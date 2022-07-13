USE Northwind

-- 1. Viết một stored procedure với Input là một mã khách hàng CustomerId và Output là một
-- hóa đơn OrderId của khách hàng đó có Total Amount là nhỏ nhất và một hóa đơn OrderId 
-- của khách hàng đó có Total Amount là lớn nhất.
CREATE PROCEDURE usp_GetOrderID_CustomerID_MaxAndMinTotalAmount
    @CustomerId INT,
    @MaxOrderId INT OUTPUT,
    @MaxTotalAmount DECIMAL(12,2) OUTPUT,
    @MinOrderId INT OUTPUT,
    @MinTotalAmount DECIMAL(12,2) OUTPUT
AS
BEGIN
    WITH CustomerInfoMax(MaxId, MaxTotalAmount, RowNum)
    AS
    (
        SELECT Id AS MaxId, TotalAmount AS MaxTotalAmount, ROW_NUMBER() OVER (ORDER BY TotalAmount ASC) AS RowNum
        FROM [Order]
        WHERE CustomerId = @CustomerId
    ),
    CustomerInfoMin(MinId, MinTotalAmount, RowNum)
    AS
    (
        SELECT Id AS MinId, TotalAmount AS MinTotalAmount, ROW_NUMBER() OVER (ORDER BY TotalAmount DESC) AS RowNum
        FROM [Order]
        WHERE CustomerId = @CustomerId
    )
    SELECT @MaxOrderId = MA.MaxId, @MaxTotalAmount = MA.MaxTotalAmount, @MinOrderId = MI.MinId, @MinTotalAmount = MI.MinTotalAmount
    FROM CustomerInfoMax MA INNER JOIN CustomerInfoMin MI ON MA.RowNum = MI.RowNum
END

DECLARE @CustomerId INT
DECLARE @MaxOrderId INT
DECLARE @MaxTotalAmount DECIMAL(12,2)
DECLARE @MinOrderId INT
DECLARE @MinTotalAmount DECIMAL(12,2)
SET @CustomerId = 10
EXEC usp_GetOrderID_CustomerID_MaxAndMinTotalAmount @CustomerId, @MaxOrderId OUTPUT, @MaxTotalAmount OUTPUT, @MinOrderId OUTPUT, @MinTotalAmount OUTPUT
SELECT @CustomerId AS CustomerId, @MaxOrderId AS MaxOrderId, @MaxTotalAmount AS MaxTotalAmount, @MinOrderId AS MinOrderId, @MinTotalAmount AS MinTotalAmount

-- 2. Viết một stored procedure để thêm vào một Customer với Input là FirstName, LastName,
-- City, Country, và Phone. Lưu ý nếu các input mà rỗng hoặc Input đó đã có trong bảng thì 
-- báo lỗi tương ứng và ROLL BACK lại.
CREATE PROCEDURE usp_InsertNewCustomer
    @FirstName NVARCHAR(40),
    @LastName NVARCHAR(40),
    @City NVARCHAR(40),
    @Country NVARCHAR(40),
    @Phone NVARCHAR(40)
AS
BEGIN
    IF (EXISTS(SELECT * FROM Customer WHERE FirstName = @FirstName AND LastName = @LastName AND City = @City AND Country = @Country AND Phone = @Phone))
    BEGIN
        PRINT N'Khách Hàng đã tồn tại.'
        RETURN -1
    END

    IF(LEN(@FirstName) = 0 OR LEN(@LastName) = 0 OR LEN(@City) = 0 OR LEN(@Country) = 0 OR LEN(@Phone) = 0)
    BEGIN
        PRINT N'Mô tả không được trống.'
        RETURN -1
    END

    BEGIN TRY
        BEGIN TRANSACTION
            INSERT INTO [dbo].[Customer]([FirstName], [LastName], [City], [Country], [Phone])
            VALUES (@FirstName, @LastName, @City, @Country, @Phone)
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
        DECLARE @ERR NVARCHAR(MAX)
        SET @ERR = ERROR_MESSAGE()
        PRINT N'Có lỗi sau trong quá trình thêm dữ liệu vào bảng Customer'
        RAISERROR(@ERR, 16, 1)
        RETURN -1
    END CATCH
END

-- Thêm Khách Hàng đã tồn tại
DECLARE @StateInsert INT
EXEC @StateInsert = usp_InsertNewCustomer 'Maria', 'Anders', 'Berlin', 'Germany', '030-0074321'
PRINT @StateInsert

-- Thêm Khách Hàng chưa tồn tại nhưng bỏ trống Phone
DECLARE @StateInsert INT
EXEC @StateInsert = usp_InsertNewCustomer 'Paul', 'Ranger', 'New York', 'USA', ' '
PRINT @StateInsert

-- Thêm Khách Hàng mới
DECLARE @StateInsert INT
EXEC @StateInsert = usp_InsertNewCustomer 'Paul', 'Bilson', 'DC', 'USA', '(503) 555-8666'
PRINT @StateInsert

-- 3. Viết Stored Procedure cập nhật lại UnitPrice của sản phẩm trong bảng OrderItem. Khi 
-- cập nhật lại UnitPrice này thì cũng phải cập nhật lại Total Amount trong bảng Order 
-- tương ứng với Total Amount = SUM (UnitPrice *Quantity).
CREATE PROCEDURE usp_UpdateUnitPrice
    @ProductId NVARCHAR(40),
    @UnitPrice DECIMAL(12,2)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            UPDATE OI SET UnitPrice = @UnitPrice
            FROM OrderItem OI
            WHERE ProductId = @ProductId

            UPDATE O SET TotalAmount = T.TotalAmount
            FROM [Order] O INNER JOIN 
            (
                SELECT OrderId, SUM(Quantity * UnitPrice) OVER (ORDER BY OrderId) AS TotalAmount
                FROM OrderItem
                -- WHERE ProductId = @ProductId
            ) T ON O.Id = T.OrderId

            PRINT N'Cập nhật thành công UnitPrice của sản phẩm ProductId = ' + LTRIM(@ProductId)
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        PRINT 'Cập Nhât Thất Bại. Xem Chi Tiết : ';
        PRINT ERROR_MESSAGE();
        RETURN -1
    END CATCH
END

-- Kết qủa trước khi cập nhật UnitPrice của ProductId = 14
SELECT * FROM OrderItem WHERE ProductId = 14
SELECT * FROM [Order] WHERE Id IN (SELECT OrderId FROM OrderItem WHERE ProductId = 14)

-- Cập nhật UnitPrice của ProductId = 14
DECLARE @StateUpdate INT;
DECLARE @ProductId INT;
DECLARE @UnitPrice DECIMAL(12,2);
SET @ProductId = 14
SET @UnitPrice = 10.0
EXEC @StateUpdate = usp_UpdateUnitPrice @ProductId, @UnitPrice
PRINT @StateUpdate
SELECT * FROM OrderItem WHERE ProductId = @ProductId
SELECT * FROM [Order] WHERE Id IN (SELECT OrderId FROM OrderItem WHERE ProductId = @ProductId)

