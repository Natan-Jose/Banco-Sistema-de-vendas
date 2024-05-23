SHOW DATABASES;

-- FUNCTION
DELIMITER $$
CREATE FUNCTION calcular_idade_funcionario(data_nascimento DATE)
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE idade INT;
    SET idade = YEAR(CURRENT_DATE()) - YEAR(data_nascimento);
    IF MONTH(CURRENT_DATE()) < MONTH(data_nascimento)
    OR (MONTH(CURRENT_DATE()) = MONTH(data_nascimento) AND DAY(CURRENT_DATE()) < DAY(data_nascimento)) THEN
        SET idade = idade - 1;
    END IF;
    IF idade <= 0 THEN
        RETURN NULL; 
    ELSE
        RETURN idade;
    END IF;
END $$
DELIMITER ;

SELECT Nome, SobreNome, calcular_idade_funcionario(DataDeNascimento) AS Idade FROM Funcionarios;

-- TRIGGERS
DELIMITER $$
CREATE TRIGGER before_delete_trigger
BEFORE DELETE ON clientes
FOR EACH ROW
BEGIN
DECLARE num_linhas INT;
SET num_linhas = (SELECT COUNT(*) FROM clientes);

IF num_linhas > 1 THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Não é permitido excluir mais
de uma linha!';
END IF;
END $$
DELIMITER ;

SELECT codigodocliente FROM clientes LIMIT 2;

DELETE FROM clientes 
WHERE CodigoDoCliente 
IN ('HUNGO', 'WOLZA');

/*VIEWS

01*/
CREATE OR REPLACE VIEW vw_relatorio_pedidos_produtos_clientes
AS
SELECT clientes.NomeDaEmpresa AS 'Empresa', pedidos.NumeroDopedido AS 'Código', pedidos.DataDoPedido AS 'Data Pedido', produtos.NomeDoproduto AS Produto, 
produtos.PrecoUnitario AS R$
FROM clientes
INNER JOIN pedidos
ON clientes.CodigoDoCliente = pedidos.CodigoDoCliente
INNER JOIN DetalhesDoPedido
ON Pedidos.NumeroDoPedido = DetalhesDoPedido.NumeroDoPedido
INNER JOIN Produtos
ON DetalhesDoPedido.CodigoDoProduto = Produtos.CodigoDoProduto;

SELECT * FROM vw_relatorio_pedidos_produtos_clientes;

#02
CREATE OR REPLACE VIEW vw_clientes_fornecedores
AS
SELECT clientes.NomeDaEmpresa, clientes.Cidade 
FROM clientes
UNION
SELECT fornecedores.NomeDaEmpresa, fornecedores.Cidade
FROM fornecedores
ORDER BY 2 ASC;

SELECT * FROM vw_clientes_fornecedores;

#03
CREATE OR REPLACE VIEW vw_clientes_produtos 
AS
SELECT clientes.cidade, produtos.NomeDoProduto AS 'Nome Do Produto', 
COUNT(produtos.NomeDoProduto) AS 'Total de chocolates por cidade'
FROM clientes
INNER JOIN pedidos
ON clientes.CodigoDoCliente = pedidos.CodigoDoCliente
INNER JOIN DetalhesDoPedido
ON pedidos.NumeroDoPedido = DetalhesDoPedido.NumeroDoPedido
INNER JOIN produtos
ON DetalhesDoPedido.CodigoDoProduto = produtos.CodigoDoProduto
WHERE produtos.NomeDoProduto LIKE '%chocolate%' 
GROUP BY clientes.cidade, produtos.NomeDoProduto
ORDER BY 3;

SELECT * FROM vw_clientes_produtos;

#O3.1
SHOW VARIABLES LIKE 'autocommit';
SET autocommit = 0;
SELECT @@autocommit;

DELIMITER $$

