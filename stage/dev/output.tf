output "vpc_id" {
	value = module.vpc.vpc[0].id
}

output "vpc_cidr" {
	value = module.vpc.vpc[0].cidr_block
}

output "public_subnet" {
	value = module.vpc.public_subnet.CIDR
}

output "private_subnet" {
	value = module.vpc.private_subnet.CIDR
}
