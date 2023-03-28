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

# TODO: define a schema here to able me to partition and cluster the table
resource "google_bigquery_table" "cota_parlamentar_raw_data" {
  dataset_id = google_bigquery_dataset.cota_parlamentar_dataset.dataset_id
  table_id   = "cota_parlamentar_raw"

  time_partitioning {
    type = "MONTH"
    #field = "datEmissao"
  }

  #clustering          = ["sgPartido"]
  deletion_protection = false
}

resource "google_bigquery_table" "cota_parlamentar_gold" {
  dataset_id = google_bigquery_dataset.cota_parlamentar_dataset.dataset_id
  table_id   = "cota_parlamentar_gold"

  schema = <<EOF
  [
    {
      "name": "state",
      "type": "STRING"
    },
    {
      "name": "party",
      "type": "STRING"
    },
    {
      "name": "issue_date",
      "type": "DATE"
    },
    {
      "name": "restitution_value",
      "type": "FLOAT"
    },
    {
      "name": "net_value",
      "type": "FLOAT"
    },
    {
      "name": "bill_description",
      "type": "STRING"
    }
  ]
  EOF
}

resource "google_bigquery_table" "cota_parlamentar_by_state_party_date" {
  dataset_id = google_bigquery_dataset.cota_parlamentar_dataset.dataset_id
  table_id   = "cota_parlamentar_by_state_party_date"

  time_partitioning {
    type  = "MONTH"
    field = "issue_date"
  }

  clustering          = ["party", "state"]
  deletion_protection = false

  schema = <<EOF
  [
    {
      "name": "state",
      "type": "STRING"
    },
    {
      "name": "party",
      "type": "STRING"
    },
    {
      "name": "issue_date",
      "type": "DATE"
    },
    {
      "name": "restitution_total",
      "type": "FLOAT"
    },
    {
      "name": "net_total",
      "type": "FLOAT"
    }
  ]
  EOF
}
