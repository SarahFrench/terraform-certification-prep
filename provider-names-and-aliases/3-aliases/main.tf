terraform {
  required_providers {
    goog = {
      source = "hashicorp/google"
      version = "4.33.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.3.2"
    }
  }
}

resource "random_string" "random" {
  length  = 16
  special = false
  upper   = false
}

locals {
  random_string = random_string.random.result
}

# Refer to the google provider via the goog local name in the required_providers block
provider "goog" {
  alias = "foobar"
}

resource "google_storage_bucket" "auto-expire-bucket" {
  provider      = goog.foobar
  name          = "test-bucket-${local.random_string}"
  location      = "us-central1"
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 3
    }
    action {
      type = "Delete"
    }
  }
}