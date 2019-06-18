-- SQL Query Executation Orders
FROM
WHERE
GROUP BY
HAVING
SELECT
ORDER BY
LIMIT



-- "04/15/2019"
-- 1. Select the nth highest Salary
Select Salary from Employee as e1
WHERE N-1 = (SELECT COUNT(DISTINCT Salary) FROM Employee as e2
WHERE e2.Salary > e1.Salary);


-- 2. Return only record (n + 1) to (n + m)
Select column_name from table_name
ORDER BY column_name
OFFSET n ROWS
FETCH NEXT m ROWS ONLY;

-- 3. WHERE LIKE syntax ** WildCards ** !expensive time consuming!
SELECT column_name FROM table_name
WHERE column_name LIKE "Car%"
/ WHERE column_name LIKE "Car_";
/*  only supproted by Microsoft SQL Server
    % matches any string with zero or more characters.
    _ matches any single character
    [] matches one of a set of characters
    ^ Represents any character not in the brackets: h[^oa]t find any h_t except hot, hat
    - Represents a range of characters [a-b]
*/


-- "04/16/2019"
-- 1. DISTINCT: can't be partial, like DISTINCT column_name_1, column_name_2"
Select distinct column_name from table_name;

/* 2. OFFSET: Return rows from b+1 to b+a"
"Or Caution:the first row is row 0, therefore, rows from b to b+a-1 is
the true logic behind it */
SELECT column_name FROM table_name LIMIT a OFFSET b;
-- in MySQL & MariaDB, the same as:
SELECT column_name FROM table_name LIMIT b, a;

-- eg:
SELECT (SELECT DISTINCT Salary FROM Employee ORDER BY Salary DESC
LIMIT 1 OFFSET 1) AS SecondHighestSalary


/*3. order by product_price Descendingly
     and then by prod_name Ascendingly,
     the shortcut can only apply to
     the columns you select out.
     !!! ORDER BY must be the last clause !!! */
SELECT prod_id, prod_price, prod_name
FROM Products
ORDER BY 2 DESC, 3 ASC; -- 2, 3 here are the shortcuts

/* 4. WHERE clause
      !<       Not less than
      !>       Not greater than
      <>       Not-equality
      !=       Not-equality
      BETWEEN  Between two specified values
      IS NULL  Is a NULL value
      IN (a,b,c)
      WHERE NOT 'conditions'
*/
SELECT prod_name, prod_price
FROM Products
WHERE vend_id  IN ('DLL01','BRS01')
ORDER BY prod_name;

SELECT prod_name
FROM Products
WHERE NOT vend_id  = 'DLL01'
ORDER BY prod_name;

/* 5. Concatenate
      +
      ||
      TRIM()
      LTRIM()
      RTRIM()
*/
SELECT Concat(vend_name, ' (', vend_country, ')')
AS vend_title
FROM Vendors
ORDER BY vend_name

/* SOUNDEX() takes into account similar sounding characters and syllables,
enabling strings to be compared by how they sound rather than how they have been typed.
*/
SELECT cust_name, cust_contact
FROM Customers
WHERE SOUNDEX(cust_contact) = SOUNDEX('Michael Green');

/* 6. Date and Time Manipulation Functions
     SQL Server: DATEPART(yy, order_date)
     Access: DATEPART('yyyy', order_date)
     PostgreSQL: DATE_PART('year', order_date)
     Oracle: to_number(to_char(order_date, 'YYYY'))
     to_char() function is used to extract part of the date,
     and to_number() is used to convert it to a numeric value so that it can be compared to 2012.
     MySQL & MariaDB: YEAR(order_date)
     SQLite: strftime('%Y', order_date)

 */
-- Oracle
SELECT order_num
FROM Orders
WHERE order_date BETWEEN to_date('01-01-2012')
 AND to_date('12-31-2012');


-- "04/22/2019"
-- ad-hoc Query  vs.  Stored Procedure



-- "04/28/2019"
-- Functions -

CREATE [ OR REPLACE ] FUNCTION
... [schema.]function-name ( [ argname argtype  [, ...] ] )
... RETURN rettype
... AS
... BEGIN
...... RETURN expression;
... END

-- parameter_list: input_a a_data_type, input_b b_data_type

CREATE FUNCTION [schema_name.] function_name(parameter_list)
RETURN data_type AS
BEGIN
    statements
    RETURN value
END


CREATE FUNCTION dbo.StripWWWandCom (input VARCHAR(250))
RETURNS VARCHAR(250)
AS BEGIN
    DECLARE Work VARCHAR(250);

    SET Work = Input;

    SET Work = REPLACE(Work, 'www.', '');
    SET Work = REPLACE(Work, '.com', '');

    RETURN Work
