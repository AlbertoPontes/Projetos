Declare
	@DATAINICIAL Date,
	@DATAFINAL Date

Set @DATAINICIAL = :pDataInicial
Set @DATAFINAL = :pDataFinal

Select
	X.SeqDespesa as SEQ_CTE,
	Y.Numero as NUMERO_CTE,
	Y.Nome as TRANSPORTADORA,
	Y.ValorTotal as VALOR_CTE,
	X.Sequencial as SEQ_NF,
	X.Numero as NUMERO_NF,
	X.Nome as FORNECEDOR,
	Z.Qtd as QUANTIDADE,
	X.ValorTotal as VALOR_NF,
	Z.Descricao as FAZENDA,
	X.Emissao as EMISSAO,
	X.TipoDoc as TIPO_DOC,
	X.Data_Recebimento as DATA_RECEBIMENTO
From
	(
		Select
			P.SeqDespesa,
			P.SeqDoc,
			D.Sequencial,
			D.Numero,
			PE.Nome,
			Convert(Varchar, D.Emissao, 103) as Emissao,
			T.Descricao TipoDoc,
			D.ValorTotal,
			Convert(Varchar, D.DataRecebimento, 103) as Data_Recebimento
		From
			Documentos D
			Join TiposDoc T on D.TipoDoc = T.Codigo
			Join DespesasDocumentos P on P.SeqDoc = D.Sequencial
			Join Pessoas PE on D.Pessoa = PE.Codigo
		Where
			D.DataRecebimento BETWEEN @DATAINICIAL AND @DATAFINAL
	) as x
	Join
	(
		Select
			D.Sequencial,
			P.SeqDoc,
			D.Numero,
			PE.Nome,
			Convert(Varchar, D.Emissao, 103) as Emissao,
			T.Descricao TipoDoc,
			D.ValorTotal,
			Convert(Varchar, D.DataRecebimento, 103) as Data_Recebimento
		From
			Documentos D
			Join TiposDoc T on D.TipoDoc = T.Codigo
			Join DespesasDocumentos P on P.SeqDespesa = D.Sequencial
			Join Pessoas PE on D.Pessoa = PE.Codigo
		Where
			D.DataRecebimento BETWEEN @DATAINICIAL AND @DATAFINAL
			AND (D.Pessoa in :pPessoa or 0 in :pPessoa )
	) y on x.SeqDoc = y.SeqDoc
	Join
	(
		Select
			D.Sequencial,
			D.Numero,
			U.Descricao,
			Sum(I.Qtd) as Qtd
		From
			Documentos D
			Join ItensDocumento I on D.Sequencial = I.Sequencial
			Join UnidNegocios U on D.Emitente = U.Codigo
		Group By
			D.Sequencial,
			D.Numero,
			U.Descricao
	) as Z on X.Sequencial = Z.Sequencial
Order By
	Y.Numero,
	X.SeqDespesa,
	X.Numero,
	Y.Nome,
	Y.ValorTotal,
	X.Sequencial,
	X.Nome,
	X.Emissao,
	X.TipoDoc,
	X.ValorTotal,
	X.Data_Recebimento