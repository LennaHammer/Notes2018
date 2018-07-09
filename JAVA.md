# Java Notes



## Spring

历史版本3.0

### IoC

用于运行时单实例对象的创建



在配置文件中构造对象，通过注入获取对象



Bean Factory

+ Application Context `applicationContext.xml `

Bean

+ id
+ class
+ property


Configuration

+ xml

   ```xml
    <bean id="..." class="...">
      <property name="..." ref="..." />
      <property name="..." value="..." />
    </bean>
   ```

+ annotation
  + `@Component` bean
  + `@Autowired` + interface 用于 field setter constructor
  + `@bean`



启动

+ ​



### AOP

`<aop:aspectj-autoproxy/>` 

+ Aspect

+ pointcut the pointcut expression String or @Pointcut
  + `execution` `@annotation` 
  + `&& this && target(...) && args(..., ...)`
+ Advice `@Before` `@After` `@Around` 

```java
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface LogExecutionTime{
    
};
@Aspect
@Component
public class ExampleAspect {
	@Around("@annotation(LogExecutionTime)")
    public Object logExecutionTime(ProceedingJoinPoint joinPoint) throws Throwable {
    	return joinPoint.proceed();
	}
}

```

 `@Around("execution(@com.stevenlanders.annotation.LogDuration * *(..)) && @annotation(logDurationAnnotation)")`

`@Around("@annotation(YourAnnotation) && execution(* *(..))")` 

Inteceptor

Annotation

+ @Target
+ @Retention

servlet 的 filter 和 spring mvc 的拦截器 都都可以起到类似的功能



## JDBC

Connection

DataSource

ResultSet

prepareStatement executeUpdate

```java
Connection con = DriverManager.getConnection(...);
try{
    PreparedStatement pstmt = con.prepareStatement("...");
    pstmt.setType(1, ...);
    ResultSet rs = pstmt.executeQuery();; // Cursor
}finally{
    if(pstmt!=null)
        pstmt.close();
}
```




```java

pstmt.execute(); //returns true for query and false for update
ResultSet rs = pstmt.executeQuery();
pstmt.executeUpdate(); // returns update count
while(rs.next()){
    Type value = rs.getType("column_name");
}
```



transaction 

```java
con.setAutoCommit(false);

con.commit(); // con.rollback(); 
```






## Servlet

用于 http 网络服务

### HttpServlet

+ `HttpServletResponse response`
+ `HttpServletRequest request`



### web.xml

File 片段 `WEB-INF/web.xml`

```xml
<servlet>
    <servlet-name>spring-mvc</servlet-name>
    <servlet-class>
        org.springframework.web.servlet.DispatcherServlet
    </servlet-class>
    <load-on-startup>1</load-on-startup>
</servlet>
<servlet-mapping>
    <servlet-name>spring-mvc</servlet-name>
    <url-pattern>/</url-pattern>
</servlet-mapping>
```



### Session



 

*Servlet*、Filter、Listener 事件

```xml
<listener>
<listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
</listener>
<filter>
<filter-name>characterEncodingFilter</filter-name>
<filter-class>
org.springframework.web.filter.CharacterEncodingFilter
</filter-class>
<init-param>
<param-name>encoding</param-name>
<param-value>UTF-8</param-value>
</init-param>
</filter>
<filter-mapping>
<filter-name>characterEncodingFilter</filter-name>
<url-pattern>/*</url-pattern>
</filter-mapping>
```

filter 有序

### jsp

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Hello World</title>
</head>
<body>
    <h1>${greeting}</h1>
    123456789
</body>
</html>
```



 request 对象



## Spring MVC

基于 Servlet

https://docs.spring.io/spring/docs/3.1.x/spring-framework-reference/html/mvc.html#mvc-ann-modelattrib-method-args

https://docs.spring.io/spring/docs/3.1.x/spring-framework-reference/html/mvc.html



### Configure

web.xml(servlet)

+ DispatcherServlet
+ ContextLoaderListener

```xml
  <listener>
    <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
  </listener>
  <context-param>
    <param-name>contextConfigLocation</param-name>
    <param-value>classpath:applicationContext.xml</param-value>
  </context-param>
	<servlet>
		<servlet-name>spring-mvc</servlet-name>
		<servlet-class>
			org.springframework.web.servlet.DispatcherServlet
		</servlet-class>
		<load-on-startup>1</load-on-startup>
	</servlet>

	<servlet-mapping>
		<servlet-name>spring-mvc</servlet-name>
		<url-pattern>/</url-pattern>
	</servlet-mapping>
    <filter>
        <filter-name>characterEncodingFilter</filter-name>
        <filter-class>
            org.springframework.web.filter.CharacterEncodingFilter
        </filter-class>
        <init-param>
            <param-name>encoding</param-name>
            <param-value>UTF-8</param-value>
        </init-param>
    </filter>
    <filter-mapping>
        <filter-name>characterEncodingFilter</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>
