/****** Object:  View [dbo].[VW_UsuariosAtivos]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE View [dbo].[VW_UsuariosAtivos]
as
	select a1.cd_empresa, COUNT(distinct d1.cd_Associado) as qt_tit, sum(case when d2.cd_grau_parentesco > 1 and d2.cd_grau_parentesco < 10  then 1 else 0 end) as qt_dep, sum(case when d2.cd_grau_parentesco = 10 then 1 else 0 end) as qt_agregado, SUM(d2.vl_plano) as vl_plano,
			sum(case when d2.CD_GRAU_PARENTESCO = 1 and d2.nr_cpf_dep IS not null and d2.nm_mae_dep IS not null then 1 
				when d2.CD_GRAU_PARENTESCO > 1 and DATEDIFF(year,d2.dt_nascimento,getdate())>=18 and d2.nr_cpf_dep IS not null and d2.nm_mae_dep IS not null then 1  
				when d2.CD_GRAU_PARENTESCO > 1 and DATEDIFF(year,d2.dt_nascimento,getdate())<18 and d2.nm_mae_dep IS not null then 1  
				else 0 
			End) as qt_cadastro_ok_ans
			--VALOR PARTICIPACAO EMPRESA TITULAR			
			,SUM(case when isnull(p1.moedaParticipacaoEmpresaTitular,1) = 1 
			    then
			 d2.vl_plano - (d2.vl_plano - isnull(p1.valorParticipacaoEmpresaTitular,0))
			    else
			  d2.vl_plano * isnull(p1.valorParticipacaoEmpresaTitular, 0)/100
			    end ) as valorParticipacaoEmpresaTitular				
			--VALOR PARTICIPACAO EMPRESADE PENDENTE
			,SUM(case when isnull(p1.moedaParticipacaoEmpresaDependente,1) = 1 
			    then
			    d2.vl_plano - (d2.vl_plano - isnull(p1.valorParticipacaoEmpresaDependente, 0))
			    else
			 d2.vl_plano * isnull(p1.valorParticipacaoEmpresaDependente, 0)/100
			    end ) as valorParticipacaoEmpresaDependente		
			--VALOR PARTICIPACAO EMPRESA AGREGADO			    
			,SUM(case when isnull(p1.moedaParticipacaoEmpresaAgregado,1) = 1 
			    then
			     d2.vl_plano - (d2.vl_plano - isnull(p1.valorParticipacaoEmpresaAgregado,0))
			    else
			   d2.vl_plano * isnull(p1.valorParticipacaoEmpresaAgregado,0)/100
			    end ) as valorParticipacaoEmpresaAgregado		    	

	  from associados as a1 , dependentes as d1 , historico as h1, situacao_historico as s1, 
		   dependentes as d2 , historico as h2 , situacao_historico as s2, 
		   preco_plano as p1
	 where a1.cd_associado = d1.cd_Associado and d1.cd_grau_parentesco = 1 and 
		   d1.cd_sequencial_historico = h1.cd_sequencial and 
		   h1.cd_situacao = s1.cd_situacao_historico and 
		   s1.fl_incluir_ans=1 and 
	       
		   a1.cd_associado = d2.cd_Associado and -- Dependentes 
		   d2.cd_sequencial_historico = h2.cd_sequencial and 
		   h2.cd_situacao = s2.cd_situacao_historico and 
		   
		   p1.cd_empresa = a1.cd_empresa and 
		   p1.cd_plano = d1.cd_plano and
		   p1.dt_fim_comercializacao is null and
		   
		   s2.fl_incluir_ans=1        
	group by a1.cd_empresa       


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
         Begin Table = "a1"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 126
               Right = 277
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d1"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 246
               Right = 273
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "h1"
            Begin Extent = 
               Top = 246
               Left = 38
               Bottom = 366
               Right = 294
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s1"
            Begin Extent = 
               Top = 366
               Left = 38
               Bottom = 486
               Right = 279
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d2"
            Begin Extent = 
               Top = 486
               Left = 38
               Bottom = 606
               Right = 273
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "h2"
            Begin Extent = 
               Top = 606
               Left = 38
               Bottom = 726
               Right = 294
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s2"
            Begin Extent = 
               Top = 726
               Left = 38
               Bottom = 846
               Right = 279
            End
            DisplayFlags = 280
            TopColumn = 0
         ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VW_UsuariosAtivos'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'End
         Begin Table = "p1"
            Begin Extent = 
               Top = 6
               Left = 315
               Bottom = 126
               Right = 610
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "gp"
            Begin Extent = 
               Top = 6
               Left = 648
               Bottom = 126
               Right = 855
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VW_UsuariosAtivos'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VW_UsuariosAtivos'
