
---------------------------------------------------------------------------------------------------------
Task 1: Understanding Iaac

1. iaac - it is a way/procedure through which we build the cloud infrastructure (ec2, s3, vpc) theough code without clicking on somewhere
   - WHY?
     - repeatable deployments
     - less human-errors
     - iaac-version is in control
     - easy team-collab
     - can create infra with single cmd
     - same config can be used multiple times
     - rollback is possible


2.   - in manual set-up:
     - manually create setup everytime
     - human-errors are possible
     - difficult to track
     - no reproductivity

    
3. terraform:
     - hashicorp tool
     - multi-cloud-support
     - declarative
  
    Cloud formation:
     - only for aws
     - yaml/json based
  
    Ansible:
     - config mgmt tool
     - configures existing servers
     - infrastructure provisioning also possible 

4.  declarative:
    - you DESCRIBE what you want, not how you build it
    - terraform figures out the steps automatically
    - you need to write every-single step: error-handling, ordering

    cloud-agonistic:
    - write once, deploy anywhere
  

---------------------------------------------------------------------------------------------------------
Task 2: installing terraform and configuring aws

1. terraform -version
   
2. aws --version
   aws configure # we need to provide the aws account credentials to aws CLI so it can access the aws resources

   terraform setup:
   - terraform -version
   - aws configure
   - aws sts get-caller-identity

   aws access key ID (public key):
   (AWS Console → IAM → Users → Security Credentials → Access Keys)

   creating access key:
   Access keys section
  → Click: "Create access key"
  → Purpose: "Command Line Interface (CLI)"
  → Click: "Next"
  → Download .csv file (⬅️ IMPORTANT!)

3. aws configure
   - we need to creata a user then access keys 
   

---------------------------------------------------------------------------------------------------------
Task 3: creating S3 bucket

1. mkdir terraform-basics
   cd terraform-basics

2. vi main.tf

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "terraweek-aditya-2026-demo" # this must be unique gloabally
}

3. formate and validate:
   terraform fmt
   terraform validate

4. initiatlizing terraform:
   terraform init
   - this downloads aws provider plugin and provider dependencies

5. check plan:
   - terraform plan

6. creating bucket:
   - terraform apply

7. .terraform contains:
   - downloaded providers
   - provider binaries
   - dependency information
   - terraform metadata

---------------------------------------------------------------------------------------------------------
Task 4: Adding ec2 instance

1. vi main.tf


resource "aws_instance" "web_server" {
  ami = "ami-0aba19e56f3eaec05"
  instance_type = "t3.micro"

  tags = {
    Name = "TerraWeek-Day1"
  }
}

adding ec2 instance details- ami-id, instance-type and tags
note...since we already created bucket in prior terraform apply, now we see only ec2 instance getting created

2. terraform apply
3. terraform did not create s3 bucket again.
   why?
   because it maintains statefile. (terraform.tfstate)
   terraform.tfstate:
        - resourceID
        - ARN
        - config mapping
        - current state
  
---------------------------------------------------------------------------------------------------------
Task 5: understanding state file

1. terraform.tfstate
   - written in JSON
  
2. terraform show # view current state
3. terraform state list 
   - this will show the s3 and ec2
4. showing s3 details:
   - terraform state show aws_s3_bucket.my_bucket # details of S3 bucket
5. showing ec2 details:
   - terraform state show aws_instance.web_server


Note:
    1. statefile contains: resourceIDs, attributes, metadata, current infra status
    2. we must never manually edit the statefile, as it can get currupt
    3. it must not be committed to github
    4. it must be added to .gitignore

---------------------------------------------------------------------------------------------------------
Task 6: Modify, plan and destroy

1. changing tags block in main.tf:

tags ={
    Name = "TerraWeek-Day1" #old
    Name = "TerraWeek-modified" 
}

2. terraform plan
3. Tags meaning:
   ~    create resource
   +    modify resource
   -    delete resource

4. this is not recreate or update, it is In-place update

5. apply changes : terraform apply

6. destroying: terraform destroy 

---------------------------------------------------------------------------------------------------------
