library(bit64)
library(tidyverse)
library(basedosdados)

# Salvando o projeto do Google Cloud - caso não tenha um, ao rodar pela
# primeira vez as funções do pacote irão aparecer instruções de como
# criar o seu. Veja mais aqui: https://basedosdados.github.io/mais/access_data_local/#criando-um-projeto-no-google-cloud
basedosdados::set_billing_id("workshop-basedosdados")

# Funções do pacote basedosdados:

# Permite carregar os dados de uma tabela da BD direto no R em formato tibble
read_sql(
  "SELECT * FROM `basedosdados.br_inep_ideb.escola`", 
  page_size = 100000)

# Permite fazer o download dos dados num arquivo CSV
download(
  "SELECT * FROM `basedosdados.br_inep_ideb.escola`",
  path = "data/ideb.csv",
  page_size = 100000)


# Usando map/reduce para puxar dados de indicadores socioeconômicos e
# juntar as tabelas pelas colunas semelhantes
(tibble(
  query = c(
    "SELECT * FROM `basedosdados.br_inep_ideb.escola`",
    "SELECT ana.id_municipio, ana.indice_sem_atend
     FROM `basedosdados.br_ana_atlas_esgotos.municipio` as ana",
    "SELECT * FROM `basedosdados.br_ibge_pib.municipio`")) %>%
  mutate(resultados = map(query, read_sql, page_size = 100000)) ->
  queries)

(queries %>%
  pull(resultados) %>%
  reduce(left_join) ->
  painel)

# Visualizações pedidas no workshop:

# Média do IDEB nacional ao longo dos anos
painel %>%
  filter(!is.na(ideb), ano > 2004) %>%
  mutate(across(where(is.integer64), as.integer)) %>%
  group_by(ano) %>% 
  summarise(media_ideb = mean(ideb, na.rm = TRUE)) %>%
  ggplot(aes(x = ano, y = media_ideb)) +
  geom_line(size = 1.2) +
  theme_minimal() +
  labs(
    x = "Ano",
    y = "Média de Ideb nacional",
    title = "OLHA SÓ O IDEB TIRADO DO BASE DOS DADOS")

# IDEB médio dos municípios por percentual de descobertura de esgoto
painel %>%
  mutate(across(where(is.integer64), as.integer)) %>%
  filter(ano == 2013) %>%
  group_by(id_municipio, rede) %>%
  summarise(
    rede = rede,
    descobertura = indice_sem_atend,
    ideb_medio = mean(ideb, na.rm = TRUE),
    .groups = "drop") %>%
  distinct(id_municipio, rede, .keep_all = TRUE) %>%
  ggplot(aes(x = descobertura, y = ideb_medio, color = rede)) +
  geom_point() +
  labs(
    x = "Descobertura de esgoto",
    y = "Ideb Médio do município",
    title = "ESGOTO TRATADO É BOM DEMAIS") +
  theme_minimal() +
  geom_smooth(method = "lm")