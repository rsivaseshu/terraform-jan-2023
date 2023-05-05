locals {
  tags = {
    Owner      = var.owner
    Env        = var.env
    Purpose    = "tf_testing"
    CostCenter = var.costcenter
  }
}