# odoo-terraform
Terraform script to deploy odoo for a company in AWS
The deployment will need to be production grade. 
Items to deployed are:
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