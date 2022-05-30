## 搭建gitlab

## 1 . 安装和配置必须的packages

[gitlab](https://www.jianshu.com/p/302b5b3f38d1 )

```shell
yum install -y curl openssh-server openssh-clients cronie

lokkit -s http -s ssh
执行此条命令时若报 lokkit : command not found 则进行 lokkit 的安装
yum install lokkit

再次执行 lokkit -s http -s ssh CentOS7 会报以下错误
ERROR: FirewallD is active, please use firewall-cmd.
systemct1 stop firewalld
再次执行即可
```

## 2. 安装gitlab package



```ruby
curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | sudo bash
yum install -y gitlab-ce
```

## 3. 安装完成

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220530183123.webp)

## 4. 配置和启动GitLab



```swift
gitlab-ctl reconfigure

启动时间会比较长，要耐心等待，显示以下信息则表明启动成功
Running handlers:
Running handlers complete
Chef Client finished, 479/1273 resources updated in 04 minutes 04 seconds
gitlab Reconfigured!
```

访问http:// ip地址



![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220530183116.webp)

设置密码，然后通过 root + password 登录，当然也可以自己新建用户。

## 5. SSH keys 配置

之后，将要访问此GitLab的服务器上的公钥添加进来就可以进行愉快的玩耍了 (Linux 系统一般在 /root/.ssh 目录下，Windows一般在 C:\Users\用户名.ssh 目录下)

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220530183111.webp)

### 6. IP显示及HTTP，SSH 端口配置

当你完成以上操作之后，你会发现你仓库中的SSH和HTTP地址是下图这样的，所以我们要对GitLab进行IP显示的配置及端口配置。

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220530183103.webp)

#### 6.1 IP配置



```shell
vim /opt/gitlab/embedded/service/gitlab-rails/config/gitlab.yml
```

修改如下项



```yaml
  gitlab:
    ## Web server settings (note: host is the FQDN, do not include http://)
    host: 192.168.10.64
    port: 6109
    https: false
```

修改 gitlab.rb



```shell
vim /etc/gitlab/gitlab.rb

external_url 'http://192.168.10.64:6109'
```

当你完成以上配置后，还是不能通过 http:// ip location : prot 来访问你的GitLab仓库。

#### 6.2 HTTP 端口配置

修改GitLab ngnix 监听端口



```csharp
vim /etc/gitlab/gitlab.rb

然后通过输入 /nginx 修改以下项
nginx['listen_port'] = 6109
 
vim /var/opt/gitlab/nginx/conf/gitlab-http.conf 
修改：
listen *:6109
```

完成以上设置之后，就可以通过 IP + PORT 来访问你的GitLab库了，同时仓库的HTTP地址显示也正常

#### 6.3 SSH 端口配置

修改SSH端口首先要修改服务器的SSH端口，这会影响到 Xshell 对服务器的连接。

1. 修改 sshd_config 中的端口号

   

   ```shell
   vim /etc/ssh/sshd_config
   
   Port 6119 //默认为22
   ```

2. 重启 sshd 服务

   

   ```shell
   systemct1 restart sshd
   
   此时会报错
   systemct1 status sshd //之后你会看到类似如下的错误信息
   
   localhost.localdomain sshd[50776]: error: Bind to port 6119 on  failed: Permission denied.
   localhost.localdomain sshd[50776]: error: Bind to port 6119 on  failed: Permission denied.
   
   网上博客有说到关闭SELinux来解决这个问题，即修改 /etc/selinux/config 文件
   SELINUX=disable
   但这种方法本人实验无效
   
   最终通过以下方法解决
   semanage port -a -t ssh_port_t -p tcp 6119
   systemct1 restart sshd
   systemct1 status sshd
   
   [root@localhost ~]# systemctl status sshd
   ?.sshd.service - OpenSSH server daemon
      Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; vendor preset: enabled)
      Active: active (running) since Fri 2019-05-10 04:19:51 EDT; 5min ago
        Docs: man:sshd(8)
              man:sshd_config(5)
    Main PID: 36086 (sshd)
       Tasks: 1
      Memory: 1.0M
      CGroup: /system.slice/sshd.service
              ?..36086 /usr/sbin/sshd -D
   
   May 10 04:19:51 localhost.localdomain systemd[1]: Starting OpenSSH server daemon...
   May 10 04:19:51 localhost.localdomain sshd[36086]: Server listening on 0.0.0.0 port 6119.
   May 10 04:19:51 localhost.localdomain sshd[36086]: Server listening on :: port 6119.
   May 10 04:19:51 localhost.localdomain systemd[1]: Started OpenSSH server daemon.
   
   端口修改成功
   ```

#### 6.4 重启GitLab



```shell
gitlab-ctl reconfigure
gitlab-ctl restart
```

完成以上操作之后，一切就都正常了

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220530183037.webp)
