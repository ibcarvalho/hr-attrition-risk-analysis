-- ============================================================
-- PROJETO: Análise de Turnover de Colaboradores
-- ARQUIVO 03: Perfil do Colaborador x Turnover
-- ============================================================


-- ============================================================
-- BLOCO 1: HORA EXTRA x TURNOVER
-- ============================================================

-- Taxa de desligamento entre quem faz e quem não faz hora extra
SELECT
    OverTime,
    COUNT(*) AS total_colaboradores,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS total_desligados,
    ROUND(CAST(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100, 2) AS taxa_turnover
FROM HR_analise_consolidada
GROUP BY OverTime;
-- Colaboradores com hora extra apresentam taxa de turnover de 30%, significativamente maior do que os sem hora extra (10%)


-- Hora extra cruzada com departamento
SELECT
    Department,
    OverTime,
    COUNT(*) AS total_colaboradores,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS total_desligados,
    ROUND(CAST(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100, 2) AS taxa_turnover
FROM HR_analise_consolidada
GROUP BY Department, OverTime
ORDER BY Department, OverTime DESC;
-- A hora extra eleva consistentemente a taxa de turnover em todos os departamentos, variando de 25% a 37,5%


-- ============================================================
-- BLOCO 2: ESTADO CIVIL x TURNOVER
-- ============================================================

SELECT
    MaritalStatus,
    COUNT(*) AS total_colaboradores,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS total_desligados,
    ROUND(CAST(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100, 2) AS taxa_turnover
FROM HR_analise_consolidada
GROUP BY MaritalStatus
ORDER BY taxa_turnover DESC;
-- Colaboradores solteiros apresentam a maior taxa de turnover (25%), quase o dobro dos casados


-- ============================================================
-- BLOCO 3: GÊNERO x TURNOVER
-- ============================================================

SELECT
    Gender,
    COUNT(*) AS total_colaboradores,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS total_desligados,
    ROUND(CAST(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100, 2) AS taxa_turnover
FROM HR_analise_consolidada
GROUP BY Gender
ORDER BY taxa_turnover DESC;
-- Gênero isoladamente não é um fator determinante para o turnover


-- ============================================================
-- BLOCO 4: FAIXA ETÁRIA x TURNOVER
-- ============================================================

WITH faixa_etaria AS (
    SELECT *,
        CASE
            WHEN Age < 30 THEN 'Abaixo de 30'
            WHEN Age BETWEEN 30 AND 40 THEN '30 a 40'
            ELSE 'Acima de 40'
        END AS faixa_idade
    FROM HR_analise_consolidada
)
SELECT
    faixa_idade,
    COUNT(*) AS total_colaboradores,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS total_desligados,
    ROUND(CAST(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100, 2) AS taxa_turnover
FROM faixa_etaria
GROUP BY faixa_idade
ORDER BY taxa_turnover DESC;
-- Colaboradores abaixo de 30 anos apresentam a maior taxa de turnover entre as faixas etárias


-- Faixa etária cruzada com hora extra (combinação de maior risco)
SELECT
    CASE
        WHEN Age < 30 THEN 'Abaixo de 30'
        WHEN Age BETWEEN 30 AND 40 THEN '30 a 40'
        ELSE 'Acima de 40'
    END AS faixa_idade,
    OverTime,
    COUNT(*) AS total_colaboradores,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS total_desligados,
    ROUND(CAST(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100, 2) AS taxa_turnover
FROM HR_analise_consolidada
GROUP BY OverTime, faixa_idade
ORDER BY OverTime DESC, faixa_idade;
-- Colaboradores abaixo de 30 anos com hora extra apresentam taxa de turnover de 53% — quase o dobro do próximo grupo mais crítico


-- ============================================================
-- BLOCO 5: CARGO x TURNOVER
-- ============================================================

SELECT
    JobRole,
    COUNT(*) AS total_colaboradores,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS total_desligados,
    ROUND(CAST(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100, 2) AS taxa_turnover
FROM HR_analise_consolidada
GROUP BY JobRole
ORDER BY taxa_turnover DESC;
-- Representantes de Vendas lideram com quase 40% de turnover, seguidos por RH e Técnicos de Laboratório (23–24%)


-- ============================================================
-- BLOCO 6: DISTÂNCIA DE CASA x CARGO x TURNOVER
-- Focado nos cargos de maior risco identificados acima
-- ============================================================

WITH deslocamento AS (
    SELECT *,
        CASE
            WHEN DistanceFromHome BETWEEN 1 AND 10 THEN 'Próximo (1-10)'
            WHEN DistanceFromHome BETWEEN 11 AND 20 THEN 'Médio (11-20)'
            ELSE 'Distante (21+)'
        END AS faixa_distancia
    FROM HR_analise_consolidada
    WHERE JobRole IN ('Sales Representative', 'Laboratory Technician', 'Human Resources')
)
SELECT
    Department,
    JobRole,
    faixa_distancia,
    COUNT(*) AS total_colaboradores,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS total_desligados,
    ROUND(CAST(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100, 2) AS taxa_turnover
FROM deslocamento
GROUP BY Department, JobRole, faixa_distancia
ORDER BY taxa_turnover DESC;


-- ============================================================
-- BLOCO 7: VIAGENS A TRABALHO x TURNOVER
-- ============================================================

-- Frequência de viagens profissionais como fator de desgaste
SELECT
    BusinessTravel,
    COUNT(*) AS total_colaboradores,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS total_desligados,
    ROUND(CAST(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100, 2) AS taxa_turnover
FROM HR_analise_consolidada
GROUP BY BusinessTravel
ORDER BY taxa_turnover DESC;
-- Colaboradores que viajam frequentemente apresentam maior taxa de turnover do que os que viajam raramente ou não viajam


-- ============================================================
-- BLOCO 8: VERIFICAÇÃO DE PERFIL DE ALTO RISCO
-- ============================================================

-- Identifica departamentos que possuem colaboradores jovens, com hora extra E solteiros
SELECT DISTINCT Department
FROM HR_analise_consolidada AS externo
WHERE EXISTS (
    SELECT 1
    FROM HR_analise_consolidada AS interno
    WHERE interno.Department = externo.Department
      AND interno.Age < 30
      AND interno.OverTime = 'Yes'
      AND interno.MaritalStatus = 'Single'
      AND interno.Attrition = 'Yes'
);
-- Departamentos retornados concentram o perfil de maior risco de turnover identificado na análise
