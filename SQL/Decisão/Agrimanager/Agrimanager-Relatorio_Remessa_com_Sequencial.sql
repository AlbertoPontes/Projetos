Declare
@DATAINI Date,
@DATAFIN Date

Set @DATAINI = :pDataInicial
Set @DATAFIN = :pDataFinal

Select
	t.NumeroBoleto as NUMERO_TITULO,
	d.Sequencial as SEQUENCIAL_DOCUMENTO,
	convert (varchar, t.DataVcto, 103) as DATA_VENCIMENTO,
	p.Nome as FAVORECIDO,
	r.ArquivoGerado as ARQUIVO_REMESSA,
	t.ValorRemessa as VALOR_REMESSA,
	convert (varchar, T.DataRemessa, 103) as DATA_REMESSA,
	u.Descricao as UNIDADE_NEGOCIO
From
	Titulos T
	left join Documentos D on d.Sequencial = t.SeqDoc
	left join Pessoas P on d.Pessoa = p.Codigo
	left join UnidNegocios U on d.Emitente = u.Codigo
	left join RemessasBancarias R on t.Remessa = r.NumeroRemessa
Where
	t.Remessa is not null and
	t.DataRemessa Between @DATAINI and @DATAFIN
Order by
	t.Remessa asc,
	t.DataVcto desc