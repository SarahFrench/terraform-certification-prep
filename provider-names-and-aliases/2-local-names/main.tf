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

resource "google_storage_bucket" "auto-expire-bucket" {
  # provider      = goog # Adding this suppresses a warning, but isn't required for the plan to work
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