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


ResultSet




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



 *Servlet*、Filter、Listener 事件

 

## Spring MVC

基于 Servlet

### servlet.xml

```xml
<context:component-scan base-package="*"/>
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



### Controller 



Component: Controller -> Service -> Repository

`@Component、@Repository、@Service、@Controller`

### Database

基于 jdbc

POJO
getter seter

```
class Data{
    
}
```



@Repository

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





### Form



## Maven

管理依赖

pom.xml

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



## References

+ https://docs.oracle.com/javase/tutorial/index.html
+ https://www.tutorialspoint.com/jdbc/index.htm







