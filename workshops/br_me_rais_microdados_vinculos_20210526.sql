WITH vinculos_acre as (                                   # definindo um nome de variável vinculos_acre
    SELECT id_municipio, ano, count(*) numero_de_vinculos # selecionando as colunas municipio, ano, e número de vinculos
    FROM `basedosdados.br_me_rais.microdados_vinculos`    # indicando a origem dos dados
    WHERE sigla_uf = 'AC'                                 # filtrando somente pelo estado do Acre
    GROUP BY ano, id_municipio)                           # organizando por ano e município
SELECT t1.ano,                                            # selecionando o ano, soma de vínculos e soma da população (e renomeando as colunas)...
       SUM(t1.numero_de_vinculos) as numero_de_vinculos,  
       SUM(t2.populacao) as populacao
FROM vinculos_acre t1                                     # ...da tabela vinculos_acre a qual recebeu no nome t1 (tabela1)
JOIN `basedosdados.br_ibge_populacao.municipios` t2       # Agregando com a tabela t2 (população dos municipios em outra base de dados)
ON t1.id_municipio = t2.id_municipio                      # em que o id municipio seja gual
AND t1.ano = t2.ano                                       # e que o ano seja igual
GROUP BY t1.ano                                           # e agrupando por ano.