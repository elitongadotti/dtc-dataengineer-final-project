resource "google_bigquery_dataset" "cota_parlamentar_dataset" {
  dataset_id    = "cota_parlamentar_ds"
  friendly_name = "cota_parlamentar"
  description   = "Cota Parlamentar dataset"
  location      = local.region
  access {
    role          = "OWNER"
    user_by_email = "emailAddress:dtc-sa@dtc-de-375519.iam.gserviceaccount.com"
  }
}

resource "google_bigquery_table" "cota_parlamentar_raw_data" {
  dataset_id = google_bigquery_dataset.cota_parlamentar_dataset.dataset_id
  table_id   = "cota_parlamentar_raw"

  time_partitioning {
    type = "MONTH"
  }

  schema = <<EOF
  [
    {
        "name": "permalink",
        "type": "STRING",
        "mode": "NULLABLE",
        "description": "The Permalink"
    },
    {
        "name": "state",
        "type": "STRING",
        "mode": "NULLABLE",
        "description": "State where the head office is located"
    }
  ]
  EOF

}