USE Northwind

-- Tạo View xuất danh sách các hoá đơn kèm theo thông tin FullName, City và Country
CREATE VIEW uvw_DetailCustomerInOrder_A
AS
    SELECT O.OrderDate, O.OrderNumber, O.CustomerId, C.FirstName + SPACE(1) + C.LastName AS [FullName],
            C.City, C.Country, O.TotalAmount
    FROM [Order] O
    INNER JOIN Customer C ON O.CustomerId = C.Id
GO

-- Xuất danh sách các hoá đơn đến từ khách hàng France
SELECT * FROM uvw_DetailCustomerInOrder_A WHERE Country = 'France'

UPDATE uvw_DetailCustomerInOrder_A SET TotalAmount = 10
WHERE Country = 'France' AND CustomerId = 85

SELECT * FROM uvw_DetailCustomerInOrder_A
WHERE Country = 'France' AND CustomerId = 85

-- Bây giờ ta thử cập nhật FullName của khách hàng thông qua view “uvw_DetailCustomerInOrder_A”. 
UPDATE uvw_DetailCustomerInOrder_A SET FullName = 'ABC'
WHERE Country = 'France' AND CustomerId = 85
-- SQL sẽ báo lỗi không cập nhật được FullName vì FullName không là field đơn trong bảng 
-- Customer mà là field truy xuất từ FirstName + LastName nên không thực hiện được.

CREATE TRIGGER uvw_DetailCustomerInOrder_A_Trigger_OnInsertOrUpdateOrDelete
ON uvw_DetailCustomerInOrder_A
INSTEAD OF INSERT, UPDATE, DELETE
AS
BEGIN
    RAISERROR('You are not allowed to insert, update, or delete through this view', 16, 1)
END

UPDATE uvw_DetailCustomerInOrder_A SET TotalAmount = 10
WHERE Country = 'France' AND CustomerId = 85

CREATE VIEW uvw_DetailCustomerInOrder_B
AS
    SELECT O.OrderDate, O.OrderNumber, O.CustomerId, C.FirstName + SPACE(1) + C.LastName AS [FullName],
            C.City, C.Country, O.TotalAmount
    FROM [Order] O
    INNER JOIN Customer C ON O.CustomerId = C.Id
    UNION
    SELECT NULL, NULL, NULL, NULL, NULL, NULL, NULL WHERE 1 = 0
GO

UPDATE uvw_DetailCustomerInOrder_B SET TotalAmount = 10
WHERE Country = 'France' AND CustomerId = 85

CREATE VIEW uvw_DetailCustomerInOrder_C
AS
    WITH TotalAmountFromOrderItem (OrderId, TotalAmount)
    AS
    (
        SELECT OrderId, SUM(UnitPrice*Quantity) AS TotalAmount
        FROM OrderItem
        GROUP BY OrderId
    )
    SELECT O.OrderDate, O.OrderNumber, O.CustomerId, C.FirstName + SPACE(1) + C.LastName AS [FullName],
            C.City, C.Country, O.TotalAmount
    FROM [Order] O
    INNER JOIN Customer C ON O.CustomerId = C.Id
    INNER JOIN TotalAmountFromOrderItem T ON O.Id = t.OrderId
    WHERE O.TotalAmount = T.TotalAmount
    WITH CHECK OPTION;
GO

UPDATE uvw_DetailCustomerInOrder_C SET TotalAmount = 10
WHERE Country = 'Germany' AND CustomerId = 79

EXEC sp_helptext uvw_DetailCustomerInOrder_A

PRINT OBJECT_DEFINITION(OBJECT_ID('uvw_DetailCustomerInOrder_A'));

CREATE VIEW uvw_DetailCustomerInOrder_D WITH ENCRYPTION
AS
    WITH TotalAmountFromOrderItem (OrderId, TotalAmount)
    AS
    (
        SELECT OrderId, SUM(UnitPrice*Quantity) AS TotalAmount
        FROM OrderItem
        GROUP BY OrderId
    )
    SELECT O.OrderDate, O.OrderNumber, O.CustomerId, C.FirstName + SPACE(1) + C.LastName AS [FullName],
            C.City, C.Country, O.TotalAmount
    FROM [Order] O
    INNER JOIN Customer C ON O.CustomerId = C.Id
    INNER JOIN TotalAmountFromOrderItem T ON O.Id = t.OrderId
    WHERE O.TotalAmount = T.TotalAmount
    WITH CHECK OPTION;
GO 

EXEC sp_helptext uvw_DetailCustomerInOrder_D

PRINT OBJECT_DEFINITION(OBJECT_ID('uvw_DetailCustomerInOrder_D'));

SET STATISTICS IO, TIME ON
GO

SELECT * FROM uvw_DetailCustomerInOrder_D
WHERE Country IN ('Germany', 'France', 'Mexico')
GO

WITH TotalAmountFromOrderItem (OrderId, TotalAmount)
AS
(
    SELECT OrderId, SUM(UnitPrice*Quantity) AS TotalAmount
    FROM OrderItem
    GROUP BY OrderId
)
SELECT O.OrderDate, O.OrderNumber, O.CustomerId, C.FirstName + SPACE(1) + C.LastName AS [FullName],
        C.City, C.Country, O.TotalAmount
FROM [Order] O
INNER JOIN Customer C ON O.CustomerId = C.Id
INNER JOIN TotalAmountFromOrderItem T ON O.Id = T.OrderId
WHERE O.TotalAmount = T.TotalAmount AND C.Country IN ('Germany', 'France', 'Mexico')
GO

SET STATISTICS IO, TIME OFF
GO

-- Tạo Schema MySchema gồm 3 bảng ThongTinKhachHang, ThongTinNhaCungCap và ThongTinHoaDon
CREATE SCHEMA MySchema
    CREATE TABLE DetailCustomer (Id int, FullName NVARCHAR(40), City NVARCHAR(40), Country NVARCHAR(40))
    CREATE TABLE DetailSupplier (Id int, CompanyName NVARCHAR(40), City NVARCHAR(40), Country NVARCHAR(40), ContactInfo NVARCHAR(40))
    CREATE TABLE DetailOrder (Id int, OrderDate datetime, OrderNumber NVARCHAR(40), CustomerId int, TotalAmount decimal(12,2));
GO

-- Truy vấn và insert dữ liệu vào từng bảng
INSERT INTO MySchema.DetailCustomer
SELECT Id, FirstName + SPACE(1) + LastName AS [FullName], City, Country
FROM Customer

INSERT INTO MySchema.DetailSupplier
SELECT Id, CompanyName, City, Country, ISNULL(Fax, Phone) AS [ContactInfo]
FROM Supplier

INSERT INTO MySchema.DetailOrder
SELECT Id, OrderDate, OrderNumber, CustomerId, TotalAmount
FROM [Order]

CREATE VIEW uvw_Order_Customer WITH SCHEMABINDING AS
    SELECT O.OrderDate, O.OrderNumber, O.CustomerId, C.FullName, C.City, C.Country, O.TotalAmount
    FROM MySchema.DetailOrder O
    INNER JOIN MySchema.DetailCustomer C ON O.CustomerId = C.Id
GO

CREATE VIEW uvw_Supplier AS
    SELECT *
    FROM MySchema.DetailSupplier S
    WHERE Country = 'USA'
GO

ALTER TABLE MySchema.DetailOrder ALTER COLUMN TotalAmount float

ALTER TABLE MySchema.DetailSupplier ALTER COLUMN Country NVARCHAR(20)