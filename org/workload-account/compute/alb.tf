############################################################
# COMPUTE (PUBLIC ALB + PRIVATE APP SERVERS)
############################################################
resource "aws_lb" "public" {
  name               = "public-alb"
  load_balancer_type = "application"
  subnets            = aws_subnet.public[*].id
  security_groups    = [aws_security_group.alb.id]

  # Enable access logs for audit and compliance
  # Note: Create S3 bucket for ALB logs separately or uncomment below
  # access_logs {
  #   bucket  = "pilotgab-alb-access-logs"
  #   enabled = true
  # }

  # Enable deletion protection for production
  enable_deletion_protection = true  # Set to false for none-production

  # Enable HTTP/2
  enable_http2 = true

  # Enable cross-zone load balancing
  enable_cross_zone_load_balancing = true

  tags = {
    Name        = "public-alb"
    Environment = "production"
  }
}

# ALB Listener (HTTPS)
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.public.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.acm_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}
