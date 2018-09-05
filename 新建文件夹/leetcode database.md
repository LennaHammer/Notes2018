# Leetcode Database

## Problems

### 175. Combine Two Tables

```mysql
select FirstName, LastName, City, State from Person p left join Address a on p.PersonId=a.PersonId
```

### 176. Second Highest Salary

```mysql
select ifnull((select distinct Salary from Employee order by Salary desc limit 1,1),null)  as SecondHighestSalary
```

### 177. Nth Highest Salary 

```mysql
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
  SET N=N-1;
  RETURN (
    select IFNULL((select distinct Salary from Employee order by Salary desc limit 1 offset N), null)
  );
END
```

```sql
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
  declare skip integer;
  set skip = N - 1;
  RETURN (
    select IFNULL((select distinct Salary from Employee order by Salary desc limit 1 offset skip), null)
  );
END
```


### 178. Rank Scores


```mysql
select Score, (select count(distinct Score) from Scores b where b.Score>a.Score)+1 Rank from Scores a order by Score desc
```

用子查询

```oracle
select round(Score,2) Score, dense_rank() over(order by Score desc) Rank from Scores
```

用窗口函数

```mysql
select a.Score,count(distinct b.Score) Rank from Scores a, Scores b where b.Score>=a.Score group by a.Id order by a.Score desc
```

用 cross product + group + 聚合函数


### 180. Consecutive Numbers

解法一

```sql
select distinct Num ConsecutiveNums from Logs x where (
    select count(*) from Logs where Id between x.Id and x.Id+2 and Num=x.Num)=3
```


解法二

```sql
select distinct a.Num ConsecutiveNums from Logs a, Logs b where b.Id between a.Id and a.Id+2 and b.Num=a.Num group by a.Id having count(b.Id)=3
```


解法三

```sql
select distinct a.Num ConsecutiveNums
from Logs a 
join Logs b on a.Id+1=b.Id 
join Logs c on b.Id+1=c.Id 
where a.Num=b.Num and b.Num=c.Num
```


解法四

```sql
select distinct Num ConsecutiveNums
from (
    select Num, @c:=if(@x=Num,@c+1,1) n, @x:=Num
    from Logs a, (select @x:=null,@c:=0) b
) t
where t.n=3
```


### 181. Employees Earning More Than Their Managers 

```mysql
select Name as Employee from Employee e where Salary > (select Salary from Employee where Id=e.ManagerId)
```

子查询

or

```mysql
select employee.Name as Employee from Employee employee join Employee manager on employee.ManagerId=manager.Id where employee.Salary > manager.Salary
```

join


### 182. Duplicate Emails

```mysql
select Email from Person group by Email having count(1)>1
```

### 183. Customers Who Never Order 

in (select ...)

```mysql
select Name as Customers from Customers where Id not in (select CustomerId from Orders)
```

### 184. Department Highest Salary

解法一

```oracle
select t2.Name Department, t1.Name Employee, t1.Salary Salary 
from (
    select Employee.*,rank() over(partition by DepartmentId order by Salary desc) r from Employee
) t1 
join Department t2 on t1.DepartmentId = t2.Id 
where r=1
```

用窗口函数

ORA-00923: FROM keyword not found where expected
https://www.techonthenet.com/oracle/errors/ora00923.php


解法二


```sql
select c.Name Department, a.Name Employee, a.Salary Salary
from Employee a
join (
    select DepartmentId, max(Salary) Salary from Employee group by DepartmentId
) b on a.DepartmentId=b.DepartmentId and a.Salary=b.Salary
join Department c on a.DepartmentId=c.Id
```

用 join + group

注意：group用非by的字段是错的，且容易导致错误，mysql不会报错。

解法三

```sql
select a.Name Department, b.Name Employee, b.Salary Salary
from Department a
join (
    select * 
    from Employee a 
    where not exists (select * from Employee where DepartmentId=a.DepartmentId and Salary>a.Salary)
) b on a.Id=b.DepartmentId
```

用子查询，not exists 即 `(select count(1) from ... limit 1) !=0`


其他写法（用子查询）

```sql
select a.Name Department, b.Name Employee, b.Salary Salary
from Department a
join (
    select * 
    from Employee a 
    where (select count(distinct Salary) from Employee where DepartmentId=a.DepartmentId and Salary>=a.Salary)=1
) b on a.Id=b.DepartmentId
```


