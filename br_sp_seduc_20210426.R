# bibliotecas
library(tidyverse)
library(DBI)
library(bigrquery)
library(geobr)
library(RColorBrewer)
library(basedosdados)

#mapa de são paulo
mapa <- geobr::read_municipality("SP")%>%
  transmute(id_municipio = code_muni, geom)


# pegando valores da SEDUC pelo pacote basedosdados
nota_muni <- basedosdados::read_sql('SELECT id_municipio, AVG(nota_idesp_em) as nota_em
                                    FROM `basedosdados-dev.br_sp_seduc_idesp.escola` 
                                    WHERE ano = 2019 GROUP BY id_municipio', 
                                    "double-voice-305816")%>%
  mutate(id_municipio = as.double(id_municipio))

# base final

basepronta <- nota_muni%>%
  left_join(mapa, by = "id_municipio")%>%
  mutate(grupo = case_when(nota_em < 2 ~ "A",
                           nota_em >= 2 & nota_em <3 ~ "B",
                           nota_em >= 3 & nota_em < 4 ~ "C",
                           nota_em >= 4 & nota_em < 5 ~ "D",
                           nota_em >= 5 ~ "E"))

#plot

ggplot(data = basepronta, aes(geometry = geom)) + geom_sf(data=basepronta, aes(fill = grupo), 
                                              color = "grey34", size= .05)+ 
  theme_void() + theme( legend.title = element_text(family = "Montserrat", face = "bold", size = 14),
                        legend.text = element_text(family = "Montserrat", face = "bold", size = 14),
                        plot.title = element_text(family = "Montserrat", face = "bold", size = 14))+
scale_fill_manual(name = "Nota Média do IDESP",
                  label= c("Menor que 2", "Entre 2 e 3","Entre 3 e 4", "Entre 4 e 5", "Maior que 5"),
                  values= brewer.pal(n = 5, name = "OrRd"),
                    na.value = "grey")


# 2 scatter de abandono e indice 

setwd("/home/matheus/Documentos")
base2 <- read_sql('SELECT fluxo.ano, fluxo.id_escola_sp, inse.nivel_socio_economico, fluxo.prop_abandono_em
FROM `basedosdados-dev.br_sp_seduc_inse.escola` as inse
INNER JOIN `basedosdados-dev.br_sp_seduc_fluxo_escolar.escola` as fluxo ON fluxo.id_escola_sp = inse.id_escola_sp
WHERE fluxo.ano = 2019 and fluxo.id_municipio = 3550308',
         "double-voice-305816")%>%
  mutate(quartil = case_when(nivel_socio_economico < 3.3 ~ 'rico',
                             nivel_socio_economico>= 3.3 & nivel_socio_economico < 4.35 ~ 'quasirico',
                             nivel_socio_economico >= 4.35 & nivel_socio_economico < 5.1 ~ 'pobre',
                             nivel_socio_economico >= 5.1 ~ 'muitopobre'))%>%
  group_by(quartil)%>%
  summarise(media = mean(prop_abandono_em))

base2 <- read_sql('SELECT fluxo.ano, fluxo.id_escola_sp, idesp.nota_idesp_ef_finais, fluxo.prop_abandono_em
FROM `basedosdados-dev.br_sp_seduc_idesp.escola` as idesp
INNER JOIN `basedosdados-dev.br_sp_seduc_fluxo_escolar.escola` as fluxo ON fluxo.id_escola_sp = idesp.id_escola_sp
WHERE fluxo.ano = 2019 and fluxo.id_municipio = 3550308',
                  "double-voice-305816")

%>%
  mutate(quartil = case_when(nivel_socio_economico < 3.3 ~ 'rico',
                             nivel_socio_economico>= 3.3 & nivel_socio_economico < 4.35 ~ 'quasirico',
                             nivel_socio_economico >= 4.35 & nivel_socio_economico < 5.1 ~ 'pobre',
                             nivel_socio_economico >= 5.1 ~ 'muitopobre'))%>%
  group_by(quartil)%>%
  summarise(media = mean(nota_idesp_ef_finais))


rio::export(base2, "basetesteseduc.csv")


