# Copyright (c) 2013, heiyeluren
# All rights reserved.

# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:

#   Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.

#   Redistributions in binary form must reproduce the above copyright notice, this
#   list of conditions and the following disclaimer in the documentation and/or
#   other materials provided with the distribution.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


###########################################
#
#   高性能Linux服务器配置脚本
# 
#   @version: v1.0.0
#
#   @desc: 执行完成后, 需要重启服务器
#
###########################################



#####################
#     临时生效
#####################

## 网络
sudo sysctl -w "net.core.somaxconn=2048"
sudo sysctl -w "net.core.rmem_default=262144"
sudo sysctl -w "net.core.wmem_default=262144"
sudo sysctl -w "net.core.rmem_max=16777216"
sudo sysctl -w "net.core.wmem_max=16777216"
sudo sysctl -w "net.core.netdev_max_backlog=20000"
sudo sysctl -w "net.ipv4.tcp_rmem=4096 4096 16777216"
sudo sysctl -w "net.ipv4.tcp_wmem=4096 4096 16777216"
sudo sysctl -w "net.ipv4.tcp_mem=786432 2097152 3145728"
sudo sysctl -w "net.ipv4.tcp_max_syn_backlog=16384"
sudo sysctl -w "net.ipv4.tcp_fin_timeout=30"
sudo sysctl -w "net.ipv4.tcp_keepalive_time=300"
sudo sysctl -w "net.ipv4.tcp_max_tw_buckets=5000"
sudo sysctl -w "net.ipv4.tcp_tw_reuse=1"
sudo sysctl -w "net.ipv4.tcp_tw_recycle=0"
sudo sysctl -w "net.ipv4.tcp_syncookies=1"
sudo sysctl -w "net.ipv4.tcp_max_orphans=131072"
sudo sysctl -w "net.ipv4.ip_local_port_range=1024 65535"

## 文件描述符
sudo sysctl -w "fs.nr_open=5000000"
sudo sysctl -w "fs.file-max=2000000"
sudo sysctl -w "fs.inotify.max_user_watches=16384"

## 缓存
sudo sysctl -w "vm.max_map_count=655360"



#####################
#     永久生效
#####################

## 网络
sudo echo "net.core.somaxconn=2048"                 >> /etc/sysctl.conf
sudo echo "net.core.rmem_default=262144"            >> /etc/sysctl.conf
sudo echo "net.core.wmem_default=262144"            >> /etc/sysctl.conf
sudo echo "net.core.rmem_max=16777216"              >> /etc/sysctl.conf
sudo echo "net.core.wmem_max=16777216"              >> /etc/sysctl.conf
sudo echo "net.core.netdev_max_backlog=20000"       >> /etc/sysctl.conf
sudo echo "net.ipv4.tcp_rmem=4096 4096 16777216"    >> /etc/sysctl.conf
sudo echo "net.ipv4.tcp_wmem=4096 4096 16777216"    >> /etc/sysctl.conf
sudo echo "net.ipv4.tcp_mem=786432 2097152 3145728" >> /etc/sysctl.conf
sudo echo "net.ipv4.tcp_max_syn_backlog=16384"      >> /etc/sysctl.conf
sudo echo "net.ipv4.tcp_fin_timeout=30"             >> /etc/sysctl.conf
sudo echo "net.ipv4.tcp_keepalive_time=300"         >> /etc/sysctl.conf
sudo echo "net.ipv4.tcp_max_tw_buckets=5000"        >> /etc/sysctl.conf
sudo echo "net.ipv4.tcp_tw_reuse=1"                 >> /etc/sysctl.conf
sudo echo "net.ipv4.tcp_tw_recycle=0"               >> /etc/sysctl.conf
sudo echo "net.ipv4.tcp_syncookies=1"               >> /etc/sysctl.conf
sudo echo "net.ipv4.tcp_max_orphans=131072"         >> /etc/sysctl.conf
sudo echo "net.ipv4.ip_local_port_range=1024 65535" >> /etc/sysctl.conf

## 文件描述符
sudo echo "fs.nr_open=5000000"                      >> /etc/sysctl.conf
sudo echo "fs.file-max=2000000"                     >> /etc/sysctl.conf
sudo echo "fs.inotify.max_user_watches=16384"       >> /etc/sysctl.conf

## 缓存
sudo echo "vm.max_map_count=655360"                 >> /etc/sysctl.conf

## 生效
sudo sysctl -p



#####################
#     修改硬限制
#####################

## 修改limits.conf, 这样可以永久生效限制
cd /etc/security/limits.d && for file in `ls`; do mv $file $file.bak; done

sudo sed -i 's/^@users/#@users/'              /etc/security/limits.conf
sudo sed -i 's/^@root/#@root/'                /etc/security/limits.conf
sudo sed -i 's/^\*/#\*/'                      /etc/security/limits.conf
sudo sed -i 's/^root/#root/'                  /etc/security/limits.conf

sudo echo "@users soft  nofile  2000001"   >> /etc/security/limits.conf
sudo echo "@users hard  nofile  2000001"   >> /etc/security/limits.conf
sudo echo "@root  soft  nofile  2000002"   >> /etc/security/limits.conf
sudo echo "@root  hard  nofile  2000002"   >> /etc/security/limits.conf
sudo echo "*      soft  nofile  2000003"   >> /etc/security/limits.conf
sudo echo "*      hard  nofile  2000003"   >> /etc/security/limits.conf
sudo echo " "                              >> /etc/security/limits.conf

sudo echo "*      soft  nproc   10240"     >> /etc/security/limits.conf
sudo echo "root   soft  nproc   unlimited" >> /etc/security/limits.conf
sudo echo " "                              >> /etc/security/limits.conf

sudo echo "*      soft  core    unlimited" >> /etc/security/limits.conf
sudo echo "*      hard  core    unlimited" >> /etc/security/limits.conf


## 给登陆session配置文件增加限制
## 增加全局每个用户登陆后的限制(100w), 需要自行执行ulimit修改
sudo sed -i 's/^ulimit/#ulimit/'     /etc/profile
sudo echo "ulimit -n 1000001"     >> /etc/profile
sudo echo "ulimit -u 10240"       >> /etc/profile
sudo echo "ulimit -c unlimited"   >> /etc/profile



#####################
#
#   重启服务器
#
#####################

sudo reboot
