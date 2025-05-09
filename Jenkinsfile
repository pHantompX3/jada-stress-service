pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'jada-stress-service:latest'
    }

    stages {
        stage('Build and Test in Docker') {
            steps {
                script {
                    docker.image('maven:3.9.9-eclipse-temurin-21').inside('-v /var/run/docker.sock:/var/run/docker.sock') {
                        sh 'chmod +x ./mvnw'
                        sh './mvnw clean package'
                        sh "docker build -t ${DOCKER_IMAGE} ."
                    }
                }
            }
        }
    }
}
