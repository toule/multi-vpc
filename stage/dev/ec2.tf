locals {
	user_data = <<-EOT
	#!/bin/sh
	yum upgrade -y && yum update -y
	echo "Start Instance!"
	EOT
}

module "public_ec2" {
	source = "../../module/ec2"
	create_ec2 = true
	ec2_name = "bastion-dev-instance"
	
	user_data = local.user_data
	ami = "ami-01d87646ef267ccd7"
	instance_type = "t3.micro"
    subnet_id = module.vpc.vpc_public_subnet[0].id ##subnet_id = "subnet-0222aaec8f37ec604"
    sg_id = [module.vpc.security_group.ssh.id] 

	key_name = "keypair" ##Using existed keypair

	tags = {
		"Stage" = "Dev"
	}
}

module "private_ec2" {
	source = "../../module/ec2"
	create_ec2 = true
	ec2_name = "private-dev-instance"
	
	user_data = local.user_data
	ami = "ami-01d87646ef267ccd7"
	instance_type = "t3.micro"
    subnet_id = module.vpc.vpc_private_subnet[0].id ##subnet_id = "subnet-0222aaec8f37ec604"
    sg_id = [module.vpc.security_group.vpc-endpoint.id]

	key_name = "keypair" ##Using existed keypair

	tags = {
		"Stage" = "Dev"
	}
}
