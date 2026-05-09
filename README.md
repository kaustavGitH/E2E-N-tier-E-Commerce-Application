# E2E N-Tier Microservice E-Commerce Application using AWS EKS

## What the project is
Deploying a production-ready microservices e-commerce platform on Amazon EKS (Elastic Kubernetes Service). This is a microservices demo application. The application is a web-based e-commerce app where users can browse items, add them to the cart, and purchase them.

This is composed of 11 microservices written in different languages such as Go, C#, Node.js, Python, Java that talk to each other over gRPC. 

## Architecture

[![Architecture Diagram](/docs/images/architecture-diagram.png)](/docs/images/architecture-diagram.png)

## Step instructions
1. Clone the GitHub Repository
2. Configure AWS Keys
3. Navigate into the Project
4. Create S3 Buckets for Terraform State
5. Create Network Infrastructure (EC2, VPC, Subnet, Route table, Internet Gateway, Security Group)
6. Connect to EC2 and Access Jenkins
7. Create EKS cluster using Terraform
8. Create Jenkins pipeline jobs for all the microservices
9. Build and Push Docker Images to DockerHub
10. Deploy all kubernetes manifests
11. Configure ingress and ingress controller

## Screenshots / Demo
| Home Page                                                                                                         | Checkout Screen                                                                                                    |
| ----------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ |
| [![Screenshot of store homepage](/docs/images/image-1.png)](docs/images/image-1.png) | [![Screenshot of checkout screen](/docs/images/image-2.png)](/docs/images/image-2.png)

## Key learnings
- Gained hands-on experience in deploying end-to-end multi-tier applications using Kubernetes
- Developed knowledge of Kubernetes objects such as Deployments, Services, Ingress
- Improved debugging and troubleshooting skills for distributed applications

## Challenges faced:
### Challenge 1:
#### Issue:
Liveness probe failed: timeout: failed to connect service "172.168.1.53:8080" within 1s: context deadline exceeded
#### Root cause analysis
liveness probe initialDelaySeconds was too less, and it was killing the pod too early. 
#### Resolution
This was fixed by increasing the initialDelaySeconds time.

### Challenge 2:
#### Issue
Ingress was created and ingress controller was deployed but alb was not created in AWS
#### Root cause analysis
On checking the logs of the alb-controller-pod, the user role was missing the authorization of ec2:DescribeRouteTable action in the AWSLoadBalancerControllerIAMPolicy.
#### Resolution
IAM role was updated to include this role and changes were redeployed using Terraform apply


Source of the application code: https://github.com/GoogleCloudPlatform/microservices-demo