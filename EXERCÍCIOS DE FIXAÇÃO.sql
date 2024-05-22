-- OPERADORES ARITMÉTICOS
SELECT pedidos.CodigoDoCliente, pedidos.Frete,
(Frete * 1.1) AS 'frete Aumentado em 10 porcento'
FROM pedidos;

-- OPERADORES COMPARAÇÃO
SELECT pedidos.NumeroDoPedido AS 'Numero de Pedido'
FROM pedidos
WHERE pedidos.NumeroDoPedido = 10285;

-- OPERADORES LÓGICOS
SELECT clientes.nomedaempresa, clientes.pais
FROM clientes
WHERE nomedaempresa LIKE 'A%'
ORDER BY 2 ASC;

#EXERCÍCIOS DE FIXAÇÃO

/*1 - Realizar uma consulta (SELECT) na tabela categorias que exiba: CodigoDaCategoria, NomeDaCategoria e a Descrição. */

SELECT CodigoDaCategoria, NomeDaCategoria, Descricao FROM categorias;

/*2 - Realizar uma consulta na tabela fornecedores realizar uma consulta que exiba: NomeDaEmpresa, NomeDoContato, endereço, telefone, homepage.*/

SELECT NomeDaEmpresa, NomeDoContato, endereco, telefone, homepage FROM fornecedores;

/*3 - Na tabela transportadoras realizar uma consulta que exiba: NomeDaEmpresa, Telefone.*/
SELECT NomeDaEmpresa, Telefone FROM transportadoras;

/*4 - Na tabela transportadoras inserir(INSERT) o seguinte dado: Mercado Livre, 4020 1735.*/
 INSERT INTO transportadoras (CodigoDaTransportadora,  NomeDaEmpresa, Telefone) 
VALUES 
(DEFAULT, "Mercado Livre", "4020 1735");

/*5 - Na tabela transportadoras excluir(DELETE) o cliente Mercado Livre.*/
DELETE FROM transportadoras
WHERE CodigoDaTransportadora = 4;

/*6 - O Gerente precisa de um relatório que exiba o nome da empresa e endereço de todos os clientes, a consulta deve ser ordenada pelo nome da empresa. (Pesquisar ORDER BY).*/
SELECT NomeDaEmpresa, Endereco FROM clientes 
ORDER BY NomeDaEmpresa ASC;

/*7 - O Gerente precisa de um relatório que exiba todos os pedidos que foram realizados entre os dias 01/09/1996 e 30/09/1996 (Pesquisar BETWEEN).*/
SELECT DataDoPedido FROM pedidos
WHERE dataDoPedido BETWEEN '1996-09-01' AND '1996-09-30';

/*8 - O Gerente precisa de um relatório que exiba o nome dos funcionário dos que começam com a letra P, a consulta deve ser ordenada pelo nome do funcionário (Pesquisar LIKE). O relatório deve conter: Nome, Cargo, telefone.*/
SELECT Nome, Cargo, TelefoneResidencial FROM funcionarios
WHERE Nome LIKE 'P%';

/* 9 - O Gerente precisa de um relatório que exiba o nome do cliente, número do pedido e a data da entrega de todos os clientes cuja primeira letra do nome comece com a letra A, a consulta deve ser ordenada pelo nome do cliente (Pesquisar LIKE).*/

SELECT clientes.NomeDoContato, pedidos.NumeroDoPedido, pedidos.DataDeEntrega
FROM clientes 
INNER JOIN pedidos 
ON pedidos.codigoDoCliente = clientes.codigoDoCliente
WHERE clientes.NomeDoContato LIKE 'A%';

/*10 - Crie uma consulta para exibir o total vendido por código do produto.*/
SELECT d.numerodopedido, d.CodigoDoProduto, d.precounitario, d.quantidade, d.desconto
FROM detalhesdopedido d
WHERE d.NumeroDoPedido = 10248;

SELECT d.NumeroDopedido AS 'Numero Do pedido', d.CodigoDoProduto AS 'Codigo Do Produto',
SUM(d.precounitario * d.quantidade * (1 - d.desconto)) AS 'Total Vendido'
FROM detalhesdopedido d
WHERE d.NumeroDoPedido = 10248
GROUP BY d.CodigoDoProduto;

