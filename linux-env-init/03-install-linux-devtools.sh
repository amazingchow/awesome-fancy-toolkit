# Copyright(c)2013, heiyeluren
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
#(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#(INCLUDING NEGLIGENCE OR OTHERWISE)ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


###########################################
#
#   安装Linux基本软件和依赖库
# 
#   @version: v1.0.0
#
#   @desc: 执行完成后, 需要重启服务器
#
###########################################



###########################################
#     安装基本的系统支持库和安全升级
###########################################

if [ $USER != "root" ]; then su root; fi

# 系统安全升级
sudo yum -y install yum-security
sudo yum -y --security check-update
sudo yum -y update --security

## 安装基本命令和包依赖(必须安装)
sudo yum -y install epel-release
sudo yum -y update

sudo yum -y install gcc gcc-c++ gdb make cmake automake autoconf nasm libtool imake binutils flex bison telnet wget curl libcurl libcurl-devel zip unzip gzip unzip bzip2 screen iftop iotop sysbench nload iperf iptraf mpfr tcpdump dstat mtr iptraf* strace sysstat htop gmp bzip2-devel gmp-devel glibc libgomp libmudflap ncurses ncurses-libs ncurses-devel boost boost-devel libgsasl libgsasl-devel cyrus-sasl* jemalloc jemalloc-devel gperf gperftools-libs gperftools-devel systemtap-sdt-devel openssl openssl-devel pcre-devel libevent libevent-devel libev libev-devel libuv libuv-devel libuv-static libgcrypt libgcrypt-devel libpng libpng-devel libjpeg-turbo libjpeg-turbo-devel openjpeg openjpeg-devel openjpeg-libs giflib giflib-devel giflib-utils gd gd-devel ImageMagick ImageMagick-devel ImageMagick-c++ ImageMagick-c++-devel GraphicsMagick GraphicsMagick-devel GraphicsMagick-c++ GraphicsMagick-c++-devel gettext gettext-devel freetype freetype-devel libtiff libtiff-devel libwebp libwebp-devel libwebp-tools libxml2 libxml2-devel libxslt libxslt-devel libuuid libmemcached libmemcached-devel libuuid-devel expat expat-devel  expat-static boost boost-devel leveldb-devel leveldb gdbm-devel gdbm sqlite-devel sqlite sqlite2 sqlite2-devel postgresql-devel postgresql-libs GeoIP-update GeoIP GeoIP-devel GeoIP-data snappy snappy-devel csnappy csnappy-devel librabbitmq librabbitmq-tools librabbitmq-devel libffi libffi-devel lz4 lz4-devel lz4-static lzo lzo-devel lzma-sdk457 lzma-sdk457-devel zstd libzstd libzstd-devel zlib-devel zlib-static libzip libzip-devel lrzip lrzip-libs lrzip-static p7zip xz xz-devel xz-compat-libs python python-pip python-devel perl perl-devel vim git subversion subversion-devel libdb libdb-cxx libdb-devel libdb-cxx-devel libdb4 libdb4-cxx libdb4-devel libdb4-cxx-devel libtool-ltdl libtool-ltdl-devel ntpdate psmisc lrzsz lsof bind-util* doxygen supervisor libnghttp2 libnghttp2-devel nghttp2 hiredis-devel hiredis mariadb* libsodium libsodium-devel nacl nacl-devel  nacl-static libunwind libunwind-devel tree java-1.8.0-openjdk java-1.8.0-openjdk-devel java-1.8.0-openjdk-headless java-1.8.0-openjdk-accessibility  java-1.8.0-openjdk-demo ruby ruby-devel ruby-libs zbar zbar-devel protobuf protobuf-static protobuf-devel glog glog-devel  axel  graphviz graphviz-devel graphviz-gd

## 安装 fastdfs 库依赖
### 注意: 本库因为自身结构代码原因, 必须采用root账户安装, 这里特别关注一下
cd /tmp && if [ ! -f fastdfs-5.08.zip ]; then  wget https://github.com/happyfish100/fastdfs/archive/V5.08.zip && mv V5.08.zip fastdfs-5.08.zip; fi
cd /tmp && if [ ! -f libfastcommon-1.0.35.zip ]; then wget https://github.com/happyfish100/libfastcommon/archive/V1.0.35.zip && mv V1.0.35.zip libfastcommon-1.0.35.zip; fi
cd /tmp && unzip -o libfastcommon-1.0.35.zip && cd libfastcommon-1.0.35
sudo ./make.sh && sudo ./make.sh install
cd .. && rm -rf libfastcommon-1.0.35
cd /tmp && unzip -o fastdfs-5.08.zip && cd fastdfs-5.08
sudo ./make.sh && sudo ./make.sh install
cd .. && rm -rf fastdfs-5.08

