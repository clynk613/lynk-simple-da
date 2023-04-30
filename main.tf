variable "region" {
  type        = string
  default     = "us-south"
  description = "The region where to deploy the resources"
}

variable "tags" {
  type    = list(string)
  default = ["terraform", "simple-da"]
}

provider "ibm" {
  region = var.region
}

variable "prefix" {
  type        = string
  default     = ""
  description = "A prefix for all resources to be created. If none provided a random prefix will be created"
}

resource "random_string" "random" {
  count = var.prefix == "" ? 1 : 0

  length  = 6
  special = false
}

locals {
  basename = var.prefix == "" ? "simple-da-${random_string.random.0.result}" : var.prefix
}

resource "ibm_resource_group" "group" {
  name = "${local.basename}-group"
}

resource "ibm_iam_access_group" "administrators" {
  name        = "${local.basename}-administrators"
  description = "Administrators for ${local.basename}"
  tags        = var.tags
}

resource "ibm_iam_access_group" "operators" {
  name        = "${local.basename}-operators"
  description = "Operators for ${local.basename}"
  tags        = var.tags
}

resource "ibm_iam_access_group" "developers" {
  name        = "${local.basename}-developers"
  description = "Developers for ${local.basename}"
  tags        = var.tags
}