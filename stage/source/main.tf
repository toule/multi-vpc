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

	enable_nat = false
	single_nat = false

	tags = {
		"Stage" = "Dev",
		"Infra" = "Terraform",
		"Source" = "GIT"
	}
	
	vpc_tags = {
		"VPC" = "Terraform"
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
    key            = "source/terraform.tfstate" # tfstate 저장 경로
    region         = "ap-northeast-2"
    dynamodb_table = "rayhli-tfstate-lock" # dynamodb table 이름
  }
}
