resource "aws_lb" "test" {
  count = var.create_elb == true ? 1:0
  name               = var.elb_name
  internal           = var.enable_internal
  load_balancer_type = var.elb_type
  security_groups    = var.security_groups_id
  subnets            = var.subnets_id

  enable_deletion_protection = var.enable_protection

  tags = {
    Environment = "production"
  }
}
