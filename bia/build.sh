ECR_REGISTRY="749856334984.dkr.ecr.us-east-1.amazonaws.com"
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ECR_REGISTRY
docker build -f bia/Dockerfile -t bia
docker tag bia:latest $ECR_REGISTRY/bia-repo:latest
docker push $ECR_REGISTRY/bia-repo:latest
