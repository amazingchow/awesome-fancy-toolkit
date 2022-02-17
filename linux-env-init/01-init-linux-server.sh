#!/bin/bash

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
#   初始化Linux服务器
#
#   @version: v1.0.0
#
#   @desc: 执行完成后, 需要重启服务器
#
###########################################



#####################
#     挂载硬盘
#####################

# 格式化磁盘和挂载磁盘, 任何原始磁盘都必须把数据盘挂载到/home目录下.
# /home目录是我们的代码安装部署目录, 我们需要把核心大磁盘挂载到/home目录下.
# 假设目前核心大磁盘默认挂载在/data目录下, 数据盘是/dev/xvdb1, 我们需要先umount这个挂载,
# 去掉挂载: umount /home/
# 重新挂载: mount -t ext4 /dev/xvdb1 /home/
# 需要永久生效(reboot重启依然生效), 需要修改/etc/fstab文件(修改后直接root权限, 执行`mount -a`生效)
# echo "/dev/xvdb1  /home ext4    defaults    0  0" >> /etc/fstab

## 注意: ucloud和aws的虚拟磁盘路径不同, 注意修改VDISK变量
## aws需要用户进行格式化和挂载磁盘到/home目录下
## ucloud默认会给用户挂载好, 因为我们标准环境需要, 所以需要:
# unmount /data
# mount /dev/vdb /home


VDISK=/dev/vdb
QVDISK=${VDISK//\//\\/}
umount $VDISK
mkfs.ext4 $VDISK
mount $VDISK /home
sed -i "s/$QVDISK/#\/dev\/vdb/g" /etc/fstab
echo "$VDISK  /home ext4    defaults,noatime    0  0" >> /etc/fstab
mount -a

## 阿里云/腾讯云等服务器挂载流程是: 
# (1) 购买云盘
# (2) 在服务器里加载使用 
#     a) 查看新加入分区: `fdisk -l`(阿里云是xvdb; 腾讯云是vdb).
#     b) 分区: `fdisk /dev/vdb`, 根据提示, 依次输入"n", "p", "1", 两次回车, "wq", 分区就开始了, 很快就会完成.
#     c) 查看分区结果: 使用"fdisk -l"命令可以看到, 新的分区/dev/vdb1已经建立完成了(注意: /dev/vdb1是针对vdb磁盘的分区1, 还可以有/dev/vdb2、/dev/vdb3, /dev/vdb是整个硬盘).
#     d) 格式化分区: `mkfs.ext4 /dev/vdb1`(如果要格式化整个磁盘就是: `mkfs.ext4 /dev/vdb`, 如果需要其他文件系统格式可以使用mkfs.ext3等).
#     e) 加载分区: `mount /dev/vdb /home/` (把/dev/vdb整个硬盘挂载在/home目录下, 也可以挂载一个分区: `mount /dev/vdb1 /home/work`).
#     f) 永久挂载: 
#           echo "/dev/vdb  /home ext4    defaults    0  0" >> /etc/fstab
#           cat /etc/fstab, 看看是否写入了, 可以用: `mount -a`全部执行/etc/fstab中的配置, 重启服务器效果类似.



#####################
#  修改root密码
#####################
#
# 为了保证系统安全, 建议把root密码设置足够健壮: 大小写字母+数字+特殊字符, 为了方便记, 可以设置一些有意义的密码.
# passwd root 



#####################
#  关闭多余系统服务
#####################
for i in irqbalance.service acpid.service auditd.service kdump.service ntpd.service postfix.service ; do
    systemctl disable $i
done



#####################
#  LDAP托管权限修改
#####################



#####################
#  ntp时间服务器同步
#####################

## 说明: 一般阿里云/腾讯云等都会有自己的ntp时间服务器, 稳妥起见, 需要搭建自己的ntp时间服务器.
##
# ntp时间服务器列表: asia.pool.ntp.org / cn.pool.ntp.org / cn.ntp.org.cn , 推荐ntp.org域名

# 加入到crontab中
# sudo crontab -e
#
# 新增如下内容: (每隔15分钟从ntp时间服务器同步一下时间)
# */15 * * * * /usr/sbin/ntpdate asia.pool.ntp.org >> /var/log/ntpdate.log
#



#####################
#  修改ssh登陆方式
#####################
#
# 说明: 修改成为采用密钥方式登录, 关闭用户密码登陆
#

# 网络上很多黑客和ScriptKids会没事就扫描服务器, 如果发现开放了22端口就会疯狂得去入侵, 为了安全起见, 多一事不如省一事原则, 修改ssh的服务端口
#
# 修改ssh/sshd端口为9922, 可以自行修改/etc/ssh/ssh_config + /etc/ssh/sshd_config

# 重启服务生效(记得重新登陆的时候需要修改ssh端口)
# `service sshd restart`或`systemctl restart  sshd.service`



#####################
#  更改hostname
#####################

## 为了方便显示服务器, 会修改hostname的显示信息, 方便终端下面显示管理
# hostname存储在/etc/hostname文件里, 直接修改重启就能生效

## 命名规则 ##
# 命名说明: 业务模块-机器用途-机器自增序列号.机房城市.所属云服务商或所属自主机房名称.业务所属主域名
#
# 示例如下:

# php-web00.bj.aliyun    #php网页00.北京机房.阿里云
# go-app01.bj.yizhuan    #go应用01.北京机房.亦庄机房
# db-mysql02.tj.qcloud   #数据库mysql.天津机房.阿里云


HNAME="linux-new-env00.bj" # 本机的可识别名字
LIP="10.9.149.238"         # 本机的IP(一般是绑定eth0网卡的IP地址)

echo $HNAME > /etc/hostname
sed -i 's/HOSTNAME/#HOSTNAME/g ' /etc/sysconfig/network
echo "HOSTNAME=$HNAME" >> /etc/sysconfig/network
echo "$LIP $HNAME" >> /etc/hosts



#####################
#  更改yum源
#####################

## 如果自己搭建了相关yum源, 需要把/etc/yum.repos.d/相关配置修改成自己的, 方便更快速得安装软件包



#####################
#
#   重启服务器
#
#####################

sudo reboot
