resource "google_compute_network" "vpc_network" {
  provider = google.google-europe-west
  name                    = "terraform-network"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "subnet_1" {
  provider      = google.google-europe-west
  name          = "test-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_firewall" "allow_ssh_any_ip" {
  provider = google.google-europe-west
  name     = "ssh-from-any-ip"
  network  = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_service_account" "gce-sa" {
  # Uses the non aliased Google provider configuration that's passed in
  account_id   = "gce-instance"
  display_name = "GCE Instance Service Account"
}

resource "google_compute_instance" "default" {
  provider = google.google-europe-west
  name         = var.instance_name
  machine_type = "e2-micro"

  tags = ["terraform"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet_1.id

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    terraform = "true"
  }

  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.gce-sa.email
    scopes = ["cloud-platform"]
  }
}