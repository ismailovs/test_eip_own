module "security_groups" {
  source  = "app.terraform.io/s_tc_1/security_groups/aws"
  version = "1.0.0"
  vpc_id = aws_vpc.main.id
  security_groups = var.security_groups
  # insert required variables here!
}