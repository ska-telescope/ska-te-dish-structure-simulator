FROM  openjdk:8

ADD images/ska-te-ds-sim/simulator.tar ./
RUN chmod 777  /home/simulator
ENV MYPATH /home/simulator
WORKDIR $MYPATH

CMD  java -jar  -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005 ./jar/simulator.jar
