
### Jquery


```js
//取值
var bookingID = $("#hidBookingID").val();
//赋值
 $("#hidBookingID").val('123');

//查找ID
$("input[id^='code']");//id属性以code开始的所有input标签

$("input[id$='code']");//id属性以code结束的所有input标签

$("input[id*='code']");//id属性包含code的所有input标签

$("input[name^='code']");//name属性以code开始的所有input标签

$("input[name$='code']");//name属性以code结束的所有input标签

$("input[name*='code']");//name属性包含code的所有input标签

//设置class[删除ID的class属性并设置属性为circle]
$("#btnId").removeClass("icon_correct_gray").addClass("icon_correct_no_circle");

//修改btn的class属性
$("#btnId").attr('class', 'icon_correct_no_circle')
//添加class
$("h1,h2,p").addClass("blue");

//设置选中触发事件
  $("input[id*='_iptremark']").blur(function () {
  //todo可以写ajax方法调用 
  });

//将ID按照_分割
 var varId = id.split("_")[0];

//循环
$("button").click(function(){
  $("li").each(function(){
    alert($(this).text())
  });
});

//隐藏
$("#hide").click(function(){
  $("p").hide();
});

//展示
$("#show").click(function(){
  $("p").show();
});

//获取属性值
var selType = $("a[name='sel_btn'].weui-btn_primary").attr("value");

//元素的开头插入
$("p").append("Some appended text.");

//元素的末尾插入
$("p").prepend("Some prepended text.");

//radio选中
<input type="radio" name="rid" id="rdoYes" value="1" />
$("#rdoYes").attr("checked", true);

//根据name选中
<input type="checkbox" name="QualifiedReason" id="reason1"/>
$("input[name='QualifiedReason']").attr("checked", false);

//根据value选中
$("input[value='reason1']").attr("checked", false);
```

### HTML

```js
//常用样式设置
style="display:none; 设置为不展示/disabled

//设置格式
class="table-td-input" placeholder="请输入" type="number" pattern="[0-9]*"
<input id="remarkId" style="width: 100%; text-align: center;color:red value="备注信息" ">

```


### 正则实例

