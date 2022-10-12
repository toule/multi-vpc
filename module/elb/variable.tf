variable "create_elb" {
	description = "Define Enable Create Elastic Load Balancer"
	type		= bool
	default		= false
}

variable "elb_name" {
	description = "Define Elastic Load Balancer Name"
	type		= string
	default		= null
}

variable "elb_type" {
	description = "Define Enable Instance Type"
	type		= string
	default		= "application"
}

variable "enable_internal" {
	description = "Define ELB Location(external/internal) - Default(external)"
	type		= bool
	default		= false
}

variable "subnets_id" {
	description = "Define Working ELB Subnet ID"
	type		= list
	default		= []
}

variable "security_groups_id" {
	description = "Define ELB Security Groups ID"
	type		= list
	default		= []
}

variable "enable_protection" {
	description = "Define ELB Delete Protection"
	type		= bool
	default		= false
}

variable "tags" {
    description = "Define TAGS"
    type        = map(string)
    default     = {
        "Infra" = "Terraform"
        "Temp" = "RayHLi"
    }
}
