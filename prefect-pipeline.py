# TODOs
# get the data from source (csv)
# load data into big query as is (raw data)
# from dbt, clean and aggregate the data
# load again, not as "golden layer"
# use this data to plot graphs in looker studio

from prefect import flow, task
import pandas as pd
from prefect_gcp import GcpCredentials

@task(log_prints=True)
def gather_data(year: int):
    filename = "Ano-{year}.csv.zip"
    df = pd.read_csv(f"https://www.camara.leg.br/cotas/{filename}", compression="zip", sep=";")
    return df

@flow(log_prints=True)
def load_into_bq(df: pd.DataFrame, table, gcs_block, project_id):
    block = GcpCredentials.load(gcs_block)

    df.to_gbq(
        destination_table=table,
        project_id=project_id,
        credentials=block.get_credentials_from_service_account(),
        chunksize=500_000,
        if_exists="append"
    )
    print(f"Data loaded to big query, table: {table}")

@flow()
def load_data():
    load_into_bq(gather_data(2017))
    print("End of flow!")
