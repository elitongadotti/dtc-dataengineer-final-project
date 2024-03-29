{{ config(materialized='table',
          partition_by={
            "field": "issue_date",
            "data_type": "datetime",
            "granularity": "month"
          }, 
          cluster_by=["party", "state"]
)}}

select
    state,
    party,
    issue_date,
    round(sum(restitution_value),2) restitution_total,
    round(sum(net_value), 2) net_total
from 
    {{ref('cota_parlamentar_gold')}}
group by state, party, issue_date
