module "test_s3" {
  source                   = "../modules/s3"
  bucketname               = "rssr-module-test-s3-bucket-2"
  env                      = "dev"
  owner                    = "app-team"
  costcenter               = "9876"
  control_object_ownership = true
  versioning               = "Enabled"
  acl                      = "private"
}