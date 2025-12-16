############################################################
# AUTO SCALING GROUP + TARGET GROUPS (APP TIER)
############################################################
############################################################
# LAUNCH TEMPLATE (APP TIER)
############################################################
resource "aws_launch_template" "app" {
  name_prefix   = "app-lt-"
  image_id      = var.ami
  instance_type = "t3.micro"

  iam_instance_profile {
    name = aws_iam_instance_profile.app.name
  }

  network_interfaces {
    security_groups             = [aws_security_group.app.id]
    associate_public_ip_address = false
  }

  user_data = base64encode(<<EOF
#!/bin/bash
set -e

yum update -y
yum install -y nginx aws-cli

# Configure nginx to listen on 8080
cat <<NGINX > /etc/nginx/conf.d/app.conf
server {
    listen 8080;
    location / {
        root /usr/share/nginx/html;
        index index.html;
    }
}
NGINX

systemctl enable nginx
systemctl start nginx

# Clean default web root
rm -rf /usr/share/nginx/html/*

# Pull application from S3
aws s3 sync s3://pilotgab-web-app /usr/share/nginx/html

systemctl restart nginx
EOF
  )
}

resource "aws_lb_target_group" "app" {
  name     = "app-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_autoscaling_group" "app" {
  desired_capacity    = 2
  max_size            = 4
  min_size            = 2
  vpc_zone_identifier = aws_subnet.app[*].id

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.app.arn]
}
