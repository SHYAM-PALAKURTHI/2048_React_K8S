![pipeline](https://github.com/user-attachments/assets/a94c0c05-4cf1-44e5-83f0-cf329ce99ab2)

**2048 Game Deployment with Terraform and Kubernetes on AWS**

Welcome to the 2048 Game Deployment project! This repository contains the code and configurations necessary to deploy a 2048 game application using a full CI/CD pipeline with Terraform, Jenkins, Docker, Kubernetes, Helm, and AWS CloudWatch.

**Table of Contents**

1.	Project Overview
2.	Architecture
3.	Prerequisites
4.	Installation and Setup
5.	CI/CD Pipeline
6.	Security Aspects
7.	Monitoring
8.	Acknowledgments

**Project Overview**
This project showcases a complete DevOps workflow to automate the deployment of a 2048 game application. It involves:

1.	Infrastructure provisioning with Terraform.
2.	Continuous Integration (CI) using Jenkins.
3.	Code quality checks with SonarQube.
4.	Containerization with Docker.
5.	Continuous Deployment (CD) to an EKS cluster using Helm.
6.	Monitoring with AWS CloudWatch.

**Architecture**
The architecture includes:
1.	User initiates the process using Terraform.
2.	Terraform provisions an EC2 instance with Jenkins.
3.	Jenkins orchestrates the build process:
4.	Builds the application using Node.js and npm.
5.	Scans code with SonarQube.
6.	Pushes Docker images to Docker Hub.
7.	Terraform creates an EKS cluster and EC2 nodes.
8.	Helm deploys the application on the EKS cluster.
9.	End Users access the 2048 game application via the web.
10.	AWS CloudWatch monitors the application.

**Prerequisites**
Before you begin, ensure you have the following installed:

1.	Terraform
2.	Jenkins
3.	Docker
4.	Kubernetes (kubectl)
5.	Helm
6.	AWS CLI

**Installation and Setup**

**1. Clone the Repository**

        git clone https://github.com/SHYAM-PALAKURTHI/2048_React_K8S.git
        cd 2048_React_K8S
   
**3. Provision Infrastructure**

Use Terraform to create the necessary infrastructure:

        cd terraform-ec2
        terraform init
        terraform apply
   
**3. Set Up Jenkins**

Access Jenkins on the Provisioned EC2 Instance:

Use SSH to connect to the EC2 instance where Jenkins is installed.

        ssh -i path/to/your-key-pair.pem ec2-user@<EC2_PUBLIC_IP>

Install Jenkins and Required Plugins:

Update the package manager and install Jenkins:
        
        sudo yum update -y
        sudo yum install -y java-1.8.0-openjdk
        sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
        sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
        sudo yum install jenkins -y
        sudo systemctl start jenkins
        sudo systemctl enable jenkins
        
Access Jenkins at http://<EC2_PUBLIC_IP>:8080 and complete the initial setup.

****Install necessary plugins: NodeJS, Docker, and SonarQube Scanner.****

Set Up the Jenkins Pipeline:
Create a new pipeline job in Jenkins.
Use the provided Jenkinsfile from the repository for the pipeline script.
**4. Configure SonarQube**
Set Up a SonarQube Server:

Provision an EC2 instance for SonarQube or use an existing server.
Install SonarQube:

        sudo yum update -y
        sudo yum install -y wget unzip
        wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-8.9.2.46101.zip
        unzip sonarqube-8.9.2.46101.zip
        sudo mv sonarqube-8.9.2.46101 /opt/sonarqube
        sudo useradd sonar
        sudo chown -R sonar:sonar /opt/sonarqube
        sudo -u sonar /opt/sonarqube/bin/linux-x86-64/sonar.sh start
        
Access SonarQube at http://<SonarQube_SERVER_IP>:9000 and complete the initial setup.

Add the SonarQube Authentication Token to Jenkins:

In Jenkins, go to Manage Jenkins > Manage Credentials.
Add a new credential for the SonarQube token.

**5. Deploy to EKS using Helm**
Ensure kubeconfig is Configured for the EKS Cluster:

Update the kubeconfig file:

        aws eks update-kubeconfig --region <your-region> --name <your-cluster-name>
**Deploy the Application with Helm:**

Package and deploy the Helm chart:
        
        cd helm-chart
        helm package .
        helm install my-release ./my-helm-chart-0.1.0.tgz

**CI/CD Pipeline**

The Jenkins pipeline (Jenkinsfile) includes the following stages:

1.	Clean Workspace: Cleans the workspace to ensure a fresh build.
2.	Checkout from Git: Pulls the latest code from the repository.
3.	Print Environment Variables: Prints environment variables for debugging.
4.	SonarQube Analysis: Analyzes the code for quality and security issues.
5.	Install Dependencies: Installs Node.js dependencies.
6.	Build and Push Docker Image: Builds the Docker image and pushes it to Docker Hub.

Security Aspects
Continuous Code Inspection with SonarQube 🔍🛡️

Continuously inspected code for vulnerabilities to ensure secure and high-quality code deployments.
Consistent Security Policies with Terraform 📜🔒

Defined and enforced consistent security policies across the infrastructure, reducing the risk of manual errors.
Container Security Best Practices 🐳🔐

Implemented best practices for container security, including image security and vulnerability scanning before pushing to Docker Hub.
Kubernetes Security Best Practices 🔐⚙️

Applied Kubernetes security best practices, including namespace isolation, network policies, and role-based access control (RBAC) to secure cluster resources.
Real-Time Monitoring and Alerting with AWS CloudWatch 📈🔔

Configured AWS CloudWatch for real-time monitoring and alerting, enabling prompt detection and response to security incidents.
Monitoring
Setting Up AWS CloudWatch for Monitoring
Create IAM Role for CloudWatch:

Create an IAM role with policies to allow your EKS nodes to send logs and metrics to CloudWatch.
        
        {
          "Version": "2012-10-17",
          "Statement": [
            {
              "Effect": "Allow",
              "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:DescribeLogStreams",
                "logs:DescribeLogGroups"
              ],
              "Resource": "*"
            },
            {
              "Effect": "Allow",
              "Action": [
                "cloudwatch:PutMetricData"
              ],
              "Resource": "*"
            }
          ]
        }
Attach this policy to your EKS nodes.

Install CloudWatch Agent on EKS Nodes:

Use the AWS Systems Manager (SSM) or manually install the CloudWatch agent on your EKS nodes.
Example command:

        kubectl apply -f https://amazon-cloudwatch-agent.s3.amazonaws.com/kubernetes/quickstart.yaml
        
Configure CloudWatch Agent:

Create a configuration file for the CloudWatch agent to define what metrics and logs to collect.

        {
          "agent": {
            "metrics_collection_interval": 60,
            "logfile": "/opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log"
          },
          "logs": {
            "logs_collected": {
              "files": {
                "collect_list": [
                  {
                    "file_path": "/var/log/messages",
                    "log_group_name": "eks-log-group",
                    "log_stream_name": "{instance_id}"
                  }
                ]
              }
            }
          },
          "metrics": {
            "metrics_collected": {
              "cpu": {
                "measurement": [
                  "cpu_usage_idle",
                  "cpu_usage_iowait",
                  "cpu_usage_user",
                  "cpu_usage_system"
                ],
                "metrics_collection_interval": 60
              },
              "mem": {
                "measurement": [
                  "mem_used_percent"
                ],
                "metrics_collection_interval": 60
              }
            }
          }
        }
Deploy CloudWatch Agent Configuration:

Apply the CloudWatch agent configuration to your EKS cluster.
