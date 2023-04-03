
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.57.0"
    }
  }

  backend "gcs" {
    bucket = "terraform-tfstate-dtc-de-project"
  }
}

provider "google" {
  project = var.project
  zone    = local.zone
}