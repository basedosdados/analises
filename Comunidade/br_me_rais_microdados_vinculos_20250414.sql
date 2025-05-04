#Busca a proporção de servidores com nível superior para os municípios brasileiros usando dados da RAIS 

SELECT id_municipio,
       count(*) as quantidade_nivel_superior,
       ( select count(*)
           from `basedosdados.br_me_rais.microdados_vinculos` vinc_sub
          where vinc_sub.id_municipio = vinc.id_municipio and
                ano = 2023 and
                vinculo_ativo_3112 ="1" and
                natureza_juridica = "1244") as total_servidores_municipio, #1244= município 
         (count(*)/( select count(*)
           from `basedosdados.br_me_rais.microdados_vinculos` vinc_sub
          where vinc_sub.id_municipio = vinc.id_municipio and
                ano = 2023 and
                vinculo_ativo_3112 ="1" and
                natureza_juridica = "1244"))*100 as proporcao_nivel_superior     
FROM `basedosdados.br_me_rais.microdados_vinculos` vinc
where cnae_2 = "84116" and #administração pública
      ano = 2023 and
      vinc.vinculo_ativo_3112 ="1" and
      natureza_juridica = "1244" and #município
      grau_instrucao_apos_2005 in ("09","10","11") #nível superior, mestrado e doutorado
group by id_municipio 
order by id_municipio
