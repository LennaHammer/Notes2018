# Java Notes



## Spring

历史版本3.0

### IoC

用于运行时单实例对象的创建



在配置文件中构造对象，通过注入获取对象



Bean Factory

+ ApplicationContext interface
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
  + `@Component` bean 用于自动扫描
  + `@Autowired` + interface 用于 field setter constructor
  + `@Bean` 用于 @Configuration



启动

+ ​



### AOP

`<aop:aspectj-autoproxy/>` 

+ Aspect
+ pointcut the pointcut expression String or @Pointcut
  + `execution` `@annotation` 
  + `&& this && target(...) && args(..., ...)`
+ Advice `@Before` `@After` `@Around` 



custom annotations

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



aop stack



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
+ HttpServletRequest request
+ HttpServletResponse response



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

## Socket



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

通过xml使用。



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



### Create Table

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

  + Constraint

    + PRIMARY KEY AUTO_INCREMENT
    + NOT NULL
    + UNIQUE 
    + Foreigner Key
    + DEFAULT
    + CHECK

+ INDEX

  + CREATE INDEX `CREATE INDEX index_name ON table_name(column_name(length)); `
  + ADD
  + =, >, <, FK, UN
  + UNIQUE
  + 用于 select 中 where 和 order使用索引，配合 explain 查看
  + 对 NULL 无效
  + 复合索引

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

### Index

用途 where, order, column

联合索引：只查询上的数据，查询最左的前缀

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
    + inner join, left join 用来补空缺值
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

Convert(decimal(18,2),ca

convert(value,type)



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

ROW_NUMBER() OVER (
ORDER BY OPERATION_DATE DESC) AS rank

substr(string string,num start,num length);

string为字符串；

start为起始位置；

length为长度。

区别：

mysql中的start是从1开始的，而hibernate中的start是从0开始的。



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

1、A (Atomicity) 原子性

原子性很容易理解，也就是说事务里的所有操作要么全部做完，要么都不做，事务成功的条件是事务里的所有操作都成功，只要有一个操作失败，整个事务就失败，需要回滚。

比如银行转账，从A账户转100元至B账户，分为两个步骤：1）从A账户取100元；2）存入100元至B账户。这两步要么一起完成，要么一起不完成，如果只完成第一步，第二步失败，钱会莫名其妙少了100元。

2、C (Consistency) 一致性

一致性也比较容易理解，也就是说数据库要一直处于一致的状态，事务的运行不会改变数据库原本的一致性约束。

例如现有完整性约束a+b=10，如果一个事务改变了a，那么必须得改变b，使得事务结束后依然满足a+b=10，否则事务失败。

3、I (Isolation) 独立性

所谓的独立性是指并发的事务之间不会互相影响，如果一个事务要访问的数据正在被另外一个事务修改，只要另外一个事务未提交，它所访问的数据就不受未提交事务的影响。

比如现在有个交易是从A账户转100元至B账户，在这个交易还未完成的情况下，如果此时B查询自己的账户，是看不到新增加的100元的。

4、D (Durability) 持久性

持久性是指一旦事务提交后，它所做的修改将会永久的保存在数据库上，即使出现宕机也不会丢失。

### DateTime

函数

YEAR(o_orderdate) = 1992 AND MONTH(o_orderdate)

### 备份

mysqldump -hhostname -uusername -ppassword -database databasename | gzip > backupfile.sql.gz



利用嵌套select给group by 的字段起别名

=(select max)

join max group by on =

ROW_NUMBER 数值相同也会进行连续

RANK() 相同的两名是并列

over(partition by course order by score desc)

will return 1 for every row that is the newest per name and subject, ROW_NUMBER

 row_number() over (partition by number order by id) as seqnum
      from t
     ) t
where seqnum = 1;



下列等价

where COUNT(*) =0

LEFT JOIN RESULTS AS t2
  ON t1.NAME = t2.NAME AND t1.SUBJECT = t2.SUBJECT AND t1.YEAR < t2.YEAR
WHERE t2.NAME IS NULL

where not exists


Analyze Table
Collect statistics about the table that can be used by the query optimizer to find a better plan.

Optimizer
Optimized Logical Plan

Aggregate 
Project 
 Join Inner
 Filter


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

ArrayList

HashMap

+ synchronizedMap
+ LinkedHashMap



### concurrent 并发

thread

synchronized 

volatile

线程池

transient volatile









java.util.concurrent

Collection

+ ConcurrentHashMap<K,V> 锁分段
+ ArrayBlockingQueue
+ Atomic

Lock 阻塞超时

+ ReentrantLock
+ ReadWriteLock

Atomic

+ ::compareAndSet

ThreadPoolExecutor