END

-- 05/08/19
-- Ranking : https://codingsight.com/methods-to-rank-rows-in-sql-server-rownumber-rank-denserank-and-ntile/

-- 1) ROW_NUMBER()
SELECT *, ROW_NUMBER() OVER( ORDER BY Student_Score) AS RowNumberRank
FROM StudentScore
-- Output: 1,2,3,4 ...

-- with **PARTITION**
SELECT *, ROW_NUMBER() OVER(PARTITION BY Student_Score  ORDER BY Student_Score) AS RowNumberRank
FROM StudentScore
-- Output: (under Student_Score) 1,2; 1,2,3 ; 1; 1,2 ...

-- 2) RANK()
SELECT *,  RANK ()  OVER(ORDER BY Student_Score) AS RankRank
FROM StudentScore
-- Output: 1,1,3,3,3,6...

-- with **PARTITION**
SELECT *, RANK() OVER(PARTITION BY Student_Score  ORDER BY Student_Score) AS RowNumberRank
FROM StudentScore
-- Output: 1,1,1,1,1,1...

-- 3) DENSE_RANK()
SELECT *,  DENSE_RANK ()  OVER(ORDER BY Student_Score) AS RankRank
FROM StudentScore
-- Output: 1,1,2,2,2,3...

SELECT *, DENSE_RANK() OVER(PARTITION BY Student_Score  ORDER BY Student_Score) AS RowNumberRank
FROM StudentScore

-- same output without using DENSE_RANK()
SELECT
  Score,
  (SELECT count(distinct Score) FROM Scores WHERE Score >= s.Score) Rank
FROM Scores s
ORDER BY Score desc

-- while add a temprary table tmp to reduce the time
SELECT
  Score,
  (SELECT count(*) FROM (SELECT distinct Score s FROM Scores) tmp WHERE s >= Score) Rank
FROM Scores
ORDER BY Score desc

-- combine join
SELECT s.Score, count(distinct t.score) Rank
FROM Scores s JOIN Scores t ON s.Score <= t.score
GROUP BY s.Id
ORDER BY s.Score desc

-- 4) NTILE()

-- ALTER table
-- !! Remember to have a complete set of backups (both schema and data since Database table changes cannot be undone)
-- MySQL: add a column
ALTER TABLE [table_name]
ADD (COLUMN?) [column_name] [column_type]

-- MySQL: Drop a column
ALTER TABLE [table_name]
DROP (COLUMN?) [column_name]

-- Drop a table
DROP TABLE table_name;

-- MySQL CTE (common table expression)???
WITH cte_name (column_list) AS (
    query
)
SELECT * FROM cte_name;

WITH customers_in_usa AS (
    SELECT
        customerName, state
    FROM
        customers
    WHERE
        country = 'USA'
) SELECT
    customerName
 FROM
    customers_in_usa
 WHERE
    state = 'CA'
 ORDER BY customerName;

-- RENAME table
/* DB2, MariaDB, MySQL, Oracle, and PostgreSQL users can use the RENAME statement.
SQL Server users can use the supplied sp_rename stored procedure.
SQLite supports the renaming of tables via the ALTER TABLE statement.*/




-- 05/16/19
-- The COALESCE() function returns the first non-null value in a list.
SELECT COALESCE(NULL, NULL, NULL, 'W3Schools.com', NULL, 'Example.com');

-- INSERT
INSERT (INTO?) table_name (column_name_1, column_name_2,) values(, , ,)


-- **WHERE always run before aggregation, it is a restriction on the source tables!!**
-- **Having is a restriction on the result after aggregation!!**

-- 05/18/19
-- create table
CREATE TABLE table_name (
    column_name_1 CHAR(10) PRIMARY KEY,
    column_name_2 CHAR(10) REFERENCES reference_table_name(corresponding_column_name),
    column_name_3 DECIMAL(p,s) NOT NULL DEFAULT 1.0,
    column_name_4 VARCHAR(1000),
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    import_time CHAR(30) DEFAULT CURRENT_DATE()
);


-- 05/19/19
-- LeetCode: 180

-- LeetCode: 184
-- 1)
SELECT D.Name as Department, E.Name as Employee, E.Salary
 FROM Department D, Employee E, Employee E2
 WHERE D.ID = E.DepartmentId and E.DepartmentId = E2.DepartmentId and
 E.Salary <= E2.Salary
 group by D.ID,E.Name having count(distinct E2.Salary) = 1
 order by D.Name desc

