CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    tipo ENUM('PJ', 'PF'),
    cpf_cnpj VARCHAR(20) UNIQUE
);

CREATE TABLE pagamentos (
    id_pagamento INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT,
    tipo_pagamento VARCHAR(50),
    dados_pagamento JSON,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

CREATE TABLE pedidos (
    id_pedido INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT,
    data_pedido DATE,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

CREATE TABLE itens_pedido (
    id_item_pedido INT PRIMARY KEY AUTO_INCREMENT,
    id_pedido INT,
    id_produto INT,
    quantidade INT,
    valor_unitario DECIMAL(10,2),
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
    FOREIGN KEY (id_produto) REFERENCES produtos(id_produto) -- Assuming a 'produtos' table exists
);

CREATE TABLE entregas (
    id_entrega INT PRIMARY KEY AUTO_INCREMENT,
    id_pedido INT,
    status ENUM('pendente', 'em_transito', 'entregue'),
    codigo_rastreio VARCHAR(50),
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido)
);

SELECT * FROM clientes;
SELECT nome, email FROM clientes WHERE tipo = 'PJ';
SELECT * FROM pedidos WHERE data_pedido BETWEEN '2023-01-01' AND '2023-12-31';
SELECT * FROM entregas WHERE status = 'pendente';
SELECT nome, email, CONCAT(tipo, ' - ', cpf_cnpj) AS identificacao FROM clientes;
SELECT p.id_pedido, SUM(i.quantidade * i.valor_unitario) AS valor_total FROM pedidos p
INNER JOIN itens_pedido i ON p.id_pedido = i.id_pedido
GROUP BY p.id_pedido;
SELECT * FROM pedidos ORDER BY data_pedido DESC;
SELECT * FROM clientes ORDER BY nome ASC;
SELECT p.id_cliente, COUNT(*) AS total_pedidos FROM pedidos p
GROUP BY p.id_cliente
HAVING COUNT(*) > 5;
SELECT c.nome, p.data_pedido, e.status FROM clientes c
INNER JOIN pedidos p ON c.id_cliente = p.id_cliente
INNER JOIN entregas e ON p.id_pedido = e.id_pedido;