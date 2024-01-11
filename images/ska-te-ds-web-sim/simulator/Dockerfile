FROM  openjdk:8

# This Dockerfile works when using the build.sh file, but not with the current oci-build Makefile and CICD targets & templates
WORKDIR /home/simulator
ADD ./config/* /home/simulator/config/
ADD ./jar/* /home/simulator/jar/
RUN chmod 777  /home/simulator
ENV MYPATH /home/simulator
WORKDIR $MYPATH

CMD  java -jar  -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005 ./jar/simulator.jar
