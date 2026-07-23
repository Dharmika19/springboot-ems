pipeline {

    agent any


    environment {

        DOCKER_IMAGE = "dharmika19/springboot-ems:latest"

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

                docker build -t $DOCKER_IMAGE .

                '''

            }

        }





        stage('Push Docker Image') {

            steps {


                withDockerRegistry(

                    credentialsId: 'dockerhub-credentials',

                    url: 'https://index.docker.io/v1/'

                ) {


                    sh '''

                    docker push $DOCKER_IMAGE

                    '''

                }

            }

        }






        stage('Deploy') {

            steps {


                sh '''

                echo "Starting deployment..."



                # Backup current running container

                if [ "$(docker ps -aq -f name=springboot-ems)" ]; then


                    echo "Backing up current container"


                    docker stop springboot-ems || true


                    docker rename springboot-ems springboot-ems-backup || true


                fi




                echo "Pulling latest Docker image"


                docker pull $DOCKER_IMAGE





                echo "Starting new container"



                docker run -d \

                --name springboot-ems \

                -p 9090:8080 \

                $DOCKER_IMAGE





                echo "Waiting for application startup"


                sleep 20






                echo "Checking application health"




                if curl -f http://localhost:9090; then



                    echo "Deployment successful"



                    docker rm -f springboot-ems-backup || true




                else



                    echo "Deployment failed"

                    echo "Starting rollback..."



                    docker rm -f springboot-ems || true



                    docker rename springboot-ems-backup springboot-ems || true



                    docker start springboot-ems



                    exit 1



                fi



                '''

            }

        }


    }





    post {


        success {


            echo 'CI/CD Deployment Successful 🚀'


        }



        failure {


            echo 'Deployment Failed - Rollback Executed ❌'


        }


    }


}
