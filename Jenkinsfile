pipeline {
    agent any

    environment {
        IMAGE_NAME = "dharmika19/springboot-ems"
        IMAGE_TAG = "latest"
        CONTAINER_NAME = "springboot-ems"
        BACKUP_CONTAINER = "springboot-ems-backup"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            agent {
                docker {
                    image 'maven:3.9.11-eclipse-temurin-21'
                    reuseNode true
                }
            }
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .'
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials') {
                        sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {

                    echo "Stopping old application if running..."

                    sh """
                    docker stop ${CONTAINER_NAME} || true
                    docker rm ${CONTAINER_NAME} || true
                    docker rename ${BACKUP_CONTAINER} ${BACKUP_CONTAINER}-old || true
                    """

                    echo "Starting new container..."

                    sh """
                    docker run -d \
                      --name ${CONTAINER_NAME} \
                      -p 9090:8080 \
                      ${IMAGE_NAME}:${IMAGE_TAG}
                    """

                    echo "Waiting for application startup..."
                    sleep(time: 60, unit: 'SECONDS')

                    echo "Checking application health..."

                    try {

                        sh 'curl -f http://localhost:9090/'

                        echo "Application is Healthy."

                    } catch (Exception e) {

                        echo "Deployment Failed!"
                        echo "Keeping failed container for debugging."

                        // IMPORTANT:
                        // We DO NOT remove the failed container.
                        // We DO NOT rollback yet.
                        // This lets us inspect docker logs.

                        error("Deployment failed")
                    }
                }
            }
        }
    }

    post {
        success {
            echo "CI/CD Pipeline Completed Successfully"
        }

        failure {
            echo "CI/CD Pipeline Failed"
        }
    }
}
