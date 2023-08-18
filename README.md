# DevOps challenge

With this challenge we want to evaluate your skills as a DevOps expert. The solution should:
- Meet every requirement detailed in the Main objectives.
- Demonstrate your ability to produce high quality and well documented code.

To achieve these goals, you can use all the tools and libraries you want. Finally, there is one optional goal which, if achieved, will be positively considered.

# How to run the scripts

Once you are located in the root folder of the project, execute the scripts as follows:
```
$> ./scripts/build.sh
```
Or
```
$> ./scripts/run.sh
```

## Required tools
To implement a solution, you should be familiar with these tools:

1. Any Linux environment
2. [Java 11](https://adoptopenjdk.net/)
3. [Docker](https://docs.docker.com/engine/install/)
## Objectives
The main goal is to create and run a Docker container with this Spring Boot application. You only have to implement the code in the three files that are in the scripts folder.
### Main
1. Implement the **build.sh** script, this script should compile the Spring Boot application and create the Docker image.
2. Implement the **Dockerfile**, add the necessary commands to assemble the image. This image should include the previously compiled code, and it should also execute it.
3. Implement the **run.sh** script, this script should run the Docker container.
4. Create a pipeline that loads the previously created Docker image into a registry. Explain briefly which CI/CD tool and registry were chosen and why.

> We are going to use AWS Codepipeline to push our Docker image to Amazon ECR. We are supposing that we have the correct IAM service roles and policies to use this tools. 
> For this to work, first of all we will need to Sign in to Amazon ECR with the aws cli command `aws ecr get-login --region $AWS_DEFAULT_REGION --no-include-email`. Also we will neeed to find our ECR repository URI where we are going to push our docker image, using a command line similar to `aws ecr describe-images` we will be able to get it.
> To start with the upload of the image to ECR, we will use the docker Cli command line to do this: `docker push $REPOSITORY_URI:$image_tag`.
> The idea here is that the execution of the application image pipeline is triggered by changes to the application source code and changes to the upstream base image. So we will create a pipeline in AWS Codepipeline indicating the repository name, the branch name and other required parameters (base image, project name, etc.) and fill all the stages of the pipeline.
### Optional
1. Explain how to deploy previously created Docker image into AWS and which tools and services you will use for. _Note: there aren't a bad or good answer, but you need argument it_

> As a Docker containerized app, there are some posibilities regarding where we can deploy our app inside the AWS ecosystem. To summarize:
>  1. AWS ECS. It's the managed service AWS provides to host containerized applications. You don't need to care about cluster behind the scenes things as is managed by AWS platform.
>  2. AWS EKS. Managed service to host a Kubernetes cluster to provide deployments of containerized applications at scale. 
>  3. AWS EC2 / Lightsail. Since the thing here is to have a bare instance where we can install our own tooling set (Docker, Kunernetes, etc.) to manage containerized applications, AWS provides these two services to have a single host machine where we can deploy our infrastructure.
>  4. AWS ElasticBeanstalk. This service is a kind of a PaaS service where we can host a Docker app and AWS is in charge of creating the required infrastructure to run the application.
>To deploy our SpringBoot app in this systems, a good starting point could be to upload our Docker Image to AWS Elastic Container Registry, where we can store our container images and access later whatever system we have choosed for our infrastructure.
> In this example, we are going to choose ECS because we think that for this example provides a consistent build and deployment experience, without not much effort.
> The high level steps to deploy to AWS ECS will be similar to this:
> - Create a Cluster in ECS
> - Then use the AWS Cli to create a service `aws ecs create-service --service-name demoap...`
> - Create a CodeDeploy application and enter our ECS Cluster and service name.
> - Include a stage in our Codepipeline pipeline specifying ECS as the deploy provider. 




**IMPORTANT:** You don't need a real AWS account, we are only going to evaluate the usage of the AWS command line interface.
