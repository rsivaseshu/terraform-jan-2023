module "example" {
  source             = "../"
  vpc_cidr_block     = "10.0.0.0/16"

  owner      = "tf"
  costcenter = "1331"
  env        = "dev"
}