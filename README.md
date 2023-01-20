# aws_poc

Imagine that you are working in a DevOps team, which is supporting other developers in building
infrastructure, pipelines etc.
One of the other development teams have built a shopping cart service for the e-commerce website. The
service exposes an HTTP REST API on port 80 – and has been configured with a working Dockerfile.

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
Due to small scale of infrastructure for this poc, decision was made to run docker container over AWS ECS under single VPC. With bigger scale EKS cluster should be considered. 

## Part 2: Conceptualize and illustrate
Now imagine that the development team asks for advice on:
1. Building a CI/CD pipeline
2. Ensuring proper monitoring and high availability

Which technology/product choices would you make and why? What advice would you give the developers
on both subjects? What would the delivery pipeline look like?

### Solution
