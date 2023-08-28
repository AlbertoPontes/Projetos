Declare
@DATAINI Date,
@DATAFIM Date

Set @DATAINI = :pDataInicial
Set @DATAFIM = :pDataFinal

Select
	po.Numero as NUMERO,
	convert(varchar,po.DataElabor,103) as DATA,
	ma.Descricao as MATERIAL,
	po.AreaHa as AREA_HA,
	replace(po.LitrosKgHa,'.',',') as LITROS_KG_HA,
	replace(ip.QtdProdTanque,'.',',') as QTD_PROD_TANQUE,
	replace(ip.Dosagem,'.',',') as DOSAGEM,
	ta.Identificacao as TALHAO,
	un.Descricao as FAZENDA
From
	ItPlanejOper IP
	Left Join PlanejOper PO on ip.NumPlanej = po.Sequencial
	Left Join Materiais MA on ip.Produto = ma.Codigo
	Left Join UnidNegocios UN on po.Fazenda = un.Codigo
	Left Join Talhoes TA on po.Talhao = ta.Codigo
Where
	po.DataElabor between @DATAINI and @DATAFIM
	and po.TipoPlanej = 'PO'
	and un.Codigo in ('12', '5166', '5168', '6222')
	and un.Empresa in ('1', '313')
Order by
	po.DataElabor,
	po.Numero