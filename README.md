# DataTalks.Club final project

The project will cover following tools:
- Terraform
- Prefect
- Google BigQuery
- Google Cloud Storage
- DBT
- Google Compute Engine
- Docker

Dataset used can be found [here](https://www2.camara.leg.br/transparencia/cota-para-exercicio-da-atividade-parlamentar/dados-abertos-cota-parlamentar). Prefect official Dockerfile [here](https://github.com/PrefectHQ/prefect/blob/main/Dockerfile)

## Architecture overview:
![Architecture overview](./assets/architecture_v1.png "Architecture overview - v.1")


# Reproducing:
In order to run prepare the environment for the pipelines that will be executed, you have to setup beforehand:   
1. Github environment variables - will be used when running Actions (CD pipeline)
2. Enable apis (TODO)

All prepared, now we can dive into pipelines settings.

## Prefect pipeline (collecting data)

After infrastructure creation (will run Terraform code triggered by GitHub Actions), we have to (1) setup Git SSH key, (2) clone this repo, (3) run `docker compose up -d --build`, (4) create a block to store GCP Credentials, (5) create a bucket named `terraform-tfstate-dtc-de-project` to store tf state file, (6) define your `.env` file and navigate to `prefect orion` container.

After that, you must create, deploy and trigger a `prefect deployment` using the 3 commands below:
- `first command`
- `second command`
- `third command`

Then, just start a new `prefect agent` to collect and effective run the flow:   
```
$ prefect agent start -q 'default'
``` 

Done, all the data is already in BigTable. Now we need to run the cleaning process.

## DBT pipeline (cleaning data)

We are using dbt cloud. Said that, you must create your dbt cloud account, setup up a connection to BigQuery and configure github to sync this repo to dbt cloud. 
Also, don't forget configure a Project Subdirectory to reference `/dbt`, once it is **where the dbt files are located**.

After configuring the environment, you just need to run the following dbt command:

```
$ dbt build --full-refresh --select +cota_parlamentar_by_state_party_date
```

## Visualizing (looker studio)

The table used to feed the dashboard was aggregated by `state`, `party` and `issue_date`, as you can observe in dbt queries.

You can visualize the dashboard that was created navigating to [this link](https://lookerstudio.google.com/reporting/3b9bb23d-e4d6-4ce7-85a6-79611c327fc6).

It also important to point that the dashboard created may not be accurate as it should, once this project was build focused to practice my Data Engineer skills specifically. The dashboard is likely a manner to show the outcome of the data pipeline itself, not the project's goal.

