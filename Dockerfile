FROM tomcat:8.0.20-jre8
COPY /target/vlab-devops-application.war /usr/local/tomcat/webapps/