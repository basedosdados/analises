## Consulta para extrair os dados de perfil dos pacientes com notificação por dengue em Campinas (usar o filtro da última linha para alterar o município) 
  ## Acesse a planilha com os resultados por [aqui](https://docs.google.com/spreadsheets/d/1tD4JP1CK5GTf6IPRqAYw25GzXBitJVw9ATEb0Ncnqzg/edit?usp=sharing)

WITH 
dicionario_tipo_notificacao AS (
    SELECT
        chave AS chave_tipo_notificacao,
        valor AS descricao_tipo_notificacao
    FROM `basedosdados.br_ms_sinan.dicionario`
    WHERE
        TRUE
        AND nome_coluna = 'tipo_notificacao'
        AND id_tabela = 'microdados_dengue'
),
dicionario_sexo_paciente AS (
    SELECT
        chave AS chave_sexo_paciente,
        valor AS descricao_sexo_paciente
    FROM `basedosdados.br_ms_sinan.dicionario`
    WHERE
        TRUE
        AND nome_coluna = 'sexo_paciente'
        AND id_tabela = 'microdados_dengue'
),
dicionario_raca_cor_paciente AS (
    SELECT
        chave AS chave_raca_cor_paciente,
        valor AS descricao_raca_cor_paciente
    FROM `basedosdados.br_ms_sinan.dicionario`
    WHERE
        TRUE
        AND nome_coluna = 'raca_cor_paciente'
        AND id_tabela = 'microdados_dengue'
),
dicionario_escolaridade_paciente AS (
    SELECT
        chave AS chave_escolaridade_paciente,
        valor AS descricao_escolaridade_paciente
    FROM `basedosdados.br_ms_sinan.dicionario`
    WHERE
        TRUE
        AND nome_coluna = 'escolaridade_paciente'
        AND id_tabela = 'microdados_dengue'
),
dicionario_gestante_paciente AS (
    SELECT
        chave AS chave_gestante_paciente,
        valor AS descricao_gestante_paciente
    FROM `basedosdados.br_ms_sinan.dicionario`
    WHERE
        TRUE
        AND nome_coluna = 'gestante_paciente'
        AND id_tabela = 'microdados_dengue'
),
dicionario_possui_doenca_autoimune AS (
    SELECT
        chave AS chave_possui_doenca_autoimune,
        valor AS descricao_possui_doenca_autoimune
    FROM `basedosdados.br_ms_sinan.dicionario`
    WHERE
        TRUE
        AND nome_coluna = 'possui_doenca_autoimune'
        AND id_tabela = 'microdados_dengue'
),
dicionario_possui_diabetes AS (
    SELECT
        chave AS chave_possui_diabetes,
        valor AS descricao_possui_diabetes
    FROM `basedosdados.br_ms_sinan.dicionario`
    WHERE
        TRUE
        AND nome_coluna = 'possui_diabetes'
        AND id_tabela = 'microdados_dengue'
),
dicionario_possui_doencas_hematologicas AS (
    SELECT
        chave AS chave_possui_doencas_hematologicas,
        valor AS descricao_possui_doencas_hematologicas
    FROM `basedosdados.br_ms_sinan.dicionario`
    WHERE
        TRUE
        AND nome_coluna = 'possui_doencas_hematologicas'
        AND id_tabela = 'microdados_dengue'
),
dicionario_possui_hepatopatias AS (
    SELECT
        chave AS chave_possui_hepatopatias,
        valor AS descricao_possui_hepatopatias
    FROM `basedosdados.br_ms_sinan.dicionario`
    WHERE
        TRUE
        AND nome_coluna = 'possui_hepatopatias'
        AND id_tabela = 'microdados_dengue'
),
dicionario_possui_doenca_renal AS (
    SELECT
        chave AS chave_possui_doenca_renal,
        valor AS descricao_possui_doenca_renal
    FROM `basedosdados.br_ms_sinan.dicionario`
    WHERE
        TRUE
        AND nome_coluna = 'possui_doenca_renal'
        AND id_tabela = 'microdados_dengue'
),
dicionario_possui_hipertensao AS (
    SELECT
        chave AS chave_possui_hipertensao,
        valor AS descricao_possui_hipertensao
    FROM `basedosdados.br_ms_sinan.dicionario`
    WHERE
        TRUE
        AND nome_coluna = 'possui_hipertensao'
        AND id_tabela = 'microdados_dengue'
),
dicionario_paciente_vacinado AS (
    SELECT
        chave AS chave_paciente_vacinado,
        valor AS descricao_paciente_vacinado
    FROM `basedosdados.br_ms_sinan.dicionario`
    WHERE
        TRUE
        AND nome_coluna = 'paciente_vacinado'
        AND id_tabela = 'microdados_dengue'
),
dicionario_internacao AS (
    SELECT
        chave AS chave_internacao,
        valor AS descricao_internacao
    FROM `basedosdados.br_ms_sinan.dicionario`
    WHERE
        TRUE
        AND nome_coluna = 'internacao'
        AND id_tabela = 'microdados_dengue'
),
dicionario_doenca_trabalho AS (
    SELECT
        chave AS chave_doenca_trabalho,
        valor AS descricao_doenca_trabalho
    FROM `basedosdados.br_ms_sinan.dicionario`
    WHERE
        TRUE
        AND nome_coluna = 'doenca_trabalho'
        AND id_tabela = 'microdados_dengue'
)
SELECT
    dados.ano as ano,
    descricao_tipo_notificacao AS tipo_notificacao,
    dados.sigla_uf_notificacao AS sigla_uf_notificacao,
    diretorio_sigla_uf_notificacao.nome AS sigla_uf_notificacao_nome,
    dados.id_municipio_notificacao AS id_municipio_notificacao,
    diretorio_id_municipio_notificacao.nome AS id_municipio_notificacao_nome,
    dados.idade_paciente as idade_paciente,
    descricao_sexo_paciente AS sexo_paciente,
    descricao_raca_cor_paciente AS raca_cor_paciente,
    descricao_escolaridade_paciente AS escolaridade_paciente,
    dados.ocupacao_paciente AS ocupacao_paciente,
    diretorio_ocupacao_paciente.descricao AS ocupacao_paciente_descricao,
    diretorio_ocupacao_paciente.descricao_familia AS ocupacao_paciente_descricao_familia,
    diretorio_ocupacao_paciente.descricao_subgrupo AS ocupacao_paciente_descricao_subgrupo,
    diretorio_ocupacao_paciente.descricao_subgrupo_principal AS ocupacao_paciente_descricao_subgrupo_principal,
    diretorio_ocupacao_paciente.descricao_grande_grupo AS ocupacao_paciente_descricao_grande_grupo,
    descricao_gestante_paciente AS gestante_paciente,
    descricao_possui_doenca_autoimune AS possui_doenca_autoimune,
    descricao_possui_diabetes AS possui_diabetes,
    descricao_possui_doencas_hematologicas AS possui_doencas_hematologicas,
    descricao_possui_hepatopatias AS possui_hepatopatias,
    descricao_possui_doenca_renal AS possui_doenca_renal,
    descricao_possui_hipertensao AS possui_hipertensao,
    descricao_paciente_vacinado AS paciente_vacinado,
    descricao_internacao AS internacao,
    descricao_doenca_trabalho AS doenca_trabalho
