# Análises BD+
Repositório de códigos simples e replicáveis das análises publicadas. 

## Catálogo 🗂

| Análise | Código | Link | Data de publicação | 
| ------- | ------ | ---- | ------------------ |
| Evolução do funcionalismo público | `/br_vinculos_rais_20210212.R` | https://twitter.com/basedosdados/status/1359995324388044804 | 2021-02-12 |
| Desmatamento nos municípios da Amazônia Legal | [br_municipios_desmatamento_20210209.sql](/br_municipios_desmatamento_20210209.sql) | https://twitter.com/basedosdados/status/1359243671351222281 | 2021-02-09 |
| Número de Vacas Ordenhadas x Produção de Leite | [br_ibge_ppm_20210305.R](/br_ibge_ppm_20210305.R) | - | 2021-00-00 |
| Tabela de nomeações e exonerações do governo federal | [br_dou_nomeacoes_exoneracoes_20210320.sql](/br_dou_nomeacoes_exoneracoes_20210320.sql) | <https://youtu.be/5gbhj-8PWLg> | 2021-03-20 |
| Número de MPs e Decretos por mês e menções a cloroquina no DOU | [br_dou_exemplos_20210320.ipynb](/br_dou_exemplos_20210320.ipynb) | <https://youtu.be/5gbhj-8PWLg> | 2021-03-20 | 
| IDEB x PIB per capita nas capitais brasileiras | [br_capitais_ideb_pib](/br_capitais_ideb_pib.sql) | https://twitter.com/basedosdados/status/1369425500154834944 | 2021-03-09 |
| Indicadores Educacionais | [br_inep_indicadores_educacionais](/br_inep_indicadores_educacionais.sql) |                   | 2021-03-30 |
## Como adicionar nova análise

1. Subir o código direto na raiz do repo com a seguinte nomenclatura: `<abrangencia>_<tema>_<AAAAMMDD>.[sql|py|...]` (ex: `br_municipios_desmatamento_20210209.sql`)
2. Adicionar no README uma nova linha na tabela do Catálogo (em Código, colocar o `/<nome_do_arquivo>` para redirecionar)

