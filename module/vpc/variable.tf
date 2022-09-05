variable "region" {
	description = "Defined Region"
	type		= string
	default		= "ap-northeast-2"
}

variable "azs" {
	description = "Defined Available Zones"
	type		= list(string)
	default		= []
}

variable "create_vpc" {
	description = "Defined Created VPC"
	type 		= bool
	default		= true
}

variable "cidr" {
	description = "Define VPC CIDR"
	type		= string
	default		= ""
}

variable "name" {
	description = "Define Infra Name"
	type		= string
	default		= ""
}

variable "public_subnet" {
	description = "Define Public Subnet CIDR"
	type		= any
	default		= {}
}

variable "private_subnet" {
	description = "Define Private Subnet CIDR"
	type		= any
	default	 	= {}
}

variable "db_subnet" {
	description = "Define DB Subnet CIDR"
	type		= any
	default		= {}
}

variable "firewall_subnet" {
	description = "Define Firewall Subnet CIDR"
	type		= any
	default		= {}
}

variable "tags" {
	description = "Define TAGS"
	type		= map(string)
	default		= {
		"Infra" = "Terraform"
		"Temp" = "RayHLi"
	}
}

variable "vpc_tags" {
	description = "Define VPC Tags"
	type		= map(string)
	default		= {}
}

variable "enable_igw" {
	description = "Define Enabled Internet Gateway"
	type		= bool
	default		= true
}

variable "enable_nat" {
	description = "Define Enabled NAT"
	type		= bool
	default		= false
}

variable "enable_vpn_gateway" {
	description = "Define Enable VPN Gateway"
	type		= bool
	default		= false
}

variable "sg" {
	description = "Define Security Group"
	type		= any
	default		= {}
}

variable "single_nat" {
	description = "Define Single Nat"
	type		= bool
	default		= false
}

variable "ha_nat" {
	description = "Define HA Nats"
	type		= bool
	default		= false
}

variable "endpoints" {
	description = "Define VPC Endpoint"
	type		= any
	default		= {}
}

variable "endpoint_sg" {
	description = "Define VPC Endpoint SG"
	type		= string
	default		= ""
}
