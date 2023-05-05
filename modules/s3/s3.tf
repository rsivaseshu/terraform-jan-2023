resource "aws_s3_bucket" "tf_demo_bucket" {
  count  = var.create_bucket ? 1 : 0
  bucket = var.bucketname
  tags   = local.tags
}

resource "aws_s3_bucket_public_access_block" "example" {
  count = var.create_bucket && var.attach_public_policy ? 1 : 0


  bucket = aws_s3_bucket.tf_demo_bucket[0].id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
resource "aws_s3_bucket_ownership_controls" "example" {
  count = var.create_bucket && var.control_object_ownership ? 1 : 0

  depends_on = [
    aws_s3_bucket_policy.tf_demo_bucket_public_read_access,
    aws_s3_bucket_public_access_block.example,
    aws_s3_bucket.tf_demo_bucket
  ]
  bucket = aws_s3_bucket.tf_demo_bucket[0].id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
resource "aws_s3_bucket_acl" "example" {
  count = var.create_bucket && var.acl != null ? 1 : 0

  depends_on = [aws_s3_bucket_ownership_controls.example]
  bucket     = aws_s3_bucket.tf_demo_bucket[0].id
  acl        = var.acl
}
resource "aws_s3_bucket_versioning" "tf_demo_bucket_versioning" {
  count = var.create_bucket && var.versioning != null ? 1 : 0

  bucket = aws_s3_bucket.tf_demo_bucket[0].id
  versioning_configuration {
    status = var.versioning
  }
}

resource "aws_s3_bucket_website_configuration" "tf_demo_bucket_website_config" {
  count = var.create_bucket && length(keys(var.website)) > 0 ? 1 : 0


  bucket = aws_s3_bucket.tf_demo_bucket[0].id

  dynamic "index_document" {
    for_each = try([var.website["index_document"]], [])

    content {
      suffix = index_document.value
    }
  }

  dynamic "error_document" {
    for_each = try([var.website["error_document"]], [])

    content {
      key = error_document.value
    }
  }
  dynamic "redirect_all_requests_to" {
    for_each = try([var.website["redirect_all_requests_to"]], [])

    content {
      host_name = redirect_all_requests_to.value.host_name
      protocol  = try(redirect_all_requests_to.value.protocol, null)
    }
  }

  dynamic "routing_rule" {
    for_each = try(flatten([var.website["routing_rules"]]), [])

    content {
      dynamic "condition" {
        for_each = [try([routing_rule.value.condition], [])]

        content {
          http_error_code_returned_equals = try(routing_rule.value.condition["http_error_code_returned_equals"], null)
          key_prefix_equals               = try(routing_rule.value.condition["key_prefix_equals"], null)
        }
      }

      redirect {
        host_name               = try(routing_rule.value.redirect["host_name"], null)
        http_redirect_code      = try(routing_rule.value.redirect["http_redirect_code"], null)
        protocol                = try(routing_rule.value.redirect["protocol"], null)
        replace_key_prefix_with = try(routing_rule.value.redirect["replace_key_prefix_with"], null)
        replace_key_with        = try(routing_rule.value.redirect["replace_key_with"], null)
      }
    }
  }

}

resource "aws_s3_bucket_policy" "tf_demo_bucket_public_read_access" {
  count = var.create_bucket && var.attach_public_policy ? 1 : 0


  bucket = aws_s3_bucket.tf_demo_bucket[0].id
  policy = data.aws_iam_policy_document.public_read_access[0].json
}

data "aws_iam_policy_document" "public_read_access" {
  count = var.create_bucket && var.attach_public_policy ? 1 : 0

  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.tf_demo_bucket[0].arn}/*",
    ]
  }

}