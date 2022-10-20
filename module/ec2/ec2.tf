resource "aws_instance" "ec2" {
	count = var.create_ec2 == true ? 1:0

	ami						= var.ami
	instance_type			= var.instance_type
	user_data				= var.user_data
	subnet_id				= var.subnet_id
	key_name				= var.key_name
	vpc_security_group_ids	= var.sg_id
    associate_public_ip_address = var.associate_public_ip_address

	tags = merge(
        {"Name"=var.ec2_name},
        var.tags,
    )
}
