locals {
	nat_count = var.single_nat ? 1 : var.ha_nat ? length(var.azs) : local.max_len
    nat_ips = try(aws_eip.nat_eip[*].id, [])
	vpc_endpoints = { for k, v in var.endpoints : k => v }
}


resource "aws_internet_gateway" "igw" {
	count = local.create_vpc && var.enable_igw ? 1:0
	vpc_id = aws_vpc.my_vpc[0].id

	tags = merge(
		{"Name"="${var.name}-igw"},
		var.tags,
	)
}

resource "aws_eip" "nat_eip" {
	count = local.create_vpc && var.enable_nat ? local.nat_count : 0
	vpc = true
	
	tags = merge(
		{"Name"="${var.name}-eip-${count.index}"},
		var.tags,
	)
}

resource "aws_nat_gateway" "nat" {
	count = local.create_vpc && var.enable_nat ? local.nat_count : 0
	
	allocation_id = element(local.nat_ips, count.index)
	subnet_id	= element(aws_subnet.public_subnet[*].id, count.index)

	tags = merge(
		{"Name"="${var.name}-nat-${upper(substr(var.azs[count.index%local.az_len],14,1))}"},
		var.tags,
	)
}

resource "aws_vpc_endpoint" "endpoint" {
	for_each = local.vpc_endpoints

	vpc_id	= aws_vpc.my_vpc[0].id
	auto_accept	= try(lookup(each.value, "auto_accept"), null)
	vpc_endpoint_type = lookup(each.value, "type")
	
	subnet_ids = lookup(each.value, "type") == "Interface" ? [for s in range(local.pri_len) : aws_subnet.private_subnet[s].id] : null
	security_group_ids = lookup(each.value, "type") == "Interface" ? [aws_security_group.endpoint_sg.id,] : null

	service_name = "com.amazonaws.${var.region}.${each.key}"

	route_table_ids = lookup(each.value, "type") == "Gateway" ? [for s in range(local.pri_len) : aws_route_table.private_rt[s].id]  : null

	tags = merge(
		{"Name"="${var.name}-${each.key}-${lookup(each.value, "type")}-endpoint"},
		var.tags,
	)

}

resource "aws_vpn_gateway" "vpn_gw" {
	count = local.create_vpc && var.enable_vpn_gateway ? 1:0
	
	vpc_id = aws_vpc.my_vpc[0].id
	
	tags = merge(
		{"Name"="${var.name}-vpn-gateway"},
		var.tags,
	)
}