CREATE PROCEDURE sp_clientes_produtos() 
BEGIN
    DECLARE erro_sql TINYINT DEFAULT FALSE;

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET erro_sql = TRUE;

    START TRANSACTION;

    EXPLAIN SELECT clientes.cidade, produtos.NomeDoProduto AS 'Nome Do Produto', 
    COUNT(produtos.NomeDoProduto) AS 'Total de chocolates por cidade'
    FROM clientes
    INNER JOIN pedidos ON clientes.CodigoDoCliente = pedidos.CodigoDoCliente
    INNER JOIN DetalhesDoPedido ON pedidos.NumeroDoPedido = DetalhesDoPedido.NumeroDoPedido
    INNER JOIN produtos ON DetalhesDoPedido.CodigoDoProduto = produtos.CodigoDoProduto
    WHERE produtos.NomeDoProduto LIKE '%chocolate%' 
    GROUP BY clientes.cidade, produtos.NomeDoProduto
    ORDER BY 3;
    
    IF erro_sql = FALSE THEN
       COMMIT;
        SELECT 'Transação bem-sucedida.' AS Resultado;
    ELSE
       ROLLBACK;
        SELECT 'Transação falhou.' AS Resultado;
    END IF;
     SET autocommit = 1;
END $$
DELIMITER ; 

CALL sp_clientes_produtos();

/*PROCEDURE

04*/
DELIMITER $$
CREATE PROCEDURE ConsultarTransportadoras()
BEGIN
SELECT * FROM transportadoras;
END $$
DELIMITER ;

CALL ConsultarTransportadoras();

#05
DELIMITER $$
CREATE PROCEDURE INS_TRANSPORTADORA(
    IN NOME VARCHAR(40), 
    IN TELEFONE VARCHAR(20))
    NOT DETERMINISTIC CONTAINS SQL SQL SECURITY DEFINER
BEGIN
    INSERT INTO Transportadoras (nomedaempresa, telefone)
    VALUES (NOME, TELEFONE);
END $$
DELIMITER ;

#06
ALTER TABLE Transportadoras
MODIFY COLUMN CodigoDaTransportadora INT AUTO_INCREMENT PRIMARY KEY;

DELIMITER $$
CREATE PROCEDURE Inserir_Transportadora(
    IN Nome VARCHAR(40), 
    IN Telefone VARCHAR(24)
)
NOT DETERMINISTIC 
BEGIN
    INSERT INTO Transportadoras (NomeDaEmpresa, Telefone)
    VALUES (Nome, Telefone);
END $$
DELIMITER ;

CALL Inserir_Transportadora('Empresa Fantasma', '81 98453-4002');

#07
DELIMITER $$

CREATE PROCEDURE Atualizar_Transportadora(
    IN codigo INT,
    IN novo_nome VARCHAR(40), 
    IN novo_telefone VARCHAR(24))
NOT DETERMINISTIC 
BEGIN
    UPDATE Transportadoras 
    SET NomeDaEmpresa = novo_nome, Telefone = novo_telefone
    WHERE CodigoDaTransportadora = codigo;
END $$
DELIMITER ;

CALL Atualizar_Transportadora(4, 'Espectral Expresso', '81 98888-4000');

#08
DELIMITER $$
CREATE PROCEDURE Excluir_Transportadora(
    IN codigo INT
)
NOT DETERMINISTIC 
BEGIN
    DELETE FROM Transportadoras 
    WHERE CodigoDaTransportadora = codigo;
END $$
DELIMITER ;

CALL Excluir_Transportadora(4);

#09
CREATE OR REPLACE VIEW vw_dados_transportadora
AS
SELECT * FROM Transportadoras;

SELECT * FROM vw_dados_transportadora;

# COMMIT, ROLLBACK, SAVEPOINT
TRUNCATE conta;
CREATE TABLE CONTA(
 nro_conta INT AUTO_INCREMENT,
 nome_titular VARCHAR(30) NOT NULL,
 saldo REAL DEFAULT 0,
 PRIMARY KEY(nro_conta)
);

INSERT INTO conta( nome_titular, saldo) 
VALUES
( 'Marta', 25400.00),
( 'Lucas', 1281.34),
('Ana', 85.12),
('Fábio', 172191.23),
('Bruna', -125);

