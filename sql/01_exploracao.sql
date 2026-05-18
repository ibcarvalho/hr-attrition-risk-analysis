-- ============================================================
-- PROJETO: Análise de Turnover de Colaboradores
-- Fonte de dados: IBM HR Analytics Employee Attrition & Performance
-- ============================================================

-- ============================================================
-- BLOCO 1: CONFIGURAÇÃO INICIAL
-- ============================================================

-- Renomeando a tabela importada para um nome mais legível
ALTER TABLE "WA_Fn-UseC_-HR-Employee-Attrition" RENAME TO HR_db;


-- ============================================================
-- BLOCO 2: ENTENDENDO A BASE DE DADOS
-- ============================================================

-- Verificando estrutura da tabela (colunas e tipos)
PRAGMA table_info('HR_db');

-- Visualizando as primeiras linhas
SELECT * FROM HR_db LIMIT 10;


-- ============================================================
-- BLOCO 3: VALIDAÇÃO DE QUALIDADE DOS DADOS
-- ============================================================

-- Verificando valores distintos de JobLevel para entender a hierarquia
SELECT DISTINCT JobLevel FROM HR_db;

-- Confirmando quais cargos pertencem aos níveis mais altos (4 e 5)
SELECT JobLevel, JobRole 
FROM HR_db 
WHERE JobLevel IN (4, 5)
ORDER BY JobLevel DESC;

-- Verificando se há EmployeeNumber duplicado
SELECT COUNT(EmployeeNumber) AS contagem 
FROM HR_db 
GROUP BY EmployeeNumber 
HAVING contagem > 1;
-- Resultado esperado: nenhuma linha retornada (sem duplicatas)

-- Verificando colunas sem variação (não agregam valor analítico)
SELECT EmployeeCount, StandardHours 
FROM HR_db 
WHERE EmployeeCount <> 1 OR StandardHours <> 80;
-- Resultado esperado: nenhuma linha. Valores sempre constantes, colunas descartadas

-- Confirmando que todos os colaboradores são maiores de idade
SELECT Over18 FROM HR_db WHERE Over18 <> 'Y';
-- Resultado esperado: nenhuma linha. Coluna sem variação, descartada

-- ============================================================
-- BLOCO 4: CHECAGEM DE VALORES NULOS NAS COLUNAS PRINCIPAIS
-- ============================================================

SELECT 
    COUNT(*) - COUNT(Attrition)    AS nulos_turnover,
    COUNT(*) - COUNT(Age)          AS nulos_idade,
    COUNT(*) - COUNT(MonthlyIncome) AS nulos_salario
FROM HR_db;
-- Resultado esperado: zeros em todas as colunas. Base sem nulos nas variáveis chave


-- ============================================================
-- BLOCO 5: CRIAÇÃO DA TABELA ANALÍTICA CONSOLIDADA
-- ============================================================

-- Teste da estrutura via CTE antes de criar a tabela
WITH HR_analise AS (
    SELECT
        EmployeeNumber,
        Age,
        Attrition,
        BusinessTravel,
        Department,
        DistanceFromHome,
        EducationField,

        CASE EnvironmentSatisfaction
            WHEN 1 THEN 'Low' WHEN 2 THEN 'Medium'
            WHEN 3 THEN 'High' ELSE 'Very High'
        END AS Environment_Satisfaction,

        Gender,
        JobRole,
        JobLevel,
        MonthlyIncome,

        CASE JobInvolvement
            WHEN 1 THEN 'Low' WHEN 2 THEN 'Medium'
            WHEN 3 THEN 'High' ELSE 'Very High'
        END AS Job_involvement,

        CASE Education
            WHEN 1 THEN 'Below College' WHEN 2 THEN 'College'
            WHEN 3 THEN 'Bachelor' WHEN 4 THEN 'Master' ELSE 'Doctor'
        END AS Education_level,

        CASE JobSatisfaction
            WHEN 1 THEN 'Low' WHEN 2 THEN 'Medium'
            WHEN 3 THEN 'High' ELSE 'Very High'
        END AS Satisfaction_level,

        MaritalStatus,
        NumCompaniesWorked,
        OverTime,
        PercentSalaryHike,
        PerformanceRating,

        CASE RelationshipSatisfaction
            WHEN 1 THEN 'Low' WHEN 2 THEN 'Medium'
            WHEN 3 THEN 'High' ELSE 'Very High'
        END AS Relationship_Satisfaction,

        StockOptionLevel,
        TotalWorkingYears,
        TrainingTimesLastYear,

        CASE WorkLifeBalance
            WHEN 1 THEN 'Bad' WHEN 2 THEN 'Good'
            WHEN 3 THEN 'Better' ELSE 'Best'
        END AS Work_LifeBalance,

        YearsAtCompany,
        YearsInCurrentRole,
        YearsSinceLastPromotion,
        YearsWithCurrManager
    FROM HR_db
)
SELECT * FROM HR_analise LIMIT 10;

-- Criando a tabela consolidada definitiva (com DROP para permitir re-execução)
DROP TABLE IF EXISTS HR_analise_consolidada;

CREATE TABLE HR_analise_consolidada AS
    SELECT
        EmployeeNumber,
        Age,
        Attrition,
        BusinessTravel,
        Department,
        DistanceFromHome,
        EducationField,

        CASE EnvironmentSatisfaction
            WHEN 1 THEN 'Low' WHEN 2 THEN 'Medium'
            WHEN 3 THEN 'High' ELSE 'Very High'
        END AS Environment_Satisfaction,

        Gender,
        JobRole,
        JobLevel,
        MonthlyIncome,

        CASE JobInvolvement
            WHEN 1 THEN 'Low' WHEN 2 THEN 'Medium'
            WHEN 3 THEN 'High' ELSE 'Very High'
        END AS Job_involvement,

        CASE Education
            WHEN 1 THEN 'Below College' WHEN 2 THEN 'College'
            WHEN 3 THEN 'Bachelor' WHEN 4 THEN 'Master' ELSE 'Doctor'
        END AS Education_level,

        CASE JobSatisfaction
            WHEN 1 THEN 'Low' WHEN 2 THEN 'Medium'
            WHEN 3 THEN 'High' ELSE 'Very High'
        END AS Satisfaction_level,

        MaritalStatus,
        NumCompaniesWorked,
        OverTime,
        PercentSalaryHike,
        PerformanceRating,

        CASE RelationshipSatisfaction
            WHEN 1 THEN 'Low' WHEN 2 THEN 'Medium'
            WHEN 3 THEN 'High' ELSE 'Very High'
        END AS Relationship_Satisfaction,

        StockOptionLevel,
        TotalWorkingYears,
        TrainingTimesLastYear,

        CASE WorkLifeBalance
            WHEN 1 THEN 'Bad' WHEN 2 THEN 'Good'
            WHEN 3 THEN 'Better' ELSE 'Best'
        END AS Work_LifeBalance,

        YearsAtCompany,
        YearsInCurrentRole,
        YearsSinceLastPromotion,
        YearsWithCurrManager
    FROM HR_db;

-- Validando a tabela criada
PRAGMA table_info('HR_analise_consolidada');
SELECT * FROM HR_analise_consolidada LIMIT 10;
