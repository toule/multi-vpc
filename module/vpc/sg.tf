locals {
	sg = {for k,v in var.sg : k=>v}
}

resource "aws_security_group" "sg" {
	for_each = local.sg
    vpc_id = aws_vpc.my_vpc[0].id
    name = each.value.Name
    description = "security group"
    ingress {
        from_port = lookup(each.value.Ingress, "F-Port")
        to_port = lookup(each.value.Ingress, "T-Port")
        protocol = lookup(each.value.Ingress, "PROTOCOL")
        cidr_blocks = lookup(each.value.Ingress, "CIDR")
    }
    egress {
        from_port = lookup(each.value.Egress, "F-Port")
        to_port = lookup(each.value.Egress, "T-Port")
        cidr_blocks = lookup(each.value.Egress, "CIDR")
        protocol = lookup(each.value.Egress, "PROTOCOL")
    }
	tags = merge(
		{"Name"="${var.name}-${upper(each.key)}-SG"},
		var.tags,
	)
}