DELETE FROM CONTA
WHERE Nro_conta = 2;

SELECT * FROM conta;

SHOW VARIABLES LIKE 'autocommit';
SET autocommit = 0;
SELECT @@autocommit;
SELECT @@global.transaction_isolation;

DELIMITER $$

CREATE PROCEDURE sp_transferencia()
BEGIN
    DECLARE erro_sql TINYINT DEFAULT FALSE;

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET erro_sql = TRUE;

    START TRANSACTION;

    UPDATE conta SET saldo = saldo - 100 WHERE nro_conta = 1;
	
    SAVEPOINT debitoEmConta;
    
    UPDATE conta SET saldo = saldo + 100 WHERE nro_conta = 4;
	
    ROLLBACK TO debitoEmConta;
	
   # RELEASE SAVEPOINT debitoEmConta;
    
    UPDATE conta SET saldo = saldo + 100 WHERE nro_conta = 5;
    
    IF erro_sql = FALSE THEN
       COMMIT;
        SELECT 'Transação bem-sucedida.' AS Resultado;
    ELSE
       ROLLBACK;
        SELECT 'Transação falhou.' AS Resultado;
    END IF;
     SET autocommit = 1;
END $$
DELIMITER ; 
--  RELEASE SAVEPOINT remove o savepoint, mas não reverte as alterações feitas na transação 

CALL sp_transferencia();

SELECT * FROM conta;
 
# Verifica se o usuário existe
DELIMITER $$

CREATE PROCEDURE sp_transferencia()
BEGIN
    DECLARE erro_sql TINYINT DEFAULT FALSE;

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET erro_sql = TRUE;

    START TRANSACTION;

    SELECT COUNT(*) INTO @existe_origem FROM conta WHERE nro_conta = 1;

    SELECT COUNT(*) INTO @existe_destino FROM conta WHERE nro_conta = 5;

    IF @existe_origem > 0 AND @existe_destino > 0 THEN
       
        UPDATE conta SET saldo = saldo - 100 WHERE nro_conta = 1;
        UPDATE conta SET saldo = saldo + 100 WHERE nro_conta = 5;
        
        IF erro_sql = FALSE THEN
            COMMIT;
            SELECT 'Transação bem-sucedida.' AS Resultado;
        ELSE
            ROLLBACK;
            SELECT 'Transação falhou.' AS Resultado;
        END IF;
    ELSE
        ROLLBACK;
        SELECT 'Usuário não encontrado em uma ou ambas as contas.' AS Resultado;
    END IF;

    SET autocommit = 1;
END $$

DELIMITER ;

CALL sp_transferencia();

SELECT * FROM conta;
 
# TRIGGER UPDATE
DELIMITER $$
CREATE TRIGGER tg_ControlaEstoqueAlteracao
BEFORE UPDATE
ON Produtos FOR EACH ROW
BEGIN
	DECLARE msg_erro VARCHAR(150);
    
    IF NEW.UnidadesEmEstoque < 0 THEN
    SET msg_erro = 'ERRO: Não é permitido estoque negativo.';
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg_erro;
END IF;
END $$
DELIMITER ;

UPDATE Produtos 
SET UnidadesEmEstoque = -1
WHERE CodigoDoProduto = 51;

# TRIGGER INSERT 
DELIMITER $$
CREATE TRIGGER tg_ControlaProdutoInclusao
BEFORE INSERT
ON Produtos FOR EACH ROW
BEGIN
	DECLARE msg_erro VARCHAR(150);
    
    IF NEW.UnidadesEmEstoque < 0 THEN
    SET msg_erro = 'ERRO: Não é permitido estoque negativo.';
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg_erro;
END IF;
END $$
DELIMITER ;

INSERT INTO Produtos(CodigoDoProduto, NomeDoProduto, CodigoDoFornecedor, CodigodaCategoria, QuantidadePorUnidade, PrecoUnitario, UnidadesEmEstoque, UnidadesPedidas, NivelDeReposicao, Descontinuado)
VALUES
(150, 'Sushi', 12, 6, '100 unidade de 100g', 10.000, -1, 0, 15, 0);

