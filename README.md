# aws_poc

Imagine that you are working in a DevOps team, which is supporting other developers in building
infrastructure, pipelines etc.
One of the other development teams have built a shopping cart service for the e-commerce website. The
service exposes an HTTP REST API on port 80 – and has been configured with a working Dockerfile.

## File structure
Repository file structure is shown below:
.
├── docker
│   └── hello-world
├── live
│   ├── prod
│   │   └── us-east-1
│   │       ├── alb
│   │       ├── ecr
│   │       │   └── config
│   │       ├── ecs
│   │       │   └── configs
│   │       └── vpc
│   └── test
│       └── us-east-1
│           ├── alb
│           ├── ecr
│           │   └── config
│           ├── ecs
│           │   └── configs
│           └── vpc
└── modules
    └── aws
        ├── alb
        ├── ecr
        ├── ecs
        └── vpc

Where "docker" contain Dockerfile for nginx demo hello-world base image. This image should be build and pushed to AWS ECR private image registry. Private registry and base image have been added to easily maintain base functionalities for any future releases.
"live" directory holds infrastructure deployments using modules defined in "modules". This directory holds infrastructure deployment for every environments - "prod" and "test" in this example. Every environment contain infrastructure definitions for different AWS regions. Global resources like IAM, which are not dependent on regions, should be put inside e.g. "global" directory, adjacent to region directories. Going deeper - every region have separate infrastructure deployment definition, some of which could contain additional config files in "configs" folders.
"modules" directory holds definitions of terraform modules, divided by terraform provider - only "aws" have been used for purpose of this POC.

## Part 1: Hosting the application
Imagine that you are tasked with provisioning cloud infrastructure for hosting the service mentioned
above.
You can either choose to use a IaC tool like Terraform or Cloudformation, or you can choose to illustrate it
using a diagram and detailed descriptions of the individual components. Please describe the individual
choices you have made.
If you choose to use IaC, then we don’t require it to be working. We just want the code to include the
needed resources for the infrastructure to work!
You decide how to run the container, as long as it runs in Amazon Web Services.
For simplicity, you could use the official nginx image as an example hello world application.
In order to ensure proper quality, the solution must have support for running multiple environments, prod
and test.

### Solution
Due to small scale of infrastructure for this poc, decision was made to run docker container over AWS ECS under single VPC. With bigger scale EKS cluster should be considered. For network separation - public and private subnets have been choosen. Also private subnets will access internet through NAT GW. ECS container will expose given port at private subnets. Access to private subnets will be possible from public subnets. Public subnets, as name suggest will be exposed to outside world using IGW. For bigger scale network separatiuon over multiple VPCs should be cosnidered. 

## Part 2: Conceptualize and illustrate
Now imagine that the development team asks for advice on:
1. Building a CI/CD pipeline
2. Ensuring proper monitoring and high availability

Which technology/product choices would you make and why? What advice would you give the developers
on both subjects? What would the delivery pipeline look like?

### Solution
