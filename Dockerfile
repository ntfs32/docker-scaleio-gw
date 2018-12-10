FROM centos:7

RUN        yum -y update && \
           yum -y install java-1.8.0-openjdk openssl

RUN        cd /tmp && \
           curl http://ftp.ufanet.ru/pub/scaleio/RH/2.5.0.254/RHEL7/EMC-ScaleIO-gateway-2.5-0.254.x86_64.rpm && \
           rpm -i EMC-ScaleIO-gateway-2.5-0.254.x86_64.rpm

COPY       ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 443