SELECT COUNT(QuantidadePorUnidade) AS 'Nenhum valor negativo encontrado'
FROM Produtos  
WHERE QuantidadePorUnidade IN (-1);

# DESCONTO EM PRODUTOS
ALTER TABLE Produtos
ADD DescontoProduto DECIMAL(7, 4) NULL AFTER NomeDoProduto;

DESCRIBE Produtos;

DELIMITER $$
CREATE TRIGGER tg_DescontoProduto
BEFORE INSERT 
ON Produtos FOR EACH ROW 
BEGIN
SET NEW.DescontoProduto = (NEW.PrecoUnitario * 0.90); -- 90%
END $$
DELIMITER ;

INSERT INTO Produtos(CodigoDoProduto, NomeDoProduto, CodigoDoFornecedor, CodigodaCategoria, QuantidadePorUnidade, PrecoUnitario, UnidadesEmEstoque, UnidadesPedidas, NivelDeReposicao, Descontinuado)
VALUES
(151, 'Sushi', 12, 6, '100 unidade de 100g', 10.000, 1, 0, 15, 0);

SELECT * FROM Produtos;

# CURSOR
SHOW VARIABLES LIKE "secure_file_priv";

DELIMITER $$

CREATE PROCEDURE sp_PaisesVendidos()
BEGIN  
  DECLARE lista VARCHAR(2000) DEFAULT '';
  DECLARE vendas VARCHAR(50);
  DECLARE fim BOOLEAN DEFAULT FALSE;

  DECLARE crPaises CURSOR
  FOR SELECT clientes.pais, COUNT(clientes.pais) AS Resultado FROM clientes 
  WHERE clientes.pais IS NOT NULL
  GROUP BY clientes.pais;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET fim = TRUE;
  OPEN crPaises;
  WHILE fim = FALSE DO
    FETCH crpaises INTO vendas;
           
    SET lista = CONCAT(lista, vendas);
    SET lista = CONCAT(lista, ', ');
  END WHILE;
  CLOSE crpaises;
  
  SELECT lista;
  SELECT lista INTO OUTFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\paises.csv';

END $$

DELIMITER ;

CALL sp_PaisesVendidos();

DROP PROCEDURE sp_PaisesVendidos;

# ABRIR CURSOR
DELIMITER $$
CREATE PROCEDURE sp_ExecCursor()
BEGIN
SET @csv_content := CONVERT(LOAD_FILE('C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\paises.csv') USING utf8);

IF @csv_content IS NULL THEN
    SELECT 'Erro: Falha ao carregar o arquivo ou arquivo não encontrado.' AS Erro;
ELSE
    SELECT @csv_content AS csv_content;
END IF;
END $$
DELIMITER ;

CALL sp_ExecCursor;

SELECT * FROM Clientes;

# Visualizar Dados do Cursor no MYSQL
SELECT CONVERT(LOAD_FILE('C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\paises.csv') USING utf8) AS csv_content;


# REGISTROS EM MAÍUSCULAS
DELIMITER $$

CREATE PROCEDURE sp_DadosMaiusculos()
BEGIN
    DECLARE erro_sql TINYINT DEFAULT FALSE;

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET erro_sql = TRUE;

    START TRANSACTION;

UPDATE Funcionarios
SET Nome = UPPER(Nome)
WHERE CodigoDoFuncionario > 0;

UPDATE Funcionarios
SET SobreNome = UPPER(SobreNome) -- LOWER
WHERE CodigoDoFuncionario > 0;

        IF erro_sql = FALSE THEN
            COMMIT;
            SELECT 'Transação bem-sucedida.' AS Resultado;
        ELSE
            ROLLBACK;
            SELECT 'Transação falhou.' AS Resultado;
        END IF;
    SET autocommit = 1;
END $$

DELIMITER ;

CALL sp_DadosMaiusculos();

SELECT * FROM Funcionarios;