FROM `basedosdados.br_ms_sinan.microdados_dengue` AS dados
LEFT JOIN `dicionario_tipo_notificacao`
    ON dados.tipo_notificacao = chave_tipo_notificacao
LEFT JOIN (SELECT DISTINCT sigla,nome  FROM `basedosdados.br_bd_diretorios_brasil.uf`) AS diretorio_sigla_uf_notificacao
    ON dados.sigla_uf_notificacao = diretorio_sigla_uf_notificacao.sigla
LEFT JOIN (SELECT DISTINCT id_municipio,nome  FROM `basedosdados.br_bd_diretorios_brasil.municipio`) AS diretorio_id_municipio_notificacao
    ON dados.id_municipio_notificacao = diretorio_id_municipio_notificacao.id_municipio
LEFT JOIN `dicionario_sexo_paciente`
    ON dados.sexo_paciente = chave_sexo_paciente
LEFT JOIN `dicionario_raca_cor_paciente`
    ON dados.raca_cor_paciente = chave_raca_cor_paciente
LEFT JOIN `dicionario_escolaridade_paciente`
    ON dados.escolaridade_paciente = chave_escolaridade_paciente
LEFT JOIN (SELECT DISTINCT cbo_2002,descricao,descricao_familia,descricao_subgrupo,descricao_subgrupo_principal,descricao_grande_grupo  FROM `basedosdados.br_bd_diretorios_brasil.cbo_2002`) AS diretorio_ocupacao_paciente
    ON dados.ocupacao_paciente = diretorio_ocupacao_paciente.cbo_2002
LEFT JOIN `dicionario_gestante_paciente`
    ON dados.gestante_paciente = chave_gestante_paciente
LEFT JOIN `dicionario_possui_doenca_autoimune`
    ON dados.possui_doenca_autoimune = chave_possui_doenca_autoimune
LEFT JOIN `dicionario_possui_diabetes`
    ON dados.possui_diabetes = chave_possui_diabetes
LEFT JOIN `dicionario_possui_doencas_hematologicas`
    ON dados.possui_doencas_hematologicas = chave_possui_doencas_hematologicas
LEFT JOIN `dicionario_possui_hepatopatias`
    ON dados.possui_hepatopatias = chave_possui_hepatopatias
LEFT JOIN `dicionario_possui_doenca_renal`
    ON dados.possui_doenca_renal = chave_possui_doenca_renal
LEFT JOIN `dicionario_possui_hipertensao`
    ON dados.possui_hipertensao = chave_possui_hipertensao
LEFT JOIN `dicionario_paciente_vacinado`
    ON dados.paciente_vacinado = chave_paciente_vacinado
LEFT JOIN `dicionario_internacao`
    ON dados.internacao = chave_internacao
LEFT JOIN `dicionario_doenca_trabalho`
    ON dados.doenca_trabalho = chave_doenca_trabalho

WHERE id_municipio_notificacao = '3509502'
