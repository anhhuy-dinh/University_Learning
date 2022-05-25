USE Northwind

-- 1. Theo mỗi OrderID cho biết số lượng Quantity của mỗi ProductID chiếm tỷ lệ bao nhiêu phần trăm
SELECT OrderId, ProductId, UnitPrice, Quantity,
        SUM(Quantity) OVER (PARTITION BY OrderId) AS QuantityByProduct,
        CAST(((Quantity * 1.0) / (SUM(Quantity) OVER (PARTITION BY OrderId)) * 100)
                                                AS DECIMAL(6, 2)) AS PercentByProduct
FROM [OrderItem]
ORDER BY OrderId, ProductId

-- 2. Xuất các hóa đơn kèm theo thông tin ngày trong tuần của hóa đơn là : Thứ 2, 3, 4, 5, 6, 7, Chủ Nhật
SELECT DATENAME(dw, OrderDate) AS [Day Name], *
FROM [Order]

-- 3. Với mỗi ProductID trong OrderItem xuất các thông tin gồm OrderID, ProductID, ProductName,
-- UnitPrice, Quantity, ContactInfo, ContactType. Trong đó ContactInfo ưu tiên Fax, nếu không thì
-- dùng Phone của Supplier sản phẩm đó. Còn ContactType là ghi chú đó là loại ContactInfo nào
SELECT O.OrderId, O.ProductId, P.ProductName, O.UnitPrice, O.Quantity,
        COALESCE(S.Fax, S.Phone) AS ContactInfo,
        CASE COALESCE(S.Fax, S.Phone) WHEN S.Fax THEN 'Fax' ELSE 'Phone' END AS ContactType
FROM OrderItem O
LEFT JOIN (Product P 
            LEFT JOIN Supplier S 
            ON P.SupplierId = S.Id)
ON O.ProductId = P.Id

-- 4.	Cho biết Id của database Northwind, Id của bảng Supplier, Id của User mà bạn đang đăng nhập là
-- bao nhiêu. Cho biết luôn tên User mà đang đăng nhập
SELECT DB_ID('Northwind') AS [DatabaseID]
SELECT OBJECT_ID('Supplier') AS [SupplierTableID]
SELECT USER_ID() AS [UserID],
        USER_NAME() AS [UserName]

-- 5.	Cho biết các thông tin user_update, user_seek, user_scan và user_lookup trên bảng Order trong 
-- database Northwind
SELECT [TableName] = OBJECT_NAME(object_id),
        last_user_update, last_user_seek, last_user_scan, last_user_lookup
FROM sys.dm_db_index_usage_stats
WHERE database_id = DB_ID('Northwind')
        AND OBJECT_NAME(object_id) = 'Order'

-- 6.	Dùng WITH phân chia cây như sau : Mức 0 là các Quốc Gia (Country), mức 1 là các Thành Phố 
-- (City) thuộc Country đó, và mức 2 là các Hóa Đơn (Order) thuộc khách hàng từ Country-City đó
WITH OrderCategory(Country, City, OrderNumber, alevel) AS
(
    SELECT DISTINCT Country,
            City = CAST('' AS NVARCHAR(255)),
            OrderNumber = CAST('' AS NVARCHAR(255)),
            alevel = 0
    FROM Customer
    
    UNION ALL

    SELECT C.Country,
            City = CAST(C.City AS NVARCHAR(255)),
            OrderNumber = CAST('' AS NVARCHAR(255)),
            alevel = OC.alevel + 1
    FROM OrderCategory OC
        INNER JOIN Customer C ON OC.Country = C.Country 
    WHERE OC.alevel = 0

    UNION ALL

    SELECT C.Country,
            City = CAST(C.City AS NVARCHAR(255)),
            OrderNumber = CAST(O.OrderNumber AS NVARCHAR(255)),
            alevel = OC.alevel + 1
    FROM OrderCategory OC
        INNER JOIN (Customer C JOIN [Order] O ON C.Id = O.CustomerId)
        ON OC.Country = C.Country AND OC.City = C.City
    WHERE OC.alevel = 1
)
SELECT [Quoc Gia] = CASE WHEN alevel = 0 THEN Country ELSE '--' END,
        [Thanh Pho] = CASE WHEN alevel = 1 THEN City ELSE '----' END,
        [Hoa Don] = OrderNumber,
        Cap = alevel
FROM
(
        SELECT *,
                ROW_NUMBER() OVER (PARTITION BY City ORDER BY City) as RowNumberCity,
                ROW_NUMBER() OVER (PARTITION BY OrderNumber ORDER BY OrderNumber) as RowNumberOrder
        FROM OrderCategory
) Report
WHERE RowNumberCity = 1 OR RowNumberOrder = 1
ORDER BY Country, City, OrderNumber, alevel

-- 7.	Xuất những hóa đơn từ khách hàng France mà có tổng số lượng Quantity lớn hơn 50 của các sản 
-- phẩm thuộc hóa đơn ấy 
WITH CustomerByCountry AS
(
    SELECT Id
    FROM Customer
    WHERE Country = 'France'
),
OrderByQuantity AS
(
    SELECT DISTINCT O.*, SUM(OI.Quantity) OVER (PARTITION BY OI.OrderId) AS TotalQuantity
    FROM [Order] O
        LEFT JOIN OrderItem OI ON O.Id = OI.OrderId
)
SELECT *
FROM OrderByQuantity
WHERE (CustomerId IN (SELECT * FROM CustomerByCountry))
AND (TotalQuantity > 50)