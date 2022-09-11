resource "aws_lb" "prom_server_lb" {
  name               = "prom-server-lb"
  security_groups    = [var.lb_sg]
  subnets            = var.public_subnet
}

resource "aws_lb_target_group" "grafana_tg" {
  name     = "grafana-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    matcher = "302"
  }
}

resource "aws_lb_target_group_attachment" "instance" {
  target_group_arn = aws_lb_target_group.grafana_tg.arn
  target_id        = var.instance_id[count.index]
  count = var.instance_count
  port             = 3000
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.prom_server_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:eu-west-2:853751771267:certificate/9110e4a0-2514-404b-8748-2cf193aeab8c"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.grafana_tg.arn
  }
}