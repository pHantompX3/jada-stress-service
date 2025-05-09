FROM eclipse-temurin:21-jdk-alpine
WORKDIR /app

# Copy the JAR only (assuming you'll build it outside or in pipeline)
COPY target/demo-0.0.1-SNAPSHOT.jar app.jar

# Run the JAR
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
