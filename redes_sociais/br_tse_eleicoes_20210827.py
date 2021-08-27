# instala pacotes
pip install basedosdados
pip install plotly
pip install chart_studio
pip install numpy

# importa pacotes
import pandas as pd
import plotly.graph_objs as go
import chart_studio.plotly as py
import numpy as np
import basedosdados as bd

# define a query dos dados
query = """
SELECT  ano, genero,
(CASE when  idade >= 18 and idade <= 24 then '18 a 24 anos' 
        when idade >= 25 and idade <= 29 then '25 a 29 anos'
        when idade >= 30 and idade <= 34 then '30 a 34 anos'
        when idade >= 35 and idade <= 39 then '35 a 39 anos'
        when idade >= 40 and idade <= 44 then '40 a 44 anos'
        when idade >= 45 and idade <= 49 then '45 a 49 anos'
        when idade >= 50 and idade <= 54 then '50 a 54 anos'
        when idade >= 55 and idade <= 59 then '55 a 59 anos'
        when idade >= 60 and idade <= 64 then '60 a 64 anos'
        when idade >= 65 and idade <= 69 then '65 a 69 anos'
        when idade >= 70 and idade <= 74 then '70 a 74 anos'
        when idade >= 75 and idade <= 79 then '75 a 79 anos'
        else '80+'   
		END) as grupo,
count(titulo_eleitoral)	
FROM `basedosdados.br_tse_eleicoes.candidatos`
where idade is not null
group by 1,2,3
ORDER BY ano DESC
"""

# utiliza a API para importa os dados com a query 
filiacao_tse = bd.read_sql(query, billing_project_id='basedosdados-dev')

#define os anos das eleições gerais
ano_geral = [1994,1998,2002,2006,2010,2014,2018]

# laço para criação de dataframes de cada ano (filtra o dataset principal)
# laço para criação de cada gráfico e salvamento
for ano in ano_geral:
    exec('df_{} = filiacao_tse[filiacao_tse["ano"]==int(ano)]'.format(ano))
    exec('df_{} = df_{}[["genero","grupo","n_candidatos"]]'.format(ano,ano))
    exec('df_{} = pd.pivot_table(df_{}, values=["n_candidatos"], index=["grupo"],columns="genero")'.format(ano,ano))
    exec('y_age = df_{}.index'.format(ano))
    exec('x_M = df_{}[("n_candidatos",  "masculino")]'.format(ano))
    exec('x_F = df_{}[("n_candidatos",  "feminino")] * -1'.format(ano))
    
    # inicia a criação do gráfico
    fig = go.Figure()
  
    # Adiciona masculino para o gráfico
    fig.add_trace(go.Bar(y= y_age, x = x_M,
                         name = 'Masculino', 
                         orientation = 'h', marker=dict(color='#42B0FF')))
      
    # Adiciona feminino para o gráfico
    fig.add_trace(go.Bar(y = y_age, x = x_F,
                         name = 'Feminino', orientation = 'h', marker=dict(color='#FF8484')))
      
    # Altera parâmetros para o gráfico
    fig.update_layout(template = 'plotly_white',
                     title = '({})'.format(ano),title_x = 0.5,
                     title_font_size = 22, barmode = 'relative',
                     bargap = 0.05, bargroupgap = 0,
                     autosize = False,
                     xaxis = dict(tickvals = [-60000,-50000,-40000, -30000, -20000,-10000, 0,10000, 20000, 30000, 40000, 50000,60000],
                                      ticktext = ['60k','50k','40k', '30k', '20k','10k', '0','10k','20k', '30k', '40k','50k','60k'],
                                      autorange=False,
                                      range=[-60000, 60000]))
    
    #Salva cada imagem no caminho a seguir
    exec('fig.write_image("gener_ano_{}.png")'.format(ano))
        
#define os anos das eleições gerais   
ano_municipal = [2000,2004,2008,2012,2016,2020]

# laço para criação de dataframes de cada ano (filtra o dataset principal)
for ano in ano_municipal:
    exec('df_{} = filiacao_tse[filiacao_tse["ano"]==int(ano)]'.format(ano))
    exec('df_{} = df_{}[["genero","grupo","n_candidatos"]]'.format(ano,ano))
    exec('df_{} = pd.pivot_table(df_{}, values=["n_candidatos"], index=["grupo"],columns="genero")'.format(ano,ano))
    exec('y_age = df_{}.index'.format(ano))
    exec('x_M = df_{}[("n_candidatos",  "masculino")]'.format(ano))
    exec('x_F = df_{}[("n_candidatos",  "feminino")] * -1'.format(ano))
    
    fig = go.Figure()
  
    fig.add_trace(go.Bar(y= y_age, x = x_M,
                         name = 'Masculino', 
                         orientation = 'h', marker=dict(color='#42B0FF')))
    
    fig.add_trace(go.Bar(y = y_age, x = x_F,
                         name = 'Feminino', orientation = 'h', marker=dict(color='#FF8484')))
      
    fig.update_layout(template = 'plotly_white',
                     title = '({})'.format(ano),title_x = 0.5,
                     title_font_size = 22, barmode = 'relative',
                     bargap = 0.05, bargroupgap = 0,
                     autosize = False,
                     xaxis = dict(tickvals = [-3000, -2000,-1000, -500, 0, 500, 1000, 2000,3000],
                                      ticktext = ['3k','2k', '1k', '500', '0','500', '1k', '2k','3k'],
                                      tickwidth = 5,
                                      autorange=False,
                                      range=[-3500, 3500]))
      
    exec('fig.write_image("gener_ano_{}.png")'.format(ano))