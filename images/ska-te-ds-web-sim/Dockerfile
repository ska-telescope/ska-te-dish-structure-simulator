FROM openjdk:8

ADD images/ska-te-ds-web-sim/simulator.tar ./
RUN chmod 777 simulator
ENV MYPATH simulator
WORKDIR ${MYPATH}

EXPOSE 4840
EXPOSE 5005
EXPOSE 8090

CMD java -jar -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005 ./jar/simulator.jar
