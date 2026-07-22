FROM "eclipse-temurin:21-jdk"
WORKDIR /app
COPY ..
RUN chmod +x mnvw
RUN ./mvn clean package -DskipTests
COPY target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]
