# Multi-stage build for Spring Boot 4.0.1 with Java 21
FROM eclipse-temurin:21-jdk-jammy AS builder

WORKDIR /build
COPY .mvn/ .mvn/
COPY mvnw pom.xml ./
RUN chmod +x mvnw
RUN ./mvnw -q -DskipTests dependency:go-offline
COPY src/ src/
RUN ./mvnw -DskipTests package

FROM eclipse-temurin:21-jre-jammy

WORKDIR /app
COPY --from=builder /build/target/tekachi-0.0.1-SNAPSHOT.jar /app/app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/app.jar"]