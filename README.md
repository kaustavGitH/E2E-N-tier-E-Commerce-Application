Deploying a production-ready microservices e-commerce platform on Amazon EKS (Elastic Kubernetes Service)

Challenges faced:

1. Liveness probe failed: timeout: failed to connect service "172.168.1.53:8080" within 1s: context deadline exceeded -> liveness probe initialDelaySeconds was too less, and it was killing the pod too earlt. This was fixed by increasing the time
2. ingress is created and ingress controller is deployed but alb is not created in aws -> On checking the logs of the alb-controller-pod, the user role was missing the authorization of ec2:DescribeRouteTable action in the AWSLoadBalancerControllerIAMPolicy.