# E-commerce Database Project

Este projeto consiste em um modelo de banco de dados para um sistema de e-commerce, desenvolvido como parte do curso de banco de dados.

## Estrutura do Banco de Dados

O banco de dados foi projetado para suportar as seguintes funcionalidades principais:

### 1. Gestão de Clientes (PF e PJ)
- Suporte para pessoas físicas e jurídicas
- Separação clara entre os tipos de cliente
- Dados específicos para cada tipo de cliente

### 2. Sistema de Pedidos
- Gerenciamento completo do ciclo de vida do pedido
- Suporte a múltiplos itens por pedido
- Cálculo de valores e quantidades

### 3. Pagamentos
- Múltiplas formas de pagamento por pedido
- Controle de status de pagamento
- Histórico de transações

### 4. Sistema de Entrega
- Rastreamento de entregas
- Códigos de rastreio únicos
- Status de entrega atualizado
- Datas estimadas e reais de entrega

### 5. Gestão de Estoque
- Controle de localização de produtos
- Gestão de quantidade disponível
- Múltiplos locais de armazenamento

### 6. Fornecedores e Vendedores
- Cadastro de fornecedores
- Gestão de vendedores (marketplace)
- Relação produto-fornecedor
- Relação produto-vendedor

## Principais Consultas Implementadas

1. **Análise de Pedidos**
   - Listagem completa com métodos de pagamento
   - Status de entrega
   - Documentos dos clientes

2. **Análise de Vendas**
   - Total de vendas por tipo de cliente
   - Acompanhamento de status de entregas
   - Performance de vendedores

## Como Usar

1. Execute o script SQL principal para criar o banco de dados:
```sql
mysql -u seu_usuario -p < mm.session.sql
```

2. O banco de dados será criado com:
   - Todas as tabelas necessárias
   - Dados de exemplo
   - Consultas de exemplo

## Modelo de Dados

### Principais Entidades:
- Cliente (PF/PJ)
- Produto
- Pedido
- Pagamento
- Entrega
- Estoque
- Fornecedor
- Vendedor

### Relacionamentos:
- Cliente -> Pedidos (1:N)
- Pedido -> Produtos (N:M)
- Pedido -> Pagamentos (1:N)
- Pedido -> Entrega (1:1)
- Produto -> Estoque (N:M)
- Produto -> Fornecedor (N:M)
- Produto -> Vendedor (N:M)

## Tecnologias Utilizadas

- MySQL/MariaDB
- SQL ANSI Standard