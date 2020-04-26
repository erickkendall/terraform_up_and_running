provider "aws" {
  version      = "~> 2.0"
  region       = "us-east-1"
  ami          = "ami-0ce2e5b7d27317779"
  intance_type = "t2.micro"


  tags {
    Name = "terraform-example"
  }

}
