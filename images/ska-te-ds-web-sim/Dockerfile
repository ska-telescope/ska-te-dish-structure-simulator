FROM openjdk:8

ENV MYPATH /home/simulator
WORKDIR $MYPATH
COPY images/ska-te-ds-web-sim/simulator/config/* ./config/
COPY images/ska-te-ds-web-sim/simulator/config/* ./
COPY images/ska-te-ds-web-sim/simulator/jar/* ./jar/
ADD images/ska-te-ds-web-sim/simulator/legacy.tar ./
RUN chmod 777 $MYPATH

EXPOSE 4840
EXPOSE 5005
EXPOSE 8090

CMD ["java", "-jar", "-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005", "./jar/simulator.jar"]
