## Step 1 : Apply the config as-is
## Step 2 : Change the resource label from "auto-expire-bucket" to "my-bucket" and uncomment the `moved` block below, apply changes
## Step 3 : It's now safe to remove the `moved` block on a 3rd apply, if desired


resource "random_string" "random" {
  length  = 16
  special = false
  upper   = false
}

locals {
  random_string = random_string.random.result
}

resource "google_storage_bucket" "auto-expire-bucket" {
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

## See above!
# moved {
#     from = google_storage_bucket.auto-expire-bucket
#     to   = google_storage_bucket.my-bucket
# }