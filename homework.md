Kubernetes & AWS EKS Assignment – t2e (Text to Emoji)
1. Network Infrastructure (IaC)

Create a VPC and subnets in separate module. using Infrastructure as Code.
both igw etc. - network module.
Use the outputs of this configuration as inputs for the EKS cluster.

2. Application Implementation

Implement the t2e application in Python.
When accessed via a browser, the application must return a simple "hello world" response.

3. Application Containerization
Containerize the Python-based t2e application and produce a runnable container image.
The image must be suitable for deployment in Kubernetes.

4. Helm Chart
Create a Helm chart to deploy the t2e application.
All Kubernetes resources must be defined and managed via Helm.

5. Service Exposure
Expose the application using a Kubernetes Service of type LoadBalancer.
The service must allow external access to the application.

6. CI/CD Pipeline
Implement a CI/CD pipeline that builds the image and deploys the application using Helm.
The pipeline must handle all Kubernetes and Helm operations.
(GitHub Actions)

7. Execution Constraints
The only commands allowed to be executed from a laptop are Terraform commands.
All build, deployment, and Helm actions must run exclusively in the CI/CD pipeline.z