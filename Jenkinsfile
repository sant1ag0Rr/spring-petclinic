pipeline {
    agent any  // Cambiado de 'none' a 'any' para el contexto global
    
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
                        credentialsId: 'github-creds'  // Credenciales específicas para GitHub
                    ]]
                ])
            }
        }

        stage('Maven Build') {
            agent {
                docker {
                    image 'maven:3.8.6-jdk-11'  // Imagen oficial existente
                    args '-v $HOME/.m2:/root/.m2'
                }
            }
            steps {
                sh 'mvn clean install'
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
            script {
                // Limpieza segura que no requiere node context
                echo "Limpiando workspace..."
            }
        }
    }
}