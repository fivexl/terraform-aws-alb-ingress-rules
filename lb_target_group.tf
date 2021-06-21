resource "aws_lb_target_group" "this" {
  for_each             = var.target_groups_map
  name                 = each.key
  target_type          = "ip"
  protocol             = var.protocol
  protocol_version     = var.protocol_version
  port                 = var.ingress_port
  vpc_id               = var.vpc_id
  deregistration_delay = var.deregistration_delay
  slow_start           = var.slow_start
  stickiness {
    type            = "lb_cookie"
    enabled         = var.enable_stickiness
    cookie_duration = var.stickiness_cookie_duration
  }
  health_check {
    enabled             = var.enable_health_check
    healthy_threshold   = var.health_check_advanced.healthy_threshold
    interval            = var.health_check_advanced.interval
    matcher             = var.health_check_advanced.matcher
    path                = var.health_check_path
    port                = var.health_check_port != 0 ? var.health_check_port : "traffic-port"
    protocol            = var.protocol
    timeout             = var.health_check_advanced.timeout
    unhealthy_threshold = var.health_check_advanced.unhealthy_threshold
  }
  tags = var.tags
}
