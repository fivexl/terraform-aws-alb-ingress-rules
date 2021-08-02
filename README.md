[![FivexL](https://releases.fivexl.io/fivexlbannergit.jpg)](https://fivexl.io/)

# ALB Ingress Rules/TLS/Target Groups
- TLS with ACM
- Listener Rules and Target Groups for ALB

## Example

```hcl

data "aws_lb" "this" {
  name = "ExampleALB"
}

data "aws_lb_listener" "this_443" {
  load_balancer_arn = data.aws_lb.this.arn
  port              = 443
}

module "ingress" {
  source            = "./alb-ingress-rules"
  domain_names      = ["example.com", "www.example.com"]
  lb_listener_arn   = data.aws_lb_listener.this_443.arn
  health_check_path = "/health"
  ingress_port      = 8080

  target_groups_map = {
    "my-example-app-v1" = 100
  }

  vpc_id = "vpc-id1111111111111"
} 

```

## TODO
- protocol_version: GRPC
- protocol: GENEVE, TCP, TCP_UDP, TLS, UDP
- target_type: instance/lambda

## More info
[Target groups for your Application Load Balancers](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-target-groups.html)

| Request protocol | Protocol version | Result  |
| ---------------- | ---------------- | ------- |  
| HTTP/1.1         |	HTTP/1.1	  | Success |
| HTTP/2	       |    HTTP/1.1      |	Success |
| gRPC	           |    HTTP/1.1      |	Error   |
| HTTP/1.1	       |    HTTP/2	      | Error   |
| HTTP/2           |	HTTP/2        |	Success |
| gRPC             |	HTTP/2        |	Success if targets support gRPC |
| HTTP/1.1         |	gRPC	      | Error   |
| HTTP/2	       |    gRPC          |	Success if a POST request |
| gRPC             |	gRPC          |	Success |

## License

Apache 2 Licensed. See [LICENSE](LICENSE) for full details.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.30.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.30.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_lb_listener_certificate.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_certificate) | resource |
| [aws_lb_listener_rule.this_multi_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_listener_rule.this_single_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_target_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_acm_certificate.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acm_domain_names"></a> [acm\_domain\_names](#input\_acm\_domain\_names) | List of domain names used to find TLS certificates | `list(string)` | `[]` | no |
| <a name="input_deregistration_delay"></a> [deregistration\_delay](#input\_deregistration\_delay) | Amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused. The range is 0-3600 seconds. | `number` | `60` | no |
| <a name="input_domain_names"></a> [domain\_names](#input\_domain\_names) | List of domain names used to find TLS certificates and condition for rules | `list(string)` | n/a | yes |
| <a name="input_enable_acm_for_domain_names"></a> [enable\_acm\_for\_domain\_names](#input\_enable\_acm\_for\_domain\_names) | Use the `domain_names` to find certificates. Disabled by default | `bool` | `false` | no |
| <a name="input_enable_stickiness"></a> [enable\_stickiness](#input\_enable\_stickiness) | Enable stickiness at Target Group level. We do not manage stickiness at the group level of target groups. | `bool` | `false` | no |
| <a name="input_health_check_advanced"></a> [health\_check\_advanced](#input\_health\_check\_advanced) | Advanced Health Check settings at the target group level | <pre>object({<br>    healthy_threshold   = number<br>    interval            = number<br>    matcher             = string<br>    timeout             = number<br>    unhealthy_threshold = number<br>  })</pre> | <pre>{<br>  "healthy_threshold": 3,<br>  "interval": 30,<br>  "matcher": "200-299",<br>  "timeout": 5,<br>  "unhealthy_threshold": 3<br>}</pre> | no |
| <a name="input_health_check_path"></a> [health\_check\_path](#input\_health\_check\_path) | Destination for the health check request. | `string` | `"/"` | no |
| <a name="input_health_check_port"></a> [health\_check\_port](#input\_health\_check\_port) | Port to use to connect with the target. Valid values are either ports 1-65535. By default is `0`, this is the traffic port. | `number` | `0` | no |
| <a name="input_ingress_port"></a> [ingress\_port](#input\_ingress\_port) | Port for Target Group. Will be used by default when registering new IP addresses in the target group, if no other port is specified. ECS automatically specifies the port. | `number` | `80` | no |
| <a name="input_lb_listener_arn"></a> [lb\_listener\_arn](#input\_lb\_listener\_arn) | ARN of Load Balancer Listener, to which the TLS certificate and rules will be added | `string` | n/a | yes |
| <a name="input_load_balancing_algorithm_type"></a> [load\_balancing\_algorithm\_type](#input\_load\_balancing\_algorithm\_type) | Determines how the load balancer selects targets when routing requests. The value is `round_robin` or `least_outstanding_requests` | `string` | `"round_robin"` | no |
| <a name="input_protocol"></a> [protocol](#input\_protocol) | Protocol to use for routing traffic to the targets | `string` | `"HTTP"` | no |
| <a name="input_protocol_version"></a> [protocol\_version](#input\_protocol\_version) | The protocol version to use for routing traffic | `string` | `"HTTP1"` | no |
| <a name="input_slow_start"></a> [slow\_start](#input\_slow\_start) | Amount time for targets to warm up before the load balancer sends them a full share of requests. The range is 30-900 seconds or 0 to disable. | `number` | `0` | no |
| <a name="input_source_ips"></a> [source\_ips](#input\_source\_ips) | List of source IP CIDR notations to match. Used to restrict access to the service from outside. | `list(string)` | `[]` | no |
| <a name="input_stickiness_cookie_duration"></a> [stickiness\_cookie\_duration](#input\_stickiness\_cookie\_duration) | The time period, in seconds, during which requests from a client should be routed to the same target. | `number` | `3600` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_target_groups_map"></a> [target\_groups\_map](#input\_target\_groups\_map) | n/a | `map(number)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC in which the Target Group will be created and in which the ALB is located | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lb_target_group_arns"></a> [lb\_target\_group\_arns](#output\_lb\_target\_group\_arns) | n/a |
