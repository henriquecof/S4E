/****** Object:  Procedure [dbo].[BI_Procedimentos]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE dbo.BI_Procedimentos

-- =============================================
-- Author:      henrique.almeida
-- Create date: 10/02/2022 
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO NO ESTILO T-SQL
-- =============================================



AS
  BEGIN

INSERT INTO migracao2019bi..procedimentos (cd_sequencial_consulta,
                                           dt_servico,
                                           cd_associado,
                                           cd_sequencial_dep,
                                           nm_responsavel,
                                           nu_matricula,
                                           nm_dependente,
                                           cd_empresa,
                                           nm_razsoc,
                                           cd_servico,
                                           nm_servico,
                                           cd_ud,
                                           oclusal,
                                           distral,
                                           mesial,
                                           vestibular,
                                           lingual,
                                           cd_funcionario,
                                           nm_empregado,
                                           cd_filial,
                                           nm_filial,
                                           dt_baixa,
                                           nr_guia,
                                           status,
                                           vl_particular,
                                           vl_produtividade,
                                           cd_sequencial_agenda,
                                           ufidfil,
                                           nmuffil,
                                           cididfil,
                                           nmcidfil,
                                           baiidfil,
                                           nmbaifil,
                                           ufidass,
                                           nmufass,
                                           cididass,
                                           nmcidass,
                                           baiidass,
                                           nmbaiass,
                                           cd_especialidade,
                                           nm_especialidade,
                                           ano,
                                           mes,
                                           cd_tipo,
                                           tipo,
                                           cd_sequencial_exame,
                                           nm_dentista_exame,
                                           qt_proc_exames,
                                           nr_orcamento,
                                           idade,
                                           nm_plano)

  SELECT DISTINCT C.cd_sequencial,
                  C.dt_servico,
                  ASS.cd_associado,
                  C.cd_sequencial_dep,
                  ASS.nm_completo,
                  ASS.nu_matricula,
                  DEP.nm_dependente,
                  ASS.cd_empresa,
                  E.nm_razsoc,
                  C.cd_servico,
                  S.nm_servico,
                  C.cd_ud,
                  C.oclusal,
                  C.distral,
                  C.mesial,
                  C.vestibular,
                  C.lingual,
                  C.cd_funcionario,
                  F.nm_empregado,
                  FI.cd_filial,
                  FI.nm_filial,
                  C.dt_baixa,
                  C.nr_numero_lote,
                  C.status,
                  TC.vl_servico,

                  --*******************************************************************
                  CASE
                    WHEN C.status = 7 AND
                      T52.tipo = 2 THEN 0
                    ELSE CASE
                        WHEN T15.cd_orcamento IS NOT NULL THEN ISNULL(T15.vl_servico, 0)
                        ELSE CASE
                            WHEN C.dt_servico IS NOT NULL AND
                              C.nr_numero_lote IS NOT NULL THEN ISNULL(C.vl_pago_produtividade, 0)
                            ELSE CASE
                                WHEN (SELECT COUNT(0)
                                      FROM plano_servico
                                      WHERE cd_servico = C.cd_servico
                                        AND cd_plano = DEP.cd_plano) > 0 OR
                                  C.status = 6 THEN ISNULL(CASE
                                    WHEN ISNULL(T41.refatualizacaotabeladentista, 1) = 1 THEN --Última tabela

                                      CASE
                                        WHEN ISNULL(T41.localtabelapagamentodentista, 1) = 1 THEN --Tabela por dentista

                                          CASE
                                            WHEN ISNULL(T41.tipovalorcalculoprodutividadedentista, 1) = 1 THEN --Valor em R$
                                              ISNULL(ISNULL((SELECT TOP 1 TT1.vl_servico
                                                  FROM tabela_servicos TT1,
                                                       tabela_referencia TT2
                                                  WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                    AND TT1.cd_tabela = F.cd_tabela
                                                    AND TT1.cd_servico = S.cd_servico
                                                    AND TT1.cd_plano = DEP.cd_plano
                                                    AND TT1.cd_especialidade IS NULL
                                                ORDER BY TT2.dt_inicio DESC,
                                                         TT2.cd_tabela_referencia DESC), (SELECT TOP 1 TT1.vl_servico
                                                  FROM tabela_servicos TT1,
                                                       tabela_referencia TT2
                                                  WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                    AND TT1.cd_tabela = F.cd_tabela
                                                    AND TT1.cd_servico = S.cd_servico
                                                    AND TT1.cd_plano IS NULL
                                                    AND TT1.cd_especialidade IS NULL
                                                ORDER BY TT2.dt_inicio DESC,
                                                         TT2.cd_tabela_referencia DESC)), ISNULL(ISNULL((SELECT TOP 1 TT1.vl_servico
                                                  FROM tabela_servicos TT1,
                                                       tabela_referencia TT2
                                                  WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                    AND TT1.cd_tabela = F.cd_tabela
                                                    AND TT1.cd_especialidade = S.cd_especialidadereferencia
                                                    AND TT1.cd_plano = DEP.cd_plano
                                                    AND TT1.cd_servico IS NULL
                                                ORDER BY TT2.dt_inicio DESC,
                                                         TT2.cd_tabela_referencia DESC), (SELECT TOP 1 TT1.vl_servico
                                                  FROM tabela_servicos TT1,
                                                       tabela_referencia TT2
                                                  WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                    AND TT1.cd_tabela = F.cd_tabela
                                                    AND TT1.cd_especialidade = S.cd_especialidadereferencia
                                                    AND TT1.cd_plano IS NULL
                                                    AND TT1.cd_servico IS NULL
                                                ORDER BY TT2.dt_inicio DESC,
                                                         TT2.cd_tabela_referencia DESC)), (SELECT TOP 1 TT1.vl_servico
                                                  FROM tabela_servicos TT1,
                                                       tabela_referencia TT2
                                                  WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                    AND TT1.cd_tabela = F.cd_tabela
                                                    AND TT1.cd_especialidade IS NULL
                                                    AND TT1.cd_plano IS NULL
                                                    AND TT1.cd_servico IS NULL
                                                ORDER BY TT2.dt_inicio DESC,
                                                         TT2.cd_tabela_referencia DESC)))
                                            WHEN T41.tipovalorcalculoprodutividadedentista = 2 THEN --Valor em US, convertido para R$
                                              ISNULL(ISNULL((SELECT TOP 1 ROUND(TT1.vl_servico * S.vl_us, 2)
                                                  FROM tabela_servicos TT1,
                                                       tabela_referencia TT2
                                                  WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                    AND TT1.cd_tabela = F.cd_tabela
                                                    AND TT1.cd_servico = S.cd_servico
                                                    AND TT1.cd_plano = DEP.cd_plano
                                                    AND TT1.cd_especialidade IS NULL
                                                ORDER BY TT2.dt_inicio DESC,
                                                         TT2.cd_tabela_referencia DESC), (SELECT TOP 1 ROUND(TT1.vl_servico * S.vl_us, 2)
                                                  FROM tabela_servicos TT1,
                                                       tabela_referencia TT2
                                                  WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                    AND TT1.cd_tabela = F.cd_tabela
                                                    AND TT1.cd_servico = S.cd_servico
                                                    AND TT1.cd_plano IS NULL
                                                    AND TT1.cd_especialidade IS NULL
                                                ORDER BY TT2.dt_inicio DESC,
                                                         TT2.cd_tabela_referencia DESC)), ISNULL(ISNULL((SELECT TOP 1 ROUND(TT1.vl_servico * S.vl_us, 2)
                                                  FROM tabela_servicos TT1,
                                                       tabela_referencia TT2
                                                  WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                    AND TT1.cd_tabela = F.cd_tabela
                                                    AND TT1.cd_especialidade = S.cd_especialidadereferencia
                                                    AND TT1.cd_plano = DEP.cd_plano
                                                    AND TT1.cd_servico IS NULL
                                                ORDER BY TT2.dt_inicio DESC,
                                                         TT2.cd_tabela_referencia DESC), (SELECT TOP 1 ROUND(TT1.vl_servico * S.vl_us, 2)
                                                  FROM tabela_servicos TT1,
                                                       tabela_referencia TT2
                                                  WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                    AND TT1.cd_tabela = F.cd_tabela
                                                    AND TT1.cd_especialidade = S.cd_especialidadereferencia
                                                    AND TT1.cd_plano IS NULL
                                                    AND TT1.cd_servico IS NULL
                                                ORDER BY TT2.dt_inicio DESC,
                                                         TT2.cd_tabela_referencia DESC)), (SELECT TOP 1 ROUND(TT1.vl_servico * S.vl_us, 2)
                                                  FROM tabela_servicos TT1,
                                                       tabela_referencia TT2
                                                  WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                    AND TT1.cd_tabela = F.cd_tabela
                                                    AND TT1.cd_especialidade IS NULL
                                                    AND TT1.cd_plano IS NULL
                                                    AND TT1.cd_servico IS NULL
                                                ORDER BY TT2.dt_inicio DESC,
                                                         TT2.cd_tabela_referencia DESC)))
                                          END
                                        WHEN T41.localtabelapagamentodentista = 2 THEN --Tabela por clínica

                                          CASE
                                            WHEN ISNULL(T41.tipovalorcalculoprodutividadedentista, 1) = 1 THEN --Valor em R$
                                              ISNULL(ISNULL((SELECT TOP 1 TT1.vl_servico
                                                  FROM tabela_servicos TT1,
                                                       tabela_referencia TT2
                                                  WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                    AND TT1.cd_tabela = FI.cd_tabela
                                                    AND TT1.cd_servico = S.cd_servico
                                                    AND TT1.cd_plano = DEP.cd_plano
                                                    AND TT1.cd_especialidade IS NULL
                                                ORDER BY TT2.dt_inicio DESC,
                                                         TT2.cd_tabela_referencia DESC), (SELECT TOP 1 TT1.vl_servico
                                                  FROM tabela_servicos TT1,
                                                       tabela_referencia TT2
                                                  WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                    AND TT1.cd_tabela = FI.cd_tabela
                                                    AND TT1.cd_servico = S.cd_servico
                                                    AND TT1.cd_plano IS NULL
                                                    AND TT1.cd_especialidade IS NULL
                                                ORDER BY TT2.dt_inicio DESC,
                                                         TT2.cd_tabela_referencia DESC)), ISNULL(ISNULL((SELECT TOP 1 TT1.vl_servico
                                                  FROM tabela_servicos TT1,
                                                       tabela_referencia TT2
                                                  WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                    AND TT1.cd_tabela = FI.cd_tabela
                                                    AND TT1.cd_especialidade = S.cd_especialidadereferencia
                                                    AND TT1.cd_plano = DEP.cd_plano
                                                    AND TT1.cd_servico IS NULL
                                                ORDER BY TT2.dt_inicio DESC,
                                                         TT2.cd_tabela_referencia DESC), (SELECT TOP 1 TT1.vl_servico
                                                  FROM tabela_servicos TT1,
                                                       tabela_referencia TT2
                                                  WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                    AND TT1.cd_tabela = FI.cd_tabela
                                                    AND TT1.cd_especialidade = S.cd_especialidadereferencia
                                                    AND TT1.cd_plano IS NULL
                                                    AND TT1.cd_servico IS NULL
                                                ORDER BY TT2.dt_inicio DESC,
                                                         TT2.cd_tabela_referencia DESC)), (SELECT TOP 1 TT1.vl_servico
                                                  FROM tabela_servicos TT1,
                                                       tabela_referencia TT2
                                                  WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                    AND TT1.cd_tabela = FI.cd_tabela
                                                    AND TT1.cd_especialidade IS NULL
                                                    AND TT1.cd_plano IS NULL
                                                    AND TT1.cd_servico IS NULL
                                                ORDER BY TT2.dt_inicio DESC,
                                                         TT2.cd_tabela_referencia DESC)))
                                            WHEN T41.tipovalorcalculoprodutividadedentista = 2 THEN --Valor em US, convertido para R$
                                              ISNULL(ISNULL((SELECT TOP 1 ROUND(TT1.vl_servico * S.vl_us, 2)
                                                  FROM tabela_servicos TT1,
                                                       tabela_referencia TT2
                                                  WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                    AND TT1.cd_tabela = FI.cd_tabela
                                                    AND TT1.cd_servico = S.cd_servico
                                                    AND TT1.cd_plano = DEP.cd_plano
                                                    AND TT1.cd_especialidade IS NULL
                                                ORDER BY TT2.dt_inicio DESC,
                                                         TT2.cd_tabela_referencia DESC), (SELECT TOP 1 ROUND(TT1.vl_servico * S.vl_us, 2)
                                                  FROM tabela_servicos TT1,
                                                       tabela_referencia TT2
                                                  WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                    AND TT1.cd_tabela = FI.cd_tabela
                                                    AND TT1.cd_servico = S.cd_servico
                                                    AND TT1.cd_plano IS NULL
                                                    AND TT1.cd_especialidade IS NULL
                                                ORDER BY TT2.dt_inicio DESC,
                                                         TT2.cd_tabela_referencia DESC)), ISNULL(ISNULL((SELECT TOP 1 ROUND(TT1.vl_servico * S.vl_us, 2)
                                                  FROM tabela_servicos TT1,
                                                       tabela_referencia TT2
                                                  WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                    AND TT1.cd_tabela = FI.cd_tabela
                                                    AND TT1.cd_especialidade = S.cd_especialidadereferencia
                                                    AND TT1.cd_plano = DEP.cd_plano
                                                    AND TT1.cd_servico IS NULL
                                                ORDER BY TT2.dt_inicio DESC,
                                                         TT2.cd_tabela_referencia DESC), (SELECT TOP 1 ROUND(TT1.vl_servico * S.vl_us, 2)
                                                  FROM tabela_servicos TT1,
                                                       tabela_referencia TT2
                                                  WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                    AND TT1.cd_tabela = FI.cd_tabela
                                                    AND TT1.cd_especialidade = S.cd_especialidadereferencia
                                                    AND TT1.cd_plano IS NULL
                                                    AND TT1.cd_servico IS NULL
                                                ORDER BY TT2.dt_inicio DESC,
                                                         TT2.cd_tabela_referencia DESC)), (SELECT TOP 1 ROUND(TT1.vl_servico * S.vl_us, 2)
                                                  FROM tabela_servicos TT1,
                                                       tabela_referencia TT2
                                                  WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                    AND TT1.cd_tabela = FI.cd_tabela
                                                    AND TT1.cd_especialidade IS NULL
                                                    AND TT1.cd_plano IS NULL
                                                    AND TT1.cd_servico IS NULL
                                                ORDER BY TT2.dt_inicio DESC,
                                                         TT2.cd_tabela_referencia DESC)))
                                          END
                                      END
                                    WHEN T41.refatualizacaotabeladentista = 2 THEN --'Tabela por data de referência x data de realização do procedimento

                                      CASE
                                        WHEN ISNULL(T41.localtabelapagamentodentista, 1) = 1 THEN --Tabela por dentista

                                          CASE
                                            WHEN ISNULL(T41.tipovalorcalculoprodutividadedentista, 1) = 1 THEN --Valor em R$
                                              ISNULL(ISNULL((SELECT TOP 1 TT1.vl_servico
                                                  FROM tabela_servicos TT1,
                                                       tabela_referencia TT2
                                                  WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                    AND TT1.cd_tabela = F.cd_tabela
                                                    AND TT1.cd_servico = S.cd_servico
                                                    AND TT1.cd_plano = DEP.cd_plano
                                                    AND TT1.cd_especialidade IS NULL
                                                    AND CONVERT(DATE, C.dt_servico) >= TT2.dt_inicio
                                                    AND CONVERT(DATE, C.dt_servico) <= ISNULL(TT2.dt_fim, GETDATE())), (SELECT TOP 1 TT1.vl_servico
                                                  FROM tabela_servicos TT1,
                                                       tabela_referencia TT2
                                                  WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                    AND TT1.cd_tabela = F.cd_tabela
                                                    AND TT1.cd_servico = S.cd_servico
                                                    AND TT1.cd_plano IS NULL
                                                    AND TT1.cd_especialidade IS NULL
                                                    AND CONVERT(DATE, C.dt_servico) >= TT2.dt_inicio
                                                    AND CONVERT(DATE, C.dt_servico) <= ISNULL(TT2.dt_fim, GETDATE()))), ISNULL(ISNULL((SELECT TOP 1 TT1.vl_servico
                                                  FROM tabela_servicos TT1,
                                                       tabela_referencia TT2
                                                  WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                    AND TT1.cd_tabela = F.cd_tabela
                                                    AND TT1.cd_especialidade = S.cd_especialidadereferencia
                                                    AND TT1.cd_plano = DEP.cd_plano
                                                    AND TT1.cd_servico IS NULL
                                                    AND CONVERT(DATE, C.dt_servico) >= TT2.dt_inicio
                                                    AND CONVERT(DATE, C.dt_servico) <= ISNULL(TT2.dt_fim, GETDATE())), (SELECT TOP 1 TT1.vl_servico
                                                  FROM tabela_servicos TT1,
                                                       tabela_referencia TT2
                                                  WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                    AND TT1.cd_tabela = F.cd_tabela
                                                    AND TT1.cd_especialidade = S.cd_especialidadereferencia
                                                    AND TT1.cd_plano IS NULL
                                                    AND TT1.cd_servico IS NULL
                                                    AND CONVERT(DATE, C.dt_servico) >= TT2.dt_inicio
                                                    AND CONVERT(DATE, C.dt_servico) <= ISNULL(TT2.dt_fim, GETDATE()))), (SELECT TOP 1 TT1.vl_servico
                                                  FROM tabela_servicos TT1,
                                                       tabela_referencia TT2
                                                  WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                    AND TT1.cd_tabela = F.cd_tabela
                                                    AND TT1.cd_especialidade IS NULL
                                                    AND TT1.cd_plano IS NULL
                                                    AND TT1.cd_servico IS NULL
                                                    AND CONVERT(DATE, C.dt_servico) >= TT2.dt_inicio
                                                    AND CONVERT(DATE, C.dt_servico) <= ISNULL(TT2.dt_fim, GETDATE()))))
                                            WHEN T41.tipovalorcalculoprodutividadedentista = 2 THEN --Valor em US, convertido para R$
                                              ISNULL(ISNULL((SELECT TOP 1 ROUND(TT1.vl_servico * S.vl_us, 2)
                                                  FROM tabela_servicos TT1,
                                                       tabela_referencia TT2
                                                  WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                    AND TT1.cd_tabela = F.cd_tabela
                                                    AND TT1.cd_servico = S.cd_servico
                                                    AND TT1.cd_plano = DEP.cd_plano
                                                    AND TT1.cd_especialidade IS NULL
                                                    AND CONVERT(DATE, C.dt_servico) >= TT2.dt_inicio
                                                    AND CONVERT(DATE, C.dt_servico) <= ISNULL(TT2.dt_fim, GETDATE())), (SELECT TOP 1 ROUND(TT1.vl_servico * S.vl_us, 2)
                                                  FROM tabela_servicos TT1,
                                                       tabela_referencia TT2
                                                  WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                    AND TT1.cd_tabela = F.cd_tabela
                                                    AND TT1.cd_servico = S.cd_servico
                                                    AND TT1.cd_plano IS NULL
                                                    AND TT1.cd_especialidade IS NULL
                                                    AND CONVERT(DATE, C.dt_servico) >= TT2.dt_inicio
                                                    AND CONVERT(DATE, C.dt_servico) <= ISNULL(TT2.dt_fim, GETDATE()))), ISNULL(ISNULL((SELECT TOP 1 ROUND(TT1.vl_servico * S.vl_us, 2)
                                                  FROM tabela_servicos TT1,
                                                       tabela_referencia TT2
                                                  WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                    AND TT1.cd_tabela = F.cd_tabela
                                                    AND TT1.cd_especialidade = S.cd_especialidadereferencia
                                                    AND TT1.cd_plano = DEP.cd_plano
                                                    AND TT1.cd_servico IS NULL
                                                    AND CONVERT(DATE, C.dt_servico) >= TT2.dt_inicio
                                                    AND CONVERT(DATE, C.dt_servico) <= ISNULL(TT2.dt_fim, GETDATE())), (SELECT TOP 1 ROUND(TT1.vl_servico * S.vl_us, 2)
                                                  FROM tabela_servicos TT1,
                                                       tabela_referencia TT2
                                                  WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                    AND TT1.cd_tabela = F.cd_tabela
                                                    AND TT1.cd_especialidade = S.cd_especialidadereferencia
                                                    AND TT1.cd_plano IS NULL
                                                    AND TT1.cd_servico IS NULL
                                                    AND CONVERT(DATE, C.dt_servico) >= TT2.dt_inicio
                                                    AND CONVERT(DATE, C.dt_servico) <= ISNULL(TT2.dt_fim, GETDATE()))), (SELECT TOP 1 ROUND(TT1.vl_servico * S.vl_us, 2)
                                                  FROM tabela_servicos TT1,
                                                       tabela_referencia TT2
                                                  WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                    AND TT1.cd_tabela = F.cd_tabela
                                                    AND TT1.cd_especialidade IS NULL
                                                    AND TT1.cd_plano IS NULL
                                                    AND TT1.cd_servico IS NULL
                                                    AND CONVERT(DATE, C.dt_servico) >= TT2.dt_inicio
                                                    AND CONVERT(DATE, C.dt_servico) <= ISNULL(TT2.dt_fim, GETDATE()))))
                                          END
                                        WHEN T41.localtabelapagamentodentista = 2 THEN --Tabela por clínica

                                          CASE
                                            WHEN ISNULL(T41.tipovalorcalculoprodutividadedentista, 1) = 1 THEN --Valor em R$
                                              ISNULL(ISNULL((SELECT TOP 1 TT1.vl_servico
                                                  FROM tabela_servicos TT1,
                                                       tabela_referencia TT2
                                                  WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                    AND TT1.cd_tabela = FI.cd_tabela
                                                    AND TT1.cd_servico = S.cd_servico
                                                    AND TT1.cd_plano = DEP.cd_plano
                                                    AND TT1.cd_especialidade IS NULL
                                                    AND CONVERT(DATE, C.dt_servico) >= TT2.dt_inicio
                                                    AND CONVERT(DATE, C.dt_servico) <= ISNULL(TT2.dt_fim, GETDATE())), (SELECT TOP 1 TT1.vl_servico
                                                  FROM tabela_servicos TT1,
                                                       tabela_referencia TT2
                                                  WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                    AND TT1.cd_tabela = FI.cd_tabela
                                                    AND TT1.cd_servico = S.cd_servico
                                                    AND TT1.cd_plano IS NULL
                                                    AND TT1.cd_especialidade IS NULL
                                                    AND CONVERT(DATE, C.dt_servico) >= TT2.dt_inicio
                                                    AND CONVERT(DATE, C.dt_servico) <= ISNULL(TT2.dt_fim, GETDATE()))), ISNULL(ISNULL((SELECT TOP 1 TT1.vl_servico
                                                  FROM tabela_servicos TT1,
                                                       tabela_referencia TT2
                                                  WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                    AND TT1.cd_tabela = FI.cd_tabela
                                                    AND TT1.cd_especialidade = S.cd_especialidadereferencia
                                                    AND TT1.cd_plano = DEP.cd_plano
                                                    AND TT1.cd_servico IS NULL
                                                    AND CONVERT(DATE, C.dt_servico) >= TT2.dt_inicio
                                                    AND CONVERT(DATE, C.dt_servico) <= ISNULL(TT2.dt_fim, GETDATE())), (SELECT TOP 1 TT1.vl_servico
                                                  FROM tabela_servicos TT1,
                                                       tabela_referencia TT2
                                                  WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                    AND TT1.cd_tabela = FI.cd_tabela
                                                    AND TT1.cd_especialidade = S.cd_especialidadereferencia
                                                    AND TT1.cd_plano IS NULL
                                                    AND TT1.cd_servico IS NULL
                                                    AND CONVERT(DATE, C.dt_servico) >= TT2.dt_inicio
                                                    AND CONVERT(DATE, C.dt_servico) <= ISNULL(TT2.dt_fim, GETDATE()))), (SELECT TOP 1 TT1.vl_servico
                                                  FROM tabela_servicos TT1,
                                                       tabela_referencia TT2
                                                  WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                    AND TT1.cd_tabela = FI.cd_tabela
                                                    AND TT1.cd_especialidade IS NULL
                                                    AND TT1.cd_plano IS NULL
                                                    AND TT1.cd_servico IS NULL
                                                    AND CONVERT(DATE, C.dt_servico) >= TT2.dt_inicio
                                                    AND CONVERT(DATE, C.dt_servico) <= ISNULL(TT2.dt_fim, GETDATE()))))
                                            WHEN T41.tipovalorcalculoprodutividadedentista = 2 THEN --Valor em US, convertido para R$
                                              ISNULL(ISNULL((SELECT TOP 1 ROUND(TT1.vl_servico * S.vl_us, 2)
                                                  FROM tabela_servicos TT1,
                                                       tabela_referencia TT2
                                                  WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                    AND TT1.cd_tabela = FI.cd_tabela
                                                    AND TT1.cd_servico = S.cd_servico
                                                    AND TT1.cd_plano = DEP.cd_plano
                                                    AND TT1.cd_especialidade IS NULL
                                                    AND CONVERT(DATE, C.dt_servico) >= TT2.dt_inicio
                                                    AND CONVERT(DATE, C.dt_servico) <= ISNULL(TT2.dt_fim, GETDATE())), (SELECT TOP 1 ROUND(TT1.vl_servico * S.vl_us, 2)
                                                  FROM tabela_servicos TT1,
                                                       tabela_referencia TT2
                                                  WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                    AND TT1.cd_tabela = FI.cd_tabela
                                                    AND TT1.cd_servico = S.cd_servico
                                                    AND TT1.cd_plano IS NULL
                                                    AND TT1.cd_especialidade IS NULL
                                                    AND CONVERT(DATE, C.dt_servico) >= TT2.dt_inicio
                                                    AND CONVERT(DATE, C.dt_servico) <= ISNULL(TT2.dt_fim, GETDATE()))), ISNULL(ISNULL((SELECT TOP 1 ROUND(TT1.vl_servico * S.vl_us, 2)
                                                  FROM tabela_servicos TT1,
                                                       tabela_referencia TT2
                                                  WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                    AND TT1.cd_tabela = FI.cd_tabela
                                                    AND TT1.cd_especialidade = S.cd_especialidadereferencia
                                                    AND TT1.cd_plano = DEP.cd_plano
                                                    AND TT1.cd_servico IS NULL
                                                    AND CONVERT(DATE, C.dt_servico) >= TT2.dt_inicio
                                                    AND CONVERT(DATE, C.dt_servico) <= ISNULL(TT2.dt_fim, GETDATE())), (SELECT TOP 1 ROUND(TT1.vl_servico * S.vl_us, 2)
                                                  FROM tabela_servicos TT1,
                                                       tabela_referencia TT2
                                                  WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                    AND TT1.cd_tabela = FI.cd_tabela
                                                    AND TT1.cd_especialidade = S.cd_especialidadereferencia
                                                    AND TT1.cd_plano IS NULL
                                                    AND TT1.cd_servico IS NULL
                                                    AND CONVERT(DATE, C.dt_servico) >= TT2.dt_inicio
                                                    AND CONVERT(DATE, C.dt_servico) <= ISNULL(TT2.dt_fim, GETDATE()))), (SELECT TOP 1 ROUND(TT1.vl_servico * S.vl_us, 2)
                                                  FROM tabela_servicos TT1,
                                                       tabela_referencia TT2
                                                  WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                    AND TT1.cd_tabela = FI.cd_tabela
                                                    AND TT1.cd_especialidade IS NULL
                                                    AND TT1.cd_plano IS NULL
                                                    AND TT1.cd_servico IS NULL
                                                    AND CONVERT(DATE, C.dt_servico) >= TT2.dt_inicio
                                                    AND CONVERT(DATE, C.dt_servico) <= ISNULL(TT2.dt_fim, GETDATE()))))
                                          END
                                      END
                                    ELSE 0
                                  END, 0)
                                ELSE ISNULL(CASE
                                    WHEN ISNULL(T41.refatualizacaotabeladentista, 1) = 1 THEN --Última tabela

                                      CASE
                                        WHEN ISNULL(T41.tipovalorcalculoprodutividadedentista, 1) = 1 THEN --Valor em R$
                                          ISNULL((SELECT TOP 1 TT1.vl_servico
                                              FROM tabela_servicos TT1,
                                                   tabela_referencia TT2
                                              WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                AND TT1.cd_tabela = T13.cd_tabelaparticular
                                                AND TT1.cd_servico = S.cd_servico
                                                AND TT1.cd_especialidade IS NULL
                                            ORDER BY TT2.dt_inicio DESC,
                                                     TT2.cd_tabela_referencia DESC), ISNULL((SELECT TOP 1 TT1.vl_servico
                                              FROM tabela_servicos TT1,
                                                   tabela_referencia TT2
                                              WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                AND TT1.cd_tabela = T13.cd_tabelaparticular
                                                AND TT1.cd_especialidade = S.cd_especialidadereferencia
                                                AND TT1.cd_servico IS NULL
                                            ORDER BY TT2.dt_inicio DESC,
                                                     TT2.cd_tabela_referencia DESC), (SELECT TOP 1 TT1.vl_servico
                                              FROM tabela_servicos TT1,
                                                   tabela_referencia TT2
                                              WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                AND TT1.cd_tabela = T13.cd_tabelaparticular
                                                AND TT1.cd_especialidade IS NULL
                                                AND TT1.cd_servico IS NULL
                                            ORDER BY TT2.dt_inicio DESC,
                                                     TT2.cd_tabela_referencia DESC)))
                                        WHEN T41.tipovalorcalculoprodutividadedentista = 2 THEN --Valor em US, convertido para R$
                                          ISNULL((SELECT TOP 1 ROUND(TT1.vl_servico * S.vl_us, 2)
                                              FROM tabela_servicos TT1,
                                                   tabela_referencia TT2
                                              WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                AND TT1.cd_tabela = T13.cd_tabelaparticular
                                                AND TT1.cd_servico = S.cd_servico
                                                AND TT1.cd_especialidade IS NULL
                                            ORDER BY TT2.dt_inicio DESC,
                                                     TT2.cd_tabela_referencia DESC), ISNULL((SELECT TOP 1 ROUND(TT1.vl_servico * S.vl_us, 2)
                                              FROM tabela_servicos TT1,
                                                   tabela_referencia TT2
                                              WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                AND TT1.cd_tabela = T13.cd_tabelaparticular
                                                AND TT1.cd_especialidade = S.cd_especialidadereferencia
                                                AND TT1.cd_servico IS NULL
                                            ORDER BY TT2.dt_inicio DESC,
                                                     TT2.cd_tabela_referencia DESC), (SELECT TOP 1 ROUND(TT1.vl_servico * S.vl_us, 2)
                                              FROM tabela_servicos TT1,
                                                   tabela_referencia TT2
                                              WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                AND TT1.cd_tabela = T13.cd_tabelaparticular
                                                AND TT1.cd_especialidade IS NULL
                                                AND TT1.cd_servico IS NULL
                                            ORDER BY TT2.dt_inicio DESC,
                                                     TT2.cd_tabela_referencia DESC)))
                                      END
                                    WHEN T41.refatualizacaotabeladentista = 2 THEN --Tabela por data de referência x data de realização do procedimento

                                      CASE
                                        WHEN ISNULL(T41.tipovalorcalculoprodutividadedentista, 1) = 1 THEN --Valor em R$
                                          ISNULL((SELECT TOP 1 TT1.vl_servico
                                              FROM tabela_servicos TT1,
                                                   tabela_referencia TT2
                                              WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                AND TT1.cd_tabela = T13.cd_tabelaparticular
                                                AND TT1.cd_servico = S.cd_servico
                                                AND TT1.cd_especialidade IS NULL
                                                AND CONVERT(DATE, C.dt_servico) >= TT2.dt_inicio
                                                AND CONVERT(DATE, C.dt_servico) <= ISNULL(TT2.dt_fim, GETDATE())), ISNULL((SELECT TOP 1 TT1.vl_servico
                                              FROM tabela_servicos TT1,
                                                   tabela_referencia TT2
                                              WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                AND TT1.cd_tabela = T13.cd_tabelaparticular
                                                AND TT1.cd_especialidade = S.cd_especialidadereferencia
                                                AND TT1.cd_servico IS NULL
                                                AND CONVERT(DATE, C.dt_servico) >= TT2.dt_inicio
                                                AND CONVERT(DATE, C.dt_servico) <= ISNULL(TT2.dt_fim, GETDATE())), (SELECT TOP 1 TT1.vl_servico
                                              FROM tabela_servicos TT1,
                                                   tabela_referencia TT2
                                              WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                AND TT1.cd_tabela = T13.cd_tabelaparticular
                                                AND TT1.cd_especialidade IS NULL
                                                AND TT1.cd_servico IS NULL
                                                AND CONVERT(DATE, C.dt_servico) >= TT2.dt_inicio
                                                AND CONVERT(DATE, C.dt_servico) <= ISNULL(TT2.dt_fim, GETDATE()))))
                                        WHEN T41.tipovalorcalculoprodutividadedentista = 2 THEN --Valor em US, convertido para R$
                                          ISNULL((SELECT TOP 1 ROUND(TT1.vl_servico * S.vl_us, 2)
                                              FROM tabela_servicos TT1,
                                                   tabela_referencia TT2
                                              WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                AND TT1.cd_tabela = T13.cd_tabelaparticular
                                                AND TT1.cd_servico = S.cd_servico
                                                AND TT1.cd_especialidade IS NULL
                                                AND CONVERT(DATE, C.dt_servico) >= TT2.dt_inicio
                                                AND CONVERT(DATE, C.dt_servico) <= ISNULL(TT2.dt_fim, GETDATE())), ISNULL((SELECT TOP 1 ROUND(TT1.vl_servico * S.vl_us, 2)
                                              FROM tabela_servicos TT1,
                                                   tabela_referencia TT2
                                              WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                AND TT1.cd_tabela = T13.cd_tabelaparticular
                                                AND TT1.cd_especialidade = S.cd_especialidadereferencia
                                                AND TT1.cd_servico IS NULL
                                                AND CONVERT(DATE, C.dt_servico) >= TT2.dt_inicio
                                                AND CONVERT(DATE, C.dt_servico) <= ISNULL(TT2.dt_fim, GETDATE())), (SELECT TOP 1 ROUND(TT1.vl_servico * S.vl_us, 2)
                                              FROM tabela_servicos TT1,
                                                   tabela_referencia TT2
                                              WHERE TT1.cd_tabela_referencia = TT2.cd_tabela_referencia
                                                AND TT1.cd_tabela = T13.cd_tabelaparticular
                                                AND TT1.cd_especialidade IS NULL
                                                AND TT1.cd_servico IS NULL
                                                AND CONVERT(DATE, C.dt_servico) >= TT2.dt_inicio
                                                AND CONVERT(DATE, C.dt_servico) <= ISNULL(TT2.dt_fim, GETDATE()))))
                                      END
                                    ELSE 0
                                  END, 0)
                              END
                          END
                      END
                  END AS VL_CUSTO,
                  --*******************************************************************

                  C.cd_sequencial_agenda,
                  ISNULL(FI.ufid, 0) AS CDUFFIL,
                  ISNULL(UFF.ufsigla, 'XX') AS UFFIL,
                  ISNULL(FI.cidid, 0) AS CDCIDFIL,
                  ISNULL(MF.nm_municipio, 'Não Informado') AS CIDFIL,
                  ISNULL(FI.baiid, 0) AS CDBAIFIL,
                  ISNULL(BF.baidescricao, 'Não Informado') AS BAIFIL, -- Filial 
                  ISNULL(ASS.ufid, 0) AS CDUFADD,
                  ISNULL(UFA.ufsigla, 'XX') AS UFASS,
                  ISNULL(ASS.cidid, 0) AS CDCIDASS,
                  ISNULL(MA.nm_municipio, 'Não Informado') AS CIDASS,
                  ISNULL(ASS.baiid, 0) AS CDBAIASS,
                  ISNULL(BA.baidescricao, 'Não Informado') AS BAIASS, -- Associados 
                  ISNULL(S.cd_especialidadereferencia, 0) AS CDESP,
                  ISNULL(ESP.nm_especialidade, 'Não Especificado') AS ESPECIALIDADE,
                  YEAR(C.dt_servico),
                  MONTH(C.dt_servico),
                  CASE
                    WHEN C.nr_numero_lote IS NULL THEN 2
                    ELSE 1
                  END,
                  CASE
                    WHEN C.nr_numero_lote IS NULL THEN 'A Faturar'
                    ELSE 'Faturado'
                  END,
                  CASE
                    WHEN C.cd_sequencial_exame IS NULL THEN C.cd_sequencial
                    ELSE C.cd_sequencial_exame
                  END,
                  CASE
                    WHEN C.cd_sequencial_exame IS NULL THEN F.nm_empregado
                    ELSE (SELECT F1.nm_empregado
                          FROM consultas AS C1,
                               funcionario AS F1
                          WHERE C1.cd_sequencial = C.cd_sequencial_exame
                            AND C1.cd_funcionario = F1.cd_funcionario)
                  END,
                  (SELECT COUNT(0)
                      FROM consultas AS C1,
                           servico AS S1
                      WHERE C1.cd_sequencial_exame = C.cd_sequencial
                        AND C1.status IN (2, 3, 5, 6, 7)
                        AND C1.cd_servico = S1.cd_servico
                        AND S1.fl_contagembaixaagenda = 1
                        AND S1.fl_apresentaprodutividade = 1) AS QTDE_PROC_EXAME,
                  CASE
                    WHEN OS.cd_orcamento IS NULL THEN 0
                    ELSE 1
                  END,
                  dbo.fs_idade(DEP.dt_nascimento, C.dt_servico),
                  T13.nm_plano

  --  FROM consultas AS C,
  --       servico AS S,
  --       filial AS FI,
  --       funcionario AS F,
  --       dependentes AS DEP,
  --       associados AS ASS,
  --       empresa AS E,
  --       tipo_pagamento T,
  --       tabela_servicos TC, -- Custo do Cliente
  --       especialidade AS ESP,
  --       orcamento_servico AS OS,
  --       uf AS UFF,
  --       municipio AS MF,
  --       bairro AS BF,
  --       uf AS UFA,
  --       municipio AS MA,
  --       bairro AS BA,
  --       tb_consultasglosados T52,
  --       orcamento_servico T15,
  --       configuracao T41,
  --       planos T13
  --  WHERE C.cd_servico = S.cd_servico
  --    AND C.cd_filial = FI.cd_filial
  --    AND C.cd_funcionario = F.cd_funcionario
  --    AND C.cd_sequencial_dep = DEP.cd_sequencial
  --    AND DEP.cd_associado = ASS.cd_associado
  --    AND ASS.cd_empresa = E.cd_empresa
  --    AND C.status IN (3, 6, 7) -- Remover os inconsistentes 
  --    AND C.cd_sequencial *= OS.cd_sequencial_pp
  --    AND C.dt_servico IS NOT NULL
  --    AND E.cd_empresa = @c_emp -- JÁ ESTAVA COMENTADO
  --    AND E.cd_tipo_pagamento = T.cd_tipo_pagamento
  --    AND T.cd_tabela *= TC.cd_tabela
  --    AND C.cd_servico *= TC.cd_servico
  --    AND S.cd_especialidadereferencia = ESP.cd_especialidade
  --    AND C.cd_sequencial *= T52.cd_sequencial
  --    AND C.cd_sequencial *= T15.cd_sequencial_pp
  --    AND DEP.cd_plano = T13.cd_plano
  --
  --    AND ASS.ufid *= UFA.ufid
  --    AND ASS.cidid *= MA.cd_municipio
  --    AND ASS.baiid *= BA.baiid
  --
  --    AND FI.ufid *= UFF.ufid
  --    AND FI.cidid *= MF.cd_municipio
  --    AND FI.baiid *= BF.baiid
  --
  --    AND S.fl_contagembaixaagenda = 1
  --    AND S.fl_apresentaprodutividade = 1
  --    AND C.dt_servico >= '01/01/2010'

  FROM consultas AS C
    INNER JOIN servico AS S ON C.cd_servico = S.cd_servico
    INNER JOIN filial AS FI ON C.cd_filial = FI.cd_filial
    INNER JOIN funcionario AS F ON C.cd_funcionario = F.cd_funcionario
    INNER JOIN dependentes AS DEP ON C.cd_sequencial_dep = DEP.cd_sequencial
    INNER JOIN associados AS ASS ON DEP.cd_associado = ASS.cd_associado
    INNER JOIN empresa AS E ON ASS.cd_empresa = E.cd_empresa
    LEFT OUTER JOIN orcamento_servico AS OS ON C.cd_sequencial = OS.cd_sequencial_pp
    INNER JOIN tipo_pagamento AS T ON E.cd_tipo_pagamento = T.cd_tipo_pagamento
    LEFT OUTER JOIN tabela_servicos AS TC ON T.cd_tabela = TC.cd_tabela
        AND C.cd_servico = TC.cd_servico
    INNER JOIN especialidade AS ESP ON S.cd_especialidadereferencia = ESP.cd_especialidade
    LEFT OUTER JOIN tb_consultasglosados AS T52 ON C.cd_sequencial = T52.cd_sequencial
    LEFT OUTER JOIN orcamento_servico AS T15 ON C.cd_sequencial = T15.cd_sequencial_pp
    INNER JOIN planos AS T13 ON DEP.cd_plano = T13.cd_plano
    LEFT OUTER JOIN uf AS UFA ON ASS.ufid = UFA.ufid
    LEFT OUTER JOIN municipio AS MA ON ASS.cidid = MA.cd_municipio
    LEFT OUTER JOIN bairro AS BA ON ASS.baiid = BA.baiid
    LEFT OUTER JOIN uf AS UFF ON FI.ufid = UFF.ufid
    LEFT OUTER JOIN municipio AS MF ON FI.cidid = MF.cd_municipio
    LEFT OUTER JOIN bairro AS BF ON FI.baiid = BF.baiid
    CROSS JOIN configuracao AS T41
  WHERE (C.status IN (3, 6, 7))
    AND (C.dt_servico IS NOT NULL)
    AND (S.fl_contagembaixaagenda = 1)
    AND (S.fl_apresentaprodutividade = 1)
    AND (C.dt_servico >= '01/01/2010')

END;
