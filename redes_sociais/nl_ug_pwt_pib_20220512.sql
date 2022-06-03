SELECT year, 
country, 
real_gdp_expenditures/population AS real_gdp_per_capita_exp, 
real_gdp_output/population AS real_gdp_per_capita_out, 
real_gdp_na/population AS real_gdp_per_capita_na,
average_hours_worked 
FROM `basedosdados.nl_ug_pwt.microdados` 
WHERE country IN ('Argentina', 'Brazil', 'Chile', 
'Colombia','Suriname', 'Uruguay') AND year >= 1970