```js

//用户名正则，4到16位（字母，数字，下划线，减号）
var uPattern = /^[a-zA-Z0-9_-]{4,16}$/;
//输出 true
console.log(uPattern.test("iFat3"));
密码强度正则
//密码强度正则，最少6位，包括至少1个大写字母，1个小写字母，1个数字，1个特殊字符
var pPattern = /^.*(?=.{6,})(?=.*\d)(?=.*[A-Z])(?=.*[a-z])(?=.*[!@#$%^&*? ]).*$/;
//输出 true
console.log("=="+pPattern.test("iFat3#"));
整数正则
//正整数正则
var posPattern = /^\d+$/;
//负整数正则
var negPattern = /^-\d+$/;
//整数正则
var intPattern = /^-?\d+$/;
//输出 true
console.log(posPattern.test("42"));
//输出 true
console.log(negPattern.test("-42"));
//输出 true
console.log(intPattern.test("-42"));
数字正则
可以是整数也可以是浮点数

//正数正则
var posPattern = /^\d*\.?\d+$/;
//负数正则
var negPattern = /^-\d*\.?\d+$/;
//数字正则
var numPattern = /^-?\d*\.?\d+$/;
console.log(posPattern.test("42.2"));
console.log(negPattern.test("-42.2"));
console.log(numPattern.test("-42.2"));
Email正则
//Email正则
var ePattern = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
//输出 true
console.log(ePattern.test("65974040@qq.com"));
手机号码正则
//手机号正则
var mPattern = /^[1][3][0-9]{9}$/;
//输出 true
console.log(mPattern.test("13900000000"));
身份证号正则
//身份证号（18位）正则
var cP = /^[1-9]\d{5}(18|19|([23]\d))\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$/;
//输出 true
console.log(cP.test("11010519880605371X"));
URL正则
//URL正则
var urlP= /^((https?|ftp|file):\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/;
//输出 true
console.log(urlP.test("http://42du.cn"));
IPv4地址正则
//ipv4地址正则
var ipP = /^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/;
//输出 true
console.log(ipP.test("115.28.47.26"));
十六进制颜色正则
//RGB Hex颜色正则
var cPattern = /^#?([a-fA-F0-9]{6}|[a-fA-F0-9]{3})$/;
//输出 true
console.log(cPattern.test("#b8b8b8"));
日期正则
//日期正则，简单判定,未做月份及日期的判定
var dP1 = /^\d{4}(\-)\d{1,2}\1\d{1,2}$/;
//输出 true
console.log(dP1.test("2017-05-11"));
//输出 true
console.log(dP1.test("2017-15-11"));
//日期正则，复杂判定
var dP2 = /^(?:(?!0000)[0-9]{4}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-8])|(?:0[13-9]|1[0-2])-(?:29|30)|(?:0[13578]|1[02])-31)|(?:[0-9]{2}(?:0[48]|[2468][048]|[13579][26])|(?:0[48]|[2468][048]|[13579][26])00)-02-29)$/;
//输出 true
console.log(dP2.test("2017-02-11"));
//输出 false
console.log(dP2.test("2017-15-11"));
//输出 false
console.log(dP2.test("2017-02-29"));
QQ号码正则
//QQ号正则，5至11位
var qqPattern = /^[1-9][0-9]{4,10}$/;
//输出 true
console.log(qqPattern.test("65974040"));
微信号正则
//微信号正则，6至20位，以字母开头，字母，数字，减号，下划线
var wxPattern = /^[a-zA-Z]([-_a-zA-Z0-9]{5,19})+$/;
//输出 true
console.log(wxPattern.test("RuilongMao"));
车牌号正则
//车牌号正则
var cPattern = /^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[A-Z]{1}[A-Z0-9]{4}[A-Z0-9挂学警港澳]{1}$/;
//输出 true
console.log(cPattern.test("京K39006"));
包含中文正则
//包含中文正则
var cnPattern = /[\u4E00-\u9FA5]/;
//输出 true
console.log(cnPattern.test("42度"));

 
Regex_Phones: /^[0-9],$/, // 数字和逗号
Regex_Ident: /^([a-zA-Z0-9]){1,50}$/, //英文、数字且不能包含英文标点和特殊符号(渠道标识)
Regex_IdentName: /^([\u2E80-\u9FFF]|[a-zA-Z0-9]){1,50}$/, //中文、英文、数字且不能包含英文标点和特殊符号(渠道名称)
Regex_MondyNum: /^\d+(\.\d{1,2})?$/, //金额，允许两位小数
Regex_MondyCh: /^[\u4e00-\u9fa5]+$/, //只能为中文
Regex_PhoneNum: /(^(([0\+]\d{2,3}-)?(0\d{2,3})-)(\d{7,8})(-(\d{3,}))?$)|(^0{0,1}1[3|4|5|6|7|8|9][0-9]{9}$)/, //电话号码和手机
Regex_ZNum: /^[1-9]\d*$/ //正整数
Regex_Name: /^[a-zA-Z][a-zA-Z0-9_@]{0,30}$/, // 用户名
Regex_NickName: /^[\u4E00-\u9FA5A-Za-z0-9_\-]+$/, // 中文/英文/数字， (昵称、组名、朋友备注名、内容名称、书名、页名) 
Regex_Passport: /^1[45][0-9]{7}$|G[0-9]{8}$|P\.[0-9]{7}$|S[0-9]{7,8}$|D[0-9]{7,8}$/, // 护照
Regex_BizLience: /^([0-9a-zA-Z]{18}$|\d{15}$)/, // 营业执照,三证合一的是18位
Regex_isExitZh:/[\u4E00-\u9FA5\uF900-\uFA2D]/, // 验证是否存在中文
Regex_price:/^\d+(\.\d{1,2})?$/ // 数字 . 最多两位有效数字
Regex_EnghlishNum:/^(?=.*\d)(?=.*[a-z])[a-zA-Z\d]{6,20}$/ //6至20位英文和数字组合
Regex_Phone: /^0?(13[0-9]|15[012356789]|18[0-9]|14[57])[0-9]{8}$/, // 手机号
Regex_Mobile: /^0?(13[0-9]|15[012356789]|18[0-9]|14[57])[0-9]{8}$/, // 手机号
Regex_Card: /\\d{14}[[0-9],0-9xX]/, // 身份证号 
Regex_Email: /^[a-zA-Z0-9]+([._\\-]*[a-zA-Z0-9])*@([a-zA-Z0-9]+[-a-zA-Z0-9]*[a-zA-Z0-9]+.){1,63}[a-zA-Z0-9]+$/, // 邮箱
Regex_RealName: /^[a-zA-Z\u4e00-\u9fa5]{0,}$/, // 真实姓名、朋友昵称、朋友全称、组名称、组标签
Regex_text: /^[\u4e00-\u9fa5]{0,}$/, // 地区 、省份、城市


js 中的正则校验证:
var re = /^[0-9]+.?[0-9]*$/;
var pattern = new RegExp("[`~!@#$^&*()=|{}':;',\\[\\].<>《》/?~！@#￥……&*（）——|{}【】‘；：”“'。，、？]");
    if(pattern.test(_value)){
        alert('不允许有特殊字符!');
    }


if(re .test(_value)){
    alert('不允许有数字！');
}

if (number.length != 8) {
    alert('必须8位数字!');
   }

```

