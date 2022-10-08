# Cloudfon-cc，Linux 版本利用 Docker-Compose 来安装部署。
# 支持的操作系统（系统都必须是 64 位）如下：
# CentOS 7.9
# Debian Bullseye 11
# Debian Buster 10
# Ubuntu 18.04 (LTS) Bionic
# Ubuntu 20.04 (LTS) Focal
# Ubuntu Impish 21.10
# Ubuntu 22.04 (LTS) Jammy
# NOTE: 安装之前请确认服务器日期时间已经同步到正确时间。
# NOTE: 以下所有 Linux 命令必须以 root 用户身份执行，请先执行 su root。
# NOTE: 以下所有 Linux 命令必须在同一个工作路径下执行， 本例中假设工作路径为 /root/cloudfon-cc

# 下载安装脚本 install_docker_cn.sh,cloudfon_cc_ctl.sh 
cd /root/cloudfon-cc
# 将下载的脚本文件放在当前目录下

# 安装运行环境 -- 执行如下命令，安装 Docker-Compose环境
cd /root/cloudfon-cc && /bin/sh install_docker_cn.sh
#国内可能会更新失败，需要更换国内镜像源，例如Ubuntu 的软件源配置文件是 /etc/apt/sources.list，可以执行如下命令，其他版本参照对应步骤
#sudo sed -i "s@http://.*archive.ubuntu.com@https://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list
#sudo sed -i "s@http://.*security.ubuntu.com@https://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list


# 下列示例命令将在 IP地址为 8.218.96.81 的 Linux 服务器上 运行 Cloudfon-cc 服务:
# 运行 Cloudfon-cc 实例
# /bin/sh cloudfon_cc_ctl.sh run
cd /root/cloudfon-cc && /bin/sh cloudfon_cc_ctl.sh run

# Cloudfon-cc 实例控制

# Cloudfon-cc服务状态
cd /root/cloudfon-cc && /bin/sh cloudfon_cc_ctl.sh status

# 重启Cloudfon-cc服务
cd /root/cloudfon-cc && /bin/sh cloudfon_cc_ctl.sh restart

# 重启Cloudfon-cc中某个服务
cd /root/cloudfon-cc && /bin/sh cloudfon_cc_ctl.sh restart -s [Service Name]

# 停止Cloudfon-cc服务
cd /root/cloudfon-cc && /bin/sh cloudfon_cc_ctl.sh stop

# 停止Cloudfon-cc中某个服务
cd /root/cloudfon-cc && /bin/sh cloudfon_cc_ctl.sh stop -s [Service Name]

# 启动Cloudfon-cc服务
cd /root/cloudfon-cc && /bin/sh cloudfon_cc_ctl.sh start

# 启动Cloudfon-cc中某个服务
cd /root/cloudfon-cc && /bin/sh cloudfon_cc_ctl.sh start -s [Service Name]

# 删除Cloudfon-cc服务
cd /root/cloudfon-cc && /bin/sh cloudfon_cc_ctl.sh rm

# 登陆操作
~~~
use http://8.218.96.81:8000 to login
default user: admin  password: admin
~~~
