FROM fredblgr/ubuntu-novnc:20.04

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    at-spi2-core vim libfuse2  \
    && apt-get clean && rm -rf /var/cache/apt/lists

ADD images/ska-te-dish-structure-simulator/config.tar /root

ADD images/ska-te-dish-structure-simulator/client.tar.gz /root

RUN mv uaexpert-bin-linux-x86_64-1.6.3-448.AppImage uaexpert.AppImage && chmod +x uaexpert.AppImage

COPY images/ska-te-dish-structure-simulator/uaexpert.sh /root/uaexpert.sh

COPY images/ska-te-dish-structure-simulator/SimulationServer-ds-sim-License-Request.txt  /root/SimulationServer-ds-sim-License-Request.txt

COPY images/ska-te-dish-structure-simulator/install.sh /root/install.sh

# ENTRYPOINT [ "/bin/bash" ]