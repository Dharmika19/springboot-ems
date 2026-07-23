stage('Push Docker Image') {
    steps {
        script {
            docker.withRegistry(
                'https://index.docker.io/v1/',
                'dockerhub-credentials'
            ) {

                def image = docker.build(
                    "dharmika19/springboot-ems:latest"
                )

                image.push()
            }
        }
    }
}
