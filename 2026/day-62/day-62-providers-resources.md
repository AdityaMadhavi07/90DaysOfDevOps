
Task 1: 

VPC
 └── Subnet
      └── EC2 Instance

Internet Gateway
      │
Route Table
      │
Security Group
      │
EC2 Instance


dependency management is an important feature of terraform.
it knows which resource must be created first.

1. aws provider
   - mkdir terraform-aws-infra
   - cd terraform-aws-infra

2. vi providers.tf

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

3. terraform init
   
4. .terraform.lock.hcl 
   - this stores exact version of file provider
   - this way if team runs 10 projects then they will use same provider version
   - maintains consistency

Note:
- The .terraform.lock.hcl file records the exact versions and checksums of provider plugins used in a Terraform configuration. It ensures reproducible deployments by making sure all team members and CI/CD pipelines use the same provider versions.
| Constraint | Meaning                    | Upgrade Allowed |
| ---------- | -------------------------- | --------------- |
| `~> 5.0`   | Any compatible 5.x version | ✅ Yes           |
| `>= 5.0`   | Any version above 5.0      | ✅ Yes           |
| `= 5.0.0`  | Exact version only         | ❌ No            |


- A Terraform provider is a plugin that enables Terraform to communicate with external APIs and manage resources on platforms such as AWS, Azure, or Google Cloud.
- A resource is the fundamental building block in Terraform that represents an infrastructure component such as an EC2 instance, VPC, subnet, or security group.or
  A resource is an infrastructure object managed by Terraform, such as a VPC, subnet, or EC2 instance.

- A dependency is a relationship between resources where one resource relies on another. Terraform builds a dependency graph and automatically determines the correct creation and destruction order.

------------------------------------------------------------------------------------------------------

Task 2: Building VPC

1. VPC : logically isolated network within Aws where you can launch and manage cloud resources. it provides complete control over ntw components:
   - ip ranges, subnets, route tables and internet access

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

3. creating vpc: foundational ntw layer in aws that provides ntw isolation and control over network resources

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Terraweek-VPC"
  }
}

4. creating public subnet: segmented portion of VPC used to organize resources. Public subnet allows resources to communicate with the internet through an internet gateway

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "TerraWeek-Public-Subnet"
  }
}

-PRAT: parent- vpc_id, range- cidr_block, access behavior- map_public_ip_on_launch, tags

5. internet gateway: ntw component that allows comm. btwn resources in a VPC and the public internet

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "TerraWeek-IGW"
  }
}
- without IGW, public internet access is not possible

6. route table: contains ntw routing tables that determine where traffic from subnet should be directed

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id  # send these traffic to IGW
  }

  tags = {
    Name = "TerraWeek-RT"
  }
}
 

7. route table association: this links route table with subnet, allowing subnet to use the routing rules defined in table

resource "aws_route_table_association" "public_assoc" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id  
}

8. terraform fmt
   terraform validate
   terraform init
   terraform plan

9. terraform apply

- Memory trick (3R)
IGW = Road to Internet
Route Table = Rules of Traffic
Association = Relation (Subnet ↔ Route Table)

- CIDR:
- address range of Network
- Ip addresses allowed in network 
- classless inter domain routing
- note: /24 = 256 IPs, /16 = 65536 IPs, the less the number, the more range
- first decide the VPC range , then carve the subnets under it. Ensure that subnet does not overlap
  

------------------------------------------------------------------------------------------------------
Task 3: understanding implicit dependencies: terraform auto-identifies dependencies through resource references

1. implicit dependency: when one terraform resource references an attribute of another terraform reosurce
   - terraform automatically determines the correct creation order without requiring manual dependency declarations

2. subnet depends on VPC , if vpc does not exist, then as api returns: invalidVpcId.notFound

aws_vpc.main
│
├── aws_subnet.public
│
├── aws_internet_gateway.igw
│
└── aws_route_table.public_rt
     │
     └── aws_route_table_association.public_assoc

   
------------------------------------------------------------------------------------------------------
Task 4: adding security group and ec2

1. security group: virtual firewall for aws resources that controls inbound and outbound network traffic at the instance level
   
resource "aws_security_group" "web_sg" {
  name = "terraweek-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "TerraWeek-SG"
  }
}

- ingress = incoming traffic allow rules
- from_port = 22 and to_port = 22 , means only ssh port 22 is allowed
- cidr_blocks = ["0.0.0.0/0"] = world-wide access, ssh from any public IP is allowed
- protocol = "-1" , means all protocol allow = tcp,udp, icmp etc

2. Ec2 defination: scalable virtual service provided by AWS that allows users to run applications in cloud
   
resource "aws_instance" "main" {
  ami = "ami-0aba19e56f3eaec05"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.public.id

  vpc_security_group_ids = [
    aws_security_group.web_sg.id
  ]

  associate_public_ip_address = true

  tags = {
      Name = "TerraWeek-Server"
  }
}

Note;
- we add "=" when we want to assign argument in a resource/block, if we have key/value pair then use "="
- if we are defining the block then no "=", if we have named block then do not use "="
- if you are assigning LITS then = []
- if map/object then = {}
-----------------------------------------------------------------------------------------------
Task 5: explicit dependencies: use depends_on when dependencies are not visible through references

1. this is manually declared dependency using the depends_on argument when Terraform cannot automatically determine the resource relationship

2. adding the second s3 bucket:

resource "aws_s3_bucket" "logs" {
  bucket = "terraweek-aditya-logs-2026"

  depends_on = [ aws_instance.main ]
}

3. WHY use depends_on?
   - normally bucket and ec2 are unrelated, terraform may create them in parallel using depends_on. This forces Ec2 first and bucket second
   - also sometimes application setup script needs ec2 first before creating monitoring resources
   - cloud watch log group should be available only after ECS service deployment
     - depends_on = [aws_ecs_service.app]

4. generating dependency graph
   - sudo apt install graphviz
   - terraform graph | dot -Tyng > graph.png
   - terraform graph

------------------------------------------------------------------------------------------------------
Task 6: Lifecycle rules: Used to control resource creation, replacement, and deletion behavior.

1. these contains meta-arguments which control how :
   - resources are created, updated, and destroyed during infra changes

2. adding lifecycle in resource:

resource "aws_instance" "main" {
  ami = "ami-0aba19e56f3eaec05"
  ...

  lifecycle {
    create_before_destroy = true  
    # creates replacement resource before deleting existing one to minimize the downtime
    
    prevent_destroy = true 
    # prevents deletion of resource by causing Terraform to fail if destroy operation is attempted

    ignore_changes = [
      tags
    ]
    # ignores changes made to specific resource attributes outside terraform

  }
}

3. terraform destroys resource in reverse dependency order
   
Note:
create_before_destroy means first new resource would be created and then it would be deleted

resource "<resource_type>" "<local_terraform_name>" 
------------------------------------------------------------------------------------------------------





