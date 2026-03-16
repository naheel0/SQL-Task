CREATE DATABASE books_store_db;
GO

USE books_store_db;
GO

CREATE TABLE books(
  book_id INT IDENTITY(1,1)PRIMARY KEY,
  title VARCHAR(150) NOT NULL,
  author VARCHAR(100)NOT NULL,
  price DECIMAL(10,2)NOT NULL
);

INSERT INTO books(title,author,price)VALUES
('Harry Potter and the Philosopher''s Stone', 'J.K. Rowling', 499.00),
('Harry Potter and the Chamber of Secrets', 'J.K. Rowling', 550.00),
('The Alchemist', 'Paulo Coelho', 399.00),
('Eleven Minutes', 'Paulo Coelho', 450.00),
('Wings of Fire', 'A.P.J Abdul Kalam', 300.00),
('Ignited Minds', 'A.P.J Abdul Kalam', 320.00);
GO

CREATE PROCEDURE sp_getallbooktitles
AS
BEGIN
SELECT title
FROM books;
END
GO

EXEC sp_getallbooktitles;
GO

 CREATE PROCEDURE sp_getbooksbyauthor
 @author_name VARCHAR(150)
 AS
 BEGIN
 SELECT book_id, title,author,price
 FROM books
 WHERE author=@author_name;
 END;
 GO
 EXEC sp_GetBooksByAuthor 'Paulo Coelho';
 GO
 CREATE FUNCTION dbo.fn_bookcountbyauthor
 (
 @author_name VARCHAR(100)
 )
 RETURNS INT
 AS
 BEGIN
 DECLARE @total_books INT;

 SELECT @total_books=COUNT(*)
 FROM books
 WHERE author=@author_name;
 RETURN @total_books;
 END;
 GO

SELECT dbo.fn_BookCountByAuthor('J.K. Rowling') AS total_books;
GO
SELECT * FROM books;
GO
SELECT author,
       dbo.fn_BookCountByAuthor(author) AS book_count
FROM books
GROUP BY author;
GO