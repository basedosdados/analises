import streamlit as st
import pandas as pd
import streamlit_shadcn_ui as ui
import graficos 

st.set_page_config(
    page_title="ClimaDengue - Base dos Dados",
    page_icon=":mosquito:",
    layout="wide"
    )

st.image("banner.png")

col1, col2 = st.columns([3,2])

with col1:
    st.write("Este dashboard permite que você naveque pelos dados de notificações de casos de dengue do SINAN e de temperatura e precipitação de estações automáticas do INMET. \n A maioria dos dados utilizados aqui estão disponíveis no data lake da Base dos Dados")


#---
# carregar dados que serão utilizados
diarios = pd.read_csv('diarios.csv')
semanais = pd.read_csv('semanais.csv')
populacao = pd.read_csv('populacao.csv')


#---
# selecionar cidade
with col2:
    filtros = st.container(border=True)
    
with filtros:
    cidade = st.selectbox('Selecione a capital',semanais['cidade'].sort_values().unique())


#---
# filtrar e combinar os dados conforme necessidade
dados_diarios = diarios[diarios['cidade']==cidade]
dados_semanais = semanais[semanais['cidade']==cidade]
function_dict = {'temperatura_media':'mean','precipitacao':'sum','casos':'sum'}
dados_mensais = dados_diarios.groupby(by=['cidade','ano','mes']).aggregate(function_dict).reset_index()
dados_mensais = dados_mensais[dados_mensais['cidade']==cidade]
pop = populacao[populacao['cidade']==cidade]
dados_anuais = dados_mensais.groupby(by='ano').aggregate(function_dict).reset_index()

dados_semanais = dados_semanais.merge(pop,left_on='ano',right_on='ano')
dados_semanais['casos_100k'] = round(dados_semanais['casos']/dados_semanais['população']*100000)
dados_mensais = dados_mensais.merge(pop,left_on='ano',right_on='ano')
dados_mensais['casos_100k'] = round(dados_mensais['casos']/dados_mensais['população']*100000)

casos_totais = dados_mensais['casos'].sum()
ano_mais_casos = int(dados_anuais.loc[dados_anuais['casos']==dados_anuais['casos'].max(),'ano'].values[0])
print(ano_mais_casos)
#--- 
# criar as tabs
dengue, temperatura, precipitacao, climadengue = st.tabs(["Dengue","Temperatura","Precipitação","Clima e Dengue"])

#--- 
# tab1: DENGUE
with dengue:
    col_card1, col_card2, col_texto = st.columns([1,1,3])
    col_heatmap = st.columns(1)[0]
    col_casos_absolutos = st.columns(1)[0]
    #col_casos_100k = st.columns(1)

#with col_card1:
#    ui.metric_card(title='Total de casos',content=casos_totais,description='nos últimos dez anos')
#with col_card2:
#    ui.metric_card(title='Ano com mais casos',content=ano_mais_casos,description='nos últimos dez anos')
#with col_texto:
#    st.markdown("<p style='padding-top:10px'></p>", unsafe_allow_html=True)
#    st.markdown("""
#                Os dados utilizados para o desenvolvimento destas visualizações estão disponíveis no dataset [SINAN na Base dos Dados](https://basedosdados.org/dataset/f51134c2-5ab9-4bbc-882f-f1034603147a?table=9bdbca38-d97f-47fa-b422-84477a6b68c8). 
#                Dados de população das capitais são das projeções disponíveis do Ministério da Saúde, acessados pelo [Tabnet](http://tabnet.datasus.gov.br/cgi/tabcgi.exe?ibge/cnv/projpop2024uf.def).
#                """)

with col_heatmap:
    pivot_semanais = pd.pivot_table(dados_semanais,values='casos_100k',index=['ano'],columns=['semana'],aggfunc='sum', fill_value=0)
    st.plotly_chart(graficos.heatmap(pivot_semanais,'Greens',"Casos por 100 mil habitantes"), use_container_width=False)

with col_casos_absolutos:
    st.plotly_chart(graficos.casos_absolutos(dados_mensais))

# tab2: temperatura
with temperatura:
    col_heatmap_temp = st.columns(1)[0]
    col_linha_temp = st.columns(1)[0]
    
with col_heatmap_temp:
    pivot_semanais = pd.pivot_table(dados_semanais,values='temperatura_media',index='ano',columns='semana',aggfunc='mean')
    pivot_semanais = round(pivot_semanais,1)
    st.plotly_chart(graficos.heatmap(pivot_semanais,'Reds','Temperatura média na semana (°C)'))

with col_linha_temp:
    st.plotly_chart(graficos.linha_tempo(dados_mensais,'temperatura_media','darkred','Temperatura média mensal','Temperatura (°C)'))


#tab3: Precipitação
with precipitacao:
    col_heatmap_precip = st.columns(1)[0]
    col_linha_precip = st.columns(1)[0]

with col_heatmap_precip:
    pivot_semanais = pd.pivot_table(dados_semanais,values='precipitacao',index='ano',columns='semana',aggfunc='sum')
    pivot_semanais = round(pivot_semanais)
    st.plotly_chart(graficos.heatmap(pivot_semanais,'Blues','Precipitação total (mm)'))

with col_linha_precip:
    st.plotly_chart(graficos.linha_tempo(dados_mensais,'precipitacao','darkblue','Precipitação total mensal','Precipitação (mm)'))


#tab4: climadengue
with climadengue:
    col_casos_temperatura = st.columns(1)[0]
    col_casos_precipitacao = st.columns(1)[0]

with col_casos_temperatura:
    st.plotly_chart(graficos.casos_tempo(dados_mensais,'temperatura_media','darkgreen','red','Notificações e Temperatura média por mês','Temperatura (°C)'))

with col_casos_precipitacao:
    st.plotly_chart(graficos.casos_tempo(dados_mensais,'precipitacao','darkgreen','blue','Notificações e Precipitação total por mês','Precipitação (mm)'))