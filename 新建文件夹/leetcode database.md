# Leetcode Database

175. Combine Two Tables

```mysql
select FirstName, LastName, City, State from Person p left join Address a on p.PersonId=a.PersonId
```

176. Second Highest Salary

```mysql
select ifnull((select distinct Salary from Employee order by Salary desc limit 1,1),null)  as SecondHighestSalary
```

  177. Nth Highest Salary 

```mysql
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
  SET N=N-1;
  RETURN (
    select IFNULL((select distinct Salary from Employee order by Salary desc limit 1 offset N), null)
  );
END
```



  181. Employees Earning More Than Their Managers 

```mysql
select Name as Employee  from Employee e where Salary > (select Salary from Employee where Id=e.ManagerId)
```

or

```mysql
select employee.Name as Employee from Employee employee join Employee manager on employee.ManagerId=manager.Id where employee.Salary > manager.Salary
```



182. Duplicate Emails

```mysql
select Email from Person group by Email having count(1)>1
```

  183. Customers Who Never Order 

in (select ...)

```mysql
select Name as Customers from Customers where Id not in (select CustomerId from Orders)
```

196. Delete Duplicate Emails

delete
group

```mysql
delete from Person where Id not in (select t.Id from (select min(Id) Id from Person group by Email) t)
```


197. Rising Temperature

时间运算

```mysql
select today.Id from Weather today join Weather yesterday on TO_DAYS(today.RecordDate)=TO_DAYS(yesterday.RecordDate)+1 where today.Temperature>yesterday.Temperature
```
595. Big Countries

```mysql
select  name, population,area from World where area>3000000 or population>25000000
```
596. Classes More Than 5 Students


distinct
group+count

```mysql
select class from courses group by class having count(distinct student)>=5
```

620. Not Boring Movies

```mysql
select id, movie, description, rating from cinema where ID%2=1 and description!='boring' order by rating desc
```

627. Swap Salary

if函数

```mysql
update salary set sex=if(sex='m','f','m')
```



常见用法

+ in (select ...)
+ join ... on ...

+ group by ...

https://www.cnblogs.com/grandyang