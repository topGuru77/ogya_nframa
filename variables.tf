variable "vpc_cidr_block" {
    description = "this is the CIDR block for the VPC"
    type        = string 
}

variable "pub_subnet1_az" {
  description = "Availability Zone for public subnet 1"
  type        = string
}

variable "pub_subnet2_az" {
  description = "Availability Zone for public subnet 2"
  type        = string
}

variable "pub_subnet3_az" {
  description = "Availability Zone for public subnet 3"
  type        = string
}

variable "priv_subnet1_az" {
  description = "Availability Zone for private subnet 1"
  type        = string
}

variable "priv_subnet2_az" {
  description = "Availability Zone for private subnet 2"
  type        = string
}

variable "vpc_instance_tenancy" {
    description = "this is the instance tenancy for the VPC"
    type        = string 
}
variable "pub_subnet1_cidr_block" {
    description = "this is the CIDR block for the public subnet 1"
    type        = string
}

variable "pub_subnet2_cidr_block" {
    description = "this is the CIDR block for the public subnet 2"
    type        = string
}

variable "pub_subnet3_cidr_block" {
    description = "this is the CIDR block for the public subnet 3"
    type        = string
}

variable "priv_subnet1_cidr_block" {
    description = "this is the CIDR block for the private subnet 1"
    type        = string
}

variable "priv_subnet2_cidr_block" {
    description = "this is the CIDR block for the private subnet 2"
    type        = string
}

variable "pub-RT1_cidr_block" {
    description = "this is the CIDR block for the public route table 1"
    type        = string
}

variable "pub-RT2_cidr_block" {
    description = "this is the CIDR block for the public route table 2"
    type        = string
}

variable "pub-RT3_cidr_block" {
    description = "this is the CIDR block for the public route table 3"
    type        = string
}

variable "priv-RT1_cidr_block" {
    description = "this is the CIDR block for the private route table 1"
    type        = string
}

variable "priv-RT2_cidr_block" {
    description = "this is the CIDR block for the private route table 2"
    type        = string
}


variable "tag_overlay" {
  description = "Tag overlay for resources"
  type        = map(string)

}
# EC2 Instances
variable "ami" {
  description = "The AMI ID for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "The EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "The name of the key pair for EC2 instances"
  type        = string
}

# Load Balancer
variable "asgapp_alb" {
  description = "The name of the load balancer"
  type        = string
  default     = "asgapp_alb"
}

# Auto Scaling
variable "min_asg_size" {
  description = "The minimum size of the Auto Scaling Group"
  type        = number
  default     = 1
}

variable "max_asg_size" {
  description = "The maximum size of the Auto Scaling Group"
  type        = number
  default     = 3
}

# Security Groups
# variable "asg_ec2_sg_id" {
#   description = "Security group for EC2 instances"
#   type        = string
# }

# variable "alb_sg_id" {
#   description = "The ID of the ALB security group"
#   type        = string
# }


# Region and Environment (optional but good for multi-environment setups)
variable "region" {
  description = "AWS region to deploy to"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "The environment (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

