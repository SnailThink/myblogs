## **maven setting.xml 中文配置详解（全配置）**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!--
 | 官方文档: https://maven.apache.org/settings.html
 |
 | Maven 提供以下两种 level 的配置:
 |
 |  1. User Level.      当前用户独享的配置, 通常在 ${user.home}/.m2/settings.xml 目录下。 
 |                      可在 CLI 命令行中通过以下参数设置:  -s /path/to/user/settings.xml
 |
 |  2. Global Level.    同一台计算机上的所有 Maven 用户共享的全局配置。 通常在${maven.home}/conf/settings.xml目录下。
 |                      可在 CLI 命令行中通过以下参数设置:  -gs /path/to/global/settings.xml
 |
 |  备注:  User Level 优先级 > Global Level
 |-->

<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">
    <!--
     | Maven 依赖搜索顺序, 当我们执行 Maven 命令时, Maven 开始按照以下顺序查找依赖的库: 
     |
     | 步骤 1 － 在本地仓库中搜索, 如果找不到, 执行步骤 2, 如果找到了则执行其他操作。
     | 步骤 2 － 在中央仓库中搜索, 如果找不到, 并且有一个或多个远程仓库已经设置, 则执行步骤 4, 如果找到了则下载到本地仓库中已被将来引用。
     | 步骤 3 － 如果远程仓库没有被设置, Maven 将简单的停滞处理并抛出错误（无法找到依赖的文件）。
     | 步骤 4 － 在一个或多个远程仓库中搜索依赖的文件, 如果找到则下载到本地仓库已被将来引用, 否则 Maven 将停止处理并抛出错误（无法找到依赖的文件）。
     |-->

    <!-- 地仓库路径, 默认值: ${user.home}/.m2/repository -->
    <localRepository>${user.home}/workspace/env/maven/repository</localRepository>

    <!-- 当 maven 需要输入值的时候, 是否交由用户输入, 默认为true；false 情况下 maven 将根据使用配置信息进行填充 -->
    <interactiveMode>true</interactiveMode>

    <!-- 是否支持联网进行 artifact 下载、 部署等操作, 默认: false -->
    <offline>false</offline>

    <!-- 
     | 搜索插件时, 如果 groupId 没有显式提供时, 则以此处配置的 groupId 为默认值, 可以简单理解为默认导入这些 groupId 下的所有 artifact（需要时才下载）
     | 默认情况下该列表包含了 org.apache.maven.plugins和org.codehaus.mojo
     |
     | 查看插件信息: 
     |    mvn help:describe -Dplugin=org.apache.maven.plugins:maven-compiler-plugin:3.5.1 -Ddetail
     |-->
    <pluginGroups>

        <!-- plugin 的 groupId -->
        <!--
        <pluginGroup>com.your.plugins</pluginGroup>
        -->

    </pluginGroups>

    <!-- 进行远程服务器访问时所需的授权配置信息。通过系统唯一的 server-id 进行唯一关联 -->
    <servers>
        <server>
            <!-- 这是 server 的 id, 该 id 与 distributionManagement 中 repository 元素的id 相匹配 -->
            <id>server_id</id>

            <!-- 鉴权用户名 -->
            <username>auth_username</username>

            <!-- 鉴权密码 -->
            <password>auth_pwd</password>

            <!-- 鉴权时使用的私钥位置。和前两个元素类似, 私钥位置和私钥密码指定了一个私钥的路径（默认是/home/hudson/.ssh/id_dsa）以及如果需要的话, 一个密钥 -->
            <privateKey>path/to/private_key</privateKey>

            <!-- 鉴权时使用的私钥密码, 非必要, 非必要时留空 -->
            <passphrase>some_passphrase</passphrase>

            <!-- 
             | 文件被创建时的权限。如果在部署的时候会创建一个仓库文件或者目录, 这时候就可以使用权限（permission）
             | 这两个元素合法的值是一个三位数字, 其对应了unix文件系统的权限, 如664, 或者775 
             |-->
            <filePermissions>664</filePermissions>

            <!-- 目录被创建时的权限 -->
            <directoryPermissions>775</directoryPermissions>

            <!-- 传输层额外的配置项 -->
            <configuration></configuration>

        </server>
    </servers>

    <!-- 
   | 从远程仓库才下载 artifacts 时, 用于替代指定远程仓库的镜像服务器配置；
   | 
   | 例如当您无法连接上国外的仓库是, 可以指定连接到国内的镜像服务器；
   |
   | pom.xml 和 setting.xml 中配置的仓库和镜像优先级关系（mirror 优先级高于 repository）: 
   |
   |    repository（setting.xml） < repository（pom.xml） < mirror（setting.xml）
   |
   |    例如, 如果配置了 mirrorOf = *,  则 不管项目的 pom.xml 配置了什么仓库, 最终都会被镜像到 镜像仓库
   |
   |  私服的配置推荐用profile配置而不是mirror
   |-->
    <mirrors>

        <!-- 
         | 【mirro 匹配顺序】: 
         | 多个 mirror 优先级 按照 id字母顺序进行排列（即与编写的顺序无关）
         | 在第一个 mirror 找不到 artifact, 不会继续超找下一个镜像。
         | 只有当 mirror 无法链接的时候, 才会尝试链接下一个镜像, 类似容灾备份。
         |-->

        <!-- 上海交通大学反向代理 --> 
        <mirror>

            <!-- 该镜像的唯一标识符, id用来区分不同的 mirror 元素, 同时会套用使用 server 中 id 相同授权配置链接到镜像 -->
            <id>sjtugmaven</id>

            <!-- 镜像名称, 无特殊作用, 可视为简述 -->
            <name>sjtug maven proxy</name>

            <!-- 镜像地址 -->
            <url>https://mirrors.sjtug.sjtu.edu.cn/maven-central/</url>
            <!-- 被镜像的服务器的id, 必须与 repository 节点设置的 ID 一致。但是 This must not match the mirror id
             | mirrorOf 的配置语法: 
             | *           = 匹配所有远程仓库。 这样所有 pom 中定义的仓库都不生效
             | external:*  = 匹配除 localhost、使用 file:// 协议外的所有远程仓库
             | repo1,repo2 = 匹配仓库 repo1 和 repo2
             | *,!repo1    = 匹配所有远程仓库, repo1 除外
             |-->
            <mirrorOf>central</mirrorOf>
        </mirror>

    </mirrors>

    <!-- 用来配置不同的代理, 多代理 profiles 可以应对笔记本或移动设备的工作环境: 通过简单的设置 profile id 就可以很容易的更换整个代理配置 -->
    <proxies>

        <!-- 代理元素包含配置代理时需要的信息 -->
        <proxy>

            <!-- 代理的唯一定义符, 用来区分不同的代理元素 -->
            <id>example_proxy</id>

            <!-- 该代理是否是激活的那个。true则激活代理。当我们声明了一组代理, 而某个时候只需要激活一个代理的时候, 该元素就可以派上用处 -->
            <active>false</active>

            <!-- 代理的协议 -->
            <protocol>https</protocol>

            <!-- 代理的主机名 -->
            <host>proxy.molo.com</host>

            <!-- 代理的端口 -->
            <port>443</port>

            <!-- 代理服务器认证的登录名 -->
            <username>proxy_user</username>

            <!-- 代理服务器认证登录密码 -->
            <password>proxy_pwd</password>

            <!-- 不该被代理的主机名列表。该列表的分隔符由代理服务器指定；例子中使用了竖线分隔符, 使用逗号分隔也很常见 -->
            <nonProxyHosts>*.google.com|ibiblio.org</nonProxyHosts>

        </proxy>

    </proxies>

    <!--
     | 构建方法的配置清单, maven 将根据不同环境参数来使用这些构建配置。
     | settings.xml 中的 profile 元素是 pom.xml 中 profile 元素的裁剪版本。
     | settings.xml 负责的是整体的构建过程, pom.xml 负责单独的项目对象构建过程。
     | settings.xml 只包含了id, activation, repositories, pluginRepositories 和 properties 元素。
     | 
     | 如果 settings 中的 profile 被激活, 它的值会覆盖任何其它定义在 pom.xml 中或 profile.xml 中的相同 id 的 profile。
     |
     | 查看当前激活的 profile:
     |   mvn help:active-profiles
     |-->
    <profiles>

        <profile>

            <!-- 该配置的唯一标识符 -->
            <id>profile_id</id>

            <!--
             | profile 的激活条件配置；
             | 其他激活方式: 
             | 1. 通过 settings.xml 文件中的 activeProfile 元素进行指定激活。
             | 2. 在命令行, 使用-P标记和逗号分隔的列表来显式的激活, 如: mvn clean package -P myProfile）。 
             |-->
            <activation>

                <!-- 是否默认激活 -->
                <activeByDefault>false</activeByDefault>

                <!--  内建的 java 版本检测, 匹配规则: https://maven.apache.org/enforcer/enforcer-rules/versionRanges.html -->
                <jdk>9.9</jdk>

                <!-- 内建操作系统属性检测, 配置规则: https://maven.apache.org/enforcer/enforcer-rules/requireOS.html -->
                <os>

                    <!-- 操作系统 -->
                    <name>Windows XP</name>

                    <!-- 操作系统家族 -->
                    <family>Windows</family>

                    <!-- 操作系统 -->
                    <arch>x86</arch>

                    <!-- 操作系统版本 -->
                    <version>5.1.2600</version>

                </os>

                <!--
                 | 如果Maven检测到某一个属性（其值可以在POM中通过${名称}引用）, 并且其拥有对应的名称和值, Profile就会被激活。
                 | 如果值字段是空的, 那么存在属性名称字段就会激活profile, 否则按区分大小写方式匹配属性值字段
                 |-->
                <property>

                    <!-- 属性名 -->
                    <name>mavenVersion</name>

                    <!-- 属性值 -->
                    <value>2.0.3</value>

                </property>
                
                <!-- 根据文件存在/不存在激活profile -->
                <file>

                    <!-- 如果指定的文件存在, 则激活profile -->
                    <exists>/path/to/active_on_exists</exists>

                    <!-- 如果指定的文件不存在, 则激活profile -->
                    <missing>/path/to/active_on_missing</missing>

                </file>

            </activation>
            <!-- 扩展属性设置。扩展属性可以在 POM 中的任何地方通过 ${扩展属性名} 进行引用
             |
             | 属性引用方式（包括扩展属性, 共 5 种属性可以引用）: 
             |
             | env.x                  : 引用 shell 环境变量, 例如, "env.PATH"指代了 $path 环境变量（在 Linux / Windows 上是 %PATH% ）.
             | project.x              : 引用 pom.xml（根元素就是 project） 中 xml 元素内容.例如 ${project.artifactId} 可以获取 pom.xml 中设置的 <artifactId /> 元素的内容
             | settings.x             : 引用 setting.xml（根元素就是 setting） 中 xml 元素内容, 例如 ${settings.offline}
             | Java System Properties : 所有可通过 java.lang.System.getProperties() 访问的属性都能在通过 ${property_name} 访问, 例如 ${java.home}
             | x                      : 在 <properties/> 或者 外部文件 中设置的属性, 都可以 ${someVar} 的形式使用
             | 
             |-->
            <properties>

                <!-- 在当前 profile 被激活时,  ${profile.property} 就可以被访问到了 -->
                <profile.property>this.property.is.accessible.when.current.profile.actived</profile.property>

            </properties>

            <!-- 远程仓库列表 -->
            <repositories>
                <!-- 
                 | releases vs snapshots
                 | maven 针对 releases、snapshots 有不同的处理策略, POM 就可以在每个单独的仓库中, 为每种类型的 artifact 采取不同的策略
                 | 例如: 
                 |     开发环境 使用 snapshots 模式实时获取最新的快照版本进行构建
                 |     生成环境 使用 releases 模式获取稳定版本进行构建
                 | 参见repositories/repository/releases元素 
                 |-->

                <!--
                 | 依赖包不更新问题:                
                 | 1. Maven 在下载依赖失败后会生成一个.lastUpdated 为后缀的文件。如果这个文件存在, 那么即使换一个有资源的仓库后, Maven依然不会去下载新资源。
                 |    可以通过 -U 参数进行强制更新、手动删除 .lastUpdated 文件：
                 |      find . -type f -name "*.lastUpdated" -exec echo {}" found and deleted" \; -exec rm -f {} \;
                 |
                 | 2. updatePolicy 设置更新频率不对, 导致没有触发 maven 检查本地 artifact 与远程 artifact 是否一致
                 |-->
                <repository>

                    <!-- 远程仓库唯一标识 -->
                    <id>maven_repository_id</id>

                    <!-- 远程仓库名称 -->
                    <name>maven_repository_name</name>

                    <!-- 远程仓库URL, 按protocol://hostname/path形式 -->
                    <url>http://host/maven</url>

                    <!-- 
                    | 用于定位和排序 artifact 的仓库布局类型-可以是 default（默认）或者 legacy（遗留）
                    | Maven 2为其仓库提供了一个默认的布局；然而, Maven 1.x有一种不同的布局。我们可以使用该元素指定布局是default（默认）还是legacy（遗留）
                    | -->
                    <layout>default</layout>

                    <!-- 如何处理远程仓库里发布版本的下载 -->
                    <releases>

                        <!-- 是否允许该仓库为 artifact 提供 发布版 / 快照版 下载功能 -->
                        <enabled>false</enabled>

                        <!-- 
                         | 每次执行构建命令时, Maven 会比较本地 POM 和远程 POM 的时间戳, 该元素指定比较的频率。
                         | 有效选项是: 
                         |     always（每次构建都检查）, daily（默认, 距上次构建检查时间超过一天）, interval: x（距上次构建检查超过 x 分钟）、 never（从不）
                         |
                         | 重要: 
                         |     设置为 daily, 如果 artifact 一天更新了几次, 在一天之内进行构建, 也不会从仓库中重新获取最新版本
                         |-->
                        <updatePolicy>always</updatePolicy>

                        <!-- 当 Maven 验证 artifact 校验文件失败时该怎么做: ignore（忽略）, fail（失败）, 或者warn（警告） -->
                        <checksumPolicy>warn</checksumPolicy>

                    </releases>

                    <!-- 如何处理远程仓库里快照版本的下载 -->
                    <snapshots>
                        <enabled />
                        <updatePolicy />
                        <checksumPolicy />
                    </snapshots>

                </repository>

                <!-- 
                    国内可用的 maven 仓库地址（updated @ 2019-02-08）：

                    http://maven.aliyun.com/nexus/content/groups/public
                    http://maven.wso2.org/nexus/content/groups/public/
                    http://jcenter.bintray.com/
                    http://maven.springframework.org/release/
                    http://repository.jboss.com/maven2/
                    http://uk.maven.org/maven2/
                    http://repo1.maven.org/maven2/
                    http://maven.springframework.org/milestone
                    http://maven.jeecg.org/nexus/content/repositories/
                    http://repo.maven.apache.org/maven2
                    http://repo.spring.io/release/
                    http://repo.spring.io/snapshot/
                    http://mavensync.zkoss.org/maven2/
                    https://repository.apache.org/content/groups/public/
                    https://repository.jboss.org/nexus/content/repositories/releases/   
                -->

            </repositories>

            <!-- 
             | maven 插件的远程仓库配置。maven 插件实际上是一种特殊类型的 artifact。
             | 插件仓库独立于 artifact 仓库。pluginRepositories 元素的结构和 repositories 元素的结构类似。
             |-->
            <!--
            <pluginRepositories>
                <pluginRepository>
                    <releases>
                        <enabled />
                        <updatePolicy />
                        <checksumPolicy />
                    </releases>
                    <snapshots>
                        <enabled />
                        <updatePolicy />
                        <checksumPolicy />
                    </snapshots>
                    <id />
                    <name />
                    <url />
                    <layout />
                </pluginRepository>
            </pluginRepositories>
            -->

        </profile>

    </profiles>

    <!--
     | 手动激活 profiles 的列表, 按照 profile 被应用的顺序定义 activeProfile
     | 任何 activeProfile, 不论环境设置如何, 其对应的 profile 都会被激活, maven 会忽略无效（找不到）的 profile
     |-->
    <!--
    <activeProfiles>
        <activeProfile>not-exits-profile</activeProfile>
    </activeProfiles>
    -->

</settings>
```

