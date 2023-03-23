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


## Reproducing:
Reproducing the steps to run the pipelines are follow:

### Prefect pipeline (collecting data)

After infrastructure creation (will run Terraform code triggered by GitHub Actions), we have to (1) setup Git SSH key, (2) clone this repo, (3) run `docker compose up -d --build`, (4) create a block to store GCP Credentials and navigate to `prefect orion` container.

After that, you must create, deploy and trigger a `prefect deployment` using the 3 commands below:
- `first command`
- `second command`
- `third command`

Then, just start a new `prefect agent` to collect and effective run the flow:   
```
$ prefect agent start -q 'default'
``` 

Done, all the data is already in BigTable. Now we need to run the cleaning process.

### dbt pipeline (cleaning data)
...