/*11 - Correção do código*/
SELECT cli.NomeDaEmpresa AS cliente,
pe.NumeroDoPedido AS pedidos,
pe.DataDeEntrega
FROM clientes AS cli
INNER JOIN pedidos AS pe
ON cli.CodigoDoCliente = pe.CodigoDoCliente
ORDER BY cli.NomeDaEmpresa, pe.NumeroDoPedido;

/*12 - O cliente necessita de um relatório que apresente: nome do cliente, nome do cargo e país (da tabela clientes),  número do pedido, data do pedido e data da entrega (da tabela pedidos). O relatório deve incluir apenas as entregas realizadas entre 01/09/1996 e 30/08/1996. Além disso, o relatório deve ser ordenado pela data da entrega.*/
SELECT clientes.NomeDoContato, clientes.CargoDoContato, clientes.Pais,
pedidos.NumeroDoPedido, pedidos.DataDoPedido, pedidos.DataDeEntrega
FROM clientes
INNER JOIN pedidos
ON clientes.CodigoDoCliente = pedidos.CodigoDoCliente
WHERE DataDeEntrega 
BETWEEN "1996-08-30" AND "1996-09-01";

/*13 - O cliente necessita de um relatório que apresente o nome do produto e o nome do fornecedor. O relatório deve ser ordenado pelo nome do fornecedor.*/

 SELECT produtos.NomeDoProduto, fornecedores.NomeDoContato
 FROM produtos
 INNER JOIN fornecedores
 ON produtos.CodigoDoFornecedor = Fornecedores.CodigoDoFornecedor
 ORDER BY Fornecedores.NomeDoContato ASC;

/*14 - O Gerente de vendas necessita de um relatório contendo o nome do contato (CLIENTES), o número do pedido (PEDIDOS) e o nome do funcionário (FUNCIONARIOS) responsável pela venda. O relatório deve ser ordenado pelo nome do funcionário.*/
 SELECT clientes.NomeDoContato, pedidos.NumeroDoPedido, funcionarios.nome
 FROM clientes
 INNER JOIN pedidos
 ON clientes.CodigoDoCliente = pedidos.CodigoDoCliente
 INNER JOIN funcionarios
 ON pedidos.CodigoDoFuncionario = funcionarios.CodigoDoFuncionario
 ORDER BY funcionarios.nome ASC;
 
/*15 - O gerente do departamento de logística requer um relatório que apresente o nome da transportadora e a cidade de destino, referentes às entregas realizadas durante o período de 01/09/1996 a 30/09/1996 e cuja cidade de destino seja Londres (TRANSPORTADORAS E PEDIDOS)*/
SELECT transportadoras.NomeDaEmpresa, pedidos.CidadeDeDestino
FROM transportadoras
INNER JOIN pedidos
ON transportadoras.CodigoDaTransportadora = pedidos.CodigoDaTransportadora
WHERE DataDeEntrega 
BETWEEN "1996-09-01" AND "1996-09-30" 
AND CidadeDeDestino LIKE "Londres%";

/*16 - O gerente do departamento de logística solicita um relatório que apresente o nome da transportadora e a soma total dos valores recebidos pelo frete, referentes às entregas realizadas durante o período de 01/09/1996 a 30/09/1996 (TRANSPORTADORAS E PEDIDOS). O relatório deve AGRUPAR os resultados pelo nome da transportadora.*/
SELECT transportadoras.NomeDaEmpresa, SUM(pedidos.frete) AS 'Total de Frete'
FROM transportadoras
INNER JOIN pedidos 
ON transportadoras.CodigoDaTransportadora = pedidos.CodigoDaTransportadora
WHERE DataDeEntrega BETWEEN "1996-09-01" AND "1996-09-30"
GROUP BY transportadoras.NomeDaEmpresa;

/*17 - O gerente do departamento de logística solicita um relatório que apresente cidade de destino do pedido e a soma total dos valores recebidos pelo frete, referentes às entregas realizadas durante o período de 01/09/1996 a 30/09/1996 ( PEDIDOS). O relatório deve AGRUPAR os resultados pela cidade de destino.*/
SELECT pedidos.CidadeDeDestino, SUM(pedidos.frete) AS 'Receita de Frete' 
FROM pedidos
WHERE DataDeEntrega BETWEEN "1996-09-02" AND "1996-09-30"
GROUP BY pedidos.CidadeDeDestino
ORDER BY pedidos.CidadeDeDestino ASC;

