# DataTalks.Club final project

This project will cover following topics:
- Terraform
- Prefect
- Google BigQuery
- Google Cloud Storage
- DBT
- Google Compute Engine
- Docker
- Github Actions
- Github Secrets

## Useful links
- Official zoomcamp repository from DataTalks.Club: [here](https://github.com/DataTalksClub/data-engineering-zoomcamp);   
- Dataset that was used on this project can be found [here](https://www2.camara.leg.br/transparencia/cota-para-exercicio-da-atividade-parlamentar/dados-abertos-cota-parlamentar);   
- Prefect official Dockerfile can be found [here](https://github.com/PrefectHQ/prefect/blob/main/Dockerfile);   
- Review criteria for this project can be found [here](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/week_7_project/README.md#peer-review-criteria)

## Problem statement
Brazil is a beautiful country, filled with countless forests, beaches, waterfalls, etc. Also a place with corruption, a lot of it! In all layers of society! The most dangerous and lethal are the ones in power (not a surprise, right?). This project aims to gather official data from parliamentary quota from years 2013 to 2017 and plot them in a manner that we (as taxes payers) can analyze and check how and by whom our money is spend.


## Architecture overview (diagram):
![Architecture overview](./assets/architecture_v1.png "Architecture overview - v.1")


# Reproducing:
In order to prepare the environment for the pipelines that will be executed, you have to setup beforehand:   
1. Github environment variables. They are: `GCP_PROJECT_ID`, `GCP_SERVICE_ACCOUNT` and `PVT_SSH_KEY`. They will be used along the project for the tasks that require an authentication or so;
2. Manually create a bucket named `terraform-tfstate-dtc-de-project`. This is where `tfstate` file will be stored;

All prepared, now we can dive into pipelines settings.

## Prefect pipeline (collecting data)

After running terraform `apply` for the very first time, you already have all infrastructure you need to run the pipelines, including partitioned and clustered BigQuery tables.
Here are some lines you need to run to make prefect ready to use.

Navigate to project folder and create `.env` file there. Github repository is already cloned within VM if you informed your `PVT_SSH_KEY` correctly. Here is a **template** for `.env` file:
```
POSTGRES_DB="prefect_db"
POSTGRES_USER="prefect-user"
POSTGRES_PASSWORD="prefect-password"
PREFECT_API_URL=http://172.17.0.1:4200/api
DB_CONNECTION_URL="postgresql+asyncpg://prefect-user:prefect-password@postgres:5432/prefect_db"
PROJECT_ID="your-gcp-project-id"
```

Then:
```
$ docker compose up -d --build
```

Copy the following files to your `orion` container. Replace `<orion-container>` with the correct value:
```
export ORION_CONTAINER=<orion-container>
docker cp ./flows/ $ORION_CONTAINER:/opt/prefect
docker cp ~/default-sa.json $ORION_CONTAINER:/opt/prefect
docker exec -it $ORION_CONTAINER /bin/bash
```

Register the GCP Credentials block in Prefect:
```
export JSON_CREDENTIALS=/opt/prefect/default-sa.json
prefect block register -f ./flows/gcp-credentials-block.py
```


**You're done!!** You can run the prefect pipeline with the following commands:
```
prefect deployment build ./flows/prefect-pipeline.py:load_data -n "Load raw data from camara.leg.br to BigQuery dataset"
prefect deployment apply ./load_data-deployment.yaml
prefect deployment run "load-data/Load raw data from camara.leg.br to BigQuery dataset"
prefect agent start -q 'default'
```

After some minutes you will see that the workload executed successfully by the Prefect Agent. The output message will be something similar to this:
```
20:04:53.395 | INFO    | prefect.infrastructure.process - Process 'fragrant-collie' exited cleanly.
```

Done, all raw data is already in BigTable. Now we need to run cleaning steps.

## DBT Pipeline (Cleaning Data)

We are using dbt cloud as data processing tool. Said that, you must previously create your dbt cloud account, setup up a connection to BigQuery and configure github to sync this repo with dbt cloud. 
Also, don't forget configure a Project Subdirectory to reference `/dbt`, once it is **where the dbt files are located**.

After configuring the environment, you just need to run the following dbt command. This command will create new tables in BigQuery, the ones we are going to use as data source to our dashboard(s).

```
$ dbt build --full-refresh --select +cota_parlamentar_by_state_party_date
```

Done, all the clean and aggregated data is available to you in BigQuery.

## Visualizing (Looker Studio)

The table used to feed the dashboard was aggregated by `state`, `party` and `issue_date`, as you can observe in dbt queries.

You can visualize the dashboard that was created navigating to [this link](https://lookerstudio.google.com/reporting/3b9bb23d-e4d6-4ce7-85a6-79611c327fc6).

A print screen of the final dashboard:
![Parliamentary Financial Quota - Brazil (2013 - 2017)
](./assets/parlamentary_quotas.jpg "Parliamentary Financial Quota - Brazil (2013 - 2017)")

---

It also important to point that the dashboard created may not be accurate as it should, since this project was build focused to practice my Data Engineer skills specifically. The dashboard is likely a manner to show the outcome of the data pipeline itself, not the project's goal.


Thank you for the dedicated time in my project,   
Eliton
