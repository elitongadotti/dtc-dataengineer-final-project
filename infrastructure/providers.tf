
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.28.0"
    }
  }
  backend "gcs" {

  }
}

provider "google" {
  project = var.project
  zone    = local.zone
}
