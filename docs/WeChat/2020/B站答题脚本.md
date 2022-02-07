代码来自 https://gist.github.com/netnr/ca14266e2ca524d7f9fe206f0d4ec46e， 

感谢作者,为防止作者删除 ，做个备份,打开浏览器控制台，复制代码直接运行。



```javascript
var bbk = {
    //问题序号
    qno: 0,
    //答案序号
    ano: 0,
    init: function () {
        bbk.answer();
    },
    /**当前题目序号 */
    currNo: function () {
        return $('.title-number').text().trim().split(' ')[1].split('/')[0] * 1
    },
    /**
     * 答题
     */
    answer: function () {
        bbk.qno = bbk.currNo();
        console.log('正在回答第 ' + bbk.qno + ' 题 ...');

        //部分1、2
        if (bbk.qno <= 50) {

            //点击答案
            $('.answer-wrap')[bbk.ano++].click();

            //检测是否正确
            setTimeout(function () {
                if (bbk.currNo() > bbk.qno) {
                    bbk.ano = 0;

                    console.log('第 ' + bbk.qno + ' 题回答正确 √');
                }

                bbk.answer();
            }, 2000);
        }

    }
}

bbk.init();

```

