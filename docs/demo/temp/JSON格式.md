### JSON的几种格式



#### 1.普通对象格式


```json
{
 "userName":"张三",
 "userCode":0
}
```

#### 2.集合格式

```json
[{
 "userName":"张三",
 "userCode":0
},{
 "userName":"李四",
 "userCode":1
}]
```

#### 3.集合套集合

```json
{
    "GRInfo":[
        {
            "asnId":"111",
            "sku":[
                {
                    "quantity":10,
                    "skuId":"A001"
                },
                {
                    "quantity":20,
                    "skuId":"A002"
                }
            ]
        },
        {
            "asnId":"222",
            "sku":[
                {
                    "quantity":10,
                    "skuId":"A003"
                },
                {
                    "quantity":20,
                    "skuId":"A004"
                }
            ]
        }
    ]
}
```

