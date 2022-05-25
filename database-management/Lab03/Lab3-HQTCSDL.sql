USE Northwind

-- Sắp xếp OrderItem tăng dần theo Quantity và tìm 10% dòng có quantity cao nhất
SELECT *
FROM
(
    SELECT RowNum, Id, OrderId, ProductId, Quantity, MAX(RowNum) OVER (ORDER BY (SELECT 1)) AS RowLast
    FROM (
        SELECT ROW_NUMBER() OVER (ORDER BY Quantity) AS RowNum,
                Id, OrderId, ProductId, Quantity
        FROM OrderItem
    ) AS DerivedTable
) Report
WHERE Report.RowNum >= 0.1 * RowLast

-- Xuất danh sách các hoá đơn (OrderNumber, OrderDate, CustomerId, TotalAmount)
-- kèm thêm thông tin hoá đơn đó có tổng số lượng mua chiếm bao nhiêu phần trăm của một khách hàng

SELECT OrderNumber, OrderDate, CustomerId, TotalAmount, STR([Percent]*100, 5, 2) + '%' AS [Percent]
FROM
(
    SELECT OrderNumber, OrderDate, CustomerId, TotalAmount, TotalAmount / (SUM(TotalAmount) OVER (PARTITION BY CustomerId)) AS [Percent]
    FROM [Order]
) Report
ORDER BY CustomerId, OrderDate

-- Với mỗi sản phẩm có trong hoá đơn, xuất thông tin 3 hoá đơn có số lượng đặt sản phẩm lớn nhất
SELECT Report.*
FROM
(
    SELECT P.Id, P.ProductName, O.Quantity,
            ROW_NUMBER() OVER (PARTITION BY O.ProductId ORDER BY O.Quantity DESC) AS RowNum
    FROM OrderItem O
    INNER JOIN Product P ON O.ProductId = P.Id
) Report
WHERE Report.RowNum <= 3
ORDER BY Report.Id

-- Xuất thông tin khách hàng và thông tin số lượng hoá đơn trong các tháng từ 1 đến 12 theo hàng ngang
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'OrderByMonth')
BEGIN
    DROP TABLE OrderByMonth
END

SELECT CustomerId, MONTH(OrderDate) AS MonthOrder, COUNT(OrderNumber) AS OrderCount INTO OrderByMonth
FROM [Order] GROUP BY CustomerId, MONTH(OrderDate)

SELECT * FROM OrderByMonth

SELECT CustomerByMonth.CustomerId, C.FirstName + ' ' + C.LastName AS [CustomerName],
        ISNULL(CustomerByMonth.[1], 0) AS [Order in T1],
        ISNULL(CustomerByMonth.[2], 0) AS [Order in T2],
        ISNULL(CustomerByMonth.[3], 0) AS [Order in T3],
        ISNULL(CustomerByMonth.[4], 0) AS [Order in T4],
        ISNULL(CustomerByMonth.[5], 0) AS [Order in T5],
        ISNULL(CustomerByMonth.[6], 0) AS [Order in T6],
        ISNULL(CustomerByMonth.[7], 0) AS [Order in T7],
        ISNULL(CustomerByMonth.[8], 0) AS [Order in T8],
        ISNULL(CustomerByMonth.[9], 0) AS [Order in T9],
        ISNULL(CustomerByMonth.[10], 0) AS [Order in T10],
        ISNULL(CustomerByMonth.[11], 0) AS [Order in T11],
        ISNULL(CustomerByMonth.[12], 0) AS [Order in T12]
FROM
(
    SELECT * FROM OrderByMonth
    PIVOT (SUM(OrderCount) FOR MonthOrder IN ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])) AS PivoteOrder
) CustomerByMonth
INNER JOIN Customer C ON CustomerByMonth.CustomerId = C.Id

-- Xuất thông tin hoá đơn với thêm cột ghi tên tháng
SELECT Id, OrderNumber, OrderDate,
        (CASE MONTH(OrderDate)
            WHEN 1 THEN 'Month 1'
            WHEN 2 THEN 'Month 2'
            WHEN 3 THEN 'Month 3'
            WHEN 4 THEN 'Month 4'
            WHEN 5 THEN 'Month 5'
            WHEN 6 THEN 'Month 6'
            WHEN 7 THEN 'Month 7'
            WHEN 8 THEN 'Month 8'
            WHEN 9 THEN 'Month 9'
            WHEN 10 THEN 'Month 10'
            WHEN 11 THEN 'Month 11'
            ELSE 'Month 12'
        END) AS OrderMonth
FROM [Order]

-- Xuat thong tin hoá đơn với thêm cột ghi tên quý
SELECT Id, OrderNumber, OrderDate,
    (CASE
        WHEN MONTH(OrderDate) < 4 THEN 'Period 1'
        WHEN MONTH(OrderDate) < 7 THEN 'Period 2'
        WHEN MONTH(OrderDate) < 10 THEN 'Period 3'
        ELSE 'Period 4'
    END) AS OrderPeriod
FROM [Order]

-- Xuất danh sách các hoá đơn gồm Id, OrderNumber, OrderDate (dd/mm/yyy), Customer: FullName, Amount
-- trong đó Amount là TotalAmount làm tròn thành 1 chữ số thập phân kèm theo đơn vị tính là $
SELECT O.Id, O.OrderNumber,
        OrderDate = CONVERT(VARCHAR(10), O.OrderDate, 103),
        CustomerName = 'Customer' + SPACE(1) + ':' + C.FirstName + SPACE(1) + C.LastName,
        Amount = LTRIM(STR(CAST(O.TotalAmount AS DECIMAL(10, 1)), 10, 1) + '$')
FROM [Order] O
INNER JOIN Customer C ON O.CustomerId = C.Id

-- Xuất danh sách các sản phẩm dưới dạng đóng gói bottles. Thay đổi chữ bottles thành 'chai'
SELECT Id, ProductName, SupplierId, UnitPrice,
        Package = STUFF(Package, CHARINDEX('bottles', Package), LEN('bottles'), 'chai')
FROM Product
WHERE Package LIKE '%bottles%'

-- Hay xep hạng sản phẩm theo UnitPrice tăng dần,
-- hạng xếp phải có thứ tự tăng đều và các sản phẩm cùng UnitPrice thì cùng hạng
SELECT Id, ProductName, UnitPrice,
        [Rank] = DENSE_RANK() OVER (ORDER BY UnitPrice)
FROM Product

-- Xuất danh sách các khách hàng và tổng số Total Amount của khách hàng đó có trong các hoá đơn
-- chia nhóm các khách hàng theo 3 nhóm dựa trên tổng số Total Amount này.
SELECT CustomerID = Report.Id,
        CustomerName = Report.FirstName + SPACE(1) + Report.LastName,
        OverallAmount = Report.OverallAmount,
        [Group] = NTILE(3) OVER (ORDER BY Report.OverallAmount DESC)
FROM
(
    SELECT C.Id, C.FirstName, C.LastName, [OverallAmount] = SUM(ISNULL(TotalAmount, 0))
    FROM Customer C
        LEFT JOIN [Order] O ON C.Id = O.CustomerId
    GROUP BY C.Id, C.FirstName, C.LastName
) Report