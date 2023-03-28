{{ config(materialized='table') }}

select
    sgUF as state,
    sgPartido as party,
    round(coalesce(vlrRestituicao, 0), 2) restitution_value,
    round(coalesce(vlrLiquido, 0), 2) net_value,
    cast(datEmissao as datetime) as issue_date,
    coalesce(txtDescricao, "") bill_description,

from 
    {{ source('staging', 'cota_parlamentar_raw') }}
where 
    sgPartido is not null 
    and sgUF is not null
    and datEmissao is not null
