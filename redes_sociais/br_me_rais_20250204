SELECT A.ano as ano, rem_media_nbrancos, rem_media_brancos, 
(rem_media_nbrancos/rem_media_brancos) AS wage_gap
FROM
    (SELECT ano, AVG(valor_remuneracao_media) as rem_media_nbrancos
    FROM `basedosdados.br_me_rais.microdados_vinculos`
    WHERE raca_cor='4' OR raca_cor='8' OR raca_cor='1'
    AND ano=2023
    GROUP BY ano) AS A
    LEFT JOIN
    (SELECT ano, AVG(valor_remuneracao_media) as rem_media_brancos
    FROM `basedosdados.br_me_rais.microdados_vinculos`
    WHERE raca_cor='2'
    AND ano=2023
    GROUP BY ano) AS B
    ON A.ano=B.ano
ORDER by ano
