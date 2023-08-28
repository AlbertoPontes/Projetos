Declare
	@DATAINI Date,
	@DATAFIM Date

	Set @DATAINI = :pDataInicial
	Set @DATAFIM = :pDataFInal

Select
	d.Numero as NUMERO_NF,
	d.Sequencial as SEQUENCIAL,
	convert(varchar,d.Emissao,103) as DATA_EMISSAO,
	p.Nome as PESSOA,
	a.Descricao as DESCRICAO,
	t.Descricao as TIPO_DOCUMENTO,
	a.Caminho as CAMINHO,
	u.Descricao as UNIDADE_NEGOCIO
From
	Documentos D
	Left Join Anexo A on a.Numero = d.Sequencial
	Left Join Pessoas P on d.Pessoa = p.Codigo
	Left Join UnidNegocios U on d.Emitente = u.Codigo
	Left join TiposDoc T on d.TipoDoc = t.Codigo
Where
	U.Codigo in ('12', '3339', '5166', '5167', '5168', '6222', '6955') and
	d.Emissao Between @DATAINI and @DATAFIM
Order By
	d.Sequencial,
	d.Emissao