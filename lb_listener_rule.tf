locals {
  lb_listener_rule_forwards = { for k, v in var.target_groups_map : aws_lb_target_group.this[k].arn => v }
}

# The first 10 processed rules are free. After that, rule evaluations per second will be considered when calculating the number of LCUs
# If the number of the rules more than 15-20 it can be the main metric for determining the value of LCUs for ALB
resource "aws_lb_listener_rule" "this_single_target" {
  for_each     = length(var.target_groups_map) == 1 ? toset(var.domain_names) : toset([])
  listener_arn = var.lb_listener_arn
  action {
    type             = "forward"
    target_group_arn = keys(local.lb_listener_rule_forwards)[0]
  }
  condition {
    host_header {
      values = [each.value]
    }
  }
  dynamic "condition" {
    for_each = length(var.source_ips) != 0 ? { source_ips = var.source_ips } : {}
    content {
      source_ip {
        values = condition.value
      }
    }
  }
  tags = var.tags
}

resource "aws_lb_listener_rule" "this_multi_target" {
  for_each     = length(var.target_groups_map) > 1 ? toset(var.domain_names) : toset([])
  listener_arn = var.lb_listener_arn
  action {
    type = "forward"
    forward {
      dynamic "target_group" {
        for_each = local.lb_listener_rule_forwards
        content {
          arn    = target_group.key
          weight = target_group.value
        }
      }
      stickiness {
        duration = 1
        enabled  = false
      }
    }
  }
  condition {
    host_header {
      values = [each.value]
    }
  }
  dynamic "condition" {
    for_each = length(var.source_ips) != 0 ? { source_ips = var.source_ips } : {}
    content {
      source_ip {
        values = condition.value
      }
    }
  }
  tags = var.tags
}
