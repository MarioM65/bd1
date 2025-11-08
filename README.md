# Oficina (Oficina DB)

Este repositório contém um modelo relacional e o script SQL para uma oficina mecânica. O objetivo é fornecer um esquema consistente (PF/PJ, veículos, mecânicos, ordens de serviço, serviços, peças, pagamentos e entregas), dados de teste e consultas exemplares para demonstração e avaliação.

## O que há aqui

- `mm.session.sql`: script SQL que cria o banco `oficina_db`, define o esquema relacional, popula dados de teste e contém consultas complexas de exemplo.

## Entidades principais

- client (PF/PJ)
- vehicle
- mechanic
- service_type
- part
- supplier
- work_order (ordem de serviço)
- work_order_service
- work_order_part
- payment_method
- payment
- delivery

## Como executar

1. No MySQL/MariaDB, execute o script para criar o banco e inserir dados:

```bash
mysql -u seu_usuario -p < mm.session.sql
```

2. Após execução, use o cliente MySQL para rodar as consultas presentes no final do arquivo `mm.session.sql`.

## Consultas de destaque (implementadas no script)

- Recuperações simples com SELECT
- Filtros com WHERE
- Atributos derivados (subtotal, impostos)
- Ordenação com ORDER BY (ex.: mecânicos por receita)
- Filtros em grupos com HAVING (ex.: clientes com gasto médio acima de X)
- Junções complexas com agregações e GROUP_CONCAT para resumos

## Notas de modelagem

- Clientes PF e PJ estão modelados com uma tabela base `client` e duas tabelas específicas (`client_pf`, `client_pj`). Um cliente é um ou outro.
- Pagamentos permitem múltiplas formas por ordem (tabela `payment` + `payment_method`).
- Entrega/retirada do veículo possui status e, quando aplicável, código de rastreio (tabela `delivery`).

## Próximos passos sugeridos

- Adicionar constraints mais ricas (triggers para atualizar `final_total` automaticamente).
- Criar views para relatórios frequentes (faturamento mensal, peças mais usadas).
- Adicionar testes automatizados (scripts SQL ou integração com um framework de testes).

---
Feito por: projeto de oficina — script e consultas no `mm.session.sql`.