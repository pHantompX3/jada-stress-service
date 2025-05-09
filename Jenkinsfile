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

                        // Unset possibly conflicting Maven env vars, if they exist
                        withEnv(['MAVEN_CONFIG=', 'MAVEN_OPTS=']) {
                            sh 'unset MAVEN_CONFIG MAVEN_OPTS || true'
                            sh './mvnw clean package'
                        }

                        sh "docker build -t ${DOCKER_IMAGE} ."
                    }
                }
            }
        }
    }
}
