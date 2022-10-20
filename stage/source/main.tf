locals {
	region = "ap-northeast-2"
}

provider "aws" {
  region  = local.region
}

module "vpc" {
	source = "github.com/toule/terraform-rayhli/module/vpc"
	create_vpc = true

    name = "git-vpc"
	cidr = "10.1.0.0/16"
	azs = ["${local.region}a","${local.region}c"]

	##The update works, but need to confirm the deletion
	public_subnet = {"Name"="GIT-Public-Subnet", "CIDR"=["10.1.1.0/24", "10.1.2.0/24"], "tags" = {"subnet"="public"}}
	private_subnet = {"Name"="GIT-Private-Subnet", "CIDR"=["10.1.3.0/24","10.1.4.0/24"], "attach_nat"="false"}
    #db_subnet = {"Name"="GIT-DB-Subnet", "CIDR"=["10.1.5.0/24","10.1.6.0/24"] }

	enable_nat = true
	single_nat = true

	sg = {
        http = {
            "Name" = "HTTP-SG",
            "Ingress" = {"F-Port"="80","T-Port"="80","PROTOCOL"="TCP","CIDR"=["0.0.0.0/0"]},
            "Egress" = {"F-Port"="0","T-Port"="0","PROTOCOL"="-1","CIDR"=["0.0.0.0/0"]},
        },
        vpc-endpoint = {
            "Name" = "Endpoint-SG",
            "Ingress" = {"F-Port"="443","T-Port"="443","PROTOCOL"="TCP","CIDR"=[module.vpc.vpc[0].cidr_block]},
            "Egress" = {"F-Port"="0","T-Port"="0","PROTOCOL"="-1","CIDR"=["0.0.0.0/0"]},
        },
        ssh = {
            "Name"="SSH-SG",
            "Ingress"= {"F-Port"="22","T-Port"="22","PROTOCOL"="TCP","CIDR"=["0.0.0.0/0"]},
            "Egress"= {"F-Port"="0","T-Port"="0","PROTOCOL"="-1","CIDR"=["0.0.0.0/0"]},
        }

    }

    endpoints = {
        "ecr.api" = {"type" = "Interface", "SG" = module.vpc.security_group.vpc-endpoint.id} ##vpc_endpoint_sg = "sg-0d3aa148df03734b1"
        "codecommit" = {"type" = "Interface", "SG"= module.vpc.security_group.ssh.id}
        "s3" = {"type" = "Gateway"}
    }

	tags = {
		"Stage" = "Dev",
		"Infra" = "Terraform",
		"Source" = "GIT"
	}
	
	vpc_tags = {
		"VPC" = "Terraform"
	}

}

locals {
    user_data = <<-EOT
    #!/bin/sh
    yum upgrade -y && yum update -y
    echo "Start Instance!"
    EOT
	jenkins_user_data = <<-EOT
	#!/bin/sh
	sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
	sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
	yum upgarde -y && yum update -y
	sudo yum install -y java-11-openjdk
	sudo yum install -y jenkins
	sudo systemctl daemon-reload
	echo "Jenkins Start!"
    EOT
}

module "bastion" {
    source = "github.com/toule/terraform-rayhli/module/ec2"
    create_ec2 = true
    ec2_name = "bastion-dev-instance"
	
    user_data = local.user_data
    ami = "ami-01d87646ef267ccd7"
    instance_type = "t3.micro"
    subnet_id = module.vpc.vpc_public_subnet[0].id  ##subnet_id = "subnet-0222aaec8f37ec604"
    sg_id = [module.vpc.security_group.ssh.id]
    associate_public_ip_address = true

    key_name = "keypair" ##Using existed keypair

    tags = {
        "Stage" = "Dev"
    }
}

module "jenkins" {
    source = "github.com/toule/terraform-rayhli/module/ec2"
    create_ec2 = true
    ec2_name = "jenkins-instance"

    user_data = local.jenkins_user_data
    ami = "ami-01d87646ef267ccd7"
    instance_type = "t3.medium"
    subnet_id = module.vpc.vpc_private_subnet[0].id ##subnet_id = "subnet-0222aaec8f37ec604"
    sg_id = [module.vpc.security_group.ssh.id]

    key_name = "keypair" ##Using existed keypair

    tags = {
        "Stage" = "Dev"
		"Work" = "Deployment"
    }
}

module "test-elb" {
	source = "github.com/toule/terraform-rayhli/module/elb"
	create_elb = false
	elb_name = "jenkins-elb"
	security_groups_id = [module.vpc.security_group.http.id]
	subnets_id = [module.vpc.vpc_public_subnet[0].id, module.vpc.vpc_public_subnet[1].id] ##subnet_id = "subnet-0222aaec8f37ec604"

	create_tg = true
	vpc_id = module.vpc.vpc[0].id
	target_port = 80
	target_protocol = "HTTP"
	target_type = "instance"
	attach_target_id = module.jenkins.ec2[0].id
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  backend s3 {
    bucket         = "terraform-state-01035729864" # S3 버킷 이름
    key            = "source/terraform.tfstate" # tfstate 저장 경로
    region         = "ap-northeast-2"
    dynamodb_table = "rayhli-tfstate-lock" # dynamodb table 이름
  }
}
