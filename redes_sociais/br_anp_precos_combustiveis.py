"""
Created on Fri Sep 10 18:15:34 2021

@author: Gustavo Aires Tiago
"""

import pandas as pd
import plotly.graph_objs as go
import basedosdados as bd

# define a query dos dados
query = """
WITH sub as (SELECT p.produto, 
            ip.indice as indice_atual
            FROM basedosdados.br_anp_precos_combustiveis.microdados p
            LEFT JOIN basedosdados.br_ibge_inflacao.ipca ip 
            ON p.ano=ip.ano AND EXTRACT(MONTH FROM p.data_coleta)=ip.mes 
            WHERE p.ano = 2021 and EXTRACT(MONTH FROM p.data_coleta) = 7
            GROUP BY 1,2)
SELECT p.ano, 
      EXTRACT(MONTH from p.data_coleta) AS mes, 
      p.produto, 
      ROUND(AVG(p.preco_venda),3) AS preco_medio,
      ROUND((AVG(sub.indice_atual)/AVG(ip.indice))*AVG(p.preco_venda),3) AS preco_corrigido,
FROM basedosdados.br_anp_precos_combustiveis.microdados p
LEFT JOIN basedosdados.br_ibge_inflacao.ipca ip  on p.ano=ip.ano and EXTRACT(MONTH from p.data_coleta)=ip.mes 
INNER JOIN sub ON p.produto=sub.produto 
WHERE ip.mes is not null 
GROUP BY 1,2,3
"""

# utiliza a API para importa os dados com a query 
df = bd.read_sql(query, billing_project_id='basedosdados-dev')

#Altera os formatos de data
df =df.dropna(subset=['mes'])
df['date'] = pd.to_datetime(df['date']).dt.to_period('m')
df['date']=df['date'].apply(lambda x: x.strftime('%Y-%m'))
df['date']=df['date'].replace('-','_', regex=True)
df[['ano','mes']]=df[['ano','mes']].astype('int64')
df = df.sort_values(['ano','mes'])

#cria uma lista de produtos
produto = pd.DataFrame(df['produto'].drop_duplicates()).replace(' ','_', regex=True)
produto = produto['produto'].values.tolist()

#cria listas de preço e data para cada produto
for i in produto:
    a = df['produto']==i
    exec('df_{} = df[a]'.format(i))
    exec('p_{} = df_{}["preco_corrigido"].values.tolist()'.format(i,i))
    exec('date_{} = df_{}["date"].drop_duplicates().values.tolist()'.format(i,i))

#formata o gráfico
fig = go.Figure()

fig.add_trace(go.Scatter(
    x= date_gasolina ,
    y=p_gasolina,
    line_color='rgb(255,132,132)',
    line_width=4,
    name='Gasolina',
    showlegend = True))

fig.add_trace(go.Scatter(
    x= date_etanol ,
    y=p_etanol,
    line_color='rgb(43,140,77)',
    line_width=4,
    name='Etanol',
    showlegend = True))

fig.add_trace(go.Scatter(
    x= date_diesel ,
    y=p_diesel,
    line_color='rgb(246,158,76)',
    line_width=4,
    name='Diesel',
    showlegend = True))

fig.add_trace(go.Scatter(
    x= date_gnv ,
    y=p_gnv,
    line_color='rgb(66,176,255)',
    line_width=4,
    name='GNV',
    showlegend = True))

fig.update_layout(
    template = 'plotly_white',
    xaxis=dict(
        tickvals = ['2004_01', '2005_01','2006_01','2007_01', '2008_01', '2009_01', '2010_01', '2011_01','2012_01',
                    '2013_01','2014_01','2015_01','2016_01','2017_01','2018_01','2019_01','2020_01','2021_01'],
        ticktext = ['2004','2005', '2006', '2007', '2008','2009', '2010',
                    '2011','2012','2013','2014','2015','2016','2017','2018','2019','2020','2021'],
        showline=True,
        showgrid=False,
        showticklabels=True,
        scaleanchor = "x",
        scaleratio = 10,
        linecolor='rgb(204, 204, 204)',
        linewidth=2,
        title = 'período',
        ticks='outside',
        tickfont=dict(
            family='Ubuntu',
            size=14,
            color='rgb(82, 82, 82)',
        ),
    ),
    yaxis=dict(
        autorange = True,
        scaleanchor = "y",
        scaleratio = 10,
        tickvals = [2.5,3,3.5,4,4.5,5,5.5,6,6.5],
        ticktext = ['R$ 2,50','R$ 3,00','R$ 3,50','R$ 4,00','R$ 4,50','R$ 5,00','R$ 5,50','R$ 6,00','R$ 6,50'],
        title = 'preço do combustível',
        showgrid=True,
        zeroline=True,
        ticks='outside',
        tickfont=dict(
                family='Ubuntu',
                size=14,
                color='rgb(82, 82, 82)'),
        showline=True,
        showticklabels=True
        
        ,
    ),
    autosize=True,
    height=1000,  
    width=1200,
    showlegend=True,
    plot_bgcolor='white',
)
fig.update_shapes()

fig.update_traces(mode='lines')
fig.show()

#Salva o gráfico no caminho especificado
fig.write_image('graf_anp_ipca.png')