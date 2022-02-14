 [git解决冲突](https://www.cnblogs.com/newAndHui/p/10851807.html) 



#### 二、Mybatis问题

 **Jpa的写法**

![img](https://img-blog.csdn.net/20180615131948889?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpeWFuZ19uYXNo/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70) 



Jpa写法

![](https://pic.downk.cc/item/5f3a353e14195aa59496790d.png)



**mybaits中的转义**

`<`   `&lt;` 
    
`<=`  `&lt;=`
    
`>`   `&gt;`
    
`>=`  `&gt;=`
    
`&`   `&amp;`
    
`'`   `&apos;`
    
`"`   `&quot;`

`<>`  `&lt;&gt;`



**1.待确认问题**

1.1 mapper问题

```java
//1.Mapper中参数名称是orderId那么是不是xml文件中也必须是orderId
//1.2 @Param是必须填写还是可以不填写 #{param.orderId2}
OrderRequirementVO findOrderRequirementByOrderId(@Param("orderId2") Integer orderId);

//2.1 xml文件中是不是必须使用 //#{param.PlatformId}
OrderRequirementVO findOrderList(@Param("param")Map<String,Object> param);
```

1.2 Date 和DateTime的区别



1.3 resultType [返回类型] parameterType [参数类型]都是分别返回什么类型

**resultType **：int 、VO、java.util.Map、java.lang.String、java.lang.Integer

​						Integer, Map

**parameterType**：java.util.Map、java.util.List、java.lang.Integer、Map

查询对象时候**resultType **为POJO

新增/删除/更新时候**resultType **可以不填写

[什么时候parameterType是必须填写的]



1.4 Jpa查询不等于**N**

- findByNameNotIN

- JPA 中 Update是否只能加 @Query

  

1.5 Jpa的Where 条件中增加不为null

```mysql
SELECT *FROM groot_user WHERE groot_user_id =IFNULL(@AA,0);
```

1.6 查询/更新单条数据时候参数是否判断



1.7 mybatis中的<>写法, 写在test中需要进行转义吗

```XML
 <if test="param.Subscribe != null and param.Subscribe <> 1">
 </if>
 
<if test="param.Subscribe != null and param.Subscribe == 1">
 </if>
 
<if test="param.Subscribe != null and (param.Subscribe >1 OR param.Subscribe <1)">
</if>

-- 是否可以使用枚举 AA
-- 参数是否区分大小写AA

  <if test="param.StartTime != null and param.EndTime != null and param.StartTime &lt;= param.EndTime">
            AND A.Status IN (0, 1, 2, 8, 9, 12, 13) AND IsOnlineContract=1
        </if>
 

<if test="param.AppId != null and param.AppId == 10001 and #{item.UserId}==-1">
 </if>
```



1.8 是否可以if嵌套写法

```xml
<if test="param.QueryType != null and param.QueryType == 1">
	A.Subscribe=1;
  	<if test="param.Subscribe != null and param.Subscribe == 10">
  	A.Subscribe>10;
 	</if>
 </if>
```

1.9 标签为select ,但是语句为update 会不会报错

```xml
    <Select id="updateOrderStagePaymentByOrderId">
           UPDATE transportplatform_order
            SET SendMoney = #{sendMoney},
                SendOilCard =  #{sendOilCard},
                ToPayment = #{toPayment},
                ReceiptMoney = #{receiptMoney},
                Abnormal = #{abnormal},
                OilPayment = #{oilPayment},
                price =  #{price},
                UpdatedTime = NOW( )
            WHERE
            OrderID = #{orderId}
    </Select>
```

1.10 mybatis update 获取主键

useGeneratedKeys 和 keyProperty 含义的使用 Todo

1.11 

```
List<BigDecimal> 返回值
java.math.BigDecimal
```



1.12 入参默认值问题

```
int QueryReqOfferNumByReqId(BaseRequest req, int reqId, int companyId = 0);
```

1.13 导入包名称无效

```
import com.e6yun.project.rms.module.seibertron.vo.user.UserVO;
```

1.14

BigDecimal 和double 的区别



1.15 重写PO中的tostring方法的用途是什么

不重写toString()方法会直接输出对象的引用
通常显示为 包名.类名.@八位字符


1.18 @RequestBody@RequestParam区别

 requestHeader中，即请求头 @RequestParam。 

 requestBody中，即请求头 @RequestBody



19.extends implements 区别

extends  是继承的时候使用

implements  是接口实现的时候使用的[接口必须要实现]



```java
//extends 继承父级
public class DemoController extends BaseController {


}

//implements
public class DemoServiceImpl implements IDemoService {

}
```

20.controller层抛出异常[统一异常如何处理]



21.字符串拼接区别

1.直接用“+”号
2.使用String的方法concat
3.使用StringBuilder的append    属于**线程不安全**的； 
4.使用StringBuffer的append   属于**线程安全**的



22.mybatis中写多条sql语句

```java
<update id="bindStu">
update edu_student set user_username=#{user_username} where stu_id = #{stu_id};
update edu_user set stu_id=#{stu_id} where user_username=#{user_username};
</update>
    
需要在mysql配置中增加 allowMultiQueries=true
jdbc.url=jdbc:mysql://localhost:3306/ssmbuild?
useSSL=false&useUnicode=true&characterEncoding=utf8&allowMultiQueries=true
```



23 mysql 使用REPLACE

```mysql
UPDATE admins_paymentbatch
SET TradeApply = #{tradeApply},
  TradeDate = #{tradeDate},
  TradeUserId =#{tradeUserId} ,
  TradeNo = CASE WHEN IFNULL(TradeNo,'') = '' 
	THEN REPLACE(PaymentNo,'DKD','TKD') ELSE TradeNo END
	
WHERE Id = #{id}

```

24 mybatis 返回主键

```xml
 <insert id="addPaymentBatch" parameterType="map" useGeneratedKeys="true" keyProperty="id">
        INSERT INTO tab1 (
         createTime
        )
        VALUES
        (
		now()
        )
    </insert>
```

**2.jpa保存数据并返回主键**

```java
//PO写法
@Entity
@Table(name = "transportplatform_order")
public class TransportplatformOrderPO implements Serializable {
    private static final long serialVersionUID = -50847923587280635L;

    @Id
    //需要加在ID注解下
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "OrderID")
    private Long orderID;

    @Basic
    @Column(name = "RequirementID")
    private Integer requirementID;

    @Basic
    @Column(name = "StartTime")
    @JSONField(format = "yyyy-MM-dd HH:mm:ss")
    private Date startTime;
    }
```



```java
//dao层写法 返回save主键Id
public Integer addOrderStatus(TransportplatformOrderstatusPO orderStatus) {
		TransportplatformOrderstatusPO saveOrderstatusPO= orderstatusDao.save(orderStatus);
		Integer saveId=saveOrderstatusPO==null?0:saveOrderstatusPO.getId();
		return saveId;
	}
```



**2.1 Jpa使用@Query**

```java
public interface ChannelBookingIxdDao extends JpaRepository<ChannelBookingIxdEntity,Integer> {
  //前面为实体类，后面为实体类的ID类型
}


//如果有些操作自带的 save( ) ,findOne( ) , findBy*( )，delete( ) 满足不了,那么我们就可以使用@Query注解了
public interface ChannelBookingIxdDao extends JpaRepository<ChannelBookingIxdEntity,Integer> {

    @Query(value = "select BookingId from ChannelBooking where isValid > 1", nativeQuery = true)
    ChannelBookingEntity findFirstByIsValidOrderByUpdateTimeDesc(Integer isValid);
}
```

**2.2 mybatis**

A: 数据不存在则新增、存在则更新 

**insert ignore**

B: 数据存在则不操作、不在则新增

**INSERT...ON DUPLICATE KEY UPDATE**

如果指定了ON DUPLICATE KEY UPDATE，并且插入行后会导致在一个UNIQUE索引

或PRIMARY KEY中出现重复值，则执行UPDATE。 

C:



**3.Jpa根据主键查询对象**

- findOne： 查询一个不存在的id数据时，返回的值是null 
-  getOne ：不存在的id数据时，直接抛出异常 
- findById 

```java
//jpa写法:
TransportplatformOrderstatusPO findOne(Integer id);
TransportplatformOrderstatusPO findAllId();
```

**4.count(*)和count(1)效率无明显区别返回的数据中包含null 值**

**5.mybatis—Updates**

```xml
   <update id="updateCorpDictionary" parameterType="PO">
     UPDATE Table_A
        <set>
            Name = #{name},
            EnumName = #{enumName},
            Value=#{value}
        </set>
        where ID = #{id}
    </update>
```

**6.查询参数过多的时候使用map**

```java
public List<WebLinesPO> queryLineMatchingByReqId(List<Integer> fromIdList, List<Integer> toIdList, Integer vehicleTypeId, BigDecimal vehicleLength, List<Integer> corpIds, List<Integer> noCorpIds) {
        Map<String, Object> map = new HashMap<>(16);
        map.put("fromIdList", fromIdList);
        map.put("toIdList", toIdList);
        map.put("vehicleTypeId", vehicleTypeId);
        map.put("vehicleLength", vehicleLength);
        map.put("corpIds", corpIds);
        return lineMapper.findLineMatchingByReqId(map);
    }
```

对应的mapper

```java
List<WebLinesPO> findLineMatchingByReqId(Map map);
```

对应的mapper.xml

```xml
 <select id="findLineMatchingByReqId" resultType="com.e6yun.project.tms.module.seibertron.po.WebLinesPO" parameterType="map">
        SELECT DISTINCT A.SubscribeUserId subscribeUserId,
             A.CorpId corpId
        FROM web_lines AS A
        where A.IsValid=1
        AND A.Status=1
        AND A.SubscribeUserId > 0
        AND (IFNULL(A.HdcVehicleTypeId,0)=0 OR A.HdcVehicleTypeId=#{vehicleTypeId})
        AND (IFNULL(A.VehicleLength,0)=0 OR A.VehicleLength=#{vehicleLength} * 1000)
        <if test="corpIds != null and corpIds.size>0">
            and A.CorpId in
            <foreach collection="corpIds" index="index" item="item" close=")" open="(" separator=",">
                #{item}
            </foreach>
        </if>
        <if test="fromIdList != null and fromIdList.size>0">
            and A.FromAreaID in
            <foreach collection="fromIdList" index="index" item="item" close=")" open="(" separator=",">
                #{item}
            </foreach>
        </if>
        <if test="toIdList != null and toIdList.size>0">
            and A.ToAreaID in
            <foreach collection="toIdList" index="index" item="item" close=")" open="(" separator=",">
                #{item}
            </foreach>
        </if>
    </select>
```

**7.mybatis if else 写法**

choose为一个整体 \when是if \otherwise是else 

```xml
<select id="selectSelective" resultMap="xxx" parameterType="xxx">
    select
    <include refid="Base_Column_List"/>
    from xxx
    where del_flag=0
    <choose>
        <when test="xxx !=null and xxx != ''">
            and xxx like concat(concat('%', #{xxx}), '%')
        </when>
        <otherwise>
            and xxx like '**%'
        </otherwise>
    </choose>
</select>

-- 2.
<select id="findCorpBiddingOfferNumByReqId" resultType="int" parameterType="Map">
        SELECT COUNT(1)
        FROM admins_corpbiddingoffer A
        <where>
            <choose>
                <when test="conditionAllCorpIds != null and conditionAllCorpIds.size>0">
                    and A.RecCorpId in
                    <foreach collection="allCorpIds" index="index" item="item" close=")" open="(" separator=",">
                        #{item}
                    </foreach>
                    and  A.ReqId=#{reqId}
                    AND  A.OfferStatus NOT IN(-1, 0, 2)
                    AND A.SubmitStatus = 1
                </when>
                <otherwise>
                   and A.ReqId=#{reqId} AND A.OfferStatus!=2 AND A.OfferStatus!=0
                </otherwise>
            </choose>
        </where>


    </select>
```

**8.mybatis foreash 写法**

```xml
<if test="param.OrderIdList != null and param.OrderIdList >0 ">
            AND A.OrderID IN
            <foreach collection="param.vehicleLength " index="index" item="item" close=")" open="(" separator=",">
                #{item}
            </foreach>
        </if>
```

**9.mybatis contains的写法**

```xml
 <if test='item.cname.contains("select") or item.cname.contains("checkbox")'>
                find_in_set(#{item.value},base.${item.cname})
 </if>
```

**10.Jpa获取count**

```xml
int countByUidAndTenementId(String parentUid, String tenementId);
```

**11.Jpa Save获取ID **

```
save.getRuleId();
```

**12.拼接字符串**

```java
	public class Practice {
		//第一种方法：使用+
		public static  String mergedString1(String string1,String string2) {
			return   string1 + string2;
		}

		//第二种：使用concat()；
		public static String mergedString2(String string1, String string2) {
			return string1.concat(string2);
		}

		//第三种：使用append()；
		public static  StringBuffer mergedString3(String string1, String string2) {
			StringBuffer sb = new StringBuffer(string1);
			return sb.append(string2);

		}

		public static void main(String[] args) {
			Scanner input = new Scanner(System.in);
			System.out.print("请输入字符串1:");
			String string1 = input.nextLine();
			System.out.print("请输入字符串2:");
			String string2 = input.nextLine();

			System.out.println("第一种方法输出的字符串是：" + mergedString1(string1, string2));
			System.out.println("第二种方法输出的字符串是:" + mergedString2(string1,string2));
			System.out.println("第三种方法输出的字符串是:" + mergedString3(string1,string2));
		}
	}
```



#### 三 idea配置问题

##### 1.idea提交代码很慢

 IntelliJ IDEA 提供了一个自动分析代码的功能，即Perform code analysis： 

Check TODO 检查代码中的TODO

![](https://pic.downk.cc/item/5f3ce95d14195aa5949b6546.png)

##### 2.idea运行卡

Help-> Edit Custom VM Options

```xml
# custom IntelliJ IDEA VM options

-Xms1024m
-Xmx2048m
-XX:ReservedCodeCacheSize=240m
-XX:+UseConcMarkSweepGC
-XX:SoftRefLRUPolicyMSPerMB=50
-ea
-Dsun.io.useCanonCaches=false
-Djava.net.preferIPv4Stack=true
-Djdk.http.auth.tunneling.disabledSchemes=""
-XX:+HeapDumpOnOutOfMemoryError
-XX:-OmitStackTraceInFastThrow
```

#### 四 字段别名问题

1.将大写的表字段复制到excel中

2.剔除B. [=RIGHT(A2,LEN(A2)-FIND(".",A2))]

3.[英文字母大小写转换]( https://www.iamwawa.cn/daxiaoxie.html ) 将剔除B.开头的数据复制到网址中

执行每行首字符小写，将转换后的数据写入Excel 小写列中



CONCATENATE("'",D2,"',")

首字母小写转小写
LOWER(LEFT(B2,1))&MID(B2,2,LEN(B2)-1) 

剔除B.
=RIGHT(A2,LEN(A2)-FIND(".",A2))

加字符串
=CONCATENATE(A2,"AS ",C2,',')

去空格

TRIM(A1)

删除最后一个字符串

 =LEFT(A1,LEN(A1)-1) 



#### 五 实战类

```java
//获取list中某一个字段的最小值
Integer thruSeqCodeMin = shipperBiddingPointList.stream().map(cp->Integer.valueOf(cp.getThruSeqCode())).min(Integer::compareTo).get();

//list排序 升序
list.sort(Comparator.comparing(Users::getName));
//降序
Collections.reverse(list);

//按照List中对象的id属性升序
list.sort(Comparator.comparing(Stu::getId))
//按照List中对象的id属性降序
list.sort(Comparator.comparing(Stu::getId).reversed());
//多条件升序 asc 
list.sort(Comparator.comparing(Stu::getId).thenComparing(Stu::getSid));
//id升序,sid降序desc
list.sort(Comparator.comparing(Stu::getId).reversed().thenComparing(Stu::getSid));
//key值重复的map
MultiValueMap<Integer, String> timeMap = new LinkedMultiValueMap<>();
//集合升序排序
Collections.sort(student, new Comparator(){
public int compare(StudentVo p1, StudentVo p2) {
return Integer.parseInt(p1.getStudentCode()) - Integer.parseInt(p2.getStudentCode());
}
});


//java 8 forEash
List<E3plLoadingcustomerPO> loadingCustomerList;
loadingCustomerList.forEach(
		x->{

			x.setLoadingID(loadingId);
			x.setCreateUserID(req.getUserId());
			x.setModifiedUserID(req.getUserId());
		});


//java 8 查询满足条件的第一条数据
Optional<E3plLoadingassignPO> optionalE3plLoadingassignPO =assignList.stream().filter(carrier->carrier.getId().equals(assignCondition.getId())).findFirst();
				if(optionalE3plLoadingassignPO.isPresent())
				{
					currentAssign =optionalE3plLoadingassignPO.get();
				}


//判断list中是否存在某一元素
 List<String> stringList=new ArrayList<>();
  stringList.add(str1);
  stringList.add(str2);
  stringList.add(str3);
  stringList.add(str4);

  boolean isPass2= stringList.contains("444");

  boolean isPass3=stringList.stream().anyMatch(task -> task.equals("444"));


//Java 8 对list进行去重
 studentList.stream().distinct().collect(Collectors.toList());//整体

// 根据对象中字段getCustomerName去重
List<CustomerVO> unique = customerVOList.stream().collect(
				Collectors.collectingAndThen(
						Collectors.toCollection(() -> new TreeSet<>(Comparator.comparing(CustomerVO::getCustomerName))), ArrayList::new)
		);


 /**
     * 获取list中存放的最后一个元素
     * @param list
     * @param <T>
     * @return
     */
    public static <T> T getLastElement(List<T> list) {
        return list.get(list.size() - 1);
    }


//获取list中的前几条数据
List newList = list.subList(start, end);

 start,end分别是第几个到第几个。
     
//java8 group by 
//1.根据customerID进行分组
List<CustomerVO> customerVOList = new ArrayList<>();
Map<Integer, List<CustomerVO>> groupByList = customerVOList.stream().
		collect(groupingBy(CustomerVO::getCustomerId));
//2.获取分组后的key和value
List<CustomerVO> groupByCalculationList = new ArrayList<>();
for (Map.Entry<Integer, List<CustomerVO>> entry : groupByList.entrySet()) {
	CustomerVO groupByPo = new CustomerVO();
	entry.getKey();
	entry.getValue();
}

```

​	

```java
//1.声明枚举，枚举赋值，获取枚举
CustomerTypeEnum customerType;
customerType = CustomerTypeEnum.UnLoad;
customerType.getCode()

```



```java

//bigdecimal 保存2位小数
new BigDecimal(0.2).setScale(2, BigDecimal.ROUND_HALF_UP).doubleValue()

BigDecimal bg = new BigDecimal(f);
double f1 = bg.setScale(2, BigDecimal.ROUND_HALF_UP).doubleValue();

//BigDecimal 转换Integer
BigDecimal bg = new BigDecimal(1000);
Integer aa= Integer.parseInt(bg.toString());

//将double 转换为bigdecimal
new BigDecimal(double x)

BigDecimal bigDecimal=new BigDecimal("1000");
BigDecimal bigDecima2=new BigDecimal("2000");
BigDecimal bigDecima3=new BigDecimal("2000");
BigDecimal bigDecima4=getBigDecimalSum(bigDecimal,bigDecima2,bigDecima3);


/**
 * 多个BigDecimal数相加和
 *
 * @param i
 * @param arg
 * @return
 */
public static BigDecimal getBigDecimalSum(BigDecimal i, BigDecimal... arg) {
    BigDecimal sum = i;
    for (BigDecimal b : arg) {
        sum = sum.add(b);
    }
    return sum;
}

/**
 * 差
 * @param i
 * @param arg
 * @return
 */
public static BigDecimal getBigDecimalDifference(BigDecimal i, BigDecimal... arg) {
    BigDecimal difference = i;
    for (BigDecimal b : arg) {
        difference = difference.subtract(b);
    }
    return difference;
}




```

**基础**

```java

//基础
a.compareTo(b) 
a==b返回为0
a<b返回小于0
a>b返回大于0

//2.判断字符串和判断对象
StringUtils.isNotEmpty(treeCode)
CollectionUtils.isEmpty(accessList)
Optional<CorpVO> optionalshipperCorp
//不为空
if (optionalshipperCorp.isPresent()){
	CorpVO shipperCorp =optionalshipperCorp.get();
}

//2.判断是否相同

//等于
if (A1.equals(A2)) {
    System.out.println("A1等于A2");
}
//!=
if (!A1.equals(A2)) {
    System.out.println("A1不等于A2");
}

//3.判断字符串长度不够则补0
//string num=12
//num.PadLeft(4, '0'); //结果为为 '0012'
   public  String addZeroForNum(String str, int strLength) {
        int strLen = str.length();
        if (strLen < strLength) {
            while (strLen < strLength) {
                StringBuffer sb = new StringBuffer();
                sb.append("0").append(str);// 左补0
                // sb.append(str).append("0");//右补0
                str = sb.toString();
                strLen = str.length();
            }
        }

        return str;
    }

//4. Integer转换为string
 //方法一:Integer类的静态方法toString()
 Integer a = 2;
 String str = Integer.toString(a)

  //方法二:Integer类的成员方法toString()
 Integer a = 2;
 String str = a.toString();

 //方法三:String类的静态方法valueOf()
 Integer a = 2;
 String str = String.valueOf(a);

//5.判断string 是否为空 建议使用isnotBlank

isNotEmpty等价于 a != null && a.length > 0

isNotBlank 等价于 a != null && a.length > 0 && str.trim().length > 0
    
//6.long（Long）与int（Integer）之间的转换
 Long a=10l; int b = (int)a;

//7.
long a = 10L； int b = new Long(a).intValue（）；
```



```java
//1、将逗号分隔的字符串转换为List
String str = "a,b,c";  

List<String> result = Arrays.asList(str.split(","));

//2、将List转换为逗号分隔的字符串

//（1） 利用Guava的Joiner

List<String> list = new ArrayList<String>();  
list.add("a");  
list.add("b");  
list.add("c");  

String str = Joiner.on(",").join(list);  

//（2）利用Apache Commons的StringUtils

List<String> list = new ArrayList<String>();  
list.add("a");  
list.add("b");  
list.add("c");  

String str = StringUtils.join(list.toArray(), ",");  

//https://www.cnblogs.com/hui-blog/p/6375174.html
```



#### 六 常见错误：

Variable used in lambda expression should be final or effectively final...

```java
PassPointVO previous = null;
if (optionalPrevious.isPresent()) {
	previous = optionalPrevious.get();
}


//改进
PassPointVO nNode = optionalnNode.isPresent()==true?optionalnNode.get():null;
```



#### 七 项目相关

```java
//1.获取对象
E6Wrapper<PageParamNewVO> wrapper = orderDao.queryOrderList(req, condition, pageParamNewVO);

List<OrderListVO> orderList = (List<OrderListVO>)wrapper.getResult().getData();

 PageImpl page = new PageImpl(loadingList, pageable, count);
 PageUtilSbt.fillPageParamResult(pageParamNewVO, page);
 return E6WrapperUtil.wrap(pageParamNewVO);

//2.分页查询
Pageable pageable = PageUtilSbt.buildPageable(pageParamNewVO);

PageImpl page = new PageImpl(loadingList, pageable, count);
PageUtilSbt.fillPageParamResult(pageParamNewVO, page);
return E6WrapperUtil.wrap(pageParamNewVO);
```



#### 八 注解

**1.Controller**

```java
@Slf4j
@Api(tags = "fcst precision Service Api", description = "fcst precision Service Method Of Operation")
@RestController()
@RequestMapping("/report/fcst")
public class FcstReportController {

	@Autowired
	ViewVersionService viewVersionService;

	@Autowired
	FcstReportService fcstReportService;

	@ApiOperation(value = "query fcst precision report with pageable", notes = "query fcst precision report with pageable")
	@PostMapping("/fcstPrecision")
	public ResponseEntity findFcstPrecisionListByPage(@RequestBody FcstReportVO fcstReportVO) {
		Page<FcstReportVO> page = fcstReportService.findFcstListByPage(fcstReportVO);
		Date rVersion = viewVersionService.findViewVersion(ViewNameEnum.FCST_REPORT.getName());
		PageParamVO pageParam = fcstReportVO.getPageParamVO();
		pageParam.setrVersion(rVersion);
		PageUtil.fillPageParamResult(pageParam, page);
		return ResponseEntity.ok(pageParam);
	}
}
```





**2.Service**

不用加注解

**3.ServiceImpl**

```java
//样例
@Service
public class TakeTServiceImpl implements TakeService {
    @Autowired
    MybatisMapper  mybatisMapper;
    @Override
	public Integer findCount() {
        
    }
}

```



**4.Mapper**

```java
public interface DemoMapper {
    DemoPO findDemo(@Param("orderNo") String orderNo);
    Integer findDemoCount(@Param("param") Map<String, Object> param);
}
```



**5.POVO**

```java
@Entity 
@Table(name = "table_name")
public class Demo implements Serializable {
    private static final long serialVersionUID = -35977632050295602L;

    /**
    * $column.comment
    */
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)  
    @Column(name = "Id")
    private Integer id;
    
    /**
    * 企业Id
    */
    @Basic 
    @Column(name = "CorpId")
    private Integer corpId;
	
	}
```

#### 九 坑总结

**1. java中split以"."分隔和以"\"分隔**

其中"."对应如下：

在java中函数split(".")必须是是split("\\.")。

其中"\"对应如下：

在java中函数split("\")必须是是split("\\\\")。 

#### 十优化写法

```java
// 1.声明一个空的集合
List<IotdReportResultVO> list = Collections.emptyList();

//2 java 时间比较不需要用< >
data.getNavArriveTime().before(new Date());
    
```



#### 十一、Mybatis问答

##### 1.mybatis 问题

Q1:mybatis foreash 中的index 是必填项吗，还有（）,有先后顺序吗

​	A:index代表第n条数据，`（,）` 没有先后顺序

Q2:$和#区别

-  不论是单个参数，还是多个参数，一律都建议使用注解@Param("") 

-  能用 #{} 的地方就用 #{}，不用或少用 ${} 

-  表名作参数时，必须用 ${}。如：select * from ${tableName} 

-  order by 时，必须用 ${}。如：select * from t_user order by ${columnName} 

-  使用 ${} 时，要注意何时加或不加单引号，即 ${} 和 '${}' 

  参考:[$和#区别](https://blog.csdn.net/siwuxie095/article/details/79190856?utm_medium=distribute.pc_relevant.none-task-blog-BlogCommendFromBaidu-1.channel_param&depth_1-utm_source=distribute.pc_relevant.none-task-blog-BlogCommendFromBaidu-1.channel_param)
  
-   `${}`是 Properties 文件中的变量占位符，它可以用于标签属性值和 sql 内部，属于静态文本替换，比如${driver}会被静态替换为`com.mysql.jdbc.Driver` 

-  [CDATA](https://www.cnblogs.com/ferby/p/9799164.html)的使用    <![CDATA[  ]]>   避免特殊字符被转义

Q3:mybatis中参数区分大小写吗？param.orderId

```java
方法一:
mapper 
List<HashMap<String, Object>> findReceiveAndSendNoList(Map<String, String> map);

xml
 <if test="sendNO!=null and sendNO!=''">
 AND send_no=#{sendNO}
 </if>

方法二:
mapper 
List<HashMap<String, Object>> findReceiveAndSendNoList(@("param")Map<String, String> map);

xml
 <if test="param.sendNO!=null and param.sendNO!=''">
 AND send_no=#{param.sendNO}
 </if>
```

Q4:解决mybati中1=1问题[ where 1=1 会造成sql注入，所以尽量避免使用 ]

[Mybatis 1=1问题](https://blog.csdn.net/u013394212/article/details/100560205?utm_medium=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-2.channel_param&depth_1-utm_source=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-2.channel_param)

```xml
<!-- 方法一 -->
SELECT
receive_no receiveNo,
send_no sendNo
FROM line
<!-- 将where条件改为如下所示 -->
<trim prefix="WHERE" prefixOverrides="AND |OR ">
<if test="sendNO!=null and sendNO!=''">
    AND send_no=#{sendNO}
</if>
<if test="receiveNo!=null and receiveNo!=''">
    AND receive_no=#{receiveNo}
</if>
</trim>

<!-- 方法二 -->
使用<Where>标签
SELECT
receive_no receiveNo,
send_no sendNo
FROM line
<where>
<if test="sendNO!=null and sendNO!=''">
    AND send_no=#{sendNO}
</if>
<if test="receiveNo!=null and receiveNo!=''">
    AND receive_no=#{receiveNo}
</if>
</where>
    
where 元素知道只有在一个以上的if条件有值的情况下才去插入“WHERE”子句。而且，若最后的内容是“AND”或“OR”开头的，where 元素也知道如何将他们去除。
    
```



Q5:mybatis中常用标签的使用

```xml
 <select id="findReceiveAndSendNoList" resultType="map">
        SELECT
        receive_no receiveNo,
        send_no sendNo
        FROM line
        <where>
            <if test="param.sendNO!=null and param.sendNO!=''">
                AND send_no=#{param.sendNO}
            </if>
            <if test="param.receiveNo!=null and param.receiveNo!=''">
                AND receive_no=#{param.receiveNo}
            </if>
            <!--拼接字符串和使用小于号 -->
            <if test="param.carrierNo!=null and param.carrierNo!=''">
                AND carrie_no like CONCAT('%',#{param.carrierNo},'%')
                AND line_id>0 AND line_id &lt;100
            </if>
            <if test="param.idList!=null and param.idList.size>0">
                AND line_id IN
                <!-- in (A OR B) separator 改为 OR -->
                <foreach collection="param.idList" item="item" index="index" open="(" separator="," close=")">
                    #{item}
                </foreach>
            </if>
            <choose>
                <when test="param.isValid>0">
                    AND is_valid=1
                </when>
                <otherwise>
                    AND is_valid=0
                </otherwise>
            </choose>
            <if test="updateUser != null ">
                <!-- updateUser参数为1的时候查询数据库updateUser=111 数据，其他的数据为null数据-->
                AND #{updateUser}=CASE WHEN updateUser = 111 THEN 1 ELSE 0 END
            </if>
        </where>
    </select>

```

Q6：Map和HashMap的区别

Map是一个接口，HashMap实现接口

比如Map是一辆汽车，而HashMap则是一个宝马牌的汽车



### 四、注解相关

#### 1. @Transient

数据库中的字段不被JPA保存在子段名称前面加上注解 @Transient 





### 五、参考文章

[变量错误]( https://blog.csdn.net/weixin_34092370/article/details/91548812 )

[多字段分组]( https://blog.csdn.net/kris1025/article/details/80714361 )

[java8通关]( https://juejin.im/post/6844904047695101960#heading-20 )

[GroupBy的使用]( https://www.cnblogs.com/tsing0520/p/13047783.html )






