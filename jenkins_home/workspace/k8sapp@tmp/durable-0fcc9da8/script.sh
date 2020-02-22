
                echo "Listing dir content"
                ls -al 
                scp -o StrictHostKeyChecking=no app/services.yml app/nginx-pod.yml ubuntu@18.232.88.23:/home/ubuntu/k8sapp
                