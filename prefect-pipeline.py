from prefect import flow, task
import pandas as pd
from prefect_gcp import GcpCredentials
import os

#@task(log_prints=True)
#def check_connection_block():
#    GcpCredentials(service_account_info=service_account_info).save("BLOCK-NAME-PLACEHOLDER")

@task(log_prints=True)
def gather_data(year: int):
    filename = "Ano-{year}.csv.zip"
    df = pd.read_csv(f"https://www.camara.leg.br/cotas/{filename}", compression="zip", sep=";")
    return df

@task(log_prints=True)
def load_into_bq(df: pd.DataFrame, table, gcs_block, project_id):
    block = GcpCredentials.load(gcs_block)
    print("Loading data to BigQuery...")
    
    df.to_gbq(
        destination_table=table,
        project_id=project_id,
        credentials=block.get_credentials_from_service_account(),
        chunksize=500_000,
        if_exists="append",
        table_schema=None # will infer
    )
    print(f"Data loaded to big query, table: {table}")

# TODO: improve the way we send the parameters, hide sensitive content
@flow()
def load_data():
    load_into_bq(gather_data(2017), "cota_parlamentar_raw", "gcs-credentials", "dtc-de-375519")
    print("End of flow!")
