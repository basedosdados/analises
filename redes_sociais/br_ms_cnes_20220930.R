## github.com/arthurfg
## Libs
library(basedosdados)
library(tidyverse)
library(sf)

## Billing Id
set_billing_id("casebd")

### Importing

## Shapefiles das UFs

query <- "SELECT * FROM `basedosdados.br_geobr_mapas.uf`"
df_uf <- read_sql(query)

## Georreferenciamento dos CAPS

query2 <- "
WITH cnes_geo AS(
  SELECT
  sigla_uf, id_municipio, id_cnes, geometria
  FROM `basedosdados.br_geobr_mapas.estabelecimentos_saude`
),
cnes AS(
  SELECT DISTINCT(id_cnes)
  FROM `basedosdados.br_ms_cnes.estabelecimento` 
  WHERE tipo_unidade = '70' AND ano = 2015 AND mes = 12
)
SELECT t1.*
FROM cnes_geo t1
INNER JOIN cnes t2
  ON t1.id_cnes = t2.id_cnes
"

geo_cnes <- read_sql(query2)

### População Brasileira e total de CAPS (dados mais recentes)

query3 <- "SELECT * FROM `basedosdados.br_ibge_populacao.uf` WHERE ano = 2021"
pop <- read_sql(query3)


query4 <- "
SELECT DISTINCT(id_cnes), sigla_uf
FROM `basedosdados.br_ms_cnes.estabelecimento` 
WHERE tipo_unidade = '70' AND ano = 2021 AND mes = 6
"
cnes <- read_sql(query4)

### Tidying
### String para SF

df_uf <- df_uf %>%
  sf::st_as_sf(wkt = "geometria")

geo_cnes <- geo_cnes %>%
  sf::st_as_sf(wkt = "geometria")

### Número de CAPS/100.000 hab

cnes %>%
  group_by(sigla_uf) %>%
  summarise(total_cnes = n())%>%
  left_join(pop, by = "sigla_uf")%>%
  mutate(pct = (total_cnes/populacao)*100000) %>%
  drop_na() %>%
  left_join(df_uf, by = "sigla_uf") -> pct_df


#### Plot

no_axis <- theme(axis.title=element_blank(),
                 axis.text=element_blank(),
                 axis.ticks=element_blank())

### Georref

geo_cnes %>%
  ggplot() +
  geom_sf(data = df_uf, aes(geometry = geometria), color = "#575757", fill = "#FFFFFF") +
  geom_sf(aes(geometry = geometria), color = "#107019", shape = 20, size = 0.45, alpha = 1) +
  labs(title ="CAPS",subtitle="Brasil, dados de 2015", size=8) +
  theme_minimal() +
  no_axis

## CAPS por 100k hab

ggplot(pct_df) +
  geom_sf(aes(fill = pct, geometry = geometria)) +
  scale_fill_distiller(palette = "Greens", limits=c(0.58,2.4), direction = 1)+
  labs(title ="CAPS por 100.000 hab",subtitle="Brasil, dados de 06/2021", size=8)+
  theme_minimal() +
  no_axis

