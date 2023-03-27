from prefect_gcp import GcpCredentials
import os

block_name = "gcs-credentials"
print(f"Saving block name {block_name}")
GcpCredentials(service_account_file=os.environ["JSON_CREDENTIALS"]).save(block_name)
