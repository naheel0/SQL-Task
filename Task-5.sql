CREATE DATABASE bookstoredb
GO

USE bookstoredb
GO

  CREATE TABLE author(
  author_id INT IDENTITY(1,1)PRIMARY KEY,
  author_name VARCHAR(100)NOT NULL,
  email VARCHAR(150),
  country VARCHAR(50)
  );
  GO

  CREATE TABLE books(
   book_id INT IDENTITY (1,1)PRIMARY KEY,
   title VARCHAR(150)NOT NULL,
   genre VARCHAR(50),
   price DECIMAL(10,2)NOT NULL,
   published_year INT,
   author_id INT  NOT NULL,

   constraint fk_books_authors
    foreign key (author_id)
    references author(author_id)
  );

 INSERT INTO author(author_name,email,country)VALUES
('J.K. Rowling', 'jkrowling@gmail.com', 'UK'),
('George R.R. Martin', 'grrm@gmail.com', 'USA'),
('Paulo Coelho', 'paulo@gmail.com', 'Brazil'),
('Chetan Bhagat', 'chetan@gmail.com', 'India');
GO

INSERT INTO books(title,genre,price,published_year,author_id)VALUES
('Harry Potter', 'Fantasy', 599.00, 1997, 1),
('Game of Thrones', 'Fantasy', 799.00, 1996, 2),
('The Alchemist', 'Fiction', 299.00, 1988, 3),
('Half Girlfriend', 'Romance', 249.00, 2014, 4),
('2 States', 'Romance', 199.00, 2009, 4);
GO


CREATE VIEW vw_booksauthordetails
AS
SELECT
  b.book_id,
    b.title,
    b.genre,
    b.price,
    b.published_year,

    a.author_id,
    a.author_name,
    a.email,
    a.country
    FROM books b
    INNER JOIN author a
    ON b.author_id=a.author_id;
    GO

    SELECT *FROM vw_booksauthordetails;