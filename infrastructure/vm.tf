

resource "google_compute_instance" "prefect_vm" {
  name                      = "prefect-vm"
  machine_type              = "n1-standard-2"
  project                   = var.project
  deletion_protection       = false
  enable_display            = true
  allow_stopping_for_update = true

  tags = ["datatalksclub-final-project"]

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20230302"
    }
  }

  // Local SSD disk
  scratch_disk {
    interface = "SCSI"
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }


  # metadata_startup_script = <<EOT
  #   echo "this is a test"
  #   echo \"${var.sa_key}\" > ~/default-sa.json

  #   file(../scripts/bootstrap.sh)
  # EOT

  metadata_startup_script = file("../scripts/bootstrap.sh")

  #   service_account {
  #     # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
  #     email  = google_service_account.default.email
  #     scopes = ["cloud-platform"]
  #   }
}