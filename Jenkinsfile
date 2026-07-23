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
                    credentialsId: 'Dockerhub-credentials',
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

                echo "Stopping old container..."

                docker stop springboot-ems || true


                echo "Removing old container..."

                docker rm springboot-ems || true



                echo "Pulling latest image..."

                docker pull $DOCKER_IMAGE



                echo "Starting new container..."

                docker run -d \
                --name springboot-ems \
                -p 9090:8080 \
                $DOCKER_IMAGE


                echo "Deployment completed"

                '''

            }

        }


    }


    post {

        success {

            echo 'Deployment Successful 🚀'

        }


        failure {

            echo 'Deployment Failed ❌'

        }

    }

}
