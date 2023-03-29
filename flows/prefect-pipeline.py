from prefect import flow, task
import pandas as pd
from prefect_gcp import GcpCredentials
import os


# @task(log_prints=True)
# def check_connection_block(block_name):
#     block = GcpCredentials.load(block_name)
#     if not block:
#         print(f"Saving block name {block_name}")
#         GcpCredentials(service_account_file=os.environ["JSON_CREDENTIALS"])\
#             .save(block_name)

@task(log_prints=True)
def gather_data(year: int):
    filename = f"Ano-{year}.csv.zip"
    file_url = f"https://www.camara.leg.br/cotas/{filename}"
    print(f"Reading file {file_url}")
    df = pd.read_csv(file_url, compression="zip", sep=";")
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
        table_schema=None # will infer schema
    )
    print(f"Data loaded to big query, table: {table}")

# TODO: improve the way we send the parameters, hide sensitive content
@flow()
def load_data():
    credentials_block_name = "gcs-credentials"
    #check_connection_block(credentials_block_name)
    for year in range(2009, 2018):
        print(f"Collecting and saving data from {year}")
        load_into_bq(gather_data(year), "cota_parlamentar_ds.cota_parlamentar_raw", credentials_block_name, "dtc-de-375519")

    print("End of flow!")
