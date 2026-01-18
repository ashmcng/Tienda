# Etapa de build
FROM maven:3.9.6-eclipse-temurin-21-alpine AS build
WORKDIR /app

# Copiar pom.xml primero (mejor cache)
COPY tienda_web/pom.xml .

RUN mvn dependency:go-offline -B

# Copiar código fuente
COPY tienda_web/src ./src

# Compilar
RUN mvn clean package -DskipTests

# Etapa runtime
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]
