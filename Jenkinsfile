#!groovy
pipeline {
  agent none
  
  stages {
    // Etapa 1: Build con Maven
    stage('Maven Install') {
      agent {
        docker {
          image 'maven:3.8.6-openjdk-17'  // Versión más reciente
          args '-v $HOME/.m2:/root/.m2'    // Cache de dependencias
        }
      }
      steps {
        sh 'mvn clean install'
      }
    }
    
    // Etapa 2: Construcción de Docker
    stage('Docker Build') {
      agent any
      steps {
        script {
          // Verificar que el Dockerfile existe
          if (!fileExists('Dockerfile')) {
            error("Dockerfile no encontrado")
          }
          sh 'docker build -t santi099/spring-petclinic:latest .'
        }
      }
    }
    
    // Etapa 3: Push a Docker Hub
    stage('Docker Push') {
      agent any
      steps {
        withCredentials([usernamePassword(
          credentialsId: 'docker-hub-creds',  // Asegúrate que este ID existe en Jenkins
          passwordVariable: 'DOCKER_HUB_PASSWORD',
          usernameVariable: 'DOCKER_HUB_USER'
        )]) {
          sh '''
            echo "$DOCKER_HUB_PASSWORD" | docker login -u "$DOCKER_HUB_USER" --password-stdin
            docker push santi099/spring-petclinic:latest
          '''
        }
      }
    }
  }
  
  post {
    always {
      sh 'docker logout'  // Limpieza segura
    }
  }
}