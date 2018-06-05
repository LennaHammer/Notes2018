# JAVA Notes

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



DataSource

ResultSet




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



### spring-mvc-servlet.xml(spring-mvc)

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



### Controller 

`@Controller class ...`

@RequestMapping





`@PathVariable` `@RequestParam` 



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







@Component: @Controller -> @Service -> @Repository





### Database

基于 jdbc

POJO
getter seter

```
class Data{
    
}
```



#### JdbcTemplate * 

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
update("",);
queryForList();

```





Data Access Object

​     

​     The DAO completely hides the data source implementation details from its clients. 



```

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

File



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



## MySQL

### Create

+ CREATE TABLE 
  + `create table if not exists table1 (id integer primary key,key, value text)`
  + Type
  + cons
    + primary key
    + not null
    + foreigner key
+ INDEX
  + =, >, <



##  



### CRUD

+ SELECT
  + `select * from where id=?`
  + WHERE
  + AS `select 1 as name`
  + ORDER  `select * order by id asc` (asc/desc)
  + LIMIT `select * from table1 limit 10 `
  + JOIN `select * from table1 join table2 on table1.id=table2.id` 
    + inner join, left join
  + arr `select count(*) from table`
  + GROUP `select column1,count(1) group by column1`
    + HAVING
  + distinct `select distinct`, union `select ... union select ...`
+ INSERT
  + `insert table(columns) values (?)`
+ UPDATE 
  + `update table set value=? where key=?`
+ DELETE
  + `delete where id=?`

### Transaction

Tools

Navicat Premium



## MyBatis

## Design Pattern

对象创建



## Tomcat



## References

+ https://docs.oracle.com/javase/tutorial/index.html
+ https://www.tutorialspoint.com/jdbc/index.htm
+ http://spring.io/guides