```



```xml
<web-app xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns="http://java.sun.com/xml/ns/javaee"
	xsi:schemaLocation="http://java.sun.com/xml/ns/javaeehttp://java.sun.com/xml/ns/javaee/web-app_3_0.xsd"
	id="WebApp_ID" version="3.0">
	<display-name>HelloWorldSpring</display-name>

	<servlet>
		<servlet-name>spring-mvc</servlet-name>
		<servlet-class>
			org.springframework.web.servlet.DispatcherServlet
		</servlet-class>
		<load-on-startup>1</load-on-startup>
	</servlet>

	<servlet-mapping>
		<servlet-name>spring-mvc</servlet-name>
		<url-pattern>/</url-pattern>
	</servlet-mapping>


	<!-- Other XML Configuration -->
	<!-- Load by Spring ContextLoaderListener -->
	<context-param>
		<param-name>contextConfigLocation</param-name>
		<param-value>/WEB-INF/root-context.xml</param-value>
	</context-param>


	<!-- Spring ContextLoaderListener -->
	<listener>
		<listener-class>org.springframework.web.context.ContextLoaderListener
		</listener-class>
	</listener>
</web-app>


```





spring-mvc-servlet.xml(spring-mvc)

+ component-scan `<context:component-scan base-package="*" />`
+ annotation-config `context:annotation-config`
+ `<mvc:annotation-driven />` 
+ InternalResourceViewResolver
+ mvc:resources

```xml
<context:component-scan base-package="*"/>
<context:annotation-config/>
<mvc:default-servlet-handler/>
<bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">
    <property name="prefix">
        <value>/WEB-INF/views/</value>
    </property>
    <property name="suffix" value=".jsp"></property>
</bean>
```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:p="http://www.springframework.org/schema/p"
    xmlns:context="http://www.springframework.org/schema/context"
    xmlns:mvc="http://www.springframework.org/schema/mvc"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
      http://www.springframework.org/schema/beans/spring-beans-4.1.xsd 
      http://www.springframework.org/schema/context
      http://www.springframework.org/schema/context/spring-context-4.1.xsd 
      http://www.springframework.org/schema/mvc
      http://www.springframework.org/schema/mvc/spring-mvc-4.1.xsd">
 
 
   <context:component-scan base-package="demo2"/>
    
   <context:annotation-config/>
    
   <bean
       class="org.springframework.web.servlet.view.InternalResourceViewResolver">
        
       <property name="prefix">
           <value>/WEB-INF/views/</value>
       </property>
        
       <property name="suffix">
           <value>.jsp</value>
       </property>       
        
   </bean>
    
</beans>
```

root-context.xml(Spring)



```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
   xsi:schemaLocation="http://www.springframework.org/schema/beans
   http://www.springframework.org/schema/beans/spring-beans.xsd">
     <bean id="dataSource" class="org.springframework.jdbc.datasource.DriverManagerDataSource">    
        <property name="driverClassName" value="com.mysql.jdbc.Driver" />    
        <property name="url" value="jdbc:mysql://localhost:3306/new_schema" />    
        <property name="username" value="root" />    
        <property name="password" value="root"/>    
    </bean>
        <bean id="jdbcTemplate"
        class="org.springframework.jdbc.core.JdbcTemplate" abstract="false" lazy-init="false" autowire="default">
        <property name="dataSource">
            <ref bean="dataSource" />
        </property>
    </bean>
</beans>


```

pom.xml(Maven)

+ spring-webmvc
+ jstl

```xml


```

手动 new

+ AnnotationConfigWebApplicationContext

RUN

+ 



### Component

@Component 被扫描，才能注入使用

+ ​

