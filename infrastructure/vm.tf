

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

  # https://stackoverflow.com/a/64230192
  metadata_startup_script = templatefile("../scripts/bootstrap.sh", {
    service_account_content = "${var.sa_key}"
    ssh_pvt_key             = var.ssh_pvt_key
  })

}