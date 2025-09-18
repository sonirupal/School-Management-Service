# Use Java 21 as base image
FROM eclipse-temurin:21-jdk-jammy AS build

WORKDIR /app

# Copy Maven wrapper and pom.xml first for caching dependencies
COPY mvnw* pom.xml ./
COPY .mvn .mvn

# Download dependencies
RUN ./mvnw dependency:go-offline

# Copy source code
COPY src src

# Build the application
RUN ./mvnw clean package -DskipTests

# -----------------------
# Run Stage
# -----------------------
FROM eclipse-temurin:21-jre-jammy

WORKDIR /app

# Copy the built jar from build stage
COPY --from=build /app/target/*.jar app.jar

# Expose default Spring Boot port
EXPOSE 9001

# Run the app
ENTRYPOINT ["java", "-jar", "app.jar"]
