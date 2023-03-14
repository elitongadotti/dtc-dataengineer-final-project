locals {
  region = "europe-west1"
}

variable "sa_key" {
  type        = string
  description = "SA account key (json)"
}

variable "project" {
  type        = string
  description = "Project id"
}