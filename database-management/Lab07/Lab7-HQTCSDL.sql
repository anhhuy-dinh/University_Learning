USE Northwind

-- SỬ DỤNG TRIGGER --
-- 1. Tạo một Trigger để kiểm tra việc khi xoá một Customer thì thông tin Order của Customer đó sẽ chuyển về cho CustomerId là 1
CREATE TRIGGER  [dbo].[Trigger_CustomerDelete]
ON [dbo].[Customer]
FOR DELETE
AS

DECLARE @DeletedCustomerID INT
SELECT @DeletedCustomerID = Id FROM deleted

UPDATE [Order] SET CustomerId = 1
WHERE CustomerId = @DeletedCustomerID

PRINT 'Cac hoa don cua khach hang CustomerId = ' + LTRIM(STR(@DeletedCustomerID)) + ' da chuyen qua cho CustomerID = 1';

-- Kiểm tra khách hàng 79 có những hoá đơn nào
SELECT * FROM [Order] WHERE CustomerId = 79

-- Viết lại câu truy vấn khách hàng 79 thông qua OrderId
SELECT * FROM [Order] WHERE Id IN (2, 191, 199, 301, 361, 720)

-- Xoá bỏ Foreign Key Constraint để kiểm nghiệm trigger. Nếu không xoá thì constraint này sẽ thực thi trước trigger và không cho phép bạn xoá bất kỳ CustomerId nào
ALTER TABLE [Order] DROP CONSTRAINT FK_ORDER_REFERENCE_CUSTOMER

-- Thực hiện lệnh xoá bỏ Customer thứ 79
DELETE FROM Customer WHERE Id = 79

-- Truy vấn để kiểm tra các hoá đơn của Customer 79 ta sẽ thấy trigger đã tự động chuyển sang cho CustomerId là 1
SELECT * FROM [Order] WHERE Id IN (2, 191, 199, 301, 361, 720)


-- 2. Tạo một trigger khi xoá CustomerId 1 thì sẽ không cho xoá và báo lỗi : "Đây là khách hàng không được xoá" sau đó ROLL BACK lại hành động xoá
CREATE TRIGGER [dbo].[Trigger_CustomerID1Delete]
ON [dbo].[Customer]
FOR DELETE
AS
    DECLARE @DeletedCustomerID INT
    SELECT @DeletedCustomerID = Id FROM deleted

    IF (@DeletedCustomerID = 1)
    BEGIN
        RAISERROR ('CustomerID = 1 khong the xoa duoc', -- message text
                    16, -- severity 16 for user-defined
                    1 -- state
                );
        ROLLBACK TRANSACTION
    END

-- Hiện bảng Customer có hai Trigger là "Trigger_CustomerDelete" và Trigger "Trigger_CustomerID1Delete". Theo quy tắc trigger nào tạo trước sẽ thực hiện trước.
-- Tuy nhiên ta sẽ ưu tiên Trigger "Trigger_CustomerID1Delete" thực hiện trước bằng cách
EXEC sp_settriggerorder @triggername = 'Trigger_CustomerID1Delete', @order='First', @stmtype='DELETE'

-- Bây giờ ta thử xoá dữ liệu của CustomerId là 1 xem sao. Chương trình sẽ báo lỗi và không cho xoá. Do trigger mà ta tạo đảm bảo điều đó.
DELETE FROM Customer WHERE Id = 1;

-- 3. Viết một trigger không được phép cập nhật UnitPrice của Product nhỏ hơn hoặc bằng 0
-- Nếu cập nhật thì sẽ báo lỗi và ROLL BACK lại
CREATE TRIGGER [dbo].[Trigger_ProductUpdate]
ON [dbo].[Product]
FOR UPDATE
AS
    DECLARE @UpdateUnitPrice DECIMAL(12,2)
    IF UPDATE(UnitPrice)
    BEGIN
        SELECT @UpdateUnitPrice = UnitPrice FROM inserted
        IF @UpdateUnitPrice <= 0
        BEGIN
            RAISERROR ('UnitPrice phai la so duong', -- message text
                        16, -- severity 16 for user-defined
                        1 -- state
                        );
            ROLLBACK TRANSACTION
        END
    END

-- Bây giờ thử cập nhật UnitPrice của sản phẩm có Id là 1 về 0. Trigger sẽ báo lỗi và không cho cập nhật vậy.
UPDATE Product SET UnitPrice = 0 WHERE Id = 1

