FROM fredblgr/ubuntu-novnc:20.04

USER root

RUN apt-get update && apt-get install -y at-spi2-core vim libfuse2

ADD config.tar /root

ADD client.tar.gz /root

RUN mv uaexpert-bin-linux-x86_64-1.6.3-448.AppImage uaexpert.AppImage && chmod +x uaexpert.AppImage

COPY uaexpert.sh /root/uaexpert.sh

COPY install.sh /root/install.sh

# ENTRYPOINT [ "/bin/bash" ]