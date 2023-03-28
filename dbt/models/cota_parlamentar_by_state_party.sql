{{ config(materialized='view') }}

select
    sgUF as state,
    sgPartido as party,
    coalesce(vlrRestituicao, 0) restitution_value,
    coalesce(vlrLiquido, 0) net_value,
    datEmissao issue_date,
    coalesce(txtDescricao, "") bill_description,

from 
    {{ source('staging', 'cota_parlamentar_raw') }}
where 
    sgPartido is not null 
    and sgUF is not null
    and datEmissao is not null
group by sgUF, sgPartido