
-------------------------------------------------------------------------------------------------
Task 1: terraform workspaces

- With workspace, we eliminate the repeatative work
- with workspace we get single codebase and multiple states

1. mkdir terraweek-capstone && cd  terraweek-capstone
2. terraform init
   - terraform will initialise and download the required files
   
3. terraform workspace show
   - o/p default

4. creating new workspaces:
   terraform workspace new _____
   
   terraform workspace new dev
   terraform workspace new staging
   terraform workspace new prod
   
5. terraform workspace list

6. switching workspaces:
   terraform workspace select dev
   terraform workspace select staging
   terraform workspace select prod

Note:
    - terraform.workspace returns name of current active workspace
    - terraform stores separate state of each workspace, terraform.tfstate
    - workspace allows multiple env to use same terraform config file while maintaining separate state files, separate directories require duplicate configurations for each env, making maintainence harder
    - terraform workspace enables managing multiple env such as dev,staging and prod from single codebase

-------------------------------------------------------------------------------------------------
Task 2: setting project structure

use modules for reusability and scalability 

terraweek-capstone/
│
├── main.tf         (root module, here we call the child module)
├── variables.tf    (defines input)
├── outputs.tf      (returns infra info)
├── providers.tf    (aws provider config)
├── locals.tf       (calculated Value)   
│
├── dev.tfvars      (dev config values)
├── staging.tfvars  
├── prod.tfvars
│
├── .gitignore      (to hide the sensitive files created by terraform)
│
└── modules/
    │
    ├── vpc/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    ├── security-group/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    └── ec2-instance/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf



1. vi providers.tf

provider "aws" {
    region = "ap-south-1"
}

2. vi variables.tf
variable "instance_type" {}

3. locals.tf
locals {
    environment = terraform.workspace
}   

4. main.tf
module "vpc" { }
module "sg" { }
module "ec2" { }

connecting all modules

5. outputs.tf
output "public_ip" {
    value = module.ec2.public._ip
}

6. dev.tfvars
instance_type = "t2.micro"

7.  vi .gitignore

.terraform/
*.tfstate
*.tfstate.backup
*.tfvars
.terraform.lock.hcl


Note:
    - file structure is best as :
        - Separation Of Concerns
        - resuaability
        - scalibility
        - team collaboration

-------------------------------------------------------------------------------------------------
Task 3: Building Custom Modules

Our aim is to divide the infra into reusable peices (modules)
It is edvised to create separate modules for- VPC, Security Group and Ec2

1. VPC Module: this will manage the networking related resources 
   
cidr        (vpc network range)
public_subnet_cidr      (subnet range)
environment         (current env)
project_name        (project identifier)


VPC - creates isolated network
public subnet - hosts EC2 instances
internet gateway - provides internet access
route table - controls ntw traffic routes
route table association - connects subnet to route table

these o/p will be used by other modules

every resource must have TAG:
Environment = dev
Project = terraweek

resource env would be identified immediately

	resource "aws_vpc" "this" { ... }
	resource "aws_subnet" "public" { ... }
	resource "aws_internet_gateway" "this" { ... }
	resource "aws_route_table" "public" { ... }
	resource "aws_route_table_association" "public_assoc" { ... }
	
	output "vpc_id"   { value = aws_vpc.this.id }
    output "subnet_id"{ value = aws_subnet.public.id }


-------------
2. security group module: creating ntw level firewall

vpc_id
ingress_ports       (allowed port list)
environment
project_name


dynamic ingress rule - terraform will use dynamic rules
    instead of adding manually, terraform will auotmatically loop the ports for each ingress rule

