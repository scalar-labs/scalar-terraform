terraform {
  backend "s3" {
    bucket = "example-scalar-tfstate"
    key    = "cassandra/terraform.tfstate"
    region = "ap-northeast-1"
  }
}
