/****** Object:  View [dbo].[VW_ANS_RPS]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[VW_ANS_RPS]
AS
SELECT     a1.cd_filial, a1.acao, a1.ufid, a1.Prestador, a1.NR_CGC, a1.Cnes, a1.Cidid, a1.tp_contratacao, a1.nr_ANSinter, a1.cd_dispon_serv, a1.data_contrato, a1.Data_Inicio_Vinculo, 
                      a1.cd_ind_urgencia
FROM         dbo.ANS_RPS_Itens AS a1 INNER JOIN
                          (SELECT     cd_filial, MAX(cd_sequencial) AS max_seq
                            FROM          dbo.ANS_RPS_Itens
                            WHERE      (dt_excluido IS NULL)
                            GROUP BY cd_filial) AS a2 ON a1.cd_filial = a2.cd_filial AND a1.cd_sequencial = a2.max_seq
