FROM centos:7.9.2009
MAINTAINER leo
# 修改yum源
RUN tar cvf /etc/yum.repos.d.tar /etc/yum.repos.d \ 
    && curl -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo \
	&& sed -i -e '/mirrors.cloud.aliyuncs.com/d' -e '/mirrors.aliyuncs.com/d' /etc/yum.repos.d/CentOS-Base.repo \
	&& rm -rf /etc/yum.repos.d/CentOS-Linux-* \
	&& yum clean all \
    && yum makecache \
	&& yum -y update
RUN set -ex \
    # 预安装所需组件
    && yum install -y wget tar libffi-devel zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gcc gcc-c++ make initscripts \
    && wget https://www.python.org/ftp/python/3.8.4/Python-3.8.4.tgz \
    && tar -zxvf Python-3.8.4.tgz \
    && cd Python-3.8.4 \
    && ./configure prefix=/usr/local/python3 \
    && make \
    && make install \
    && make clean \
    && rm -rf /Python-3.8.4* \
    && yum install -y epel-release \
    && yum install -y python-pip
	
# 设置默认为python3
RUN set -ex \
    # 备份旧版本python
    && mv /usr/bin/python /usr/bin/python27 \
    && mv /usr/bin/pip /usr/bin/pip-python2.7 \
    # 配置默认为python3
    && ln -s /usr/local/python3/bin/python3.8 /usr/bin/python \
    && ln -s /usr/local/python3/bin/pip3 /usr/bin/pip
# 修复因修改python版本导致yum失效问题
RUN set -ex \
    && sed -i "s#/usr/bin/python#/usr/bin/python2.7#" /usr/bin/yum \
    && sed -i "s#/usr/bin/python#/usr/bin/python2.7#" /usr/libexec/urlgrabber-ext-down \
    && yum install -y deltarpm
	# 基础环境配置
RUN set -ex \
    # 修改系统时区为东八区
    && rm -rf /etc/localtime \
    && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && yum install -y vim \
    # 安装定时任务组件
    && yum -y install cronie
# 支持中文
RUN yum install kde-l10n-Chinese -y
RUN localedef -c -f UTF-8 -i zh_CN zh_CN.utf8
# 更新pip版本
RUN pip install --upgrade pip
ENV LC_ALL zh_CN.UTF-8