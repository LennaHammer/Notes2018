# Java Notes

## Spring

用于运行时单实例对象的创建



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



启动



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

有序

### .jsp

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



 

## Spring MVC

基于 Servlet

### Configure

web.xml(servlet)

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

root-context.xml

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



### Controller * 



class

`@Controller class ...`

method

`@RequestMapping`

`@RequestMapping(,method=GET)`

`GetMapping`   `@PostMapping`

param 参数

`@PathVariable` `@RequestParam` 

异常

+ `@ExceptionHandler(RuntimeException.class)  `

+ `@ResponseStatus class Exception `

+ 全局 `**@ControllerAdvice** `

返回

+ `@ResponseBody`





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





```java
@ExceptionHandler({ NullPointerException.class })
@ResponseStatus(value=HttpStatus.NOT_FOUND)
public void handleNullPointerException(Exception e) {
    e.printStackTrace();
}
```



@Component: @Controller -->> (@Service -> @Repository）





### Database

基于 jdbc

POJO
getter seter

```
class Data{
    
}
```







Data Access Object

​     

​     The DAO completely hides the data source implementation details from its clients. 



```java
interface DAO{};
class DAOImpl{
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

### Form

post

view

File upload

`@RequestParam("file") MultipartFile file`

### JSON

`@RestController`

= `@Controller @ResponseBody`

`@RequestBody`

HttpMessageConverter 

MappingJackson2HttpMessageConverter

Content-Type MediaType

`Accept: */*`

library `org.sf.json`



## Spring Data

### JdbcTemplate *

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



```java
jdbcTemplate = new JdbcTemplate(dataSource);
jdbcTemplate.update("update ", ...);
jdbcTemplate query();
jdbcTemplate queryForList("select ...", ...); // all rows
jdbcTemplate queryForObject("select ...", ...); // first row
//jdbcTemplate queryForMap("select ...", ...);
```



### Transactions

`@Transactional`

```xml
<tx:annotation-driven transaction-manager="txManager"/><!-- a PlatformTransactionManager is still required -->
<bean id="txManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
<!-- (this dependency is defined somewhere else) -->
<property name="dataSource" ref="dataSource"/>
</bean>
```







### JPA

`@Entity class`

`class CrudRepository`



## Maven

管理依赖

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



## MySQL *

### Create

+ CREATE TABLE 
  + `create table if not exists table1 (id integer primary key, data text)`

  + Type(Length)

    + Numeric `int`
    + String `varchar(255)` `text` 
    + Date and Time     

  + INDEX

    + 

  + cons

    + primary key
    + not null
    + uniq
    + foreigner key

+ INDEX
  + =, >, <

  



### CRUD

+ SELECT
  + `select * from where id=?`
  + WHERE
    + RANGE `bewteen ... and ...`
    + LIST `in`
  + AS `select 1 as name`
  + ORDER  `select * order by id asc` (asc/desc)
  + LIMIT `select * from table1 limit 10 `
  + JOIN `select * from table1 join table2 on table1.id=table2.id` 
    + inner join, left join
  + Aggregation `select count(*) from table`
    + `count,sum` 
  + GROUP `select column1, count(1) group by column1`
    + HAVING
  + distinct `select distinct`, union `select ... union select ...`
+ INSERT
  + `insert table(columns) values (?)`
+ UPDATE 
  + `update table set value=? where key=?`
+ DELETE
  + `delete where id=?`

### Transaction

### Tools

MySQL Workbench

Navicat Premium



## MyBatis

## Design Pattern

对象创建

## IDE

Ecplise

web project

deploy

clean/build





## Tomcat

`.war` 放入 `webapps`



## Test

## JSON

```java
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
```



```
JSONObject.fromObject(...).toString();
```



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
        
    </body>
</html>
```



功能

+ heading `<h1>...</h1>`
+ list `<ul><li>...</li><li>...</li></ul>` 
+ link `<a href="...">...</a>`
+ image `<img src="..." alt="...">`
+ table `<table></table>`
+ Blockquote `<blockquote></blockquote>`
+ `<p></p>` 

块

+ div `<div class="...">...</div>`
+ span `<span class="...">...</span>`

## Bootstrap

layout

content

table

components

utilities



layout 布局

+ container `.container `  ` container-fluid` 顶层一个
+ row `.row` 
  + header
    +  `.navbar ` 属性 `navbar-dark`  `.navbar-expand `
  + footer
+ column `.col-sm` 列，手持设备可以转成行 一共 12 列
  + `xs 576px sm 768px md 992px lg 1200px`

样式

+ 对齐
+ 标记

功能元素

+ nav `.navbar` 

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

  

状态

+ callback
+ Modal 遮罩窗体

## Angular

## JS

PLAIN Javascript

## Jquery

AJAX

DOM

## require.js



## TCP/IP





## Spring Boot



```java
@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
```

## Back-end

role

## Security 



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







