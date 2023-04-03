# this file was used to run on a docker block in Prefect
FROM prefecthq/prefect:2.8-python3.8-conda

RUN apt update

COPY requirements.txt .
RUN pip install -r requirements.txt --trusted-host pypi.python.org --no-cache-dir
