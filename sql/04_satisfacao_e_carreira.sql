-- ============================================================
-- PROJETO: Análise de Turnover de Colaboradores
-- ARQUIVO 04: Satisfação, Carreira e Remuneração
-- ============================================================


-- ============================================================
-- BLOCO 1: SATISFAÇÃO COM O TRABALHO x TURNOVER
-- ============================================================

SELECT
    Satisfaction_level,
    COUNT(*) AS total_colaboradores,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS total_desligados,
    ROUND(CAST(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100, 2) AS taxa_turnover
FROM HR_analise_consolidada
GROUP BY Satisfaction_level
ORDER BY taxa_turnover DESC;
-- Baixa satisfação com o trabalho está associada à maior taxa de turnover (22,84%), com queda progressiva nos níveis superiores


-- ============================================================
-- BLOCO 2: SATISFAÇÃO COM O AMBIENTE x TURNOVER
-- ============================================================

SELECT
    Environment_Satisfaction,
    COUNT(*) AS total_colaboradores,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS total_desligados,
    ROUND(CAST(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100, 2) AS taxa_turnover
FROM HR_analise_consolidada
GROUP BY Environment_Satisfaction
ORDER BY taxa_turnover DESC;
-- Insatisfação com o ambiente de trabalho é o fator de satisfação com maior impacto: mais de 25% de turnover no nível baixo


-- ============================================================
-- BLOCO 3: SATISFAÇÃO COM RELACIONAMENTOS x TURNOVER
-- ============================================================

SELECT
    Relationship_Satisfaction,
    COUNT(*) AS total_colaboradores,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS total_desligados,
    ROUND(CAST(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100, 2) AS taxa_turnover
FROM HR_analise_consolidada
GROUP BY Relationship_Satisfaction
ORDER BY taxa_turnover DESC;
-- Baixa satisfação nos relacionamentos está associada a taxas de turnover acima de 20%


-- ============================================================
-- BLOCO 4: EQUILÍBRIO VIDA-TRABALHO x TURNOVER
-- ============================================================

SELECT
    Work_LifeBalance,
    COUNT(*) AS total_colaboradores,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS total_desligados,
    ROUND(CAST(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100, 2) AS taxa_turnover
FROM HR_analise_consolidada
GROUP BY Work_LifeBalance
ORDER BY taxa_turnover DESC;
-- Equilíbrio vida/trabalho ruim está associado à taxa mais alta de turnover: acima de 31%


-- ============================================================
-- BLOCO 5: TEMPO SEM PROMOÇÃO x TURNOVER
-- ============================================================

SELECT
    CASE
        WHEN YearsSinceLastPromotion < 2         THEN 'Abaixo de 2 anos'
        WHEN YearsSinceLastPromotion BETWEEN 2 AND 5 THEN '2 a 5 anos'
        ELSE 'Acima de 5 anos'
    END AS tempo_sem_promocao,
    COUNT(*) AS total_colaboradores,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS total_desligados,
    ROUND(CAST(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100, 2) AS taxa_turnover
FROM HR_analise_consolidada
GROUP BY tempo_sem_promocao
ORDER BY taxa_turnover DESC;


-- ============================================================
-- BLOCO 6: TEMPO NA EMPRESA (FASE DE CARREIRA) x TURNOVER
-- ============================================================

SELECT
    CASE
        WHEN YearsAtCompany BETWEEN 0 AND 2 THEN 'Fase de Adaptação (0-2 anos)'
        WHEN YearsAtCompany BETWEEN 3 AND 5 THEN 'Fase de Crescimento (3-5 anos)'
        ELSE 'Fase de Liderança (6+ anos)'
    END AS fase_carreira,
    COUNT(*) AS total_colaboradores,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS total_desligados,
    ROUND(CAST(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100, 2) AS taxa_turnover
FROM HR_analise_consolidada
GROUP BY fase_carreira
ORDER BY taxa_turnover DESC;
-- Colaboradores na fase de adaptação (0 a 2 anos) apresentam quase 30% de turnover — o maior risco da jornada


-- ============================================================
-- BLOCO 7: NÍVEL HIERÁRQUICO x TURNOVER
-- ============================================================

SELECT
    JobLevel,
    COUNT(*) AS total_colaboradores,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS total_desligados,
    ROUND(CAST(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100, 2) AS taxa_turnover
FROM HR_analise_consolidada
GROUP BY JobLevel
ORDER BY taxa_turnover DESC;
-- Colaboradores no nível hierárquico mais baixo (nível 1) apresentam taxa de turnover de 26,34%


-- ============================================================
-- BLOCO 8: AUMENTO SALARIAL x TURNOVER
-- ============================================================

-- Verificando distribuição dos percentuais de aumento
SELECT DISTINCT PercentSalaryHike
FROM HR_analise_consolidada
ORDER BY PercentSalaryHike;

-- Taxa de turnover por faixa de aumento salarial
SELECT
    CASE
        WHEN PercentSalaryHike <= 14 THEN 'Baixo (até 14%)'
        WHEN PercentSalaryHike >= 20 THEN 'Alto (20%+)'
        ELSE 'Médio (15-19%)'
    END AS faixa_aumento,
    COUNT(*) AS total_colaboradores,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS total_desligados,
    ROUND(CAST(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100, 2) AS taxa_turnover
FROM HR_analise_consolidada
GROUP BY faixa_aumento
ORDER BY taxa_turnover DESC;
-- Aumentos salariais menores estão associados a taxas de turnover levemente superiores, mas o impacto é menos expressivo do que fatores comportamentais


-- ============================================================
-- BLOCO 9: CARGOS COM ALTA CONCENTRAÇÃO DE INSATISFAÇÃO
-- ============================================================

-- Identifica cargos onde a maioria dos colaboradores tem satisfação baixa
SELECT
    JobRole,
    COUNT(*) AS total_colaboradores,
    SUM(CASE WHEN Satisfaction_level = 'Low' THEN 1 ELSE 0 END) AS insatisfeitos,
    ROUND(CAST(SUM(CASE WHEN Satisfaction_level = 'Low' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100, 2) AS '%_insatisfeitos'
FROM HR_analise_consolidada
GROUP BY JobRole
HAVING '%_insatisfeitos' > 20
ORDER BY '%_insatisfeitos' DESC;
-- Cargos com mais de 20% de colaboradores insatisfeitos são candidatos prioritários para ações de retenção


-- ============================================================
-- BLOCO 10: PERFIL CONSOLIDADO DE RISCO
-- ============================================================

-- Combina múltiplos fatores de risco em uma única análise por departamento
-- Técnica: múltiplas CTEs encadeadas — organização e legibilidade para análises complexas
WITH turnover_depto AS (
    SELECT
        Department,
        ROUND(CAST(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100, 2) AS taxa_turnover
    FROM HR_analise_consolidada
    GROUP BY Department
),
overtime_depto AS (
    SELECT
        Department,
        ROUND(CAST(SUM(CASE WHEN OverTime = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100, 2) AS pct_overtime
    FROM HR_analise_consolidada
    GROUP BY Department
),
salario_depto AS (
    SELECT
        Department,
        ROUND(AVG(MonthlyIncome), 2) AS media_salario
    FROM HR_analise_consolidada
    GROUP BY Department
)
SELECT
    t.Department,
    t.taxa_turnover,
    o.pct_overtime,
    s.media_salario
FROM turnover_depto AS t
JOIN overtime_depto  AS o ON t.Department = o.Department
JOIN salario_depto   AS s ON t.Department = s.Department
ORDER BY t.taxa_turnover DESC;
-- Visão consolidada por departamento: turnover, hora extra e salário médio
-- Base para priorização de ações
