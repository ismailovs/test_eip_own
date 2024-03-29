variable "security_groups" {
  description = "A map of security groups with their rules"
  type = map(object({
    description = string
    ingress_rules = optional(list(object({
      description = optional(string)
      priority    = optional(number)
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    })))
    egress_rules = list(object({
      description = optional(string)
      priority    = optional(number)
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
  }))
}

variable "key_name" {
    type = string
    default = "cloud_2025"
}

variable "instance_types" {
  type    = list(string)
  default = ["t2.micro", "t2.small", "t2.medium"]
}

variable "ami" {
  type = map(any)
  default = {
    us-east-1a = "ami-0230bd60aa48260c6"
    us-west-1a = "ami-06e4ca05d431835e9"
    us-west-2a = "ami-093467ec28ae4fe03"
  }
}