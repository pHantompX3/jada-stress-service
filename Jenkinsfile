pipeline {
    agent {
        docker {
             image 'maven:3.9.9-eclipse-temurin-21'
            args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    environment {
        DOCKER_IMAGE = 'jada-stress-service:latest'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Test') {
            steps {
                sh './mvnw test'
            }
        }

        stage('Package') {
            steps {
                sh './mvnw clean package -DskipTests'
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}")
                }
            }
        }
    }
}