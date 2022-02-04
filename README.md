# odoo-terraform
Terraform script to deploy odoo for a company in AWS
The deployment will need to be close to production grade. Items to consider are
1. 1 VPC
2. 3 subnets (private, public, and database)
3. 3 security group (https, ssh, and database)
4. 2 route tables
5. 1 internet gateway
6. 1 elastic IP
7. 1 ec2 instance
8. 1 RDS instance
9. 1 load balancer
10. 1 s3 bucket for storing terraform states and backups
11. 1 load balancer with SSL certificate
