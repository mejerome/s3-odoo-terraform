# odoo-terraform
This update is to convert this deployment to docker server that can run multiple odoo instances.
EC2 instance image is replaced with AWS linux AMI with docker installed and EBS volume is attached to the instance.
The load balancer is modified to direct traffic to the right container differentiated by the ports.

To add a new instance just add a new service in the docker-compose.yml file.

Everything else remains same.

[]: # Language: markdown
[]: # Path: README.md
Terraform script to deploy odoo for a company in AWS
The deployment will need to be close to production grade. 
Items deployed are:
1. VPC
2. Subnets (private, public, and database)
3. Security group (https, ssh, and database)
4. Route tables
5. Internet gateway
6. Elastic IP
7. EC2 instance
8. RDS instance
9. Load balancer
10. S3 bucket for storing terraform states and backups
11. Load balancer with SSL certificate
