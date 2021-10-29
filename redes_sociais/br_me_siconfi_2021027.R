### Diretorio
rm(list = ls())

#setwd("~/basedosdados/visualizacao/siconfi")

### Pacotes

library(basedosdados)
library(tidyverse)
library(geobr)
library(ggeasy)


### Dados

set_billing_id("bd")

df_receita = basedosdados::read_sql(
"  SELECT
  sigla_uf,
  id_municipio,
  valor AS receitas_orcamentarias
  FROM
  `basedosdados.br_me_siconfi.municipio_receitas_orcamentarias`
  WHERE
  ano = 2020
  AND conta_bd = 'Receitas Orçamentárias'
  AND estagio_bd = 'Receitas Brutas Realizadas'
  AND sigla_uf = 'BA'"
  )


df_despesa = basedosdados::read_sql(
"  SELECT
  sigla_uf,
  id_municipio,
  valor AS despesas_orcamentarias
  FROM
  `basedosdados.br_me_siconfi.municipio_despesas_orcamentarias`
  WHERE
  ano = 2020
  AND conta_bd = 'Despesas Orçamentárias'
  AND estagio_bd = 'Despesas Empenhadas'
  AND sigla_uf = 'BA'"
)


#### Tratamento 

df_merge = merge(df_receita, df_despesa, by = c('sigla_uf', 'id_municipio')) %>% 
  mutate(valor = receitas_orcamentarias - despesas_orcamentarias) 

df_merge$id_municipio = as.integer(df_merge$id_municipio)


bbmp = geobr::read_municipality(code_muni = 29, year = 2020) %>% 
  select(code_muni, name_muni, abbrev_state, geom) %>% 
  rename(id_municipio = code_muni, municipio = name_muni, sigla_uf = abbrev_state) %>% 
  select(id_municipio, sigla_uf, municipio, geom)

bbmp$id_municipio = as.integer(bbmp$id_municipio)


df_plot = left_join(bbmp, df_merge,  by = c('sigla_uf', 'id_municipio')) %>% 
  select(id_municipio, sigla_uf, municipio, receitas_orcamentarias, despesas_orcamentarias,
         valor, geom)


df_plot[is.na(df_plot)] <- "NA"


for ( i in 1:length(df_plot$dummy)) {
  if(df_plot$valor[i] == "NA") {
    df_plot$dummy[i] = 0
  } 
  else if(df_plot$valor[i] == 0) {
    df_plot$dummy[i] = -2  
  }
  else if(df_plot$valor[i] > 0) {
    df_plot$dummy[i] = 2  
  }
  
  else {
    df_plot$dummy[i] = 1
  }
  
}

df_plot$dummy = as.character(df_plot$dummy)

#### Plot 

ggplot() +
  geom_sf(data = df_plot, aes(fill = dummy), color = '#1C1C1C', size = 0) +
  labs(title="Saldo Orçamentário dos Munícipios Baianos em 2020",
       caption='Fonte: Siconfi', 
       size=8) +
  scale_fill_manual(values = c("#D3D3D3", "#2B8C4D", "#004529"), 
                      name = "", 
                      labels = c("Não Declarado", "Déficit", "Superávit"),
                      guide = guide_legend(reverse = TRUE)) +
  theme_void()+
  theme(legend.text = element_text(size = 10),
        plot.title = element_text(face = "bold", size = 14)) +
 
  easy_center_title()



  