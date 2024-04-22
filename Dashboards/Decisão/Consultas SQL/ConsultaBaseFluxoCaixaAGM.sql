/*Tipo 0 Detalhamento*/
/*Disponibilidade Por Empresa/Conta */
Select Space(1) as Status,Convert(DateTime,GetDate(),103) as Emissao,Convert(DateTime,GetDate(),103) as DataVcto,Space(100) as Hist1,
Space(100) as Hist2,1 as Ordem,P.Nome as DescChave, Space(50) as Mae,'0'+RTRIM(P.Nome) as Id,
DateAdd(day,-1,GetDate()) as Data,
0.00 as Entrada,0.00 as Saida,
Sum(dbo.ConverteMoeda(1,1,getDate(),dbo.fnBuscaGetSaldoFin(CC.Sequencial,CC.pessoa,'N'))) as Saldo 
,space(1) M1, Space(1) M2,0.00 as EntradaO,0.00 as SaidaO
From
ContasCorrentes CC,Pessoas P,Pessoas AG
Where CC.Pessoa=P.Codigo And AG.Codigo=CC.AgtFin
And CC.pessoa=313
And CC.Fluxo='S'
And CharIndex('E1',P.Tipo)<>0
and (IsNull(CC.UnidNegocio, 0) = 0
 or cc.UnidNegocio in (8493,5167,5884,5168,5166,5885,6222,7669,331,6955) )
