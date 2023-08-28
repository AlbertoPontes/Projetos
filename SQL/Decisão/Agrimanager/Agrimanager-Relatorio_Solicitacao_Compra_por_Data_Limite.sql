Declare 
@DATAINI Date,
@DATAFIN Date

Set @DATAINI = :pDataInicial
Set @DATAFIN = :pDataFinal

Select Distinct
	Isnull (str(so.NumeroSolic), '') as NUMERO_SOLICITACAO,
	Isnull (convert(varchar, ic.DATA_DIG, 103), '') as DATA_DIGITACAO_SOLICITACAO,
	convert (varchar, ic.DATA_LIMITE, 103) as DATA_LIMITE_SOLICITACAO,
	Isnull (convert(varchar, dc.DtRecebe, 103),'NAO RECEBIDO') as DATA_RECEBIMENTO,
	Isnull (convert(varchar, datediff (day, ic.DATA_LIMITE, dc.DtRecebe)) + ' DIAS', '') as DIAS_ATRASO,
	Isnull (ps.Nome, '') as USUARIO_SOLICITACAO,
	Isnull (un.Descricao, '') as UNIDADE_NEGOCIO,
	Isnull (str(ic.Cotacao), '') as NUMERO_COTACAO,
	iSNULL (po.Nome, '') as COMPRADOR,
	Isnull (convert(varchar,ic.DATA_AUTO, 103), '') as DATA_AUTORIZACAO_COTACAO,
	Isnull (str(cp.NumeroOC), '') as NUMERO_OC,
	Isnull (str(dc.Numero), '') as NUMERO_DOCUMENTO,
	Isnull (str(dc.Sequencial), '') as SEQUENCIAL_DOCUMENTO,
	Isnull (convert(varchar, dc.Emissao, 103), '') as DATA_EMISSAO_DOCUMENTO,
	Isnull (convert(varchar, dc.DataDig, 103), '') as DATA_DIGITACAO_DOCUMENTO,
	Isnull (pe.Nome, '') as USUARIO_DIGITACAO_DOCUMENTO
From
	Solicitacoes SO
		left join
				(
				Select
					ie.SequencialSolic,
					ie.Cotacao,
					ie.DataLimite as DATA_LIMITE,
					ie.DataAlteracaoSolic as DATA_DIG,
					ie.DataAutCotacao as DATA_AUTO,
					ie.UserAlteracaoSolic,
					ie.Comprador
				From
					ItensSolic IE
				Group by
					ie.SequencialSolic,
					ie.Cotacao,
					ie.DataLimite,
					ie.DataAlteracaoSolic,
					IE.DataAutCotacao,
					ie.UserAlteracaoSolic,
					ie.Comprador
				) IC on so.SequencialSolic = ic.SequencialSolic
		left join
				(
				Select
					co.Cotacao,
					co.SequencialSolic
				From
					CotacaoMat CO
				) CM on so.SequencialSolic = cm.SequencialSolic
		left join 
				(
				Select
					co.NumeroOC,
					co.Data as DATA_OC,
					ic.SequencialOC,
					ic.Cotacao,
					co.Empresa
				From
					Compras CO
						left join
								(
								Select
									ia.SequencialOC,
									ia.Cotacao
								From
									ItensCompra IA
								Group by
									ia.SequencialOC,
									ia.Cotacao
								) IC on co.SequencialOC = ic.SequencialOC
				) CP on cm.Cotacao = cp.Cotacao
		left join
				(
				Select
					do.Numero,
					do.Sequencial,
					do.Emissao,
					do.DataDig,
					do.usuoriginal,
					id.SEQUENCIALOC,
					id.DtRecebe
				From
					Documentos DO
						left join 
								(
								Select
									it.SEQUENCIALOC,
									it.Sequencial, 
									it.DtRecebe
								From
									ItensDocumento IT
								Group by
									it.SEQUENCIALOC,
									it.Sequencial,
									it.DtRecebe
								) ID on do.Sequencial = id.Sequencial
				) DC on cp.SequencialOC = dc.SEQUENCIALOC
		left join Pessoas PE on dc.usuoriginal = pe.Codigo
		left join UnidNegocios UN on so.LocalEntrega = un.Codigo
		left join Pessoas PS on ic.UserAlteracaoSolic = ps.Codigo
		left join Pessoas PO on ic.Comprador = po.Codigo
Where
	ic.DATA_LIMITE Between @DATAINI and @DATAFIN