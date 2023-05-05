locals {
  users = ["sravani", "seshu", "narayana", "gopal", "inam"]

  groups = ["dev", "app", "HR"]



  tags = {
    Owner      = var.owner
    Env        = var.env
    Purpose    = "tf_testing"
    CostCenter = var.costcenter
  }
}


resource "aws_iam_user" "user1" {
  count         = length(local.users)
  name          = local.users[count.index]
  force_destroy = true

  tags = local.tags
}

resource "aws_iam_group" "name" {
  for_each = toset(local.groups)
  name     = each.value
}
