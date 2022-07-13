USE Northwind

-- * Sử dụng Scalar-valued Function * --
-- Viết hàm truyền vào một CustomerId và xuất ra tổng số lượng hoá đơn của khách hàng đó
CREATE FUNCTION ufn_NumOfOrderByCustID(@CustomerId INT = 0)
RETURNS INT
AS
BEGIN
    DECLARE @TotalOrders INT

    SELECT @TotalOrders = COUNT(*)
    FROM [Order]
    WHERE CustomerId = @CustomerID

    RETURN @TotalOrders
END

-- Sau đó sử dụng hàm này để xuất số lượng hoá đơn của tất cả các khách hàng
SELECT *, dbo.ufn_NumOfOrderByCustID(Id) AS 'Number Of Orders'
FROM Customer

-- * Sử dụng table-valued Function dạng inline-statement * --
-- Viết hàm truyền vào loại package hàng hoá và xuất ra danh sách các hàng hoá thuộc loại đó
CREATE FUNCTION ufn_ProductListByDesc(@Descr NVARCHAR(20))
RETURNS TABLE
AS
RETURN (
    SELECT *
    FROM Product
    WHERE LOWER(Package) LIKE '%' + LTRIM(RTRIM(LOWER(@Descr))) + '%'
)

-- Gọi hàm để xuất danh sách các hàng hoá loại Package là 'bottles'
SELECT * FROM dbo.ufn_ProductListByDesc('bottles')

-- * Sử dụng table-valued Function dạng multi-statement * --
-- Viết hàm truyền vào một danh sách các nước và xuất ra thông tin các khách hàng thuộc danh sách các nước đó
CREATE FUNCTION ufn_CustomerListByCountryFilter(@CountryFilter NVARCHAR(MAX))
RETURNS @ResultTable TABLE (Id INT, FirstName NVARCHAR(MAX), LastName NVARCHAR(MAX), Country NVARCHAR(MAX), Phone NVARCHAR(MAX))
AS
BEGIN
    SET @CountryFilter = LOWER(@CountryFilter);

    INSERT INTO @ResultTable
    SELECT Id, FirstName, LastName, Country, Phone
    FROM Customer
    WHERE CHARINDEX(LTRIM(RTRIM(LOWER(Country))), @CountryFilter) > 0

    RETURN
END

-- Gọi hàm xuất danh sách các khách hàng đến từ các nước Germany, Sweden, USA và UK
SELECT * FROM ufn_CustomerListByCountryFilter('Germany, Sweden, USA, UK');

-- thử viết lại hàm có cùng chức năng trên nhưng là inline-statement
CREATE FUNCTION ufn_CustomerListByCountryFilter2(@CountryFilter NVARCHAR(MAX))
RETURNS TABLE
AS
RETURN (
    SELECT *
    FROM Customer
    WHERE CHARINDEX(LTRIM(RTRIM(LOWER(Country))), LOWER(@CountryFilter)) > 0
)

-- Gọi STATISTICS TIME để kiểm tra thời gian thực thi giữa hai hàm
SET STATISTICS TIME ON
SELECT * FROM ufn_CustomerListByCountryFilter('Germany, Sweden, USA, UK');
SELECT * FROM ufn_CustomerListByCountryFilter2('Germany, Sweden, USA, UK');
SET STATISTICS TIME OFF

-- * Sử dụng Function để giám sát/kiểm tra dữ liệu thêm vào bảng * --
-- Viết một hàm kiểm tra dữ liệu đưa vào bảng Product. Trong bảng Product có cột SupplierId.
-- Nếu dữ liệu đưa vào thì phải đảm bảo SupplierId đó phải tồn tại trong bảng Supplier
CREATE FUNCTION ufn_CheckSupplierExistence(@SupplierId INT)
RETURNS BIT
AS
    BEGIN
        DECLARE @Existence BIT;
        IF (EXISTS(SELECT * FROM Supplier WHERE Id = @SupplierId))
            SET @Existence = 1;
        ELSE
            SET @Existence = 0;

        RETURN @Existence;
    END
GO

ALTER TABLE Product
ADD CONSTRAINT CheckProductExistence
    CHECK (dbo.ufn_CheckSupplierExistence(SupplierId) = 1)

-- Giả sử thêm vào bảng Product có SupplierId là 100 (chưa tồn tại) thì hàm CheckSupplierExistence sẽ kiểm tra.
-- Nếu SupplierId chưa có thì sẽ không có insert
INSERT INTO Product VALUES('New Product 1', 100, 10, 'kgs', 0);