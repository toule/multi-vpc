locals {
	public_attach_igw = try(var.public_subnet.attach_igw, true)
	private_attach_nat = try(var.private_subnet.attach_nat, false)
	db_attach_igw = try(var.db_subnet.attach_igw, false)
	db_attach_nat = try(var.db_subnet.attach_nat, false)
}

resource "aws_route_table" "public_rt" {
	count = local.create_vpc && local.pub_len == 0 ? 0 : local.firewall_len > 0 ? local.pub_len : 1
	vpc_id = aws_vpc.my_vpc[0].id

	dynamic "route" {
    	for_each = local.public_attach_igw == true ? ["0.0.0.0/0"] : []
    	content {
      		cidr_block = route.value
      		gateway_id = aws_internet_gateway.igw[0].id
     	}
  	}

	tags = merge(
		{"Name"= local.firewall_len > 0 ? "${var.name}-public-rt-${upper(substr(var.azs[count.index%local.az_len],14,1))}" : "${var.name}-public-rt"},
		var.tags,
	)
}

resource "aws_route_table_association" "public_rt" {
	count = local.create_vpc && local.pub_len > 0 ? local.pub_len : 0
	
	subnet_id = element(aws_subnet.public_subnet[*].id, count.index)
	route_table_id = local.firewall_len > 0 ? element(aws_route_table.public_rt[*].id, count.index) : aws_route_table.public_rt[0].id
}

resource "aws_route_table" "private_rt" {
	count = local.create_vpc && local.pri_len > 0 ? local.pri_len : 0
	vpc_id = aws_vpc.my_vpc[0].id

	dynamic "route" {
    	for_each = local.private_attach_nat == true ? ["0.0.0.0/0"] : []
    	content {
      		cidr_block = route.value
      		nat_gateway_id = var.single_nat == true ? aws_nat_gateway.nat[0].id : element(aws_nat_gateway.nat[*].id, count.index)
    	}
  	}

	tags = merge(
		{"Name"= "${var.name}-private-rt-${upper(substr(var.azs[count.index%local.az_len],14,1))}"},
		var.tags,
	)
}

resource "aws_route_table_association" "private_rt" {
	count = local.create_vpc && local.pri_len > 0 ? local.pri_len : 0
	
	subnet_id = element(aws_subnet.private_subnet[*].id, count.index)
	route_table_id = element(aws_route_table.private_rt[*].id, count.index)
}

resource "aws_route_table" "db_private_rt" {
	count = local.create_vpc && local.db_len > 0 ? local.db_len : 0
	vpc_id = aws_vpc.my_vpc[0].id

	dynamic "route" {
    	for_each = local.db_attach_igw == true || local.db_attach_nat == true ? ["0.0.0.0/0"] : []
    	content {
      		cidr_block = route.value
			gateway_id = local.db_attach_igw == true ? aws_internet_gateway.igw[0].id : ""
      		nat_gateway_id = local.db_attach_nat == false ? "" : var.single_nat == true ? aws_nat_gateway.nat[0].id : element(aws_nat_gateway.nat[*].id, count.index)
    	}
  	}

	tags = merge(
		{"Name"= "${var.name}-db-rt-${upper(substr(var.azs[count.index%local.az_len],14,1))}"},
		var.tags,
	)
}
