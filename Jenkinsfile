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
        // stage('Push Docker Image'){
        //     steps{
        //         withCredentials([string(credentialsId: 'dockerhubpass', variable: 'dockerhubpass')]) {
        //             sh '''
        //             docker login -u jfogue -p ${dockerhubpass}
        //             docker push ${IMAGE_URL_WITH_TAG}
        //             '''
        //         }
        //     }
        // }
        stage('Deploy to kubernetes'){
            steps{
                sh "ls -al"
                sh "chmod +x scripts/update_tag.sh" 
                sh "echo 'Peeking to see if pod file got renamed'"
                sh "ls -al app"
                sh "scripts/update_tag.sh ${DOCKER_TAG}"
                sshagent(['ssh']) {
                sh '''
                echo "Listing dir content"
                ls -al 
                mkdir k8sapp ubuntu@18.232.88.23:/home/ubuntu/k8sapp
                scp -o StrictHostKeyChecking=no app/services.yml app/nginx-pod.yml ubuntu@18.232.88.23:/home/ubuntu/k8sapp

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
