pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'jada-stress-service:latest'
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

                        // Unset Maven-related env vars first
                        sh 'unset MAVEN_CONFIG || true'
                        sh 'unset MAVEN_OPTS || true'

                        // Then run build separately
                        sh './mvnw clean package'

                        // Build Docker image
                        sh "docker build -t ${DOCKER_IMAGE} ."
                    }
                }
            }
        }
    }
}
