USE Northwind

-- Sắp xếp sản phẩm tăng dần theo UnitPrice, và tìm 20% dòng có UnitPrice cao nhất.
SELECT *
FROM
(
    SELECT RowNum, Id, ProductName, SupplierId, UnitPrice, Package, MAX(RowNum) OVER (ORDER BY (SELECT 1)) AS RowLast
    FROM (
        SELECT ROW_NUMBER() OVER (ORDER BY UnitPrice) AS RowNum,
                Id, ProductName, SupplierId, UnitPrice, Package
        FROM Product
    ) AS DerivedTable
) Report
WHERE Report.RowNum >= 0.2 * RowLast

-- Với mỗi hóa đơn, xuất danh sách các sản phẩm, số lượng (Quantity) và số phần trăm 
-- của sản phẩm đó trong hóa đơn.
SELECT OrderId, ProductId, ProductName, UnitPrice, Quantity, STR([Percent]*100, 5, 2) + '%' AS [Percent]
FROM
(
    SELECT O.OrderId, O.ProductId, P.ProductName, O.UnitPrice, O.Quantity,
            O.Quantity * 1.0 / (SUM(O.Quantity) OVER (PARTITION BY O.OrderId)) AS [Percent]
    FROM OrderItem O
    INNER JOIN Product P ON O.ProductId = P.Id
) Report
ORDER BY OrderId, ProductId

-- Xuất danh sách các nhà cung cấp kèm theo các cột USA, UK, France, Germany, Others. 
-- Nếu nhà cung cấp nào thuộc các quốc gia  này thì ta đánh số 1 còn lại là 0
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'SupplierByCountry')
BEGIN 
    DROP TABLE SupplierByCountry
END

SELECT Id, CompanyName, (CASE Country
            WHEN 'USA' THEN 'USA'
            WHEN 'UK' THEN 'UK'
            WHEN 'Germany' THEN 'Germany'
            WHEN 'France' THEN 'France'
            ELSE 'Others' 
            END) AS SupplierCountry
INTO SupplierByCountry
FROM Supplier GROUP BY Id, CompanyName, Country

SELECT S.Id, PivotTable.CompanyName, USA, UK, France, Germany, Others
FROM SupplierByCountry
PIVOT
(
    COUNT(Id) FOR SupplierCountry IN (USA, UK, France, Germany, Others)
) AS PivotTable
INNER JOIN Supplier S ON S.CompanyName = PivotTable.CompanyName
ORDER BY S.Id

-- Xuất danh sách các hóa đơn gồm OrderNumber, OrderDate (format: dd mm yyyy), 
-- CustomerName, Address (format: “Phone: …… , City: …. and Country: ….”), TotalAmount 
-- làm tròn không chữ số thập phân và đơn vị theo kèm là Euro.
SELECT O.OrderNumber, 
        OrderDate = CONVERT(VARCHAR(10), O.OrderDate, 103),
        CustomerName = C.FirstName + SPACE(1) + C.LastName,
        [Address] = 'Phone: ' + C.Phone + ', City: ' + C.City +' and Country: ' + C.Country,
        Amount = LTRIM(STR(CAST(O.TotalAmount AS DECIMAL(10,0)), 10, 0) + ' Euro')
FROM [Order] O
LEFT JOIN Customer C ON O.CustomerId = C.Id

-- Xuất danh sách các sản phẩm dưới dạng đóng gói bags. Thay đổi chữ bags thành ‘túi’
SELECT Id, ProductName, SupplierId, UnitPrice,
        Package = STUFF(Package, CHARINDEX('bags', Package), LEN('bags'), 'túi')
FROM Product
WHERE Package LIKE '%bags%'

-- Xuất danh sách các khách hàng theo tổng số hóa đơn mà khách hàng đó có, sắp xếp theo
-- thứ tự giảm dần của tổng số hóa đơn, kèm theo đó là các thông tin phân hạng 
-- DENSE_RANK và nhóm (chia thành 3 nhóm)
SELECT CustomerID = Report.Id,
        CustomerName = Report.FirstName + SPACE(1) + Report.LastName,
        TotalOrder = Report.TotalOrder,
        [Rank] = DENSE_RANK() OVER (ORDER BY Report.TotalOrder DESC),
        [Group] = NTILE(3) OVER (ORDER BY Report.TotalOrder DESC)
FROM
(
    SELECT C.Id, C.FirstName, C.LastName, [TotalOrder] = COUNT(OrderNumber)
    FROM Customer C
    LEFT JOIN [Order] O ON O.CustomerId = C.Id
    GROUP BY C.Id, C.FirstName, C.LastName
) Report
ORDER BY TotalOrder DESC