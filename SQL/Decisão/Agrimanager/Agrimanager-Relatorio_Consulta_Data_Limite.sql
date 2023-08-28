Declare
@DATAINI Date,
@DATAFIN Date

SET @DATAINI = :pDataInicial
SET @DATAFIN = :pDataFinal

Select
	so.NumeroSolic,
	isnull (convert(varchar, it.DATA_LIMITE, 103), '') as DATA_LIMITE,
	isnull (convert(varchar, SO.Data, 103), '') as DATA_DIGITACAO,
	isnull (convert(varchar, SO.DataAutoriz, 103), '') as DATA_AUTORIZACAO_SOLICITACAO,
	isnull (convert(varchar, it.DATA_COTACAO, 103), '') as DATA_COTACAO,
	isnull ( convert ( varchar, it.Nome), '') as COMPRADOR,
	un.Descricao as UNIDADE_NEGOCIO
From
	Solicitacoes SO
		left join  (
					Select Distinct
						ic.SequencialSolic,
						ic.DataLimite as DATA_LIMITE,
						ic.DataCotacao as DATA_COTACAO,
						p.Nome
					From
						ItensSolic IC
						left join Pessoas P on ic.Comprador = p.Codigo
					) IT on so.SequencialSolic = it.SequencialSolic
		left join 
					UnidNegocios UN on so.LocalEntrega = un.Codigo
Where
it.DATA_LIMITE Between @DATAINI and @DATAFIN
Order By
it.DATA_LIMITE
Desc