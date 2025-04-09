terraform {
  backend "s3" {
    bucket         = "asg-domino-end2end"
    key            = "asg-domino-terraform/state"
    region         = "us-east-1"
    encrypt       = true
    dynamodb_table = "terraform_aws-networking_state_lock"
  }
}