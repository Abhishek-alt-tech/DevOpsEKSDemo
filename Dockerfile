FROM lolhens/baseimage-openjre
MAINTAINER Abhishek
LABEL env = dev
ADD target/springbootApp.jar springbootApp.jar
EXPOSE 80
ENTRYPOINT ["java", "-jar", "springbootApp.jar"]
