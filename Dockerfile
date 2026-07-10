FROM tomcat:11.0-jdk17

RUN rm -rf /usr/local/tomcat/webapps/*

COPY BingeIt.war /usr/local/tomcat/webapps/ROOT.war

# Disable shutdown port to prevent Render health checks from killing Tomcat
RUN sed -i 's/port="8005" shutdown="SHUTDOWN"/port="-1" shutdown="SHUTDOWN"/' /usr/local/tomcat/conf/server.xml

EXPOSE 8080

CMD ["catalina.sh", "run"]