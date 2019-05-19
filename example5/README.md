# Django App Deployment Framework #

Purpose: To provide a re-useable Terraform framework that can be used to 
deploy multiple django applications or a single django application to
different environments like DEV, QA and Production. 

AWS Features:
- AWS ALB with SSL
- AWS Fargate with multiple application instances
- Aurora Serverless for database

Things missing / not done:
- S3 bucket for ALB access logs
- Separate between Aurora admin creds and Django db creds in settings.py