# Elastic Container Service (ECS) cluster

- Containers are tools that allow you to package your application and its files, library and dependencies.
- A managed AWS version of Kubernetes. It’s also a container orchestration service.
- Containers can be deployed on the EC2 or Fargate (serverless service)
- Migrating to other cloud providers will have challenges as ECS is a proprietary software of AWS.
- ECS offers the control plane + configuration. The node groups (EC2 and fargate) will be users' choice.
- EC2: full control of the node groups adding flexibility at the cost of always having VM running and updates
- Fargate: serverless meaning you’re not responsible for the VM’s and you only pay for what you use at the cost of control over the infrastructure.
- ECS Task definition: manifest for ECS i.e. image, port, mem/cpu, volume etc.
- ECS Service: like EKS controller controls how many tasks (containers + config) are deployed & managed.
- A load balancer can be attached to each ECS service to route traffic to the service.


For more information, please visit: https://spacelift.io/blog/terraform-ecs