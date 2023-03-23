##--parte 1 ----

#1. instalar pacotes e carregá-los
install.packages('basedosdados')
library(basedosdados)

#.2 definir billing id
basedosdados::set_billing_id('seu-billing-id')

#3. definir query
query <- 
"
WITH siconfi as (
#QUERY 1 -> encontrar os investimento na conta de educação 
SELECT 
ano,
sigla_uf,
id_municipio,
SUM (valor) as total_siconfi
FROM `basedosdados.br_me_siconfi.municipio_despesas_funcao`
WHERE ano = 2020 AND sigla_uf = 'CE' AND conta = 'Educação' AND estagio = 'Despesas Pagas'
GROUP BY 1,2,3
ORDER BY 4 DESC),
censo_escolar as (
#Query 2
SELECT
ano,
sigla_uf,
id_municipio,
sum(quantidade_matricula_masculino + quantidade_matricula_feminino + quantidade_matricula_nao_declarada) as total_matriculas
FROM `basedosdados.br_inep_censo_escolar.escola`
WHERE ano = 2020 AND sigla_uf = 'CE'
GROUP BY 1,2,3),
investimento_educacao as (
SELECT
siconfi.id_municipio,
ROUND((total_siconfi/total_matriculas),2) as investimento_per_capita
FROM siconfi
inner join censo_escolar
on siconfi.ano = censo_escolar.ano AND siconfi.id_municipio = censo_escolar.id_municipio
)
select 
investimento_educacao.id_municipio,
investimento_educacao.investimento_per_capita,
saeb.rede,
saeb.media as media_matematica_5ano,
FROM investimento_educacao
INNER JOIN `basedosdados.br_inep_saeb.municipio` saeb ON
investimento_educacao.id_municipio = saeb.id_municipio 
WHERE saeb.ano = 2021 AND saeb.serie = 5 AND saeb.disciplina = 'MT'  AND saeb.localizacao = 'total'"

#4. ler query e salvar em um objeto
dados <- basedosdados::read_sql(query = query)


##--parte 2 ----
library(ggplot2)
library(dplyr)

#1. observar os dados
glimpse(dados)

#2. ver os valores únicos da variável rede
unique(dados$rede)

#3. filtar a rede que será utilizada na análise
dados <- dados %>% 
  filter(rede == "total - federal, estadual, municipal e privada")


#4. plotar gráfico de dispersão
dados %>% 
  ggplot2::ggplot(aes(x = investimento_per_capita,
                      y = media_matematica_5ano)) +
  geom_point() +
  tema_sem_legenda +
  theme_void()+
  labs(y = "Média em matemática no 5º ano" ,
       x = "Investimento per Capita em educação",
       caption = "Fonte: elaborado pelos autores com dados do SICONFI, SAEB e Censo Escolar extraídos da @Basedosdados.",
       title = "Investimento per capita x Média em matemática do 5º ano",
       subtitle = "Preços constantes em Reais (R$)")

plot(dados)

##--parte 2.1 ---- montar o mapa da média da nota de matemática do 5º ano no saeb nos municípios do ceará
library(geobr)

#1. ler dados .wkt dos municípios do ceará
municipios_ceara <- read_municipality(code_muni = 'CE')


#2. realizar o join entre as bases
municipios_ceara <- municipios_ceara %>% 
  mutate(code_muni = as.character(code_muni)) %>% 
  left_join(dados,
            by = c('code_muni' = 'id_municipio'))



#3. construir mapa preliminar
municipios_ceara %>% 
  ggplot() +
  geom_sf(aes(fill = media_matematica_5ano)) +
  scale_fill_distiller(palette = 'Greens',
                       direction = 1) +
  theme_void() +
  #customizar tema
  theme(plot.title = element_text(hjust =0.5, 
                                  face = 'bold'),
        legend.text = element_text(size = 10)
        
       # legend.key.size = unit(1, 'cm')
       ) +
  ggtitle("Nível de aprendizagem de Matemática no 5º ano SAEB em 2021")


#4. Criar categorias de nível de aprendizado de acordo com a classificação do todos pela educação
municipios_ceara %>% 
  #criar categoria de nivel de aprendizado
  mutate(nivel_aprendizado = cut(media_matematica_5ano,
                                 breaks=c(-Inf, 174,224,274, Inf),
                                 labels=c("Insuficiente","Básico","Proficiente",'Avançado'))) %>% 
  #elaborar mapa
  ggplot() +
  geom_sf(aes(fill = nivel_aprendizado)) +
  scale_fill_brewer(palette = 'Greens',
                       direction = 1) +
  theme_void() +
  theme(plot.title = element_text(hjust =0.5, face = 'bold'),
        legend.text = element_text(size = 10)) +
  theme(legend.key.size = unit(1, 'cm')) +
  ggtitle("Nível de aprendizagem de Matemática no 5º ano SAEB em 2021")