-- 2)
 SELECT D.Name AS Department ,E.Name AS Employee ,E.Salary
 FROM
 	Employee E,
 	(SELECT DepartmentId,max(Salary) as max FROM Employee GROUP BY DepartmentId) T,
 	Department D
 WHERE E.DepartmentId = T.DepartmentId
   AND E.Salary = T.max
   AND E.DepartmentId = D.id

-- 3)
 SELECT D.Name,A.Name,A.Salary
 FROM
 	Employee A,
 	Department D
 WHERE A.DepartmentId = D.Id
   AND NOT EXISTS
   (SELECT 1 FROM Employee B WHERE B.Salary > A.Salary AND A.DepartmentId = B.DepartmentId)

-- 4)
 SELECT D.Name AS Department ,E.Name AS Employee ,E.Salary
 from
 	Employee E,
 	Department D
 WHERE E.DepartmentId = D.id
   AND (DepartmentId,Salary) in
   (SELECT DepartmentId,max(Salary) as max FROM Employee GROUP BY DepartmentId)

-- LeetCode: 184
-- OWN Answer
SELECT B.Name AS Department, A.Name AS Employee, B.max_salary AS Salary FROM Employee A LEFT JOIN
(SELECT MAX(E.Salary) AS max_salary, E.DepartmentId, D.Name FROM Employee E LEFT JOIN
Department D on E.DepartmentId = D.Id GROUP BY E.DepartmentId) AS B
ON A.DepartmentId = B.DepartmentId
WHERE A.Salary = B.max_salary AND B.Name IS NOT NULL

-- LeetCode: 185
SELECT b.Name as Department, a.Name Employee, a.Salary Salary
FROM Employee a inner join Department b on a.DepartmentId = b.Id
WHERE 3 > (SELECT COUNT(DISTINCT c.Salary) FROM Employee c
            WHERE c.Salary > a.Salary and a.DepartmentId = c.DepartmentId)
ORDER BY b.Id, Salary desc;

-- 05/19/19 Book
COUNT(*) -- count NULL
COUNT(column) -- do not count NULL

-- TOP and TOP PERCENT

-- 05/20/19 Book
-- graphical interfaces


SELECT vend_name, prod_name, prod_price
FROM Vendors, Products
WHERE Vendors.vend_id = Products.vend_id;
/* Realize the importance of "WHERE", it would pair every row of the first table
to every row of the second table, while the WHERE clause acts as the filter
to only include rows that match the specific filter condition - the join condition, in this case.
*/

/*The UNION automatically removes any duplicate rows from the query result set
The UNION ALL won't
*/

/*
Some DBMSs support two additional types of UNION EXCEPT (sometimes called MINUS)
can be used to only retrieve the rows that exist in the first table but not in the second,
and INTERSECT can be used to retrieve only the rows that exist in both tables.
In practice, however, these UNION types are rarely used as the same results can be accomplished using joins.
*/

-- Insert Retrieved Data
INSERT INTO Customers(cust_id,
                      cust_contact,
                      cust_email,
                      cust_name,
                      cust_address,
                      cust_city,
                      cust_state,
                      cust_zip,
                      cust_country)
SELECT cust_id,
       cust_contact,
       cust_email,
       cust_name,
       cust_address,
       cust_city,
       cust_state,
       cust_zip,
       cust_country
FROM CustNew;

SELECT *
INTO CustCopy
FROM Customers;

-- “MariaDB, MySQL, Oracle, PostgreSQL, and SQLite”
CREATE TABLE table_name_2 AS
SELECT * FROM table_name_1;

-- UPDATE table
UPDATE table_name
SET column_name_1 = NULL, -- this can delete the value
    column_name_2 = 'some value'
WHERE column_name_3 = 'some value'; -- the conditions

UPDATE table_name
SET CASE WHEN ** THEN ** ELSE ** END;

-- DELETE some rows
DELETE (FROM?) table_name
WHERE column_name_1 = 'some value';

-- DELET WHOLE TABLE
TRUNCATE TABLE table_name;

-- CREATE VIEW
-- Views are virtual tables. They do not contain data, but instead, they contain queries that retrieve data as needed.

CREATE VIEW OrderItemsExpanded AS
SELECT order_num,
       prod_id,
       quantity,
       item_price,
       quantity*item_price AS expanded_price
FROM OrderItems;


-- Executing Stored Procedures
EXECUTE AddNewProduct('JTS01',
                      'Stuffed Eiffel Tower',
                      6.49,
                      'Plush stuffed toy with the text La Tour Eiffel in red white and blue');


