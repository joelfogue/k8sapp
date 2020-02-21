# k8sapp

0. Assume the saml profile
1. Build the packer image
2. Upate and launch the cfn stack to use this image
3. Start jenkins container
4. Create the cluster from within that box - update the on-ec2-start.yml with IP of EC2 and run that ansible role
5. 