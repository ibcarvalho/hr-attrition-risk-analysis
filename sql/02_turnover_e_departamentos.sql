
-- ============================================================
-- PROJETO: Análise de Turnover de Colaboradores
-- ARQUIVO 02: Análise de Turnover e Departamentos
-- ============================================================


-- ============================================================
-- BLOCO 1: TURNOVER GERAL
-- ============================================================

-- Taxa de turnover global da empresa
WITH turnover AS (
    SELECT
        COUNT(*) AS total_colaboradores,
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS total_desligados
    FROM HR_analise_consolidada
)
SELECT ROUND((total_desligados * 100.0) / total_colaboradores, 2) AS percentual_desligados
FROM turnover;
-- A empresa possui uma taxa de turnover de 16,12%, acima da média saudável de mercado (5–10%)


-- ============================================================
-- BLOCO 2: TURNOVER POR DEPARTAMENTO
-- ============================================================

-- Contagem de colaboradores, desligados e taxa de turnover por departamento
WITH turnover_departamento AS (
    SELECT
        Department,
        COUNT(*) AS total_colaboradores,
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS total_desligados
    FROM HR_analise_consolidada
    GROUP BY Department
)
SELECT
    Department,
    total_colaboradores,
    total_desligados,
    ROUND((total_desligados * 100.0) / NULLIF(total_colaboradores, 0), 2) AS taxa_turnover
FROM turnover_departamento
ORDER BY taxa_turnover DESC;
-- Vendas lidera com a maior taxa de turnover, seguido por RH e P&D


-- Criando uma VIEW reutilizável de turnover por departamento
CREATE VIEW IF NOT EXISTS dep_turnover AS
SELECT
    Department,
    COUNT(*) AS total_colaboradores,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS total_desligados,
    ROUND((SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0) / NULLIF(COUNT(*), 0), 2) AS taxa_turnover
FROM HR_analise_consolidada
GROUP BY Department;

SELECT * FROM dep_turnover;


-- ============================================================
-- BLOCO 3: PERFIL SALARIAL E ETÁRIO POR DEPARTAMENTO
-- ============================================================

-- Média de idade e salário por departamento (GROUP BY)
SELECT
    Department,
    ROUND(AVG(Age), 0)           AS media_idade,
    ROUND(AVG(MonthlyIncome), 2) AS media_salario
FROM HR_analise_consolidada
GROUP BY Department;

-- Demonstração alternativa com Window Function (mesmo resultado, abordagem diferente)
-- Útil quando se quer manter o detalhe por colaborador junto com o agregado do grupo
SELECT DISTINCT
    Department,
    AVG(MonthlyIncome) OVER (PARTITION BY Department) AS media_salario_depto,
    AVG(Age)           OVER (PARTITION BY Department) AS media_idade_depto
FROM HR_analise_consolidada;


-- ============================================================
-- BLOCO 4: SALÁRIO INDIVIDUAL VS. MÉDIA DO DEPARTAMENTO
-- ============================================================

-- Posição salarial de cada colaborador em relação à média do seu departamento
WITH media_salario AS (
    SELECT
        Department,
        AVG(MonthlyIncome) AS media_salario_depto
    FROM HR_analise_consolidada
    GROUP BY Department
)
SELECT
    hr.EmployeeNumber,
    hr.Department,
    hr.MonthlyIncome,
    ROUND(s.media_salario_depto, 2) AS media_depto,
    ROUND(hr.MonthlyIncome - s.media_salario_depto, 2) AS diferenca_vs_media
FROM HR_analise_consolidada AS hr
LEFT JOIN media_salario AS s ON hr.Department = s.Department;


-- ============================================================
-- BLOCO 5: RANKING SALARIAL POR DEPARTAMENTO
-- ============================================================

-- Ranking completo de salários dentro de cada departamento
SELECT
    EmployeeNumber,
    Department,
    JobRole,
    MonthlyIncome,
    RANK() OVER (PARTITION BY Department ORDER BY MonthlyIncome DESC) AS ranking_salario
FROM HR_analise_consolidada;

-- Top 3 maiores salários por departamento
WITH ranking_salarios AS (
    SELECT
        EmployeeNumber,
        Department,
        JobRole,
        MonthlyIncome,
        RANK() OVER (PARTITION BY Department ORDER BY MonthlyIncome DESC) AS ranking_salario
    FROM HR_analise_consolidada
)
SELECT * FROM ranking_salarios WHERE ranking_salario <= 3;

-- Posição de cada colaborador acima ou abaixo da média do departamento
SELECT
    EmployeeNumber,
    Department,
    MonthlyIncome,
    ROUND(AVG(MonthlyIncome) OVER (PARTITION BY Department), 2) AS media_depto,
    ROUND(MonthlyIncome - AVG(MonthlyIncome) OVER (PARTITION BY Department), 2) AS acima_abaixo_media
FROM HR_analise_consolidada;


-- ============================================================
-- BLOCO 6: SALÁRIO MÉDIO — QUEM SAIU VS. QUEM FICOU
-- ============================================================

-- Colaboradores que saíram recebiam menos? Análise por departamento
SELECT
    Attrition,
    Department,
    ROUND(AVG(MonthlyIncome), 2) AS media_salario
FROM HR_analise_consolidada
GROUP BY Department, Attrition
ORDER BY Department, Attrition;
-- Em todos os departamentos, colaboradores desligados tinham salário médio inferior aos que permaneceram


-- ============================================================
-- BLOCO 7: COLABORADORES ABAIXO DA MÉDIA SALARIAL DO CARGO
-- ============================================================

-- Identifica colaboradores que recebem abaixo da média do seu próprio cargo
SELECT
    EmployeeNumber,
    JobRole,
    MonthlyIncome
FROM HR_analise_consolidada AS externo
WHERE MonthlyIncome < (
    SELECT AVG(MonthlyIncome)
    FROM HR_analise_consolidada AS interno
    WHERE interno.JobRole = externo.JobRole
)
ORDER BY JobRole, MonthlyIncome;
-- Colaboradores nesta lista têm maior risco de turnover por questões salariais relativas ao cargo
