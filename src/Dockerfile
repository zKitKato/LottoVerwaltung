# Stage 1: Build WAR
FROM maven:3.9.0-eclipse-temurin-17 AS build
WORKDIR /app

# pom.xml kopieren, Dependencies auflösen (Cache)
COPY pom.xml .
RUN mvn dependency:go-offline

# Source Code kopieren und WAR bauen
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Run WAR in Tomcat
FROM tomcat:10.1-jdk17
# Alte ROOT entfernen
RUN rm -rf /usr/local/tomcat/webapps/ROOT*

# WAR kopieren
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080