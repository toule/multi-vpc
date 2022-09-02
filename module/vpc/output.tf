output "vpc" {
	value = aws_vpc.my_vpc
}

output "public_subnet" {
	value = var.public_subnet
}

output "private_subnet" {
	value = var.private_subnet
}
