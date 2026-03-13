CREATE DATABASE BOOKS
GO
USE  BOOKS
GO
CREATE TABLE  authors(
 authorID INT IDENTITY(1,1) PRIMARY KEY,
 authorName VARCHAR(100) NOT NULL UNIQUE,
);
CREATE TABLE  publishers(
 publisherID INT IDENTITY(1,1) PRIMARY KEY,
 publisherName VARCHAR(100) NOT NULL UNIQUE,
);
CREATE TABLE Books(
BookID INT IDENTITY(1,1) PRIMARY KEY,
Title VARCHAR(200) NOT NULL,
PublicationYear INT NOT NULL,

 authorID INT NOT NULL,
 PublisherID INT NOT NULL,

 FOREIGN KEY(authorID) REFERENCES authors(authorID)
 ON UPDATE CASCADE
 ON DELETE CASCADE,

 FOREIGN KEY(publisherID) REFERENCES publishers(publisherID)
 ON UPDATE CASCADE
 ON DELETE CASCADE,
);
INSERT INTO authors(authorName) VALUES
('Paulo Coelho'),
('A. P. J. Abdul Kalam'),
('J. K. Rowling'),
('Robert Kiyosaki'),
('Charles Duhigg'),
('James Clear');
INSERT INTO publishers(publisherName) VALUES
('HarperCollins'),
('Bloomsbury'),
('Penguin'),
('Random House');
INSERT INTO Books(Title,PublicationYear,authorID,PublisherID) VALUES
('The Alchemist', 1988, 1, 1),
('Wings of Fire', 1999, 2, 3),
('Harry Potter and the Philosopher''s Stone', 1997, 3, 2),
('Harry Potter and the Chamber of Secrets', 1998, 3, 2),
('Rich Dad Poor Dad', 1997, 4, 4),
('The Power of Habit', 2012, 5, 3),
('Atomic Habits', 2018, 6, 1);
SELECT b.Title, a.AuthorName, p.PublisherName
FROM Books b
INNER JOIN Authors a ON b.AuthorID = a.AuthorID
INNER JOIN Publishers p ON b.PublisherID = p.PublisherID;

SELECT b.Title, a.AuthorName, p.PublisherName
FROM Books b
INNER JOIN Authors a ON b.AuthorID = a.AuthorID
LEFT JOIN Publishers p ON b.PublisherID = p.PublisherID;

SELECT b.Title, a.AuthorName, p.PublisherName
FROM Books b
RIGHT JOIN  Publishers p ON b.PublisherID = p.PublisherID
LEFT JOIN Authors a ON b.AuthorID = a.AuthorID;

SELECT b.Title, a.AuthorName, p.PublisherName
FROM Books b
RIGHT JOIN Publishers p ON b.PublisherID = p.PublisherID
LEFT JOIN Authors a ON b.AuthorID = a.AuthorID;

SELECT b.Title, a.AuthorName, p.PublisherName
FROM Books b
RIGHT JOIN Publishers p ON b.PublisherID = p.PublisherID
LEFT JOIN Authors a ON b.AuthorID = a.AuthorID;

SELECT AuthorName AS Name FROM Authors
UNION ALL 
SELECT PublisherName FROM Publishers;