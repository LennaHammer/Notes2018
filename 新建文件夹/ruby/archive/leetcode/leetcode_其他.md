
## Database

### 175. Combine Two Tables

+ LEFT JOIN µÄÓÃ·¨

```
select FirstName, LastName, City, State from Person left join Address on Person.PersonId = Address.PersonId
```

### 176. Second Highest Salary

```
select IFNULL((select distinct Salary from Employee order by Salary desc limit 1 offset 1 ), null) as SecondHighestSalary 
```

### 177. Nth Highest Salary

```
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
  SET N=N-1;
  RETURN (
    select IFNULL((select distinct Salary from Employee order by Salary desc limit 1 offset N), null)
  );
END
```

### 177. Nth Highest Salary



## Shell

### 192. Word Frequency

```
sed -r 's/ +/\n/g' words.txt|sed '/^$/d' |sort|uniq -c|sort -nr|awk '{print $2,$1}'
```


```
awk '{for(i=1;i<=NF;i++)A[$i]++;}END{for(x in A)print(x,A[x])}' words.txt| sort -rnk2,2
```

### 193. Valid Phone Numbers

```
grep -E '^\([0-9]{3}\) [0-9]{3}-[0-9]{4}$|^[0-9]{3}-[0-9]{3}-[0-9]{4}$' file.txt
```

### 194. Transpose File

```
awk '{for(i=1;i<=NF;i++)A[i]=A[i] " " $i}END{for(i=1;A[i];i++)print(substr(A[i],2))}' file.txt
```

### 195. Tenth Line

```
sed -n 10p file.txt
```