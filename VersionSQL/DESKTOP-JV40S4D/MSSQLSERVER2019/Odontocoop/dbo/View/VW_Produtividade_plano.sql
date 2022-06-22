/****** Object:  View [dbo].[VW_Produtividade_plano]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[VW_Produtividade_plano]
AS
SELECT     pd.cd_pgto_dentista_lanc, SUM(CASE WHEN e.TP_EMPRESA IN (2, 6) THEN vl_pago_produtividade + isnull(vl_acerto_pgto_produtividade, 0) ELSE 0 END) AS Empresarial, 
                      SUM(CASE WHEN e.TP_EMPRESA NOT IN (2, 6, 8, 9) THEN vl_pago_produtividade + isnull(vl_acerto_pgto_produtividade, 0) ELSE 0 END) AS Individual, SUM(CASE WHEN e.TP_EMPRESA IN (8) 
                      THEN vl_pago_produtividade + isnull(vl_acerto_pgto_produtividade, 0) ELSE 0 END) AS Coletivo
FROM         dbo.Consultas AS c INNER JOIN
                      dbo.pagamento_dentista AS pd ON c.nr_numero_lote = pd.cd_sequencial INNER JOIN
                      dbo.DEPENDENTES AS d ON c.cd_sequencial_dep = d.CD_SEQUENCIAL INNER JOIN
                      dbo.ASSOCIADOS AS a ON d.CD_ASSOCIADO = a.cd_associado INNER JOIN
                      dbo.EMPRESA AS e ON a.cd_empresa = e.CD_EMPRESA
GROUP BY pd.cd_pgto_dentista_lanc

EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "c"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 126
               Right = 288
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "pd"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 246
               Right = 275
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d"
            Begin Extent = 
               Top = 246
               Left = 38
               Bottom = 366
               Right = 273
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "a"
            Begin Extent = 
               Top = 366
               Left = 38
               Bottom = 486
               Right = 277
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "e"
            Begin Extent = 
               Top = 486
               Left = 38
               Bottom = 606
               Right = 316
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VW_Produtividade_plano'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VW_Produtividade_plano'
