from prefect import flow, task
import pandas as pd
from prefect_gcp import GcpCredentials
import numpy as np


@task(log_prints=True)
def gather_data(year: int):
    filename = f"Ano-{year}.csv.zip"
    file_url = f"https://www.camara.leg.br/cotas/{filename}"
    print(f"Reading file {file_url}")
    df = pd.read_csv(file_url, compression="zip", sep=";").fillna("").astype(str)
    double_cols = ["vlrRestituicao", "vlrLiquido"]
    df[double_cols] = df[double_cols].astype(np.double)

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
    
    # currently available years are:
    for year in range(2013, 2018):
        print(f"Collecting and saving data from {year}")
        load_into_bq(gather_data(year), "cota_parlamentar_ds.cota_parlamentar_raw", credentials_block_name, "dtc-de-375519")

    print("End of flow!")
