-- 04/15/2019
-- LeetCode: 176 & 177
-- 1. Select the nth highest Salary
Select Salary from Employee as e1
WHERE N-1 = (SELECT COUNT(DISTINCT Salary) FROM Employee as e2
WHERE e2.Salary > e1.Salary);


-- 2. Return only record (n + 1) to (n + m)
Select column_name from table_name
ORDER BY column_name
OFFSET n ROWS
FETCH NEXT m ROWS ONLY;

-- LeetCode: 180
SELECT *
FROM
    Logs l1,
    Logs l2,
    Logs l3
WHERE
    l1.Id = l2.Id - 1
    AND l2.Id = l3.Id - 1
    AND l1.Num = l2.Num
    AND l2.Num = l3.Num
;


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

-- LeetCode: 262
SELECT Request_at AS 'Date',
FORMAT(SUM(CASE WHEN Status = 'completed' THEN 0 ELSE 1 END)/COUNT(*),2) AS 'Cancellation Rate'
FROM
(SELECT T.* FROM Trips T LEFT JOIN Users U ON T.Client_Id = U.Users_Id
    WHERE U.Banned = 'NO' AND U.Role = 'client' AND T.Request_at BETWEEN '2013-10-01' AND '2013-10-03') AS C
    GROUP BY Request_at

-- LeetCode: 626
SELECT
    (CASE
        WHEN MOD(id, 2) != 0 AND counts != id THEN id + 1
        WHEN MOD(id, 2) != 0 AND counts = id THEN id
        ELSE id - 1
    END) AS id,
    student
FROM
    seat,
    (SELECT
        COUNT(*) AS counts
    FROM
        seat) AS seat_counts
ORDER BY id ASC;
