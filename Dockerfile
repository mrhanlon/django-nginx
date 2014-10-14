FROM centos:centos7

MAINTAINER Matthew R Hanlon <mrhanlon@gmail.com>

RUN curl -O http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-2.noarch.rpm
RUN rpm -Uvh epel-release-7*.rpm

RUN curl -O http://dl.iuscommunity.org/pub/ius/stable/CentOS/7/x86_64/ius-release-1.0-13.ius.centos7.noarch.rpm
RUN rpm -Uvh ius-release*.rpm

#RUN curl -O http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
#RUN rpm -Uvh remi-release-7*.rpm

RUN yum update -y
RUN yum groupinstall -y "development tools"
RUN yum install -y python python-devel python-setuptools
RUN yum install -y nginx supervisor
RUN easy_install pip

# pip installs
RUN pip install uwsgi

# add code
add . /home/docker/code

# web server conf
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN ln -s /home/docker/code/conf/nginx-app.conf /etc/nginx/conf.d/
RUN ln -s /home/docker/code/conf/supervisor-app.ini /etc/supervisord.d/

RUN pip install -r /home/docker/code/conf/requirements.txt

# normally, comment this line out; build your app in /app
RUN django-admin.py startproject website /home/docker/code/app

expose 80
cmd ["supervisord", "-n"]
