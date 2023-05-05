module "test_s3" {
  source     = "../modules/s3"
  bucketname = "rssr-module-test-s3-bucket-1"
  env        = "dev"
  owner      = "ram"
  costcenter = "9876"
}