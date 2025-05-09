pipeline {
    agent any

    triggers {
        pollSCM('H/2 * * * *') // Poll every 2 minutes
    }

    environment {
        DOCKER_IMAGE_BASE = 'jada-stress-service'
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

                        // Extract version from pom.xml
                        def appVersion = sh(
                            script: "./mvnw help:evaluate -Dexpression=project.version -q -DforceStdout",
                            returnStdout: true
                        ).trim()
                        env.APP_VERSION = appVersion

                        // Run build
                        sh 'unset MAVEN_CONFIG MAVEN_OPTS && ./mvnw clean package'
                    }

                    // Copy the built JAR to a consistent name
                    sh '''
                        JAR_NAME=$(ls target/*.jar | grep -v original | head -n 1)
                        cp "$JAR_NAME" target/app.jar
                    '''

                    // Build Docker image with version tag and latest
                    sh """
                        docker build -t ${DOCKER_IMAGE_BASE}:latest \
                                     -t ${DOCKER_IMAGE_BASE}:${APP_VERSION} .
                    """
                }
            }
        }

        stage('Deploy App Container') {
            steps {
                script {
                    // Stop and remove old container if it exists
                    sh "docker rm -f ${CONTAINER_NAME} || true"

                    // Run new container using versioned image
                    sh """
                        docker run -d --name ${CONTAINER_NAME} \
                        -p ${HOST_PORT}:${CONTAINER_PORT} \
                        ${DOCKER_IMAGE_BASE}:${APP_VERSION}
                    """
                }
            }
        }
    }
}
