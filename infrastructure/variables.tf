locals {
  region = "europe-west1"
  zone   = "europe-west1-d"
}

variable "sa_key" {
  type        = string
  description = "SA account key (json)"
}

variable "project" {
  type        = string
  description = "Project id"
}

# variable "tf_state_bucket" {
#   type        = string
#   description = "Bucket where tf state is placed"
# }
