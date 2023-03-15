
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.57.0"
    }
  }

  backend "gcs" {
    bucket      = "terraform-tfstate-dtc-de-project"
    credentials = "/Users/gadotte/other/dtc-dataengineering-zoomcamp/dtc-de-375519-104e2a094182.json"
  }
}

provider "google" {
  project     = var.project
  zone        = local.zone
  credentials = "/Users/gadotte/other/dtc-dataengineering-zoomcamp/dtc-de-375519-104e2a094182.json"
}
