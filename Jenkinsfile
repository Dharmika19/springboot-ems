pipeline {

    agent any

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }


        stage('Build Application') {

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
                -t dharmika19/springboot-ems:latest .
                '''
            }
        }


        stage('Push Docker Image') {

            steps {

                script {

                    docker.withRegistry(
                        'https://index.docker.io/v1/',
                        'dockerhub-credentials'
                    ) {

                        def image = docker.image(
                            'dharmika19/springboot-ems:latest'
                        )

                        image.push()

                    }

                }

            }

        }


        stage('Deploy Application') {

            steps {

                sh '''
                
                docker stop springboot-ems || true
                
                docker rm springboot-ems || true


                docker pull dharmika19/springboot-ems:latest


                docker run -d \
                --name springboot-ems \
                -p 8081:8080 \
                dharmika19/springboot-ems:latest

                '''

            }

        }

    }


    post {

        success {
            echo 'Deployment Successful!'
        }


        failure {
            echo 'Pipeline Failed!'
        }

    }

}
