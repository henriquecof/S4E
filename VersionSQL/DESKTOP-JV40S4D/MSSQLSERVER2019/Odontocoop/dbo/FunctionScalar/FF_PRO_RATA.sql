/****** Object:  Function [dbo].[FF_PRO_RATA]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE function [dbo].[FF_PRO_RATA] (
	@associado as integer,
	@empresaOrigem as integer,
	@empresaDestino as integer,
	@cd_plano as integer)
returns varchar(50)
as
begin

   ----------------------------------------
   -- Declaração de Variaveis            --
   ----------------------------------------
   Declare @cd_Ass int 
   Declare @Qtde int 
   Declare @dt_venc Int
   Declare @dt_venc_ant Int
   Declare @dias int 
   Declare @dt_vencT Date
   
         
   Declare @parcela int
   Declare @vencimento date
   
	Select @cd_Ass = i.cd_associado , 
			@dt_venc = eI.dt_vencimento, 
			@dias = case when eI.dt_vencimento > ee.dt_vencimento then eI.dt_vencimento - ee.dt_vencimento else -1*(ee.dt_vencimento-eI.dt_vencimento) end , 
			@dt_venc_ant = ee.dt_vencimento
	From Associados as I, Empresa as EI, Empresa as EE
	where i.cd_Associado = @associado and 
         @empresaDestino = EI.cd_empresa and 
         @empresaOrigem = EE.cd_empresa and 
         eI.dt_vencimento <> EE.dt_vencimento and 
         eI.tp_empresa = 3 

     --print @cd_Ass
     
	select @Qtde = count(0) 
	from mensalidades 
	where TP_ASSOCIADO_EMPRESA = 1 
			and cd_associado_empresa = @cd_Ass 
			and CD_TIPO_RECEBIMENTO = 0 
			and cd_tipo_parcela = 1
			and dt_vencimento <= CONVERT(varchar(10),getdate(),101)

	 if @Qtde >0 
        return 'Recurso indisponível para usuário em atraso.'
     else	 	
       Set @dt_vencT = dateadd(month,1,getdate())
       Set @dt_vencT = convert(varchar(2),MONTH(@dt_vencT))+'/01/'+convert(varchar(4),year(@dt_vencT))
       
		Select top 1 @parcela = m.cd_parcela, @vencimento = m.dt_vencimento
		From mensalidades as m
	   where m.cd_Associado_empresa = @cd_Ass
	     and m.cd_tipo_recebimento = 0 
	     and m.tp_associado_empresa = 1
	     and cd_tipo_parcela = 1
	     and m.dt_vencimento >= @dt_vencT
	   order by m.dt_vencimento asc  
		
		if @dias<>0 and @dt_venc>@dt_venc_ant -- Se o venc foi posterior paga o pro-rata antecipado
			Set @vencimento = convert(date,convert(varchar(2),month(@vencimento))+'/'+convert(varchar(2),case when month(@vencimento)=2 and @dt_venc_ant=30 then 28 else @dt_venc_ant end) + '/' + convert(varchar(4),year(@vencimento)))
		else 
		    Set @vencimento = convert(date,convert(varchar(2),month(@vencimento))+'/'+convert(varchar(2),case when month(@vencimento)=2 and @dt_venc=30 then 28 else @dt_venc end) + '/' + convert(varchar(4),year(@vencimento)))

	Declare @calculo money
	Declare @plano integer
	declare @vencimentoNovo date

	select @calculo = case when t2.cd_grau_parentesco = 1 then Vl_tit else vl_dep1 end--, @dt_assContrato = t2.dt_assinaturaContrato 
	from preco_plano t1, DEPENDENTES t2
	where t1.cd_empresa = @empresaDestino and
		t1.dt_fim_comercializacao is null and
		t2.CD_SEQUENCIAL = @associado and
		t1.cd_plano = @cd_plano

	 

	set @vencimentoNovo = @vencimento
	--return @dt_venc_ant
	if @dt_venc > @dt_venc_ant 
		begin
		set @vencimentoNovo = convert(varchar(2),MONTH(@vencimento))+'/'+convert(varchar(2),@dt_venc)+'/'+convert(varchar(4),year(@vencimento))
		end
	else
		begin
		set @vencimentoNovo = convert(varchar(2),MONTH(@vencimento))+'/'+convert(varchar(2),@dt_venc_ant)+'/'+convert(varchar(4),year(@vencimento))
		end

	set @calculo = round((@calculo/30)*(dbo.FF_Calculo_Prorata (@vencimento,@vencimentoNovo)),2)

	return convert(varchar(50),Abs(@calculo))+'|'+convert(varchar(2),MONTH(@vencimentoNovo))+'/'+convert(varchar(4),year(@vencimentoNovo))

end
