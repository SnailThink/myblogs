

## JQuery

### 设置radio选中

``` js
//根据ID选中
 <input type="radio" name="rid" id="rdoYes" value="1" />
$("#rdoYes").attr("checked", true);

```





### 根据input

```js

//根据name选中
<input type="checkbox" name="QualifiedReason" id="reason1"/>
$("input[name='QualifiedReason']").attr("checked", false);

//根据value选中
$("input[value='reason1']").attr("checked", false);

```

