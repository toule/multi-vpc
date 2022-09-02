provider "aws" {
  region  = "ap-northeast-2"
}

module "vpc" {
	source = "../../module/vpc"
	create_vpc = true

    name = "DEV-VPC"
	cidr = "10.0.0.0/16"
	azs = ["ap-northeast-2a","ap-northeast-2c"]

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
	endpoints = {
		sns = {"type" = "Interface"}
		s3 = {"type"	= "Gateway"}
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
