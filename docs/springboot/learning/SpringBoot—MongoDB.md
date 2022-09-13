 ## Spirng Boot——MongoDB

> 作者：知否派。<br/>
> 文章所涉及的资料来自互联网整理和个人总结，意在于个人学习和经验汇总，如有什么地方侵权，请联系本人删除，谢谢
>
> 项目地址：[spring-boot-learning](https://gitee.com/VincentBlog/spring-boot-learning)

### 一、什么是MongoDB

MongoDB是一个介于`关系数据库`和非关系数据库之间的产品，是非关系数据库当中功能最丰富，最像关系数据库的。它支持的数据结构非常松散，是类似`json`的`bson`格式，因此可以存储比较复杂的数据类型。Mongo最大的特点是它支持的查询语言非常强大，其语法有点类似于面向对象的查询语言，几乎可以实现类似关系数据库单表查询的绝大部分功能，而且还支持对数据建立索引.

**JSON 与 BSON 之间的区别**

| JSON                                                         | BSON                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| JSON 是 javascript 对象表示法                                | BSON 是二进制 JSON                                           |
| 是一种轻量级的、基于文本的、开放的数据交换格式               | 是一种二进制序列化文档格式                                   |
| JSON 包含一些基本数据类型，如字符串、数字、布尔值、空值      | 除了支持 JSON 中的类型外，BSON 还包含一些额外的数据类型，例如日期（Date）、二进制（BinData）等 |
| AnyDB、redis 等数据库将数据存储为 JSON 格式                  | MongoDB 中将数据存储为 BSON 格式                             |
| 主要用于传输数据                                             | 主要用于存储数据                                             |
| 没有响应的编码和解码技术                                     | 有专用的编码和解码技术                                       |
| 如果想从 JSON 文件中读取指定信息，需要遍历整个数据           | 在 BSON 中，可以使用索引跳过到指定内容                       |
| JSON 格式不需要解析，因为它是人类可读的                      | BSON 需要解析，因为它是二进制的                              |
| JSON 是对象和数组的组合，其中对象是键值对的集合，而数组是元素的有序列表 | BSON 是二进制数据，在其中可以存储一些附加信息，例如字符串长度、对象类型等 |



### 二、如何安装MongoDB

[下载地址](https://www.mongodb.com/try/download/community)

[安装详解](https://www.runoob.com/mongodb/mongodb-window-install.html)

**配置客户端**

![image-20220526112447080](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220526112454.png)

**创建DataBase**

![image-20220526112644355](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220526112644.png)

**查看数据**

![image-20220526112855557](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220526112855.png)



### 三、SpringBoot 集成MongoDB

#### 3.1 引入依赖

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>spring-boot-learning</artifactId>
        <groupId>com.whcoding</groupId>
        <version>1.0-SNAPSHOT</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>

    <artifactId>demo-mongodb</artifactId>
    <version>1.0-SNAPSHOT</version>
    <packaging>jar</packaging>

    <!--设置版本-->
    <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
        <java.version>1.8</java.version>
    </properties>


    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
       <!--1. 引入mongodb -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-mongodb</artifactId>
        </dependency>

        <!--2. hutool工具类 -->
        <dependency>
            <groupId>cn.hutool</groupId>
            <artifactId>hutool-all</artifactId>
        </dependency>

        <!--3.guava工具类 -->
        <dependency>
            <groupId>com.google.guava</groupId>
            <artifactId>guava</artifactId>
        </dependency>

        <!--4.fastjson -->
        <dependency>
            <groupId>com.alibaba</groupId>
            <artifactId>fastjson</artifactId>
        </dependency>

        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <optional>true</optional>
        </dependency>

    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>

</project>
```

#### **3.2 ArticleEntity**

```java
package com.whcoding.mongodb.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

/**
 * @author whcoding
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ArticleEntity {
    /**
     * 文章id
     */
    private Long id;

    /**
     * 文章标题
     */
    private String title;

    /**
     * 文章内容
     */
    private String content;

    /**
     * 创建时间
     */
    private Date createTime;

    /**
     * 更新时间
     */
    private Date updateTime;

    /**
     * 点赞数量
     */
    private Long thumbUp;

    /**
     * 访客数量
     */
    private Long visits;

}

```

#### 3.3 ArticleRepository

```java
package com.whcoding.mongodb.repository;


import com.whcoding.mongodb.entity.ArticleEntity;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

/**
 *
 * @author whcoding
 */
public interface ArticleRepository extends MongoRepository<ArticleEntity, Long> {
    /**
     * 根据标题模糊查询
     *
     * @param title 标题
     * @return 满足条件的文章列表
     */
    List<ArticleEntity> findByTitleLike(String title);
}

```

#### 3.4 ArticleRepositoryTest

```java
package com.whcoding.mongodb.repository;
import java.util.Date;
import java.util.List;


import cn.hutool.core.date.DateUtil;
import cn.hutool.core.util.RandomUtil;
import com.whcoding.mongodb.DemoMongodbApplicationTest;

import com.whcoding.mongodb.entity.ArticleEntity;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.data.mongodb.core.query.Update;



public class ArticleRepositoryTest extends DemoMongodbApplicationTest {
	@Autowired
	private ArticleRepository articleRepo;

	@Autowired
	private MongoTemplate mongoTemplate;

//	@Autowired
//	private Snowflake snowflake;



	/**
	 * 测试新增
	 */
	@Test
	public void testSave2() {
		ArticleEntity article = new ArticleEntity();
		article.setId(0L);
		article.setTitle("知否派");
		article.setContent("MongoDB入门");
		article.setCreateTime(new Date());
		article.setUpdateTime(new Date());
		article.setThumbUp(Long.valueOf(100));
		article.setVisits(Long.valueOf(100));
		articleRepo.save(article);
	}


	/**
	 * 测试新增
	 */
	@Test
	public void testSave() {
		ArticleEntity article = new ArticleEntity(1L,
				RandomUtil.randomString(20)
				, RandomUtil.randomString(150)
				, DateUtil.date()
				, DateUtil.date(),
				0L,
				0L);
		articleRepo.save(article);
	}

	/**
	 * 测试新增列表
	 */
	@Test
	public void testSaveList() {
//		List<Article> articles = Lists.newArrayList();
//		for (int i = 0; i < 10; i++) {
//			articles.add(new Article(snowflake.nextId(), RandomUtil.randomString(20), RandomUtil.randomString(150), DateUtil.date(), DateUtil.date(), 0L, 0L));
//		}
//		articleRepo.saveAll(articles);

	}

	/**
	 * 测试更新
	 */
//	@Test
//	public void testUpdate() {
//		articleRepo.findById(1L).ifPresent(article -> {
//			article.setTitle(article.getTitle() + "更新之后的标题");
//			article.setUpdateTime(DateUtil.date());
//			articleRepo.save(article);
//		});
//	}

	/**
	 * 测试删除
	 */
	@Test
	public void testDelete() {
		// 根据主键删除
		articleRepo.deleteById(1L);

		// 全部删除
		articleRepo.deleteAll();
	}

	/**
	 * 测试点赞数、访客数，使用save方式更新点赞、访客
	 */
//	@Test
//	public void testThumbUp() {
//		articleRepo.findById(1L).ifPresent(article -> {
//			article.setThumbUp(article.getThumbUp() + 1);
//			article.setVisits(article.getVisits() + 1);
//			articleRepo.save(article);
//		});
//	}

	/**
	 * 测试点赞数、访客数，使用更优雅/高效的方式更新点赞、访客
	 */
	@Test
	public void testThumbUp2() {
		Query query = new Query();
		query.addCriteria(Criteria.where("_id").is(1L));
		Update update = new Update();
		update.inc("thumbUp", 1L);
		update.inc("visits", 1L);
		mongoTemplate.updateFirst(query, update, "article");

	}

	/**
	 * 测试分页排序查询
	 */
	@Test
	public void testQuery() {
		Sort sort = Sort.by("thumbUp", "updateTime").descending();
		PageRequest pageRequest = PageRequest.of(0, 5, sort);
		Page<ArticleEntity> all = articleRepo.findAll(pageRequest);
	}

	/**
	 * 测试根据标题模糊查询
	 */
	@Test
	public void testFindByTitleLike() {

		List<ArticleEntity> articles = articleRepo.findByTitleLike("更新");
	}

	/**
	 * 查询所有数据
	 */
	@Test
	public void testFindAll() {
		List<ArticleEntity> articlesList = articleRepo.findAll();
		System.out.println("从MongoDB中获取的数据总数为:"+articlesList.size());
	}
}

```

#### 3.5 DemoMongodbApplication

```java
package com.whcoding.mongodb;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * @program: spring-boot-learning
 * @description:
 * @author: whcoding
 * @create: 2022-05-25 17:45
 **/

@SpringBootApplication
public class DemoMongodbApplication {
	public static void main(String[] args) {
		SpringApplication.run(DemoMongodbApplication.class, args);
	}
}
```

### 四、回顾

#### 1.mongoDB的优点



#### 2.MySQL和mongoDB的区别


![image-20220707161552460](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220707161552460.png)



### 参考文章

[mongodb中文手册](https://mongodb.net.cn/manual/crud/)

###  公众号

如果大家想要实时关注我更新的文章以及分享的干货的话，可以关注我的公众号。
<img src="https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220507200900.jpg" style="zoom:50%;" />

