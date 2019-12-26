FROM jenkins/jenkins:2.190.3
# 2.190.3 is the lts version as of 2019-12

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
