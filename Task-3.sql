USE BOOKS;
CREATE TABLE Sales(
sale_id INT IDENTITY(1,1) PRIMARY KEY,
book_id INT NOT NULL,
sale_date DATE,
sale_amount DECIMAL(10,2) NOT NULL,

FOREIGN KEY (book_id) REFERENCES Books(BookID)
);
INSERT INTO Sales(book_id,sale_date,sale_amount)VALUES
(1, '2024-01-10', 499.00),
(1, '2024-02-15', 499.00),
(1, '2025-03-05', 499.00),

(2, '2024-01-18', 399.00),
(2, '2024-03-20', 399.00),
(2, '2025-02-01', 399.00),

(3, '2024-02-01', 799.00),
(3, '2024-06-15', 799.00),
(3, '2025-05-01', 799.00),

(4, '2024-04-10', 599.00),
(4, '2025-07-20', 599.00),
(4, '2025-08-25', 599.00);
GO

SELECT b.Title,b.BookID,
SUM(s.sale_amount) AS total_amount
FROM Books b
JOIN Sales s 
ON b.BookID=s.book_id
GROUP BY b.Title,b.

SELECT b.Title,b.BookID,
YEAR(s.sale_date) AS sales_year,
SUM(s.sale_amount) AS total_sales
FROM Books b
JOIN Sales s
ON b.BookID=s.book_id
GROUP BY b.BookID,b.Title,YEAR(s.sale_date)
ORDER BY b.Title,sales_year

SELECT b.BookID,b.Title,
SUM(s.sale_amount) AS total_amount
FROM Books b
JOIN Sales s
ON b.BookID=s.book_id
GROUP BY b.BookID,b.Title
HAVING SUM(s.sale_amount)>1000;
GO

CREATE PROCEDURE GetBookTotalSales
@BookTitle VARCHAR(100)
AS
BEGIN
SELECT b.Title,
SUM(s.sale_amount) AS total_sales
FROM Books b
JOIN Sales s
ON b.BookID=s.book_id
WHERE b.Title=@BookTitle
GROUP BY b.Title
END;
GO
EXEC GetBookTotalSales 'Atomic Habits';
GO

CREATE FUNCTION AvgSaleAmount()
RETURNS DECIMAL(10,2)
AS
BEGIN
DECLARE @AvgAmount DECIMAL(10,2);
SELECT @AvgAmount=AVG(sale_amount) FROM Sales;
RETURN @AvgAmount;
END;
GO
SELECT dbo.AvgSaleAmount() AS AverageSaleAmount;