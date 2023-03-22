resource "google_bigquery_dataset" "cota_parlamentar_dataset" {
  dataset_id    = "cota_parlamentar_ds"
  friendly_name = "cota_parlamentar"
  description   = "Cota Parlamentar dataset"
  location      = local.region
  #   access {
  #     role          = "OWNER"
  #     user_by_email = "emailAddress:dtc-sa@dtc-de-375519.iam.gserviceaccount.com"
  #   }
}

# TODO: set column to partition (datEmissao) and cluster by party (sgPartido)
resource "google_bigquery_table" "cota_parlamentar_raw_data" {
  dataset_id = google_bigquery_dataset.cota_parlamentar_dataset.dataset_id
  table_id   = "cota_parlamentar_raw"

  time_partitioning {
    type = "MONTH"
  }

  #   schema = <<EOF
  #   [
  #     {
  #         "name": "col1",
  #         "type": "STRING",
  #         "mode": "NULLABLE",
  #         "description": "The Permalink"
  #     },
  #     ...
  #   ]
  #   EOF

}