# hr-attrition-risk-analysis
Projeto de HR Analytics focado em turnover de funcionários, análise de risco e geração de insights de negócio utilizando SQL e visualização de dados.

# Análise de Turnover de Colaboradores — IBM HR Dataset

Projeto de análise de dados desenvolvido com **SQL** para identificar os principais fatores associados ao desligamento de colaboradores em uma empresa fictícia da IBM.

O objetivo é demonstrar habilidades analíticas e de negócio relevantes para uma posição de **Analista de Dados Júnior**, combinando queries SQL estruturadas com interpretação orientada a decisões de RH.

---

## Estrutura do Projeto

```
hr-attrition-analysis/
│
|
├── sql/
│   ├── 01_setup_e_exploracao.sql          # Configuração, validação e criação da tabela analítica
│   ├── 02_turnover_e_departamentos.sql    # Turnover geral, por departamento e análise salarial   
|   ├── 03_perfil_colaborador.sql          # Hora extra, faixa etária, cargo, distância, viagens
|   ├── 04_satisfacao_e_carreira.sql       # Satisfação, promoção, tempo na empresa e remuneração
│   └── 05_conclusoes.sql                  # Painel consolidado e resumo executivo
│
└── README.md
│
└── WA_Fn-UseC_-HR-Employee-Attrition.csv  # Dataset original (IBM HR Analytics)
```

---

## Perguntas de Negócio Respondidas

- Qual é a taxa geral de turnover da empresa?
- Quais departamentos e cargos têm maior rotatividade?
- Colaboradores que fazem hora extra saem mais?
- Qual é o perfil demográfico de quem mais sai?
- Satisfação com o trabalho, ambiente e vida pessoal influenciam o desligamento?
- Falta de promoção e tempo na empresa têm relação com o turnover?
- Colaboradores que saíram ganhavam menos do que os que ficaram?

---

## Principais Achados

| Fator | Grupo de Maior Risco | Taxa de Turnover |
|---|---|---|
| Hora Extra | Com hora extra | 30% |
| Hora Extra + Idade | Abaixo de 30 com hora extra | **53%** |
| Fase na empresa | Adaptação (0–2 anos) | ~30% |
| Work-Life Balance | Ruim (Bad) | 31% |
| Estado Civil | Solteiros | 25% |
| Nível Hierárquico | Nível 1 | 26% |
| Cargo | Sales Representative | ~40% |

**Perfil de maior risco:** colaborador jovem (< 30 anos), solteiro, nível hierárquico 1, com hora extra, nos primeiros 2 anos de empresa.

---

## Técnicas SQL Utilizadas

| Técnica | Onde foi aplicada |
|---|---|
| `CTE` (Common Table Expressions) | Organização de queries complexas e encadeamento de análises |
| `Window Functions` — `RANK()`, `AVG() OVER` | Ranking salarial e comparação individual vs. grupo |
| `CASE WHEN` | Criação de faixas (idade, distância, carreira, satisfação) |
| `GROUP BY` + `HAVING` | Agregações e filtros sobre grupos |
| `Subquery correlacionada` | Colaboradores abaixo da média salarial do próprio cargo |
| `EXISTS` | Verificação de perfis de risco por departamento |
| `JOIN` com CTE | Cruzamento de múltiplas agregações |
| `CREATE VIEW` | Reutilização da lógica de turnover por departamento |
| `CREATE TABLE AS SELECT` | Tabela analítica consolidada com labels legíveis |
| `NULLIF`, `CAST`, `ROUND` | Tratamento de divisão por zero e formatação |

---

## Dataset

- **Fonte:** [IBM HR Analytics Employee Attrition & Performance](https://www.kaggle.com/datasets/pavansubhasht/ibm-hr-analytics-attrition-dataset)
- **Registros:** 1.470 colaboradores
- **Colunas:** 35 variáveis (demográficas, de cargo, satisfação e histórico profissional)
- **Variável-alvo:** `Attrition` (Yes/No)

---

## 📌 Tecnologias

![SQLite](https://img.shields.io/badge/SQLite-003B57?style=for-the-badge&logo=sqlite&logoColor=white)
