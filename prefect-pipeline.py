# TODOs
# get the data from source (csv)
# load data into big query as is (raw data)
# from dbt, clean and aggregate the data
# load again, not as "golden layer"
# use this data to plot graphs in looker studio

from prefect import flow, task
from prefect_gcp.cloud_storage import GcsBucket
from random import randint
from prefect.tasks import task_input_hash
from datetime import timedelta
import os

@task(log_prints=True)
def gather_data():
    pass

@flow(log_prints=True)
def load_into_bq():
    pass

@flow()
def load_data():
    print("Loading data from source to big query")
    pass
