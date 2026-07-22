pipeline {

    agent any

    tools {
        jdk 'jdk21'
        maven 'maven'
    }

    stages {

        stage('checkout') {
            steps {
                echo 'checking out source code ...'
                checkout scm
            }
        }

        stage('build') {
            steps {
                echo 'building spring boot application ...'
                sh './mvnw test'
            }
        }
    }

    post {

        success {
            echo 'Build completed successfully'
        }

        failure {
            echo 'Build failed'
        }

        always {
            cleanWs()
        }
    }
}
