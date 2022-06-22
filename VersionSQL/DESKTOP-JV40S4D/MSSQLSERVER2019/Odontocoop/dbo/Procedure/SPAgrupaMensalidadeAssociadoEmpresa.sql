/****** Object:  Procedure [dbo].[SPAgrupaMensalidadeAssociadoEmpresa]    Committed by VersionSQL https://www.versionsql.com ******/

create procedure [dbo].[SPAgrupaMensalidadeAssociadoEmpresa]
	@cd_funcionario integer,
    @cd_empresa integer,
    @dt_vencimento datetime,
    @parcelasAssociado varchar(max)
as
begin -- 1
	
	--declare @cd_funcionario integer = 7021
	--declare @cd_empresa integer = 1958
	--declare @dt_vencimento datetime = '09/27/2017'
	--declare @parcelasAssociado varchar(max) = '1994628'
	declare @cd_tipopagamento integer 
	declare @tp_empresa integer
	declare @cd_parcelaCriada integer

	select @cd_tipopagamento = cd_tipo_pagamento, @tp_empresa = TP_EMPRESA
	from EMPRESA 
	where CD_EMPRESA = @cd_empresa

	--Cria mensalidade
	insert mensalidades (CD_ASSOCIADO_empresa,TP_ASSOCIADO_EMPRESA,cd_tipo_parcela, CD_TIPO_PAGAMENTO,CD_TIPO_RECEBIMENTO,DT_VENCIMENTO,DT_GERADO, vl_parcela, cd_usuario_cadastro )
	values (@cd_empresa, (case when @tp_empresa in (2,7,8) then 2 when @tp_empresa in (6) then 3 else 1 end), 1 , @cd_tipopagamento, 0 , @dt_vencimento , GETDATE(),0,@cd_funcionario) 

	--Pega mensalidade criada
	select @cd_parcelaCriada = max(CD_PARCELA)
	from mensalidades
	where cd_associado_empresa = @cd_empresa 
		and cd_tipo_parcela = 1 
		and DT_VENCIMENTO = @dt_vencimento 
		and cd_tipo_recebimento = 0 
		and TP_ASSOCIADO_EMPRESA = (case when @tp_empresa in (2,7,8) then 2 when @tp_empresa in (6) then 3 else 1 end)
		
	--Update no valor da mensalidade
	update mensalidades
	set VL_PARCELA = (select SUM(VL_PARCELA) from mensalidades where CD_PARCELA in (select * from fnStringList2Table(@parcelasAssociado)))
	where CD_PARCELA = @cd_parcelaCriada
	
	--Copiando mensalidade_plano para a nova mensalidade
	insert into Mensalidades_Planos (cd_parcela_mensalidade, cd_sequencial_dep, cd_plano, valor, cd_funcionario_exclusao, cd_empresa_filha, cd_tipo_parcela, id_mensalidade_avulsa, cd_sequencial_consulta)
	select @cd_parcelaCriada, cd_sequencial_dep, cd_plano, valor, cd_funcionario_exclusao, cd_empresa_filha, cd_tipo_parcela, id_mensalidade_avulsa, cd_sequencial_consulta
	from Mensalidades_Planos 
	where cd_parcela_mensalidade in (SELECT * from fnStringList2Table(@parcelasAssociado))
	
end -- 1
