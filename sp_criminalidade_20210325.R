# bibliotecas
library(tidyverse)
library(DBI)
library(bigrquery)
library(geobr)
library(RColorBrewer)

#mapa de são paulo
mapa <- geobr::read_municipality("SP")%>%
  transmute(id_municipio = code_muni, geom)

#criminalidade em são paulo
bq_auth(path = "chavebigquery/My Project 55562-2deeaad41d85.json")
id_projeto <- "double-voice-305816"

con <- dbConnect(
  bigrquery::bigquery(),
  billing = id_projeto,
  project = "basedosdados"
)

query <- 'SELECT id_municipio, ano, mes, total_de_inqueritos_policiais_instaurados
FROM `basedosdados.br_sp_gov_ssp.produtividade_policial` 
WHERE ano = 2021 AND mes = 1'
base_inqueritos1 <- dbGetQuery(con, query)

query2 <- 'SELECT id_municipio, SUM (total_de_estupro) AS total_de_estupro
FROM `basedosdados.br_sp_gov_ssp.ocorrencias_registradas` 
WHERE ano = 2020
GROUP BY id_municipio'
base_estupro <- dbGetQuery(con, query2)

query2_complementar <- 'SELECT id_municipio, populacao
FROM `basedosdados.br_ibge_populacao.municipios`
WHERE ano = 2020'
base_populacao <- dbGetQuery(con, query2_complementar)

base_inqueritos<- base_inqueritos1%>%
  left_join(base_populacao, by = "id_municipio")

#juntando e criando o mapa
basepramapa<- mapa%>%
  inner_join(base_inqueritos, by = 'id_municipio')%>%
  mutate(inqueritospcapita = (total_de_inqueritos_policiais_instaurados/populacao)*100000, 
         grupos_inqueritos = cut_width(inqueritospcapita, width = 100, boundary = 0))

basepramapa2<- base_estupro%>%
  left_join(base_populacao, by = 'id_municipio')

basepramapa2f <- mapa%>%
  inner_join(basepramapa2, by = 'id_municipio')%>%
               mutate(estupro_por_100hab = (total_de_estupro/populacao)*100000,
                      grupo_estupro = cut_width(estupro_por_100hab, width = 25, boundary = 0))

# VISUALIZACOES E MAPAS -------------------------------------------------

#base de estupro

rank_estupro <- basepramapa2f%>%
  top_n(n = 100, wt= estupro_por_100hab)%>%
  mutate(minuscula = case_when(populacao<10000 ~ "Menos de 10 mil habitantes",
                               populacao> 10000 & populacao<25000 ~ "Entre 10 e 25 mil habitantes",
                               populacao>25000 & populacao<100000 ~ "Entre 25 e 100 mil habitantes",
                               populacao>100000 ~ "Mais de cem mil habitantes"))

teste<- tibble(taxa = rank_estupro$estupro_por_100hab,
       pop = rank_estupro$populacao)

rio::export(teste, "~/Documentos/bdmais/bases_prontas/rankestupro.csv")

# mapa 1 ---------------------------
ggplot() + geom_sf(data=basepramapa , size= .05, 
                   show.legend = F) + geom_sf(data=basepramapa, aes(fill =grupos_inqueritos), lwd = 0, 
                                              color = "grey34")+ 
  theme_void() + theme( legend.title = element_text(family = "Montserrat", face = "bold", size = 14),
         legend.text = element_text(family = "Montserrat", face = "bold", size = 14),
         plot.title = element_text(family = "Montserrat", face = "bold", size = 14))+
   scale_fill_manual(name = "Número de Inquéritos a cada 100 mil hab",
                                 label= c("Menos de 100", "de 100 a 200","de 200 a 300","Mais de 300",
                                          "Valores ausentes na base original"),
                                   values= brewer.pal(n = 4, name = "Reds"),
                     na.value = "grey")
# mapa2 -----------------------
ggplot() + geom_sf(data=basepramapa2f , size= .15, 
                   show.legend = F) + geom_sf(data=basepramapa2f, aes(fill =grupo_estupro), 
                                              color = "black", lwd = 0)+ 
  theme_void() + theme( legend.title = element_text(family = "Montserrat", face = "bold", size = 14),
                        legend.text = element_text(family = "Montserrat", face = "bold", size = 14),
                        plot.title = element_text(family = "Montserrat", face = "bold", size = 14))+
  scale_fill_manual(name = "Casos de Estupro por 100 mil hab.",
                    label= c("Menos de 25 casos", "de 25 a 75 casos","de 75 a 125 casos","de 125 a 150 casos", "de 150 a 175 casos",
                             "de 175 a 200 casos", "Mais de 200 casos"),
                    values=  brewer.pal(n = 7, name = "Reds"),
                    na.value = "black")
   

