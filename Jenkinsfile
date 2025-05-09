pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'jada-stress-service:latest'
        MAVEN_CACHE = '/var/jenkins_home/.m2' // Adjust if needed
    }

    stages {
        stage('Build and Test in Docker') {
            steps {
                script {
                    docker.image('maven:3.9.9-eclipse-temurin-21').inside(
                        "--v ${env.MAVEN_CACHE}:/root/.m2 -v /var/run/docker.sock:/var/run/docker.sock"
                    ) {
                        checkout scm
                        sh 'chmod +x ./mvnw'

                        // Unset problematic env vars entirely
                        withEnv(['MAVEN_CONFIG=', 'MAVEN_OPTS=']) {
                            sh 'unset MAVEN_CONFIG MAVEN_OPTS && ./mvnw clean package'
                        }

                        sh "docker build -t ${DOCKER_IMAGE} ."
                    }
                }
            }
        }
    }
}
