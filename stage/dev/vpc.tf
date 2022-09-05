locals {
	region = "ap-northeast-2"
}

provider "aws" {
  region  = local.region
}

module "vpc" {
	source = "../../module/vpc"
	create_vpc = true

    name = "DEV-VPC"
	cidr = "10.0.0.0/16"
	azs = ["${local.region}a","${local.region}c"]

	##The update works, but need to confirm the deletion
	public_subnet = {"Name"="Dev-Public-Subnet", "CIDR"=["10.0.1.0/24", "10.0.2.0/24"], "tags" = {"subnet"="public"}}
	private_subnet = {"Name"="Dev-Private-Subnet", "CIDR"=["10.0.3.0/24","10.0.4.0/24"], "attach_nat" = true}
    db_subnet = {"Name"="Dev-DB-Subnet", "CIDR"=["10.0.5.0/24","10.0.6.0/24"] }

	enable_nat = true
	single_nat = true
	
	tags = {
		"Stage" = "Dev",
		"Infra" = "Terraform",
	}
	
	vpc_tags = {
		"VPC" = "Terraform"
	}

	sg = {
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
    key            = "dev/terraform.tfstate" # tfstate 저장 경로
    region         = "ap-northeast-2"
    dynamodb_table = "rayhli-tfstate-lock" # dynamodb table 이름
  }
}
