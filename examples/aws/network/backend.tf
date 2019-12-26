terraform {
  backend "s3" {
    bucket = "example-scalar-tfstate"
    key    = "network/terraform.tfstate"
    region = "ap-northeast-1"
  }
}
