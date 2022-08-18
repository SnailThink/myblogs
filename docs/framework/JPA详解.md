## SpringBoot 集成JPA


### JPA进阶


#### 1.JPA @Column 字段命名 默认驼峰转换

JPA @Column 字段命名 默认驼峰转换  如果数据库字段为非下划线命名则需要配置。

spring data jpa 使用的默认策略是 ImprovedNamingStrategy

所以修改配置下 hibernate 的命名策略就可以了

在application.properties文件中加入:

```xml
#PhysicalNamingStrategyStandardImpl

spring.jpa.hibernate.naming.physical-strategy=org.hibernate.boot.model.naming.PhysicalNamingStrategyStandardImpl
```


#### 2.spring data jpa方法命名规则

| 关键字            | 方法命名                       | sql where字句              |
| ----------------- | ------------------------------ | -------------------------- |
| And               | findByNameAndPwd               | where name= ? and pwd =?   |
| Or                | findByNameOrSex                | where name= ? or sex=?     |
| Is,Equals         | findById,findByIdEquals        | where id= ?                |
| Between           | findByIdBetween                | where id between ? and ?   |
| LessThan          | findByIdLessThan               | where id < ?               |
| LessThanEquals    | findByIdLessThanEquals         | where id <= ?              |
| GreaterThan       | findByIdGreaterThan            | where id > ?               |
| GreaterThanEquals | findByIdGreaterThanEquals      | where id > = ?             |
| After             | findByIdAfter                  | where id > ?               |
| Before            | findByIdBefore                 | where id < ?               |
| IsNull            | findByNameIsNull               | where name is null         |
| isNotNull,NotNull | findByNameNotNull              | where name is not null     |
| Like              | findByNameLike                 | where name like ?          |
| NotLike           | findByNameNotLike              | where name not like ?      |
| StartingWith      | findByNameStartingWith         | where name like '?%'       |
| EndingWith        | findByNameEndingWith           | where name like '%?'       |
| Containing        | findByNameContaining           | where name like '%?%'      |
| OrderBy           | findByIdOrderByXDesc           | where id=? order by x desc |
| Not               | findByNameNot                  | where name <> ?            |
| In                | findByIdIn(Collection<?> c)    | where id in (?)            |
| NotIn             | findByIdNotIn(Collection<?> c) | where id not  in (?)       |
| True              | findByAaaTue                   | where aaa = true           |
| False             | findByAaaFalse                 | where aaa = false          |
| IgnoreCase        | findByNameIgnoreCase           | where UPPER(name)=UPPER(?) |

#### 3.JPA不被持久化字段

 一般使用后面两种方式比较多，推荐使用注解的方式。 

```java
public class OrmCustomerPO implements Serializable {

	private Long id;

	/**
	 * 客户名称
	 */
	private String customerName;
    
	//方法一：
	static String customerName1;
	//方法二：
	final String customerName2 ="";
	//方法三：
	transient String customerName3;
	//方法四：
	@Transient
	private String customerName4;

}
```

#### 4.JPA使用SQL语句

```java

@Query(value="select * from orm_dept where dept_name=(:deptName)",nativeQuery = true)
	List<OrmDeptPO> queryDeptByName(@Param("deptName") String deptName);
```



#### 5.Jpa非主键字段如何配置自动增长

- nullable：是否为空
- insertable：是否能插入
- updateable：是否能更新

```java
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "id",nullable=false,insertable=false,updatable=false,columnDefinition="numeric(19,0) IDENTITY")
    private Integer id;
```

