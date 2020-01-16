--create a stored procedure with parameter to display rate
create procedure spPrintEmployeeRate @DeptName nvarchar (90)
as 
begin
     with currentpayrates
	 as
	 (
	    select BusinessEntityID, max (modifieddate) lastmodifieddate
		from AdventureWorksDB.HumanResources.EmployeePayHistory
		group by BusinessEntityID
	 )
     Select distinct
	 'Job Title' = E.JobTitle, 'Employee' = P.FirstName + ' ' + P.LastName, EPH.Rate currentpayrate
	 from AdventureWorksDB.HumanResources.Employee E
	 left outer join AdventureWorksDB.Person.Person P
	       on E.BusinessEntityID = P.BusinessEntityID
	 left join AdventureWorksDB.HumanResources.EmployeeDepartmentHistory EDH
	        on E.BusinessEntityID = EDH.BusinessEntityID
	 LEFT OUTER join AdventureWorksDB.HumanResources.Department D
	        on EDH.DepartmentID = D.DepartmentID
	 left join currentpayrates cpr
	      on E.BusinessEntityID = cpr.BusinessEntityID
	inner join AdventureWorksDB.HumanResources.EmployeePayHistory EPH
	      on cpr.lastmodifieddate = eph.modifieddate
	 LEFT OUTER join AdventureWorksDB.HumanResources.EmployeePayHistory 
	        on EPH.BusinessEntityID = E.BusinessEntityID
	WHERE EDH.EndDate is null and D.Name = @DeptName
	ORDER BY  EPH.Rate DESC
	END
	GO

	-- run the stored procedure by passing in "Engineering"

	EXEC spPrintEmployeeRate Engineering
GO

--Write a transact-SQL statement to modify spPrintEmployeeRate procedure to add an input parameter as MinRate.
create procedure spPrintEmployeeRate1 @MinRate decimal (5,2)
as 
begin
     with currentpayrates
	 as
	 (
	    select BusinessEntityID, max (modifieddate) lastmodifieddate
		from AdventureWorksDB.HumanResources.EmployeePayHistory
		group by BusinessEntityID
	 )
     Select distinct
	 'Job Title' = E.JobTitle, 'Employee' = P.FirstName + ' ' + P.LastName, EPH.Rate currentpayrate
	 from AdventureWorksDB.HumanResources.Employee E
	 left outer join AdventureWorksDB.Person.Person P
	       on E.BusinessEntityID = P.BusinessEntityID
	 left join AdventureoWrksDB.HumanResources.EmployeeDepartmentHistory EDH
	        on E.BusinessEntityID = EDH.BusinessEntityID
	 LEFT OUTER join AdventureWorksDB.HumanResources.Department D
	        on EDH.DepartmentID = D.DepartmentID
	 left join currentpayrates cpr
	      on E.BusinessEntityID = cpr.BusinessEntityID
	inner join AdventureWorksDB.HumanResources.EmployeePayHistory EPH
	      on cpr.lastmodifieddate = eph.modifieddate
	 LEFT OUTER join AdventureWorksDB.HumanResources.EmployeePayHistory 
	        on EPH.BusinessEntityID = E.BusinessEntityID
	WHERE EDH.EndDate is null and EPH.Rate >  @MinRate
	ORDER BY  EPH.Rate DESC
	END
	GO

	--Write a transact-SQL statement to delete spPrintEmployeeRate procedure
	DROP PROC spPrintEmployeeRate


	--Create a transact-SQL stored procedure spGetWeeklyGroupTotalSalary with output parameter that allows the human resources queries the weekly total salary of one department group (GroupName in Department table)
create proc spGetWeeklyGroupTotalSalary (
@TotalSalary decimal(26,2) output,
@GroupName nchar(100)
)
as 
begin
     with currentpayrates
	 as
	 (
	    select BusinessEntityID, max (modifieddate) lastmodifieddate
		from AdventureWorksDB.HumanResources.EmployeePayHistory
		group by BusinessEntityID
	 )
	select @TotalSalary = Sum(EPH.Rate*40)
	From AdventureWorksDB.HumanResources.EmployeeDepartmentHistory  EDH
	left join currentpayrates cpr
		On EDH.BusinessEntityID = cpr.BusinessEntityID
	Inner Join AdventureWorksDB.HumanResources.EmployeePayHistory as EPH
		on cpr.lastmodifieddate = EPH.ModifiedDate
	left join AdventureWorksDB.HumanResources.Department D
		on EDH.DepartmentID = d.DepartmentID
	WHERE EDH.EndDate is null 
	AND d.GroupName = --'Marketing ' 
	@GroupName

	Group By d.GroupName
END 
GO


---Write a transact-SQL statement to execute the procedure spGetWeeklyGroupTotalSalary with a department group name as input and display the result.
Declare @TotalWeeklyGroupSalary dec(26,2)
	EXEC [dbo].[spGetWeeklyGroupTotalSalary] 'Marketing', @TotalSalary = @TotalWeeklyGroupSalary 
output
Select @TotalWeeklyGroupSalary as 'Total Group Weekly Salary'

--Create a transact-SQL stored procedure spGetCurrentSalaryRate with output parameter that returns the current salary hourly rate, and department name of an employee based on the employee ID (BusinessEntityID) as input

create procedure spGetCurrentSalaryRate @BusinessEntityID int  
as 
begin
     with currentpayrates
	 as
	 (
	    select BusinessEntityID, max (modifieddate) lastmodifieddate
		from AdventureWorksDB.HumanResources.EmployeePayHistory
		group by BusinessEntityID
	 )
     Select distinct
	 'DepartmentName' = D.Name , 'Job Title' = E.JobTitle, 'Employee' = P.FirstName + ' ' + P.LastName, EPH.Rate currentpayrate
	 from AdventureWorksDB.HumanResources.Employee E
	 left outer join AdventureWorksDB.Person.Person P
	       on E.BusinessEntityID = P.BusinessEntityID
	 left join AdventureWorksDB.HumanResources.EmployeeDepartmentHistory EDH
	        on E.BusinessEntityID = EDH.BusinessEntityID
	 LEFT OUTER join AdventureWorksDB.HumanResources.Department D
	        on EDH.DepartmentID = D.DepartmentID
	 left join currentpayrates cpr
	      on E.BusinessEntityID = cpr.BusinessEntityID
	inner join AdventureWorksDB.HumanResources.EmployeePayHistory EPH
	      on cpr.lastmodifieddate = eph.modifieddate
	 LEFT OUTER join AdventureWorksDB.HumanResources.EmployeePayHistory 
	        on EPH.BusinessEntityID = E.BusinessEntityID
	WHERE EDH.EndDate is null  and EDH.BusinessEntityID = @BusinessEntityID 
	ORDER BY  EPH.Rate DESC
	END
	GO


