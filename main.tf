provider "aws" {
  region = "eu-west-2"
}

#------------------Network_Load_Balancer-----------------------
resource "aws_lb" "nlb" {
  name               = "terraform-nlb"
  load_balancer_type = "network"
  subnets            = [var.subnet_a, var.subnet_b, var.subnet_c]
  count              = var.load_balancer_type == "nlb" ? 1 : 0
  tags = {
    Name = "terraform-nlb"
  }
}

#------------------Listener_for_NLB---------------------
resource "aws_lb_listener" "listener_tcp" {
  load_balancer_arn = aws_lb.nlb[0].arn
  port              = "80"
  protocol          = "TCP"
  count             = var.load_balancer_type == "nlb" ? 1 : 0

  default_action {
    target_group_arn = aws_lb_target_group.web.arn
    type             = "forward"
  }
}