And CC.Tipo in(1,3,4,7,8,9,10,11,12,13,14)
And dbo.GetSaldoFin(CC.ContaCTB,CC.pessoa,Getdate()) <> 0
Group by P.Nome
UNION ALL
Select Space(1) as Status,Convert(DateTime,GetDate(),103) as Emissao,Convert(DateTime,GetDate(),103) as DataVcto,
Space(100) as Hist1,Space(100) as Hist2,1 as Ordem,Rtrim(Substring(AG.Nome,1,40))+Space(1)+CC.CtaBanc as DescChave,
'0'+RTRIM(P.Nome) as Mae, RTRIM(Substring(AG.Nome,1,40))+RTRIM(CC.CtaBanc) as Id,
DateAdd(day,-1,GetDate()) as Data,
0.00 as Entrada,0.00 as Saida,
dbo.ConverteMoeda(1,1,getDate(),dbo.fnBuscaGetSaldoFin(CC.Sequencial,CC.pessoa,'N')) as Saldo 
,Space(1) M1, Space(1) M2,0.00 as EntradaO,0.00 as SaidaO
From
ContasCorrentes CC,Pessoas P,Pessoas AG
Where CC.Pessoa=P.Codigo And AG.Codigo=CC.AgtFin
And CC.pessoa=313
And CC.Fluxo='S'
And CharIndex('E1',P.Tipo)<>0
and (IsNull(CC.UnidNegocio, 0) = 0
or Cc.UnidNegocio in (8493,5167,5884,5168,5166,5885,6222,7669,331,6955))
And CC.Tipo in(1,3,4,7,8,9,10,11,12,13,14)
And dbo.GetSaldoFin(CC.ContaCTB,CC.pessoa,Getdate()) <> 0
Union all
/*Query Fill Periodo*/
Select Space(1) as Status,Convert(DateTime,GetDate(),103) as Emissao,Convert(DateTime,GetDate(),103) as DataVcto,Space(100) as Hist1,Space(100) as Hist2,
2 as Ordem,Id as DescChave,Space(100) as Mae,Convert(char(100),'A'+Id) as Id,Data,Entrada,Saida,
COnvert(Float,0.00) as Saldo
,Space(1) M1, Space(1) M2, Convert(Float,0) EntradaO,Convert(Float,0) SaidaO
from(
Select Sum(E1.Entrada) as Entrada,Sum(E1.Saida) as Saida,E1.Data,E1.Id
,Space(1) M1, Space(1) M2, Convert(Float,0) EntradaO,Convert(Float,0) SaidaO
From (
 Select T.DataVcto as Data,convert(char(50),T.DataVcto,103) as Id,
 Sum(Case When TD.Tipo='E' Then dbo.ConverteMoeda(T.Moeda2,1,GetDate(),Saldo2) Else 0 End) as Entrada,
 Sum(Case When TD.Tipo='S' Then dbo.ConverteMoeda(T.Moeda2,1,GetDate(),abs(Saldo2)) Else 0 End) as Saida
--1ggggggggggggggggggg
,Space(1) M1, Space(1) M2,0 as EntradaO, 0 as SaidaO
 From TitulosUNDNEG T,Documentos D,Pessoas P,TiposDoc TD,Pessoas EP
 Where Isnull(D.SituacaoEF,space(1))<>'S' and T.SeqDoc=D.Sequencial and P.Codigo=D.Pessoa And EP.Codigo=D.Empresa
AND ISNULL(D.TipoOrigem,SPACE(1)) <> 'R'
 And TD.Codigo=D.TipoDoc And T.DataVcto>='02/21/2024' And T.DataVcto<='06/20/2024'
 and (T.UnidNegocio in (8493,5167,5884,5168,5166,5885,6222,7669,331,6955) or T.UnidNegocio=0)
 And T.Saldo2<>0
 And D.Empresa=313
 And T.Moeda2=1
 Group By T.DataVcto,convert(char(50),T.DataVcto,103)
, T.Moeda2
Union all
/*Previsao - Somente Previstos ou Todos*/
 Select T.DataVcto as Data,convert(char(50),T.DataVcto,103) as Id,
 Sum(Case When T.Tipo='E' Then dbo.ConverteMoeda(T.Moeda2,1,GetDate(),Saldo2) Else 0 End) as Entrada,
 Sum(Case When T.Tipo='S' Then dbo.ConverteMoeda(T.Moeda2,1,GetDate(),abs(Saldo2)) Else 0 End) as Saida
--gggggggggggg2
,Space(1) M1, Space(1) M2, 0 EntradaO, 0 SaidaO
 From ParcelaPedidos T,Pessoas P,Pessoas EP
 Where  P.Codigo=T.Pessoa And EP.Codigo=T.Empresa
 And T.DataVcto>='02/21/2024' And T.DataVcto<='06/20/2024'
 and (T.UnidNegocio in (8493,5167,5884,5168,5166,5885,6222,7669,331,6955) )
 And T.Saldo2<>0
 And T.Empresa=313
 And T.Moeda2=1
 Group By T.DataVcto,convert(char(50),T.DataVcto,103)
, T.Moeda2
) as E1 Group By E1.ID,E1.Data
) as E3
Union all
/*Query Fill Periodo*/
Select Space(1) as Status,Convert(DateTime,GetDate(),103) as Emissao,Convert(DateTime,GetDate(),103) as DataVcto,Space(100) as Hist1,Space(100) as Hist2,0 as Ordem,Id as DescChave,Space(100) as Mae,Convert(char(100),' '+Id) as Id,Data,Entrada,Saida,
COnvert(Float,0.00) as Saldo
,Space(1) M1, Space(1) M2, Convert(Float,0) EntradaO,Convert(Float,0) SaidaO
from(
Select Sum(E1.Entrada) as Entrada,Sum(E1.Saida) as Saida,E1.Data,E1.Id
,Space(1) M1, Space(1) M2, Convert(Float,0) EntradaO,Convert(Float,0) SaidaO
From (
 Select T.DataVcto as Data,convert(char(50),T.DataVcto,103) as Id,
 Sum(Case When TD.Tipo='E' Then dbo.ConverteMoeda(T.Moeda2,1,GetDate(),Saldo2) Else 0 End) as Entrada,
 Sum(Case When TD.Tipo='S' Then dbo.ConverteMoeda(T.Moeda2,1,GetDate(),abs(Saldo2)) Else 0 End) as Saida
--1ggggggggggggggggggg
,Space(1) M1, Space(1) M2,0 as EntradaO, 0 as SaidaO
 From TitulosUNDNEG T,Documentos D,Pessoas P,TiposDoc TD,Pessoas EP
 Where Isnull(D.SituacaoEF,space(1))<>'S' and T.SeqDoc=D.Sequencial and P.Codigo=D.Pessoa And EP.Codigo=D.Empresa
AND ISNULL(D.TipoOrigem,SPACE(1)) <> 'R'
 And TD.Codigo=D.TipoDoc And T.DataVcto>='12/30/1899' And T.DataVcto<='02/20/2024'
 and (T.UnidNegocio in (8493,5167,5884,5168,5166,5885,6222,7669,331,6955) or T.UnidNegocio=0)
 And T.Saldo2<>0
 And D.Empresa=313
 And T.Moeda2=1
 Group By T.DataVcto,convert(char(50),T.DataVcto,103)
, T.Moeda2
Union all
/*Previsao - Somente Previstos ou Todos*/
 Select T.DataVcto as Data,convert(char(50),T.DataVcto,103) as Id,
 Sum(Case When T.Tipo='E' Then dbo.ConverteMoeda(T.Moeda2,1,GetDate(),Saldo2) Else 0 End) as Entrada,
 Sum(Case When T.Tipo='S' Then dbo.ConverteMoeda(T.Moeda2,1,GetDate(),abs(Saldo2)) Else 0 End) as Saida
--gggggggggggg2
,Space(1) M1, Space(1) M2, 0 EntradaO, 0 SaidaO
 From ParcelaPedidos T,Pessoas P,Pessoas EP
 Where  P.Codigo=T.Pessoa And EP.Codigo=T.Empresa
 And T.DataVcto>='12/30/1899' And T.DataVcto<='02/20/2024'
 and (T.UnidNegocio in (8493,5167,5884,5168,5166,5885,6222,7669,331,6955) )
 And T.Saldo2<>0
 And T.Empresa=313
 And T.Moeda2=1
 Group By T.DataVcto,convert(char(50),T.DataVcto,103)
, T.Moeda2
) as E1 Group By E1.ID,E1.Data
) as E3