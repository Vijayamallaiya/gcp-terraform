resource "google_service_account" "vm_sa" {
  account_id   = "wordpress-sa"
  display_name = "WordPress Service Account"
}

resource "google_project_iam_member" "logging" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.vm_sa.email}"
}

resource "google_compute_instance" "vm" {
  name         = var.instance_name
  machine_type = "e2-medium"
  zone         = var.zone

  tags = ["ssh", "http"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork

    access_config {}
  }

  service_account {
    email  = google_service_account.vm_sa.email
    scopes = ["https://www.googleapis.com/auth/logging.write"]
  }

  metadata_startup_script = templatefile("${path.module}/../../scripts/startup.sh", {
    db_password = var.db_password
  })
}