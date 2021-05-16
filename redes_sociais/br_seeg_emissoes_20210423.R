#emissoes

# bibliotecas
library(tidyverse)
library(DBI)
library(bigrquery)
library(geobr)
library(RColorBrewer)

bq_auth(path = "chavebigquery/My Project 55562-2deeaad41d85.json")
id_projeto <- "double-voice-305816"

con <- dbConnect(
  bigrquery::bigquery(),
  billing = id_projeto,
  project = "basedosdados"
)

##GRAFICO 1
query <- 'SELECT sigla_uf, ano, SUM(emissao) FROM `basedosdados.br_seeg_emissoes.uf` 
where gas = "CO2e (t) GWP-AR5" 
and ano IN (1971,1972,1973,1974,1975,1976,1977,1978,1979,1980,1981,1980,1982,1983,1984,1985, 1986, 
1987, 1988, 1989, 1990, 1991, 1992, 1993, 1994, 1995
, 1996, 1997, 1998, 1999, 2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010
, 2011, 2012, 2013, 2014, 2015, 2016,2017,2018,2019)
GROUP BY sigla_uf, ano'
base_emissao1 <- dbGetQuery(con, query)

base_emissao_wide <- base_emissao1%>%
  filter(!sigla_uf == "NA")%>%
  pivot_wider(id_cols = c("sigla_uf", "ano"), names_from = "sigla_uf",  values_from = f0_)%>%
  arrange(ano)

##GRAFICO2
query2 <- 'SELECT nivel_1, ano, SUM(emissao) as emissao  FROM `basedosdados.br_seeg_emissoes.uf`
WHERE gas = "CO2e (t) GWP-AR5" 
GROUP BY nivel_1, ano
ORDER BY ano,emissao DESC '
base_emissao2 <- dbGetQuery(con, query2)

base_emissao_wide2 <- base_emissao2%>%
  pivot_wider(id_cols = c("nivel_1", "ano"), names_from = "nivel_1",  values_from = emissao)%>%
  arrange(ano)

## GRAFICO 3 ------------------------------
query3 <- 'SELECT ano, gas, SUM(emissao) as emissao  FROM `basedosdados.br_seeg_emissoes.uf`
GROUP BY ano, gas
ORDER BY ano,emissao DESC  '
base_emissao3 <- dbGetQuery(con, query3)

base_emissao_wide3 <- base_emissao3%>%
  pivot_wider(id_cols = c("gas", "ano"), names_from = "gas",  values_from = emissao)%>%
  arrange(ano)

rio::export(base_emissao_wide3, "baseemissao3.csv")

rio::export(base_emissao_wide2, "baseemissao2.csv")
rio::export(base_emissao_wide, "baseemissao.csv")
