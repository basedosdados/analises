# Como instalar e acessar os dados:
# https://basedosdados.github.io/mais/access_data_local/

# install.packages("basedosdados")
# install.packages("tidyverse")
library(basedosdados)
library(tidyverse)

set_billing_id("basedosdados")

query <- "SELECT
    pib.id_municipio,
    pop.ano,
    pib.PIB / pop.populacao * 1000 as pib_per_capita
    FROM `basedosdados.br_ibge_pib.municipio` as pib
    JOIN `basedosdados.br_ibge_populacao.municipio` as pop
    ON CAST(pib.id_municipio AS STRING) = pop.id_municipio AND pib.ano = pop.ano"

# Você pode fazer o download no seu computador
# Checando caminho atual: getwd()

data_path <- file.path(getwd(), "/workshops/bd_fgv_sicss_20210621/dados")
data <- download(query, file.path(data_path, "pib_per_capita.csv"))

# Ou carregar o resultado da query no seu ambiente de análise
data <- read_sql(query)

data %>% summarize()