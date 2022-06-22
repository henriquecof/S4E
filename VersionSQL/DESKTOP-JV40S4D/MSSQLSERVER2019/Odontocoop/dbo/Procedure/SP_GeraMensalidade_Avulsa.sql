/****** Object:  Procedure [dbo].[SP_GeraMensalidade_Avulsa]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE Procedure [dbo].[SP_GeraMensalidade_Avulsa] (@Ass int, @cd_seq int, @dt_venc datetime, @tp_pag int, @tipo_parcela int, @vl_parcela money, @cd_plano int = -1, @retorno varchar(1000) = '' output, @chaId int = -1, @cd_funcionario_cadastro bigint = -1)
As
Begin

   -- Se valor e plano for -1 buscar no cadastro.
   -- Se adesao gerada e aberta... Data superior a assinatura do contrato nao gerar novamente
   --Declare @retorno varchar(1000)
   Declare @cd_parc int
   
   Set @dt_venc = CONVERT(varchar(10),@dt_venc,101)
   
   print '1'     
   select @cd_plano = case when @cd_plano=-1 then d.cd_plano else @cd_plano end
     from dependentes as d 
    where d.cd_sequencial = @cd_seq 

	--- Existe parcela gerada hj... Se sim usa a mesma
	set @cd_parc = null 
	
	select @cd_parc = max(CD_PARCELA)
	  from mensalidades
	 where cd_associado_empresa = @ass and 
	       cd_tipo_parcela = @tipo_parcela and 
   		   convert(varchar(10),DT_VENCIMENTO,101) = @dt_venc and 
		   TP_ASSOCIADO_EMPRESA = 1 and 
		   CONVERT(varchar(10),dt_gerado,101) = convert(varchar(10),getdate(),101) and 
		   CD_TIPO_RECEBIMENTO=0
	
	if @cd_parc is null 
   	Begin -- 2.2	
		insert mensalidades (CD_ASSOCIADO_empresa, TP_ASSOCIADO_EMPRESA, cd_tipo_parcela, CD_TIPO_PAGAMENTO, CD_TIPO_RECEBIMENTO, DT_VENCIMENTO, DT_GERADO, VL_PARCELA, VL_Acrescimo, VL_Desconto, chaId, cd_usuario_cadastro)
                values (@ass, 1 , @tipo_parcela, @tp_pag, 0, @dt_venc, getdate(), 0, 0, 0, case when @chaId > 0 then @chaId else null end, case when @cd_funcionario_cadastro > 0 then @cd_funcionario_cadastro else null end)  
		if @@Rowcount =  0 
		  begin -- 8.1
			Set @retorno = 'Erro na inclusão da adesão.'
			return
		  end -- 8.1

		print '21'     
		select @cd_parc = max(CD_PARCELA)
		  from mensalidades
		 where cd_associado_empresa = @ass and 
		       cd_tipo_parcela = @tipo_parcela and 
   			   convert(varchar(10),DT_VENCIMENTO,101) = @dt_venc and 
			   TP_ASSOCIADO_EMPRESA = 1 and 
			   vl_parcela = 0 
    End -- 2.2
    
	print '22'             
	insert mensalidades_planos (cd_parcela_mensalidade, cd_sequencial_dep , valor, cd_plano) 
	values (@cd_parc, @cd_seq, @vl_parcela , @cd_plano)
    
	if @@Rowcount =  0 
	begin -- 8.2
	  Set @retorno ='Erro na inclusão da adesão do usuário.'
	  return
	end -- 8.2
    
    --Set @retorno ='Erro na inclusão da adesão do usuário.'
    return  
    
End
