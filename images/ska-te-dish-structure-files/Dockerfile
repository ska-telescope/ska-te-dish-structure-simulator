FROM ubuntu:20.04

USER root

WORKDIR /root

ADD images/ska-te-dish-structure-files/config.tar /root

COPY images/ska-te-dish-structure-files/SimulationServer-ds-sim-License-Request.txt  /root/SimulationServer-ds-sim-License-Request.txt

COPY images/ska-te-dish-structure-files/copy.sh /usr/local/bin/copy

RUN chmod +x /usr/local/bin/copy

RUN mkdir /shared

# ENTRYPOINT [ "/bin/bash" ]