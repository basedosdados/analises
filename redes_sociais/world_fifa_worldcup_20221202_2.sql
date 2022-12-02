SELECT 
  year,
  stage_name,
  team_a_name,
  score,
  team_b_name,

  CASE 
    WHEN team_a_name = 'Brazil' then team_a_score_margin
    WHEN team_b_name = 'Brazil' then team_b_score_margin
  END  AS score_margin

FROM `basedosdados.world_fifa_worldcup.matches` 
WHERE (team_b_name = 'Brazil' and team_b_win = 1) or (team_a_name = 'Brazil' and team_a_win = 1)
ORDER BY score_margin DESC
LIMIT 10