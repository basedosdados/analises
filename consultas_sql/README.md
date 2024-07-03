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
| Qual oPIB das capitais do pa�s em 2018  | [br_capitais_ideb_pib_20210303.sql](consultas_sql/br_capitais_ideb_pib_20210303.sql) |
