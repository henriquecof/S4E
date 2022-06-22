/****** Object:  Procedure [dbo].[PS_MostraLigacaoCobranca]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[PS_MostraLigacaoCobranca](@Associado int, @TipoAssociado int, @Quantidade int)
As
 Begin 
   if (@Quantidade=0)
     Begin
		Select 1,T10.cd_parcela, data_gerado as dt_comentario, t10.sequencial,t10.Faixa_dias_atrasado as faixa_dias_atraso  , '' as ds_comentario, 
				   convert(varchar(10),t10.data_gerado,103) + ' ' + convert(varchar(10),t10.data_gerado,108) as data,           
				   t10.nome_usuario as cd_usuario,
				   Case t10.status 
					 When 1 Then 'Reagendamento'
					 When 2 Then 'Cadastro geral incompleto'
					 When 3 Then 'Carta'
					 When 4 Then 'Enviar SPC'
					 When 5 Then 'Enviar p/ Cancelamento'
                     When 6 Then 'Ligação Improdutiva'
                     When 7 Then 'Pagamento Efetuado'
					 Else 'Outros'
				  End as status, 
				  convert(varchar(10),T10.Data_Vencimento,103) as data_vencimento,T10.Dias_Atrasado as dias_atraso,
				  case 
					  when (T10.cd_parcela >= 1      and T10.cd_parcela<=31999) then 'Plano'
					  when (T10.cd_parcela >= 32000  and T10.cd_parcela<=63999) then 'Serviço Opcional'
					  when (T10.cd_parcela >= 64000  and T10.cd_parcela<=95999) then 'Orçamento'
					  when (T10.cd_parcela >= 96000  and T10.cd_parcela<=127999) then 'Acordo'
					  when (T10.cd_parcela >= 128000 and T10.cd_parcela<=159999) then 'Plano Ortodôtico'
					  when (T10.cd_parcela >= 160000 and T10.cd_parcela<=191999) then 'Parcelas Geradas'
				  end as tipo_plano, t1.cd_funcionario, t1.nm_empregado
			From TB_ListaAtrasadosUsuario t10 , Funcionario t1		 
			Where  t10.nome_usuario    = t1.cd_funcionario And
                   t10.Status          > 0      And
  				   t10.tipo_pessoa     = @TipoAssociado And
				   t10.codigo          = @Associado And
				   t10.sequencial not in (select sequencial from Comentario t100 where t100.sequencial = t10.sequencial)              
			Union all
			Select 1, T20.cd_parcela,t1.dt_comentario, t10.sequencial, t1.faixa_dias_atraso, t1.ds_comentario, convert(varchar(10),t1.dt_comentario,103) + ' ' + convert(varchar(10),t1.dt_comentario,108) as data,
				   t1.cd_usuario,
				   Case t1.cd_status 
					 When 1 Then 'Reagendamento'
					 When 2 Then 'Cadastro geral incompleto'
					 When 3 Then 'Carta'
					 When 4 Then 'Enviar SPC'
					 When 5 Then 'Enviar p/ Cancelamento'
                     When 6 Then 'Ligação Improdutiva'
                     When 7 Then 'Pagamento Efetuado'
					 Else 'Outros'
				  End as status, 
				   convert(varchar(10),T20.Data_Vencimento,103) as data_vencimento,T20.Dias_Atraso,
				  case 
					  when (T20.cd_parcela >= 1      and T20.cd_parcela<=31999) then 'Plano'
					  when (T20.cd_parcela >= 32000  and T20.cd_parcela<=63999) then 'Serviço Opcional'
					  when (T20.cd_parcela >= 64000  and T20.cd_parcela<=95999) then 'Orçamento'
					  when (T20.cd_parcela >= 96000  and T20.cd_parcela<=127999) then 'Acordo'
					  when (T20.cd_parcela >= 128000 and T20.cd_parcela<=159999) then 'Plano Ortodôtico'
					  when (T20.cd_parcela >= 160000 and T20.cd_parcela<=191999) then 'Parcelas Geradas'
				  end as tipo_plano, t30.cd_funcionario, t30.nm_empregado
			From comentario t1, TB_ListaAtrasadosUsuario t10, 
				 TB_ParcelasAtrasadasUsuario T20, Funcionario t30
			Where  t10.nome_usuario    = t30.cd_funcionario And
                   t1.CD_Status       > 0      And
				   t10.Status         > 0      And
  				   t1.CD_Tp_Associado   = @TipoAssociado And
				   t1.CD_Associado      = @Associado And
				   isnull(t1.CD_Usuario,'') <> '' And
				   t1.sequencial        = t10.sequencial  And		              
				   t10.sequencial       = t20.sequencial
            Union all
			Select 2,0 as cd_parcela,t1.data as dt_comentario, t1.sequencial,
				  0 as faixa_dias_atraso , t1.comentario as ds_comentario,
				  convert(varchar(10),t1.data,103) + ' ' + convert(varchar(10),t1.data,108) as data,
				  convert(varchar,t1.cd_funcionario) as cd_usuario,
				 case t1.status
					when 1 then 'Ligação Recebida'
					when 2 then 'Providência Tomada'
                    When 3 Then 'Ligação Improdutiva'
                    When 4 Then 'Pagamento Efetuado'
					when 5 then 'Outros'
				  end  as status,
                  convert(varchar(10),T1.data,103) as data_vencimento,0 as Dias_Atraso,
				  '' as tipo_plano, t10.cd_funcionario, t10.nm_empregado  
			From TB_ListaAtrasadosUsuarioReceptivo t1, funcionario t10
			where t1.cd_funcionario = t10.cd_funcionario And
				  t1.tipo_pessoa     = @TipoAssociado And
				  t1.codigo          = @Associado 
			Order by 1,3,2
     End
   Else
     Begin
          Select top 2 T10.cd_parcela, data_gerado as dt_comentario, t10.sequencial,t10.Faixa_dias_atrasado as faixa_dias_atraso  , '' as ds_comentario, 
				   convert(varchar(10),t10.data_gerado,103) + ' ' + convert(varchar(10),t10.data_gerado,108) as data,           
				   t10.nome_usuario as cd_usuario,
				   Case t10.status 
					 When 1 Then 'Reagendamento'
					 When 2 Then 'Cadastro geral incompleto'
					 When 3 Then 'Carta'
					 When 4 Then 'Enviar SPC'
					 When 5 Then 'Enviar p/ Cancelamento'
                     When 6 Then 'Ligação Improdutiva'
                     When 7 Then 'Pagamento Efetuado'
					 Else 'Outros'
				  End as status, 
				  convert(varchar(10),T10.Data_Vencimento,103) as data_vencimento,T10.Dias_Atrasado as dias_atraso,
				  case 
					  when (T10.cd_parcela >= 1      and T10.cd_parcela<=31999) then 'Plano'
					  when (T10.cd_parcela >= 32000  and T10.cd_parcela<=63999) then 'Serviço Opcional'
					  when (T10.cd_parcela >= 64000  and T10.cd_parcela<=95999) then 'Orçamento'
					  when (T10.cd_parcela >= 96000  and T10.cd_parcela<=127999) then 'Acordo'
					  when (T10.cd_parcela >= 128000 and T10.cd_parcela<=159999) then 'Plano Ortodôtico'
					  when (T10.cd_parcela >= 160000 and T10.cd_parcela<=191999) then 'Parcelas Geradas'
				  end as tipo_plano
			From TB_ListaAtrasadosUsuario t10 		 
			Where  t10.Status          > 0      And
  				   t10.tipo_pessoa     = @TipoAssociado And
				   t10.codigo          = @Associado And
				   t10.sequencial not in (select sequencial from Comentario t100 where t100.sequencial = t10.sequencial)              
			Union all
			Select top 2 T20.cd_parcela,t1.dt_comentario, t10.sequencial, t1.faixa_dias_atraso, t1.ds_comentario, convert(varchar(10),t1.dt_comentario,103) + ' ' + convert(varchar(10),t1.dt_comentario,108) as data,
				   t1.cd_usuario,
				   Case t1.cd_status 
					 When 1 Then 'Reagendamento'
					 When 2 Then 'Cadastro geral incompleto'
					 When 3 Then 'Carta'
					 When 4 Then 'Enviar SPC'
					 When 5 Then 'Enviar p/ Cancelamento'
                     When 6 Then 'Ligação Improdutiva'
                     When 7 Then 'Pagamento Efetuado'
					 Else 'Outros'
				  End as status, 
				   convert(varchar(10),T20.Data_Vencimento,103) as data_vencimento,T20.Dias_Atraso,
				  case 
					  when (T20.cd_parcela >= 1      and T20.cd_parcela<=31999) then 'Plano'
					  when (T20.cd_parcela >= 32000  and T20.cd_parcela<=63999) then 'Serviço Opcional'
					  when (T20.cd_parcela >= 64000  and T20.cd_parcela<=95999) then 'Orçamento'
					  when (T20.cd_parcela >= 96000  and T20.cd_parcela<=127999) then 'Acordo'
					  when (T20.cd_parcela >= 128000 and T20.cd_parcela<=159999) then 'Plano Ortodôtico'
					  when (T20.cd_parcela >= 160000 and T20.cd_parcela<=191999) then 'Parcelas Geradas'
				  end as tipo_plano
			From comentario t1, TB_ListaAtrasadosUsuario t10, 
				 TB_ParcelasAtrasadasUsuario T20
			Where  t1.CD_Status       > 0      And
				   t10.Status         > 0      And
  				   t1.CD_Tp_Associado   = @TipoAssociado And
				   t1.CD_Associado      = @Associado And
				   isnull(t1.CD_Usuario,'') <> '' And
				   t1.sequencial        = t10.sequencial  And		              
				   t10.sequencial       = t20.sequencial
			Order by 2,1
    End       
End 
