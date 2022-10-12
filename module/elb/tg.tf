resource "aws_lb_target_group" "elb_target" {
  count = var.create_tg == true ? 1:0

  name     = "${var.elb_name}-tg"
  target_type = var.target_type
  port     = var.target_port
  protocol = var.target_protocol
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "elb_attach" {
  count = var.create_tg == true ? 1:0

  target_group_arn = aws_lb_target_group.elb_target[0].arn
  target_id        = var.attach_target_id
  port             = var.target_port
}
