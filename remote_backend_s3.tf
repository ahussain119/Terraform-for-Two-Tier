# Purpose: This file is used to configure the remote backend for the terraform state file.  
terraform {
    backend "s3" {
        bucket = "aws-tier-2-remote-storage-aaqib"
        key    = "key/terraform.tfstate"
        region = "us-west-2"
    }
}