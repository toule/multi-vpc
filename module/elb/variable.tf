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

variable "create_tg" {
    description = "Define Enable ELB Target Group"
    type        = bool
    default     = false
}

variable "target_type" {
    description = "Define ELB Target Group Type"
    type        = string
    default     = "instance"
}

variable "target_port" {
	description = "Define ELB Target Group Port"
	type		= number
	default		= 0
}

variable "target_protocol" {
    description = "Define ELB Target Group Protocol"
    type        = string
    default     = null
}

variable "vpc_id" {
    description = "Define the VPC ID where the Working ELB"
    type        = string
    default     = null
}

variable "attach_target_id" {
    description = "Define the Attach Target ID(Instance/ECS Container/Lambda etc..)"
    type        = string
    default     = null
}
