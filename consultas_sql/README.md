Este é nosso repositório de consultas SQL para facilitar e poupar tempo da sua análise com os dados da BD. Por aqui você encontra consultas SQL criadas para acessar recortes específicos nos dados do nosso datalake público. 

No nome de cada arquivo você encontra o conjunto e a tabela utilizadas na consulta SQL. 

Criou um recorte interessante? Não deixe de compartilhar aqui também e contribuir com essa biblioteca de consultas. 


## Como adicionar nova consulta

1. Clique em add file
2. Suba a consulta que você quer compartilhar usando a seguinte nomeclatura: `<abrangencia>_<tema>_<AAAAMMDD>.[sql|py|...]` ou `<nome.da.tabela>_<data>.[linguagem]`

> ex: `br_municipios_desmatamento_20210209.sql`

3. Clique em em "Commit Changes"
4. Na janela que vai aparecer, clique em "Propose Changes"
5. Clique em "Create Pull Request"
6. Adicione uma breve descrição do seu código ou análise no campo "Add a description"
7. Clique em "Create Pull Request"
8. Pronto! Sua consulta e código serão revisados pela nossa equipe e, se estiver tudo de acordo com os padrões da BD, será publicada 💚


## Consultas 🔎

Aqui você consultas SQL em nosso datalake público

| Pergunta | Consulta | 
| ------- | ------ |
| Tivemos mais contratos contratos pré ou pós-pagos de telefonia móvel no Brasil em 2023? | [consultas_sql/br_anatel_telefonia_movel.microdados.sql](/consultas_sql/br_anatel_telefonia_movel.microdados.sql) |
| Quais empresas tiveram mais contratos de telefonía móvel no Brasil em 2023? | [consultas_sql/br_anatel_telefonia_movel.microdados.sql](/consultas_sql/br_anatel_telefonia_movel.microdados.sql) |
| Qual tipo de sinal foi predominante nos contratos de telefonia móvel no Brasil em 2023?  | [consultas_sql/br_anatel_telefonia_movel.microdados.sql](/consultas_sql/br_anatel_telefonia_movel.microdados.sql) |
| Qual oPIB das capitais do pa�s em 2018  | [br_capitais_ideb_pib_20210303.sql](/consultas_sql/br_capitais_ideb_pib_20210303.sql) |
| Qual o IDEB das capitais em 2019  | [br_capitais_ideb_pib_20210303.sql](/consultas_sql/br_capitais_ideb_pib_20210303.sql) |
| Qual é a Popula��o das capitais em 2018  | [br_capitais_ideb_pib_20210303.sql](/consultas_sql/br_capitais_ideb_pib_20210303.sql) |
| Qual foi a remuneração média de servidores do executivo federal no primeiro semestre de 2024?  | [br_cgu_servidores_executivo_federal.remuneracao.sql](consultas_sql\br_cgu_servidores_executivo_federal.remuneracao.sql) |
| Qual foi a remuneração máxima de servidores do executivo federal no primeiro semestre de 2024?  | [br_cgu_servidores_executivo_federal.remuneracao.sql](consultas_sql\br_cgu_servidores_executivo_federal.remuneracao.sql) |
| Quantas UBSs existem em seu município? | [br_cnes_estabelecimentos_upa_20230322.sql](consultas_sql\br_cnes_estabelecimentos_upa_20230322.sql) |
| Consulta do somatório das despesas, agrupado por tipo de despesa; além da soma total do valor restituído à Câmara, quando houver | [br_dados_abertos_camara_20240516.sql](consultas_sql\br_dados_abertos_camara_20240516.sql) |
| Consulta às despesas por tipo de despesa, data, valor de restituição à Câmara e nome_passageiro da viagem quando a despesa se refere a esse gasto. | [br_dados_abertos_camara_20240516.sql](consultas_sql\br_dados_abertos_camara_20240516.sql) |
|Qual UF teve a maior quantidade de furto de veículos de 2016 a 2021? | [br_fbsp_absp_uf_20230808.sql](consultas_sql\br_fbsp_absp_uf_20230808.sql) |
| Qual é a área territorial e densidade demográfica (CENSO 2022) da sua cidade | [br_ibge_censo_2022.area_territorial_densidade_demografica_municipio.sql](consultas_sql\br_ibge_censo_2022.area_territorial_densidade_demografica_municipio.sql) |
| O valor da produção da extração vegetal cresceu no Brasil nas últimas três décadas?  | [br_ibge_pevs.producao_extracao_vegetal.sql](consultas_sql\br_ibge_pevs.producao_extracao_vegetal.sql) |
| Quantos focos de queimadas houveram em seu municipio teve ao longo do tempo?   | [br_inpe_queimadas.microdados_20231113.sql](consultas_sql\br_inpe_queimadas.microdados_20231113.sql) |
| Quantos MWh seu estado consumiu de energia de 2004 a 2021?   | [br_mme_consumo_energia_eletrica_uf_20230801.sql](consultas_sql\br_mme_consumo_energia_eletrica_uf_20230801.sql) |

