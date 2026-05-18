-- ============================================================
-- PROJETO: Análise de Turnover de Colaboradores
-- ARQUIVO 05: Conclusões e Resumo Executivo
-- ============================================================


-- ============================================================
-- VISÃO CONSOLIDADA DE RISCO POR DEPARTAMENTO
-- ============================================================

-- Painel resumido com os principais indicadores por departamento
WITH turnover_depto AS (
    SELECT
        Department,
        COUNT(*) AS total_colaboradores,
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS total_desligados,
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
    t.total_colaboradores,
    t.total_desligados,
    t.taxa_turnover,
    o.pct_overtime        AS pct_hora_extra,
    s.media_salario
FROM turnover_depto AS t
JOIN overtime_depto  AS o ON t.Department = o.Department
JOIN salario_depto   AS s ON t.Department = s.Department
ORDER BY t.taxa_turnover DESC;


-- ============================================================
-- RESUMO EXECUTIVO — PRINCIPAIS ACHADOS DA ANÁLISE
-- ============================================================

/*
=================================================================
ANÁLISE DE TURNOVER — RESUMO EXECUTIVO
Dataset: IBM HR Analytics | 1.470 colaboradores
=================================================================

TAXA GERAL DE TURNOVER: 16,12%
(Acima da média saudável de mercado, que é de 5% a 10%)

-----------------------------------------------------------------
TOP 5 FATORES ASSOCIADOS AO TURNOVER
-----------------------------------------------------------------

1. HORA EXTRA
   - Colaboradores com hora extra: 30% de turnover
   - Sem hora extra: 10% de turnover
   - Jovens abaixo de 30 anos com hora extra: 53% de turnover
   → Principal fator isolado identificado na análise

2. FASE DE ADAPTAÇÃO (0 a 2 anos na empresa)
   - Taxa de turnover: ~30%
   - Os primeiros dois anos são o período mais crítico de retenção
   → Programas de onboarding e mentoria são prioritários aqui

3. NÍVEL HIERÁRQUICO BAIXO (Nível 1)
   - Taxa de turnover: 26,34%
   - Combinado com baixo salário e hora extra, forma o perfil de maior risco
   → Plano de carreira claro pode reduzir essa saída

4. EQUILÍBRIO VIDA/TRABALHO RUIM
   - Colaboradores com Work-Life Balance "Bad": 31% de turnover
   - Fortemente correlacionado com hora extra
   → Políticas de flexibilidade são um alavancador direto de retenção

5. ESTADO CIVIL SOLTEIRO
   - Taxa de turnover: 25%
   - Quase o dobro dos colaboradores casados
   → Pode indicar menor arraigo e maior mobilidade profissional

-----------------------------------------------------------------
CARGOS DE MAIOR RISCO
-----------------------------------------------------------------
- Sales Representative:    ~40% de turnover
- Human Resources:         ~23% de turnover
- Laboratory Technician:   ~24% de turnover

-----------------------------------------------------------------
PERFIL DE COLABORADOR DE MAIOR RISCO
-----------------------------------------------------------------
  Abaixo de 30 anos
  - Solteiro
  - Nível hierárquico 1
  - Faz hora extra
  - Até 2 anos na empresa
  - Cargo: Sales Representative ou Lab Technician

-----------------------------------------------------------------
RECOMENDAÇÕES DE NEGÓCIO
-----------------------------------------------------------------
1. Revisar política de hora extra, sendo um impacto direto e mensurável
2. Fortalecer onboarding nos primeiros 24 meses
3. Criar plano de carreira visível para colaboradores nível 1
4. Desenvolver ações específicas para Sales Representatives
5. Monitorar satisfação com ambiente de trabalho (maior impacto entre os 4 fatores de satisfação)

=================================================================
*/