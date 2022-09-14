#github: arthurfg

### Importando as Libs

library(tidyverse)
library(basedosdados)
library(sf)
library(geobr)
library(readr)

### Importando os dados 

# Indicador de desigualdade

indicador_desigualdade <- read_csv("~/Documents/BackupR/indicador_desigualdade.csv")

df <- indicador_desigualdade %>%
  rename(valor = `0`) %>%
  drop_na() %>%
  filter(valor < 1) ## Breve limpeza nos dados

# Dados geográficos do `geobr`

geo <- read_state(showProgress = FALSE) %>%
  rename(sigla_uf = abbrev_state) ## Renomeando para o join

# Fazendo o Join das duas tabelas

df <- df %>%
  left_join(geo, by = "sigla_uf")

### Plot

ggplot(df) +
  geom_sf(aes(fill = valor, geometry = geom)) +
  scale_fill_distiller(palette = "Greens", limits=c(0.668, 1), direction = 1)+
  labs(fill = "Valor") +
  theme_classic()

 