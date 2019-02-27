aws_region  = "us-east-1"
aws_profile = "superman"
project_name = "terraform_exersize"

#networking
vpc_cidr    = "10.0.0.0/16"
public_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
private_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
rds_cidrs    = ["10.0.5.0/24", "10.0.6.0/24","10.0.7.0/24"]

accessip = ["0.0.0.0/0"]

# storage
# bez .co.uk za6toto to 6te se dobavi s script ponatam
domain_name = "kurshum"

#DB
db_instance_class	= "db.t2.micro"
dbname			= "supermandb"
dbuser			= "superman"
dbpassword		= "superman123456"