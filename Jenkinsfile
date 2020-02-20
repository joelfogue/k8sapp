pipeline {
    agent any
    environment{
        DOCKER_TAG = extractTagFromCommitSha()
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
                    sh '''
                    docker login -u jfogue -p ${dockerhubpass}
                    docker tag nginxapp:${DOCKER_TAG} jfogue/nginxapp:${DOCKER_TAG}
                    docker push jfogue/nginxapp:${DOCKER_TAG}
                    '''
                }
            }
        }
    }
}

def extractTagFromCommitSha(){
    def tag  = sh script: 'git rev-parse HEAD', returnStdout: true
    return tag
}
