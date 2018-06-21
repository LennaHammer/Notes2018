# Java Notes



## Spring

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



启动





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

有序

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

@Component 被扫描

+ 

+ @Controller -->> (@Service -> @Repository）



### Controller 



class

+ `@Controller class ...`

method

+ `@RequestMapping("/...")`

`@RequestMapping(value="/...",methodRequestMethod.=GET)`

`GetMapping`   `@PostMapping`

param

+ `@RequestParam("name")` 
+ `"/{name}"` -> `@PathVariable("name")`
+ HttpServletRequest
+ HttpServletResponse
+ `@ModelAttribute` 
  + every request `@ModelAttribute("person")`   before @RequestMapping
  + from form 

Exception

+ `@ExceptionHandler(RuntimeException.class)  `

+ `@ResponseStatus class Exception `

+ 全局 `@ControllerAdvice` 

返回 Response

+ `Model model` `model.addAttribute("...","...")` ->  `"view"`
+ `"redirect:/path"` 
+ ModelAndView `new ModelAndView("view", "command", new Item());`
+ `@ResponseBody` 返回 String 或 Bean
+ new ResponseEntity(obj,  HttpStatus.OK)





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





### View

+ `<%@ page contentType="text/html; charset=UTF-8" %>` 
+ `<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>`
+ `<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">` 
+ `${...}`
+ `foreach`
+ `request.getAttribute`

```jsp
<%@ page contentType="text/html; charset=UTF-8" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
```



### Model

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

+ `@ModelAttribute("SpringWeb")` 

View
+ `<form:form method="POST" action="/...">`

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

### Logger

### validation 

### Security

interceptor+

HandlerInterceptorAdapter 

	public boolean preHandle(HttpServletRequest request, 
		HttpServletResponse response, Object handler)
	    throws Exception {
		
		long startTime = System.currentTimeMillis();
		request.setAttribute("startTime", startTime);
		
		return true;
	}
authenticate

PreAuthorize

@PreAuthorize("hasRole('ADMIN') AND hasRole('DBA')")



## Spring Data

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
    

@ManyToMany(mappedBy = "roles")



### MyBatis



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

  + 

  + Type(Length)

    + Numeric `INT` `FLOAT` `DOUBLE` `DECIMAL` 
    + String `varchar(255)` `text` 
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
  + distinct `select distinct`, union `select ... union select ...`
  + 嵌套 nested 
    + in (select ...)
+ INSERT
  + `insert table(columns) values (?)`
  + `insert into table1(columns) values (select columns from table2)` 
+ UPDATE 
  + `update table set value=? where key=?`
+ DELETE
  + `delete where id=?`

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

内置 LEFT

字符串

定义

### 注意

避免类型转换

加索引

引擎必须指定 Innodb 支持事务 编码用 `utf8mb4` （不用名称 utf8 是历史兼容原因）

not null

isolation_level value is None, and permitted values are 'READ UNCOMMITTED', 'READ COMMITTED', 'REPEATABLE READ', and 'SERIALIZABLE'

分表

explain

lock

复杂查询

cursor

explain

### Tools

CLI

MySQL Workbench

Navicat Premium





## MyBatis



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

## Design Pattern

对象创建

+ Factory
+ Builder  例如 `StringBuilder`
+ Single Instance 实现 全局对象

行为

+ Command 实现 undo

组合

+ 实现 Sum Type



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

web project

deploy

clean/build

jetbrains

vscode



git

git add

git commit

git push

git pull git fetch followed by a git merge.

## Deploy

### MySQL

### Nginx

负载均衡

反向代理

## Tomcat

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



## Angular

Vue

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

+ 

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

+ 浮动 `<div style="float: left; width=30%;"></div>`
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

## HTTP

header

+ `Content-Type` 



Request

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



## TCP/IP

socket

frame



## Spring Boot

`Web devtools MySQL JDBC JPA`



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

```ini
spring.jpa.hibernate.ddl-auto=create
spring.datasource.url=jdbc:mysql://localhost:3306/database1
spring.datasource.username=root
spring.datasource.password=root
spring.jpa.database-platform=org.hibernate.dialect.MySQL5Dialect  
```



@Transactional @EnableTransactionManagement



## Back-end

role 团队分工

+ Customer
+ Project Manager
+   前端 后端

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





cesrum 地球3d显示

无人机自动 3d 建模







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
+ 
+ https://bootstrapstudio.io/
+ https://www.tutorialspoint.com/springaop/
+ https://hellokoding.com/registration-and-login-example-with-spring-security-spring-boot-spring-data-jpa-hsql-jsp/
+ http://stateless.co/hal_specification.html
+ http://phlyrestfully.readthedocs.io/en/latest/halprimer.html
+ https://www.drupal.org/docs/8/core/modules/workflows/overview
+ https://www.google.com
+ https://www.bing.com
+ 



补充


```
Permissions for an Action
Workflows
States
Transitions
```