-- Creating Stored Procedures
CREATE PROCEDURE MailingListCount (
  ListCount OUT INTEGER
)
IS
v_rows INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_rows
    FROM Customers
    WHERE NOT cust_email IS NULL;
    ListCount := v_rows;
END

-- Invoke the Oracle Example
var ReturnValue NUMBER
EXEC MailingListCount(:ReturnValue);
SELECT ReturnValue;


-- Microsoft SQL Server
CREATE PROCEDURE MailingListCount
AS
DECLARE @cnt INTEGER
SELECT @cnt = COUNT(*)
FROM Customers
WHERE NOT cust_email IS NULL;
RETURN @cnt;

-- Invoke the Microsoft SQL Server example
DECLARE @ReturnValue INT
EXECUTE @ReturnValue=MailingListCount;
SELECT @ReturnValue;


-- SQL Server example
CREATE PROCEDURE NewOrder @cust_id CHAR(10)
AS
-- Declare variable for order number
DECLARE @order_num INTEGER
-- Get current highest order number
SELECT @order_num=MAX(order_num)
FROM Orders
-- Determine next order number
SELECT @order_num=@order_num+1
-- Insert new order
INSERT INTO Orders(order_num, order_date, cust_id)
VALUES(@order_num, GETDATE(), @cust_id)
-- Return order number
RETURN @order_num;

/* Transaction Processing is a mechanism used to manage sets of SQL operations
that must be executed in batches so as
to ensure that databases never contain the results of partial operations. */

-- Transaction processing is used to manage INSERT, UPDATE, and DELETE statements.
/*
Procedure:
1) BEGIN/SET/START
2) COMMIT/ROLLBACK
3) SAVEPOINTS & ROLLBACK
*/

-- 1. SQL Server
-- 1) & 2)
BEGIN TRANSACTION
...
COMMIT TRANSACTION

-- 3) SAVEPOINTS
SAVE TRANSACTION point_name;
ROLLBACK TRANSACTION point_name;

-- SQL Server example:
BEGIN TRANSACTION
INSERT INTO Customers(cust_id, cust_name)
VALUES('1000000010', 'Toys Emporium');
SAVE TRANSACTION StartOrder;
INSERT INTO Orders(order_num, order_date, cust_id)
VALUES(20100,'2001/12/1','1000000010');
IF @@ERROR <> 0 ROLLBACK TRANSACTION StartOrder;
INSERT INTO OrderItems(order_num, order_item, prod_id, quantity, item_price)
VALUES(20100, 1, 'BR01', 100, 5.49);
IF @@ERROR <> 0 ROLLBACK TRANSACTION StartOrder;
INSERT INTO OrderItems(order_num, order_item, prod_id, quantity, item_price)
VALUES(20100, 2, 'BR03', 100, 10.99);
IF @@ERROR <> 0 ROLLBACK TRANSACTION StartOrder;
COMMIT TRANSACTION;


-- 2. MariaDB & MySQL
-- 1)
START TRANSACTION
...
-- 3) SAVEPOINTS
SAVEPOINT point_name;
ROLLBACK TO point_name;

-- 3. Oracle
SET TRANSACTION
...
COMMIT;

-- Oracle example
SET TRANSACTION
DELETE OrderItems WHERE order_num = 12345;
DELETE Orders WHERE order_num = 12345;
COMMIT;

-- 4. PostgreSQL & ANSI SQL
BEGIN
...

-- Cursors
-- DB2, MariaDB, MySQL, SQL Server
DECLARE CustCursor CURSOR
FOR
SELECT * FROM Customers
WHERE cust_email IS NULL;

-- Oracle & PostgreSQL
DECLARE CURSOR CustCursor
IS
SELECT * FROM Customers
WHERE cust_email IS NULL;

-- To be Continued

-- Advanced SQL query

-- 1) PRIMARY KEY
-- not applicable to SQLite
ALTER TABLE Vendors
ADD CONSTRAINT PRIMARY KEY (vend_id);

-- 2) FOREIGN KEY
ALTER TABLE Orders
ADD CONSTRAINT
FOREIGN KEY (cust_id) REFERENCES Customers (cust_id);

ALTER TABLE Orders
ADD CONSTRAINT CHECK (gender LIKE '[MF]')； -- gender is the column to be added constraints



-- TRIGGER:

-- SQL Server
CREATE TRIGGER customer_state
ON Customers
FOR INSERT, UPDATE
AS
UPDATE Customers
SET cust_state = Upper(cust_state)
WHERE Customers.cust_id = inserted.cust_id;

