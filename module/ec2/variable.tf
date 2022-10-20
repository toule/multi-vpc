variable "create_ec2" {
	description = "Define Enable Create EC2"
	type		= bool
	default		= false
}

variable "ec2_name" {
	description = "Define EC2 Name"
	type		= string
	default		= null
}

variable "instance_type" {
	description = "Define Enable Instance Type"
	type		= string
	default		= "t3.micro"
}

variable "user_data" {
	description = "Define EC2 User Data (Initail)"
	type		= string
	default		= null
}

variable "subnet_id" {
	description = "Define Working EC2 Subnet ID"
	type		= string
	default		= null
}

variable "key_name" {
	description = "Define EC2 Key Name"
	type		= string
	default		= null
}

variable "ami" {
	description = "Define EC2 AMI ID"
	type		= string
	default		= null
}

variable "sg_id" {
	description = "Define Security Group IDs"
	type		= list
	default		= []
}

variable "tags" {
    description = "Define TAGS"
    type        = map(string)
    default     = {
        "Infra" = "Terraform"
        "Temp" = "RayHLi"
    }
}

variable "associate_public_ip_address" {
	description = "Define Public Address"
	type		= bool
	default		= false
}
