Declare
@DATAINICIAL Date,
@DATAFINAL Date

Set @DATAINICIAL = :pDATAINICIAL
Set @DATAFINAL = :pDATAFINAL


		Select
			m.Descricao as COMBUSTIVEIS,
			AVG(d.Valor/i.Qtd) as PRECO_MEDIO,
			u.Descricao as FAZENDA
			From
			ItensDocumento I
			Join Documentos D on i.Sequencial = d.Sequencial
			Join Materiais M  on m.Codigo = i.Produto
			Join UnidNegocios U on d.Emitente = U.Codigo
		Where
			i.Produto = '5'
			and d.TipoOperacao = '493'
			and i.Qtd >= '5000'
			and d.DataRecebimento between @DATAINICIAL and @DATAFINAL
			and d.Empresa = '313'
		Group by
			m.Descricao,
			u.Descricao
Union All
		Select
			m.Descricao as COMBUSTIVEL,
			AVG(d.Valor/i.Qtd) as PRECO_MEDIO,
			u.Descricao as FAZENDA
			From
			ItensDocumento I
			Join Documentos D on i.Sequencial = d.Sequencial
			Join Materiais M  on m.Codigo = i.Produto
			Join UnidNegocios U on d.Emitente = U.Codigo
		Where
			i.Produto = '14'
			and d.TipoOperacao = '493'
			and i.Qtd >= '5000'
			and d.DataRecebimento between @DATAINICIAL and @DATAFINAL
			and d.Empresa = '313'
		Group by
			m.Descricao,
			u.Descricao
