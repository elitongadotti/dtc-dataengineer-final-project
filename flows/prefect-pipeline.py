from prefect import flow, task
import pandas as pd
from prefect_gcp import GcpCredentials
from google.cloud import storage
from google.oauth2 import service_account
import os


@task(log_prints=True)
def gather_data(year: int):
    filename = f"Ano-{year}.csv.zip"
    file_url = f"https://www.camara.leg.br/cotas/{filename}"
    print(f"Reading file {file_url}")
    df = pd.read_csv(file_url, compression="zip", sep=";")
    return df

@task(log_prints=True)
def select_cols(df: pd.DataFrame):
    df = df[["cpf", "sgUF", "sgPartido", "txtDescricao", "datEmissao", "vlrLiquido", "vlrRestituicao"]]

    str_cols = df.select_dtypes("object").columns
    double_cols = df.select_dtypes(["float32", "float64"]).columns
    
    df[str_cols] = df[str_cols].fillna("")
    df[double_cols] = df[double_cols].fillna(0)
    df["cpf"] = df["cpf"].astype(int)

    return df


@task(log_prints=True)
def load_to_gcs(credentials_file_path: str, df: pd.DataFrame, bucket_name: str, blob_name: str):
    credentials = service_account.Credentials.from_service_account_file(credentials_file_path)
    bucket = storage.Client(credentials=credentials).bucket(bucket_name)
    blob = bucket.blob(blob_name)
    blob.upload_from_string(df.to_csv(), 'text/csv')


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
        load_into_bq(
            select_cols(
                gather_data(year)
            ), "cota_parlamentar_ds.cota_parlamentar_raw", credentials_block_name, "dtc-de-375519"
        )

    print("End of flow!")
