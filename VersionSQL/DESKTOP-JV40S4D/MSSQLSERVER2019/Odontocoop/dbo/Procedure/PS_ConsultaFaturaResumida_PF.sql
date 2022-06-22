/****** Object:  Procedure [dbo].[PS_ConsultaFaturaResumida_PF]    Committed by VersionSQL https://www.versionsql.com ******/

  --exec PS_ConsultaFaturaResumida_PF 97 ,'07/25/2019'
CREATE Procedure [dbo].[PS_ConsultaFaturaResumida_PF](  
       @Empresa int,  
       @DT_Vencimento varchar(10))  
As  
Begin  

	Declare @cd_parc int  
	Declare @cd_parc_ant int   
	Declare @Dt_VencAnt datetime   
	Declare @Dt_VencAtual datetime   

	select @dt_vencAnt = dateadd(month,-1,@DT_Vencimento)   
	select @dt_vencAnt = convert(datetime,convert(varchar(2),month(@dt_vencAnt)) + '/01/' + convert(varchar(4),year(@dt_vencAnt)))  

	select @Dt_VencAtual = dateadd(month,0,@DT_Vencimento)   
	select @Dt_VencAtual = convert(datetime,convert(varchar(2),month(@Dt_VencAtual)) + '/01/' + convert(varchar(4),year(@Dt_VencAtual)))  

	print @dt_vencAnt  

	print 'inicio del'  
	delete ConsultaFaturaResumida where cd_empresa = @Empresa  
	print 'fim del'  
  
 --select @cd_parc = cd_parcela from mensalidades   
 -- where cd_associado_empresa = @Empresa and cd_tipo_parcela = 1 and cd_tipo_recebimento not in (1,2) and tp_Associado_empresa = 2 and   
 --    dt_vencimento >= @DT_Vencimento and dt_vencimento <= @DT_Vencimento + ' 23:59'  
  
 --select @cd_parc_ant = cd_parcela from mensalidades   
 -- where cd_associado_empresa = @Empresa and cd_tipo_parcela = 1 and cd_tipo_recebimento not in (1,2) and tp_Associado_empresa = 2 and   
 --    dt_vencimento >= @dt_vencAnt and dt_vencimento < dateadd(month,1,@dt_vencAnt)   
  
	insert into ConsultaFaturaResumida      (cd_empresa,tipo,cd_associado,valor)
	select @Empresa, 1 as tipo, a.cd_Associado, sum(m.VL_PARCELA)
	from ASSOCIADOS as a, mensalidades as m   
	where a.cd_empresa=@Empresa and   
		a.cd_Associado = m.cd_associado_empresa and   
		m.cd_tipo_parcela in(1,2) and   
		m.cd_tipo_recebimento not in (1,2) and   
		m.tp_Associado_empresa = 1 and   
		m.dt_vencimento >= @Dt_VencAtual and m.dt_vencimento <  dateadd(month,1,@Dt_VencAtual)   
	group by a.cd_Associado  
	union   
	select @Empresa, 2 as tipo, a.cd_Associado, sum(m.VL_PARCELA)   
	from ASSOCIADOS as a, mensalidades as m   
	where a.cd_empresa=@Empresa and   
		a.cd_Associado = m.cd_associado_empresa and   
		m.cd_tipo_parcela in(1,2) and   
		m.cd_tipo_recebimento not in (1,2) and   
		m.tp_Associado_empresa = 1 and   
		m.dt_vencimento >= @dt_vencAnt and m.dt_vencimento < dateadd(month,1,@dt_vencAnt)   
	group by a.cd_Associado  
End
