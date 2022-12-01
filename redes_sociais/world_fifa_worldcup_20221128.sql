WITH tabela_gol AS (SELECT 
  year,
  team_a_name,
  team_a_score,
  team_b_score,  
  team_b_name, 
  CASE
      WHEN
         team_a_name = 'Brazil' THEN team_a_score
      WHEN 
         team_b_name = 'Brazil' THEN team_b_score
  END AS gol_brazil,
  
  FROM `basedosdados.world_fifa_worldcup.matches` 
  WHERE stage_name = 'group stage' AND (team_a_name = 'Brazil'OR team_b_name = 'Brazil'))
  SELECT 
      year,
      sum(gol_brazil) AS total_gol,
      avg(gol_brazil) AS media_gol,
      max(gol_brazil) AS max_gol,
      stddev(gol_brazil) AS dp_gol
   FROM tabela_gol
   GROUP BY 1