```sql
select a.Name Department, b.Name Employee, b.Salary Salary
from Department a
join (
    select * from Employee a
    where a.Id not in (
        select a.Id
        from Employee a, Employee b
        where a.DepartmentId = b.DepartmentId
        and a.Salary < b.Salary
        group by a.Id
    )
) b on a.Id=b.DepartmentId
```


```sql
select a.Name Department, b.Name Employee, b.Salary Salary
from Department a
join (
    select * from Employee a
    where a.Id in (
        select a.Id
        from Employee a, Employee b
        where a.DepartmentId = b.DepartmentId
        and a.Salary <= b.Salary
        group by a.Id
        having count(distinct b.Salary)=1
    )
) b on a.Id=b.DepartmentId
```

```sql
select a.Name Department, b.Name Employee, b.Salary Salary
from Department a
join (
    select a.* from Employee a
    join (
        select a.Id
        from Employee a, Employee b
        where a.DepartmentId =b.DepartmentId
        and a.Salary <= b.Salary
        group by a.Id
        having count(distinct b.Salary)=1
    ) b on a.Id=b.Id
) b on a.Id=b.DepartmentId
```


### 185. Department Top Three Salaries

```sql
select a.Name Department, b.Name Employee, b.Salary Salary
from Department a
join (
    select * 
    from Employee a 
    where (select count(distinct Salary) from Employee where DepartmentId=a.DepartmentId and Salary>a.Salary)<3
) b on a.Id=b.DepartmentId
```

用子查询



### 196. Delete Duplicate Emails

delete
group

```mysql
delete from Person where Id not in (select t.Id from (select min(Id) Id from Person group by Email) t)
```

删除 delete

按 min(Id)



### 197. Rising Temperature

时间运算

```mysql
select today.Id from Weather today join Weather yesterday on TO_DAYS(today.RecordDate)=TO_DAYS(yesterday.RecordDate)+1 where today.Temperature>yesterday.Temperature
```


### 595. Big Countries

```mysql
select  name, population,area from World where area>3000000 or population>25000000
```


### 596. Classes More Than 5 Students


distinct
group+count

```mysql
select class from courses group by class having count(distinct student)>=5
```

### 620. Not Boring Movies

```mysql
select id, movie, description, rating from cinema where ID%2=1 and description!='boring' order by rating desc
```

### 626. Exchange Seats

```sql
select 
    case when id%2=0 then id-1 when id%2=1 and id=c then id else id+1 end id,
    student
from seat a, (select count(*) c from seat) b
order by id
```


```sql
select * 
from (
    select
    case id%2 
    when 1 then id+1 
    else id-1
    end id, student
from seat a, (select count(*) c from seat) b
where 
    case c%2
    when 0 then true
    else id < c 
    end
union all select
    id, student
from seat a, (select count(*) c from seat) b
where c%2=1 and id=c) t
order by id
```

用 union

### 627. Swap Salary

if 函数

```sql
update salary set sex=if(sex='m','f','m')
```


```sql
update salary set sex = case when sex='m' then 'f' else 'm' end
```


```sql
update salary set sex = case sex when 'm' then 'f' else 'm' end
```


## 说明

常见用法

+ in (select ...)
+ join ... on ...

+ group by `select key, max(value) from tables group by key`

+ 子查询
+ 选择 投影 汇总


+ select count(*) from table limit 1


+ https://www.cnblogs.com/grandyang
+ https://www.sqlite.org/lang_select.html
+ https://dev.mysql.com/doc/refman/8.0/en/window-functions-usage.html



语句


常用函数

日期时间 date
字符串

参考资料

+ mysql
+ sqlite
+ sql server



SELECT
         year, country, product, profit,
         ROW_NUMBER() OVER(PARTITION BY country) AS row_num1,
         ROW_NUMBER() OVER(PARTITION BY country ORDER BY year, product) AS row_num2
       FROM sales;


group==distinct

注意性能优化！！！

+ 用尽量简单的写法
+ where 和 order 有对应的索引
+ join 会先循环行数少的表，性能可能优于子查询
+ 一些常规问题别人的写法






