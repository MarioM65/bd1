
    -- Oficina: esquema relacional lógico implementado e dados de teste
    DROP DATABASE IF EXISTS oficina_db;
    CREATE DATABASE oficina_db;
    USE oficina_db;

    -- Tabela de clientes (base)
    CREATE TABLE client (
        idClient INT PRIMARY KEY AUTO_INCREMENT,
        name VARCHAR(100) NOT NULL,
        phone VARCHAR(20),
        email VARCHAR(100),
        address VARCHAR(255),
        client_type ENUM('PF','PJ') NOT NULL,
        active BOOLEAN DEFAULT TRUE
    );

    -- Dados específicos para PF
    CREATE TABLE client_pf (
        idClientPF INT PRIMARY KEY,
        cpf CHAR(11) NOT NULL UNIQUE,
        birth_date DATE,
        FOREIGN KEY (idClientPF) REFERENCES client(idClient) ON DELETE CASCADE
    );

    -- Dados específicos para PJ
    CREATE TABLE client_pj (
        idClientPJ INT PRIMARY KEY,
        cnpj CHAR(14) NOT NULL UNIQUE,
        company_name VARCHAR(150) NOT NULL,
        contact_person VARCHAR(100),
        FOREIGN KEY (idClientPJ) REFERENCES client(idClient) ON DELETE CASCADE
    );

    -- Veículos dos clientes
    CREATE TABLE vehicle (
        idVehicle INT PRIMARY KEY AUTO_INCREMENT,
        idClient INT NOT NULL,
        plate VARCHAR(20) NOT NULL UNIQUE,
        vin VARCHAR(25) UNIQUE,
        make VARCHAR(50),
        model VARCHAR(50),
        year INT,
        FOREIGN KEY (idClient) REFERENCES client(idClient) ON DELETE CASCADE
    );

    -- Mecânicos
    CREATE TABLE mechanic (
        idMechanic INT PRIMARY KEY AUTO_INCREMENT,
        name VARCHAR(100) NOT NULL,
        specialization VARCHAR(100),
        hourly_rate DECIMAL(10,2) NOT NULL DEFAULT 50.00
    );

    -- Tipos de serviço oferecidos
    CREATE TABLE service_type (
        idServiceType INT PRIMARY KEY AUTO_INCREMENT,
        description VARCHAR(200) NOT NULL,
        base_price DECIMAL(10,2) NOT NULL,
        est_hours DECIMAL(5,2) DEFAULT 1.0
    );

    -- Peças e estoque
    CREATE TABLE part (
        idPart INT PRIMARY KEY AUTO_INCREMENT,
        name VARCHAR(150) NOT NULL,
        sku VARCHAR(50) UNIQUE,
        cost_price DECIMAL(10,2) NOT NULL,
        sale_price DECIMAL(10,2) NOT NULL,
        stock_qty INT DEFAULT 0
    );

    -- Fornecedores
    CREATE TABLE supplier (
        idSupplier INT PRIMARY KEY AUTO_INCREMENT,
        name VARCHAR(150) NOT NULL,
        cnpj CHAR(14) UNIQUE,
        contact VARCHAR(100)
    );

    -- Relacionamento peça-fornecedor
    CREATE TABLE part_supplier (
        idPart INT NOT NULL,
        idSupplier INT NOT NULL,
        supply_price DECIMAL(10,2) NOT NULL,
        PRIMARY KEY (idPart, idSupplier),
        FOREIGN KEY (idPart) REFERENCES part(idPart),
        FOREIGN KEY (idSupplier) REFERENCES supplier(idSupplier)
    );

    -- Ordem de serviço (work order)
    CREATE TABLE work_order (
        idWorkOrder INT PRIMARY KEY AUTO_INCREMENT,
        idClient INT NOT NULL,
        idVehicle INT NOT NULL,
        reported_problem TEXT,
        idMechanic INT, -- responsável principal
        status ENUM('aberto','em_andamento','aguardando_pecas','concluido','faturado','entregue') DEFAULT 'aberto',
        open_date DATETIME DEFAULT CURRENT_TIMESTAMP,
        close_date DATETIME,
        estimated_total DECIMAL(12,2) DEFAULT 0,
        final_total DECIMAL(12,2) DEFAULT 0,
        FOREIGN KEY (idClient) REFERENCES client(idClient),
        FOREIGN KEY (idVehicle) REFERENCES vehicle(idVehicle),
        FOREIGN KEY (idMechanic) REFERENCES mechanic(idMechanic)
    );

    -- Serviços realizados na ordem
    CREATE TABLE work_order_service (
        idWorkOrder INT NOT NULL,
        idServiceType INT NOT NULL,
        quantity INT DEFAULT 1,
        unit_price DECIMAL(10,2) NOT NULL,
        PRIMARY KEY (idWorkOrder, idServiceType),
        FOREIGN KEY (idWorkOrder) REFERENCES work_order(idWorkOrder) ON DELETE CASCADE,
        FOREIGN KEY (idServiceType) REFERENCES service_type(idServiceType)
    );

    -- Peças utilizadas na ordem
    CREATE TABLE work_order_part (
        idWorkOrder INT NOT NULL,
        idPart INT NOT NULL,
        quantity INT NOT NULL,
        unit_price DECIMAL(10,2) NOT NULL,
        PRIMARY KEY (idWorkOrder, idPart),
        FOREIGN KEY (idWorkOrder) REFERENCES work_order(idWorkOrder) ON DELETE CASCADE,
        FOREIGN KEY (idPart) REFERENCES part(idPart)
    );

    -- Métodos de pagamento
    CREATE TABLE payment_method (
        idPaymentMethod INT PRIMARY KEY AUTO_INCREMENT,
        name VARCHAR(50) NOT NULL,
        description VARCHAR(200)
    );

    -- Pagamentos (uma ordem pode ter vários pagamentos)
    CREATE TABLE payment (
        idPayment INT PRIMARY KEY AUTO_INCREMENT,
        idWorkOrder INT NOT NULL,
        idPaymentMethod INT NOT NULL,
        amount DECIMAL(12,2) NOT NULL,
        payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
        status ENUM('pendente','aprovado','recusado','estornado') DEFAULT 'pendente',
        FOREIGN KEY (idWorkOrder) REFERENCES work_order(idWorkOrder),
        FOREIGN KEY (idPaymentMethod) REFERENCES payment_method(idPaymentMethod)
    );

    -- Entrega do veículo (ou envio de peças) com rastreio
    CREATE TABLE delivery (
        idDelivery INT PRIMARY KEY AUTO_INCREMENT,
        idWorkOrder INT UNIQUE,
        tracking_code VARCHAR(50) UNIQUE,
        delivery_status ENUM('aguardando','em_transito','entregue','devolvido') DEFAULT 'aguardando',
        estimated_date DATE,
        actual_date DATETIME,
        carrier VARCHAR(100),
        FOREIGN KEY (idWorkOrder) REFERENCES work_order(idWorkOrder)
    );

    -- Índices úteis
    CREATE INDEX idx_workorder_client ON work_order(idClient);
    CREATE INDEX idx_vehicle_plate ON vehicle(plate);

    -- ==========================
    -- Dados de exemplo (populate)
    -- ==========================

    -- Clientes
    INSERT INTO client (name, phone, email, address, client_type) VALUES
    ('Carlos Pereira', '11999990000', 'carlos@example.com', 'Rua das Flores, 10', 'PF'),
    ('AutoCorp LTDA', '1133333000', 'finance@autocorp.com', 'Av. Industria, 500', 'PJ'),
    ('Mariana Silva', '21988880000', 'mariana@example.com', 'Rua das Oliveiras, 45', 'PF');

    INSERT INTO client_pf (idClientPF, cpf, birth_date) VALUES
    (1, '12345678901', '1980-04-10'),
    (3, '98765432100', '1992-11-07');

    INSERT INTO client_pj (idClientPJ, cnpj, company_name, contact_person) VALUES
    (2, '12345678000199', 'AutoCorp LTDA', 'Paulo Gomes');

    -- Veículos
    INSERT INTO vehicle (idClient, plate, vin, make, model, year) VALUES
    (1, 'ABC-1234', '1HGCM82633A004352', 'Honda', 'Civic', 2010),
    (3, 'XYZ-9876', '2T1BR32E54C123456', 'Toyota', 'Corolla', 2015),
    (2, 'FGR-5566', '3FAHP0HA7AR123456', 'Ford', 'Focus', 2018);

    -- Mecânicos
    INSERT INTO mechanic (name, specialization, hourly_rate) VALUES
    ('João Mecânico', 'Injeção Eletrônica', 80.00),
    ('Luciana Reparos', 'Suspensão e Freios', 70.00);

    -- Tipos de serviços
    INSERT INTO service_type (description, base_price, est_hours) VALUES
    ('Troca de óleo', 120.00, 1.0),
    ('Alinhamento e balanceamento', 180.00, 1.5),
    ('Substituição pastilha de freio', 200.00, 2.0);

    -- Peças
    INSERT INTO part (name, sku, cost_price, sale_price, stock_qty) VALUES
    ('Óleo 5W30 4L', 'OLEO-5W30-4L', 30.00, 60.00, 20),
    ('Pastilha de freio dianteira', 'PAST-FR-001', 40.00, 90.00, 10),
    ('Filtro de óleo', 'FILT-OL-01', 10.00, 25.00, 30);

    -- Fornecedores
    INSERT INTO supplier (name, cnpj, contact) VALUES
    ('Peças & Cia', '22233344000155', 'vendas@pecasecia.com'),
    ('Lubrificantes SA', '33344455000166', 'contato@lubri.com');

    INSERT INTO part_supplier (idPart, idSupplier, supply_price) VALUES
    (1, 2, 28.00),
    (2, 1, 38.00),
    (3, 2, 9.00);

    -- Métodos de pagamento
    INSERT INTO payment_method (name, description) VALUES
    ('Dinheiro', 'Pagamento em dinheiro'),
    ('Cartão de Crédito', 'Parcelado'),
    ('PIX', 'Pagamento instantâneo');

    -- Ordens de serviço
    INSERT INTO work_order (idClient, idVehicle, reported_problem, idMechanic, status, open_date, estimated_total) VALUES
    (1, 1, 'Vibração ao frear', 2, 'em_andamento', '2024-01-10 09:30:00', 350.00),
    (3, 2, 'Troca de óleo e filtro', 1, 'concluido', '2024-01-12 11:00:00', 200.00),
    (2, 3, 'Revisão 20.000km', 1, 'aguardando_pecas', '2024-01-15 08:00:00', 800.00);

    -- Serviços realizados
    INSERT INTO work_order_service (idWorkOrder, idServiceType, quantity, unit_price) VALUES
    (1, 3, 1, 200.00), -- pastilha
    (1, 2, 1, 180.00), -- alinhamento
    (2, 1, 1, 120.00), -- troca de óleo
    (3, 1, 1, 120.00);

    -- Peças usadas
    INSERT INTO work_order_part (idWorkOrder, idPart, quantity, unit_price) VALUES
    (1, 2, 2, 90.00), -- pastilha *2
    (2, 1, 1, 60.00), -- óleo
    (2, 3, 1, 25.00); -- filtro

    -- Atualiza estoque conforme utilização (exemplo simples)
    UPDATE part SET stock_qty = stock_qty - 2 WHERE idPart = 2;
    UPDATE part SET stock_qty = stock_qty - 1 WHERE idPart IN (1,3);

    -- Pagamentos
    INSERT INTO payment (idWorkOrder, idPaymentMethod, amount, status) VALUES
    (1, 1, 200.00, 'aprovado'),
    (1, 3, 160.00, 'aprovado'),
    (2, 2, 145.00, 'aprovado');

    -- Entregas (ex: veículo entregue ao cliente)
    INSERT INTO delivery (idWorkOrder, tracking_code, delivery_status, estimated_date) VALUES
    (2, 'OF123BR0001', 'entregue', '2024-01-14'),
    (3, NULL, 'aguardando', NULL);

    -- ==========================
    -- Consultas de exemplo (mais complexas)
    -- 1) Recuperação simples - listar clientes
    SELECT idClient, name, phone, email, client_type FROM client;

    -- 2) WHERE - veículos por placa parcial
    SELECT v.idVehicle, v.plate, v.make, v.model, c.name as owner
    FROM vehicle v
    JOIN client c ON v.idClient = c.idClient
    WHERE v.plate LIKE 'A%';

    -- 3) Atributos derivados - calcular subtotal de cada ordem (serviços + peças)
    SELECT 
        w.idWorkOrder,
        c.name,
        COALESCE(SUM(wos.quantity * wos.unit_price),0) AS services_total,
        COALESCE(SUM(wop.quantity * wop.unit_price),0) AS parts_total,
        (COALESCE(SUM(wos.quantity * wos.unit_price),0) + COALESCE(SUM(wop.quantity * wop.unit_price),0)) AS order_subtotal,
        ((COALESCE(SUM(wos.quantity * wos.unit_price),0) + COALESCE(SUM(wop.quantity * wop.unit_price),0)) * 0.12) AS tax_12pct
    FROM work_order w
    JOIN client c ON w.idClient = c.idClient
    LEFT JOIN work_order_service wos ON w.idWorkOrder = wos.idWorkOrder
    LEFT JOIN work_order_part wop ON w.idWorkOrder = wop.idWorkOrder
    GROUP BY w.idWorkOrder, c.name;

    -- 4) ORDER BY - mecânicos por receita (serviços cobrados)
    SELECT m.idMechanic, m.name, SUM(wos.unit_price * wos.quantity) AS revenue
    FROM mechanic m
    JOIN work_order w ON w.idMechanic = m.idMechanic
    JOIN work_order_service wos ON w.idWorkOrder = wos.idWorkOrder
    GROUP BY m.idMechanic, m.name
    ORDER BY revenue DESC;

    -- 5) HAVING - clientes com gasto médio por ordem acima de 250
    SELECT c.idClient, c.name, COUNT(w.idWorkOrder) AS orders_cnt, AVG(
        (SELECT COALESCE(SUM(wos2.quantity * wos2.unit_price),0) + COALESCE(SUM(wop2.quantity * wop2.unit_price),0)
         FROM work_order_service wos2 LEFT JOIN work_order_part wop2 ON wos2.idWorkOrder = wop2.idWorkOrder
         WHERE wos2.idWorkOrder = w.idWorkOrder)
    ) AS avg_spent
    FROM client c
    JOIN work_order w ON c.idClient = w.idClient
    GROUP BY c.idClient, c.name
    HAVING AVG(
        (SELECT COALESCE(SUM(wos2.quantity * wos2.unit_price),0) + COALESCE(SUM(wop2.quantity * wop2.unit_price),0)
         FROM work_order_service wos2 LEFT JOIN work_order_part wop2 ON wos2.idWorkOrder = wop2.idWorkOrder
         WHERE wos2.idWorkOrder = w.idWorkOrder)
    ) > 250;

    -- 6) Junções complexas - relatório detalhado de ordens
    SELECT
        w.idWorkOrder,
        c.name AS client,
        CONCAT(v.make,' ',v.model,' (',v.plate,')') AS vehicle,
        m.name AS mechanic,
        w.status,
        w.open_date,
        COALESCE(SUM(wos.quantity * wos.unit_price),0) AS services_total,
        COALESCE(SUM(wop.quantity * wop.unit_price),0) AS parts_total,
        (COALESCE(SUM(wos.quantity * wos.unit_price),0) + COALESCE(SUM(wop.quantity * wop.unit_price),0)) AS subtotal,
        GROUP_CONCAT(DISTINCT pm.name) AS payment_methods,
        d.tracking_code,
        d.delivery_status
    FROM work_order w
    LEFT JOIN client c ON w.idClient = c.idClient
    LEFT JOIN vehicle v ON w.idVehicle = v.idVehicle
    LEFT JOIN mechanic m ON w.idMechanic = m.idMechanic
    LEFT JOIN work_order_service wos ON w.idWorkOrder = wos.idWorkOrder
    LEFT JOIN work_order_part wop ON w.idWorkOrder = wop.idWorkOrder
    LEFT JOIN payment p ON w.idWorkOrder = p.idWorkOrder
    LEFT JOIN payment_method pm ON p.idPaymentMethod = pm.idPaymentMethod
    LEFT JOIN delivery d ON w.idWorkOrder = d.idWorkOrder
    GROUP BY w.idWorkOrder, c.name, v.make, v.model, v.plate, m.name, w.status, w.open_date, d.tracking_code, d.delivery_status
    ORDER BY w.open_date DESC;
