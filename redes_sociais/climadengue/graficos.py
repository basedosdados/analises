
import pandas as pd
import plotly.graph_objects as go
from plotly.subplots import make_subplots
import plotly.express as px


#--- gráficos

#heatmap
def heatmap(dados,cor,titulo):
    fig_heatmap = px.imshow(dados, text_auto=True,
                            color_continuous_scale=cor, 
                            aspect="auto")
    fig_heatmap.update_layout(xaxis={'side':'bottom'})
    fig_heatmap.update_layout(yaxis={'tickmode':'linear'})
    fig_heatmap.update_xaxes(title_text="Semana epidemiológica")
    fig_heatmap.update_yaxes(title_text="")
    fig_heatmap.update_layout(title_text=titulo)
    #fig_heatmap.update_layout(annotations=[dict(text='Sinan', xanchor='right',yanchor='bottom',x=0,y=0,showarrow=False)])
    return fig_heatmap

#casos absolutos de dengue na capital escolhida
def casos_absolutos(dados):
    dados['data'] = pd.to_datetime(dados['ano'].astype(str) + '-' + dados['mes'].astype(str), format='%Y-%m')
    fig_casos = go.Figure()
    fig_casos.add_trace(
        go.Bar(x=dados['data'],y=dados['casos'],marker_color='darkgreen')
    )
    fig_casos.update_xaxes(title_text="")
    fig_casos.update_yaxes(title_text="Notificações")
    fig_casos.update_layout(title_text=f"Casos de Dengue")
    #fig_casos.update_layout(xaxis={'tickmode':'linear'})
    fig_casos.update_layout(plot_bgcolor='white')
    return fig_casos    

def linha_tempo(dados,variavel,cor,titulo,xlabel):
    dados['data'] = pd.to_datetime(dados['ano'].astype(str) + '-' + dados['mes'].astype(str), format='%Y-%m')
    fig = go.Figure()
    fig.add_trace(
        go.Scatter(x=dados['data'],y=dados[variavel],marker_color=cor)
    )
    fig.update_xaxes(title_text="")
    fig.update_yaxes(title_text=xlabel)
    fig.update_layout(title_text=titulo)
    #fig_casos.update_layout(xaxis={'tickmode':'linear'})
    fig.update_layout(plot_bgcolor='white')
    return fig

def casos_tempo(dados,variavel,cor_casos,cor_variavel,titulo,label_variavel):
    dados['data'] = pd.to_datetime(dados['ano'].astype(str) + '-' + dados['mes'].astype(str), format='%Y-%m')
    fig = make_subplots(specs=[[{"secondary_y": True}]])
    fig.add_trace(
        go.Bar(x=dados['data'], y=dados['casos'], name="Notificações",marker_color=cor_casos),
        secondary_y=False,
    )
    fig.add_trace(
        go.Scatter(x=dados['data'], y=dados[variavel], name=label_variavel, marker_color=cor_variavel),
        secondary_y=True,
    )
    fig.update_layout(title_text=titulo)
    fig.update_xaxes(title_text="")
    fig.update_yaxes(title_text='Notificações', secondary_y=False)
    fig.update_yaxes(title_text=label_variavel, secondary_y=True)
    fig.update_layout(plot_bgcolor='white')
    #fig_temp_casos.update_layout(yaxis2={'rangemode':'tozero'})
    return fig

#climograma
def climograma(dados_mensais):
    fig_climograma = make_subplots(specs=[[{"secondary_y": True}]])
    fig_climograma.add_trace(
        go.Bar(x=dados_mensais['mes'], y=dados_mensais['precipitacao'], name="Precipitação (mm)"),
        secondary_y=False,
    )
    fig_climograma.add_trace(
        go.Scatter(x=dados_mensais['mes'], y=dados_mensais['temperatura_media'], name="Temperatura média (°C)"),
        secondary_y=True,
    )
    fig_climograma.update_layout(title_text=f"Climograma")
    fig_climograma.update_xaxes(title_text="Mês")
    fig_climograma.update_yaxes(title_text="Precipitação (mm)", secondary_y=False)
    fig_climograma.update_yaxes(title_text="Temperatura média (°C)", secondary_y=True)
    fig_climograma.update_layout(plot_bgcolor='white')
    fig_climograma.update_layout(xaxis={'tickmode':'linear'})
    fig_climograma.update_layout(yaxis2={'rangemode':'tozero'})
    return fig_climograma



#casos por mês
def casos(dados_mensais):
    fig_casos = go.Figure()
    fig_casos.add_trace(
        go.Bar(x=dados_mensais['mes'],y=dados_mensais['casos'],marker_color='teal')
    )
    fig_casos.update_xaxes(title_text="Mês")
    fig_casos.update_yaxes(title_text="Notificações")
    fig_casos.update_layout(title_text=f"Casos de Dengue")
    fig_casos.update_layout(xaxis={'tickmode':'linear'})
    fig_casos.update_layout(plot_bgcolor='white')
    return fig_casos

#temperatura media e casos por semana epidemiologica
def temp_casos(dados_semanais):
    fig_temp_casos = make_subplots(specs=[[{"secondary_y": True}]])
    fig_temp_casos.add_trace(
        go.Bar(x=dados_semanais['semana'], y=dados_semanais['casos'], name="Notificações",marker_color='teal'),
        secondary_y=False,
    )
    fig_temp_casos.add_trace(
        go.Scatter(x=dados_semanais['semana'], y=dados_semanais['temperatura_media'], name="Temperatura média (°C)"),
        secondary_y=True,
    )
    fig_temp_casos.update_layout(title_text=f"Casos e Temperatura")
    fig_temp_casos.update_xaxes(title_text="Semana epidemiológica")
    fig_temp_casos.update_yaxes(title_text="Precipitação (mm)", secondary_y=False)
    fig_temp_casos.update_yaxes(title_text="Temperatura média (°C)", secondary_y=True)
    fig_temp_casos.update_layout(plot_bgcolor='white')
    fig_temp_casos.update_layout(yaxis2={'rangemode':'tozero'})
    return fig_temp_casos

#precipitacao total e casos por semana epidemiologica
def precip_casos(dados_semanais):
    fig_precip_casos = make_subplots(specs=[[{"secondary_y": True}]])
    fig_precip_casos.add_trace(
        go.Bar(x=dados_semanais['semana'], y=dados_semanais['casos'], name="Notificações",marker_color='teal'),
        secondary_y=False,
    )
    fig_precip_casos.add_trace(
        go.Scatter(x=dados_semanais['semana'], y=dados_semanais['precipitacao'], name="Precipitação (mm)",marker_color='blue'),
        secondary_y=True,
    )
    fig_precip_casos.update_layout(title_text=f"Casos e Precipitação")
    fig_precip_casos.update_xaxes(title_text="Semana epidemiológica")
    fig_precip_casos.update_yaxes(title_text="Casos", secondary_y=False)
    fig_precip_casos.update_yaxes(title_text="Precipitação (mm)", secondary_y=True)
    fig_precip_casos.update_layout(plot_bgcolor='white')
    fig_precip_casos.update_layout(yaxis={'rangemode':'tozero'})
    return fig_precip_casos