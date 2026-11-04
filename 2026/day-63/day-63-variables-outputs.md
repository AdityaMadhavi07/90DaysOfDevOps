
Task 1: extracting variables

1. vi variables.tf
   
variable "region" {
  type        = string
  default     = "ap-south-1"
  description = "AWS Region"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "project_name" {
  type = string
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "allowed_ports" {
  type    = list(number)
  default = [22, 80, 443]
}

variable "extra_tags" {
  type    = map(string)
  default = {}
}

2. using variable in Provider
   - replacing: region, cidr, subnet cidr, ec2 instance type with variables
   - making security group ports dynamic 
  
provider "aws {
    region = var.region
}

3. testing variable.prompt:
   terraform plan

4. commonly used string:
   - type = string
   - type = number
   - type = bool
   - type = list(string)
   - type = map(string)
  

Note:
- with dynmaic ingress we need not write separate ingress block for each port
- dynamic block runs a loop on allowed_ports list and ingress rule is auto-generated for each port
----------------------------------------------------------------------------------------------------
Task 2: creating tfvars files

1. vi terraform.tfvars
project_name = "terraweek"
environment = "dev"
instance_type = "t3.micro"

2. prod.tfvars
project_name = "terraweek"
environment = "prod"
instance_type = "t3.small"
vpc_cidr = "10.1.0.0/16"
subnet_cidr = "10.1.1.0/24"

3. testing dev: terraform plan, terraform auto-loads --> terraform.tfvars
4. testing prod: terraform plan -var-file="prod.tfvars"

5. CLI override:
   - terraform plan -var="instance_type=t3.nano"
   - this will override the values mentioned in tfvars
  
6. Env variable:
   - export TF_VAR_environment="staging"

7. variable precedence:
   
   Variable Default (lowest)
        ↓
   terraform.tfvars
        ↓
    *.auto.tfvars
        ↓
    -var-file
        ↓
TF_VAR_* environment variables
        ↓
       -var (highest)
        
   - developer creates the *.auto.tfvars file , terraform automatically reads all these files when we do terraform plan
   - *.auto.tfvars files are user-created variable files that Terraform automatically loads during plan/apply operations. They are useful for variables that should always be available without specifying -var-file, whereas environment-specific files like dev.tfvars or prod.tfvars are usually loaded explicitly to avoid accidental deployments with the wrong configuration.
----------------------------------------------------------------------------------------------------
Task 3: Adding Outputs

1. vi outputs.tf
output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_id" {
  value = aws_subnet.public.id
}

output "instance_id" {
  value = aws_instance.main.id
}

output "instance_public_ip" {
  value = aws_instance.main.public_ip
}

output "instance_public_dns" {
  value = aws_instance.main.public_dns
}

output "security_group_id" {
  value = aws_security_group.web_sg.id
}

2. terraform apply
3. terraform outputs
4. specific output: terraform output instance_public_ip
5. terrafom output -json


----------------------------------------------------------------------------------------------------
Task 4: Using Data Sources

1. resource: creates cloud components like EC2
2. data source: reads existing information
   - fetches latest AMI
  

data "aws_ami" "ubuntu" {
  most_recent = true # to pick latest matching AMI

  owners = ["amazon"]

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name = "root-device-type"
    values = ["gp2"]
  }
}

- you can add the data source and availability zones in main.tf after providers and before resources
- you can also create data.tf

3. now we replace the hardcoded AMI:
   ami = data.aws_ami.amazon_linux.id

4. az:
   
data "aws_availability_zones" "available" {
    state = "available"
}

5. using az
availability_zone = data.aws_availability_zones.available.names[0] # using 1st available AZ



----------------------------------------------------------------------------------------------------
Task 5: Locals 

1. vi locals.tf

locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = {
    Project = var.project_name
    Environment = var.environment
    ManagedBy = "Terraform"
  }
}

# Vpc Tag:
tags = merge(local.common_tags, {
  Name = "${local.name_prefix}-vpc"
})

# Subnet Tag:
tags = merge(local.common_tags, {
  Name = "${local.name_prefix}-subnet"
})

# Ec2 Tag:
tags = merge(local.common_tags, {
  Name = "${local.name_prefix}-server"
})


2. WHY Locals?
   - DRY principle - do not repeat
   - we need not hardcode same tags/resources again
   - to define repeated values in single place

3. WHY Tags?
   - to provide metadata to aws resources
   - easy billing/cost tracking
   - fast search/filtering

locals = reusable values
tags = resource metadata


Note: variable takes input form user, where as 
      local calculates input ,
      output shows value to the user
      data source: reads existing aws information


----------------------------------------------------------------------------------------------------
Task 6: terraform console practice

1. terraform console

2. String functions:
   upper:
   upper("terraweek)

   join:
   join("-", ["terra", "week", "2026"])
   o/p: terra-week-2026

   format:
   format("arn:aws:s3:::%s", "my-bucket")
   o/p: arn:aws:s3:::my-bucket

3. Collection functions:
   length:
   length(["a","b","c"])
   o/p: 3

   Lookup:
   lookup({
    dev="t2.micro",
    prod="t3.small"
   }, "dev")

   o/p: t2.micro

   Toset:
   toset(["a","b","a"])
   o/p: ["a","b"] # removes duplicate

   Networking Function:
   cidrsubnet("10.0.0.0/16",8,1)
   o/p: 10.0.1.0/24

   Conditional Expression:
   replacing:
   instance_type = var.instance_type
   
   with:
   instance_type = var.environment == "prod" ? "t3.small" : "t2.micro"


4. useful terrafform functions:
   merge()
   merge(map1,map2) # used for tags, combines multiple maps

   lookup()
   lookup(my_map,"dev") # retieves values from Map

   join()
   join("-",["dev","web"]) # converts list to string

   length()
   length(var.allowed_ports) # counts the elements

   cidrsubnet()
   cidrsubnet("10.0.0.0/16",8,1) # automatically calculates the subnet















----------------------------------------------------------------------------------------------------
Task X:





----------------------------------------------------------------------------------------------------
Task X:








