locals {
	az_len = try(length(var.azs), 0)
   	pub_len = try(length(var.public_subnet.CIDR), 0)
   	pri_len = try(length(var.private_subnet.CIDR), 0)
    db_len = try(length(var.db_subnet.CIDR), 0)
	firewall_len = try(length(var.firewall_subnet.CIDR), 0)
	max_len = max(
		try(length(var.azs), 0),
   		try(length(var.public_subnet.CIDR), 0),
   		try(length(var.private_subnet.CIDR), 0),
    	try(length(var.db_subnet.CIDR), 0),
		try(length(var.firewall_subnet.CIDR), 0),
	)
}


##Public Subnet

resource "aws_subnet" "public_subnet" {
	count = local.create_vpc && local.pub_len > 0 ? local.pub_len : 0

	vpc_id     = aws_vpc.my_vpc[0].id
	availability_zone = var.azs[count.index%local.az_len]
    cidr_block = var.public_subnet.CIDR[count.index]

	tags = merge(
		{ "Name" = "${var.public_subnet.Name}-${upper(substr(var.azs[count.index%local.az_len],14,1))}" },
        var.tags,
        try(var.public_subnet.tags, {}),
    )	
}

##Private Subnet

resource "aws_subnet" "private_subnet" {
	count = local.create_vpc && local.pri_len > 0 ? local.pri_len : 0

	vpc_id     = aws_vpc.my_vpc[0].id
	availability_zone = var.azs[count.index%local.az_len]
    cidr_block = var.private_subnet.CIDR[count.index]

	tags = merge(
		{ "Name" = "${var.private_subnet.Name}-${upper(substr(var.azs[count.index%local.az_len],14,1))}" },
        var.tags,
		try(var.private_subnet.tags, {}),
    )	
}

##DB Subnet

resource "aws_subnet" "db_subnet" {
	count = local.create_vpc && local.db_len > 0 ? local.db_len : 0

	vpc_id     = aws_vpc.my_vpc[0].id
	availability_zone = var.azs[count.index%local.az_len]
    cidr_block = var.db_subnet.CIDR[count.index]

	tags = merge(
		{ "Name" = "${var.db_subnet.Name}-${upper(substr(var.azs[count.index%local.az_len],14,1))}" },
        var.tags,
		try(var.db_subnet.tags, {}),
    )	
}

##Firewall Subnet

resource "aws_subnet" "firewall_subnet" {
	count = local.create_vpc && local.firewall_len > 0 ? local.firewall_len : 0

	vpc_id     = aws_vpc.my_vpc[0].id
	availability_zone = var.azs[count.index%local.az_len]
    cidr_block = var.firewall_subnet.CIDR[count.index]

	tags = merge(
		{ "Name" = "${var.firewall_subnet.Name}-${upper(substr(var.azs[count.index%local.az_len],14,1))}" },
        var.tags,
		try(var.firewall_subnet.tags, {}),
    )	
}

