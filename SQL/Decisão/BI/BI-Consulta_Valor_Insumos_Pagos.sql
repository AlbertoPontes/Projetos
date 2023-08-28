Select
	m.Codigo as CODIGO_MATERIAL,
	m.Descricao as MATERIAL,
	i.Qtd as QUANTIDADE,
	tb.DESCRICAO as UNIDADE,
	i.Valor as VALOR_ITEM,
	d.Numero as NUMERO_NF,
	t.Valor2 as VALOR_TITULO,
	tc.Descricao as MOEDA,
	mt.Data as DATA_LANCAMENTO,
	da.Descricao as UNIDADE_NEGOCIO
From
	Documentos D
	Left Join ItensDocumento I on d.Sequencial=i.Sequencial
	Left Join Materiais M on i.Produto=m.Codigo
	Left Join Tabelas TA on m.Grupo=ta.Codigo and ta.Tipo='9'
	Left Join Titulos T on d.Sequencial=t.SeqDoc
	Left Join MovTitulos MT on t.Sequencial=mt.Sequencial
	Left Join TIPOMOVTITULOS TT on mt.TipoMov=tt.SEQUENCIAL
	Left Join DetPessoas DA on d.Emitente=da.Sequencial
	Left Join Tabelas TB on i.Unidade=tb.Codigo
	Left Join Tabelas TC on t.Moeda2=tc.Codigo and tc.tipo='10'
Where
	m.Grupo in (3, 4, 9, 15, 208, 214, 251, 286, 289, 204, 205, 206, 218, 241, 245, 246, 219) and
	mt.SeqLanc <> '0' and
	tt.Baixa='S' and
	tb.Tipo='5' and
	d.Empresa='313'