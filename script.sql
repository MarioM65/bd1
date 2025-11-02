--criar tabela cliente--
CREATE TABLE client (
    idClient INT PRIMARY KEY AUTO_INCREMENT,
    fname VARCHAR(10) ,
    mimit char(3),
    lname VARCHAR(10),
    cpf char(11) NOT NULL,
    address VARCHAR(50),
    constraint unique_cpf_client unique (cpf)
);
--criar tabela produto--
CREATE TABLE product (
    idProduct INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30) NOT NULL,
    classification_key boolean default false,
    category enum('eletronicos', 'moveis', 'utilidades domesticas', 'esporte', 'outros') default 'outros',
    avaliacao float default 0,
    size varchar(10)
);
--criar tabela pagamentos--
CREATE TABLE payment (
    idPayment INT ,
    idClient INT,
    cash float default 0,
    type_payment enum('credito', 'debito', 'pix', 'boleto') default 'pix',
    limiteavailable float default 0,
    PRIMARY KEY (idPayment, idClient),
    FOREIGN KEY (idClient) REFERENCES client(idClient)
);

--criar tabela pedido--
CREATE TABLE order (
    idOrder INT PRIMARY KEY AUTO_INCREMENT,
    orderDate DATE NOT NULL,
    orderStatus enum('pendente', 'processando', 'enviado', 'entregue', 'cancelado') default 'pendente',
    orderDescription VARCHAR(100),
    sendValue float default 0,
    paymentCash boolean default false,
    idOrderPayment INT,
    idOrderClient INT,
    FOREIGN KEY (idOrderPayment) REFERENCES payment(idPayment),
    FOREIGN KEY (idOrderClient) REFERENCES client(idClient)
);
--criar tabela estoque--
CREATE TABLE stock (
    idStock INT PRIMARY KEY AUTO_INCREMENT,
    location VARCHAR(30) NOT NULL,
    quantity INT default 0
);
--criar tabela fornecedor--
CREATE TABLE supplier (
    idSupplier INT PRIMARY KEY AUTO_INCREMENT,
    socialName VARCHAR(50) NOT NULL,
    cnpj char(14) NOT NULL,
    contact VARCHAR(30),
    constraint unique_cnpj_supplier unique (cnpj)
);
--criar tabela vendedor--
CREATE TABLE seller (
    idSeller INT PRIMARY KEY AUTO_INCREMENT,
    socialName VARCHAR(50) NOT NULL,
    abstractName VARCHAR(30),
    cnpj char(14),
    cpf char(11),
    location VARCHAR(50),
    contact VARCHAR(30),
    constraint unique_cnpj_seller unique (cnpj),
    constraint unique_cpf_seller unique (cpf)
);