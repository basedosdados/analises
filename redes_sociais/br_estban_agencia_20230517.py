# -*- coding: utf-8 -*-
"""estban.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/1tyeuI3s3ByYv4unpDBxe93YUURIwEgpg
"""

!pip install basedosdados -q

import basedosdados as bd
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

query = '''
WITH total_ano AS (
    SELECT 
        ano, 
        SUM(valor) AS valor_total 
    FROM basedosdados.br_bcb_estban.agencia
    WHERE ano > 2002 AND ano < 2023
        AND id_verbete = '160' ## Créditos Bancários
    GROUP BY ano
),
share AS (
    SELECT 
        a.ano,
        a.instituicao, 
        SUM(a.valor) AS valor,  
        (SUM(a.valor) / t.valor_total) * 100 AS percentual
    FROM basedosdados.br_bcb_estban.agencia a
    JOIN total_ano t ON t.ano = a.ano
    WHERE a.ano > 2002 AND a.ano < 2023 AND a.id_verbete = '160' # Créditos Bancários
    GROUP BY a.instituicao, a.ano, t.valor_total
), 
principais AS (
  SELECT
  s.ano,
  CASE WHEN percentual > 5.0 THEN s.instituicao ELSE 'OUTROS' END AS instituicao,
  SUM(percentual)  as percentual 
  FROM share s 
  GROUP BY ano, instituicao
)
SELECT * FROM principais
'''
df = bd.read_sql(query, billing_project_id='basedosdados-dev')

#Visualização 
#Necessário pivotar para plotar o gráfico que desejo
pivot_df = df.pivot_table(index='ano', columns='instituicao', values='percentual')

pivot_df.head()

#Plotagem do gráfico
ax = pivot_df.plot(kind='bar', stacked=True)
plt.title('Participação Percentual das Instituições Financeiras em Operações de Crédito de 2003 a 2022')
plt.xlabel('Ano')
plt.ylabel('Percentual')
ax.set_ylim(0, 100)
plt.legend(bbox_to_anchor=(1.02, 1), loc='upper left')
plt.show()
ax.figure.savefig("estban.svg", transparent=True, format='svg')

df_itau = df.loc[df['instituicao'] == 'ITAU UNIBANCO S.A.']

df_caixa['variacao'] = df_caixa['percentual'].diff()

# Plotar gráfico da variação da porcentagem ao longo dos anos
plt.plot(df_caixa['ano'], df_caixa['variacao'], marker='o')
plt.xlabel('Ano')
plt.ylabel('Variação da Porcentagem')
plt.title('Variação da Porcentagem da Caixa Econômica Federal ao longo dos anos')
plt.grid(True)
plt.show()

# Calcular a variação total da porcentagem ao longo de todos os anos
variacao_total = abs(df_itau['percentual'].iloc[-1] - df_itau['percentual'].iloc[0])

print(f"A variação total da porcentagem do Itau ao longo de todos os anos é de: {variacao_total}%")