

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
```



### HTML

```js
//常用样式设置
style="display:none; 设置为不展示/disabled

//设置格式
class="table-td-input" placeholder="请输入" type="number" pattern="[0-9]*"
<input id="remarkId" style="width: 100%; text-align: center;color:red value="备注信息" ">

```

