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
    classification_key boolean,
    category enum('eletronicos', 'moveis', 'utilidades domesticas', 'esporte', 'outros'),
    address VARCHAR(50),
    cpf char(11) NOT NULL,
    constraint unique_cpf_product unique (cpf)
);
--criar tabela pedido--