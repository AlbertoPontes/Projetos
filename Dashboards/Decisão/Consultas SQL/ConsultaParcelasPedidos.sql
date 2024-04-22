Select
un.Descricao as UnidNegocio,
pa.Nome as Empresa,
pp.Sequencial,
pp.Numero,
pp.DataVcto,
pp.Tipo,
pp.Saldo2,
pp.Moeda2,
pb.Nome as Pessoa,
pc.Nome as Representante
from
ParcelaPedidos PP
Left Join UnidNegocios UN on pp.UnidNegocio = un.Codigo
Left Join Pessoas PA on pp.Empresa = pa.Codigo
Left Join Pessoas PB on pp.Pessoa = pb.Codigo
Left Join Pessoas PC on pp.Representante = pc.Codigo