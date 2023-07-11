FROM fredblgr/ubuntu-novnc:20.04

USER root

WORKDIR /root

RUN apt-get update && apt-get install -y --no-install-recommends \
    at-spi2-core vim libfuse2  \
    dnsutils \
    && apt-get clean && rm -rf /var/cache/apt/lists

ADD images/ska-te-dish-structure-simulator/client.tar.gz /root

RUN mv uaexpert-bin-linux-x86_64-1.6.3-448.AppImage /usr/local/bin/uaexpert.AppImage && chmod +x /usr/local/bin/uaexpert.AppImage

COPY images/ska-te-dish-structure-simulator/uaexpert.sh /usr/local/bin/client

COPY images/ska-te-dish-structure-simulator/install.sh /usr/local/bin/install

COPY images/ska-te-dish-structure-simulator/getip.sh /usr/local/bin/getip

RUN chmod +x /usr/local/bin/install /usr/local/bin/client /usr/local/bin/getip


# ENTRYPOINT [ "/bin/bash" ]