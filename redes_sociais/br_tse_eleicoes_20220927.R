## github.com/arthurfg  
## Libs

library(tidyverse)
library(basedosdados)
library(geofacet)
library(ggh4x)
library(extrafont)

### BD

set_billing_id("casebd")

## Base de resultados
query <- bdplyr("br_tse_eleicoes.resultados_candidato") %>%
  select(ano, id_municipio, sigla_uf,
         turno, tipo_eleicao, cargo,
         numero_candidato, id_candidato_bd,
         resultado, ano) %>%
  filter(ano > 2005, cargo == "deputado federal", resultado != "nao eleito")

df_resultado <- bd_collect(query)


## Base de candidatos

query2 <- bdplyr("br_tse_eleicoes.candidatos") %>%
  select(ano, sigla_uf, id_candidato_bd,
         nome, situacao, ocupacao, genero,
         idade, instrucao, raca) %>%
  filter(ano > 2005)

df_candidatos <- bd_collect(query2)

## Base de diretórios

query4 <- bdplyr("br_bd_diretorios_brasil.uf") %>%
  select(sigla, nome)

diretorio <- bd_collect(query4)


##### Tidying

diretorio <- diretorio %>%
  rename(nome_uf = nome, sigla_uf = sigla)

candidatos_join <- df_candidatos %>%
  left_join(df_resultado, by = c("id_candidato_bd", "ano")) %>%
  rename(sigla_uf = sigla_uf.x) %>%
  inner_join(diretorio, by = "sigla_uf")

#### Criando o df com o total de deputadas eleitas por ano e UF
#### e a sua proporção, frente ao total de eleitos(as)

a <- candidatos_join %>%
  filter(resultado != "suplente") %>%
  filter(!is.na(id_candidato_bd)) %>%
  filter(tipo_eleicao == "eleicao ordinaria",
         situacao == "deferido") %>%
  mutate(genero = as_factor(genero)) %>% 
  group_by(ano, sigla_uf, genero, .drop = FALSE) %>%
  summarise(N = n()) %>%
  group_by(ano, sigla_uf, .drop = FALSE) %>%
  mutate(total = sum(N), proporcao = round(N / total, 2))


##### Plot

a %>%
  filter(genero == "feminino") %>%
  ggplot(aes(x = ano, y = proporcao)) +
  geom_area(fill = "#009688", alpha = 0.4) +
  geom_line(color="#762a83", size = 1, alpha = 0.5) +
  geom_point(size=1.5, color="#762a83", alpha = 0.5) +
  scale_y_continuous(labels = scales::percent) +
  facet_geo(~sigla_uf, grid = "br_states_grid1") +
  scale_x_continuous(breaks = seq(2006, 2018, 4)) +
  labs(
    title = "\n \n\n",
    caption = "\nFonte: @basedosdados · Elaboração: Arthur Gusmão"
  ) +
  theme_minimal() +
  theme(
    panel.grid = element_blank(),
    legend.pos = c(0.875, 0.975),
    legend.direction = "horizontal",
    legend.box = "vertical",
    legend.title = element_blank(),
    plot.background = element_rect(fill = "#F5F4EF", color = NA),
    plot.margin = margin(40, 60, 40, 60),
    plot.title = element_text(
      margin = margin(0, 0, 0, 0), 
      size = 20,
      family = "Georgia",
      face = "bold",
      vjust = 0, 
      color = "grey25"
    ),
    plot.caption = element_text(size = 11, family = "Georgia", color = "grey25"),
    axis.title = element_blank(),
    axis.text.x = element_text(color = "grey40", size = 8),
    axis.text.y = element_text(color = "grey40", size = 6),
    strip.text = element_text(face = "bold", color = "grey20")
  )
