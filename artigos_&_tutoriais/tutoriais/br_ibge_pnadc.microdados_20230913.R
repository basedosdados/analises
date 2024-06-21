#Pergunta que me guia:
#Quantas pessoas sabiam ler e escrever por UF no Brasil no 1º Trimestre de 2023?

#Código escrito por Gustavo Alcântara
#Analista de Dados na Base dos Dados
#Esse código apresenta uma possibilidade de 
#utilizar os microdados da PNAD-C a partir 
#do pacote da Base dos Dados.
#No final, é apresentado uma comparação com o pacote PNAD-C
#para verificar se os valores coincidem. 
#Atente-se que retirei os NAS na análise com os dados da Base dos Dados.

#1º Passo:
#Limpar o Ambiente

rm(list=ls())
graphics.off()
gc(reset = TRUE)

#2º Passo:
#Chame essas bibliotecas
library(tidyverse) #Para Limpeza, caso necessário
library(basedosdados) #Para importar os microdados da PNAD-C
library(survey) #Para expandir a amostra 
library(srvyr) #Para expandir a amostra

#3º Passo
#Defina seu billing_id
basedosdados::set_billing_id(
  'seu-billing-id'
)

#4º Passo
#É necessário baixar o dicionário inicialmente
#para verificar os valores nas variáveis categóricas
dicionario <- basedosdados::read_sql(
  "SELECT *  
    FROM `basedosdados.br_ibge_pnadc.dicionario`
  WHERE id_tabela = 'microdados' AND
  (nome_coluna ='V2007' OR
    nome_coluna = 'V2010' OR
    nome_coluna = 'V3001')"
)

#5º Passo
#Acesso aos microdados
df <- basedosdados::read_sql(
  "SELECT 
  id_domicilio,
  sigla_uf,
  V1016, 
  V1022,
  V1023,
  V2007,
  V2009,
  V2010,
  V3001,
  V1028,
  V1028001
  FROM `basedosdados.br_ibge_pnadc.microdados` 
  WHERE trimestre = 1 AND ano = 2023"  
)

#Esse mutate serve para atribuir cada pessoa e posteriormente
#fazer a contagem
df <- df |>
  dplyr::mutate(id = 1)

#Aqui é onde faremos, através do svrepdesign() a expansão da amostra
pnadc_boot <- svrepdesign(data = df, 
                          type = "bootstrap" , 
                          weights = ~V1028 ,
                          repweights = "^V1028[0-9]{3}" , 
                          mse = TRUE )

#Verifique a Classe
class(pnadc_boot)

#Atribua o objeto como um survey
pnad <- as_survey(pnadc_boot)

#Limpeza dos dados
pnad |>
  mutate(sexo = ifelse(V2007 == 1, "Homem", "Mulher"),
         raca = case_when(
           V2010 == 1 ~ "Branca",
           V2010 == 2 ~ "Preta",
           V2010 == 3 ~ "Amarela",
           V2010 == 4 ~ "Parda",
           V2010 == 5 ~ "Indígena",
           V2010 == 9 ~ "Ignorado"
         ),
         ler_escrever = case_when(
           V3001 == 1 ~'Sim',
           V3001 ==2~'Não'
         )) |>
  filter(!is.na(ler_escrever)) %>%
  group_by(sexo, raca, ler_escrever) %>%
  summarise(total = survey_total(id, na.rm = TRUE)) |>
  mutate(porcentagem = total / sum(total) * 100) |>
  arrange(factor(ler_escrever, levels = c("Não", "Sim")), 
          desc(porcentagem)) |>
  print(n=1000)

#Essa Amostra conta com +/- 200 milhões de pessoas 
#porque retirei os N.As. 
#Se quiser, fique à vontade para fazer a comparação 
#com o código abaixo utilizando o pacote PNADC. 

#Selecione as variáveis
variaveis <- c('UF', 'V1016', 'V1022', 'V1023','V2007','V2009','V2010','V3001')

#Obtenha o Dataframe
q <- get_pnadc(year = 2023, quarter = 1, vars = variaveis)

#Verifique a Classe
class(q)

#Veja o total
svytotal(x=~UF, design = q, na.rm=TRUE)
