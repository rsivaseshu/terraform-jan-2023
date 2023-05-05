variable "bucketname" {
  type        = string
  description = "enter your bucket name"
}

variable "owner" {
  type        = string
  description = "Enter bucket owner name"
}

variable "env" {
  type        = string
  description = "Enter env name"
}

variable "costcenter" {
  type        = number
  description = "Enter costcenter name"
}

variable "create_bucket" {
  description = "Controls if S3 bucket should be created"
  type        = bool
  default     = true
}

variable "attach_public_policy" {
  description = "Controls if a user defined public bucket policy will be attached (set to `false` to allow upstream to apply defaults to the bucket)"
  type        = bool
  default     = false
}

variable "acl" {
  description = "(Optional) The canned ACL to apply. Conflicts with `grant`"
  type        = string
  default     = null
}

variable "versioning" {
  description = "(Optional) Versioning defaults to null. if you want make it enabled "
  default     = null
  type        = string
}

variable "website" {
  description = "Map containing static web-site hosting or redirect configuration."
  type        = any # map(string)
  default     = {}
}

variable "control_object_ownership" {
  description = "Whether to manage S3 Bucket Ownership Controls on this bucket."
  type        = bool
  default     = false
}