SELECT 
    ano, 
    sum(desmatado) area_total_desmatada,
    sum(incremento) incremetento_area_desmatada
FROM `basedosdados.br_inpe_prodes.desmatamento_municipios`
GROUP BY 1
ORDER BY 1;

# A partir da base gerada foi construído um gráfico no Flourish: https://public.flourish.studio/visualisation/5938420/
