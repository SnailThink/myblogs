### 常用注解以及注解使用



#### Controller



```java
@RestController
@RequestMapping("ormUserController")
public class OrmUserController {

	@GetMapping("/getStrName")
	public String getStrName(@RequestParam String name){
		return  name+"hello";
	}

	@PostMapping("getStrName2")
	public String getStrName2(@RequestBody OrmUserPO ormUserPO) {
		return ormUserPO.getName() + "hello";
	}
}
```

**@RestController**

`@RestController`注解是`@Controller和`@`ResponseBody`的合集,表示这是个控制器 bean,并且是将函数的返回值直 接填入 HTTP 响应体中,是 REST 风格的控制器。

扩展：

单独使用 `@Controller` 不加 `@ResponseBody`的话一般使用在要返回一个视图的情况，这种情况属于比较传统的 Spring MVC 的应用，对应于前后端不分离的情况。`@Controller` +`@ResponseBody` 返回 JSON 或 XML 形式数据

**GET 请求**

`@PostMapping("users")` 等价于`@RequestMapping(value="/users",method=RequestMethod.POST)`

`@GetMapping("users")` 等价于`@RequestMapping(value="/users",method=RequestMethod.GET)`

`@PutMapping("/users/{userId}")` 等价于`@RequestMapping(value="/users/{userId}",method=RequestMethod.PUT)`

`@DeleteMapping("/users/{userId}")`等价于`@RequestMapping(value="/users/{userId}",method=RequestMethod.DELETE)`



#### Mapper

```java
@Mapper
public interface OrmUserMapper {

	/**
	 * 根据名称查询数据
	 * @param name
	 * @return
	 */
	OrmUserPO queryOrmUserByName(@Param("name")String name);
}
```

**@Mapper**

等价于bean注入

#### impl

```java
@Service
public class OrmUserServiceImpl implements OrmUserService {

	@Autowired
	private OrmUserMapper ormUserMapper;

	/**
	 * 根据用户名称查询数据
	 * @param name
	 * @return
	 */
	@Override
	public OrmUserPO queryOrmUserByName(String name) {
		return ormUserMapper.queryOrmUserByName(name);
	}
}
```

**@Service**

注入bean中



#### Spring Bean 相关

`@Autowired`

`@Component`,`@Repository`,`@Service`, `@Controller`

`@RestController`

