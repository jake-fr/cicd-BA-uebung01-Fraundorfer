# ---- Build stage: compile, test and package with Maven ----
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /build

# Copy pom first so dependency downloads are cached as their own layer
COPY pom.xml .
RUN mvn -B -q dependency:go-offline

COPY src ./src
RUN mvn -B package && ls -la target

# ---- Runtime stage: only the JRE and the JAR ----
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /build/target/ci-cd-uebung-1.0.0.jar /app/app.jar

ENTRYPOINT ["java", "-cp", "/app/app.jar", "com.example.cicd.App"]