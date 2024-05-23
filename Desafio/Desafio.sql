-- SUB-SELECT
SELECT clientes.NomeDoContato
FROM clientes
WHERE codigodocliente IN (SELECT codigodocliente FROM pedidos);

-- LEFT JOIN
SELECT clientes.CodigoDoCliente AS 'Código', clientes.NomeDaEmpresa AS 'Empresa', 
pedidos.DataDoPedido AS 'Data do Pedido'
FROM clientes
LEFT JOIN pedidos
ON clientes.CodigoDoCliente = pedidos.CodigoDoCliente
order by 3;

/* EXPORTA EM CSV 
ABRIR NO GOOGLE PLANILHA
CRIAR UM GRÁFICO
*/
SELECT pedidos.RegiaoDeDestino, SUM(detalhesdopedido.PrecoUnitario) AS 'Preço'
FROM pedidos
INNER JOIN detalhesdopedido
ON pedidos.NumeroDoPedido = detalhesdopedido.NumeroDoPedido
WHERE pedidos.RegiaoDeDestino IS NOT NULL
GROUP BY pedidos.RegiaoDeDestino;
