FROM eclipse-temurin:21-jdk-alpine

# Add a label for clarity and tracking
LABEL maintainer="wayden13@gmail.com"

# Use a non-root user (optional security)
RUN addgroup -S app && adduser -S app -G app
USER app

WORKDIR /app

COPY target/app.jar app.jar

ENTRYPOINT ["java", "-jar", "/app/app.jar"]