-- Oracle & PostgreSQL
CREATE TRIGGER customer_state
AFTER INSERT OR UPDATE
FOR EACH ROW
BEGIN
UPDATE Customers
SET cust_state = Upper(cust_state)
WHERE Customers.cust_id = :OLD.cust_id
END;
-- Constraints Are FASTER Than Trigger

LEFT(column_name, LENGTH(column_name)-4)
RIGHT(column_name_2, 8)

CASE
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    WHEN conditionN THEN resultN
    ELSE result
END;

POSITION(',' IN city_state);


-- SQL Server
SELECT TOP 50 PERCENT * FROM Customers;

SELECT SupplierName
FROM Suppliers
WHERE EXISTS (SELECT ProductName FROM Products
    WHERE Products.SupplierID = Suppliers.supplierID AND Price = 22)


-- MySQL
DATE_ADD(date_column, INTERVAL 30 DAY)
DATE_ADD("2017-06-15", INTERVAL -2 MONTH)
DATE_ADD("2017-06-15 09:34:21", INTERVAL -3 HOUR)
DATE_ADD("2017-06-15 09:34:21", INTERVAL 15 MINUTE)

DATEDIFF(date_column_1, date_column_2) = 1 -- date_column_1(May 4th) is one day after of date_column_2(May 3rd)



-- 06/04/19
-- How to join two tables by creating new temporary tables:

CREATE VIEW public.ParkingCapacity AS
SELECT
TEMP_2.parkingID,
TEMP_2.TakeTimes,
TEMP_3.ReturnTimes,
TEMP_2.TakeAmout,
TEMP_3.ReturnAmout
FROM((SELECT A.parkingID, TakeTimes, TakeAmout
    FROM dw_gofun_parking AS A LEFT JOIN (
        SELECT takeparkingID AS parkingID, COUNT(*) AS TakeTimes, SUM(Amount) AS TakeAmout
        FROM dw_gofun_order
        GROUP BY takeparkingID) AS TEMP_1 ON A.parkingID = TEMP_1.parkingID) AS TEMP_2
        LEFT JOIN (SELECT returnparkingID As parkingID, COUNT(*) AS ReturnTimes, SUM(Amount) AS returnAmout
        FROM dw_gofun_order
        GROUP BY returnparkingID) AS TEMP_3 ON TEMP_2.parkingID = TEMP_3.parkingID
    )



-- 06/05/19
-- Percentile in MySQL: https://stackoverflow.com/questions/4741239/select-top-x-or-bottom-percent-for-numeric-values-in-mysql
SELECT price FROM prices p1 WHERE
(SELECT count(*) FROM prices p2 WHERE p2.price >= p1.price) <=
     (SELECT 0.1 * count(*) FROM prices)
);

-- 06/16/19
-- LeetCode: 182
SELECT Email FROM Person GROUP BY Email HAVING COUNT(*)>1

-- LeetCode: 196
DELETE P1 FROM Person P1, Person P2 WHERE P1.Id>P2.Id AND P1.Email = P2.Email

-- LeetCode: 197
-- Mine:
SELECT Id FROM (SELECT A.Temp_prev AS Temp_prev, B.* FROM
    (SELECT DATE_ADD(RecordDate, INTERVAL 1 DAY) AS RecordDate, Temperature AS Temp_prev FROM Weather) A
    RIGHT JOIN Weather B ON A.RecordDate = B.RecordDate) as c WHERE Temperature > Temp_prev
-- Solution: (Better using DATEDIFF)
SELECT W1.Id as Id from Weather W1 JOIN Weather W2 ON DATEDIFF(W1.RecordDate, W2.RecordDate) = 1 AND W1.Temperature > W2.Temperature


-- format
FORMAT(1, 'N7') -- 1.0000000

-- LeetCode: 262
SELECT Request_at AS 'Date',
FORMAT(SUM(CASE WHEN Status = 'completed' THEN 0 ELSE 1 END)/COUNT(*),2) AS 'Cancellation Rate'
FROM
(SELECT T.* FROM Trips T LEFT JOIN Users U ON T.Client_Id = U.Users_Id
    WHERE U.Banned = 'NO' AND U.Role = 'client' AND T.Request_at BETWEEN '2013-10-01' AND '2013-10-03') AS C
    GROUP BY Request_at


-- 06/17/19
FLOOR(17.36) -- 17
FLOOR(-17.36) -- -18
CEIL(17.36) -- 18
CEIL(-17.36) -- -17

SQRT(25) -- 5
POWER(BASE, Exponent) -- POWER(3,2) = 9
MOD(dividend,divider); dividend % divider; dividend MOD divider; -- get remainder: MOD(7,2)=1
EXP(2) -- e^2

-- LeetCode: 626
