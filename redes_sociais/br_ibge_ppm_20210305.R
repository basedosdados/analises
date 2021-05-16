## Diretório:

setwd("~/basedosdados")

## Pacotes

library(bigrquery)
library(ggplot2)
library(ggthemes)
library(gganimate)
library(dplyr)
library(xlsx)
library(scales)
library(ggeasy)
library(extrafont)

## Se for a primeira vez utilizando o pacote 'extrafont', rodar codigo abaixo:

font_import()
loadfonts()

## Puxar dados da BD

project_id = "mahallla"

ppm_query = "with origem_animal as 
(SELECT ano, SUM(producao) as producao
from `basedosdados.br_ibge_ppm.producao_origem_animal`
where tipo_produto = 'Leite (Mil litros)'
GROUP BY (ano))
SELECT t1.ano, producao, SUM(vacas_ordenhadas) as vacas_ordenhadas
from origem_animal t1
JOIN `basedosdados.br_ibge_ppm.producao_pecuaria` t2
ON t1.ano = t2.ano
GROUP BY (ano), producao"

ppm_download = bq_table_download(bq_project_query(project_id, ppm_query))

## Plot

ppm_plot = ggplot(ppm_download, aes(x= ano))+
  geom_line(aes(y = producao, color = "Produção de leite"), size=1.6)+
  geom_line(aes(y = vacas_ordenhadas, color = "Número de Vacas Ordenhadas"), size=1.6)+
  labs(x="",
       y = "",
       title = "Número de Vacas Ordenhadas x Produção de Leite (1974-2019)",
       caption = "Fonte: Base dos Dados, IBGE")+
  scale_color_manual(name = "",
                     values = c("#4d7d1a", "#1e88e5"),
                     labels = c("Número de Vacas Ordenhadas", "Produção de leite"))+
  scale_y_continuous(labels = scales::number_format())+
  theme_light()+
  theme(legend.position = "top", 
        axis.text = element_text(family = "Montserrat"),
        legend.text = element_text(family = "Montserrat", face = "bold", size = 11),
        plot.title = element_text(family = "Montserrat", face = "bold", size = 14))+
  easy_center_title()+
  transition_reveal(along = ano)

ppm = animate(ppm_plot, height = 600, width = 1250, res = 100, duration = 4.8)

save_animation(animation = ppm, file = "ppm_final.gif")

## Caso queira exportar a base

write.csv(ppm_download, "output_ppm.csv")



