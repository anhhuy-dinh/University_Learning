USE Northwind

-- 1. SỬ DỤNG STORED PROCEDURE VỚI THAM SỐ INPUT VÀ OUTPUT --
-- Viết stored procedure với input là một sản phẩm ProductId và Output là một hoá đơn OrderId mà trong hoá đơn đó sản phẩm nhập có UnitPrice lớn nhất
CREATE PROCEDURE usp_GetOrderID_ProductID_HighPrice
    @ProductId INT,
    @OrderId INT OUTPUT,
    @UnitPrice DECIMAL(12,2) OUTPUT
AS
BEGIN
    WITH ProductInfo(Id, OrderId, UnitPrice, RowNum)
    AS
    (
        SELECT Id, OrderId, UnitPrice, ROW_NUMBER() OVER (ORDER BY UnitPrice DESC) AS RowNum
        FROM OrderItem
        WHERE ProductId = @ProductId
    )
    SELECT @OrderId = OrderId, @UnitPrice = UnitPrice
    FROM ProductInfo
END

-- Chạy stored procedure này với ProductId là 11 xem kết quả hoá đơn nào mà Product 11 có UnitPrice là lớn nhất
DECLARE @ProductId INT
DECLARE @OrderId INT
DECLARE @UnitPrice DECIMAL(12,2)
SET @ProductId = 11
EXEC usp_GetOrderID_ProductID_HighPrice @ProductId, @OrderId OUTPUT, @UnitPrice OUTPUT
SELECT @ProductId AS ProductId, @OrderId AS OrderId, @UnitPrice AS UnitPrice

-- 2. SỬ DỤNG STORED PROCEDURE VỚI TRANSACTION --
-- Viết một stored procedure để thêm một product với một product mới với Input là ProductName, SupplierId, UnitPrice và Package. Lưu ý: Nếu SupplierID đó chưa tồn tại hoặc Package là trống thì báo lỗi và RollBack lại.
CREATE PROCEDURE usp_InsertNewProduct
    @ProductName NVARCHAR(50),
    @SupplierId INT,
    @UnitPrice DECIMAL(12,2),
    @Package NVARCHAR(30)
AS
BEGIN
    IF(NOT EXISTS(SELECT * FROM Supplier WHERE Id = @SupplierId))
    BEGIN
        PRINT N'Nhà Cung Cấp ' + LTRIM(STR(@SupplierId)) + N' chưa tồn tại'
        RETURN -1
    END

    IF(LEN(@Package) = 0)
    BEGIN
        PRINT N'Mô tả dạng Package của Nhà Cung Cấp ' + LTRIM(STR(@SupplierId)) + N' không được trống'
        RETURN -1
    END

    BEGIN TRY
        BEGIN TRANSACTION
            INSERT INTO [dbo].[Product]([ProductName], [SupplierId], [UnitPrice], [Package], [IsDiscontinued])
            VALUES (@ProductName, @SupplierId, @UnitPrice, @Package, 0)
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
        DECLARE @ERR NVARCHAR(MAX)
        SET @ERR = ERROR_MESSAGE()
        PRINT N'Có lỗi sau trong quá trình thêm dữ liệu vào bảng Product:'
        RAISERROR(@Err, 16, 1)
        RETURN -1
    END CATCH
END

-- Giả sử thêm sản phẩm của nhà cung cấp 100 (Chưa có nhà cung cấp này). Chương trình sẽ báo lỗi và ROLLBACK lại.
DECLARE @StateInsert INT
EXEC @StateInsert = usp_InsertNewProduct 'New My Product', 100, 10, 'boxes'
PRINT @StateInsert

-- Giả sử thêm sản phẩm nhà cung cấp 1 (Đã có nhà cung cấp này) nhưng Package lại để trống. Chương trình sẽ báo lỗi và ROLLBACK lại.
DECLARE @StateInsert INT
EXEC @StateInsert = usp_InsertNewProduct 'New My Product', 1, 10, ' '
PRINT @StateInsert

-- Thêm một sản phẩm của nhà cung cấp 1 với Package là boxes
DECLARE @StateInsert INT
EXEC @StateInsert = usp_InsertNewProduct 'New My Product', 1, 10, 'boxes'
PRINT @StateInsert