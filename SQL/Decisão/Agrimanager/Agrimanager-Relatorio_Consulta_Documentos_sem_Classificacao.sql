Select Distinct
	D.Empresa,
	D.Sequencial,
	D.Emissao,
	D.DataRecebimento,
	D.Numero,
	D.TipoDoc,
	TD.Contab,
	D.TipoOperacao,
	O.Codigo,
	O.Descricao,
	D.Valor,
	MC.IdentLan,
	MC.Sequencial,
	MC.Tipo,
	MC.Conta,
	MC.Valor,
	D.usuoriginal "UsuReg",
	U1.Nome "DescUsuRegistro",
	D.CodUsuario "UsuAlt",
	U2.Nome "DescUsuAlteração"
From 
	Documentos D
	Left Join TiposDoc TD on (TD.Codigo = D.TipoDoc)
	Left Join Operacoes O on (O.Sequencial = D.TipoOperacao)
	Left Join MovContab MC on (MC.SeqDoc = D.Sequencial)
	Left Join Usuarios U1 on (U1.Codigo = D.usuoriginal)
	Left Join Usuarios U2 on (U2.Codigo = D.CodUsuario)
Where 
	TD.Contab = 'S' and 
	MC.IdentLan is null