+ @Controller -->> (@Service -> @Repository）



### Controller 



class

+ `@Controller`
+ `@RequestMapping("/...")`

method

+ `@RequestMapping("/...")`
+ `@RequestMapping(value="/...",method=RequestMethod.GET)`
+ `@GetMapping("...")`   `@PostMapping(...)`

param

+ `@RequestParam("name")` 
+ `"/{name}"` -> `@PathVariable("name")`
+ HttpServletRequest
+ HttpServletResponse
+ `@ModelAttribute` Data Binding
  + every request `@ModelAttribute("person")`   before @RequestMapping
  + from form 
+ MultipartFile
+ session

Exception

+ `@ExceptionHandler(RuntimeException.class)  `

+ `@ResponseStatus class Exception `

+ 全局 `@ControllerAdvice` 

Response

+ view `Model model` `model.addAttribute("...","...")` ->  `return "view"`
+ redirect `return "redirect:/path"` 
+ `new ModelAndView("view", "command", new Item());`
+ string `@ResponseBody` 返回 String 或 Bean
+ status `new ResponseEntity(obj,  HttpStatus.OK)`

Interceptor

+ 



```java
@Controller
public class HelloController {
    @RequestMapping("/hello")
    public String hello(Model model) {
        model.addAttribute("hello");
        
        return "helloworld";
         
    }
 
}
```

https://spring.io/blog/2013/11/01/exception-handling-in-spring-mvc





@RestControllerAdvice





```java
@ExceptionHandler({ NullPointerException.class })
@ResponseStatus(value=HttpStatus.NOT_FOUND)
public void handleNullPointerException(Exception e) {
    e.printStackTrace();
}
```



Interceptor

HandlerInterceptorAdapter

```java
@Component
public class ApplicationControllerInterceptor extends HandlerInterceptorAdapter {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
        System.out.println("++++++++++");
        return super.preHandle(request, response, handler);
    }
}
```



```java
@Configuration
public class InterceptorConfig implements WebMvcConfigurer {

	@Autowired
	ApplicationControllerInterceptor interceptor;

	public void addInterceptors(InterceptorRegistry registry) {
		registry.addInterceptor(interceptor);
	}
}
```



### View

+ `<%@ page contentType="text/html; charset=UTF-8" %>` 
+ `<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>`
+ `<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">` 
+ `${...}`
+ `c:foreach`
+ `request.getAttribute`

```jsp
<%@ page contentType="text/html; charset=UTF-8" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
```



### Model

基于 jdbc

POJO bean

getter seter

```
class Data{
   
}
```



Data Access Object

​     

​     The DAO completely hides the data source implementation details from its clients. 



```java
interface DAO1{};
class DAO1Impl{
    private DataSource dataSource;
    public insertObject()
    public updateObject()
    public Object findById(int id)
    public findAll()
    public save
    boolean exists(int id)
}
```

@Repository



Service 

### Form

Controller

+ `ModelAndView` 
+ `@ModelAttribute("SpringWeb")` params 
+ @ModelAttribute method
+ binding

View
+ `<form:form method="POST" action="/..." modelAttribute="...">`

+ `path="..."`
  + `<form:label path="name1">Name 1</form:label>`
  + `<form:input path="name1" />`

表单验证
  + @Validated
  + form:errors 
  + BindingResult 

File 文件上传

  + class MultipartFile

   `<form:form method="POST" modelAttribute="fileUpload"
          enctype="multipart/form-data">`

  `<input type="file" name="file" />`

  

  

post

view

File upload

`@RequestParam("file") MultipartFile file`

### Validation

binding results



### Json

Controller

`@RestController`

= `@Controller @ResponseBody`

+ `@RequestBody`
+ `@ResponseBody`
+ `produces="application/json"` 
+ `@RequestMapping(value = "/all/{pageNum}/{pageSize}", produces = {"application/json;charset=UTF-8"})`

HttpMessageConverter

MappingJackson2HttpMessageConverter



response.sendRedirect("some-url");



MediaType

+ `Accept: */*`
+ Content-Type 

library `org.sf.json`

Jackson

format

pdf

excel



@RestController
@RequestMapping("/{userId}/bookmarks")

@ResponseStatus(HttpStatus.NOT_FOUND)
class UserNotFoundException extends RuntimeException {

	public UserNotFoundException(String userId) {
		super("could not find user '" + userId + "'.");
	}
}

### 文件上传



### Logger

###  

### Security

interceptor+

HandlerInterceptorAdapter 

```java
public boolean preHandle(HttpServletRequest request, 
	HttpServletResponse response, Object handler)
    throws Exception {
	
	long startTime = System.currentTimeMillis();
	request.setAttribute("startTime", startTime);
	
	return true;
}
```
authenticate

PreAuthorize

@PreAuthorize("hasRole('ADMIN') AND hasRole('DBA')")



## Spring Data
### Transactions

`@Transactional`

```xml
<tx:annotation-driven transaction-manager="txManager"/><!-- a PlatformTransactionManager is still required -->
<bean id="txManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
<!-- (this dependency is defined somewhere else) -->
    <property name="dataSource" ref="dataSource"/>
</bean>
```

### JdbcTemplate

```xml
    <bean id="dataSource" class="org.springframework.jdbc.datasource.DriverManagerDataSource">
    	<property name="driverClassName" value="oracle.jdbc.driver.OracleDriver" />
    	<property name="url" value="jdbc:oracle:thin:@192.168.0.159:1521:orcl" />
    	<property name="username" value="geologic" />
    	<property name="password" value="geologic" />
    </bean>
    <bean id="jdbcTemplate"
        class="org.springframework.jdbc.core.JdbcTemplate" abstract="false" lazy-init="false" autowire="default">
        <property name="dataSource">
            <ref bean="dataSource" />
        </property>
    </bean>
```



+ execute
+ query
+ update



```java
jdbcTemplate = new JdbcTemplate(dataSource);

jdbcTemplate.update("update ", ...);
jdbcTemplate query();
jdbcTemplate queryForList("select ...", ...); // all rows
jdbcTemplate queryForObject("select ...", ...); // first row
//jdbcTemplate queryForMap("select ...", ...);
```

 NamedParameterJdbcTemplate

BeanPropertyRowMapper







`@ExceptionHandler`





### JPA

`@Entity class`

`class CrudRepository`

JpaRepository

JpaRepository extends PagingAndSortingRepository which in turn extends CrudRepository.

@Data

@Entity

@Id
    @GeneratedValue(strategy = GenerationType.AUTO)

@ManyToOne
    @JoinColumn(name = "book_category_id")

@OneToMany(mappedBy = "bookCategory", cascade = CascadeType.ALL)

@ManyToMany
    @JoinTable(name = "user_role", joinColumns = @JoinColumn(name = "user_id"), inverseJoinColumns = @JoinColumn(name = "role_id"))
​    

@ManyToMany(mappedBy = "roles")

### Spring Data JPA

类

+ Repository
+ JpaRepository

类方法 Query

+ findById
+ findByNameAndPwd
+ findByIdBetween
+ findByNameNotNull 
+ findByNameLike 
+ findByNameStartingWith 
+ findByIdOrderByXDesc 
+ findByIdIn(Collection<?> c) 
+ findByAaaTrue 
+ findByNameIgnoreCase 
+ existisById

类方法

+ save(entity)
+ delete
+ count
+ find

方法 Modifying

+ setFixedFirstnameFor
+ 


## MyBatis

优点：方便映射到实体类，省去写 rowmapper，避免直接拼字符串

SqlSessionFactoryBuilder  XML 

SqlSessionFactory Singleton pattern

SqlSession session = sqlSessionFactory.openSession();

SqlSession Each thread 

Mapper



session.selectOne

session.getMapper

```java
public interface BlogMapper {
  @Select("SELECT * FROM blog WHERE id = #{id}")
  Blog selectBlog(int id);
}
```



MyBatis Generator

generatorConfig.xml

## Maven

管理项目依赖

+ `pom.xml`
+ `mvn clean install`
+ `war` 
+ `dependency:purge-local-repository` 

pom.xml

```xml
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-web</artifactId>
    <version>4.1.2.RELEASE</version>
</dependency>
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-webmvc</artifactId>
    <version>4.1.2.RELEASE</version>
</dependency>
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-jdbc</artifactId>
    <version>4.1.2.RELEASE</version>
</dependency>
<dependency>
    <groupId>javax.servlet</groupId>
    <artifactId>javax.servlet-api</artifactId>
    <version>3.0.1</version>
</dependency>
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>5.1.25</version>
</dependency>
```



运行



## MySQL

### Install



### Create

+ CREATE TABLE 
  + `create table if not exists table1 (id integer primary key , data text not null)`

  + ```sql
    CREATE TABLE IF NOT EXISTS `table1` (
        id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
        key VARCHAR(255) NOT NULL,
        value TEXT NOT NULL
    )ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ```

  + ​

  + Type(Length)

    + Numeric `INT` `FLOAT` `DOUBLE` `DECIMAL` 
    + String `VARCHAR(255)` `TEXT` 
    + Date and Time  `DATETIME ` 
    + Bytes `BLOB` 

  + INDEX

    + `CREATE INDEX` `ADD` 

  + Constraint

    + PRIMARY KEY AUTO_INCREMENT
    + NOT NULL
    + UNIQUE 
    + Foreigner Key
    + DEFAULT
    + CHECK

+ INDEX

  + CREATE INDEX `CREATE INDEX index_name ON table_name(column_name(length)); `
  + =, >, <, FK, UN
  + UNIQUE
  + 用于 select 中 where 和 order，配合 explain 查看
  + 对 NULL 无效

+ DROP TABLE `DROP TABLE table_name;`

+ ALTER TABLE 修改 column

  + ADD ... AFTER ...
  + DROP
  + RENAME
  + MODIFY 
  + CHANGE 
+ trigger


```mysql
CREATE TABLE `data` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
	`key` VARCHAR(160) NOT NULL,
	`value` TEXT NOT NULL,
	PRIMARY KEY (`id`),
	UNIQUE INDEX `key_unique` (`key`)
)
COLLATE='utf8mb4_bin'
ENGINE=InnoDB
;



```



### CRUD

+ SELECT
  + `select * from where id=?`
  + WHERE
    + EQUAL `=` `!=` 
    + RANGE `bewteen ... and ...`
    + LIST `in`
    + NULL `is null` `is not null` 
    + LIKE `colnum like "prefix%"` 
  + AS `select 1 as name`
  + ORDER  `select * order by id asc` (asc/desc)
  + LIMIT `select * from table1 limit 10 `
  + JOIN `select * from table1 join table2 on table1.id=table2.id` 
    + inner join, left join
  + Aggregation `select count(*) from table`
    + `count,sum` 
  + GROUP `select column1, count(1) group by column1`
    + HAVING
  + distinct `select distinct`, union `select ... union select ...`， union all
  + 嵌套 nested 
    + in (select ...)
+ INSERT
  + `insert table(columns) values (?)`
  + `insert into table1(columns) values (select columns from table2)` 
+ UPDATE 
  + `update table set value=? where key=?`
+ DELETE
  + `delete from table where id=?`

### Transaction

ACID 

+ Atomicity  Rollback
+ Consistency  
+ Isolation  Read uncommitted
+ Durability

BEGIN 或 START TRANSACTION

+ BEGIN
+ COMMIT
+ ROLLBACK

### Function

内置函数

+ 字符串 LEFT
+ 日期时间 datediff todays
+ 地理信息 

用户定义函数

储存过程

### 注意

避免类型转换

加索引

引擎必须指定 Innodb 支持事务 编码用 `utf8mb4` （不用名称 utf8 是历史兼容原因）

not null

isolation_level value is None, and permitted values are 'READ UNCOMMITTED', 'READ COMMITTED', 'REPEATABLE READ', and 'SERIALIZABLE'

分表

explain 查看 扫描的表行树，用的索引

lock 硬事务，软事务

复杂查询

cursor

explain

select row_number() over+

CONVERT

DATEDIFF

### Tools

CLI

+ 

GUI

+ MySQL Workbench
+ Navicat Premium
+ HeidiSQL



获得表的信息

SHOW columns FROM table_name

desc table_name

SHOW TABLE STATUS



备份表



DESCRIBE City;

{EXPLAIN | DESCRIBE | DESC}

explain select

+ type all index range
+ ​

https://dev.mysql.com/doc/workbench/en/wb-tutorial-visual-explain-dbt3.html



SELECT SEC_TO_TIME(SUM(TIME_TO_SEC(time_col))) FROM tbl_name;
SELECT FROM_DAYS(SUM(TO_DAYS(date_col))) FROM tbl_name;

https://dev.mysql.com/doc/refman/8.0/en/optimize-overview.html



window functions

COUNT(*) is somewhat different in that it returns a count of the number of rows retrieved, whether or not they contain NULL values.

COUNT(expr) Returns a count of the number of non-NULL values of expr

SELECT
         year, country, product, profit,
         SUM(profit) OVER() AS total_profit,
         SUM(profit) OVER(PARTITION BY country) AS country_profit
       FROM sales
       ORDER BY country, year, product, profit;

CUME_DIST()
DENSE_RANK()
FIRST_VALUE()
LAG()
LAST_VALUE()
LEAD()
NTH_VALUE()
NTILE()
PERCENT_RANK()
RANK()
ROW_NUMBER()

https://dev.mysql.com/doc/refman/8.0/en/mysql-indexes.html





sample standard deviation

sample variance

 the population standard variance



DATEDIFF(expr1,expr2)

TO_DAYS()	Return the date argument converted to days
TO_SECONDS()

select 1 from tablename where col = 'col' limit 1;

INSERT INTO table (a,b,c) VALUES (1,2,3)  ON DUPLICATE KEY UPDATE c=c+1; 

REPLACE INTO users (id,name,age) VALUES(123, '贾斯丁比伯', 22); 

MATCH() ... AGAINST 

 Full-Text Search Functions

https://dev.mysql.com/doc/refman/8.0/en/select-optimization.html



### ACID

locking 

concurrency



https://dev.mysql.com/doc/refman/8.0/en/glossary.html#glos_acid

isolation level
One of the foundations of database processing. Isolation is the I in the acronym ACID; the isolation level is the setting that fine-tunes the balance between performance and reliability, consistency, and reproducibility of results when multiple transactions are making changes and performing queries at the same time.

From highest amount of consistency and protection to the least, the isolation levels supported by InnoDB are: SERIALIZABLE, REPEATABLE READ, READ COMMITTED, and READ UNCOMMITTED.

With InnoDB tables, many users can keep the default isolation level (REPEATABLE READ) for all operations. Expert users might choose the READ COMMITTED level as they push the boundaries of scalability with OLTP processing, or during data warehousing operations where minor inconsistencies do not affect the aggregate results of large amounts of data. The levels on the edges (SERIALIZABLE and READ UNCOMMITTED) change the processing behavior to such an extent that they are rarely used.

See Also ACID, OLTP, READ COMMITTED, READ UNCOMMITTED, REPEATABLE READ, SERIALIZABLE, transaction.

ACID
An acronym standing for atomicity, consistency, isolation, and durability. These properties are all desirable in a database system, and are all closely tied to the notion of a transaction. The transactional features of InnoDB adhere to the ACID principles.

Transactions are atomic units of work that can be committed or rolled back. When a transaction makes multiple changes to the database, either all the changes succeed when the transaction is committed, or all the changes are undone when the transaction is rolled back.

The database remains in a consistent state at all times — after each commit or rollback, and while transactions are in progress. If related data is being updated across multiple tables, queries see either all old values or all new values, not a mix of old and new values.

Transactions are protected (isolated) from each other while they are in progress; they cannot interfere with each other or see each other's uncommitted data. This isolation is achieved through the locking mechanism. Experienced users can adjust the isolation level, trading off less protection in favor of increased performance and concurrency, when they can be sure that the transactions really do not interfere with each other.

The results of transactions are durable: once a commit operation succeeds, the changes made by that transaction are safe from power failures, system crashes, race conditions, or other potential dangers that many non-database applications are vulnerable to. Durability typically involves writing to disk storage, with a certain amount of redundancy to protect against power failures or software crashes during write operations. (In InnoDB, the doublewrite buffer assists with durability.)

See Also atomic, commit, concurrency, doublewrite buffer, isolation level, locking, rollback, transaction.

isolation level

+ SERIALIZABLE default(sql)
+ REPEATABLE READ default(mysql)  加 lock blocking non-repeatable reads but not phantom reads
  + It prevents any rows that are queried from being changed by other transactions, thus blocking non-repeatable reads but not phantom reads.
  + SELECT ... FOR UPDATE
+ READ COMMITTED 
+ READ_UNCOMMITTED 不用，脏读



| isolation level  | 默认   | dirty read | phantom | non-repeatable | locking |
| ---------------- | ------ | ---------- | ------- | -------------- | ------- |
| SERIALIZABLE     | SQL    | 无         | 无      | 无             |         |
| REPEATABLE READ  | InnoDB | 无         | 有      | 无             |         |
| READ COMMITTED   |        | 无         | 有      | 有             |         |
| READ_UNCOMMITTED |        | 有         | 有      | 有             |         |



+ 脏读
+ non-repeatable reads 被其他事务修改
+ phantom 行数不对，被其他事物增删
+ 

A row that appears in the result set of a query, but not in the result set of an earlier query. For example, if a query is run twice within a transaction, and in the meantime, another transaction commits after inserting a new row or updating a row so that it matches the WHERE clause of the query.



Pessimistic

Optimistic

deadlock detection



### DateTime

函数

YEAR(o_orderdate) = 1992 AND MONTH(o_orderdate)

### 备份

mysqldump -hhostname -uusername -ppassword -database databasename | gzip > backupfile.sql.gz




## Design Pattern

动机

+ 替换
+ 对象
+ 组合

对象创建 Creational patterns

+ Factory 创建对象的对象 实现 new 的 多态替换 Abstract factory 实现为 factory 对象 的替换  Factory method 
+ Builder  例如 `StringBuilder`
+ Singleton 实现 全局对象
+ Prototype 原型

行为 Behavioral patterns

+ Command 实现 undo
+ ​
+ Observer 实现 事件 event 订阅 subscribe ，MVC 中触发视图的变化
+ Iterator 迭代
+ Visitor 复合类型的迭代 Interpreter 迭代时解释运行

组合 Structural patterns

+ Composite 实现 Sum Type
+ Adapter 改变接口 Decorator 增加功能 Proxy
+ State 不用 switch 语句实现状态机
+ Memento 保存当前状态
+ Chain of responsibility 实现 Filter

Concurrency patterns

+ Lock
+ ​

## Java 基础

### collections

### 并发

collection

lock



## Date time 

## JSON

```java
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
```

85570979

```
JSONObject.fromObject(...).toString();
```

Map.of

Arrays.asList

Jackson



## IDE

Ecplise

+ 快捷键 `Ctrl+/` 补全
+ 快捷键 `Ctrl+1` 修正
+ 插件 Spring

web project

deploy

clean/build

jetbrains

vscode

+ 快捷键 `Ctrl+P` 切换文件

## git

git

git add

git commit

git push

git pull git fetch followed by a git merge.

## Deploy

上线

### Linux

### MySQL



### Nginx

负载均衡

反向代理

### Tomcat

`.war` 放入 `webapps`



## Test

## Bootstrap

layout

content

table

components

utilities



Platform

+ desktop
+ mobile

layout 网格布局

+ container `.container `  ` container-fluid` 顶层一个

+ row `.row` 
  + footer

+ column `.col-*` 列， 一共 12 列 

  + 手持设备可以转成行Stack  `.col-sm-*` 

  + `xs 576px sm 768px md 992px lg 1200px`
  + 网格 固定 流动 按比例
  + 响应性
  + 堆栈 浮动

样式

+ 对齐
+ 标记

功能元素

+ nav `.navbar` 

+ header

  - `.navbar ` 属性 `navbar-dark`  `.navbar-expand `

+ footer

+ table

+ button `.btn` 属性 ``

  + `.dropdown` 

+ Pagination

  ```html
  <ul class="pagination">
    <li class="page-item disabled"><a class="page-link" href="#" tabindex="-1">&laquo;</a></li>
    <li class="page-item active"><a class="page-link" href="#">1</a></li>
    <li class="page-item "><a class="page-link" href="#">2</a></li>
    <li class="page-item"><a class="page-link" href="#">3</a></li>
    <li class="page-item"><a class="page-link" href="#">&raquo;</a></li>
  </ul>
  ```

+ card

状态

+ callback

+ Modal 遮罩窗体

mobile

+ break

CSS 样式



CSS 实现



```css
body {
    margin: 0;
}
.container {
    margin-right: auto;
    margin-left: auto;
}
.clear{
    clear: both;
}
```

float:left

有一些可视化的布局工具



### Mobile



## Angular

Vue



从事件变成渲染。



## HTML



整体

```html
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>...</title>
        <link href="***.css" rel="stylesheet"/>
        <script type="text/javascript" src="***.js"></script>
    </head>
    <body>
        ...
    </body>
</html>
```



功能

+ heading `<h1>...</h1>`
+ list `<ul><li>...</li><li>...</li></ul>` 
+ link `<a href="...">...</a>`
+ image `<img src="..." alt="...">`
+ table `<table>...</table>`
  + 行 tr 列 td
+ blockquote `<blockquote>...</blockquote>`
+ paragraph `<p>...</p>` 
+ text `<b>...</b>` `<i>...</i>` 

块

+ div `<div class="...">...</div>` block
+ span `<span class="...">...</span>` inline

FORM 表单

+ form action method `<form method="..." action="...">...</form>`

+ label

+ input

  + `<input type="hidden" name="..." value="..."/>`

  + `<input type="" value="Submit"/>`

  + `<input type="submit" value="Submit"/>`
  + checkbox
  + radio `<input name="..." type="radio" value="..." checked="checked"/>`

+ textarea rows cols

+ check_box `<input type="checkbox" id="article_validated" name="article[validated]" value="1" />`

样式 Style

+ ​

HTML 4

+ `<font>...</font>`
+ `<b>...</b>` `<i>...</i>`
+ 表格布局



## CSS

### Style

width width:100%;

margin 外边距

图片

+ `float: left;` 图像和文本的关系

空元素 `<div stype="clear: both;"></div>`

margin 边距 padding border

居中

文本

+ font-size 行高  
+ line-height

background-color

display:inline

display:block

position: absolute;

border-radius: 5px; */

### Layout

空间

+ 背景 background 颜色 图片
+ 边框
+ 大小 width height 单位 px %
+ 间距 外边距 内边距
+ 居中

分栏布局

+ 分栏浮动 `<div style="float: left; width=30%;"></div>`
+ 清除浮动`<div style="clear: both;"></div>`

绝对布局

position: absolute;









## JavaScript



### Vanilla

plain javascript

+ select `document.querySelectorAll`
+ document.createElement .appendChild
+ ajax `var xhr = new XMLHttpRequest(); ` ` xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');`
  + xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');



setTimeout



```javascript
function $(){
    
}
function select(selector){
    return document.querySelectorAll(selector)
}

$.ajax = function(opt){
    var url = opt['url'];
    var method = opt['method'] || 'GET';
    var data = opt['data'];
    var success = opt['success'];
    var xhr = new XMLHttpRequest();
    xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');    
}
$.prototype.each = function(html){
    
};
$.prototype.html = function(html){
    
};
$.prototype.css = function(html){
    
};
$.prototype.attr = function(html){
    
};
$.prototype.show = function(html){
    
};
$.prototype.hide = function(html){
	return this.css("display", "none")
};
```

https://www.cnblogs.com/xiaohuochai/p/7526278.html

Zepto.js



### JQuery

AJAX

DOM 事件

```javascript
$("...").html(...);
              
$("...").click(function(){
    ...
});
   
$.get("...", ...)
```



### require.js

单网页应用管理多 js 文件

http://handlebarsjs.com/

http://www.embeddedjs.com/

https://mustache.github.io/

http://www.vogella.com/tutorials/JavaServerFaces/article.html

### tinyMCE



自动补全输入框

## HTTP

header

+ `Content-Type` 



Request

+ method
+ `Keep-Alive`

Response

+ Status Code 200 3 404 500

Get

Post

+ Form
  + `application/x-www-form-urlencoded` 
  + upload file `multipart/form-data`
+ TEXT 
  + `application/json` 



URLConnection

1、+ URL 中+号表示空格 %2B 
2、空格 URL中的空格可以用+号或者编码 %20 
3、 / 分隔目录和子目录 %2F 
4、 ? 分隔实际的 URL 和参数 %3F 
5、 % 指定特殊字符 %25 
6、# 表示书签 %23 
7、 & URL 中指定的参数间的分隔符 %26 
8、 = URL 中指定参数的值 %3D



## TCP/IP

socket

frame

packet



## Spring Boot

`Web devtools MySQL JDBC JPA`



web devtools mybatis jdbc mysql  lambok



```java
@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
```



pom.xml

```xml
<dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-tomcat</artifactId>
        <scope>provided</scope>
</dependency>
```

执行 `dependency:purge-local-repository` 

配置

端口



```properties
server.port=8004
```

 连接 mysql

```ini
spring.jpa.hibernate.ddl-auto=create
spring.datasource.url=jdbc:mysql://localhost:3306/database1
spring.datasource.username=root
spring.datasource.password=root
spring.jpa.database-platform=org.hibernate.dialect.MySQL5Dialect  
```



@ComponentScan(basePackages = "com.test.app")

@Transactional @EnableTransactionManagement



模块

日志模块

工作流引擎

treeview 模块

## Back-end

role 团队分工

+ Customer
+ Project Manager
+ 前端 后端

## Domain 

system

user

+ role/group
+ login
+ logout
+ permission

Work Flow

+ Process
+ State
+ Transition
+ Action approve(next) deny(back) cancel restart resolve
+ Request
+ Activities activity
+ User
+ Group
+ Permission 发起的权限



办公 OA



系统模块

首页（浏览咨询，头+轮播+分栏）

登录界面（大背景图+登录框）

后台操作界面（上方tab导航+左侧+正文）

文章发布（加自定义栏目，分栏目，固定栏目（友情链接等）的编辑）

咨询系统（留言，回复，显示发布）

目录树（可修改结构，增删节点），分发数据（加权限，加自定义表格，录入编辑浏览导出）

购物车（添加到购物车，下单，看订单状态）

审批系统（审批流程，流程可修改）

用户和权限，（设置用户信息，登录，登出，修改密码，修改用户信息，设定用户的权限）

消息箱（提醒）

页面设计 + 数据库的设计 实例



注意可修改可配置的部分



结构

博客 浏览博文 评论（发送，显示） 后台管理（登录，编辑博文，删除评论）

+ 文章
+ 评论
+ 后台 新建文章 编辑文章 删除评论
+ 辅助 搜索

论坛

+ 用户
+ 帖子
+ 板块

购物 查询 购买

电商

+ 用户 User 顾客
+ 购物车 Cart
+ 订单 Order 订单商品
+ 商品 Goods
+ 搜索 Search
+ 目录 Index
+ 后台 增加商品 处理订单

页面设计 

tab栏目





Excel

+ 输入有效性

+ 汇总

+ 图表

Access

+ 表格
+ 关系
+ 表单 绑定 数据源
+ 报表









## Advance

进阶

提高补充



spring



mysql

外键 引用 枚举项可变

数据库范式 

Database Normalization

 Normal Form 

dependencies

Functional dependency

函数依赖 x->y eg. id->name

传递依赖 x->y /\ y->z => x->z

1NF Atomic columns

2NF 依赖于主键 No partial dependencies

3NF 不存在传递依赖 No transitive dependencies

BCNF 

读写事务隔离



## Redis教程



## GIS

mysql

GEOMETRY

类型

GEOMETRY（内部格式）

POINT

LINESTRING

POLYGON

查询 

+ 用ST_AsText
+ MBRContains 

SELECT ST_AsText(ST_GeomFromText(@mp));

插入 用ST_GeomFromText



索引SPATIAL INDEX(



Well-Known Text (WKT) Format（文本格式）

`ST_GeomFromText(...)` 文本格式转内部格式

`ST_AsText ` 内部格式转文本格式

sharp



point

POLYGON((120.152627724 30.312151179, 120.1528202 30.310101329, 120.160247752 30.302236616, 120.161226136 30.295942228, 120.157295087 30.2945869, 120.14327573 30.30942543, 120.150616189 30.313894475, 120.152627724 30.312151179))

MULTIPOLYGON(((120.15302015 30.299728037, 120.157295087 30.2945869, 120.154759368 30.293816328, 120.15390814 30.295835673, 120.149698396 30.29459818, 120.145101432 30.301637696, 120.145511434 30.306987958, 120.15302015 30.299728037)), ((120.166818473 30.347120822, 120.170087744 30.339075233, 120.173948414 30.339344393, 120.152627724 30.312151179, 120.150616189 30.313894475, 120.14327573 30.30942543, 120.141016643 30.327011727, 120.144558281 30.327347644, 120.143775266 30.333254667, 120.132787036 30.333070584, 120.132409346 30.342810367, 120.143129909 30.342728101, 120.142859251 30.345866931, 120.15037414 30.345158958, 120.149370328 30.343615841, 120.150635425 30.342854044, 120.153161203 30.343635488, 120.152889449 30.345879629, 120.155226536 30.345065427, 120.154990106 30.3476505, 120.156930075 30.347246025, 120.157441212 30.345070776, 120.160915423 30.346207469, 120.161816258 30.344771021, 120.166818473 30.347120822)))



地图 arcgis



3D

坐标 

屏幕坐标系 真实世界的坐标系 

地理坐标的转换 经纬度坐标

Camera 

cesrum 地球3d显示

无人机自动 3d 建模

数据

GeoJson

3D Tiles  tileset.json

open layer

leaflet

## 数据可视化

excel

plot

ECharts - Java类库 ECharts-Ja

## [分布式 RPC 服务框架 Dubbo [推](https://www.oschina.net/p/dubbo) 

分布式系统协调 ZooKeeper



## [分布式系统基础架构 Hadoop ](https://www.oschina.net/p/hadoop) 

## [分布式搜索引擎 ElasticSearch ](https://www.oschina.net/p/elasticsearch) 

## 集成测试工具 Selenium

Java 常用工具包 Jodd  推荐
常用工具包

guava



uuid



## References

+ https://docs.oracle.com/javase/tutorial/index.html
  + https://docs.oracle.com/javase/tutorial/jdbc/index.html
+ https://www.tutorialspoint.com/jdbc/index.htm
+ http://spring.io/guides
+ https://docs.spring.io/spring/docs/current/javadoc-api/
+ http://grepcode.com/file/repository.grepcode.com/java/root/jdk/openjdk/6-b14
+ https://docs.oracle.com/javaee/6/tutorial/doc/bnafd.html
+ https://docs.spring.io/spring/docs/current/spring-framework-reference/
+ https://docs.spring.io/spring/docs/current/spring-framework-reference/web.html
+ https://dev.mysql.com/doc/refman/8.0/en/data-types.html
+ http://jsfiddle.net
+ https://www.tutorialspoint.com/online_bootstrap_editor.php
+ https://www.runoob.com/try/bootstrap
+ https://www.layoutit.com/build
+ ​
+ https://bootstrapstudio.io/
+ https://www.tutorialspoint.com/springaop/
+ https://hellokoding.com/registration-and-login-example-with-spring-security-spring-boot-spring-data-jpa-hsql-jsp/
+ http://stateless.co/hal_specification.html
+ http://phlyrestfully.readthedocs.io/en/latest/halprimer.html
+ https://www.drupal.org/docs/8/core/modules/workflows/overview
+ https://www.google.com
+ https://www.bing.com



http://wuyuan.io/tutorials

补充


```
Permissions for an Action
Workflows
States
Transitions
```
