
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.57.0"
    }
  }
  backend "gcs" {
    bucket = var.tf_state_bucket
  }
}

provider "google" {
  project = var.project
  zone    = local.zone
}
