#### BASE DOS DADOS ####
#### Desigualdades de gênero e raça na remuneração ####

# A análise foi feita levando em consideração quatro grupos: homens brancos, mulheres brancas,
# homens negros e mulheres negras. O objetivo é analisar diferenças salariais entre os grupos,
# a partir das médias do rendimento mensal do trabalho.

#### Preparação ####

#### Bibliotecas e demais configurações ####
options(scipen=999) # previne o R de adotar notação científica nos outputs
library(basedosdados)
library(tidyverse)

# Billing ID do BigQuery
basedosdados::set_billing_id('seu-billing-ID')

#### Motivação do limite superior de R$ 10.000 da remuneção para os cálculos de média ####

# Variáveis de redimento podem apresentar distribuições assimétricas com valores extremos
# (por disparidade real ou por erros de computação).
# Para isso podemos utilizar os percentis do salario_mensal como guia: a mediana, o percentil 90 e o percentil 99.
# Isso foi feito para cada ano.

percentil <- basedosdados::read_sql(
  "SELECT
ano,
mediana
FROM (
  SELECT
  ano,
  salario_mensal,
  PERCENTILE_CONT(salario_mensal, 0.5) OVER(PARTITION BY ano) as mediana
  FROM basedosdados.br_me_caged.microdados_movimentacao) 
GROUP BY ano, mediana
")

# A partir disso podemos calcular a média sem os valores extremos. Vimos que para 2023, o percentil 99
# da distribuição foi 9754.1 reais. Ou seja, 99% das pessoas receberem este valor ou menos como salário mensal
# em 2023. Como este foi o valor máximo para todos os anos, parece ser um valor razoável de base do limite superior.

#### Perguntas ####

#### Em média, quanto % os homens recebem a mais que mulheres? ####

# Na primeira consulta selecionamos o ano e mês dos registros, concatenados em formato de data; a média geral do 
# salário mensal e das horas contratuais de trabalho; a frequência de cada um dos grupos; a média de salário
# mensal por grupo. Consideramos os rendimentos de até R$ 10.000,00.

df_count <- basedosdados::read_sql(
  "SELECT
FORMAT_DATETIME('%y-%m-%d', DATETIME(CONCAT(ano, '-', mes, '-01'))) as ano_mes,
AVG(salario_mensal) as media_salario,
AVG(horas_contratuais) as media_horas,
COUNT(CASE WHEN sexo = '1' AND raca_cor = '1' THEN 1 END) as Homens_brancos,
COUNT(CASE WHEN sexo = '1' AND raca_cor IN ('2','3') THEN 1 END) as Homens_negros,
COUNT(CASE WHEN sexo = '3' AND raca_cor = '1' THEN 1 END) as Mulheres_brancas,
COUNT(CASE WHEN sexo = '3' AND raca_cor IN ('2','3') THEN 1 END) as Mulheres_negras,

AVG(CASE WHEN sexo = '1' AND raca_cor = '1' THEN salario_mensal END) as sal_medio_homens_brancos,
AVG(CASE WHEN sexo = '1' AND raca_cor IN ('2','3') THEN salario_mensal END) as sal_medio_homens_negros,
AVG(CASE WHEN sexo = '3' AND raca_cor = '1' THEN salario_mensal END) as sal_medio_mulheres_brancas,
AVG(CASE WHEN sexo = '3' AND raca_cor IN ('2','3') THEN salario_mensal END) as sal_medio_mulheres_negras

FROM
basedosdados.br_me_caged.microdados_movimentacao
WHERE salario_mensal < 10000
GROUP BY ano_mes
ORDER BY ano_mes
  ")

# Podemos responder a pergunta de diferenças salariais de quatro formas:

# * O percentual do quanto o salário médio de homens brancos é maior do que o salário médio de cada grupo
# (valores negativos indicam que o salários dos outros grupos é maior);

# * O percentual de quanto o salário dos outros grupos é menor do que o salário de homens brancos;

# * O percentual de quanto o salário médio de cada grupo é maior do que o salário médio geral
# (valores negativos indicam que o salário do grupo é menor do que a média geral);

# * O salário dos demais grupos enquanto percentual do salário médio de homens brancos.


diferencas <- df_count %>% 
  mutate(dif_hb_maior_homens_negros = ((sal_medio_homens_brancos / sal_medio_homens_negros)-1)*100,
         dif_hb_maior_mulheres_brancas = ((sal_medio_homens_brancos / sal_medio_mulheres_brancas)-1)*100,
         dif_hb_maior_mulheres_negras = ((sal_medio_homens_brancos / sal_medio_mulheres_negras)-1)*100,
         # O quanto o salário dos homens brancos é maior do que o salário médio dos outros grupos
         dif_homens_negros_menor_hb = ((sal_medio_homens_brancos - sal_medio_homens_negros)/sal_medio_homens_brancos)*100,
         dif_mulheres_brancas_menor_hb = ((sal_medio_homens_brancos - sal_medio_mulheres_brancas)/sal_medio_homens_brancos)*100,
         dif_mulheres_negras_menor_hb = ((sal_medio_homens_brancos - sal_medio_mulheres_negras)/sal_medio_homens_brancos)*100,
         # O quanto o salário dos outros grupos é menor do que o salário de homens brancos
         dif_homens_brancos_mg = ((sal_medio_homens_brancos - media_salario)/media_salario)*100,
         dif_homens_negros_mg = ((sal_medio_homens_negros - media_salario)/media_salario)*100,
         dif_mulheres_brancas_mg = ((sal_medio_mulheres_brancas - media_salario)/media_salario)*100,
         dif_mulheres_negras_mg = ((sal_medio_mulheres_negras - media_salario)/media_salario)*100,
         # O quanto o salário médio de cada grupo é maior do que o salário médio geral
         homens_negros_perc_hb = (sal_medio_homens_negros/sal_medio_homens_brancos)*100,
         mulheres_brancas_perc_hb = (sal_medio_mulheres_brancas/sal_medio_homens_brancos)*100,
         mulheres_negras_perc_hb = (sal_medio_mulheres_negras/sal_medio_homens_brancos)*100)
         # Salário dos grupos enquanto percentual do salário de homens brancos

# Gráfico

dif_sal <- 
  ggplot(diferencas, aes(x = as.Date(ano_mes))) + 
  geom_line(aes(y = homens_negros_perc_hb), color = "#FF8484", linewidth = 0.5) +
  geom_line(aes(y = mulheres_brancas_perc_hb), color = "#42B0FF", linewidth = 0.5) +
  geom_line(aes(y = mulheres_negras_perc_hb), color = "#F69E4C", linewidth = 0.5) +
  labs(
    title = "Salário dos grupos como percentual \n do salário médio de homens brancos",
    y = "%", x = "") +
  theme_minimal()


#### A diferença entre a remuneração de homens e mulheres aumentou ou diminuiu com os anos? E quanto ####

df_count_ano <- basedosdados::read_sql(
  "SELECT
ano,
AVG(salario_mensal) as media_salario,
AVG(horas_contratuais) as media_horas,
COUNT(CASE WHEN sexo = '1' AND raca_cor = '1' THEN 1 END) as Homens_brancos,
COUNT(CASE WHEN sexo = '1' AND raca_cor IN ('2','3') THEN 1 END) as Homens_negros,
COUNT(CASE WHEN sexo = '3' AND raca_cor = '1' THEN 1 END) as Mulheres_brancas,
COUNT(CASE WHEN sexo = '3' AND raca_cor IN ('2','3') THEN 1 END) as Mulheres_negras,

AVG(CASE WHEN sexo = '1' AND raca_cor = '1' THEN salario_mensal END) as sal_medio_homens_brancos,
AVG(CASE WHEN sexo = '1' AND raca_cor IN ('2','3') THEN salario_mensal END) as sal_medio_homens_negros,
AVG(CASE WHEN sexo = '3' AND raca_cor = '1' THEN salario_mensal END) as sal_medio_mulheres_brancas,
AVG(CASE WHEN sexo = '3' AND raca_cor IN ('2','3') THEN salario_mensal END) as sal_medio_mulheres_negras
    
FROM
basedosdados.br_me_caged.microdados_movimentacao
WHERE salario_mensal < 10000
GROUP BY ano
ORDER BY ano
  ")

# Seguindo a mesma lógica anterior, temos:

diferencas_ano <- df_count_ano %>% 
  mutate(dif_hb_maior_homens_negros = ((sal_medio_homens_brancos / sal_medio_homens_negros)-1)*100,
         dif_hb_maior_mulheres_brancas = ((sal_medio_homens_brancos / sal_medio_mulheres_brancas)-1)*100,
         dif_hb_maior_mulheres_negras = ((sal_medio_homens_brancos / sal_medio_mulheres_negras)-1)*100,
         # O quanto o salário dos homens brancos é maior do que o salário médio dos outros grupos
         dif_homens_negros_menor_hb = ((sal_medio_homens_brancos - sal_medio_homens_negros)/sal_medio_homens_brancos)*100,
         dif_mulheres_brancas_menor_hb = ((sal_medio_homens_brancos - sal_medio_mulheres_brancas)/sal_medio_homens_brancos)*100,
         dif_mulheres_negras_menor_hb = ((sal_medio_homens_brancos - sal_medio_mulheres_negras)/sal_medio_homens_brancos)*100,
         # O quanto o salário dos outros grupos é menor do que o salário de homens brancos
         dif_homens_brancos_mg = ((sal_medio_homens_brancos - media_salario)/media_salario)*100,
         dif_homens_negros_mg = ((sal_medio_homens_negros - media_salario)/media_salario)*100,
         dif_mulheres_brancas_mg = ((sal_medio_mulheres_brancas - media_salario)/media_salario)*100,
         dif_mulheres_negras_mg = ((sal_medio_mulheres_negras - media_salario)/media_salario)*100,
         # O quanto o salário médio de cada grupo é maior do que o salário médio geral
         homens_negros_perc_hb = (sal_medio_homens_negros/sal_medio_homens_brancos)*100,
         mulheres_brancas_perc_hb = (sal_medio_mulheres_brancas/sal_medio_homens_brancos)*100,
         mulheres_negras_perc_hb = (sal_medio_mulheres_negras/sal_medio_homens_brancos)*100)
# Salário dos grupos como percentual do salário de homens brancos

# Gráfico das diferenças salariais somente por ano

dif_sal_ano2 <- 
  ggplot(diferencas_ano, aes(x = ano)) + 
  geom_line(aes(y = homens_negros_perc_hb), color = "#FF8484", linewidth = 0.5) +
  geom_line(aes(y = mulheres_brancas_perc_hb), color = "#42B0FF", linewidth = 0.5) +
  geom_line(aes(y = mulheres_negras_perc_hb), color = "#F69E4C", linewidth = 0.5) +
  labs(
    title = "Salário dos grupos como percentual \n do salário médio de homens brancos",
    y = "%", x = "") +
  theme_minimal()

# Visto ano a ano, contudo, parece haver tendência de declínio nas diferenças de média salarial

#### Qual é a tendência. Taxa de crescimento do salário por ano e grupo ####

taxa_crescimento <- df_count_ano %>%
  select(-c('Homens_brancos':'Mulheres_negras')) %>% 
  mutate(tx_geral = (media_salario - lag(media_salario))/lag(media_salario),
         tx_hb = (sal_medio_homens_brancos - lag(sal_medio_homens_brancos))/lag(sal_medio_homens_brancos),
         tx_hn = (sal_medio_homens_negros - lag(sal_medio_homens_negros))/lag(sal_medio_homens_negros),
         tx_mb = (sal_medio_mulheres_brancas - lag(sal_medio_mulheres_brancas))/lag(sal_medio_mulheres_brancas),
         tx_mn = (sal_medio_mulheres_negras - lag(sal_medio_mulheres_negras))/lag(sal_medio_mulheres_negras))

taxa_crescimento <- taxa_crescimento %>% replace(is.na(.), 0) 

# Gráfico da taxa de crescimento dos salários médios 

taxas_plt <- 
  ggplot(taxa_crescimento, aes(x = ano)) + 
  geom_line(aes(y = tx_geral*100), color = "black", linewidth = 0.5) +
  geom_line(aes(y = tx_hb*100), color = "#7EC876", linewidth = 0.5) +
  geom_line(aes(y = tx_hn*100), color = "#FF8484", linewidth = 0.5) +
  geom_line(aes(y = tx_mb*100), color = "#42B0FF", linewidth = 0.5) +
  geom_line(aes(y = tx_mn*100), color = "#F69E4C", linewidth = 0.5) +
  labs(
    title = "Taxa de crescimento do salário médio \n por grupo",
    y = "Percentual do crescimento", x = "") +
  theme_minimal()

#### Qual região apresenta mais equidade de gênero e racial na remuneração e qual apresenta a maior disparidade? ####
# Qual a diferença da média entre as duas?

df_count_regioes <- basedosdados::read_sql(
  "SELECT
FORMAT_DATETIME('%y-%m-%d', DATETIME(CONCAT(ano, '-', mes, '-01'))) as ano_mes,
AVG(salario_mensal) as media_salario,
AVG(horas_contratuais) as media_horas,
COUNT(CASE WHEN sexo = '1' AND raca_cor = '1' THEN 1 END) as Homens_brancos,
COUNT(CASE WHEN sexo = '1' AND raca_cor IN ('2','3') THEN 1 END) as Homens_negros,
COUNT(CASE WHEN sexo = '3' AND raca_cor = '1' THEN 1 END) as Mulheres_brancas,
COUNT(CASE WHEN sexo = '3' AND raca_cor IN ('2','3') THEN 1 END) as Mulheres_negras,

AVG(CASE WHEN sexo = '1' AND raca_cor = '1' THEN salario_mensal END) as sal_medio_homens_brancos,
AVG(CASE WHEN sexo = '1' AND raca_cor IN ('2','3') THEN salario_mensal END) as sal_medio_homens_negros,
AVG(CASE WHEN sexo = '3' AND raca_cor = '1' THEN salario_mensal END) as sal_medio_mulheres_brancas,
AVG(CASE WHEN sexo = '3' AND raca_cor IN ('2','3') THEN salario_mensal END) as sal_medio_mulheres_negras,

CASE 
WHEN sigla_uf IN ('AC','AM','AP','PA','RO','RR','TO') THEN 'Norte'
WHEN sigla_uf IN ('AL','BA','CE','MA','PB','PE','PI','RN','SE') THEN 'Nordeste'
WHEN sigla_uf IN ('GO','MT','MS') THEN 'Centro-Oeste'
WHEN sigla_uf IN ('ES','MG','RJ','SP') THEN 'Sudeste'
ELSE 'Sul'
END AS regioes,
    
FROM
basedosdados.br_me_caged.microdados_movimentacao
WHERE salario_mensal < 10000
GROUP BY ano_mes, regioes
ORDER BY ano_mes
  ")

# Diferenças:

diferencas_regiao <- df_count_regioes %>% 
  mutate(dif_hb_maior_homens_negros = ((sal_medio_homens_brancos / sal_medio_homens_negros)-1)*100,
         dif_hb_maior_mulheres_brancas = ((sal_medio_homens_brancos / sal_medio_mulheres_brancas)-1)*100,
         dif_hb_maior_mulheres_negras = ((sal_medio_homens_brancos / sal_medio_mulheres_negras)-1)*100,
         # O quanto o salário dos homens brancos é maior do que o salário médio dos outros grupos
         dif_homens_negros_menor_hb = ((sal_medio_homens_brancos - sal_medio_homens_negros)/sal_medio_homens_brancos)*100,
         dif_mulheres_brancas_menor_hb = ((sal_medio_homens_brancos - sal_medio_mulheres_brancas)/sal_medio_homens_brancos)*100,
         dif_mulheres_negras_menor_hb = ((sal_medio_homens_brancos - sal_medio_mulheres_negras)/sal_medio_homens_brancos)*100,
         # O quanto o salário dos outros grupos é menor do que o salário de homens brancos
         dif_homens_brancos_mg = ((sal_medio_homens_brancos - media_salario)/media_salario)*100,
         dif_homens_negros_mg = ((sal_medio_homens_negros - media_salario)/media_salario)*100,
         dif_mulheres_brancas_mg = ((sal_medio_mulheres_brancas - media_salario)/media_salario)*100,
         dif_mulheres_negras_mg = ((sal_medio_mulheres_negras - media_salario)/media_salario)*100,
         # O quanto o salário médio de cada grupo é maior do que o salário médio geral
         homens_negros_perc_hb = (sal_medio_homens_negros/sal_medio_homens_brancos)*100,
         mulheres_brancas_perc_hb = (sal_medio_mulheres_brancas/sal_medio_homens_brancos)*100,
         mulheres_negras_perc_hb = (sal_medio_mulheres_negras/sal_medio_homens_brancos)*100)
# Salário dos grupos como percentual do salário dos homens brancos

#### Regiões por ano ####

df_count_regioes_ano <- basedosdados::read_sql(
  "SELECT
ano,
AVG(salario_mensal) as media_salario,
AVG(horas_contratuais) as media_horas,
AVG(CASE WHEN sexo = '1' AND raca_cor = '1' THEN salario_mensal END) as sal_medio_homens_brancos,
AVG(CASE WHEN sexo = '1' AND raca_cor IN ('2','3') THEN salario_mensal END) as sal_medio_homens_negros,
AVG(CASE WHEN sexo = '3' AND raca_cor = '1' THEN salario_mensal END) as sal_medio_mulheres_brancas,
AVG(CASE WHEN sexo = '3' AND raca_cor IN ('2','3') THEN salario_mensal END) as sal_medio_mulheres_negras,
CASE 
WHEN sigla_uf IN ('AC','AM','AP','PA','RO','RR','TO') THEN 'Norte'
WHEN sigla_uf IN ('AL','BA','CE','MA','PB','PE','PI','RN','SE') THEN 'Nordeste'
WHEN sigla_uf IN ('GO','MT','MS') THEN 'Centro-Oeste'
WHEN sigla_uf IN ('ES','MG','RJ','SP') THEN 'Sudeste'
ELSE 'Sul'
END AS regioes,
    
FROM
basedosdados.br_me_caged.microdados_movimentacao
WHERE salario_mensal < 10000
GROUP BY ano, regioes
ORDER BY ano
  ")

# Diferenças:

diferencas_regiao_ano <- df_count_regioes_ano %>% 
  mutate(dif_hb_maior_homens_negros = ((sal_medio_homens_brancos / sal_medio_homens_negros)-1)*100,
         dif_hb_maior_mulheres_brancas = ((sal_medio_homens_brancos / sal_medio_mulheres_brancas)-1)*100,
         dif_hb_maior_mulheres_negras = ((sal_medio_homens_brancos / sal_medio_mulheres_negras)-1)*100,
         # O quanto o salário dos homens brancos é maior do que o salário médio dos outros grupos
         dif_homens_negros_menor_hb = ((sal_medio_homens_brancos - sal_medio_homens_negros)/sal_medio_homens_brancos)*100,
         dif_mulheres_brancas_menor_hb = ((sal_medio_homens_brancos - sal_medio_mulheres_brancas)/sal_medio_homens_brancos)*100,
         dif_mulheres_negras_menor_hb = ((sal_medio_homens_brancos - sal_medio_mulheres_negras)/sal_medio_homens_brancos)*100,
         # O quanto o salário dos outros grupos é menor do que o salário de homens brancos
         dif_homens_brancos_mg = ((sal_medio_homens_brancos - media_salario)/media_salario)*100,
         dif_homens_negros_mg = ((sal_medio_homens_negros - media_salario)/media_salario)*100,
         dif_mulheres_brancas_mg = ((sal_medio_mulheres_brancas - media_salario)/media_salario)*100,
         dif_mulheres_negras_mg = ((sal_medio_mulheres_negras - media_salario)/media_salario)*100,
         # O quanto o salário médio de cada grupo é maior do que o salário médio geral
         homens_negros_perc_hb = (sal_medio_homens_negros/sal_medio_homens_brancos)*100,
         mulheres_brancas_perc_hb = (sal_medio_mulheres_brancas/sal_medio_homens_brancos)*100,
         mulheres_negras_perc_hb = (sal_medio_mulheres_negras/sal_medio_homens_brancos)*100)
# Salário dos grupos como percentual do salário dos homens brancos

# Gráficos

# O quanto o salário de homens brancos é maior em relação aos grupos  
dif_sal_regiao <- 
  ggplot(diferencas_regiao, aes(x = as.Date(ano_mes))) + 
  geom_line(aes(y = dif_hb_maior_homens_negros), color = "#FF8484", linewidth = 0.5) +
  geom_line(aes(y = dif_hb_maior_mulheres_brancas), color = "#42B0FF", linewidth = 0.5) +
  geom_line(aes(y = dif_hb_maior_mulheres_negras), color = "#F69E4C", linewidth = 0.5) +
  labs(
    title = "Percentual do quanto o salário médio de \n de hb é maior do que dos outros grupos",
    y = "Percentual da diferença", x = "") +
  facet_wrap(~ regioes) +
  theme_minimal()

# Salário médio dos grupos como percentual do salário médio de homens brancos
dif_sal_regiao_2 <- 
  ggplot(diferencas_regiao, aes(x = as.Date(ano_mes))) + 
  geom_line(aes(y = homens_negros_perc_hb), color = "#FF8484", linewidth = 0.5) +
  geom_line(aes(y = mulheres_brancas_perc_hb), color = "#42B0FF", linewidth = 0.5) +
  geom_line(aes(y = mulheres_negras_perc_hb), color = "#F69E4C", linewidth = 0.5) +
  labs(
    title = "Salário médio dos grupos \n como percentual do salário médio de homens brancos",
    y = "%", x = "") +
  facet_wrap(~ regioes) +
  theme_minimal()

#### E por estado? ####

df_count_UF <- basedosdados::read_sql(
  "SELECT
ano,
sigla_uf,
AVG(salario_mensal) as media_salario,
AVG(horas_contratuais) as media_horas,
COUNT(CASE WHEN sexo = '1' AND raca_cor = '1' THEN 1 END) as Homens_brancos,
COUNT(CASE WHEN sexo = '1' AND raca_cor IN ('2','3') THEN 1 END) as Homens_negros,
COUNT(CASE WHEN sexo = '3' AND raca_cor = '1' THEN 1 END) as Mulheres_brancas,
COUNT(CASE WHEN sexo = '3' AND raca_cor IN ('2','3') THEN 1 END) as Mulheres_negras,

AVG(CASE WHEN sexo = '1' AND raca_cor = '1' THEN salario_mensal END) as sal_medio_homens_brancos,
AVG(CASE WHEN sexo = '1' AND raca_cor IN ('2','3') THEN salario_mensal END) as sal_medio_homens_negros,
AVG(CASE WHEN sexo = '3' AND raca_cor = '1' THEN salario_mensal END) as sal_medio_mulheres_brancas,
AVG(CASE WHEN sexo = '3' AND raca_cor IN ('2','3') THEN salario_mensal END) as sal_medio_mulheres_negras,

FROM
basedosdados.br_me_caged.microdados_movimentacao
WHERE salario_mensal < 10000
GROUP BY ano, sigla_uf
ORDER BY ano, sigla_uf
  ")

diferencas_uf <- df_count_UF %>% 
  mutate(dif_hb_maior_homens_negros = ((sal_medio_homens_brancos / sal_medio_homens_negros)-1)*100,
         dif_hb_maior_mulheres_brancas = ((sal_medio_homens_brancos / sal_medio_mulheres_brancas)-1)*100,
         dif_hb_maior_mulheres_negras = ((sal_medio_homens_brancos / sal_medio_mulheres_negras)-1)*100,
         # O quanto o salário dos homens brancos é maior do que o salário médio dos outros grupos
         dif_homens_negros_menor_hb = ((sal_medio_homens_brancos - sal_medio_homens_negros)/sal_medio_homens_brancos)*100,
         dif_mulheres_brancas_menor_hb = ((sal_medio_homens_brancos - sal_medio_mulheres_brancas)/sal_medio_homens_brancos)*100,
         dif_mulheres_negras_menor_hb = ((sal_medio_homens_brancos - sal_medio_mulheres_negras)/sal_medio_homens_brancos)*100,
         # O quanto o salário dos outros grupos é menor do que o salário de homens brancos
         dif_homens_brancos_mg = ((sal_medio_homens_brancos - media_salario)/media_salario)*100,
         dif_homens_negros_mg = ((sal_medio_homens_negros - media_salario)/media_salario)*100,
         dif_mulheres_brancas_mg = ((sal_medio_mulheres_brancas - media_salario)/media_salario)*100,
         dif_mulheres_negras_mg = ((sal_medio_mulheres_negras - media_salario)/media_salario)*100)
# O quanto o salário médio de cada grupo é maior do que o salário médio geral


# Diferenças entre os estados: valores máximo e mínimo dos salários médios; valores máximo e mínimo
# do percentual do salári omédio entre homens brancos e mulheres negras


max_min_uf <- diferencas_uf %>% 
  group_by(ano) %>%
  mutate(max_sal_uf = max(media_salario, na.rm = TRUE),
         min_sal_uf = min(media_salario, na.rm = TRUE)) %>% 
  ungroup() %>%  
  filter(media_salario == max_sal_uf | media_salario == min_sal_uf)

max_min_comp_mn_uf <- diferencas_uf %>% 
  group_by(ano) %>%
  mutate(max_desigualdade = max(dif_hb_maior_mulheres_negras, na.rm = TRUE),
         min_desigualdade = min(dif_hb_maior_mulheres_negras, na.rm = TRUE)) %>% 
  ungroup() %>%  
  filter(dif_hb_maior_mulheres_negras == max_desigualdade | dif_hb_maior_mulheres_negras == min_desigualdade)


#### Qual setor que apresenta a menor(e a menor) remuneração? #### 
# Qual a composição racial e de gênero desses setores? 

df_count_cnae <- basedosdados::read_sql(
  "SELECT
ano,
cnae_2_secao,
AVG(salario_mensal) as media_salario,
AVG(horas_contratuais) as media_horas,
COUNT(CASE WHEN sexo = '1' AND raca_cor = '1' THEN 1 END) as Homens_brancos,
COUNT(CASE WHEN sexo = '1' AND raca_cor IN ('2','3') THEN 1 END) as Homens_negros,
COUNT(CASE WHEN sexo = '3' AND raca_cor = '1' THEN 1 END) as Mulheres_brancas,
COUNT(CASE WHEN sexo = '3' AND raca_cor IN ('2','3') THEN 1 END) as Mulheres_negras,

AVG(CASE WHEN sexo = '1' AND raca_cor = '1' THEN salario_mensal END) as sal_medio_homens_brancos,
AVG(CASE WHEN sexo = '1' AND raca_cor IN ('2','3') THEN salario_mensal END) as sal_medio_homens_negros,
AVG(CASE WHEN sexo = '3' AND raca_cor = '1' THEN salario_mensal END) as sal_medio_mulheres_brancas,
AVG(CASE WHEN sexo = '3' AND raca_cor IN ('2','3') THEN salario_mensal END) as sal_medio_mulheres_negras,

FROM
basedosdados.br_me_caged.microdados_movimentacao
WHERE salario_mensal < 10000
GROUP BY ano, cnae_2_secao
ORDER BY ano, cnae_2_secao
  ")


diferencas_cnae <- df_count_cnae %>% 
  mutate(dif_hb_maior_homens_negros = ((sal_medio_homens_brancos / sal_medio_homens_negros)-1)*100,
         dif_hb_maior_mulheres_brancas = ((sal_medio_homens_brancos / sal_medio_mulheres_brancas)-1)*100,
         dif_hb_maior_mulheres_negras = ((sal_medio_homens_brancos / sal_medio_mulheres_negras)-1)*100,
         # O quanto o salário dos homens brancos é maior do que o salário médio dos outros grupos
         dif_homens_negros_menor_hb = ((sal_medio_homens_brancos - sal_medio_homens_negros)/sal_medio_homens_brancos)*100,
         dif_mulheres_brancas_menor_hb = ((sal_medio_homens_brancos - sal_medio_mulheres_brancas)/sal_medio_homens_brancos)*100,
         dif_mulheres_negras_menor_hb = ((sal_medio_homens_brancos - sal_medio_mulheres_negras)/sal_medio_homens_brancos)*100,
         # O quanto o salário dos outros grupos é menor do que o salário de homens brancos
         dif_homens_brancos_mg = ((sal_medio_homens_brancos - media_salario)/media_salario)*100,
         dif_homens_negros_mg = ((sal_medio_homens_negros - media_salario)/media_salario)*100,
         dif_mulheres_brancas_mg = ((sal_medio_mulheres_brancas - media_salario)/media_salario)*100,
         dif_mulheres_negras_mg = ((sal_medio_mulheres_negras - media_salario)/media_salario)*100)
# O quanto o salário médio de cada grupo é maior do que o salário médio geral

# Diferenças entre os setores: valores máximo e mínimo dos salários médios; valores máximo e mínimo
# do percentual do salári omédio entre homens brancos e mulheres negras

max_min_cnae <- diferencas_cnae %>% 
  group_by(ano) %>%
  mutate(max_sal_cnae = max(media_salario, na.rm = TRUE),
         min_sal_cnae = min(media_salario, na.rm = TRUE)) %>% 
  ungroup() %>%  
  filter(media_salario == max_sal_cnae | media_salario == min_sal_cnae)


max_min_comp_mn <- diferencas_cnae %>% 
  group_by(ano) %>%
  mutate(max_desigualdade = max(dif_hb_maior_mulheres_negras, na.rm = TRUE),
         min_desigualdade = min(dif_hb_maior_mulheres_negras, na.rm = TRUE)) %>% 
  ungroup() %>%  
  filter(dif_hb_maior_mulheres_negras == max_desigualdade | dif_hb_maior_mulheres_negras == min_desigualdade)


max_min_freq_mn <- diferencas_cnae %>% 
  group_by(ano) %>%
  mutate(max_freq = max(Mulheres_negras, na.rm = TRUE),
         min_freq = min(Mulheres_negras, na.rm = TRUE)) %>% 
  ungroup() %>%  
  filter(Mulheres_negras == max_freq | Mulheres_negras == min_freq)

#### Bonus ####
#### Mais contexto: e o cenários das movimentações? ####

# ver tipos de movimentação

saldo_grupo <- basedosdados::read_sql(
  "SELECT
FORMAT_DATETIME('%y-%m-%d', DATETIME(CONCAT(ano, '-', mes, '-01'))) as ano_mes,
AVG(salario_mensal) as media_salario,
SUM(saldo_movimentacao) as saldo_movimentacao,
COUNT(CASE WHEN sexo = '1' AND raca_cor = '1' THEN 1 END) as Homens_brancos,
COUNT(CASE WHEN sexo = '1' AND raca_cor IN ('2','3') THEN 1 END) as Homens_negros,
COUNT(CASE WHEN sexo = '3' AND raca_cor = '1' THEN 1 END) as Mulheres_brancas,
COUNT(CASE WHEN sexo = '3' AND raca_cor IN ('2','3') THEN 1 END) as Mulheres_negras,

SUM(CASE WHEN sexo = '1' AND raca_cor = '1' THEN saldo_movimentacao END) as saldo_homens_brancos,
SUM(CASE WHEN sexo = '1' AND raca_cor IN ('2','3') THEN saldo_movimentacao END) as saldo_homens_negros,
SUM(CASE WHEN sexo = '3' AND raca_cor = '1' THEN saldo_movimentacao END) as saldo_mulheres_brancas,
SUM(CASE WHEN sexo = '3' AND raca_cor IN ('2','3') THEN saldo_movimentacao END) as saldo_mulheres_negras

FROM
basedosdados.br_me_caged.microdados_movimentacao
WHERE salario_mensal < 10000
GROUP BY ano_mes
ORDER BY ano_mes
  ")

ad_des_grupo <- saldo_grupo <- basedosdados::read_sql(
  "SELECT
FORMAT_DATETIME('%y-%m-%d', DATETIME(CONCAT(ano, '-', mes, '-01'))) as ano_mes,
AVG(salario_mensal) as media_salario,
saldo_movimentacao,
COUNT(CASE WHEN sexo = '1' AND raca_cor = '1' THEN 1 END) as Homens_brancos,
COUNT(CASE WHEN sexo = '1' AND raca_cor IN ('2','3') THEN 1 END) as Homens_negros,
COUNT(CASE WHEN sexo = '3' AND raca_cor = '1' THEN 1 END) as Mulheres_brancas,
COUNT(CASE WHEN sexo = '3' AND raca_cor IN ('2','3') THEN 1 END) as Mulheres_negras,

AVG(CASE WHEN sexo = '1' AND raca_cor = '1' THEN salario_mensal END) as sal_medio_homens_brancos,
AVG(CASE WHEN sexo = '1' AND raca_cor IN ('2','3') THEN salario_mensal END) as sal_medio_homens_negros,
AVG(CASE WHEN sexo = '3' AND raca_cor = '1' THEN salario_mensal END) as sal_medio_mulheres_brancas,
AVG(CASE WHEN sexo = '3' AND raca_cor IN ('2','3') THEN salario_mensal END) as sal_medio_mulheres_negras

FROM
basedosdados.br_me_caged.microdados_movimentacao
WHERE salario_mensal < 10000
GROUP BY ano_mes, saldo_movimentacao
ORDER BY ano_mes
  ")


saldo_mov <- basedosdados::read_sql(
  "SELECT
FORMAT_DATETIME('%y-%m-%d', DATETIME(CONCAT(ano, '-', mes, '-01'))) as ano_mes,
sum(saldo_movimentacao) as saldo_movimentacao
FROM
basedosdados.br_me_caged.microdados_movimentacao
WHERE salario_mensal < 10000
GROUP BY ano_mes
ORDER BY ano_mes
  ")
# Gráfico movimentações

X11()
admissoes_demissoes <- 
  ggplot(ad_des_grupo, aes(x = as.Date(ano_mes))) + 
  geom_line(aes(y = Homens_brancos), color = "#7EC876", linewidth = 0.5) +
  geom_line(aes(y = Homens_negros), color = "#FF8484", linewidth = 0.5) +
  geom_line(aes(y = Mulheres_brancas), color = "#42B0FF", linewidth = 0.5) +
  geom_line(aes(y = Mulheres_negras), color = "#F69E4C", linewidth = 0.5) +
  facet_wrap(~ saldo_movimentacao) +
  labs(
    title = "Saldo de movimentações",
    y = "Total de pessoas", x = "") +
  theme_minimal()

sal_movimentacao <- 
  ggplot(ad_des_grupo, aes(x = as.Date(ano_mes))) + 
  geom_line(aes(y = sal_medio_homens_brancos), color = "#7EC876", linewidth = 0.5) +
  geom_line(aes(y = sal_medio_homens_negros), color = "#FF8484", linewidth = 0.5) +
  geom_line(aes(y = sal_medio_mulheres_brancas), color = "#42B0FF", linewidth = 0.5) +
  geom_line(aes(y = sal_medio_mulheres_negras), color = "#F69E4C", linewidth = 0.5) +
  facet_wrap(~ saldo_movimentacao) +
  labs(
    title = "Salário médio de admitidos e desligados",
    y = "", x = "") +
  theme_minimal()



X11()
saldo_grupo_plot <- 
  ggplot(saldo_grupo, aes(x = as.Date(ano_mes))) + 
  geom_line(aes(y = saldo_homens_brancos), color = "#7EC876", linewidth = 0.5) +
  geom_line(aes(y = saldo_homens_negros), color = "#FF8484", linewidth = 0.5) +
  geom_line(aes(y = saldo_mulheres_brancas), color = "#42B0FF", linewidth = 0.5) +
  geom_line(aes(y = saldo_mulheres_negras), color = "#F69E4C", linewidth = 0.5) +
  labs(
    title = "Saldo de movimentações por grupo",
    y = "Saldo", x = "") +
  theme_minimal()


# Movimentações somente por ano

ad_des_grupo_ano <- saldo_grupo <- basedosdados::read_sql(
  "SELECT
ano,
AVG(salario_mensal) as media_salario,
saldo_movimentacao,
COUNT(CASE WHEN sexo = '1' AND raca_cor = '1' THEN 1 END) as Homens_brancos,
COUNT(CASE WHEN sexo = '1' AND raca_cor IN ('2','3') THEN 1 END) as Homens_negros,
COUNT(CASE WHEN sexo = '3' AND raca_cor = '1' THEN 1 END) as Mulheres_brancas,
COUNT(CASE WHEN sexo = '3' AND raca_cor IN ('2','3') THEN 1 END) as Mulheres_negras,

AVG(CASE WHEN sexo = '1' AND raca_cor = '1' THEN salario_mensal END) as sal_medio_homens_brancos,
AVG(CASE WHEN sexo = '1' AND raca_cor IN ('2','3') THEN salario_mensal END) as sal_medio_homens_negros,
AVG(CASE WHEN sexo = '3' AND raca_cor = '1' THEN salario_mensal END) as sal_medio_mulheres_brancas,
AVG(CASE WHEN sexo = '3' AND raca_cor IN ('2','3') THEN salario_mensal END) as sal_medio_mulheres_negras

FROM
basedosdados.br_me_caged.microdados_movimentacao
WHERE salario_mensal < 10000
GROUP BY ano, saldo_movimentacao
ORDER BY ano
  ")

# Gráfico 

admissoes_demissoes_ano <- 
  ggplot(ad_des_grupo_ano, aes(x = ano)) + 
  geom_line(aes(y = Homens_brancos), color = "#7EC876", linewidth = 0.5) +
  geom_line(aes(y = Homens_negros), color = "#FF8484", linewidth = 0.5) +
  geom_line(aes(y = Mulheres_brancas), color = "#42B0FF", linewidth = 0.5) +
  geom_line(aes(y = Mulheres_negras), color = "#F69E4C", linewidth = 0.5) +
  facet_wrap(~ saldo_movimentacao) +
  labs(
    title = "Saldo de movimentações",
    y = "Total de pessoas", x = "") +
  theme_minimal()


sal_movimentacao_ano <- 
  ggplot(ad_des_grupo_ano, aes(x = ano)) + 
  geom_line(aes(y = sal_medio_homens_brancos), color = "#7EC876", linewidth = 0.5) +
  geom_line(aes(y = sal_medio_homens_negros), color = "#FF8484", linewidth = 0.5) +
  geom_line(aes(y = sal_medio_mulheres_brancas), color = "#42B0FF", linewidth = 0.5) +
  geom_line(aes(y = sal_medio_mulheres_negras), color = "#F69E4C", linewidth = 0.5) +
  facet_wrap(~ saldo_movimentacao) +
  labs(
    title = "Salário médio de admitidos e desligados",
    y = "", x = "") +
  theme_minimal()

#

saldo_grupo_ano <- basedosdados::read_sql(
  "SELECT
ano,
AVG(salario_mensal) as media_salario,
SUM(saldo_movimentacao) as saldo_movimentacao,
COUNT(CASE WHEN sexo = '1' AND raca_cor = '1' THEN 1 END) as Homens_brancos,
COUNT(CASE WHEN sexo = '1' AND raca_cor IN ('2','3') THEN 1 END) as Homens_negros,
COUNT(CASE WHEN sexo = '3' AND raca_cor = '1' THEN 1 END) as Mulheres_brancas,
COUNT(CASE WHEN sexo = '3' AND raca_cor IN ('2','3') THEN 1 END) as Mulheres_negras,

SUM(CASE WHEN sexo = '1' AND raca_cor = '1' THEN saldo_movimentacao END) as saldo_homens_brancos,
SUM(CASE WHEN sexo = '1' AND raca_cor IN ('2','3') THEN saldo_movimentacao END) as saldo_homens_negros,
SUM(CASE WHEN sexo = '3' AND raca_cor = '1' THEN saldo_movimentacao END) as saldo_mulheres_brancas,
SUM(CASE WHEN sexo = '3' AND raca_cor IN ('2','3') THEN saldo_movimentacao END) as saldo_mulheres_negras

FROM
basedosdados.br_me_caged.microdados_movimentacao
WHERE salario_mensal < 10000
GROUP BY ano
ORDER BY ano
  ")

# Gráfico

saldo_ano_plot <- 
  ggplot(saldo_grupo_ano, aes(x = ano)) + 
  geom_line(aes(y = saldo_homens_brancos), color = "#7EC876", linewidth = 0.5) +
  geom_line(aes(y = saldo_homens_negros), color = "#FF8484", linewidth = 0.5) +
  geom_line(aes(y = saldo_mulheres_brancas), color = "#42B0FF", linewidth = 0.5) +
  geom_line(aes(y = saldo_mulheres_negras), color = "#F69E4C", linewidth = 0.5) +
  labs(
    title = "Saldo de movimentações por grupo",
    y = "Saldo", x = "") +
  theme_minimal()



