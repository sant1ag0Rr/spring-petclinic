pipeline {
  agent none
  
  stages {
    // Etapa de construcción con Maven
    stage('Maven Install') {
      agent {
        docker {
          image 'maven:3.8.6-openjdk-11'  // Versión más reciente y estable
          args '-v $HOME/.m2:/root/.m2'   // Cachear dependencias
        }
      }
      steps {
        sh 'mvn clean install'
      }
    }

    // Etapa de construcción de la imagen Docker
    stage('Docker Build') {
      agent any
      steps {
        script {
          // Verifica que el Dockerfile exista
          if (!fileExists('Dockerfile')) {
            error("Dockerfile no encontrado en el directorio raíz")
          }
          sh 'docker build -t santi099/spring-petclinic:latest .'
        }
      }
    }

    // Nueva etapa: Push a Docker Hub
    stage('Docker Push') {
      agent any
      when {
        branch 'main'  // Solo ejecutar en la rama principal
      }
      steps {
        withCredentials([[
          $class: 'UsernamePasswordMultiBinding',
          credentialsId: 'docker-hub-creds',  // ID de las credenciales en Jenkins
          usernameVariable: 'DOCKER_HUB_USER',
          passwordVariable: 'DOCKER_HUB_PASSWORD'
        ]]) {
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
      // Limpieza: elimina credenciales temporales
      sh 'docker logout'
    }
  }
}