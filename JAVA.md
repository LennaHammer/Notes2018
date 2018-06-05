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

```



 

## Spring MVC

基于 Servlet

### springmvc_servlet.xml

```xml
<context:component-scan base-package="*"/>
<context:annotation-config/>
<mvc:default-servlet-handler/>
<bean      class="org.springframework.web.servlet.view.InternalResourceViewResolver">
    <property name="prefix">
        <value>/WEB-INF/views/</value>
    </property>
    <property name="suffix">
        <value>.jsp</value>
    </property>
</bean>
```



### Controller 

`@Controller class ...`

@RequestMapping





`@PathVariable` `@RequestParam` 









@Component: @Controller -> @Service -> @Repository





### Database

基于 jdbc

POJO
getter seter

```
class Data{
    
}
```



#### JdbcTemplate 

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

## MyBatis

## Design Pattern

对象创建



## Tomcat



## References

+ https://docs.oracle.com/javase/tutorial/index.html
+ https://www.tutorialspoint.com/jdbc/index.htm
+ http://spring.io/guides







