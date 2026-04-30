# Use a lightweight Java runtime
FROM eclipse-temurin:17-jre-jammy

# Set working directory
WORKDIR /app

# Copy jar into container
COPY target/tekachi-0.0.1-SNAPSHOT.jar /app/app.jar

# Expose port (default Spring Boot)
EXPOSE 8080

# Run the app
ENTRYPOINT ["java", "-jar", "app.jar"]