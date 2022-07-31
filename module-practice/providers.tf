provider "google" {
    project = var.project_id
}

provider "google" {
  project = var.project_id
  alias   = "google-europe-west"
  region  = "europe-west2"
  zone    = "europe-west2-a"
}