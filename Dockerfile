# Используем официальный образ Maven для сборки приложения
FROM maven:3.9.9-eclipse-temurin-17 AS build

# Устанавливаем раочую директорию внутри контейнера
WORKDIR /app

# Копируем файлы pom.xml и src в контейнерq
COPY pom.xml .
COPY src ./src

# Собираем приложение, пропуская тесты (если тесты нужны, удалите -DskipTests)
RUN mvn clean package -DskipTests

# Используем минимальный образ Java для запуска приложения
FROM openjdk:17-jdk-slim

# Устанавливаем раочую директорию
WORKDIR /app

# Копируем собранный JAR-файл из предыдущего этапа
COPY --from=build /app/target/*.jar app.jar

# Запускаем приложение
ENTRYPOINT ["java", "-jar", "app.jar"]
