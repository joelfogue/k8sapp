pipeline {
    agent any
    environment{
        DOCKER_TAG = getDockerTag()
        JENKINS_URL  = "127.0.0.1:8080"
        IMAGE_URL_WITH_TAG = "${JENKINS_URL}/nginxapp:${DOCKER_TAG}"
    }
    stages{
        stage('Build Docker Image'){
            steps{
                sh "docker build app/ -t ${IMAGE_URL_WITH_TAG}"
            }
        }
        stage('Push Docker Image'){
            steps{
                withCredentials([string(credentialsId: 'dockerhubpass', variable: 'dockerhubpass')]) {
                    sh "docker login -u jfogue -p ${dockerhubpass}"
                    sh "docker push ${IMAGE_URL_WITH_TAG}"
                }
            }
        }
    }
}

def getDockerTag(){
    def tag  = sh script: 'git rev-parse HEAD', returnStdout: true
    return tag
}
