USE LibraryDB

CREATE TABLE Authors(
 AuthorID INT IDENTITY(1,1) PRIMARY KEY,
 AuthorName VARCHAR(100) NOT NULL
);

CREATE TABLE Books(
 BookID INT IDENTITY(1,1) PRIMARY KEY,
 Title VARCHAR(150) NOT NULL,
 AuthorID INT NOT NULL,
 FOREIGN KEY(AuthorID) REFERENCES Authors(AuthorID)
);

CREATE TABLE Users(
 MemberID INT IDENTITY(1,1) PRIMARY KEY,
 FullName VARCHAR(100) NOT NULL,
 Phone VARCHAR(15)
);

CREATE TABLE BookCopies (
 CopyID INT IDENTITY(1,1) PRIMARY KEY,
 BookID INT NOT NULL,
 IsAvailable BIT NOT NULL DEFAULT 1,
 FOREIGN KEY (BookID) REFERENCES Books(BookID)
);

CREATE TABLE Borrowing (
 BorrowID INT IDENTITY(1,1) PRIMARY KEY,
 MemberID INT NOT NULL,
 CopyID INT NOT NULL,
 BorrowDate DATETIME NOT NULL DEFAULT GETDATE(),
 ReturnDate DATETIME NULL,
 FOREIGN KEY (MemberID) REFERENCES Users(MemberID),
 FOREIGN KEY (CopyID) REFERENCES BookCopies(CopyID)
);
GO

CREATE PROCEDURE sp_CheckoutBook
@MemberID INT,
@CopyID INT
AS
BEGIN
 SET NOCOUNT ON;

 IF NOT EXISTS(SELECT 1 FROM BookCopies WHERE CopyID=@CopyID)
 BEGIN
  PRINT 'Invalid CopyID';
  RETURN;
 END

 IF EXISTS(SELECT 1 FROM BookCopies WHERE CopyID=@CopyID AND IsAvailable=0)
 BEGIN
  PRINT 'This book copy is not available.';
  RETURN;
 END

 INSERT INTO Borrowing(MemberID, CopyID, BorrowDate)
 VALUES (@MemberID, @CopyID, GETDATE());

 UPDATE BookCopies
 SET IsAvailable = 0
 WHERE CopyID = @CopyID;

 PRINT 'Book checked out successfully!';
END

EXEC sp_CheckoutBook @MemberID = 1, @CopyID = 2;
GO
CREATE PROCEDURE sp_ReturnBook
@MemberID INT,
@CopyID INT
AS
BEGIN
 SET NOCOUNT ON;

 IF NOT EXISTS(
   SELECT 1
   FROM Borrowing
   WHERE MemberID=@MemberID
   AND CopyID=@CopyID
   AND ReturnDate IS NULL
 )
 BEGIN 
  PRINT 'No active borrowing found for this member and copy.';
  RETURN;
 END

 UPDATE Borrowing
 SET ReturnDate = GETDATE()
 WHERE MemberID = @MemberID
 AND CopyID = @CopyID
 AND ReturnDate IS NULL;

 UPDATE BookCopies
 SET IsAvailable = 1
 WHERE CopyID = @CopyID;

 PRINT 'Book returned successfully!';
END
EXEC sp_ReturnBook @MemberID = 1, @CopyID = 2;
GO
CREATE FUNCTION fn_GetBookCountByAuthor
(
 @AuthorID INT
)
RETURNS INT
AS
BEGIN
 DECLARE @TotalBooks INT;

 SELECT @TotalBooks = COUNT(*)
 FROM Books
 WHERE AuthorID = @AuthorID;

 RETURN ISNULL(@TotalBooks, 0);
END

SELECT dbo.fn_GetBookCountByAuthor(1) AS TotalBooks;
GO
CREATE FUNCTION fn_GetOverdueBorrowings()
RETURNS TABLE
AS
RETURN
(
 SELECT 
 br.BorrowID,
 br.MemberID,
 u.FullName,
 br.CopyID,
 b.Title,
 br.BorrowDate,
 DATEDIFF(DAY, br.BorrowDate, GETDATE()) AS DaysPassed
 FROM Borrowing br
 INNER JOIN Users u ON u.MemberID = br.MemberID
 INNER JOIN BookCopies bc ON bc.CopyID = br.CopyID
 INNER JOIN Books b ON b.BookID = bc.BookID
 WHERE br.ReturnDate IS NULL
 AND br.BorrowDate <= DATEADD(DAY, -7, GETDATE())
);

SELECT * FROM dbo.fn_GetOverdueBorrowings();

INSERT INTO Authors(AuthorName) VALUES
('J.K. Rowling'),
('George R.R. Martin'),
('Paulo Coelho'),
('Robert Kiyosaki'),
('Dan Brown');

INSERT INTO Books(Title, AuthorID) VALUES
('Harry Potter and the Philosopher''s Stone', 1),
('Harry Potter and the Chamber of Secrets', 1),
('A Game of Thrones', 2),
('A Clash of Kings', 2),
('The Alchemist', 3),
('Rich Dad Poor Dad', 4),
('The Da Vinci Code', 5);

INSERT INTO Users(FullName, Phone) VALUES
('Ansif MK', '9876543210'),
('Riyas K', '9876500001'),
('Nihal P', '9876500002'),
('Akhil V', '9876500003');

INSERT INTO BookCopies(BookID, IsAvailable) VALUES
(1,1),(1,1),
(2,1),(2,1),
(3,1),(3,1),
(4,1),(4,1),
(5,1),(5,1),
(6,1),(6,1),
(7,1),(7,1);

INSERT INTO Borrowing(MemberID, CopyID, BorrowDate, ReturnDate)
VALUES
(1,1, DATEADD(DAY,-10,GETDATE()), NULL);

INSERT INTO Borrowing(MemberID, CopyID, BorrowDate, ReturnDate)
VALUES
(2,2, DATEADD(DAY,-5,GETDATE()), GETDATE());

UPDATE BookCopies SET IsAvailable = 0 WHERE CopyID = 1;
UPDATE BookCopies SET IsAvailable = 1 WHERE CopyID = 2;

EXEC sp_CheckoutBook @MemberID = 3, @CopyID = 3;

EXEC sp_ReturnBook @MemberID = 3, @CopyID = 3;

SELECT dbo.fn_GetBookCountByAuthor(1) AS BooksByRowling;

SELECT * FROM dbo.fn_GetOverdueBorrowings();