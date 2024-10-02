## Selecionando dados de despesas de candidatos da cidade de campinas para as eleições 2024

SELECT
    dados.numero_candidato as numero_candidato,
    dados.cpf_candidato as cpf_candidato,
    dados.sequencial_candidato as sequencial_candidato,
    dados.id_candidato_bd as id_candidato_bd,
    dados.nome_candidato as nome_candidato,
    dados.numero_partido as numero_partido,
    dados.sigla_partido as sigla_partido,
    dados.nome_partido as nome_partido,
    dados.cargo as cargo,
    dados.sequencial_despesa as sequencial_despesa,
    dados.data_despesa as data_despesa,
    dados.tipo_despesa as tipo_despesa,
    dados.descricao_despesa as descricao_despesa,
    dados.origem_despesa as origem_despesa,
    dados.valor_despesa as valor_despesa,
    dados.tipo_prestacao_contas as tipo_prestacao_contas,
    dados.data_prestacao_contas as data_prestacao_contas,
    dados.sequencial_prestador_contas as sequencial_prestador_contas,
    dados.cnpj_prestador_contas as cnpj_prestador_contas,
    dados.fonte_recurso as fonte_recurso,
    dados.cpf_cnpj_fornecedor as cpf_cnpj_fornecedor,
    dados.nome_fornecedor as nome_fornecedor,
    dados.nome_fornecedor_rf as nome_fornecedor_rf,
    dados.cnae_2_fornecedor as cnae_2_fornecedor,
    dados.cnae_2_fornecedor_classe as cnae_2_fornecedor_classe,
    dados.cnae_2_fornecedor_subclasse as cnae_2_fornecedor_subclasse,
    dados.descricao_cnae_2_fornecedor as descricao_cnae_2_fornecedor,
    dados.tipo_fornecedor as tipo_fornecedor
FROM `basedosdados.br_tse_eleicoes.despesas_candidato` AS dados
WHERE ano = 2024 AND cargo = 'prefeito' AND id_municipio = '3509502'