The Security Group module creates a reusable firewall configuration using dynamic ingress rules. It accepts a list of ports and automatically generates the required rules, improving flexibility and reducing code duplication.


    resource "aws_security_group" "this" {
	  dynamic "ingress" {
	    for_each = var.ingress_ports
	    content { from_port = ingress.value to_port = ingress.value protocol = "tcp" cidr_blocks = ["0.0.0.0/0"] }
	  }
	  egress { from_port = 0 to_port = 0 protocol = "-1" cidr_blocks = ["0.0.0.0/0"] }
	}
	
    output "sg_id" { value = aws_security_group.this 
    }
-------------
3. EC2 Instance Module: creating VM


ami_id          (os image - amazon linux, ubuntu, redhat)
instance_type   (server size - t2.micro, t3.small)
subnet_id       (vpc module o/p, determines location where EC2 launches)
security_group_ids      (security group module o/p)
environment             ()
project_name

    resource "aws_instance" "this" {
	  ami                    = var.ami_id
	  instance_type          = var.instance_type
	  subnet_id              = var.subnet_id
	  vpc_security_group_ids = var.security_group_ids
	}
	
	output "instance_id" { value = aws_instance.this.id }
	output "public_ip"   { value = aws_instance.this.public_ip }



-------------
The directory structure:

terraweek-capstone/
  main.tf
  providers.tf
  variables.tf
  locals.tf
  outputs.tf
  dev.tfvars
  staging.tfvars
  prod.tfvars
  modules/
    vpc/
      main.tf
      variables.tf
      outputs.tf
    security-group/
      main.tf
      variables.tf
      outputs.tf
    ec2-instance/
      main.tf
      variables.tf
      outputs.tf

------
mkdir modules
touch modules/vpc/{main.tf,variables.tf,outputs.tf}
touch modules/security-group/{main.tf,variables.tf,outputs.tf}
touch modules/ec2-instance/{main.tf,variables.tf,outputs.tf}
-------


Note:
- resource "<resource_type>" "<local_name>" {}
  - <resource_type> = fixed value from terraform doc
  - aws_vpc, aws_subnet, aws_instance, aws_security_group, aws_s3_bucket
  - Output.tf: this exposes the Module-Values
    - values needed by other modules are added here
    - eg while creating vpc, we expose VPC_id and subnet_id as both are required by SG and Ec2


<!-- % % % % % % % % % % % % % % % % % % % % % % % % % % % % -->

# -------------variable for VPC---------------------------------
variable "cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR block"
  type        = string
}

variable "environment" {
  description = "Environment name (dev/staging/prod)"
  type        = string
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
}

# --------resource for vpc-----------------------------------------
resource "aws_vpc" "this" {
  cidr_block = var.cidr   # network range
  enable_dns_support = true   # DNS resolution ON
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-${var.environment}-vpc"
    Environment = var.environment
    Project = var.project_name
  }
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.this.id    # subnet will go in this VPC
  cidr_block = var.public_subnet_cidr   # subnet range
  map_public_ip_on_launch = true    # public Ip will be assigned on ec2 launch

  tags = {
    Name = "${var.project_name}-${var.environment}-public-subnet"
    Environment = var.environment
    Project = var.project_name
  }
}

# without internet gateway, ec2 wont connect to internet
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.project_name}-${var.environment}-public-subnet"
    Environment = var.environment
    Project = var.project_name
  }
}

# defines traffic routing
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"    # any destination
    gateway_id = aws_internet_gateway.this.id   # send all internet traffic here
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-public-subnet"
    Environment = var.environment
    Project = var.project_name
  }
}

# without this internet wont work
resource "aws_route_table_association" "public_assoc" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# ------output for VPC--------------------------------------------
output "vpc_id" {
  description = "Created VPC ID"
  value       = aws_vpc.this.id
}

output "subnet_id" {
  description = "Created public subnet ID"
  value       = aws_subnet.public.id
}

# --------------------------------------
VPC
 ↓
Subnet
 ↓
Internet Gateway
 ↓
Route Table
 ↓
Association

# ******************** % % % % % % % % *********************


