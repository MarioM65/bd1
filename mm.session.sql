USE ecommerce_db;

-- Modificação da tabela de clientes para incluir discriminador PF/PJ
CREATE TABLE client (
    idClient INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    address VARCHAR(50),
    client_type ENUM('PF', 'PJ') NOT NULL,
    active BOOLEAN DEFAULT TRUE
);

-- Tabela específica para Pessoa Física
CREATE TABLE client_pf (
    idClientPF INT PRIMARY KEY,
    cpf CHAR(11) NOT NULL,
    birthDate DATE,
    CONSTRAINT unique_cpf_client UNIQUE (cpf),
    FOREIGN KEY (idClientPF) REFERENCES client(idClient)
);

-- Tabela específica para Pessoa Jurídica
CREATE TABLE client_pj (
    idClientPJ INT PRIMARY KEY,
    cnpj CHAR(14) NOT NULL,
    socialName VARCHAR(50) NOT NULL,
    businessName VARCHAR(50),
    CONSTRAINT unique_cnpj_client UNIQUE (cnpj),
    FOREIGN KEY (idClientPJ) REFERENCES client(idClient)
);

-- Tabela de produtos
CREATE TABLE product (
    idProduct INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30) NOT NULL,
    classification_key BOOLEAN DEFAULT FALSE,
    category ENUM('eletronicos', 'moveis', 'utilidades domesticas', 'esporte', 'outros') DEFAULT 'outros',
    avaliacao FLOAT DEFAULT 0,
    size VARCHAR(10)
);

-- Tabela de métodos de pagamento disponíveis
CREATE TABLE payment_method (
    idPaymentMethod INT PRIMARY KEY AUTO_INCREMENT,
    method_name VARCHAR(50) NOT NULL,
    description VARCHAR(100),
    active BOOLEAN DEFAULT TRUE
);

-- Tabela de pagamentos (relacionamento N:M entre pedido e método de pagamento)
CREATE TABLE payment (
    idPayment INT AUTO_INCREMENT PRIMARY KEY,
    idOrder INT NOT NULL,
    idPaymentMethod INT NOT NULL,
    payment_value FLOAT NOT NULL,
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    payment_status ENUM('pendente', 'aprovado', 'recusado', 'estornado') DEFAULT 'pendente',
    FOREIGN KEY (idPaymentMethod) REFERENCES payment_method(idPaymentMethod)
);

-- Tabela de pedidos
CREATE TABLE `order` (
    idOrder INT PRIMARY KEY AUTO_INCREMENT,
    orderDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    orderStatus ENUM('pendente', 'processando', 'enviado', 'entregue', 'cancelado') DEFAULT 'pendente',
    orderDescription VARCHAR(100),
    sendValue FLOAT DEFAULT 0,
    totalValue FLOAT DEFAULT 0,
    idClient INT,
    FOREIGN KEY (idClient) REFERENCES client(idClient)
);

-- Tabela de entrega com status e rastreio
CREATE TABLE delivery (
    idDelivery INT PRIMARY KEY AUTO_INCREMENT,
    idOrder INT UNIQUE,
    tracking_code VARCHAR(50) UNIQUE,
    delivery_status ENUM('aguardando_envio', 'em_transito', 'entregue', 'devolvido') DEFAULT 'aguardando_envio',
    estimated_delivery DATE,
    actual_delivery DATETIME,
    shipping_company VARCHAR(50),
    FOREIGN KEY (idOrder) REFERENCES `order`(idOrder)
);

-- Tabela de estoque
CREATE TABLE stock (
    idStock INT PRIMARY KEY AUTO_INCREMENT,
    location VARCHAR(30) NOT NULL,
    quantity INT DEFAULT 0
);

-- Tabela de fornecedores
CREATE TABLE supplier (
    idSupplier INT PRIMARY KEY AUTO_INCREMENT,
    socialName VARCHAR(50) NOT NULL,
    cnpj CHAR(14) NOT NULL,
    contact VARCHAR(30),
    CONSTRAINT unique_cnpj_supplier UNIQUE (cnpj)
);

-- Tabela de vendedores
CREATE TABLE seller (
    idSeller INT PRIMARY KEY AUTO_INCREMENT,
    socialName VARCHAR(50) NOT NULL,
    abstractName VARCHAR(30),
    cnpj CHAR(14),
    cpf CHAR(11),
    location VARCHAR(50),
    contact VARCHAR(30),
    CONSTRAINT unique_cnpj_seller UNIQUE (cnpj),
    CONSTRAINT unique_cpf_seller UNIQUE (cpf)
);

-- Relação produto-vendedor
CREATE TABLE product_seller (
    idProductSeller INT AUTO_INCREMENT PRIMARY KEY,
    idProduct INT NOT NULL,
    idSeller INT NOT NULL,
    quantity INT DEFAULT 1,
    FOREIGN KEY (idProduct) REFERENCES product(idProduct),
    FOREIGN KEY (idSeller) REFERENCES seller(idSeller)
);
Create Table supplier_product (
    idSupplierProduct INT AUTO_INCREMENT PRIMARY KEY,
    idSupplier INT NOT NULL,
    idProduct INT NOT NULL,
    supplyPrice FLOAT NOT NULL,
    FOREIGN KEY (idSupplier) REFERENCES supplier(idSupplier),
    FOREIGN KEY (idProduct) REFERENCES product(idProduct)
);

-- Relação produto-pedido
CREATE TABLE product_order (
    idProduct INT NOT NULL,
    idOrder INT NOT NULL,
    quantity INT DEFAULT 1,
    status ENUM('Disponivel', 'Indisponivel') DEFAULT 'Disponivel',
    PRIMARY KEY (idProduct, idOrder),
    FOREIGN KEY (idProduct) REFERENCES product(idProduct),
    FOREIGN KEY (idOrder) REFERENCES `order`(idOrder)
);

