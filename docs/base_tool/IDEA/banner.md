

我们只需要在springboot项目的resources文件夹下面创建一个banner.txt文件，springboot启动的时候会去加载

```
${AnsiColor.BRIGHT_YELLOW}  
////////////////////////////////////////////////////////////////////  
//                          _ooOoo_                               //  
//                         o8888888o                              //  
//                         88" . "88                              //  
//                         (| ^_^ |)                              //  
//                         O\  =  /O                              //  
//                      ____/`---'\____                           //  
//                    .'  \\|     |//  `.                         //  
//                   /  \\|||  :  |||//  \                        //  
//                  /  _||||| -:- |||||-  \                       //  
//                  |   | \\\  -  /// |   |                       //  
//                  | \_|  ''\---/''  |   |                       //  
//                  \  .-\__  `-`  ___/-. /                       //  
//                ___`. .'  /--.--\  `. . ___                     //  
//              ."" '<  `.___\_<|>_/___.'  >'"".                  //  
//            | | :  `- \`.;`\ _ /`;.`/ - ` : | |                 //  
//            \  \ `-.   \_ __\ /__ _/   .-` /  /                 //  
//      ========`-.____`-.___\_____/___.-`____.-'========         //  
//                           `=---='                              //  
//      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        //  
//            佛祖保佑       永不宕机      永无BUG                　　//
//////////////////////////////////////////////////////////////////// 

```



这里有几个定制banner的网站，文字、图片都可以秀起来，怎么秀就看你的骚操作了

　　http://patorjk.com/software/taag

　　http://www.network-science.de/ascii/

　　http://www.degraeve.com/img2txt.php



banner.txt配置

`　　${AnsiColor.BRIGHT_RED}`：设置控制台中输出内容的颜色

`　　${application.version}`：用来获取`MANIFEST.MF`文件中的版本号

`　　${application.formatted-version}`：格式化后的`${application.version}`版本信息

`　　${spring-boot.version}`：Spring Boot的版本号

${spring-boot.formatted-version}`：格式化后的`${spring-boot.version}`版本信息

```
spring对banner的配置，来自springboot参考手册，Common application properties：https://docs.spring.io/spring-boot/docs/2.1.0.RELEASE/reference/htmlsingle/#common-application-properties
```



