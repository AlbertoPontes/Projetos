SELECT
    ROW_NUMBER() OVER (ORDER BY t.Sequencial) as Indice,
    t.Sequencial,
    t.EMISSAO as Data_Lancamento,
    t.DataVcto as Data_Vencimento,
    td.Tipo,
    d.Numero as Documento,
    un.Descricao as Unidade_Negocio,
    ta.Descricao as CR,
    l.Descricao as CR_2,
    t.Valor,
    t.Saldo as P_R,
    t.Observacao1 as Observacao,
    p.Nome
FROM
    Titulos T
	LEFT JOIN Documentos D ON t.SeqDoc = d.Sequencial
	LEFT JOIN TiposDoc TD ON d.TipoDoc = td.Codigo
	LEFT JOIN UnidNegocios UN ON d.Emitente = un.Codigo
	LEFT JOIN Pessoas P ON d.Pessoa = p.Codigo
	LEFT JOIN ClassifFinanc CF ON d.Sequencial = cf.IdentDoc
	LEFT JOIN Locais L ON cf.CResultado = l.Codigo
	LEFT JOIN Tabelas TA ON l.Tipo = ta.Codigo AND ta.Tipo = '16'