# -------------variable for Security group------------------------
variable "vpc_id" {
  description = "VPC ID where SG will be created"
  type        = string
}

variable "ingress_ports" {
  description = "List of allowed ingress ports"
  type        = list(number)
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

# --------resource for security group------------------------------

resource "aws_security_group" "this" {
  name = "${var.project_name}-${var.environment}-sg"
  description = "Dynamic ingress SG"
  vpc_id = var.vpc_id   # SG to be created in which VPC

  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      from_port = ingress.value
      to_port = ingress.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow TCP ${ingress.value}"
    }
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-sg"
    Environment = var.environment
    Project = var.project_name
  }
}

# ------output for security group----------------------------

output "sg_id" {
  description = "Security group ID"
  value = aws_security_group.this.id
}

SG = firewall

# ******************** % % % % % % % % *********************

# -----------variable for ec2--------------------------------------

variable "ami_id" {
  description = "AMI ID for Ec2 Instance"
  type = string
}

variable "instance_type" {
  description = "Ec2 instance type"
  type = string
}

variable "subnet_id" {
  description = "Subnet ID for EC2 placement"
  type = string
}

variable "security_group_ids" {
  description = "Security group Ids attached to Ec2"
  type = list(string)
}

variable "environment" {
  description = "Environment name"
  type = string
}

variable "project_name" {
  description = "Project name for tagging"
  type = string
}

# --------resource for EC2---------------------------------------

resource "aws_instance" "this" {
  ami = var.ami_id    # os image
  instance_type = var.instance_type   # machine size
  subnet_id = var.subnet_id   # vpc to be launched in which subnet
  vpc_security_group_ids = var.security_group_ids   # which firewall to be attached
  associate_public_ip_address = true    # assigning Ip for public internet access

  tags = {
    Name = "${var.project_name}-${var.environment}-ec2"
    Environment = var.environment
    Project = var.project_name
  }
}

# -------------output for ec2-----------------------------------

output "instance_id" {
  description = "Ec2 Instance ID"
  value = aws_instance.this.id 
}

output "public_ip" {
  description = "Ec2 Public IP"
  value = aws_instance.this.public_ip
}

A → AMI
I → Instance Type
S → Subnet
S → Security Group
A → Asso pub Ip add




<!-- % % % % % % % % % % % % % % % % % % % % % % % % % % % % -->

-------------------------------------------------------------------------------------------------
Task 4: wiring it together

connecting all the modules and making them workspace-aware

1. vi locals.tf

locals {
  environment = terraform.workspace

  name_prefix = "${var.project_name}-${local.environment}"

  common_tags = {
    Project = var.project_name
    Environment = local.environment
    ManagedBy = "Terraform"
    Workspace = terraform.workspace
  }
}

2. vi variables.tf (ROOT)  - to make infra configurable

variable "project_name" {
  description = "Project name for tagging all resources"
  type = string
  default = "terraweek"

}

variable "vpc_cidr" {
  description = "vpc cidr block"
  type = string
}

variable "public_subnet_cidr" {
  description = "public subnet cidr"
  type = string
}

variable "instance_type" {
  type = string
}

variable "ingress_ports" {

  type = list(number)
  default = [ 22,80 ]
}

variable "allowed_ports" {
  description = "Allowed ports list"
  type = list(number)
}

variable "ami_id" {
  description = "AMI ID"
  type = string
}

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
}


note: variables.tf acts as the placeholder, .tfvar files include the actual value 
variables.tf (placeholder)
    ↓
dev.tfvars / staging.tfvars / prod.tfvars (actual value)
    ↓
Terraform use karti hai


3. vi main.tf (ROOT folder) - to connect all modules
   - vpc --> security --> ec2
   - dependency flow: vpc -> vpc_id -> security_group -> sg_id -> ec2


# main.tf 
module "vpc" {
  source = "./modules/vpc"

  cidr = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  environment = local.environment
  project_name = var.project_name
}

