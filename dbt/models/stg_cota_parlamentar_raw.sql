{{ config(materialized='table') }}

select
    sgUF as state,
    sgPartido as party,
    vlrRestituicao restitution_value,
    vlrLiquido net_value,
    datEmissao issue_date,
    txtDescricao bill_description,

from 
    {{ source('staging', 'cota_parlamentar_raw') }}
where 
    sgPartido is not null 
    and sgUF is not null
    and datEmissao is not null
