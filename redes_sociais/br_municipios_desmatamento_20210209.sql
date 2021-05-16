SELECT
  id_municipio,
  municipio_uf,
  max(if(ano = 2019, desmatado,null)) a_2019,
  max(if(ano = 2018, desmatado,null)) a_2018,
  max(if(ano = 2017, desmatado,null)) a_2017,
  max(if(ano = 2016, desmatado,null)) a_2016,
  max(if(ano = 2015, desmatado,null)) a_2015,
  max(if(ano = 2014, desmatado,null)) a_2014,
  max(if(ano = 2013, desmatado,null)) a_2013,
  max(if(ano = 2012, desmatado,null)) a_2012,
  max(if(ano = 2011, desmatado,null)) a_2011,
  max(if(ano = 2010, desmatado,null)) a_2010,
FROM
  `basedosdados.br_inpe_prodes.desmatamento_municipios` t1
JOIN (
  SELECT
    DISTINCT id_municipio AS id,
    CONCAT(municipio, "/", sigla_uf) municipio_uf
  FROM
    `basedosdados.br_bd_diretorios_brasil.municipio` ) t2
ON
  t1.id_municipio = t2.id
GROUP BY id_municipio, municipio_uf
ORDER BY a_2019 DESC
LIMIT 10;

#A partir da base gerada foi construído um gráfico no Flourish: https://public.flourish.studio/visualisation/5203982/