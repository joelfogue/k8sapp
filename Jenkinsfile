pipeline {
    agent any
    environment{
        DOCKER_TAG = extractTagFromCommitSha()
        IMAGE_URL_WITH_TAG="jfogue/nginxapp:${DOCKER_TAG}"
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
                    docker push ${IMAGE_URL_WITH_TAG}
                    '''
                }
            }
        }
        stage('Deploy to kubernetes'){
            steps{
                sh "chmod +x script/update_tag.sh" 
                sh "script/update_tag.sh ${DOCKER_TAG}"
                sshagent(['ssh']) {
                steps{
                    '''
                    echo "Listing dir content"
                    ls -al 
                    // scp -o StrictHostKeyChecking=no app/services.yml app/nginx-pod.yml ubuntu@172.31.39.14:/home/ubuntu/
                    
                    '''
                }
            }
            }
        }
    }
}

def extractTagFromCommitSha(){
    def tag  = sh script: 'git rev-parse HEAD', returnStdout: true
    return tag
}
