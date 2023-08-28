Declare
	@DATAINICIAL Date,
	@DATAFINAL Date

	Set @DATAINICIAL = '2023/01/01'
	Set @DATAFINAL = '2023/01/31'


SELECT
	@DATAINICIAL as Data_Inicial,
	@DATAFINAL as Data_Final,
    Identificacao,
    Descricao as Maquina,
    UnidadeNegocio as Fazenda,
    DataAquisicao as Data_Aquisicao,
    ValorAquisicao as Valor_Aquisicao,
	KM_HOR as KM_HR,
    Valor_Combustivel,
    Valor_Total_Pecas,
    (Valor_Servicos_A + Valor_Servicos_B) AS Valor_Total_Servicos,
	(Valor_Total_Pecas + Valor_Servicos_A + Valor_Servicos_B) as Valor_Pecas_Servicos
FROM (
    SELECT
        B.Identificacao,
        B.Descricao,
        B.UnidMedida,
        U.Descricao AS UnidadeNegocio,
        B.DataAquisicao,
        B.ValorAquisicao,
		CASE WHEN B.UnidMedida = 'H' THEN Max(d.Horimetro) - Min(d.Horimetro) WHEN b.UnidMedida = 'K' THEN Max(d.KM) - Min(d.KM) Else 0 End as KM_HOR,
        SUM(CASE WHEN m.Grupo = '1' AND t.tipo ='9' THEN i.Valor ELSE 0 END) AS Valor_Combustivel,
        SUM(CASE WHEN m.Grupo IN (277, 280, 255, 237, 5, 278, 211, 272, 279, 273, 212, 66, 274, 250) AND t.tipo ='9' THEN i.Valor ELSE 0 END) AS Valor_Total_Pecas,
        SUM(CASE WHEN m.Grupo NOT IN (1, 277, 280, 255, 237, 5, 278, 211, 272, 279, 273, 212, 66, 274, 250) AND t.tipo ='9' THEN i.Valor ELSE 0 END) AS Valor_Servicos_A,
        ISNULL(SUM(s.Valor), 0) AS Valor_Servicos_B,
        SUM(CASE WHEN m.Grupo IN (277, 280, 255, 237, 5, 278, 211, 272, 279, 273, 212, 66, 274, 250) AND t.tipo ='9' OR m.Grupo NOT IN (1, 277, 280, 255, 237, 5, 278, 211, 272, 279, 273, 212, 66, 274, 250) AND t.tipo ='9' THEN i.Valor ELSE 0 END) AS Valor_Pecas_Servicos
    FROM
        DocEstoque D
        LEFT JOIN Bens B ON d.Destino = b.Codigo
        LEFT JOIN UnidNegocios U ON b.UnidadeNegocio = u.Codigo
        LEFT JOIN ItDocEstoque I ON i.SeqMov = d.Sequencial
        LEFT JOIN Materiais M ON i.Produto = m.Codigo
        LEFT JOIN Tabelas T ON m.Grupo = t.Codigo
        LEFT JOIN ServicoExcOS S ON d.Sequencial = s.SeqMov
    WHERE
        D.Data BETWEEN @DATAINICIAL AND @DATAFINAL
        AND b.Propriedade = 'P'
        AND b.Grupo IN (50,26,24,67,25,55,28,57,17,66,64,52,34,56,53,29,27,49,59,31,58,18,16,33,60,48,65,69)
        AND u.Empresa = '313'
    GROUP BY
        b.Identificacao,
        b.Descricao,
        b.UnidMedida,
        u.Descricao,
        b.DataAquisicao,
        b.ValorAquisicao
) Subconsulta;