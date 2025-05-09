pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'jada-stress-service:latest'
        CONTAINER_NAME = 'jada-app'
        HOST_PORT = '8081'
        CONTAINER_PORT = '8080'
    }

    stages {
        stage('Build and Test in Docker') {
            steps {
                script {
                    docker.image('maven:3.9.9-eclipse-temurin-21').inside(
                        '-v /var/jenkins_home/.m2:/root/.m2 -v /var/run/docker.sock:/var/run/docker.sock'
                    ) {
                        checkout scm
                        sh 'chmod +x ./mvnw'

                        // Properly unset Maven-related vars and run build
                        sh 'unset MAVEN_CONFIG MAVEN_OPTS && ./mvnw clean package'
                    }

                    // Build Docker image outside container
                    sh "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }
        stage('Deploy App Container') {
            steps {
                script {
                    // Stop and remove old container if it exists
                    sh "docker rm -f ${CONTAINER_NAME} || true"

                    // Run new container on host
                    sh """
                        docker run -d --name ${CONTAINER_NAME} \
                        -p ${HOST_PORT}:${CONTAINER_PORT} \
                        ${DOCKER_IMAGE}
                    """
                }
            }
        }
    }
}
