# -*- coding: utf-8 -*-

import os
import xml.etree.ElementTree as ET
from fpdf import FPDF

# Obtém uma lista de todos os arquivos XML no diretório atual
arquivos_xml = [arquivo for arquivo in os.listdir('.') if arquivo.endswith('.xml')]

for arquivo in arquivos_xml:
    # Ler o arquivo XML da nota fiscal
    tree = ET.parse(arquivo)
    root = tree.getroot()

    # Extrair as informações relevantes do XML
    numero = root.find('.//ide/numero').text
    data_emissao = root.find('.//ide/dhEmi').text
    valor_total = root.find('.//total/ICMSTot/vNF').text

    produtos = []
    for prod in root.findall('.//det'):
        descricao = prod.find('.//prod/xProd').text
        quantidade = prod.find('.//prod/qCom').text
        valor_unitario = prod.find('.//prod/vUnCom').text
        valor_total_produto = prod.find('.//prod/vProd').text
        produtos.append({'descricao': descricao, 'quantidade': quantidade, 
                         'valor_unitario': valor_unitario, 'valor_total': valor_total_produto})

    # Criar um novo objeto PDF com a biblioteca PyFPDF
    pdf = FPDF()
    pdf.add_page()

    # Adicionar informações do cabeçalho ao PDF
    pdf.set_font('Arial', 'B', 16)
    pdf.cell(0, 10, 'Nota Fiscal Eletrônica', 0, 1, 'C')
    pdf.ln(10)
    pdf.set_font('Arial', 'B', 14)
    pdf.cell(0, 10, f'Número: {numero}', 0, 1)
    pdf.cell(0, 10, f'Data de emissão: {data_emissao}', 0, 1)
    pdf.ln(10)

    # Adicionar informações do corpo ao PDF
    pdf.set_font('Arial', 'B', 12)
    pdf.cell(50, 10, 'Descrição', 1)
    pdf.cell(40, 10, 'Quantidade', 1)
    pdf.cell(40, 10, 'Valor unitário', 1)
    pdf.cell(40, 10, 'Valor total', 1)
    pdf.ln()

    for produto in produtos:
        pdf.set_font('Arial', '', 12)
        pdf.cell(50, 10, produto['descricao'], 1)
        pdf.cell(40, 10, produto['quantidade'], 1)
        pdf.cell(40, 10, produto['valor_unitario'], 1)
        pdf.cell(40, 10, produto['valor_total'], 1)
        pdf.ln()

    pdf.ln(10)

    # Adicionar informações do rodapé ao PDF
    pdf.set_font('Arial', 'B', 14)
    pdf.cell(0, 10, f'Valor total: R$ {valor_total}', 0, 1, 'R')

    # Salvar o arquivo PDF em disco
    nome_arquivo_pdf = os.path.splitext(arquivo)[0] + '.pdf'
    pdf.output(nome_arquivo_pdf, 'F')
