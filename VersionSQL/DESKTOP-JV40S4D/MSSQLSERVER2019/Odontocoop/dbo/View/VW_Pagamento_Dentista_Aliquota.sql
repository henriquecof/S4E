/****** Object:  View [dbo].[VW_Pagamento_Dentista_Aliquota]    Committed by VersionSQL https://www.versionsql.com ******/

Create View [dbo].[VW_Pagamento_Dentista_Aliquota]
as
SELECT     pda.cd_pgto_dentista_lanc, SUM(CASE WHEN a.cd_grupo_aliquota = 6 THEN ISNULL(pda.valor_aliquota, 0) ELSE 0 END) AS PIS, 
                      SUM(CASE WHEN a.cd_grupo_aliquota = 1 THEN ISNULL(pda.valor_aliquota, 0) ELSE 0 END) AS COFINS,
                      SUM(CASE WHEN a.cd_grupo_aliquota = 2 THEN ISNULL(pda.valor_aliquota, 0) ELSE 0 END) AS CSLL,
                      SUM(CASE WHEN a.cd_grupo_aliquota = 3 THEN ISNULL(pda.valor_aliquota, 0) ELSE 0 END) AS INSS,
                      SUM(CASE WHEN a.cd_grupo_aliquota = 5 THEN ISNULL (pda.valor_aliquota, 0) ELSE 0 END) AS ISS,
                      SUM(CASE WHEN a.cd_grupo_aliquota = 4 THEN ISNULL(pda.valor_aliquota, 0) ELSE 0 END) AS IR
FROM         dbo.Pagamento_Dentista_Aliquotas AS pda INNER JOIN
                      dbo.Aliquota AS a ON pda.cd_aliquota = a.cd_aliquota
WHERE     (pda.dt_exclusao IS NULL) AND (pda.id_retido = 1)
GROUP BY pda.cd_pgto_dentista_lanc
