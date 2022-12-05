SELECT 
  year, 
  stage_name, 
  team_a_name, 
  score, 
  team_b_name, 
  extra_time, 
  score_penalties 
FROM `basedosdados.world_fifa_worldcup.matches` 
WHERE (team_a_name = 'Brazil' OR team_b_name = 'Brazil') AND stage_name = 'round of 16'
ORDER BY year DESC
