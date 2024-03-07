#Análise para divulgação nas redes sociais
  #Resultados em: https://docs.google.com/spreadsheets/d/1AlmErOqpgnyWMJqo_VouckNAxHhkSqpM-UzUSBt7Ltw/edit?usp=sharing

#Como é a representatividade de raça nos edições históricas do oscar? 
  
SELECT race_ethnicity, COUNT(DISTINCT name) AS total_winners
FROM `basedosdados.world_ampas_oscar.winner_demographics`
WHERE race_ethnicity IS NOT NULL
GROUP BY race_ethnicity
ORDER BY total_winners DESC;

#Quais cidades possuem mais vencedores(as)? 
  
SELECT birthplace, COUNT(DISTINCT name) AS total_winners
FROM `basedosdados.world_ampas_oscar.winner_demographics`
WHERE birthplace IS NOT NULL
GROUP BY birthplace
ORDER BY total_winners DESC;

#Qual é a idade média dos(as) vencedores(as)?
SELECT AVG(age) AS idade_media_geral
FROM (
    SELECT birth_year,
           year_edition - birth_year AS age
    FROM `basedosdados.world_ampas_oscar.winner_demographics`
) AS t;

#Qual é a idade máxima e mínima de vencedores(as)?
  #MÁXIMA
SELECT MAX(age) AS idade_media_geral
FROM (
    SELECT birth_year,
           year_edition - birth_year AS age
    FROM `basedosdados.world_ampas_oscar.winner_demographics`
) AS t;
  #Mínima
SELECT MIN(age) AS idade_media_geral
FROM (
    SELECT birth_year,
           year_edition - birth_year AS age
    FROM `basedosdados.world_ampas_oscar.winner_demographics`
) AS t;

#Quais foram as pessoas mais jovens e idosas a ganhar o oscar? 
SELECT age, name, category, movie
FROM (
    SELECT birth_year,
           year_edition - birth_year AS age,
           name,
           category,
           movie
    FROM `basedosdados.world_ampas_oscar.winner_demographics`
) AS t
WHERE age = 83

SELECT age, name, category, movie
FROM (
    SELECT birth_year,
           year_edition - birth_year AS age,
           name,
           category,
           movie
    FROM `basedosdados.world_ampas_oscar.winner_demographics`
) AS t
WHERE age = 11
