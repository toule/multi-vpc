output "vpc" {
	value = aws_vpc.my_vpc
}

output "vpc_public_subnet" {
	value = aws_subnet.public_subnet
}

output "vpc_private_subnet" {
	value = aws_subnet.private_subnet
}

output "public_subnet" {
	value = var.public_subnet
}

output "private_subnet" {
	value = var.private_subnet
}

output "security_group" {
	value = aws_security_group.sg
}
