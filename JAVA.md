# JAVA Notes



## Spring

用于运行时单实例对象的创建



Bean

+ id
+ class
+ property


Configuration

+ xml

   ```xml
  <bean id="..." class="...">
      <property name="..." ref="..." />
  </bean>
   ```

  

+ anno
  + `@Autowired`


启动



## JDBC

## Servlet

用于 http 网络服务

HttpServlet

+ request
+ response

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



### .jsp

```jsp

```



 *Servlet*、Filter、*Listener*, 

## Spring MVC

基于 Servlet

### servlet.xml

```xml
<context:component-scan base-package="package1"/>
<context:annotation-config/>
<bean      class="org.springframework.web.servlet.view.InternalResourceViewResolver">
    <property name="prefix">
        <value>/WEB-INF/views/</value>
    </property>
    <property name="suffix">
        <value>.jsp</value>
    </property>
</bean>
```



### Database

基于 jdbc

POJO
getter seter

Data Access Object





### Form



## Maven

管理依赖

pom.xml

运行



## MySQL

### Create

+ CREATE TABLE 
  + `create table table1 ()`
  + type
  + cons
    + primary key
    + not null
    + foreigner key
+ INDEX
  + =, >, <





### CRUD

+ SELECT
  + `select * from where id=?`
  + AS `select 1 as name`
  + ORDER  `select * order by id asc` (asc/desc)
  + LIMIT `select * from table1 limit 10 `
  + JOIN `select * from table1 join table2 on table1.id=table2.id`
  + arr `select count(*) from table`
  + GROUP `select column1,count(1) group by column1`
+ INSERT
  + `insert table(columns) values (?)`
+ UPDATE 
  + `update table set value=? where key=?`
+ DELETE
  + `delete where id=?`

### Transaction



## References

+ https://docs.oracle.com/javase/tutorial/index.html
+ https://www.tutorialspoint.com/jdbc/index.htm







