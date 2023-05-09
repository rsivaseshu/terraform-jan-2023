data "aws_subnet" "pub_sub1" {
  filter {
    name   = "tag:Name"
    values = ["Demo-${var.env}-pub-sub-1"]
  }
}