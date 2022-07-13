USE Northwind

-- 1. Viết hàm truyền vào một CustomerId và xuất ra tổng giá tiền (Total Amount) của các hoá đơn từ
-- khách hàng đó. Sau đó dùng hàm này xuất ra tổng giá tiền từ các hoá đơn của tất cả khách hàng.
CREATE FUNCTION ufn_TotalAmountByCustomerID(@CustomerID INT = 0)
RETURNS INT
AS
BEGIN
    DECLARE @Total_Amount INT

    SELECT @Total_Amount = SUM(TotalAmount) OVER (PARTITION BY CustomerId)
    FROM [Order]
    WHERE CustomerId = @CustomerID

    RETURN @Total_Amount
END

SELECT *, dbo.ufn_TotalAmountByCustomerID(Id) AS 'Total Amount'
FROM Customer

-- 2. Viết hàm truyền vào hai số và xuất ra danh sách các sản phẩm có UnitPrice nằm trong khoảng số đó.
CREATE FUNCTION ufn_UnitPriceInRange(@Start INT = 0, @End INT = 1)
RETURNS @ResultTable TABLE (Id INT, ProductName NVARCHAR(50), SupplierId INT, UnitPrice DECIMAL(12,2), Package NVARCHAR(30), isDiscontinued BIT)
AS
BEGIN
    INSERT INTO @ResultTable
    SELECT *
    FROM Product
    WHERE (UnitPrice >= @Start) AND (UnitPrice <= @End)

    RETURN
END

SELECT * FROM ufn_UnitPriceInRange(20, 30)

-- 3. Viết hàm truyền vào một danh sách các tháng 'June; July; August; September' và xuất ra thông tin
-- của các hoá đơn có trong những tháng đó. Viết cả hai hàm dưới dạng inline và multi statement sau đó
-- cho biết thời gian thực thi của mỗi hàm, so sánh và đánh giá.
CREATE FUNCTION ufn_OrderByMonth(@MonthFilter NVARCHAR(MAX))
RETURNS @ResultTable TABLE (Id INT, OrderDate DATETIME, OrderNumber NVARCHAR(MAX), CustomerId INT, 
                            TotalAmount DECIMAL(12,2))
AS
BEGIN
    SET @MonthFilter = LOWER(@MonthFilter);

    INSERT INTO @ResultTable
    SELECT *
    FROM [Order]
    WHERE CHARINDEX(LTRIM(RTRIM(LOWER(DATENAME(MONTH, OrderDate)))), @MonthFilter) > 0

    RETURN
END

CREATE FUNCTION ufn_OrderByMonth2(@MonthFilter NVARCHAR(MAX))
RETURNS TABLE
AS
RETURN (
    SELECT *
    FROM [Order]
    WHERE CHARINDEX(LTRIM(RTRIM(LOWER(DATENAME(MONTH, OrderDate)))), LOWER(@MonthFilter)) > 0
)

SET STATISTICS TIME ON

SELECT *, DATENAME(MONTH, OrderDate) AS OrderMonth
FROM ufn_OrderByMonth('June; July; August; September');

SELECT *, DATENAME(MONTH, OrderDate) AS OrderMonth
FROM ufn_OrderByMonth2('June; July; August; September');

SET STATISTICS TIME OFF

-- 4. Viết hàm kiểm tra mỗi hoá đơn không có quá 5 sản phẩm (kiểm tra trong bảng OrderItem). Nếu
-- insert quá 5 sản phẩm cho một hoá đơn thì báo lỗi và không cho insert.
CREATE FUNCTION ufn_CheckOverloadQuantity(@OrderID INT)
RETURNS BIT
AS
    BEGIN
        DECLARE @Overload BIT;
        IF ((SELECT DISTINCT COUNT(ProductId) OVER (PARTITION BY OrderId) FROM OrderItem WHERE OrderId = @OrderID) > 5)
            SET @Overload = 1;
        ELSE
            SET @Overload = 0;

        RETURN @Overload;
    END
GO

ALTER TABLE OrderItem
ADD CONSTRAINT CheckOverload
    CHECK (dbo.ufn_CheckOverloadQuantity(OrderId) = 1);
    
SELECT DISTINCT OrderId, COUNT(ProductId) AS [Number of Products]
FROM OrderItem
GROUP BY OrderId
HAVING COUNT(ProductId) = 5

INSERT INTO OrderItem VALUES(47, 14, 18.60, 13);
