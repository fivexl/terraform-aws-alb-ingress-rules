output "lb_target_group_arns" {
  value = { for k, v in var.target_groups_map : k => aws_lb_target_group.this[k].arn }
}
