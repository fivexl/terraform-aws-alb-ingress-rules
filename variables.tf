variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "target_groups_map" {
  type = map(number)
  validation {
    condition     = alltrue([for item in keys(var.target_groups_map) : length(item) <= 32 && can(regex("/\\W|-|\\s/", item)) ? true : false])
    error_message = "Name cannot be longer than 32 characters and only a-z, A-Z, 0-9 and hyphens(\"-\") are allowed."
  }
}

variable "vpc_id" {
  description = "ID of the VPC in which the Target Group will be created and in which the ALB is located"
  type        = string
}

variable "lb_listener_arn" {
  description = "ARN of Load Balancer Listener, to which the TLS certificate and rules will be added"
  type        = string
}

variable "domain_names" {
  description = "List of domain names used to find TLS certificates and condition for rules"
  type        = list(string)
}

variable "enable_acm_for_domain_names" {
  description = "Use the `domain_names` to find certificates. Disabled by default"
  type        = bool
  default     = false
}

variable "acm_domain_names" {
  description = "List of domain names used to find TLS certificates"
  type        = list(string)
  default     = []
}

variable "source_ips" {
  description = "List of source IP CIDR notations to match. Used to restrict access to the service from outside."
  type        = list(string)
  default     = []
  validation {
    condition     = length(var.source_ips) <= 4
    error_message = "We cannot use more than 4 CIDRs per one rule."
  }
}

variable "ingress_port" {
  description = "Port for Target Group. Will be used by default when registering new IP addresses in the target group, if no other port is specified. ECS automatically specifies the port."
  type        = number
  default     = 80
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

variable "enable_stickiness" {
  description = "Enable stickiness at Target Group level. We do not manage stickiness at the group level of target groups."
  type        = bool
  default     = false
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
  description = "Port to use to connect with the target. Valid values are either ports 1-65535. By default is `0`, this is the traffic port."
  type        = number
  default     = 0
}

variable "load_balancing_algorithm_type" {
  description = "Determines how the load balancer selects targets when routing requests. The value is `round_robin` or `least_outstanding_requests`"
  type        = string
  default     = "round_robin"
}

variable "health_check_advanced" {
  description = "Advanced Health Check settings at the target group level"
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