## 安装开发运行环境相关编译语言和工具(可选, 推荐安装)
# sudo yum -y install golang golang-docs nodejs luajit luajit-devel lua-static;

## 针对MySQL/Mongo/Redis/PostgreSQL机器可以安装相关工具(可选, 推荐安装)
# sudo yum -y install mytop innotop percona-xtrabackup* holland-xtrabackup sysbench mariadb* redis mongodb mongodb-mms-backup-agent mongodb-mms-monitoring-agent mongodb-server mongodb-test postgresql postgresql-devel postgresql-pgpool* postgresql-server postgresql-test postgresql-upgrade
# sudo yum -y install perl perl-devel perl-DBI perl-DBD-MySQL perl-Time-HiRes perl-IO-Socket-SSL perl-TermReadKey perl-Digest-MD5 perl-Digest-Perl-MD5 perl-Digest-MD5-File python-redis perl-Redis python-pymongo postgresql-pl*
# cd /tmp
# if [ ! -f percona-toolkit-3.0.3-1.el7.x86_64.rpm ]; then wget https://www.percona.com/downloads/percona-toolkit/3.0.3/binary/redhat/7/x86_64/percona-toolkit-3.0.3-1.el7.x86_64.rpm; fi 
# if [ ! -f percona-toolkit-debuginfo-3.0.3-1.el7.x86_64.rpm ]; then wget https://www.percona.com/downloads/percona-toolkit/3.0.3/binary/redhat/7/x86_64/percona-toolkit-debuginfo-3.0.3-1.el7.x86_64.rpm; fi
# if [ ! -f percona-xtrabackup-24-2.4.8-1.el7.x86_64.rpm ]; then wget https://www.percona.com/downloads/XtraBackup/Percona-XtraBackup-2.4.8/binary/redhat/7/x86_64/percona-xtrabackup-24-2.4.8-1.el7.x86_64.rpm; fi
# if [ ! -f percona-xtrabackup-24-debuginfo-2.4.8-1.el7.x86_64.rpm ]; then wget https://www.percona.com/downloads/XtraBackup/Percona-XtraBackup-2.4.8/binary/redhat/7/x86_64/percona-xtrabackup-24-debuginfo-2.4.8-1.el7.x86_64.rpm; fi
# if [ ! -f percona-xtrabackup-test-24-2.4.8-1.el7.x86_64.rpm ]; then wget https://www.percona.com/downloads/XtraBackup/Percona-XtraBackup-2.4.8/binary/redhat/7/x86_64/percona-xtrabackup-test-24-2.4.8-1.el7.x86_64.rpm; fi
# sudo rpm -Uvh --force --nodeps  percona-toolkit-3.0.3-1.el7.x86_64.rpm  percona-toolkit-debuginfo-3.0.3-1.el7.x86_64.rpm  percona-xtrabackup-24-2.4.8-1.el7.x86_64.rpm  percona-xtrabackup-24-debuginfo-2.4.8-1.el7.x86_64.rpm  percona-xtrabackup-test-24-2.4.8-1.el7.x86_64.rpm

## 针对RHEL 7.x+系统的特殊包区别
if [ `uname -r | grep -i el7` == "" ]; then 
  ## 注意：如果是CentOS/RHEL 7.0+系统, 如果需要安装如下几个包, 需要使用如下指令：(否则会报错：Error: Protected multilib versions: xxxxx) ##
  ## 也可以执行：package-cleanup --cleandupes  把旧版本包卸载后再执行上面的yum 安装命令 ## 
  ## 在 RHEL/CentOS 7.x+版本这几个软件会报错：libstdc++/pcre/zlib/xz-libs  ##
  ## 相关包安装指令：
  ## yum -y install libstdc++ pcre zlib xz-libs --setopt=protected_multilib=false
  ##
fi;



# 2. 创建用户和目录(本部分可以托管到LDAP, 也可以直接创建)
if [ $USER != "root" ]; then  su root; fi
mkdir -pv /home/coresave

#创建账户和主目录
groupadd  work -g 500 ; useradd work -u 500 -g 500 -d /home/work  # -p Flzc3000c1sy&l9t
groupadd  rd   -g 501 ; useradd rd   -u 501 -g 501 -d /home/rd  # -p YhsbjCfcys

mkdir -p /home/work/lib
mkdir -p /home/work/soft
mkdir -p /home/work/logs
mkdir -p /home/work/data
mkdir -p /home/work/opbin
mkdir -p /home/work/tmp
chmod 755 /home/work/  /home/rd /home/coresave
chown 500.500 /home/work -R


## 说明:其他目录按照自己组件安装需求再创建 ##



##########################################
#
#    基础运维工具部署
#
##########################################


# 监控工具
# 运维工具
# 上线工具



##########################################
#
#   @desc: 执行完成后, 需要重启服务器
#
##########################################

sudo reboot
