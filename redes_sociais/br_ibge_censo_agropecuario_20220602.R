#Código elaborado por: Gustavo Alcântara
#Analista de dados na Base dos Dados
#github: gustavoalcantara

#A boa pergunta é:
#Qual a Proporção de Gados por Pessoa no MT?

#Passo 1
#Vamos limpar nosso ambiente primeiro, né?
#Isso evita trabalhar com coisas preteritamente carregadas. 
rm(list=ls())
graphics.off()
gc(reset = TRUE)

#Passo 2
#Apontar minha billing_id do Google
basedosdados::set_billing_id('bd-geobr-censoagro')

#Passo 3
#Vamos rodar a query pra tentar responder essa pergunta :)
#O pacote basedosdados no R disponibiliza uma função
#de ler uma query de SQL. Fica bem mais fácil do que 
#baixar todo o Dataframe. 
df <- basedosdados::read_sql(
  "SELECT 
  c.ano, c.id_municipio, c.sigla_uf, quantidade_bovinos_total, populacao,
  quantidade_bovinos_total/populacao AS gado_pessoa
  FROM basedosdados.br_ibge_censo_agropecuario.municipio AS c
  INNER JOIN basedosdados.br_ibge_populacao.municipio AS p
  ON c.id_municipio = p.id_municipio AND c.ano = p.ano
  WHERE c.ano = 2017 AND c.sigla_uf = 'MT'"
) 
#Lembrando que o último Censo Agropecuário foi realizado em 2017.
#Portanto, é válido comparar a população com o mesmo ano. 

#Passo 4
#Agora, vamos trabalhar com o geobr para elaborar
#um mapa coroplético do estado do MT
mun <- geobr::read_municipality(code_muni = 51)

#renomeando variáveis para realizar um join futuramente
mun|>
  dplyr::rename(id_municipio = code_muni) -> mun

#atribuindo a id do municipio como um double
df|>
  dplyr::mutate(id_municipio = as.double(id_municipio)) -> df

#Join do Dataframe para as categorias de ordem espaciais
mun|>
  dplyr::left_join(df,
                   by='id_municipio') -> mun

#Passo 5
#elaborando o mapa
windows()
ggplot()+
  geom_sf(data=mun, aes(fill=gado_pessoa))+
  scale_fill_binned()+
  labs(title = "Proporção de gado por pessoas no Mato Grosso em 2017")

#Se quiser colaborar com o código, fique a vontade  