-- Localização de armazenamento
CREATE TABLE storageLocation (
    id_product INT NOT NULL,
    id_stock INT NOT NULL,
    location VARCHAR(255) NOT NULL,
    PRIMARY KEY (id_product, id_stock),
    FOREIGN KEY (id_product) REFERENCES product(idProduct),
    FOREIGN KEY (id_stock) REFERENCES stock(idStock)
);
-- Inserir métodos de pagamento
INSERT INTO payment_method (method_name, description) VALUES
('Cartão de Crédito', 'Pagamento com cartão de crédito'),
('Cartão de Débito', 'Pagamento com cartão de débito'),
('PIX', 'Pagamento instantâneo via PIX'),
('Boleto', 'Pagamento via boleto bancário');

-- Inserir clientes (PF e PJ)
INSERT INTO client (name, address, client_type) VALUES
('Maria Silva', 'Rua A, 123', 'PF'),
('João Souza', 'Rua B, 456', 'PF'),
('Tech Solutions LTDA', 'Av. Principal, 789', 'PJ');

-- Inserir dados de PF
INSERT INTO client_pf (idClientPF, cpf, birthDate) VALUES
(1, '12345678901', '1990-05-15'),
(2, '23456789012', '1985-08-22');

-- Inserir dados de PJ
INSERT INTO client_pj (idClientPJ, cnpj, socialName, businessName) VALUES
(3, '12345678000199', 'Tech Solutions LTDA', 'TechSol'); 
INSERT INTO product (name, classification_key, category, avaliacao, size) VALUES
('Smartphone', TRUE, 'eletronicos', 4.5, 'M'),
('Sofa', FALSE, 'moveis', 4.0, 'L'),
('Bola de Futebol', FALSE, 'esporte', 4.8, 'M');
INSERT INTO stock (location, quantity) VALUES
('Armazém Central', 100),
('Loja Norte', 50);
INSERT INTO supplier (socialName, cnpj, contact) VALUES
('Fornecedor A', '12345678000199', 'contato@fornecedora.com'),
('Fornecedor B', '98765432000188', 'contato@fornecedoraB.com'); 
INSERT INTO seller (socialName, abstractName, cnpj, cpf, location, contact) VALUES
('Vendedor X', 'VendX', '11223344000155', NULL, 'Cidade X', 'contato@vendedoX.com'),
('Vendedor Y', 'VendY', NULL, '99887766554', 'Cidade Y', 'contato@vendedoY.com');
-- Inserir pedidos com suas entregas e pagamentos
INSERT INTO `order` (orderDate, orderStatus, orderDescription, sendValue, totalValue, idClient) VALUES
('2024-01-15 10:00:00', 'processando', 'Pedido de Smartphone', 20.0, 1520.0, 1),
('2024-01-16 14:30:00', 'enviado', 'Pedido de Sofá', 50.0, 2050.0, 3);

INSERT INTO delivery (idOrder, tracking_code, delivery_status, estimated_delivery) VALUES
(1, 'BR123456789', 'em_transito', '2024-01-20'),
(2, 'BR987654321', 'aguardando_envio', '2024-01-25');

INSERT INTO payment (idOrder, idPaymentMethod, payment_value, payment_status) VALUES
(1, 1, 1520.0, 'aprovado'),
(2, 3, 2050.0, 'aprovado');
INSERT INTO product_seller (idProduct, idSeller, quantity) VALUES
(1, 1, 10),
(2, 2, 5);
INSERT INTO supplier_product (idSupplier, idProduct, supplyPrice) VALUES
(1, 1, 250.0),
(2, 2, 800.0);
INSERT INTO product_order (idProduct, idOrder, quantity, status) VALUES
(1, 1, 1, 'Disponivel'),
(2, 2, 2, 'Disponivel');    
INSERT INTO storageLocation (id_product, id_stock, location) VALUES
(1, 1, 'Prateleira A1'),
(2, 2, 'Prateleira B2');

-- Exemplos de consultas

-- 1. Listar todos os pedidos com seus métodos de pagamento
SELECT 
    o.idOrder,
    c.name as cliente,
    CASE 
        WHEN c.client_type = 'PF' THEN cpf.cpf
        ELSE pj.cnpj
    END as documento,
    o.totalValue,
    GROUP_CONCAT(pm.method_name) as metodos_pagamento,
    d.tracking_code,
    d.delivery_status
FROM `order` o
JOIN client c ON o.idClient = c.idClient
LEFT JOIN client_pf cpf ON c.idClient = cpf.idClientPF
LEFT JOIN client_pj pj ON c.idClient = pj.idClientPJ
JOIN payment p ON o.idOrder = p.idOrder
JOIN payment_method pm ON p.idPaymentMethod = pm.idPaymentMethod
LEFT JOIN delivery d ON o.idOrder = d.idOrder
GROUP BY o.idOrder;

-- 2. Valor total de vendas por tipo de cliente
SELECT 
    c.client_type,
    COUNT(o.idOrder) as total_pedidos,
    SUM(o.totalValue) as valor_total
FROM client c
LEFT JOIN `order` o ON c.idClient = o.idClient
GROUP BY c.client_type;

-- 3. Status de entrega por pedido
SELECT 
    o.idOrder,
    c.name as cliente,
    o.orderStatus,
    d.tracking_code,
    d.delivery_status,
    d.estimated_delivery
FROM `order` o
JOIN client c ON o.idClient = c.idClient
LEFT JOIN delivery d ON o.idOrder = d.idOrder
ORDER BY o.orderDate DESC;