# here "vpc" is logical name/instance name, this value can be anything, this is done so we can re-use the o/p of this module anywhere in main.tf

module "security_group" {
  source = "./modules/security-group"

  vpc_id = module.vpc.vpc_id
  ingress_ports = var.allowed_ports
  environment = local.environment
  project_name = var.project_name
}

module "ec2-instance" {
  source = "./modules/ec2-instance"

  ami_id              = var.ami_id
  instance_type       = var.instance_type
  subnet_id           = module.vpc.subnet_id       # VPC module ka output
  security_group_ids  = [module.security_group.sg_id]  # SG module ka output
  environment         = local.environment
  project_name        = var.project_name
}

# ---sudo apt install tree, tree = to get a structred view of files


4. env specific tfvars
   - dev.tfvars: cheapest env, for smallest ec2 and lowest cost, ssh and http, t2.micro
   - staging.tfvars: production-like testing, ssh + http + https , for t2.small
   - prod.tfvars: security first, no ssh exposure, only http + https, for t3.small (larger instance), 
   
   - tfvars stores different values for each env, the values will change when the code runs


   vi dev.tfvars:
   vpc_cidr = "10.0.0.0/16"
   <!-- aws_region = "eu-north-1" -->
   aws_region = "us-west-2"
   public_subnet_cidr = "10.0.0.0/24"
   instance_type = "t2.micro"
   ingress_ports = [22,80]
   project_name = "terraweek" # since we have added this in defaults under root var so no need
   allowed_ports = [22, 80, 443]
   ami_id = "ami-0aba19e56f3eaec05"

   vi staging.tfvars:
   vpc_cidr      = "10.1.0.0/16"
   aws_region = "eu-north-1"
   public_subnet_cidr   = "10.1.1.0/24"
   instance_type = "t2.small"
   ingress_ports = [22, 80, 443]

   vi prod.tfvars:
   vpc_cidr      = "10.2.0.0/16"
   aws_region = "eu-north-1"
   public_subnet_cidr   = "10.2.1.0/24"
   instance_type = "t3.small"
   ingress_ports = [80, 443]


5. for dev:
   terraform workspace select dev
   terraform apply -var-file=dev.tfvars

   for staging;
   terraform workspace select staging
   terraform apply -var-file=staging.tfvars

   for prod:
   terraform workspace select prod
   terraform apply -var-file=prod.tfvars


   "SAME CODE, DIFF INFRASTRUCTURE, SEPARATE STATE FILES"

6. vi providers.tf: States the region 

provider "aws" {
  region = "eu-north-1"
}

  - if we want each module to be in separate region, then we need to edit the:
    - providers.tf
    - main.tf (ROOT)
    - main.tf (modules)

  Better approach:
  - or we can even add a new variable in root-variables.tf:

    variable "aws_region" {
      description = "AWS region for resources"
      type        = string
    }
  
  - in providers.tf:
    provider "aws" {
      region = var.aws_region  # ⬅️ Variable se region
    }
    
  -   do the change in env specific .tfvar files:  aws_region = "eu-north-1"


7. - terraform workspace allows multiple env to be managed from single code-base. 
   - env specific tfvars provides diff config values like VPC CIDRs, security rules and ec2 sizes.
   - each workspace maintains its separate state file ensuring env isolation 

8. terraform apply -var-file=dev.tfvars
   
   - dev.tfvars se values load hoti hain
   - Root variables.tf fill hoti hain
   - main.tf modules ko values pass karta hai
   - Module variables.tf fill hoti hain
   - Module main.tf resources create karte hain

   - .tfvars (Value) ➔ Root Variable ➔ Module Call ➔ Module Variable ➔ Actual Resource.
   - .tfvars (Value) ➔ Root Variable ➔  root main.tf (Module Call) ➔ Module Variable ➔ 
     Actual Resource (main.tf of module)


   - if we delete root-variables.tf, it will break reusability
   - if we hardcode values in variable.tf
   - Root variables.tf = Global Configuration Interface
   - Module variables.tf = Local Implementation Details

