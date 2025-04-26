# Usar como base la imagen de Alpine Java
FROM anapsix/alpine-java

# Especificar el mantenedor
LABEL maintainer="shanem@liatrio.com"

# Copiar el .jar generado al contenedor
COPY /target/spring-petclinic-1.5.1.jar /home/spring-petclinic-1.5.1.jar

# Comando para ejecutar el .jar al iniciar el contenedor
CMD ["java", "-jar", "/home/spring-petclinic-1.5.1.jar"]