+ Future future = executorService.submit(new Callable
+ ScheduledExecutorService

ForkJoinPool 

http://tutorials.jenkov.com/java-concurrency/index.html

### annotation



### Datetime 



formatter

SimpleDateFormat 格式 

SimpleDateFormat dd=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

Date 不可变

Calendar 可变

运算

```java
Calendar cal = Calendar.getInstance();
cal.setTime(...)
cal.add(Calendar.HOUR_OF_DAY, hours);
var datetime = cal.getTime()
```



解析

```java
SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
var datetime = formatter.parse(date)
String s = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(datetime);

```



格式化

```java
Date findTime = new Date();
SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
String str = formatter.format(findTime);
```



### JSON

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

### Stream

去重
```java
list = list.stream().distinct().collect(Collectors.toList());
```


## IDE

Ecplise

+ 快捷键 `Ctrl+/` 补全
+ 快捷键 `Ctrl+1` 修正
+ Ctrl+单击 跳转
+ 插件 Spring

web project

deploy

clean/build

jetbrains

vscode

+ 快捷键 `Ctrl+P` 切换文件





debug ssql sysout（sql）

## git

概念

stage

任务

创建

+ git init

提交

+ git add

+ git commit

+ git push

获取

+ git clone
+ git pull



git

git add

git commit

git push

git pull git fetch followed by a git merge.



stage 暂存区



创建

+ init, clone

修改

+ add, commit, rm, mv
  + `git commit -m "message"` 
+ status, diff
+ reset HEAD

分支

+ branch, checkout, merge 

远程

+ remote
+ push 
+ pull = fetch+merge

## BASH

命令



## Deploy

部署

### Linux

### MySQL



### Nginx

负载均衡

反向代理

### Tomcat

`.war` 放入 `webapps`

### 压力测试

工具 jmeter？

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

```css
box-sizing: border-box;

```



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

### components

Thumbnails

```html
<div class="row">
  <div class="col-xs-6 col-md-3">
    <a href="#" class="thumbnail">
      <img src="..." alt="...">
    </a>
  </div>
  ...
</div>
```

栏数可以根据屏幕宽度变化
显示的图片加了底框

http://www.tutorialspoint.com/bootstrap/bootstrap_thumbnails.htm

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

### 文本

字体
+颜色 color 
+字体 font 大小 font-size (单位 px 像素 em 继承父元素的字体倍数)
+修饰 text-decoration

段落
+ 对齐 text-align 
+ 行高 line-height 缩进

### 边框底纹
+ 背景 颜色 图片
+ 边框 样式 宽度 颜色
+ 衬距 padding

### 编号方式
列表样式

### 定位

+ 环绕样式 `float:left` `clear:both`
+ 定位样式
+ 位置与大小

Box

### 布局

滚动条 `overflow : auto`

布局
+ 居中 `margin: 0 auto`, `text-align:center`
绝对布局
+ `position: absolute; width: 451px; height: 92px; z-index: 1; left: 243px; top: 51px;`
+ `margin:0; padding:0; `
分栏布局
+ `float:left:width:50%`,




Aural


margin: 0;
box-sizing: border-box;

Normalize.css

响应式图片
max-width 100%，height:auto

## CSS （废弃）
### text

颜色

+ color 名称 #RGBA
  + aqua, black, blue, fuchsia, gray, green, lime, maroon, navy, olive, orange, purple, red, silver, teal, white, yellow。

字体

+ font 顺序 font-style, font-variant, font-weight, font-stretch, font-size, line-height, and font-family. 

+ font-style font-weight text-decoration
	 font-family Arial 	sans-serif Courier New 	monospace Times New Roman 	serif
+ serif, sans-serif, monospace, cursive,和 fantasy. 
+ font-size px 像素 em 继承父元素的字体倍数

文本布局

+ text-align
+ line-height

### Box

背景
background

+ background-color  background-image 
 padding

display 属性为 inline inline-block

+ width, height 内容框（content box）的宽度和高度 默认情况下 width 被设置为可用空间的100%  height默认设置为content的高度。

+ padding 

+ border `border-radius: 20px;`

+ margin  居中 margin: 0 auto;



Overflow

+ Overflow visible auto

  width: 70%;
  max-width: 1280px;
  min-width: 480px;

  box-sizing调整盒模型。 用值 border-box margin  0
  总宽度是它的  width， padding-right，padding-left，border-right和border-left margin属性之和
  box-sizing调整盒模型。 用值 border-box

### Layout  

文档流

floats 和 positioning

分栏

Flexbox



### Mobile



HSL **色相**、**饱和度**以及**明度值** 

函数

transform: rotate(45deg);
/* calculate the new position of an element after it has been moved across 50px and down 60px */
transform: translate(50px, 60px);
/* calculate the computed value of 90% of the current width minus 15px */
width: calc(90%-15px);
/* fetch an image from the network to be used as a background image */
background-image: url('myimage.png');


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
+ 清除浮动 `<div style="clear: both;"></div>`

绝对布局

position: absolute;









## JavaScript

### Core



Date

+ `Date.parse("...")` 为当前时区
+ `new Date().getTime()`

Date.parse 使用本地时区

 如果参数字符串只包含日期格式，那么将会使用UTC时区

格林尼治标准时间（GMT

协调世界时(UTC)  

 GMT +8





隐式类型转换规则

等号规则
+ 
加号规则
+ 
类型转换规则
转换成数字


正则表达式

+ search -> Number
+ match -> array
+ test boolean
+ exec -> match
+ lastIndex 

### DOM

+ byid
+ document.createElement .appendChild

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

```javascript
$.get( "ajax/test.html", function( data ) {
  $( ".result" ).html( data );
  alert( "Load was performed." );
});
```

post form json raw

JSON.stringify

```javascript
$.ajax({
    type: "post",
    url: "sync", //your valid url
    contentType: "application/json", //this is required for spring 3 - ajax to work (at least for me)
    data: JSON.stringify(jsonobject), //json object or array of json objects
    success: function(result) {
        //do nothing
    },
    error: function(){
        alert('failure');
    }
});
```



显示隐藏元素

+ show、hide
+ toggleClass display

输出内容

+ html(...)
+ append

Ajax

+ form
+ json JSON.stringify
+ file
+ 跨域 jsonp ，服务器配置

绑定事件

+ click
+ 冒泡 `event.preventDefault();`

模式

+ 进入返回
+ 跳转



### require.js

单网页应用管理多 js 文件++



requirejs-text



http://handlebarsjs.com/

http://www.embeddedjs.com/

https://mustache.github.io/

http://www.vogella.com/tutorials/JavaServerFaces/article.html

### tinyMCE



自动补全输入框

 var a = document.createElement('a')
    // 创建一个单击事件
    var event = new MouseEvent('click')
    

```javascript
var a = document.createElement('a');
a.download = name || '导出表格.xls';
a.href = uri + base64(format(template, ctx));
document.body.appendChild(a);
a.click();
```
### 效果

拖动图层

### 插件

zTree
debugger;

### Vue


### webpack/babel





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

网际互联及OSI七层模型：

物理层、数据链路层、网络层、传输层、表示层、会话层、应用层

==========================================

物理层

作用：定义一些电器，机械，过程和规范，如集线器；

PDU(协议数据单元)：bit/比特

设备：集线器HUB;

注意：没有寻址的概念；

==========================================

数据链路层

作用：定义如何格式化数据，支持错误检测；

典型协议：以太网，帧中继（古董级VPN）

PDU：frame（帧）设备：以太网交换机；

备注：交换机通过MAC地址转发数据，逻辑链路控制；

===========================================

网络层

作用：定义一个逻辑的寻址，选择最佳路径传输，路由数据包；

典型协议：IP，IPX，ICMP,ARP(IP->MAC),IARP;

PDU:packet/数据包；

设备：路由器

备注：实现寻址

============================================

传输层：

作用：提供可靠和尽力而为的传输；

典型协议：TCP,UDP,SPX,port(65535个端口),EIGRP,OSPF,

PDU:fragment 段；

无典型设备；

备注：负责网络传输和会话建立；

=============================================

会话层：

作用：控制会话，建立管理终止应用程序会话；

典型协议：NFS, SQL, ASP, PHP, JSP, RSVP(资源源预留协议), windows， 

备注：负责会话建立；

==============================================

表示层：

作用：格式化数据；

典型协议：ASCII, JPEG. PNG, MP3. WAV, AVI, 

备注：可以提供加密服务；

===============================================

应用层：

作用：控制应用程序；

典型协议：telant, ssh, http, ftp, smtp, rip, BGP, (未完待续)

备注：为应用程序提供网络服务；

================================================

Q：什么时候有PDU？

A：当需要跟别人通信时候才有。

TCP/IP 介绍
TCP/IP 是用于因特网 (Internet) 的通信协议。

计算机通信协议（Computer Communication Protocol）
计算机通信协议是对那些计算机必须遵守以便彼此通信的的规则的描述。

什么是 TCP/IP？
TCP/IP 是供已连接因特网的计算机进行通信的通信协议。

TCP/IP 指传输控制协议/网际协议（Transmission Control Protocol / Internet Protocol）。

TCP/IP 定义了电子设备（比如计算机）如何连入因特网，以及数据如何在它们之间传输的标准。

在 TCP/IP 内部
在 TCP/IP 中包含一系列用于处理数据通信的协议：

TCP (传输控制协议) - 应用程序之间通信
UDP (用户数据报协议) - 应用程序之间的简单通信
IP (网际协议) - 计算机之间的通信
ICMP (因特网消息控制协议) - 针对错误和状态
DHCP (动态主机配置协议) - 针对动态寻址
TCP 使用固定的连接
TCP 用于应用程序之间的通信。

当应用程序希望通过 TCP 与另一个应用程序通信时，它会发送一个通信请求。这个请求必须被送到一个确切的地址。在双方"握手"之后，TCP 将在两个应用程序之间建立一个全双工 (full-duplex) 的通信。

这个全双工的通信将占用两个计算机之间的通信线路，直到它被一方或双方关闭为止。

UDP 和 TCP 很相似，但是更简单，同时可靠性低于 TCP。

IP 是无连接的
IP 用于计算机之间的通信。

IP 是无连接的通信协议。它不会占用两个正在通信的计算机之间的通信线路。这样，IP 就降低了对网络线路的需求。每条线可以同时满足许多不同的计算机之间的通信需要。

通过 IP，消息（或者其他数据）被分割为小的独立的包，并通过因特网在计算机之间传送。

IP 负责将每个包路由至它的目的地。

IP 路由器
当一个 IP 包从一台计算机被发送，它会到达一个 IP 路由器。

IP 路由器负责将这个包路由至它的目的地，直接地或者通过其他的路由器。

在一个相同的通信中，一个包所经由的路径可能会和其他的包不同。而路由器负责根据通信量、网络中的错误或者其他参数来进行正确地寻址。

TCP/IP
TCP/IP 意味着 TCP 和 IP 在一起协同工作。

TCP 负责应用软件（比如您的浏览器）和网络软件之间的通信。

IP 负责计算机之间的通信。

TCP 负责将数据分割并装入 IP 包，然后在它们到达的时候重新组合它们。

IP 负责将包发送至接受者。

TCP/IP 寻址
TCP/IP 使用 32 个比特或者 4 组 0 到 255 之间的数字来为计算机编址。

IP地址
每个计算机必须有一个 IP 地址才能够连入因特网。

每个 IP 包必须有一个地址才能够发送到另一台计算机。

在本教程下一节，您会学习到更多关于 IP 地址和 IP 名称的知识。

IP 地址包含 4 组数字：
TCP/IP 使用 4 组数字来为计算机编址。每个计算机必须有一个唯一的 4 组数字的地址。

每组数字必须在 0 到 255 之间，并由点号隔开，比如：192.168.1.60。

32 比特 = 4 字节
TCP/IP 使用 32 个比特来编址。一个计算机字节是 8 比特。所以 TCP/IP 使用了 4 个字节。

一个计算机字节可以包含 256 个不同的值：

00000000、00000001、00000010、00000011、00000100、00000101、00000110、00000111、00001000 ....... 直到 11111111。

现在，您应该知道了为什么 TCP/IP 地址是介于 0 到 255 之间的 4 组数字。

IP V6
IPv6 是 "Internet Protocol Version 6" 的缩写，也被称作下一代互联网协议，它是由 IETF 小组（Internet 工程任务组Internet Engineering Task Force）设计的用来替代现行的 IPv4（现行的）协议的一种新的 IP 协议。

我们知道，Internet 的主机都有一个唯一的 IP 地址，IP 地址用一个 32 位二进制的数表示一个主机号码，但 32 位地址资源有限，已经不能满足用户的需求了，因此 Internet 研究组织发布新的主机标识方法，即 IPv6。

在 RFC1884 中（RFC 是 Request for Comments document 的缩写。RFC 实际上就是 Internet 有关服务的一些标准），规定的标准语法建议把 IPv6 地址的 128 位（16 个字节）写成 8 个 16 位的无符号整数，每个整数用 4 个十六进制位表示，这些数之间用冒号（:）分开，例如：

686E：8C64：FFFF：FFFF：0：1180：96A：FFFF
冒号十六进制记法允许零压缩，即一串连续的0可以用一对冒号取代，例如：

FF05：0：0：0：0：0：0：B3可以定成：FF05：：B3
为了保证零压缩有一个清晰的解释，建议中规定，在任一地址中，只能使用一次零压缩。该技术对已建议的分配策略特别有用，因为会有许多地址包含连续的零串。

冒号十六进制记法结合有点十进制记法的后缀。这种结合在IPv4向IPv6换阶段特别有用。例如，下面的串是一个合法的冒号十六进制记法：

0：0：0：0：0：0：128.10.1.1
这种记法中，虽然冒号所分隔的每一个值是一个16位的量，但每个分点十进制部分的值则指明一个字节的值。再使用零压缩即可得出：

：：128.10.1.1
域名
12 个阿拉伯数字很难记忆。使用一个名称更容易。

用于 TCP/IP 地址的名字被称为域名。runoob.com 就是一个域名。

当你键入一个像 http://www.runoob.com 这样的域名，域名会被一种 DNS 程序翻译为数字。

在全世界，数量庞大的 DNS 服务器被连入因特网。DNS 服务器负责将域名翻译为 TCP/IP 地址，同时负责使用新的域名信息更新彼此的系统。

当一个新的域名连同其 TCP/IP 地址一起注册后，全世界的 DNS 服务器都会对此信息进行更新。

TCP/IP 协议
TCP/IP 是不同的通信协议的大集合。

协议族
TCP/IP 是基于 TCP 和 IP 这两个最初的协议之上的不同的通信协议的大集合。

TCP - 传输控制协议
TCP 用于从应用程序到网络的数据传输控制。

TCP 负责在数据传送之前将它们分割为 IP 包，然后在它们到达的时候将它们重组。

IP - 网际协议（Internet Protocol）
IP 负责计算机之间的通信。

IP 负责在因特网上发送和接收数据包。

HTTP - 超文本传输协议(Hyper Text Transfer Protocol)
HTTP 负责 web 服务器与 web 浏览器之间的通信。

HTTP 用于从 web 客户端（浏览器）向 web 服务器发送请求，并从 web 服务器向 web 客户端返回内容（网页）。

HTTPS - 安全的 HTTP（HTTP Secure）
HTTPS 负责在 web 服务器和 web 浏览器之间的安全通信。

作为有代表性的应用，HTTPS 会用于处理信用卡交易和其他的敏感数据。

SSL - 安全套接字层（Secure Sockets Layer）
SSL 协议用于为安全数据传输加密数据。

SMTP - 简易邮件传输协议（Simple Mail Transfer Protocol）
SMTP 用于电子邮件的传输。

MIME - 多用途因特网邮件扩展（Multi-purpose Internet Mail Extensions）
MIME 协议使 SMTP 有能力通过 TCP/IP 网络传输多媒体文件，包括声音、视频和二进制数据。

IMAP - 因特网消息访问协议（Internet Message Access Protocol）
IMAP 用于存储和取回电子邮件。

POP - 邮局协议（Post Office Protocol）
POP 用于从电子邮件服务器向个人电脑下载电子邮件。

FTP - 文件传输协议（File Transfer Protocol）
FTP 负责计算机之间的文件传输。

NTP - 网络时间协议（Network Time Protocol）
NTP 用于在计算机之间同步时间（钟）。

DHCP - 动态主机配置协议（Dynamic Host Configuration Protocol）
DHCP 用于向网络中的计算机分配动态 IP 地址。

SNMP - 简单网络管理协议（Simple Network Management Protocol）
SNMP 用于计算机网络的管理。

LDAP - 轻量级的目录访问协议（Lightweight Directory Access Protocol）
LDAP 用于从因特网搜集关于用户和电子邮件地址的信息。

ICMP - 因特网消息控制协议（Internet Control Message Protocol）
ICMP 负责网络中的错误处理。

ARP - 地址解析协议（Address Resolution Protocol）
ARP - 用于通过 IP 来查找基于 IP 地址的计算机网卡的硬件地址。

RARP - 反向地址转换协议（Reverse Address Resolution Protocol）
RARP 用于通过 IP 查找基于硬件地址的计算机网卡的 IP 地址。

BOOTP - 自举协议（Boot Protocol）
BOOTP 用于从网络启动计算机。

PPTP - 点对点隧道协议（Point to Point Tunneling Protocol）
PPTP 用于私人网络之间的连接（隧道）。

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

cache

@Component

+ 



ReactiveRedisTemplate

RedisTemplate

StringRedisTemplate



### Cache

@EnableCaching 



方法

- @Cacheable("books")
- @CachePut(cacheNames="book", key="#isbn")
- @CacheEvict

spring.cache.redis.*

### Task

Schedule

TaskExecutor @Scheduled

@Async
Future<String>





## Netty

### java.Nio

buffer 是一个 queue
select 是同步阻塞的

### 拆包


## Back-end

role 团队分工

+ Customer
+ Project Manager
+ 前端 后端

## Debug

浏览器断点

后台断点

简单的原型

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







## 后台系统

用户 User

角色 Role

权限 p

菜单 Menu

+ Tree
+ Role

表格 Table

+ 分页
+ 排序
+ 过滤
+ 搜索
+ 导出 Excel

表单 Form

+ 表单提交
+ 表单验证
+ 数据绑定 通过控件的 name 和 value 
+ 单选框，多选框

远程调用 ajax restful

本地异步调用

+ 回调函数

图表

+ chart
+ map

工作流

+ 状态 State 状态视图
+ 事件 Event 转变



## 项目沟通

需求

计划

实现

测试



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

POINT   (x,y) 经度 纬度

+ 函数 X Y

距离 st_distance

POLYGON   多边形 

+ Area 面积

Spatial index

how far two points differ, or whether points fall within a spatial area of interest

最小边界矩形（MBR）

+ MBRContains(g1,g2)  g1的最小边界矩形是否包含g2的最小边界矩形。例如判断点在多边形内

https://blog.csdn.net/zzq900503/article/details/17142621

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
+ st_distance
+ ST_Contains
+ 

SELECT ST_AsText(ST_GeomFromText(@mp));

插入 用ST_GeomFromText ST_GeomFromText('POINT(116.405289 39.904987)');  



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

cesrum 地球3d显示(炫酷)

无人机自动 3d 建模

数据

GeoJson

3D Tiles  tileset.json

open layer

leaflet+

http://www.tianditu.com/



bigemap 地图瓦片下载





shp 文件 转 wkt 格式的文本 MULTIPOLYGON






ArcGlobe
ArcMap
ArcServer

wms、wmts协议

### Leaflet


图层

地图 多图层 天地图服务

标注 
+ 点（经纬度） 折线（边界） 鼠标事件（显示信息图层）onMouseMove
+ 标绘工具

投影

```js
var crs = new L.Proj.CRS(
                'EPSG:4326',
                "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs", {
                    origin: [-180.0, 90],
                    resolutions: res
                });
```

### CesiumJS

Cesium3DTileset
contesxtcapture4.3
倾斜摄影无人机倾斜摄影

## 数据可视化

excel

plot

ECharts - Java类库 ECharts-Ja

显示表格

显示 Chart

+ 折线图
+ 直方图

导出 Excel

导出 Pdf

## 3D

变换
glTranslatef(); glScaled(); glRotatef()
model Matrix

视角
摄像机

画图
点
线
面

渲染
光

## three.js

Vector3

translation, rotation, shear, scale, reflection, orthogonal or perspective projection


Object
点、线、面

Camera
透视，平行


https://en.wikipedia.org/wiki/Transformation_matrix

Geometry 
顶点

法线，面的方向
Material 材质

纹理 texture 贴图，法线

Light 光照
+ Ambient Light

Phong shading model

GLSL shader 
 vertex shader 与 fragment shader
 gl_Position
 gl_FragColor
uniforms and attributes 






内置的特殊变量
glsl程序使用一些特殊的内置变量与硬件进行沟通.他们大致分成两种 一种是 input类型,他负责向硬件(渲染管线)发送数据. 另一种是output类型,负责向程序回传数据,以便编程时需要.

在 vertex Shader 中:

output 类型的内置变量:

变量	说明	单位
highp vec4 gl_Position;	gl_Position 放置顶点坐标信息	vec4
mediump float gl_PointSize;	gl_PointSize 需要绘制点的大小,(只在gl.POINTS模式下有效)	float
在 fragment Shader 中:

input 类型的内置变量:

变量	说明	单位
mediump vec4 gl_FragCoord;	片元在framebuffer画面的相对位置	vec4
bool gl_FrontFacing;	标志当前图元是不是正面图元的一部分	bool
mediump vec2 gl_PointCoord;	经过插值计算后的纹理坐标,点的范围是0.0到1.0	vec2
output 类型的内置变量:

变量	说明	单位
mediump vec4 gl_FragColor;	设置当前片点的颜色	vec4 RGBA color
mediump vec4 gl_FragData[n]	设置当前片点的颜色,使用glDrawBuffers数据数组	vec4 RGBA color

官方的shader范例:
下面的shader如果你可以一眼看懂,说明你已经对glsl语言基本掌握了.

Vertex Shader:

uniform mat4 mvp_matrix; //透视矩阵 * 视图矩阵 * 模型变换矩阵
uniform mat3 normal_matrix; //法线变换矩阵(用于物体变换后法线跟着变换)
uniform vec3 ec_light_dir; //光照方向
attribute vec4 a_vertex; // 顶点坐标
attribute vec3 a_normal; //顶点法线
attribute vec2 a_texcoord; //纹理坐标
varying float v_diffuse; //法线与入射光的夹角
varying vec2 v_texcoord; //2d纹理坐标
void main(void)
{
 //归一化法线
 vec3 ec_normal = normalize(normal_matrix * a_normal);
 //v_diffuse 是法线与光照的夹角.根据向量点乘法则,当两向量长度为1是 乘积即cosθ值
 v_diffuse = max(dot(ec_light_dir, ec_normal), 0.0);
 v_texcoord = a_texcoord;
 gl_Position = mvp_matrix * a_vertex;
}
Fragment Shader:

precision mediump float;
uniform sampler2D t_reflectance;
uniform vec4 i_ambient;
varying float v_diffuse;
varying vec2 v_texcoord;
void main (void)
{
 vec4 color = texture2D(t_reflectance, v_texcoord);
 //这里分解开来是 color*vec3(1,1,1)*v_diffuse + color*i_ambient
 //色*光*夹角cos + 色*环境光
 gl_FragColor = color*(vec4(v_diffuse) + i_ambient);
}

https://www.cnblogs.com/brainworld/p/7445290.html

There are three types of variables in shaders: uniforms, attributes, and varyings:

Uniforms are variables that have the same value for all vertices - lighting, fog, and shadow maps are examples of data that would be stored in uniforms. Uniforms can be accessed by both the vertex shader and the fragment shader.
Attributes are variables associated with each vertex---for instance, the vertex position, face normal, and vertex color are all examples of data that would be stored in attributes. Attributes can only be accessed within the vertex shader.
Varyings are variables that are passed from the vertex shader to the fragment shader. For each fragment, the value of each varying will be smoothly interpolated from the values of adjacent vertices.

document.getElementById( 'vertexShader' ).textContent

## Leaflet

wkt格式 坐标 边界

投影方式，目前支持的地图投影方式有：EPSG:900913(墨卡托投影)，EPSG:4326(大地平面投影)。

WGS84坐标经纬度与网络墨卡托(Web Mercator)投影坐标

wmts 服务影像数据


Equirectangular projection
WGS 84: EPSG Projection EPSG:4326 天地图用这个 GPS 用这个


Spherical Mercator projection
Web Mercator EPSG3857 也叫 EPSG:900913  WMS 服务用这个 默认 leaflet 用这个

Coordinate Reference Systems (CRS), which are EPSG:3857.

国内加密坐标GCJ-02以WGS 84为基础偏移。

geographical coordinates into coordinates in units 

Represents a geographical point with a certain latitude and longitude.


esri-leaflet

服务URL：
CGCS2000，经纬度：
全球矢量中文注记服务：http://t0.tianditu.com/cva_c/wmts
全球矢量地图服务：http://t0.tianditu.com/vec_c/wmts
全球影像地图服务：http://t0.tianditu.com/img_c/wmts
CGCS2000，web墨卡托：
全球矢量中文注记服务：http://t0.tianditu.com/cva_w/wmts
全球矢量地图服务：http://t0.tianditu.com/vec_w/wmts
全球影像地图服务：http://t0.tianditu.com/img_w/wmts

    visibility: visible;
    position: absolute;
    right: 20px;
    top: 20px;
    width: 50px;
    height: 50px;
    background-image: url(../img/map-vec.png);
    cursor: pointer;

    visibility: hidden;
    position: absolute;
    z-index: 100;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;

    visibility: visible;
    position: absolute;
    top: 20px;
    left: 50%;
    margin-left: -145px;
    padding: 5px;
    background-color: #2d89e7;
    border-radius: 5px;
    -webkit-border-radius: 5px;
    -moz-border-radius: 5px;
    z-index: 20;


## Redis

Cache

后台任务

发布订阅



## 分布式 RPC 服务框架 Dubbo

分布式系统协调 ZooKeeper



## 分布式系统基础架构 Hadoop 

##[分布式搜索引擎 ElasticSearch

提交更新

AOP？

## Nginx

反向代理
负载均衡



## Selenium

Java 常用工具包 Jodd  推荐
常用工具包

guava



uuid

## NoSQL

关系运算

projection



### Redis

key-value存储



Memchche,



当分布式缓存集群需要扩容的时候

先构造一个长度为232的整数环（这个环被称为一致性Hash环），根据节点名称的Hash值（其分布为[0, 232-1]）将缓存服务器节点放置在这个Hash环上，然后根据需要缓存的数据的Key值计算得到其Hash值（其分布也为[0, 232-1]），然后在Hash环上顺时针查找距离这个Key值的Hash值最近的服务器节点

虚拟节点





哈希(Hash)

列表(List)

发布订阅 pub/sub

当有新消息通过 PUBLISH 命令发送给频道 channel1 时， 这个消息就会被发送给订阅它的三个客户端：

事务 MULTI 不是原子性的。

类型	简介	特性	场景
String(字符串)	二进制安全	可以包含任何数据,比如jpg图片或者序列化的对象,一个键最大能存储512M	---
Hash(字典)	键值对集合,即编程语言中的Map类型	适合存储对象,并且可以像数据库中update一个属性一样只修改某一项属性值(Memcached中需要取出整个字符串反序列化成对象修改完再序列化存回去)	存储、读取、修改用户属性
List(列表)	链表(双向链表)	增删快,提供了操作某一段元素的API	1,最新消息排行等功能(比如朋友圈的时间线) 2,消息队列
Set(集合)	哈希表实现,元素不重复	1,添加、删除,查找的复杂度都是O(1) 2,为集合提供了求交集、并集、差集等操作	1,共同好友 2,利用唯一性,统计访问网站的所有独立ip 3,好用推荐时,根据tag求交集,大于某个阈值就可以推荐
Sorted Set(有序集合)	将Set中的元素增加一个权重参数score,元素按score有序排列	数据插入集合时,已经进行天然排序	1,排行榜 2,带权重





集群

+ 主从
+ 分片
+ 哨兵
+ 客户端



### MongoDB
文档存储

分布式文件存储的开源数据库系统

术语

+ database,	database
	 table,	collection
	 row,	document
	 column,	field
	 index,	index
+ table joins,
	 primary key,	primary key

id

+ `"_id":ObjectId(...)`

查询

分片

关系

+ 嵌入
+ 引用

索引

索引数组字段 会为 music、cricket、blogs三个值建立单独的索引。

索引子文档字段

explain

indexOnly: 字段为 true ，表示我们使用了索引。
cursor：因为这个查询使用了索引，MongoDB 中索引存储在B树结构中，所以这是也使用了 BtreeCursor 类型的游标。如果没有使用索引，游标的类型是 BasicCursor。这个键还会给出你所使用的索引的名称，你通过这个名称可以查看当前数据库下的system.indexes集合（系统自动创建，由于存储索引信息，这个稍微会提到）来得到索引的详细信息。
n：当前查询返回的文档数量。
nscanned/nscannedObjects：表明当前这次查询一共扫描了集合中多少个文档，我们的目的是，让这个数值和返回文档的数量越接近越好。
millis：当前查询所需时间，毫秒数。
indexBounds：当前查询具体使用的索引。

hint 强制 MongoDB 使用一个指定的索引。

索引不能被以下的查询使用：

正则表达式及非操作符，如 $nin, $not, 等。
算术运算符，如 $mod, 等。
$where 子句

原子操作

+ findAndModify 

MapReduce 

map ：映射函数 (生成键值对序列,作为 reduce 函数参数)。
reduce 统计函数，reduce函数的任务就是将key-values变成key-value，也就是把values数组变成一个单一的值value。。
out 统计结果存放集合 (不指定则使用临时集合,在客户端断开后自动删除)。
query 一个筛选条件，只有满足条件的文档才会调用map函数。（query。limit，sort可以随意组合）
sort 和limit结合的sort排序参数（也是在发往map函数前给文档排序），可以优化分组机制
limit 发往map函数的文档数量的上限（要是没有limit，单独使用sort的用处不大）

```javascript
db.collection.mapReduce(
   function() {emit(key,value);},  //map 函数
   function(key, values) {return reduceFunction},   //reduce 函数
   {
      out: collection,
      query: document,
      sort: document,
      limit: number
   }
)
```



GridFS

### ElasticSearch

全文搜索

GET http://localhost:9200/_search?q = name:central

节点统计

此API用于检索集群的一个节点的统计信息。节点状态与集群几乎相同。 例如，



### Cassandra  
列存储 

HBase
面向列的数据库是存储数据表作为数据列的部分，而不是作为行数据。总之它们拥有列族。

列族

'Column family:column name'

grant命令授予特定的权限，如读，写，执行和管理表给定一个特定的用户。 grant命令的语法如下：

hbase> grant <user> <permissions> [<table> [<column family> [<column; qualifier>]]

我们可以从RWXCA组，其中给予零个或多个特权给用户

R - 代表读取权限
W - 代表写权限
X - 代表执行权限
C - 代表创建权限
A - 代表管理权限

Tutorialspoint



Cassandra具有能够处理大量数据的分布式架构。 数据放置在具有多个复制因子的不同机器上，以获得高可用性，而无需担心单点故障。

Cassandra是一个面向列的数据库。

Cassandra中的数据复制
在Cassandra中，集群中的一个或多个节点充当给定数据片段的副本。如果检测到一些节点以过期值响应，Cassandra将向客户端返回最近的值。返回最新的值后，Cassandra在后台执行读修复以更新失效值。

下图显示了Cassandra如何在集群中的节点之间使用数据复制，以确保没有单点故障的示意图。

布隆过滤器 - 这些只是快速，非确定性的算法，用于测试元素是否是集合的成员。它是一种特殊的缓存。 每次查询后访问Bloom过滤器。

Cassandra的主要组成部分主要有：

节点(Node)：Cassandra节点是存储数据的地方。
数据中心(Data center)：数据中心是相关节点的集合。
集群(Cluster)：集群是包含一个或多个数据中心的组件。
提交日志(Commit log)：在Cassandra中，提交日志是一个崩溃恢复机制。 每个写入操作都将写入提交日志。
存储表(Mem-table)：内存表是内存驻留的数据结构。 提交日志后，数据将被写入内存表。 有时，对于单列系列，将有多个内容表。
SSTable：当内容达到阈值时，它是从内存表刷新数据的磁盘文件。
布鲁姆过滤器(Bloom filter)：这些只是快速，非确定性的，用于测试元素是否是集合成员的算法。 它是一种特殊的缓存。 每次查询后都会访问Bloom过滤器。

Cassandra查询语言(CQL)用于通过其节点访问Cassandra。 CQL将数据库(Keyspace)视为表的容器。 程序员使用cqlsh：提示使用CQL或单独的应用程序语言驱动程序。
客户端可以接近任何节点进行读写操作。 该节点(协调器)在客户机和保存数据的节点之间扮演代理。

Cassandra被许多零售商用于购物车数据保持和快速的产品目录输入和输出。

社交媒体分析和推荐引擎
Cassandra是许多在线公司和社交媒体提供商的良好数据库，用于分析和推荐给客户。

键空间(Keyspace)是用于保存列族

CREATE (TABLE | COLUMNFAMILY) <tablename>  

KeyspaceName.TableName   

## Search

## Redis



LRU Cache

+ maxmemory
+ allkeys-lru
+ volatile-ttl
+ volatile-lru



The volatile-lru and volatile-random policies are mainly useful when you want to use a single instance for both caching and to have a set of persistent keys. However it is usually a better idea to run two Redis instances to solve such a problem.



 Transactions 

+ 隔离性
+ 原子性 (失败，不支持回滚)
+ MULTI + (QUEUED) + EXEC
+ 

Persistence

+ 



类型

+ String

Hash

List

Set

SortedSet

Pub/Sub



## RabbitMQ

Task Queue

Introduction

+ messages
+ producer 发送消息
+ queue
+ consumer 等待消息，一直运行
+ api connection 
+ exchange
+ broker





Work queues (Task Queues)

+ consuming tasks among multiple workers.
+ Message acknowledgment 任务完成时发送 ack，否则会重试
+ Message durability/message persistence 仍然不完全可靠
+ Fair dispatch

Publish/Subscribe

+ deliver a message to multiple consumers
+ broadcast log messages
+ the producer can only send messages to an exchange
+ exchange  broadcasts all the messages it receives to all the queues it knows
+ exchange types available: direct, topic, headers and fanout
+ Bindings That relationship between exchange and a queue is called a binding.queue_bind(exchange='logs',
         queue=
+ fanout exchange type
+ 匿名队列

Routing

+ routing_key  binding key
+ direct 

Topics

+ `*`(star) can substitute for exactly one word.
+ `#` (hash) can substitute for zero or more words.
+ fanout direct
+ Severity syslog

 RPC

+ wait for the result

+ Bearing that in mind, consider the following advice:

  Make sure it's obvious which function call is local and which is remote.
  Document your system. Make the dependencies between components clear.
  Handle error cases. How should the client react when the RPC server is down for a long time?

+ callback_queue

+ reply_to = callback_queue

+ create a single callback queue per client. correlation_id

+ the restarted RPC server will process the request again. That's why on the client we must handle the duplicate responses gracefully, and the RPC should ideally be idempotent.



Consumer Acknowledgements and Publisher Confirms

+ Both features build on the same idea and are inspired by TCP. 
+ delivery tag
+ When Consumers Fail or Lose Connection: Automatic Requeueing
+  idempotence
+ For persistent messages routed to durable queues, this means persisting to disk.
+ Applications should not depend on the order of acknowledgements when possible.

Time-To-Live Extensions



Java Spring AMQP

+ RabbitTemplate



发送方本地消息表+接收方消费状态表



异步事务

事务

锁

可靠消息，TCC，最大努力通知

未收到确认消息，主动询问。

等幂性，通过记录单号。

锁

第一阶段，写入binlog；第二阶段执行commit或者rollback。这就是著名的两阶段提交协议（2PC）



论文中提出的解决方法是将更新交易表记录和用户表更新消息放在一个本地事务来完成，为了避免重复消费用户表更新消息带来的问题，增加一个操作记录表updates_applied来记录已经完成的交易相关的信息。记录编号。



解决方法很简单，在余额宝这边增加消息应用状态表（message_apply），通俗来说就是个账本，用于记录消息的消费情况，每次来一个消息，在真正执行之前，先去消息应用状态表中查询一遍，如果找到说明是重复消息，丢弃即可，如果没找到才执行，同时插入到消息应用状态表（同一事务）。





分布式，paxos算法。





## 分布式



消息系统

队列 点对点消息系统

发布-订阅消息系统

分布式的发布 - 订阅消息传递系统和一个强大的队列

用例。 其中一些列在下面 -

指标 - Kafka通常用于运营监控数据。 这涉及从分布式应用程序汇总统计数据以生成操作数据的集中式提要。
日志聚合解决方案 - Kafka可以在整个组织中使用，从多个服务中收集日志，并以标准格式向多个消费者提供。
流处理 - 流行的框架(如Storm和Spark Streaming)可以从主题读取数据，对其进行处理，并将处理后的数据写入新主题，以供用

ZooKeeper是一个分布式协调服务来管理大量的主机。协调和管理在分布式环境的一个服务是一个复杂的过程。ZooKeeper 简单解决了其结构和API这个问题。ZooKeeper允许开发人员能够专注于核心应用程序逻辑，而无需担心应用程序的分布式特性。

Apache ZooKeeper是由群集（组节点）之间进行相互协调，并保持强大的同步技术共享数据的服务。ZooKeeper本身是一个分布式应用写入分布式应用提供服务。

ZooKeeper 提供的通用服务如下-

命名服务 − 确定在一个集群中的节点的名字。它类似于DNS，只不是过节点。

配置管理 − 系统最近加入节点和向上最新配置信息。

集群管理 − 加入/节点的群集和节点状态实时离开。

节点领导者选举 − 选举一个节点作为领导者协调的目的。

锁定和同步服务 − 锁定数据，同时修改它。这种机制可以帮助自动故障恢复，同时连接其它的分布式应用程序。如Apache HBase。

高可靠的数据注册表 − 一个或几个节点的可用性的数据向下。

## Spring Cloud

熔断，降级



### eureka 

服务发现和注册

@EnableEurekaServer



### zuul 微服务网关

@EnableZuulProxy



routes 路由

Filter

 [spring cloud 学习(6) - zuul 微服务网关](https://www.cnblogs.com/yjmyzz/p/spring-cloud-zuul-demo.html)

## Debug

断点 breakpoint



step in

step over

时区问题



IETester

https://www.my-debugbar.com/wiki/IETester/HomePage

## Excel

数据透视表 = group by

## BASH



文本编辑

+ vi

+ sed



查找文件

+ grep

+ find



输出报表

wc

awk



文件操作

+ cp
+ mv
+ mkdir



控制流程

+ if
+ while


网络
Netcat 

进程管理


综合案例

词频

## Linux

文件锁

socket

## Docker



## Axure

原型工具

box-shadow: 0 0 8px #ccc;

。拟合的公式参照前面发的网页文章，里面有详细的正交多项式拟合公式，和检验偏差的方法，一些偏离曲线多的点值要去掉移除，

证明P=NP或P!=NP

LIKE CONCAT(?, '%');



## Data

MapReduce

文件储存 hdfs://



，进程调度（线程池）

JobTracker and TaskTracker

shuffle

partition



    Map: each worker node applies the map function to the local data, and writes the output to a temporary storage. A master node ensures that only one copy of redundant input data is processed.
    Shuffle: worker nodes redistribute data based on the output keys (produced by the map function), such that all data belonging to one key is located on the same worker node.
    Reduce: worker nodes now process each group of output data, per key, in parallel.


 provided that all outputs of the map operation that share the same key are presented to the same reducer at the same time, or that the reduction function is associative.

(key, value) pairs



RDD



map e => (e.key, e.value)

flatMap

reduce

reduceByKey

groupByKey

如Map阶段的map, flatMap, filter, keyBy，Reduce阶段的reduceByKey, sortByKey, mean, gourpBy, sort等。



算法

求最大值最小值

平均值问题

TopN问题

词频数统计


## 推荐系统

## 过滤

## 日志系统


## Erlang


消息

错误处理


## MapReduce

map :: (k1,v1) -> (k2,v2)

reduce :: (k1,v1) -> (k2,v2)

多步骤

数据存储 DBFS





常见算法

+ 单词统计



## Pig

## Spark

flatMap
reduce groupBy

http://spark.apache.org/docs/latest/ml-statistics.html

## 功能


推荐算法

搜索排序

垃圾信息过滤

kdb

Generalized Linear Model, Logistic Regression

cluster

socket 进程
Apache Kafka

keras

NIO之前，恐怕十个Java程序员里只一个可能写出高质量的网络应用

备份数据库

## References

参考链接

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







1、所有报表中，小数位数全部保留两位，需要检查一下。
2、水位日报表功能，选择渠首分水闸，11号站有数据，但是表格没有出来数据。
3、解决IE11无法进入主页的问题。
4、系统安装部署文档，把最新的上传到SVN后告诉我在哪里。
5、水位流量统计图的日期是乱的



mustache.js

Pug, Mustache, and EJS



```sql
SELECT
	TOP 20 fycd,
	delta,
	row_number () OVER (PARTITION BY delta ORDER BY TM) as n,
	TM,W,Q
FROM
	(
		SELECT
			*, DATEDIFF(
				mi,
				'2018-05-28 08:00:00.000',
				TM
			) / 15 AS delta
		FROM
			nsy.WRTRUN
		WHERE
			fycd IN (11)
		AND tm > '2018-05-28 08:00:00.000'
	) AS a
ORDER BY
	TM
```



```javascript
$('.sub-right table td').each((i,e)=>{
    var x =$(e).text();if(/^\d+\.\d+$/.test(x))$(e).text(parseFloat(x).toFixed(2))})
```

```
$('.sub-right table td').each(function(i,e){
    var x =$(e).text();if(/^\d+\.\d+$/.test(x))$(e).text(parseFloat(x).toFixed(2))});
```



```sql

DECLARE @tmp TABLE (dt datetime)
DECLARE @i datetime = '2018-05-28 08:00:00'
DECLARE @a datetime = '2018-05-28 08:00:00'
DECLARE @s datetime = dateadd(DAY, 1 ,@i)
WHILE DATEDIFF(mi, @i, @s) >= 0
BEGIN
	INSERT @tmp (dt)
VALUES
	(@i)
SET @i = DATEADD(mi, 15, @i)
END SELECT
	*
FROM
	(
		SELECT
			*, ROW_NUMBER () OVER (
				partition BY dt,
				fycd
			ORDER BY
				TM DESC
			) AS rn
		FROM
			@tmp AS k,
			nsy.WRTRUN AS v
		WHERE
			v.FYCD IN (11, 12, 13, 14, 15, 16, 17, 18)
		AND v.TM BETWEEN @a
		AND @s
		AND DATEDIFF(SECOND, v.TM, k.dt) BETWEEN 0
		AND 2 * 60 * 60
	) t
WHERE
	t.rn = 1
ORDER BY
	fycd,
	dt
DECLARE @t TABLE (fycd INT) INSERT INTO @t
VALUES
	(11),
	(12),
	(13),
	(14),
	(15),
	(16),
	(17),
	(18) SELECT
		t0.dt,
		t1.fycd,t3.FYNM,t2.TM,t2.W,t2.Q
	FROM
		@tmp AS t0
	CROSS JOIN @t AS t1
	LEFT JOIN (
		SELECT
			*
		FROM
			(
				SELECT
					*, ROW_NUMBER () OVER (
						partition BY dt,
						fycd
					ORDER BY
						TM DESC
					) AS rn
				FROM
					@tmp AS k,
					nsy.WRTRUN AS v
				WHERE
					v.FYCD IN (11, 12, 13, 14, 15, 16, 17, 18)
				AND v.TM BETWEEN @a
				AND @s
				AND DATEDIFF(SECOND, v.TM, k.dt) BETWEEN 0
				AND 2 * 60 * 60
			) t
		WHERE
			t.rn = 1
	) AS t2 ON t1.fycd = t2.fycd
	AND t0.dt = t2.dt join [nsy].FYINF t3 on t1.fycd=t3.fycd
	ORDER BY
		t1.fycd,
		t0.dt
```

https://stackoverflow.com/questions/10999522/how-to-get-the-latest-record-in-each-group-using-group-by

分布式事物。


写视频点播网站文件下载接口
基础变量/数组写出模拟maven导入包过程
写出新变脸内存分配，模拟垃圾回收过程
50个白球50个红球，两个盒子，怎么放让人随机在一个盒子里抽到红球概率最高
n个数里取两个和为s的数
java数据结构
HashMap原理
自定义类型可以作为Key么？
java内存模型
知道的排序算法
快排的优化
Java多线程实现方式
Java线程与进程区别
JVM内存模型+垃圾回收算法
hashmap和treemap的区别
操作系统同步方式、通信方式
计算机网络三次握手四次分手以及wait_time三种差别
http post和get差别
美赛的建模
k-means 算法
数据库的三范式
路由器和交换机有什么区别
抽象类和接口有什么区别
HashMap 和 HashTable 有什么区别
多线程下有什么同步措施
JVM GC、CMS 和 多线程
Java 64 位的指针压缩
Java 中的锁是怎么实现的、有什么锁
Spark 和 Hadoop 区别
Spark 分布式数据的容错机制
Spark 的 shuffle read 和 shuffle write 的实现
docker(namespace cgroups)
docker文件系统
http协议
java线程池达到提交上限的具体情况
Java无锁原理
rehash过程
java如何定位内存泄漏
对中间件的认识
数组中Arrays.sort的排序方法是什么？
快速排序和堆排序的优缺点
GC中可达性分析法，和引用计数法有什么不同？引用计数法有什么问题？
JVM类加载机制
链表中如何判断有环路
数据结构中的链表
算法二分查找
时间复杂度分析
操作系统cpu调度算法


http://lbs.tianditu.gov.cn/home.html








