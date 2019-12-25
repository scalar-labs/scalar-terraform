terraform {
  backend "s3" {
    bucket = "example-scalar-tfstate"
    key    = "scalardl/terraform.tfstate"
    region = "ap-northeast-1"
  }
}
