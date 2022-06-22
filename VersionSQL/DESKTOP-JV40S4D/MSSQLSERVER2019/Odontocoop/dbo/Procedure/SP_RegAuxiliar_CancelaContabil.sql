/****** Object:  Procedure [dbo].[SP_RegAuxiliar_CancelaContabil]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_RegAuxiliar_CancelaContabil] (@competencia varchar(6))
as
Begin 
	Declare @meses_atrasos_pf as tinyint  
	Declare @meses_renegociacao_pf as tinyint 

	Declare @meses_atrasos_pj as tinyint  
	Declare @meses_renegociacao_pj as tinyint 

	Declare @dt_base as date 
	Declare @ult_diacompetencia as int -- Saber qual o ultimo dia do mes da Competencia (28,30 ou 31)
    Declare @cd_func int 
    
    select top 1 @cd_func=cd_funcionario from Processos

	Select @meses_atrasos_pf=isnull(qt_meses_cancela_regaux_pf,0),@meses_renegociacao_pf=isnull(qt_meses_renegocia_regaux_pf,0),
	       @meses_atrasos_pj=isnull(qt_meses_cancela_regaux_pj,0),@meses_renegociacao_pj=isnull(qt_meses_renegocia_regaux_pj,0)
	  from configuracao 

	print @competencia
	print convert(date,RIGHT(@competencia,2)+'/01/'+LEFT(@competencia,4))

	Set @dt_base = dateadd(month,1,convert(date,RIGHT(@competencia,2)+'/01/'+LEFT(@competencia,4))) -- Primeiro dia do mes posterior
	Set @ult_diacompetencia = day(DATEADD(day,-1,@dt_base))

    print @dt_base
    
	if @meses_atrasos_pf>0 
	Begin
	    -- Se aberto e superior a 2 meses cancelar
		update MENSALIDADES -- Cancelar os titulos em abertos 
		   set dt_cancelado_contabil = dateadd(month,@meses_atrasos_pf,dt_vencimento) ,
			   CD_USUARIO_ALTERACAO = case when CD_USUARIO_ALTERACAO is null then @cd_func else CD_USUARIO_ALTERACAO end , 
			   DT_ALTERACAO=case when DT_ALTERACAO is null then GETDATE() else DT_ALTERACAO end ,
			   executarTrigger=0
		 where CD_TIPO_RECEBIMENTO in (0) and 
			   dt_cancelado_contabil is null and 
			   TP_ASSOCIADO_EMPRESA=1 and 
			   DT_VENCIMENTO < dateadd(month,-1*@meses_atrasos_pf,@dt_base)  and
			   dt_emissao is not null
     End 

--        -- Cancelar os titulos acordados cujo vencimento ja venceram
		update MENSALIDADES -- Cancelar os titulos acordados
		   set dt_cancelado_contabil = case when convert(varchar(6),isnull(DT_BAIXA,getdate()),112)>convert(varchar(6),dateadd(month,@meses_atrasos_pf,dt_vencimento),112) then isnull(DT_BAIXA,getdate()) else dateadd(month,@meses_atrasos_pf,dt_vencimento) end ,
			   CD_USUARIO_ALTERACAO = case when CD_USUARIO_ALTERACAO is null then @cd_func else CD_USUARIO_ALTERACAO end , 
			   DT_ALTERACAO=case when DT_ALTERACAO is null then GETDATE() else DT_ALTERACAO end ,
			   CD_USUARIO_BAIXA = case when CD_USUARIO_BAIXA is null then @cd_func else CD_USUARIO_BAIXA end , 
			   DT_BAIXA=case when DT_BAIXA is null then GETDATE() else DT_BAIXA end ,
			   executarTrigger=0
		 where CD_TIPO_RECEBIMENTO in (2) and 
			   dt_cancelado_contabil is null and 
			   TP_ASSOCIADO_EMPRESA=1 and 
			   convert(varchar(6),dt_baixa,112) <= @competencia  and
			   dt_emissao is not null

		update MENSALIDADES -- Cancelar os titulos acordados
		   set dt_cancelado_contabil = case when convert(varchar(6),isnull(DT_BAIXA,getdate()),112)>convert(varchar(6),@competencia,112)  then isnull(DT_BAIXA,getdate()) else convert(date,RIGHT(@competencia,2)+'/' + convert(varchar(2),case when DAY(dt_vencimento)>@ult_diacompetencia then @ult_diacompetencia else DAY(dt_vencimento) end) + '/'+LEFT(@competencia,4)) end ,
			   CD_USUARIO_ALTERACAO = case when CD_USUARIO_ALTERACAO is null then @cd_func else CD_USUARIO_ALTERACAO end , 
			   DT_ALTERACAO=case when DT_ALTERACAO is null then GETDATE() else DT_ALTERACAO end ,
			   CD_USUARIO_BAIXA = case when CD_USUARIO_BAIXA is null then @cd_func else CD_USUARIO_BAIXA end , 
			   DT_BAIXA=case when DT_BAIXA is null then GETDATE() else DT_BAIXA end ,
			   executarTrigger=0
		 where CD_TIPO_RECEBIMENTO in (1) and 
			   dt_cancelado_contabil is null and 
			   TP_ASSOCIADO_EMPRESA=1 and 
			   convert(varchar(6),dt_baixa,112) <= @competencia and
			   dt_emissao is not null

	if @meses_atrasos_pj>0 
	Begin
		update MENSALIDADES -- Cancelar os titulos em abertos 
		   set dt_cancelado_contabil = dateadd(month,@meses_atrasos_pf,dt_vencimento) ,
			   CD_USUARIO_ALTERACAO = case when CD_USUARIO_ALTERACAO is null then @cd_func else CD_USUARIO_ALTERACAO end , 
			   DT_ALTERACAO=case when DT_ALTERACAO is null then GETDATE() else DT_ALTERACAO end ,
			   executarTrigger=0
		 where CD_TIPO_RECEBIMENTO = 0 and 
			   dt_cancelado_contabil is null and 
			   TP_ASSOCIADO_EMPRESA=2 and 
			   isnull(dt_negociado,DT_VENCIMENTO) < dateadd(month,-1*@meses_atrasos_pj,@dt_base) and
			   dt_emissao is not null
     End  

		update MENSALIDADES -- Cancelar os titulos acordados
		   set dt_cancelado_contabil = case when convert(varchar(6),isnull(DT_BAIXA,getdate()),112)>convert(varchar(6),dateadd(month,@meses_atrasos_pf,dt_vencimento),112) then isnull(DT_BAIXA,getdate()) else dateadd(month,@meses_atrasos_pf,dt_vencimento) end ,
			   CD_USUARIO_ALTERACAO = case when CD_USUARIO_ALTERACAO is null then @cd_func else CD_USUARIO_ALTERACAO end , 
			   DT_ALTERACAO=case when DT_ALTERACAO is null then GETDATE() else DT_ALTERACAO end ,
			   CD_USUARIO_BAIXA = case when CD_USUARIO_BAIXA is null then @cd_func else CD_USUARIO_BAIXA end , 
			   DT_BAIXA=case when DT_BAIXA is null then GETDATE() else DT_BAIXA end ,
			   executarTrigger=0
		 where CD_TIPO_RECEBIMENTO = 2 and 
			   dt_cancelado_contabil is null and 
			   TP_ASSOCIADO_EMPRESA=2 and 
			   convert(varchar(6),dt_baixa,112) <= @competencia and
			   dt_emissao is not null

		update MENSALIDADES -- Cancelar os titulos acordados
		   set dt_cancelado_contabil = case when convert(varchar(6),isnull(DT_BAIXA,getdate()),112)>convert(varchar(6),@competencia,112)  then isnull(DT_BAIXA,getdate()) else convert(date,RIGHT(@competencia,2)+'/' + convert(varchar(2),case when DAY(dt_vencimento)>@ult_diacompetencia then @ult_diacompetencia else DAY(dt_vencimento) end) + '/'+LEFT(@competencia,4)) end ,
			   CD_USUARIO_ALTERACAO = case when CD_USUARIO_ALTERACAO is null then @cd_func else CD_USUARIO_ALTERACAO end , 
			   DT_ALTERACAO=case when DT_ALTERACAO is null then GETDATE() else DT_ALTERACAO end ,
			   CD_USUARIO_BAIXA = case when CD_USUARIO_BAIXA is null then @cd_func else CD_USUARIO_BAIXA end , 
			   DT_BAIXA=case when DT_BAIXA is null then GETDATE() else DT_BAIXA end ,
			   executarTrigger=0
		 where CD_TIPO_RECEBIMENTO = 1 and 
			   dt_cancelado_contabil is null and 
			   TP_ASSOCIADO_EMPRESA=2 and 
			   convert(varchar(6),dt_baixa,112) <= @competencia and
			   dt_emissao is not null

		   
End 
