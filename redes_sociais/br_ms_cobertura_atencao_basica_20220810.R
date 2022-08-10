#Código elaborado por: Gustavo Alcântara
#Analista de dados na Base dos Dados
#github: gustavoalcantara

#A boa pergunta é:
#Qual a proporção da cobertura da Atenção Básica 
#nas UFS do Brasil nos anos de 2007 e 2020?
#É possível analisar uma evolução

#Passo 1
#Vamos limpar nosso ambiente primeiro, né?
#Isso evita trabalhar com coisas preteritamente carregadas. 
rm(list=ls())
graphics.off()
gc(reset = TRUE)

#Passo 2: Como nossa query trabalhará com as UF,
#vamos priorizar já chamar os arquivos espaciais para
#futuras views
uf <- geobr::read_state()

#Passo 3
#Apontar minha billing_id do Google 
#e criar um dataframe com a query necessária
#para responder a pergunta
#Billing Id
basedosdados::set_billing_id('bd-analise-saude')

#dataframe
df <- basedosdados::read_sql("SELECT 
  ano,
  sigla_uf,
  ROUND (100 * SUM (populacao_coberta_total_atencao_basica) / SUM (populacao), 2) AS proporcao_cobertura_atencao_basica_uf
FROM basedosdados.br_ms_atencao_basica.municipio 
WHERE mes = 12
GROUP BY ano, sigla_uf
order by sigla_uf asc")


#Mudando nome de variável pra fazer join
uf <- uf |>
  dplyr::rename(sigla_uf = abbrev_state)

#passo 4
#Join com o arquivo spatial feature do Geobr.
uf|>
  dplyr::inner_join(df, by='sigla_uf') -> uf

windows()

#Gráfico de evolução ao longo do tempo.
plot <- uf|>
  ggplot2::ggplot()+
  geom_sf(aes(fill=proporcao_cobertura_atencao_basica_uf))+
  scale_fill_binned(type = "viridis", name = 'Proporção')+
  facet_wrap(~ as.character(ano), nrow = 3)+
  labs(title = "Proporção de Atendimento da Cobertura Básica por UF de 2007 a 2020")

#save com o arquivo .svg para criar gifs de acordo com o padrão BD
ggsave(filename = 'saude.svg', plot = plot, dpi = 200, width = 10,
       height = 8, units = "cm")


#Passo 5: Bônus.
#Evolução ao longo do tempo comparando 2020 a 2007
df|>
  dplyr::group_by(ano, sigla_uf)|>
  dplyr::summarise(proporcao_cobertura_atencao_basica_uf) |>
  dplyr::filter(ano==2007 | ano==2020) |>
  dplyr::mutate(ano = 
                  as.character(ano))|>
  tidyr::pivot_wider(names_from = ano, 
                     values_from = proporcao_cobertura_atencao_basica_uf ) |>
  dplyr::mutate(evolucao = 
                  `2020` - `2007`) ->x

#Save em .csv para futuras análises
write.csv(x,'teste.csv',  na = " ", 
          row.names = F, fileEncoding = "UTF-8")