9. Locals:
    - these are calculated/derived values used internally by terraform
    - it does not take input from user, nor it is hardcoded
    - eg terraform.workspace, local.environment
locals {
  environment = terraform.workspace
}

10. Providers:
    - informing terraform about the cloud service
    - bridge between terraform and cloud
provider "aws" {
  region = var.aws_region   # ⬅️ Variable se region
}

terraform workspace select dev
    ↓
locals.tf:
  environment = "dev"          ← workspace se
  name_prefix = "terraweek-dev"
    ↓
terraform apply -var-file=dev.tfvars
    ↓
providers.tf:
  region = var.aws_region      ← dev.tfvars se "us-west-2"
    ↓
AWS us-west-2 region me:
  VPC name: "terraweek-dev-vpc"
  SG name:  "terraweek-dev-sg"
  EC2 name: "terraweek-dev-ec2"
    ↓
Tags:
  Environment = "dev"
  Project     = "terraweek"
  ManagedBy   = "Terraform"
  
-------------------------------------------------------------------------------------------------
Task 5:

do terraform init 

# Dev 
terraform workspace select dev
terraform plan -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"

# Staging 
terraform workspace select staging
terraform plan -var-file="staging.tfvars"
terraform apply -var-file="staging.tfvars"

# Prod 
terraform workspace select prod
terraform plan -var-file="prod.tfvars"
terraform apply -var-file="prod.tfvars"


Select Workspace
      ↓
Terraform Plan
      ↓
Terraform Apply

Terraform Init - Situation	Kab Karna
Naya project	✅ MUST - pehli baar
Naya provider add kiya	✅ Karna padega - providers.tf change hua toh
Backend change kiya	✅ Karna padega - state file location change hua
.terraform/ delete kiya	✅ Karna padega - dependencies phir se download
New machine pe pull kiya	✅ Karna padega - dependencies nahi hain


1. while doing terraform plan, we need to make sure that variables mentioned in modules are present in Root variables
2. also variable name must be same
3. do the change in main.tf (root)
4. check the providers.tf, .tfvars, 
5. you will have to be careful about the ami-id, instance-type and region:
   - note specific instance types are available only in limited regions
6. again do terraform init --> workspace --> plan --> apply


terraform workspace show

verification:
vpc-0e32b2d40c64026f1
vpc-07fabb754196c9604
vpc-09af54d1d43653013
-------------------------------------------------------------------------------------------------
Task 6: Best Practices

1. file structure
2. state management: 
   - use remote backend (s3)
   - enable state locking (dynamoDB)
   - enable bucket versioning

terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket"
    key            = "terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
  }
}
``
3. variables: do not hardcode values
4. moduels: must be reusable 
5. workspaces: provide env isolation
6. security: .gitignore
7. commands before every deployment:
   - terraform fmt: fixes indentation, formats the code
   - terraform validate: syntax + missing variable check
   - terraform plan
   - terraform apply
8. tagging:
  tags = {
  Project     = "TerraformCapstone"
  Environment = terraform.workspace
  ManagedBy   = "Terraform"
  }

9. naming convention: <project>-<environment>-<resource>
10. clean-up:
    - terraform destroy -var-file="dev.tfvars"
   
-------------------------------------------------------------------------------------------------
Task 7: Destroying all Env

1. terraform workspace select prod
   terraform destroy -var-file="prod.tfvars"

terraform workspace select staging
terraform destroy -var-file="staging.tfvars"

terraform workspace select dev
terraform destroy -var-file="dev.tfvars"

2. cleaning workspaces:
terraform workspace select default
terraform workspace delete dev
terraform workspace delete staging
terraform workspace delete prod

terraform workspace list

-------------------------------------------------------------------------------------------------

