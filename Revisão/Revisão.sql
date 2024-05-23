-- 01 --
SELECT NomeDaEmpresa, Telefone FROM transportadoras;

-- 02 --
SELECT NomeDaCategoria, Descricao FROM categorias
ORDER BY NomeDaCategoria;

-- 03 --
SELECT clientes.NomeDoContato, 
COUNT(pedidos.NumeroDopedido) AS TotalPedidos 
FROM clientes
JOIN pedidos
ON clientes.CodigoDoCliente = pedidos.CodigoDoCliente
GROUP BY clientes.NomeDoContato
ORDER BY clientes.NomeDoContato;

-- 04 --
SELECT produtos.NomeDoProduto, categorias.NomeDaCategoria, categorias.CodigoDaCategoria 
FROM Produtos
INNER JOIN categorias
ON produtos.CodigoDaCategoria = categorias.CodigoDaCategoria
ORDER BY produtos.NomeDoProduto;

-- 05 --
SELECT COUNT(CodigoDoCliente) AS TotalPedidos
FROM pedidos
WHERE CodigoDoCliente = 'ANATR';

-- 06 --
SELECT AVG(PrecoUnitario) AS PrecoMedio
FROM produtos;

-- 07 --
SELECT CodigoDoProduto, NomeDoProduto, PrecoUnitario 
FROM produtos
WHERE PrecoUnitario > 28.00;

-- 08 --
SELECT CodigoDoCliente, Frete, (Frete * 1.2) AS frete_aumentado_em_20_porcento
FROM pedidos;

-- 09 --
SELECT NumeroDoPedido, NomeDoDestinatario
FROM pedidos
WHERE NumeroDoPedido IN (10248, 10253, 10289, 10308, 10516);