SELECT pedidos.PaisDeDestino, SUM(pedidos.frete) AS total
FROM pedidos
GROUP BY pedidos.PaisDeDestino
ORDER BY pedidos.PaisDeDestino;

#PRATICANDO

/*01 - O cliente precisa de um relatório que exiba o total faturado com o frete por país de destino.*/
SELECT pedidos.PaisDeDestino, SUM(pedidos.frete) AS 'Total Faturado'
FROM pedidos
GROUP BY pedidos.PaisDeDestino
ORDER BY pedidos.PaisDeDestino ASC;

/*02 - Escreva uma consulta SQL que liste o nome do funcionário e o total de pedidos realizados por cada funcionário.*/
SELECT funcionarios.nome, COUNT(pedidos.NumeroDoPedido) AS 'total de pedidos'
FROM funcionarios
INNER JOIN pedidos
ON funcionarios.CodigoDoFuncionario = pedidos.CodigoDoFuncionario
GROUP BY funcionarios.nome
ORDER BY funcionarios.nome ASC;

/*03 - Criar um relatório que exiba nome da transportadora, país da entrega do pedido e o valor total do frete, a valor deve estar no formato 0.000,00. O relatório deve ser ordenado pelo nome da transportadora.*/
SELECT transportadoras.NomeDaEmpresa, pedidos.PaisDeDestino,  
FORMAT(SUM(pedidos.frete), '0.000,00') AS TotalDePedidos 
FROM transportadoras
JOIN pedidos
ON transportadoras.CodigoDaTransportadora = pedidos.CodigoDaTransportadora
GROUP BY transportadoras.NomeDaEmpresa, pedidos.PaisDeDestino
ORDER BY transportadoras.NomeDaEmpresa, pedidos.PaisDeDestino;

/*04 - Criar um relatório que exiba o cliente, produto, quantidade de produto e o valor total, ordenar o relatório pelo nome do cliente, produto.*/
SELECT clientes.NomeDoContato, produtos.NomeDoProduto, detalhesdopedido.Quantidade
FROM clientes
INNER JOIN pedidos
ON clientes.CodigoDoCliente = pedidos.CodigoDoCliente
INNER JOIN DetalhesDoPedido
ON pedidos.NumeroDoPedido = DetalhesDoPedido.NumeroDoPedido 
INNER JOIN produtos
ON DetalhesDoPedido.CodigoDoProduto = produtos.CodigoDoProduto;

/*05 - Criar um relatório que exiba o total de funcionários.*/
SELECT COUNT(Nome) AS 'Total de Funcionários' FROM Funcionarios;

#HAVING

/*06 - O cliente precisa de um relatório que exiba os produtos que foram vendidos acima de 999 unidades. (pedidos, detalhesdopedido, produto)*/
SELECT pedidos.NumeroDoPedido, produtos.NomeDoProduto, DetalhesdoPedido.Quantidade
FROM pedidos
INNER JOIN DetalhesdoPedido
ON pedidos.NumeroDoPedido =  DetalhesdoPedido.NumeroDoPedido
INNER JOIN produtos
ON DetalhesdoPedido.CodigoDoProduto = produtos.CodigoDoProduto
WHERE DetalhesdoPedido.Quantidade > 999
ORDER BY DetalhesdoPedido.Quantidade;

/*07 - O Cliente deseja saber todos os produtos que foram vendidos com desconto.*/
SELECT produtos.NomeDoProduto, DetalhesdoPedido.Desconto
FROM produtos
INNER JOIN DetalhesdoPedido
ON DetalhesdoPedido.CodigoDoProduto = produtos.CodigoDoProduto
WHERE DetalhesdoPedido.Desconto NOT IN (0);

/*08 - Selecione o nome do produto, a quantidade total vendida e o preço médio de venda para cada produto.*/
SELECT produtos.NomeDoProduto, COUNT(DetalhesdoPedido.Quantidade) AS 'Total Vendida',
AVG(DetalhesdoPedido.PrecoUnitario) 'Preço Médio' 
FROM produtos
INNER JOIN DetalhesdoPedido
ON DetalhesdoPedido.CodigoDoProduto = produtos.CodigoDoProduto
GROUP BY produtos.NomeDoProduto;
