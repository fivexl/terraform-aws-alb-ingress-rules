variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "target_groups_map" {
  type = map(number)
  validation {
    condition     = alltrue([for item in keys(var.target_groups_map) : length(item) <= 30 && can(regex("/\\W|-|\\s/", item)) ? true : false])
    error_message = "Name cannot be longer than 30 characters and only a-z, A-Z, 0-9 and hyphens(\"-\") are allowed."
  }
}

variable "vpc_id" {
  type = string
}

variable "lb_listener_arn" {
  type = string
}

variable "domain_names" {
  type = list(string)
}

variable "acm_domain_names" {
  type    = list(string)
  default = []
}

variable "ingress_port" {
  type    = number
  default = 80
}

variable "enable_stickiness" {
  type    = bool
  default = false
}

variable "enable_health_check" {
  type    = bool
  default = true
}

variable "enable_acm_for_domain_names" {
  type    = bool
  default = false
}

variable "protocol" {
  description = "Protocol to use for routing traffic to the targets"
  type        = string
  default     = "HTTP"
  validation {
    condition     = contains(["HTTP", "HTTPS"], var.protocol)
    error_message = "The valid protocols is HTTP or HTTPS."
  }
}

variable "protocol_version" {
  description = "The protocol version to use for routing traffic"
  type        = string
  default     = "HTTP1"
  validation {
    condition     = contains(["HTTP1", "HTTP2"], var.protocol_version)
    error_message = "The valid protocol versions is HTTP1 or HTTP2."
  }
}

variable "deregistration_delay" {
  description = "Amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused. The range is 0-3600 seconds."
  type        = number
  default     = 60
}

variable "slow_start" {
  description = "Amount time for targets to warm up before the load balancer sends them a full share of requests. The range is 30-900 seconds or 0 to disable. "
  type        = number
  default     = 0
}

variable "stickiness_cookie_duration" {
  description = "The time period, in seconds, during which requests from a client should be routed to the same target."
  type        = number
  default     = 3600
}

variable "health_check_path" {
  description = "Destination for the health check request."
  type        = string
  default     = "/"
}

variable "health_check_port" {
  description = "Port to use to connect with the target. Valid values are either ports 1-65535"
  type        = number
  default     = 0
}

variable "health_check_advanced" {
  type = object({
    healthy_threshold   = number
    interval            = number
    matcher             = string
    timeout             = number
    unhealthy_threshold = number
  })
  default = {
    healthy_threshold   = 3
    interval            = 30
    matcher             = "200-299"
    timeout             = 5
    unhealthy_threshold = 3
  }
}
