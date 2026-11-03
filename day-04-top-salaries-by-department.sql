Q) Using the same Employees table, find the top 2 distinct salaries in each department.

Return these columns:
- EmployeeID
- EmployeeName
- Department
- Salary
- SalaryRank
If multiple employees have the same salary, include all of them.

Sample data
EmployeeID	EmployeeName	Department	Salary
1	Rahul	Engineering	60000
2	Priya	Engineering	80000
3	Amit	Engineering	75000
4	Neha	HR	50000
5	Karan	HR	70000
6	Simran	HR	70000
7	Arjun	Marketing	90000
8	Isha	Marketing	65000
9	Rohan	Marketing	60000

A) WITH RANKED_SALARIES AS (
  SELECT EmployeeName, Department, EmployeeID, Salary,
  DENSE_RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS SalaryRank
  FROM Employees
)
SELECT EmployeeName, Department, SalaryRank, EmployeeID, Salary
FROM RANKED_SALARIES
WHERE SalaryRank < 3
ORDER BY Department, SalaryRank, EmployeeID
;
