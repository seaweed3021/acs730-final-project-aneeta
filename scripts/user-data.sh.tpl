#!/bin/bash
yum update -y
yum install -y httpd awscli

systemctl start httpd
systemctl enable httpd

mkdir -p /var/www/html/images
aws s3 cp s3://${bucket_name}/${image_key} /var/www/html/images/site-image.webp --region us-east-1

INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

cat > /var/www/html/index.html << HTMLEOF
<!DOCTYPE html>
<html>
<head>
  <title>Aneeta - ACS730 Final Project</title>
  <style>
    body { font-family: Arial, sans-serif; text-align: center; margin-top: 50px; background: #f4f4f4; }
    img { max-width: 400px; border-radius: 10px; box-shadow: 0 4px 8px rgba(0,0,0,0.2); }
    h1 { color: #333; }
  </style>
</head>
<body>
  <h1>Aneeta - ACS730 Two-Tier Web Application</h1>
  <p>Served from EC2 via Auto Scaling Group behind an Application Load Balancer</p>
  <p>Instance ID: $INSTANCE_ID</p>
  <img src="images/site-image.webp" alt="Project image">
</body>
</html>
HTMLEOF

systemctl restart httpd