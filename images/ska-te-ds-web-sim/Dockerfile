FROM openjdk:8
ARG CETC_TARBALL_LOCATION=.

ADD ${CETC_TARBALL_LOCATION}/simulator.tar /
RUN chmod 777 /home/simulator
ENV MYPATH /home/simulator
WORKDIR ${MYPATH}

EXPOSE 4840
EXPOSE 5005
EXPOSE 8090

CMD java -jar -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005 ./jar/simulator.jar
