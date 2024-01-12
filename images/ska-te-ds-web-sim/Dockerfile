FROM openjdk:8

WORKDIR /home/simulator
COPY images/ska-te-ds-web-sim/simulator/config/* /home/simulator/config/
COPY images/ska-te-ds-web-sim/simulator/jar/* /home/simulator/jar/
ADD images/ska-te-ds-web-sim/simulator/legacy.tar ./
RUN chmod 777  /home/simulator
ENV MYPATH /home/simulator
WORKDIR $MYPATH

EXPOSE 4840
EXPOSE 5005
EXPOSE 8090

CMD ["java", "-jar", "-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005", "./jar/simulator.jar"]
