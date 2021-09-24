

### Redis指南

1. Reids的安装
2. Redis数据类型
3. Redis.conf详解
4. Reids持久化
5. Redis主从复制
6. Redis缓存穿透和雪崩
7. Redis整合SpringBoot
8. Redis发布订阅
9. Redis常见问题

### 1.Redis的安装

**官网地址**

> https://redis.io/ 
>
> http://www.redis.cn/

**Windows 下安装**

**下载地址：**https://github.com/tporadowski/redis/releases。

Redis 支持 32 位和 64 位。这个需要根据你系统平台的实际情况选择，这里我们下载 **Redis-x64-xxx.zip**压缩包到 C 盘，解压后，将文件夹重新命名为 **redis**。

若从GitHub下载比较慢可以访问：可以访问百度云下载

链接：https://pan.baidu.com/s/1kBl0tOT_RzMpc6d1wSewCQ 
提取码：4d3p 

内容如下

![](https://gitee.com/VincentBlog/image/raw/master/image/20210303102148.png)

打开cmd窗口 使用cd进入文件中然后执行

> ```shell
> redis-server.exe redis.windows.conf
> ```

### 2.Redis数据类型

#### Redis-key

```
key
    keys * 获取所有的key
    select 0 选择第一个库
    move myString 1 将当前的数据库key移动到某个数据库,目标库有，则不能移动
    flush db      清除指定库
    flushall      清除所有库
    randomkey     随机key
    type key      类型
    
    set key1 value1 设置key
    get key1    获取key
    mset key1 value1 key2 value2 key3 value3
    mget key1 key2 key3
    del key1   删除key
    exists key      判断是否存在key
    expire key 10   10过期
    pexpire key 1000 毫秒
    persist key     删除过期时间
```

#### 2.1 String(字符串)

 这是最简单的类型，就是普通的 set 和 get，做简单的 KV 缓存。 

```
string
    set name cxx
    get name
    getrange name 0 -1        字符串分段
    getset name new_cxx       设置值，返回旧值
    mset key1 key2            批量设置
    mget key1 key2            批量获取
    setnx key value           不存在就插入（not exists）
    setex key time value      过期时间（expire）
    setrange key index value  从index开始替换value
    incr age        递增
    incrby age 10   递增
    decr age        递减
    decrby age 10   递减
    incrbyfloat     增减浮点数
    append          追加
    strlen          长度
    getbit/setbit/bitcount/bitop    位操作
```

#### 2.2 List(列表)

 List 是有序列表 

```
list
    lpush mylist a b c  左插入
    rpush mylist x y z  右插入
    lrange mylist 0 -1  数据集合
    lpop mylist  弹出元素
    rpop mylist  弹出元素
    llen mylist  长度
    lrem mylist count value  删除
    count > 0 : 从表头开始向表尾搜索，移除与 VALUE 相等的元素，数量为 COUNT 。
    count < 0 : 从表尾开始向表头搜索，移除与 VALUE相等的元素，数量为COUNT的绝对值。
    count = 0 : 移除表中所有与 VALUE 相等的值。
    lindex mylist 2          指定索引的值
    lset mylist 2 n          索引设值
    ltrim mylist 0 4         删除key
    linsert mylist before a  插入
    linsert mylist after a   插入
    rpoplpush list list2     转移列表的数据
```



#### 2.3 Set(集合)

 Set 是无序集合，会自动去重的那种。 

```
set
    sadd myset redis 
    smembers myset       获取所有数据集合
    srem myset value     删除value
    sismember myset set1 判断元素是否在集合中
    scard key_name       个数
    sdiff | sinter | sunion 操作：集合间运算：差集 | 交集 | 并集
    srandmember          随机获取集合中的元素
    spop                 从集合中弹出一个元素
```

#### 2.4 Hash(哈希)

这个是类似 Map 的一种结构，这个一般就是可以将结构化的数据，比如一个对象（前提是这个对象没嵌套其他的对象）给缓存在 Redis 里，然后每次读写缓存的时候，可以就操作 Hash里的某个字段。 

```
hash
    hset myhash name cxx 		赋值
    hget myhash name			查询
    hmset myhash name cxx age 25 note "i am notes"
    hmget myhash name age note   
    hgetall myhash               获取所有的
    hexists myhash name          是否存在
    hsetnx myhash score 100      设置不存在的
    hincrby myhash id 1          递增
    hdel myhash name             删除
    hkeys myhash                 只取key
    hvals myhash                 只取value
    hlen myhash                  长度
```

#### 2.5 Zset(有序集合)

 Sorted set 是排序的 Set，去重但可以排序，写进去的时候给一个分数，自动根据分数排序。 

```shell
zset
    zadd zset 1 one
    zadd zset 2 two
    zadd zset 3 three
    zincrby zset 1 one              增长分数
    zscore zset two                 获取分数
    zrange zset 0 -1 withscores     范围值
    zrangebyscore zset 10 25 withscores 指定范围的值
    zrangebyscore zset 10 25 withscores limit 1 2 分页
    Zrevrangebyscore zset 10 25 withscores  指定范围的值
    zcard zset  元素数量
    Zcount zset 获得指定分数范围内的元素个数
    Zrem zset one two        删除一个或多个元素
    Zremrangebyrank zset 0 1  按照排名范围删除元素
    Zremrangebyscore zset 0 1 按照分数范围删除元素
    Zrank zset 0 -1    分数最小的元素排名为0
    Zrevrank zset 0 -1  分数最大的元素排名为0
    Zinterstore
    zunionstore rank:last_week 7 
    rank:20150323 rank:20150324
    rank:20150325  weights 1 1 1 1 1 1 1
```



### 3.Redis.conf详解

**快照**

持久化，在规定时间内，执行了多少次操作，则会持久化到rdb aof redis是内存数据库

```shell
# 如果900s内，如果至少有一个1 key进行了修改，我们及进行持久化操作 
save 900 1
# 如果300s内，如果至少10 key进行了修改，我们及进行持久化操作
save 300 10
# 如果60s内，如果至少10000 key进行了修改，我们及进行持久化操
save 60 10000

stop-writes-on-bgsave-error yes   # 持久化如果出错，是否还需要继续工作！

rdbcompression yes # 是否压缩 rdb 文件，需要消耗一些cpu资源！

rdbchecksum yes # 保存rdb文件的时候，进行错误的检查校验！

dir ./  # rdb 文件保存的目录
```

**端口**

Redis默认端口号为6379若要修改直接修改 `redis.windows.conf`文件

```shell
# Accept connections on the specified port, default is 6379 (IANA #815344).
# If port 0 is specified Redis will not listen on a TCP socket.
port 6379
```

**SECURITY 安全【设置Redis密码】**

```shell
127.0.0.1:6379> ping 
PONG 
127.0.0.1:6379> config get requirepass   # 获取redis的密码 
1) "requirepass"
2) "" 
127.0.0.1:6379> config set requirepass "123456"   # 设置redis的密码 
OK 
127.0.0.1:6379> config get requirepass   # 发现所有的命令都没有权限了 
(error) NOAUTH Authentication required. 
127.0.0.1:6379> ping (error) NOAUTH Authentication required. 127.0.0.1:6379> auth 123456  # 使用密码进行登录！ 
OK 
127.0.0.1:6379> config get requirepass 
1) "requirepass" 
2) "123456" 
```

**限制CLIENTS**

```shell
maxclients 10000   # 设置能连接上redis的大客户端的数量
maxmemory <bytes>  # redis 配置大的内存容量
maxmemory-policy noeviction  # 内存到达上限之后的处理策略    
1、volatile-lru：只对设置了过期时间的key进行LRU（默认值）     
2、allkeys-lru ： 删除lru算法的key       
3、volatile-random：随机删除即将过期key       
4、allkeys-random：随机删除       
5、volatile-ttl ： 删除即将过期的       
6、noeviction ： 永不过期，返回错误
```

**APPEND ONLY 模式  AOF配置**

```shell
appendonly no    # 默认是不开启aof模式的，默认是使用rdb方式持久化的，在大部分所有的情况下， rdb完全够用！ 
appendfilename "appendonly.aof"  # 持久化的文件的名字

# appendfsync always   # 每次修改都会 sync。消耗性能 
appendfsync everysec   # 每秒执行一次 sync，可能会丢失这1s的数据！ 
# appendfsync no       # 不执行 sync，这个时候操作系统自己同步数据，速度快！
```

### 4.Reids持久化

#### 4.1 RDB(Redis DataBase)

**什么是RDB**

在指定的时间间隔内将内存中的数据集快照写入磁盘，也就是行话讲的Snapshot快照，
它恢复时是将快 照文件直接读到内存里。
Redis会单独创建（fork）一个子进程来进行持久化，会先将数据写入到一个临时文件中，待持久化过程都结束了，再用这个临时文件替换上次持久化好的文件。整个过程中，主进程是不进行任何IO操作的。这就确保了极高的性能。如果需要进行大规模数据的恢复，且对于数据恢复的完整性不是非常敏感，那RDB方式要比AOF方式更加的高效。RDB的缺点是后一次持久化后的数据可能丢失。我们默认的就是 RDB，一般情况下不需要修改这个配置

**触发机制**

1. save的规则满足的情况下 会自动触发rdb规则
2. 执行flushall命令 也会触发rdb规则
3. 退出redis 也会产生rdb文件

备份就会自动生成一个dump.rdb

**恢复rdb文件**

1. 将rdb文件放在redis启动目录就可以，redis启的时候会自动检查dump.rdb恢复数据
2. 查看要存在的位置

```powershell
127.0.0.1:6379> config get dir 
1) "dir" 
2) "/usr/local/bin"# 如果在这个目录下存在 dump.rdb文件，启动就会自动恢复其中的数据 
```

**优点**

1. 适合大规模数据恢复
2. 对数据的完整性要求不高

**缺点**

1. 需要一定的间隔时间操作 如果redis宕机 那么最后一次修改的数据就没有了
2. fork进程的时候 会占用一定的内存空间

#### 4.2 AOF(Append Only File)

**什么是AOF**

将所有的命令都记录，恢复的时候将这个文件全部执行一遍

以日志的形式进行记录每个操作，将redis执行的所有的命令都记录[读操作不记录]，只能追加文件不能修改文件，redis启动开始就会读取文件重新构造数据，[redis重启的时候就根据日志文件的内容将写指令从前到后执行一次完成数据的恢复]

AOF保存的是 appendonly.aof文件

**append**

默认是不开启的 我们需要手动进行配置！我们只要将appendonly 改为yes就开启了aof

重启redis 就可以生效

```shell
# Please check http://redis.io/topics/persistence for more information.

appendonly yes

# The name of the append only file (default: "appendonly.aof")
appendfilename "appendonly.aof"
```

**恢复aof数据**

redis 提供了一个工具 `redis-check-aof -fix`



**重写规则说明**

aof默认就是文件的无限追加 文件会越来越大

![](https://gitee.com/VincentBlog/image/raw/master/image/20210303102149.png)

若aof文件大于64m！fork一个新的进程将文件进行重写

**优点**

```shell
appendonly no    # 默认是不开启aof模式的，默认是使用rdb方式持久化的，在大部分所有的情况下， rdb完全够用！ 
appendfilename "appendonly.aof"  # 持久化的文件的名字
# appendfsync always   # 每次修改都会 sync。消耗性能 
appendfsync everysec   # 每秒执行一次 sync，可能会丢失这1s的数据！ 
# appendfsync no       # 不执行 sync，这个时候操作系统自己同步数据，速度快！
# rewrite  重写， 
```

1. 每一次修改都同步 文件的完整性更好
2. 每秒同步一次，可能会丢失一秒的数据
3. 从不同步，效率最高的

**缺点**

1. 相对于数据文件来说 aof远远大于rdb 恢复速度也比rdb慢
2. aof运行效率也要比rdb慢 所以redis默认配置是rdb持久化

**扩展**

1. Rdb持久化方式能够在指定的时间间隔对数据进行快照存储

2. Aof持久化方式每次对服务器写操作当服务器重启的时候回重新执行这些命令恢复原始数据AOF命令以redis协议追加保存每次写的操作到文件末尾，Redis还能对AoF文件进行后台重写使得Aof的文件体积不至于过大

3. 只做缓存 若只希望数据在服务器运行的时候存在 也可以不做持久化

4. 同时开启两种持久化方式

   - 在这种情况下，当redis重启的时候会优先载入AOF文件来恢复原始的数据，
    因为在通常情况下AOF 文件保存的数据集要比RDB文件保存的数据集要完整。
   
   - DB 的数据不实时，同时使用两者时服务器重启也只会找AOF文件，
    那要不要只使用AOF呢？作者建议不要，
   
     因为RDB更适合用于备份数据库（AOF在不断变化不好备份），快速重启，
    而且不会有 AOF可能潜在的Bug，留着作为一个万一的手段
   
5. 性能建议

   - 因为RDB文件只用作后备用途，建议只在Slave上持久化RDB文件，而且只要15分钟备份一次就够 了，只保留 save 900 1 这条规则。 
   - 如果Enable AOF ，好处是在恶劣情况下也只会丢失不超过两秒数据，启动脚本较简单只load自 己的AOF文件就可以了，代价一是带来了持续的IO，二是AOF rewrite 的后将 rewrite 过程中产 生的新数据写到新文件造成的阻塞几乎是不可避免的。只要硬盘许可，应该尽量减少AOF rewrite 的频率，AOF重写的基础大小默认值64M太小了，可以设到5G以上，默认超过原大小100%大小重 写可以改到适当的数值。 
   - 如果不Enable AOF ，仅靠 Master-Slave Repllcation 实现高可用性也可以，能省掉一大笔IO，也 减少了rewrite时带来的系统波动。代价是如果Master/Slave 同时倒掉，会丢失十几分钟的数据， 启动脚本也要比较两个 Master/Slave 中的 RDB文件，载入较新的那个，微博就是这种架构。

### 5.Redis主从复制

主从复制，是指将一台Redis服务器的数据，复制到其他Redis服务器，前者称为主节点（master/leader）,后者称为从节点（slave/follower）；数据的复制是单向的，只能由主节点到从节点。Master以写为主 Salve以读为主

默认情况下每台redis服务器都是主节点；

且一个主节点可以有多个从节点(或者没有从节点) 但是一个从节点只能有一个主节点

**主从复制的主要包括**

1. 数据冗余：主从复制实现了数据的热备份 是持久化之外的一种数据冗余方式。
2. 故障恢复：当主节点出现问题时，可以由从节点提供服务实现快速的故障恢复；实际上是一种服务的冗余
3. 负载均衡：在主从复制的基础上，配合读写分离可以由主节点提供写服务 由从节点提供读服务（既写Redis数据时应连接主节点，写Redis数据时候连接从节点）分担服务器负载；尤其在写少读多的场景下，通过过个从节点分担读负载 可以提高Redis服务器的并发量。
4. 高可用（集群）基石：除了上述作用以外，主从复制还是哨兵和集群能够实施的基础，因此说主从复 制是Redis高可用的基础。 

一般来说，要将Redis运用于工程项目中，只使用一台Redis是万万不能的（宕机），原因如下：

1、从结构上，单个Redis服务器会发生单点故障，并且一台服务器需要处理所有的请求负载，压力较大；
2、从容量上，单个Redis服务器内存容量有限，就算一台Redis服务器内存容量为256G，也不能将所有 内存用作Redis存储内存，一般来说，单台Redis大使用内存不应该超过20G。
电商网站上的商品，一般都是一次上传，无数次浏览的，说专业点也就是"多读少写"。
对于这种场景，我们可以使如下这种架构： ![](https://gitee.com/VincentBlog/image/raw/master/image/20210303102150.png)

主从复制 读写分离80%的情况都是进行读操作！减缓服务器的压了！架构中经常使用！一主二从。

#### 环境配置

只配置从库，不用配置主库

```shell
127.0.0.1:6379> info replication   # 查看当前库的信息 
# Replication 
role:master  # 角色  
master connected_slaves:0 #  没有从机 master_replid:b63c90e6c501143759cb0e7f450bd1eb0c70882a master_replid2:0000000000000000000000000000000000000000 
master_repl_offset:0 
second_repl_offset:-1 
repl_backlog_active:0 
repl_backlog_size:1048576 
repl_backlog_first_byte_offset:0 
repl_backlog_histlen:0
```

配置3个配置文件 然后修改对应的信息

1. 端口
2. pid名字
3. log文件名字
4. dump.rdb名字

#### 一主二从

默认情况下，每台Redis服务器都是主节点：一般只配置从机就好了

```shell
127.0.0.1:6380> SLAVEOF 127.0.0.1 6379   #  SLAVEOF host 6379   找谁当自己的老大！ 
OK 
127.0.0.1:6380> info replication 
# Replication 
role:slave  # 当前角色是从机
master_host:127.0.0.1   # 可以的看到主机的信息 master_port:6379 

master_link_status:up 
master_last_io_seconds_ago:3 
master_sync_in_progress:0 
slave_repl_offset:14 
slave_priority:100 
slave_read_only:1 
connected_slaves:0 
master_replid:a81be8dd257636b2d3e7a9f595e69d73ff03774e master_replid2:0000000000000000000000000000000000000000 
master_repl_offset:14 
second_repl_offset:-1 
repl_backlog_active:1 
repl_backlog_size:1048576 
repl_backlog_first_byte_offset:1 
repl_backlog_histlen:14


# 在主机中查看！ 
127.0.0.1:6379> info replication 
# Replication
role:master 
connected_slaves:1  # 多了从机的配置 slave0:ip=127.0.0.1,port=6380,state=online,offset=42,lag=1    # 多了从机的配置 
master_replid:a81be8dd257636b2d3e7a9f595e69d73ff03774e master_replid2:0000000000000000000000000000000000000000 master_repl_offset:42 
second_repl_offset:-1
repl_backlog_active:1 
repl_backlog_size:1048576 
repl_backlog_first_byte_offset:1 
repl_backlog_histlen:42 
```

**复制原理**

Slave 启动成功连接到 master 后会发送一个sync同步命令
Master 接到命令，启动后台的存盘进程，同时收集所有接收到的用于修改数据集命令，在后台进程执行 完毕之后，master将传送整个数据文件到slave，并完成一次完全同步。 

全量复制：而slave服务在接收到数据库文件数据后，将其存盘并加载到内存中。

增量复制：Master 继续将新的所有收集到的修改命令依次传给slave，完成同步 但是只要是重新连接master，一次完全同步（全量复制）将被自动执行！ 我们的数据一定可以在从机中 看到！

### 6.Redis缓存穿透和雪崩

#### 缓存穿透

**概念**：用户想查询一条数据 发现Redis内存中没有 ,于是向持久层数据库查询，发现也没有

若恶意访问则导致所有的查询都打在了数据库上，这时候就相当于出现了缓存穿透。

**解决方法**:

1. 布隆过滤器

   布隆过滤器是一种数据结构，对所有可能查询的参数以hash形式存储，在控制器层先进行校验不符合则丢弃 从而避免对底层存储系统的查询压力

2. 做好参数效验 一些不合法的请求直接抛出异常信息

#### 缓存击穿（量太大 缓存过期）

**概念** 缓存击穿，是指一个key非常热点，在不停的扛着大并发，大并发集中 对这一个点进行访问，当这个key在失效的瞬间，持续的大并发就穿破缓存，直接请求数据库，就像在一 个屏障上凿开了一个洞。
当某个key在过期的瞬间，有大量的请求并发访问，这类数据一般是热点数据，由于缓存过期，会同时访 问数据库来查询新数据，并且回写缓存，会导使数据库瞬间压力过大。

**解决方法**

设置热点数据永不过期
从缓存层面来看，没有设置过期时间，所以不会出现热点 key 过期后产生的问题。

加互斥锁
分布式锁：使用分布式锁，保证对于每个key同时只有一个线程去查询后端服务，其他线程没有获得分布 式锁的权限，因此只需要等待即可。这种方式将高并发的压力转移到了分布式锁，因此对分布式锁的考 验很大。

#### 缓存雪崩

**概念** 缓存雪崩，是指在某一个时间段，缓存集中过期失效。Redis 宕机

产生雪崩的原因之一，比如在写本文的时候，马上就要到双十二零点，很快就会迎来一波抢购，这波商 品时间比较集中的放入了缓存，假设缓存一个小时。那么到了凌晨一点钟的时候，这批商品的缓存就都 过期了。而对这批商品的访问查询，都落到了数据库上，对于数据库而言，就会产生周期性的压力波峰。于是所有的请求都会达到存储层，存储层的调用量会暴增，造成存储层也会挂掉的情况。

其实集中过期，倒不是非常致命，比较致命的缓存雪崩，是缓存服务器某个节点宕机或断网。因为自然 形成的缓存雪崩，一定是在某个时间段集中创建缓存，这个时候，数据库也是可以顶住压力的。无非就 是对数据库产生周期性的压力而已。而缓存服务节点的宕机，对数据库服务器造成的压力是不可预知 的，很有可能瞬间就把数据库压垮。

**解决方法**

redis高可用 

这个思想的含义是，既然redis有可能挂掉，那我多增设几台redis，这样一台挂掉之后其他的还可以继续 工作，其实就是搭建的集群。**采用redis集群处理**

限流降级（在SpringCloud讲解过！）
这个解决方案的思想是，在缓存失效后，通过加锁或者队列来控制读数据库写缓存的线程数量。比如对 某个key只允许一个线程查询数据和写缓存，其他线程等待。

数据预热
数据加热的含义就是在正式部署之前，我先把可能的数据先预先访问一遍，这样部分可能大量访问的数 据就会加载到缓存中。在即将发生大并发访问前手动触发加载缓存不同的key，设置不同的过期时间，让 缓存失效的时间点尽量均匀。**设置随机失效时间/设置缓存永不过期**

### 7. Redis整合SpringBoot

1. 导入依赖

   ```xml
   <dependency>
       <groupId>org.springframework.boot</groupId>
       <artifactId>spring-boot-starter-redis</artifactId>
       <version>1.4.7.RELEASE</version>
   </dependency>
   ```

2. 配置连接

   ```yaml
   server.port=10008
   
   #访问地址
   spring.redis.host=127.0.0.1
   #访问端口
   spring.redis.port=6379
   #注意，如果没有password，此处不设置值，但这一项要保留
   spring.redis.password=
   #数据库下标
   spring.redis.dbIndex=0
   #最大空闲数，数据库连接的最大空闲时间。超过空闲时间，数据库连接将被标记为不可用，然后被释放。设为0表示无限制。
   spring.redis.maxIdle=300
   #连接池的最大数据库连接数。设为0表示无限制
   spring.redis.maxActive=600
   #最大建立连接等待时间。如果超过此时间将接到异常。设为-1表示无限制。
   spring.redis.maxWait=1000
   #在borrow一个jedis实例时，是否提前进行alidate操作；如果为true，则得到的jedis实例均是可用的；
   spring.redis.testOnBorrow=true
   ```

3. 测试

   ```java
    /**
        * 3. redis的基础Crud
        */
       @Test
       void redisCrudisTemplate() {
           //新增
           redisTemplate.opsForValue().set("key3", "value4");
           //查询
           String value= (String) redisTemplate.opsForValue().get("key3");
           System.out.println("@1"+value);
           //修改
           redisTemplate.opsForValue().set("key3", "value5");
           String valueNew= (String) redisTemplate.opsForValue().get("key3");
           System.out.println("@2"+valueNew);
           //删除
           redisTemplate.delete("key3");
       }
   ```

4. 编写RedisTemplete

   ```java
   
   /**
    * RedisTemplate 工具类
    *
    * @author SnilThink
    * @version 2020/01/21
    */
   @Component
   public final class RedisTemplateUtil {
   
       @Autowired
       @Qualifier("redisTemplate")
       private RedisTemplate redisTemplate;
   
       //- - - - - - - - - - - - - - - - - - - - -  公共方法 - - - - - - - - - - - - - - - - - - - -
   
       /**
        * 给一个指定的 key 值附加过期时间
        *
        * @param key
        * @param time
        * @return
        */
       public boolean expire(String key, long time) {
   
           return redisTemplate.expire(key, time, TimeUnit.SECONDS);
       }
   
       /**
        * 根据key 获取过期时间
        *
        * @param key
        * @return
        */
       public long getTime(String key) {
   
           return redisTemplate.getExpire(key, TimeUnit.SECONDS);
       }
   
       /**
        * 根据key 获取过期时间
        *
        * @param key
        * @return
        */
       public boolean hasKey(String key) {
           return redisTemplate.hasKey(key);
       }
   
       /**
        * 移除指定key 的过期时间
        *
        * @param key
        * @return
        */
       public boolean persist(String key) {
           return redisTemplate.boundValueOps(key).persist();
       }
   
       //- - - - - - - - - - - - - - - - - - - - -  String类型 - - - - - - - - - - - - - - - - - - - -
   
       /**
        * 根据key获取值
        *
        * @param key 键
        * @return 值
        */
       public Object get(String key) {
           return key == null ? null : redisTemplate.opsForValue().get(key);
       }
   
       /**
        * 将值放入缓存
        *
        * @param key   键
        * @param value 值
        * @return true成功 false 失败
        */
       public void set(String key, String value) {
           redisTemplate.opsForValue().set(key, value);
       }
   
       /**
        * 将值放入缓存并设置时间
        *
        * @param key   键
        * @param value 值
        * @param time  时间(秒) -1为无期限
        * @return true成功 false 失败
        */
       public void set(String key, String value, long time) {
           if (time > 0) {
               redisTemplate.opsForValue().set(key, value, time, TimeUnit.SECONDS);
           } else {
               redisTemplate.opsForValue().set(key, value);
           }
       }
   
       /**
        * 批量添加 key (重复的键会覆盖)
        *
        * @param keyAndValue
        */
       public void batchSet(Map<String, String> keyAndValue) {
           redisTemplate.opsForValue().multiSet(keyAndValue);
       }
   
       /**
        * 批量添加 key-value 只有在键不存在时,才添加
        * map 中只要有一个key存在,则全部不添加
        *
        * @param keyAndValue
        */
       public void batchSetIfAbsent(Map<String, String> keyAndValue) {
           redisTemplate.opsForValue().multiSetIfAbsent(keyAndValue);
       }
   
       /**
        * 对一个 key-value 的值进行加减操作,
        * 如果该 key 不存在 将创建一个key 并赋值该 number
        * 如果 key 存在,但 value 不是长整型 ,将报错
        *
        * @param key
        * @param number
        */
       public Long increment(String key, long number) {
           return redisTemplate.opsForValue().increment(key, number);
       }
   
       /**
        * 对一个 key-value 的值进行加减操作,
        * 如果该 key 不存在 将创建一个key 并赋值该 number
        * 如果 key 存在,但 value 不是 纯数字 ,将报错
        *
        * @param key
        * @param number
        */
       public Double increment(String key, double number) {
           return redisTemplate.opsForValue().increment(key, number);
       }
   
       //- - - - - - - - - - - - - - - - - - - - -  set类型 - - - - - - - - - - - - - - - - - - - -
   
       /**
        * 将数据放入set缓存
        *
        * @param key 键
        * @return
        */
       public void sSet(String key, String value) {
           redisTemplate.opsForSet().add(key, value);
       }
   
       /**
        * 获取变量中的值
        *
        * @param key 键
        * @return
        */
       public Set<Object> members(String key) {
           return redisTemplate.opsForSet().members(key);
       }
   
       /**
        * 随机获取变量中指定个数的元素
        *
        * @param key   键
        * @param count 值
        * @return
        */
       public void randomMembers(String key, long count) {
           redisTemplate.opsForSet().randomMembers(key, count);
       }
   
       /**
        * 随机获取变量中的元素
        *
        * @param key 键
        * @return
        */
       public Object randomMember(String key) {
           return redisTemplate.opsForSet().randomMember(key);
       }
   
       /**
        * 弹出变量中的元素
        *
        * @param key 键
        * @return
        */
       public Object pop(String key) {
           return redisTemplate.opsForSet().pop("setValue");
       }
   
       /**
        * 获取变量中值的长度
        *
        * @param key 键
        * @return
        */
       public long size(String key) {
           return redisTemplate.opsForSet().size(key);
       }
   
       /**
        * 根据value从一个set中查询,是否存在
        *
        * @param key   键
        * @param value 值
        * @return true 存在 false不存在
        */
       public boolean sHasKey(String key, Object value) {
           return redisTemplate.opsForSet().isMember(key, value);
       }
   
       /**
        * 检查给定的元素是否在变量中。
        *
        * @param key 键
        * @param obj 元素对象
        * @return
        */
       public boolean isMember(String key, Object obj) {
           return redisTemplate.opsForSet().isMember(key, obj);
       }
   
       /**
        * 转移变量的元素值到目的变量。
        *
        * @param key     键
        * @param value   元素对象
        * @param destKey 元素对象
        * @return
        */
       public boolean move(String key, String value, String destKey) {
           return redisTemplate.opsForSet().move(key, value, destKey);
       }
   
       /**
        * 批量移除set缓存中元素
        *
        * @param key    键
        * @param values 值
        * @return
        */
       public void remove(String key, Object... values) {
           redisTemplate.opsForSet().remove(key, values);
       }
   
       /**
        * 通过给定的key求2个set变量的差值
        *
        * @param key     键
        * @param destKey 键
        * @return
        */
       public Set<Set> difference(String key, String destKey) {
           return redisTemplate.opsForSet().difference(key, destKey);
       }
   
   
       //- - - - - - - - - - - - - - - - - - - - -  hash类型 - - - - - - - - - - - - - - - - - - - -
   
       /**
        * 加入缓存
        *
        * @param key 键
        * @param map 键
        * @return
        */
       public void add(String key, Map<String, String> map) {
           redisTemplate.opsForHash().putAll(key, map);
       }
   
       /**
        * 获取 key 下的 所有  hashkey 和 value
        *
        * @param key 键
        * @return
        */
       public Map<Object, Object> getHashEntries(String key) {
           return redisTemplate.opsForHash().entries(key);
       }
   
       /**
        * 验证指定 key 下 有没有指定的 hashkey
        *
        * @param key
        * @param hashKey
        * @return
        */
       public boolean hashKey(String key, String hashKey) {
           return redisTemplate.opsForHash().hasKey(key, hashKey);
       }
   
       /**
        * 获取指定key的值string
        *
        * @param key  键
        * @param key2 键
        * @return
        */
       public String getMapString(String key, String key2) {
           return redisTemplate.opsForHash().get("map1", "key1").toString();
       }
   
       /**
        * 获取指定的值Int
        *
        * @param key  键
        * @param key2 键
        * @return
        */
       public Integer getMapInt(String key, String key2) {
           return (Integer) redisTemplate.opsForHash().get("map1", "key1");
       }
   
       /**
        * 弹出元素并删除
        *
        * @param key 键
        * @return
        */
       public String popValue(String key) {
           return redisTemplate.opsForSet().pop(key).toString();
       }
   
       /**
        * 删除指定 hash 的 HashKey
        *
        * @param key
        * @param hashKeys
        * @return 删除成功的 数量
        */
       public Long delete(String key, String... hashKeys) {
           return redisTemplate.opsForHash().delete(key, hashKeys);
       }
   
   
       /**
        * 删除指定 hash 的 HashKey
        *
        * @param key
        */
       public void delete(String key) {
           redisTemplate.delete(key);
       }
   
   
       /**
        * 给指定 hash 的 hashkey 做增减操作
        *
        * @param key
        * @param hashKey
        * @param number
        * @return
        */
       public Long increment(String key, String hashKey, long number) {
           return redisTemplate.opsForHash().increment(key, hashKey, number);
       }
   
       /**
        * 给指定 hash 的 hashkey 做增减操作
        *
        * @param key
        * @param hashKey
        * @param number
        * @return
        */
       public Double increment(String key, String hashKey, Double number) {
           return redisTemplate.opsForHash().increment(key, hashKey, number);
       }
   
       /**
        * 获取 key 下的 所有 hashkey 字段
        *
        * @param key
        * @return
        */
       public Set<Object> hashKeys(String key) {
           return redisTemplate.opsForHash().keys(key);
       }
   
       /**
        * 获取指定 hash 下面的 键值对 数量
        *
        * @param key
        * @return
        */
       public Long hashSize(String key) {
           return redisTemplate.opsForHash().size(key);
       }
   
       //- - - - - - - - - - - - - - - - - - - - -  list类型 - - - - - - - - - - - - - - - - - - - -
   
       /**
        * 在变量左边添加元素值
        *
        * @param key
        * @param value
        * @return
        */
       public void leftPush(String key, Object value) {
           redisTemplate.opsForList().leftPush(key, value);
       }
   
       /**
        * 获取集合指定位置的值。
        *
        * @param key
        * @param index
        * @return
        */
       public Object index(String key, long index) {
           return redisTemplate.opsForList().index("list", 1);
       }
   
       /**
        * 获取指定区间的值。
        *
        * @param key
        * @param start
        * @param end
        * @return
        */
       public List<Object> range(String key, long start, long end) {
           return redisTemplate.opsForList().range(key, start, end);
       }
   
       /**
        * 把最后一个参数值放到指定集合的第一个出现中间参数的前面，
        * 如果中间参数值存在的话。
        *
        * @param key
        * @param pivot
        * @param value
        * @return
        */
       public void leftPush(String key, String pivot, String value) {
           redisTemplate.opsForList().leftPush(key, pivot, value);
       }
   
       /**
        * 向左边批量添加参数元素。
        *
        * @param key
        * @param values
        * @return
        */
       public void leftPushAll(String key, String... values) {
   //        redisTemplate.opsForList().leftPushAll(key,"w","x","y");
           redisTemplate.opsForList().leftPushAll(key, values);
       }
   
       /**
        * 向集合最右边添加元素。
        *
        * @param key
        * @param value
        * @return
        */
       public void leftPushAll(String key, String value) {
           redisTemplate.opsForList().rightPush(key, value);
       }
   
       /**
        * 向左边批量添加参数元素。
        *
        * @param key
        * @param values
        * @return
        */
       public void rightPushAll(String key, String... values) {
           redisTemplate.opsForList().rightPushAll(key, values);
       }
   
   
       /**
        * 向已存在的集合中添加元素。
        *
        * @param key
        * @param value
        * @return
        */
       public void rightPushIfPresent(String key, Object value) {
           redisTemplate.opsForList().rightPushIfPresent(key, value);
       }
   
       /**
        * 向已存在的集合中添加元素。
        *
        * @param key
        * @return
        */
       public long listLength(String key) {
           return redisTemplate.opsForList().size(key);
       }
   
       /**
        * 移除集合中的左边第一个元素。
        *
        * @param key
        * @return
        */
       public void leftPop(String key) {
           redisTemplate.opsForList().leftPop(key);
       }
   
       /**
        * 移除集合中左边的元素在等待的时间里，如果超过等待的时间仍没有元素则退出。
        *
        * @param key
        * @return
        */
       public void leftPop(String key, long timeout, TimeUnit unit) {
           redisTemplate.opsForList().leftPop(key, timeout, unit);
       }
   
       /**
        * 移除集合中右边的元素。
        *
        * @param key
        * @return
        */
       public void rightPop(String key) {
           redisTemplate.opsForList().rightPop(key);
       }
   
       /**
        * 移除集合中右边的元素在等待的时间里，如果超过等待的时间仍没有元素则退出。
        *
        * @param key
        * @return
        */
       public void rightPop(String key, long timeout, TimeUnit unit) {
           redisTemplate.opsForList().rightPop(key, timeout, unit);
       }
   }
   ```

   

5. 编写RedisConfig

   ```java
   @Configuration
   public class RedisConfig {
   
       /**
        * 自己定义 RedisTemplate
        *
        * @param factory
        * @return
        */
       @Bean
       @SuppressWarnings("all")
       public RedisTemplate<String, Object> redisTemplate(RedisConnectionFactory factory) {
           //为了开发方便 一版直接使用<String, Object>
           RedisTemplate<String, Object> template = new RedisTemplate<String, Object>();
           template.setConnectionFactory(factory);
           // key采用String的序列化方式
           template.setKeySerializer(new StringRedisSerializer());
           // hash的key也采用String的序列化方式
           template.setHashKeySerializer(new StringRedisSerializer());
           // value序列化方式采用jackson
           template.setValueSerializer(new GenericJackson2JsonRedisSerializer());
           // hash的value序列化方式采用jackson
           template.setHashValueSerializer(new GenericJackson2JsonRedisSerializer());
           template.afterPropertiesSet();
           return template;
       }
   }
   ```

6. 项目demo地址

   > https://gitee.com/VincentBlog/snailthink.git

### 8.Redis发布订阅

Redis 发布订阅 (pub/sub) 是一种消息通信模式：发送者 (pub) 发送消息，订阅者 (sub) 接收消息。

Redis 客户端可以订阅任意数量的频道。

下图展示了频道 channel1 ， 以及订阅这个频道的三个客户端 —— client2 、 client5 和 client1 之间的关系：

![](https://gitee.com/VincentBlog/image/raw/master/image/20210303164851.png)



 当有新消息通过 PUBLISH 命令发送给频道 channel1 时， 这个消息就会被发送给订阅它的三个客户端： 

![](https://gitee.com/VincentBlog/image/raw/master/image/20210303164850.png)



### Redis面试题总结

#### 1.Redis 是单线程还是多线程？

Redis是单线程的

核心：Redis将所有的数据全部放到内存中，所以单线程去操作效率就是最高的，多线程【cpu上下文会切换：耗时的操作】对于内存系统来说，如果灭有上下文切换效率就是最高的，多从读写都在一个CPU上的。

#### 2.redis相比memcached有哪些优势？

**参考答案**：

共同点：

1. 都是基于内存的操作
2. 都有过期策略
3. 性能都很高

区别：

1. Redis 不仅仅支持简单的 k/v 类型的数据，同时还提供 list，set，zset，hash 等数据结构的存储。Memcached 只支持最简单的 k/v 数据类型。 
2. Redis 支持数据的持久化，可以将内存中的数据保持在磁盘中，重启的时候可以再次加载进行使用,而 Memecache 把数据全部存在内存之中.
3. Memcached 是多线程，非阻塞 IO 复用的网络模型；Redis 使用单线程的多路 IO 复用模型。 （Redis 6.0 引入了多线程 IO ）
4. Redis 支持发布订阅模型、Lua 脚本、事务等功能，而 Memcached 不支持。并且，Redis 支持更多的编程语言。
5. Memcached过期数据的删除策略只用了惰性删除，而 Redis 同时使用了惰性删除与定期删除。

#### 3.redis常见性能问题和解决方案？

**参考答案**：

(1) Master最好不要做任何持久化工作，如RDB内存快照和AOF日志文件

(2) 如果数据比较重要，某个Slave开启AOF备份数据，策略设置为每秒同步一次

(3) 为了主从复制的速度和连接的稳定性，Master和Slave最好在同一个局域网内

(4) 尽量避免在压力很大的主库上增加从库

(5) 主从复制不要用图状结构，用单向链表结构更为稳定，即：Master <- Slave1 <- Slave2 <- Slave3...

这样的结构方便解决单点故障问题，实现Slave对Master的替换。如果Master挂了，可以立刻启用Slave1做Master，其他不变。

#### 4. Redis如何保证缓存和数据库的数据一致性？

起因：

1.如果删除了缓存Redis，还没有来得及写库MySQL，另一个线程就来读取，发现缓存为空，则去数据库中读取数据写入缓存，此时缓存中为脏数据。

2.如果先写了库，在删除缓存前，写库的线程宕机了，没有删除掉缓存，则也会出现数据不一致情况。

解决方法：

1. 首先尝试从缓存读取，读到数据则直接返回；如果读不到，就读数据库，并将数据会写到缓存，并返回。

2. 需要更新数据时，先更新数据库，然后把缓存里对应的数据失效掉（删掉）。

**延时双删策略**

```java
public void write( String key, Object data )
{
	redis.delKey( key );
	db.updateData( data );
	Thread.sleep( 500 );
	redis.delKey( key );
}
```

1. 先删除缓存

2. 在写入数据库中

3. 休眠500毫秒

   休眠具体时间需要根据项目读数据业务逻辑的耗时，目的就是确保读请求结束，写请求可以删除读请求造成的缓存脏数据。 

4. 再次删除缓存

   弊端：增加了请求的耗时

5. 总结

   并发不高的情况：

   读: 读redis->没有，读mysql->把mysql数据写回redis，有的话直接从redis中取；

   写: 写mysql->成功，再写redis；

   并发高的情况：

   读: 读redis->没有，读mysql->把mysql数据写回redis，有的话直接从redis中取；

   写：异步话，先写入redis的缓存，就直接返回；定期或特定动作将数据保存到mysql，可以做到多次更新，一次保存；

   [Redis如何保持缓存和数据库一致性？](https://blog.csdn.net/belalds/article/details/82078009)

#### 5.Redis 常见的性能问题都有哪些？如何解决？

**参考答案**：

Master写内存快照，save命令调度rdbSave函数，会阻塞主线程的工作，当快照比较大时对性能影响是非常大的，会间断性暂停服务，所以Master最好不要写内存快照。

Master AOF持久化，如果不重写AOF文件，这个持久化方式对性能的影响是最小的，但是AOF文件会不断增大，AOF文件过大会影响Master重启的恢复速度。Master最好不要做任何持久化工作，包括内存快照和AOF日志文件，特别是不要启用内存快照做持久化,如果数据比较关键，某个Slave开启AOF备份数据，策略为每秒同步一次。

Master调用BGREWRITEAOF重写AOF文件，AOF在重写的时候会占大量的CPU和内存资源，导致服务load过高，出现短暂服务暂停现象。

Redis主从复制的性能问题，为了主从复制的速度和连接的稳定性，Slave和Master最好在同一个局域网内

#### 6. Redis 最适合的场景

**参考答案**：

Redis最适合所有数据in-memory的场景，虽然Redis也提供持久化功能，但实际更多的是一个disk-backed的功能，跟传统意义上的持久化有比较大的差别，那么可能大家就会有疑问，似乎Redis更像一个加强版的Memcached，那么何时使用Memcached,何时使用Redis呢?

如果简单地比较Redis与Memcached的区别，大多数都会得到以下观点：

Redis不仅仅支持简单的k/v类型的数据，同时还提供list，set，zset，hash等数据结构的存储。
Redis支持数据的备份，即master-slave模式的数据备份。
Redis支持数据的持久化，可以将内存中的数据保持在磁盘中，重启的时候可以再次加载进行使用

#### 7.Redis的同步机制了解么？

**参考答案**：

主从同步。第一次同步时，主节点做一次bgsave，并同时将后续修改操作记录到内存buffer，待完成后将rdb文件全量同步到复制节点，复制节点接受完成后将rdb镜像加载到内存。加载完成后，再通知主节点将期间修改的操作记录同步到复制节点进行重放就完成了同步过程。

#### 8.是否使用过Redis集群，集群的原理是什么？

**参考答案**：

Redis Sentinel着眼于高可用，在master宕机时会自动将slave提升为master，继续提供服务。

Redis Cluster着眼于扩展性，在单个redis内存不足时，使用Cluster进行分片存储。


