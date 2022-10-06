FROM adoptopenjdk/openjdk11:alpine-jre
Run  mkdir -p /opt/app
WORKDIR /opt/app
COPY target/demo.jar /opt/app
ENTRYPOINT ["java","-jar","demo.jar"]