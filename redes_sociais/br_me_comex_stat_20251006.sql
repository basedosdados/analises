--- exportacao e importacao para diferentes classificacoes

select
 ano,
 case
   when cast(substr(id_sh4, 1, 2) as int64) between 1 and 24 then 'Produtos primários (agropecuários)'
   when cast(substr(id_sh4, 1, 2) as int64) between 25 and 27 then 'Produtos primários (minerais/combustíveis)'
   when cast(substr(id_sh4, 1, 2) as int64) between 28 and 40 then 'Manufaturados (químicos e plásticos)'
   when cast(substr(id_sh4, 1, 2) as int64) between 41 and 49 then 'Manufaturados (madeira, papel, couro)'
   when cast(substr(id_sh4, 1, 2) as int64) between 50 and 63 then 'Manufaturados (têxteis e vestuário)'
   when cast(substr(id_sh4, 1, 2) as int64) between 64 and 83 then 'Manufaturados (calçados, metais, produtos de metal)'
   when cast(substr(id_sh4, 1, 2) as int64) between 84 and 90 then 'Manufaturados (máquinas e eletrônicos)'
   when cast(substr(id_sh4, 1, 2) as int64) between 91 and 97 then 'Manufaturados (veículos, aeronaves, outros)'
   else 'Outros'
 end as grupo_produto,
 sum(valor_fob_dolar) as total_exportado
from `basedosdados.br_me_comex_stat.municipio_exportacao` ---mudar para municipio_importacao
where ano = 2024
group by ano, grupo_produto
order by ano, total_exportado desc


--- top 10 maiores importadores do brasil
with exportacoes_2024 as (
 select
   sigla_pais_iso3 as pais,
   sum(valor_fob_dolar) as total_exportado
 from `basedosdados.br_me_comex_stat.municipio_exportacao`
 where ano = 2024
 group by pais
)
select
 pais,
 total_exportado,
 total_exportado / sum(total_exportado) over() * 100 as percentual_sobre_total
from exportacoes_2024
order by total_exportado desc
limit 10


--- principais produtos importados pelos eua
with exportacoes_eua as (
 select
   id_sh4,
   sum(valor_fob_dolar) as total_exportado
 from `basedosdados.br_me_comex_stat.municipio_exportacao`
 where ano = 2024
   and sigla_pais_iso3 = 'USA'
 group by id_sh4
),
dic as (
 select id_sh4, nome_sh4_portugues,
        row_number() over(partition by id_sh4 order by nome_sh4_portugues) as rn
 from `basedosdados.br_bd_diretorios_mundo.sistema_harmonizado`
),
totais as (
 select sum(total_exportado) as total_geral
 from exportacoes_eua
)
select
 e.id_sh4,
 d.nome_sh4_portugues as produto,
 e.total_exportado,
 round(e.total_exportado / t.total_geral * 100, 2) as percentual_sobre_total
from exportacoes_eua e
left join dic d
 on e.id_sh4 = d.id_sh4 and d.rn = 1
cross join totais t
order by e.total_exportado desc
limit 20


--- paises que importam café verde
select
 sigla_pais_iso3 as pais,
 sum(peso_liquido_kg) as total_kg
from `basedosdados.br_me_comex_stat.ncm_exportacao`
where ano = 2024
 and id_ncm = '09011110'
group by pais
order by total_kg desc
