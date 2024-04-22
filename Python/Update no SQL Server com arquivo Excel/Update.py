import pandas as pd
import pyodbc

# Configurações de conexão com o banco de dados
server = 'Endereco_do_Servidor_do_Banco_de_Dados'
database = 'Nome_do_Banco_de_Dados'
username = 'Usuario_do_Banco_de_Dados'
password = 'Senha_do_Usuario_do_Banco_de_Dados'
conn_str = f'DRIVER=ODBC Driver 17 for SQL Server;SERVER={server};DATABASE={database};UID={username};PWD={password}'

# Conectar ao banco de dados
conn = pyodbc.connect(conn_str)
cursor = conn.cursor()

# Caminho para o arquivo Excel
caminho_excel = 'C:\\Pasta_do_Arquivo\\arquivo.xlsx'

# Ler a planilha do Excel
df = pd.read_excel(caminho_excel)

# Iterar sobre as linhas da planilha
for index, row in df.iterrows():
    AliasColuna1Excel = row['NOME_COLUNA1_EXCEL']
    AliasColuna2Excel = row['NOME_COLUNA2_EXCEL']
    
    # Atualizar o banco de dados
    cursor.execute("UPDATE tabela SET Coluna2Banco = ? WHERE Coluna1Banco = ?", (AliasColuna2Excel, AliasColuna1Excel))
    conn.commit()

# Fechar conexão com o banco de dados
conn.close()

print("Atualização concluída.")
