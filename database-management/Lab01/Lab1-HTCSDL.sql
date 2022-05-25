USE master
-- Xuất thông báo có Database Northwind hay khong --
IF db_id('Northwind') IS NOT NULL
BEGIN
    SELECT 'database does exist'
END
ELSE
BEGIN
    SELECT 'database does not exist'
END

USE Northwind

-- Truy vấn dữ liệu bảng Supplier --
SELECT * FROM Supplier

-- Truy vấn dữ liệu Supplier với các thông tin cụ thể : Id, First Name, Last Name, CompanyName, City, Country
-- (Dùng CHARINDEX để kiếm vị trí ‘ ‘ ; dùng LEFT để lấy chuỗi con từ trái qua ; dùng SUBSTRING để lấy chuỗi con từ vị trí index n to m) --
-- Truy vấn dữ liệu chi tiết Supplier --
SELECT Id,
        LEFT(ContactName, CHARINDEX(' ', ContactName)-1) AS 'FirstName',
        SUBSTRING(ContactName, CHARINDEX(' ', ContactName)+1, 100) AS 'LastName',
        City, Country
FROM Supplier

-- Cũng truy vấn trên ta sắp xếp lại quy tắc hiển thị theo thứ tự tăng dần của FirstName và giảm dần của City -- 
-- Truy vấn dữ liệu chi tiết Supplier co sắp xếp --
SELECT Id,
        LEFT(ContactName, CHARINDEX(' ', ContactName)-1) AS 'FirstName',
        SUBSTRING(ContactName, CHARINDEX(' ', ContactName)+1, 100) AS 'LastName',
        City, Country
FROM Supplier
ORDER BY FirstName ASC, City DESC

-- Truy vấn cho biết có bao nhiêu Country của nhà cung cấp và đó là những Country nào --
-- Truy vấn Country --
SELECT DISTINCT Country
FROM Supplier

SELECT COUNT(DISTINCT Country)
FROM Supplier

-- Truy vấn danh sách các nhà cung cấp với ID là 3,5, từ 1-5, và từ 3-5 --
-- (Lưu ý để dùng OFFSET bắt buộc phải có ORDER BY) --

-- Truy vấn Supplier theo Id --
SELECT *
FROM Supplier
WHERE Id = 3 OR Id = 5

SELECT TOP 5 *
FROM Supplier

SELECT *
FROM Supplier
ORDER BY Id
OFFSET 2 ROWS
FETCH NEXT 3 ROWS ONLY

-- Truy vấn các Supplier mà ở Country USA hay UK ngoại trừ thành phố London và phải có số Fax --
-- Truy vấn kết hợp --
SELECT *
FROM Supplier
WHERE Country in ('USA', 'UK') AND NOT City = 'London' AND Fax IS NOT NULL

-- Truy vấn các sản phẩm mà đóng gói (Package) dưới dạng 'boxes' mà có giá trị từ 10 đến 20 --
SELECT *
FROM Product
WHERE Package LIKE '%boxes%' AND UnitPrice BETWEEN 10 AND 20