pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'santi099/spring-petclinic'
        DOCKER_TAG = 'latest'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/main']],
                    extensions: [],
                    userRemoteConfigs: [[
                        url: 'https://github.com/sant1ag0Rr/spring-petclinic.git',
                        credentialsId: 'github-creds'
                    ]]
                ])
            }
        }

        stage('Maven Build') {
            agent {
                docker {
                    image 'maven:3.8.6-jdk-17'  // Imagen con Java 17
                    args '-v $HOME/.m2:/root/.m2 --platform linux/amd64'  # Cache + arquitectura específica
                }
            }
            steps {
                sh 'mvn clean install -Denforcer.skip=true'  # Opcional: Saltar validación de versión
            }
        }

        stage('Docker Build') {
            agent any
            steps {
                script {
                    if (!fileExists('Dockerfile')) {
                        error("Dockerfile no encontrado")
                    }
                    sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                }
            }
        }

        stage('Docker Push') {
            agent any
            when {
                branch 'main'
            }
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'docker-hub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push ${DOCKER_IMAGE}:${DOCKER_TAG}
                    '''
                }
            }
        }
    }

    post {
        always {
            echo "Limpiando workspace..."
            // Limpieza adicional opcional
            sh 'docker system prune -f || true'
        }
    }
}