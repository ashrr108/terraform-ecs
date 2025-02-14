﻿# About Roost & Installation

[Roost.ai](http://roost.ai/ "http://roost.ai/") is hosted within the customer AWS account. It will run as ECS containers behind an Application Load Balancer.

Every installation is tied to one “org” and has a default admin account identified by the email address mentioned in the initial configuration. Within an “org”, there can be multiple projects that allow the users to define EaaS applications. Once an EaaS application is defined, it can be used forever against code pull request triggers and on-demand triggers.


# Roost Installation Prerequisites

1.  Identify AWS region, VPC, pair of Subnets where the Roost ECS cluster can be created.
    
2.  Keep AWS account credentials handy.
    
3.  Decide on a custom URL for accessing Roost Website like _**“roost.\<company-domain>.com”**_
    
4.  Import SSL certificate for domain: wildcard *.\<company-domain>.com into AWS Certificate Manager for the same AWS region (make a note of the ARN).
    
5.  Identify at least one 3rd party authentication method. Roost supports Google, Microsoft, Github and OKTA (will need to configure call back URL for https://roost.<company-domain\>.com/login)

## Add Redirect URI for Azure AD

1.  Go to the [Azure portal](https://portal.azure.com/ "https://portal.azure.com/"). Make sure that you sign in to the portal by using an account that has permissions to update Azure AD Application registration.
    
2.  Navigate to **Azure Active Directory**, select **App registrations**, locate the application registration by using the application ID, and then open the app registration page.
    
    You can also open the page directly by using the following links:
    
    -   If this app is owned by an organisation (Azure AD tenant), use `https://portal.azure.com/#blade/Microsoft_AAD_RegisteredApps/ApplicationMenuBlade/Authentication/appId/<AppGUID>`.
        
    -   If this app is owned by your personal Microsoft (MSA) account, use `https://portal.azure.com/#blade/Microsoft_AAD_RegisteredApps/ApplicationMenuBlade/Authentication/appId/<AppGUID>/isMSAApp/true`.
        
3.  On the app registration page, select **Authentication**. In the **Platform configurations** section, select **Add URI** to add the Redirect URI that is displayed in the error message to Azure AD.
    
4.  URI will look like https://roost.<company-domain\>.com/login

## AWS Pre-requisites for Roost Installation

1.  Ability to run Terraform scripts with AWS credentials
    
2.  Custom Domain URL and SSL Certificates
    
3.  AWS Aurora/MySQL RDS
    
4.  ECS Cluster
    
5.  Application Load Balancer resources
    
6.  Service Discovery:Namespace

## AWS Entitlements

-   Create RDS, if existing RDS is not provided
    
-   Create ECS, if existing ECS Cluster is not provided
    
-   Create EFS Resources
    
    -   FileSystem
        
    -   Target Mount Point
        
-   Create ECS Resources
    
    -   Task Definition
        
    -   Container
        
-   Create ALB Resources
    
    -   Load Balancer
        
    -   Target Group
        
    -   Listener
        
-   Create Security Group
    
-   Create AWS Log Group
    
-   Create Service Discovery
    
    -   Namespace


## Policy Document (JSON) 

[AWS Entitlements for Roost](https://github.com/roost-io/terraform/blob/b93a00135671f5a33bbfac8c07d060438180223d/aws/roost-install-policy.json)

## AWS Resources for Roost

Expect below AWS resources to pre-exist
|Data | Name | Description
|-----------|---------| ----------
| AWS Region|region | AWS region where the Roost resources will be created
| AWS VPC | vpc_id | VPC in the above region
| AWS Public Subnets | subnets | In 2 or more Availability Zones
| AWS Private Subnet | private_subnet | For the ECS containers to use
| AWS Certificate ARN |  certificate_arn | SSL Certificate for the custom domain to associate with Load Balancer DNS
| AWS RDS | mysql_(host\|port\|user\|password) | MySQL/Aurora RDS details for db schema to be created
| AWS ECS Cluster| cluster_name | ECS Cluster where the task definition and services are to be created

Terraform to Create (Destroy)
| AWS Resource | Name | Description
|-------------------|--------|-------
|AWS Cloud Watch Log Group|roost-log-group|Log group for ECS container logs
|AWS Security Group|roost-database-sg|Traffic Ingress Rules for Database to ECS 
|AWS Security Group|roost-efs-sg|Traffic Ingress/Egress for Elastic File System Mount
|AWS Security Group|roost-lb-sg|Traffic Ingress/Egress for Application Load Balancer
|AWS Security Group|roost-sg|Traffic Ingress/Egress for ECS containers
|AWS Elastic File System|roost-efs| For log and config file persistence
|AWS EFS Mount Target|roost-mount-target| Mount point for all ECS containers with storage need
|AWS LoadBalancer|roost-lb|Application Load Balancer for ECS Service
|AWS LoadBalancer Listener|roost-lb-listener|ALB Listener
|AWS LoadBalancer Listener Rule|roost-lb-listener-rule|ALB Listener Rule to forward all requests to ECS Roost Nginx
|AWS LoadBalancer Target Group|roost-lb-target-group|ALB Target Group forwarding external traffic to ECS
|AWS ECS Task Definition|roost-nginx-task-def|ECS Task for Roost Routing
|AWS ECS Task Definition|roost-web-task-def|ECS Task for Roost UI
|AWS ECS Task Definition|roost-app-task-def|ECS Task for App Controller
|AWS ECS Task Definition|roost-eaas-task-def|ECS Task for EaaS server
|ECS Service|roostnginx-svc|Service for Roost ECS nginx 
|ECS Service|roostapp-svc|Service for Roost ECS roost-app 
|ECS Service|roostweb-svc|Service for Roost ECS roost-web
|ECS Service|roosteaas-svc|Service for Roost ECS roost-eaas  
|ECS Service Namespace|roostns|Service DNS Private namespace
|Service Discovery|roostweb|Service discovery to map DNS to ECS containers
|Service Discovery|roostapp|Service discovery to map DNS to ECS containers
|Service Discovery|roosteaas|Service discovery to map DNS to ECS containers


# Terraform Scripts for Roost

Access Terraform scripts from GitHub - roost-io/terraform
https://github.com/roost-io/terraform ; Branch “ecs”

### For RDS create

    cd rds;
    # Modify terraform.tfvars 
    # Modify provider.tf
    terraform init
    terraform plan
    terraform apply

### For ECS cluster create, along with Roost
    cd ecs;
    # Modify terraform.tfvars and set cluster_create = true
    # Modify provider.tf
    terraform init
    terraform plan
    terraform apply

## Roost Docker Images

The following Roost docker.io are referred to by the Terraform scripts.

Image tag is variable driven (default tag is ecs)
  -  docker.io/zbio/roost-web:ecs
  -  docker.io/zbio/roost-app:ecs
  -  docker.io/zbio/roost-eaas:ecs
  -  docker.io/zbio/roost-jump:ecs
  -  docker.io/zbio/roost-nginx:ecs

# Verifying Roost Installation

### Post execution

Access Roost on web-browser at the custom domain provided [https://roost.\<company-domain>.com](https://zbio.atlassian.net/wiki/spaces/RDD/pages/1756823581/Verifying+Roost+Installation# "#")

### **Troubleshoot**

-   AWS Load balancer URL will have to be added to the DNS Domain Routes
    
	Verify if CNAME for the custom URL is added to DNS Domain Routes
	``roost.<company-domain>.com CNAME <LoadBalancer URL>``

-   Check the Redirect URI is added to the the 3rd party auth
``Redirect URI: https://roost.\<company-domain>.com/login``


-   Check the RDS/Database is accessible (host, port, user, password, db & security group)
		Connect to Database using MySQL Workbench or MySQL client

		> mysql -h <db-host-name> -u <db-user-name> -p
		
		>> SHOW DATABASES;
		 
		>> use roostio;
		 
		>> select * from client;
		 
		>> select * from thirdparty_login; ``    


-   Check the ECS Cluster and containers are in a running state

     Access ECS dashboard
     
    [![](https://docs.aws.amazon.com/assets/images/favicon.ico)Amazon ECS clusters - Amazon Elastic Container Service](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/clusters.html)

