pipeline {

    agent any

    environment {
        DOCKER_IMAGE = "dharmika19/springboot-ems:latest"
        DOCKER_CREDENTIALS = "dockerhub-credentials"
        CONTAINER_NAME = "springboot-ems"
        BACKUP_NAME = "springboot-ems-backup"
        PORT_MAPPING = "9090:8080"
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

                sh '''
                docker build \
                -t ${DOCKER_IMAGE} .
                '''

            }
        }



        stage('Push Docker Image') {

            steps {

                script {

                    withDockerRegistry(
                        credentialsId: "${DOCKER_CREDENTIALS}",
                        url: "https://index.docker.io/v1/"
                    ) {

                        sh '''
                        docker push ${DOCKER_IMAGE}
                        '''

                    }

                }

            }
        }




        stage('Deploy') {

            steps {

                script {


                    try {


                        echo "Creating backup of current container"


                        sh '''
                        if docker ps -a --format '{{.Names}}' | grep -q ${CONTAINER_NAME}
                        then

                            docker stop ${CONTAINER_NAME} || true

                            docker rename ${CONTAINER_NAME} ${BACKUP_NAME} || true

                        fi
                        '''



                        echo "Starting new deployment"



                        sh '''
                        docker run -d \
                        --name ${CONTAINER_NAME} \
                        -p ${PORT_MAPPING} \
                        ${DOCKER_IMAGE}
                        '''



                        echo "Waiting for application startup"


                        sh '''
                        sleep 60
                        '''



                        echo "Checking application health"



                        sh '''
                        curl -f http://localhost:9090/
                        '''



                        echo "Deployment Successful"


                        sh '''
                        docker rm -f ${BACKUP_NAME} || true
                        '''



                    }


                    catch (Exception e) {


                        echo "Deployment Failed - Rollback Executed ❌"



                        sh '''

                        echo "Removing failed container"

                        docker rm -f ${CONTAINER_NAME} || true



                        echo "Restoring previous container"



                        if docker ps -a --format '{{.Names}}' | grep -q ${BACKUP_NAME}
                        then

                            docker rename ${BACKUP_NAME} ${CONTAINER_NAME}

                            docker start ${CONTAINER_NAME}

                        fi


                        '''


                        error("Deployment failed")

                    }

                }

            }

        }



    }



    post {


        success {

            echo "CI/CD Pipeline Completed Successfully ✅"

        }


        failure {

            echo "CI/CD Pipeline Failed ❌"

        }


    }


}