-- SỬ DỤNG CURSOR --
-- 1. Viết một Function với input là tiêu chuẩn dạng Package và sau đó dựa trên tiêu chuẩn này xuất ra danh sách các Id và ProductName như sau
-- (INPUT: 'boxes'
--  OUTPUT: boxes list is 1: Chai, 5: Chef Anton's Gumbo Mix ...)
CREATE FUNCTION dbo.ufn_ListProductByPackage (@PackageDescr NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @ProductList NVARCHAR(MAX) = @PackageDescr + ' list is ';
    DECLARE @Id INT;
    DECLARE @ProductName NVARCHAR(MAX);

    DECLARE ProductCursor CURSOR READ_ONLY
    FOR
    SELECT Id, ProductName
    FROM Product
    WHERE LOWER(Package) LIKE '%' + LTRIM(RTRIM(LOWER(@PackageDescr))) + '%'

    OPEN ProductCursor

    FETCH NEXT FROM ProductCursor INTO @Id, @ProductName

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @ProductList = @ProductList + LTRIM(STR(@Id)) + ':' + @ProductName + ' ; ';
        FETCH NEXT FROM ProductCursor INTO @Id, @ProductName
    END

    CLOSE ProductCursor
    DEALLOCATE ProductCursor

    RETURN @ProductList
END

-- Bây giờ gọi thử Function này với INPUT là boxes
SELECT dbo.ufn_ListProductByPackage('boxes')

-- SỬ DỤNG TRANSACTION --
-- Viết một giao dịch cập nhật UnitPrice của tất cả các sản phẩm có xuất sứ từ USA 
-- bằng cách input vào một cơ số @DFactor và tính UnitPrice mới theo công thức 
-- UnitPrice = UnitPrice / @DFactor. Sau đó cho biết có bao nhiêu sản phẩm đã được 
-- cập nhật UnitPrice. Dùng TRANSACTION trong trường hợp này để kiểm soát lỗi có 
-- thể xảy ra trong quá trình cập nhật và ROLL BACK khi cần.
BEGIN TRY
    BEGIN TRANSACTION UpdatePriceTrans

        SET NOCOUNT ON;

        DECLARE @NumOfUpdateRecords INT = 0;
        DECLARE @DFactor INt;
        SET @DFactor = 0;

        UPDATE P SET UnitPrice = UnitPrice / @DFactor
        FROM Product P
        INNER JOIN Supplier S ON P.SupplierId = S.Id
        WHERE S.Country LIKE '%USA%'

        SET @NumOfUpdateRecords = @@ROWCOUNT
        PRINT 'Cap Nhat Thanh Cong ' + LTRIM(STR(@NumOfUpdateRecords)) + ' dong trong bang Product';

    COMMIT TRANSACTION UpdatePriceTrans
END TRY
BEGIN CATCH
    ROLLBACK TRAN UpdatePriceTrans
    PRINT 'Cap Nhat That Bai. Xem Chi Tiet : ';
    PRINT ERROR_MESSAGE();
END CATCH

-- SỬ DỤNG BẢNG TẠM --
-- Ta viết một ví dụ TRANSACTION với input vào là hai tháng bất kỳ của một năm sau 
-- đó cho biết tháng nào có nhiều khách hàng đặt hóa đơn hơn. Hai bảng tạm ta dùng 
-- là #OrderInfo1 và @OrderInfo2. #OrderInfo1 là bảng vật lý được tạo ra sẽ nằm trong 
-- Table của database TempDB. Do đó dùng xong ta phải DROP TABLE. Còn @OrderInfo2 
-- là một biến dạng bảng. Biến này sẽ tự động xóa khi kết thúc thực thi script. 
BEGIN TRY
BEGIN TRANSACTION CompareTwoMonthTrans

    SET NOCOUNT ON;
    DECLARE @Month1 INT
    DECLARE @Month2 INT
    DECLARE @Year INT

    SET @Month1 = 7;
    SET @Month2 = 8;
    SET @Year = 2012;

    CREATE TABLE #OrderInfo1 -- create a physical table
    (
        OrderDate DATETIME,
        OrderNumber NVARCHAR(10),
        CustomerId INT
    )

    DECLARE @OrderInfo2 TABLE -- Create a table variable
    (
        OrderDate DATETIME,
        OrderNumber NVARCHAR(10),
        CustomerId INT
    )

    INSERT INTO  #OrderInfo1
    SELECT OrderDate, OrderNumber, CustomerId
    FROM [Order]
    WHERE MONTH(OrderDate) = @Month1 AND YEAR(OrderDate) = @Year;

    INSERT INTO @OrderInfo2
    SELECT OrderDate, OrderNumber, CustomerId
    FROM [Order]
    WHERE MONTH(OrderDate) = @Month2 AND YEAR(OrderDate) = @Year

    DECLARE @NumCustomer1 INT
    SET @NumCustomer1 = (SELECT COUNT(DISTINCT CustomerId) FROM #OrderInfo1)
    DECLARE @NumCustomer2 INT
    SET @NumCustomer2 = (SELECT COUNT(DISTINCT CustomerId) FROM @OrderInfo2)

    PRINT 'Trong Nam: ' + LTRIM(STR(@Year))
    PRINT 'Trong Thang ' + LTRIM(STR(@Month1)) + ' : ' + LTRIM(STR(@NumCustomer1)) + 'khach hang dat hoa don'
    PRINT 'Trong Thang ' + LTRIM(STR(@Month2)) + ' : ' + LTRIM(STR(@NumCustomer2)) + 'khach hang dat hoa don'

    PRINT
    CASE
        WHEN @NumCustomer1 = @NumCustomer2
            THEN 'So Luong Khach Hang Cua Thang ' + LTRIM(STR(@Month1)) + ' Bang Thang ' + LTRIM(STR(@Month2))
        WHEN @NumCustomer1 > @NumCustomer2
            THEN 'So Luong Khach Hang Cua Thang ' + LTRIM(STR(@Month1)) + ' Nhieu Hon Thang ' + LTRIM(STR(@Month2))
        ELSE 'So Luong Khach Hang Cua Thang ' + LTRIM(STR(@Month1)) + ' Nho Hon Thang ' + LTRIM(STR(@Month2))
    END

    DROP TABLE #OrderInfo1 -- Must drop the physical table

COMMIT TRANSACTION CompareTwoMonthTrans
END TRY
BEGIN CATCH
    ROLLBACK TRAN CompareTwoMonthTrans
    PRINT 'Co loi xay ra. Xem chi tiet : ';
    PRINT ERROR_MESSAGE();
END CATCH