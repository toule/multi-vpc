resource "aws_security_group" "endpoint_sg" {
    vpc_id = aws_vpc.my_vpc[0].id
    name = "vpc-endpoint-sg"
    description = "endpoint sg"
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = [aws_vpc.my_vpc[0].cidr_block]
    }
    egress {
        from_port = 0
        to_port = 0
        cidr_blocks = [var.cidr]
        protocol = -1
    }
}
