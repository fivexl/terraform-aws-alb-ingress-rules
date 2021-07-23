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

Apache 2 Licensed. See LICENSE for full details.
