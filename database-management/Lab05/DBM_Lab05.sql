USE Northwind

-- 1. Tạo các view sau:
--      uvw_DetailProductInOrder với các cột sau OrderId, OrderNumber, OrderDate, ProductId, 
--      ProductInfo (= ProductName + Package. Ví dụ: Chai 10 boxes x 20 bags), UnitPrice và
--      Quantity.
CREATE VIEW uvw_DetailProductInOrder
AS
    SELECT OJ.Id AS [OrderId], OJ.OrderNumber, OJ.OrderDate, OJ.ProductId,
            P.ProductName + SPACE(1) + P.Package AS [ProductInfo],
            OJ.UnitPrice, OJ.Quantity
    FROM (
        SELECT O.Id, O.OrderDate, O.OrderNumber, OI.ProductId, OI.UnitPrice, OI.Quantity
        FROM [Order] O
        INNER JOIN OrderItem OI ON O.Id = OI.OrderId
    ) OJ
    INNER JOIN Product P ON P.Id = OJ.ProductId
GO

SELECT * FROM uvw_DetailProductInOrder

--      uvw_AllProductInOrder với các cột sau OrderId, OrderNumber, OrderDate, ProductList
--      (ví dụ "11,42,72" với OrderId 1), và TotalAmount (=SUM(UnitPrice * Quantity)) theo
--      mỗi OrderId.
CREATE VIEW uvw_AllProductInOrder
AS
    SELECT DISTINCT V1.OrderId, V1.OrderNumber, V1.OrderDate,
            STUFF((
                SELECT ',' + CONVERT (NVARCHAR(40), V2.ProductId) AS [text()]
                FROM uvw_DetailProductInOrder V2
                WHERE V1.OrderId = V2.OrderId
                FOR XML PATH('')
            ), 1, 1, '') AS ProductList,
            SUM(V1.UnitPrice * V1.Quantity) OVER (PARTITION BY V1.OrderId) AS TotalAmount
    FROM uvw_DetailProductInOrder V1
GO

SELECT * FROM uvw_AllProductInOrder

-- 2. Dùng view “uvw_DetailProductInOrder“ truy vấn những thông tin có OrderDate trong tháng 7.
SELECT *, DATENAME(MONTH, OrderDate) AS [Month Name]
FROM uvw_DetailProductInOrder
WHERE MONTH(OrderDate) = 7

-- 3. Dùng view “uvw_AllProductInOrder” truy vấn những hóa đơn Order có ít nhất 3 product trở lên.
SELECT V1.*, V2.[Number of Order]
FROM uvw_AllProductInOrder V1
INNER JOIN (
    SELECT DISTINCT OrderId, COUNT(value) OVER (PARTITION BY OrderId) AS [Number of Order]
    FROM uvw_AllProductInOrder
        CROSS APPLY STRING_SPLIT(ProductList, ',')
) V2 ON V1.OrderId = V2.OrderId
WHERE V2.[Number of Order] >= 3

-- 4. Hai view trên đã readonly chưa? Có những cách nào làm hai view trên thành readonly?
SELECT TABLE_NAME, IS_UPDATABLE
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_NAME = 'uvw_AllProductInOrder' OR TABLE_NAME = 'uvw_DetailProductInOrder'
-- Comment --
--  + Hai view trên có một số field không là field đơn do đó giá trị biến IS_UPDATEABLE trả về NO, 
-- nhưng ta vẫn có thể UPDATE giá trị đối với các field đơn khác. Do đó hai view trên không readonly.
--  + Có nhiều cách để làm hai view trên thành readonly. Dưới đây là 2 cách ví dụ để chuyển các field 
-- đơn khác thành readonly:
-- (1) Dùng TRIGGER
CREATE TRIGGER uvw_DetailProductInOrder_Trigger_OnInsertOrUpdateOrDelete
ON uvw_DetailProductInOrder
INSTEAD OF INSERT, UPDATE, DELETE
AS
BEGIN
    RAISERROR('You are not allowed to insert, update, or delete through this view', 16, 1)
END

UPDATE uvw_DetailProductInOrder SET Quantity = 12
WHERE OrderId = 1 AND ProductId = 11

-- (2) Thêm “UNION SELECT NULL,NULL,NULL,NULL,NULL,NULL,NULL WHERE 1 = 0” vào trong view
CREATE VIEW uvw_DetailProductInOrder_B
AS
    SELECT OJ.Id AS [OrderId], OJ.OrderNumber, OJ.OrderDate, OJ.ProductId,
            P.ProductName + SPACE(1) + P.Package AS [ProductInfo],
            OJ.UnitPrice, OJ.Quantity
    FROM (
        SELECT O.Id, O.OrderDate, O.OrderNumber, OI.ProductId, OI.UnitPrice, OI.Quantity
        FROM [Order] O
        INNER JOIN OrderItem OI ON O.Id = OI.OrderId
    ) OJ
    INNER JOIN Product P ON P.Id = OJ.ProductId
    UNION
    SELECT NULL, NULL, NULL, NULL, NULL, NULL, NULL WHERE 1 = 0
GO

UPDATE uvw_DetailProductInOrder_B SET Quantity = 12
WHERE OrderId = 1 AND ProductId = 11

-- 5. Thống kê về thời gian thực thi khi gọi hai view trên. View nào chạy nhanh hơn? 
SET STATISTICS IO, TIME ON
GO

SELECT * FROM uvw_DetailProductInOrder
GO

SELECT * FROM uvw_AllProductInOrder
GO

SET STATISTICS IO, TIME OFF
GO
-- Thời gian truy vấn của VIEW `uvw_DetailProductInOrder` là 32ms và của VIEW `uvw_AllProductInOrder` là 34ms
-- Do đó VIEW `uvw_DetailProductInOrder` chạy nhanh hơn.