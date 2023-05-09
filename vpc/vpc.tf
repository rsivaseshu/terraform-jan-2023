module "some-vpc" {
  source         = "git::https://github.com/rsivaseshu/terraform-jan-2023.git//modules/vpc?ref=v1.0.0"
  vpc_cidr_block = "172.19.0.0/16"
  env            = "test"
  owner          = "test-user1"
  costcenter     = 5673
}