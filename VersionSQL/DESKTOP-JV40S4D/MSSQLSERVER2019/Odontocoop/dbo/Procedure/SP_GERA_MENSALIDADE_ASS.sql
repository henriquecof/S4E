/****** Object:  Procedure [dbo].[SP_GERA_MENSALIDADE_ASS]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE procedure [dbo].[SP_GERA_MENSALIDADE_ASS]
	@wl_venc datetime,
	@wl_empresa integer,
    @tp_empresa integer
as
begin

    Declare @cd_ass integer

    if @tp_empresa >= 10 -- Empresa >= 10 Sao particulares e Convenios e nao faturados por essa rotina
       return 

	DECLARE GERA_MENSALIDADE_ASS CURSOR FOR  
	select a.cd_Associado
	  from associados as a, dependentes as d, historico as h /*Dependente */, situacao_historico as s , empresa as e
	 where a.cd_empresa = @wl_empresa and 
           a.cd_empresa = e.cd_empresa and 
		   a.cd_associado = d.cd_associado and 
		   d.cd_sequencial_historico = h.cd_sequencial and 
		   h.cd_situacao = s.cd_situacao_historico and 
           d.cd_grau_parentesco =1 and 
		   s.fl_gera_cobranca = 1 and 
           e.tp_empresa = @tp_empresa and 
		   d.mm_aaaa_1pagamento <= convert(int,year(@wl_venc))*100 + convert(int,month(@wl_venc)) 
	OPEN GERA_MENSALIDADE_ASS  
	FETCH NEXT FROM GERA_MENSALIDADE_ASS INTO @cd_ass
	WHILE (@@FETCH_STATUS <> -1)  
	begin  

        exec sp_gera_mensalidade @wl_venc, @cd_ass, @tp_empresa, 0 , 0 , 1 

	 	FETCH NEXT FROM GERA_MENSALIDADE_ASS INTO @cd_ass
    End 
    Close GERA_MENSALIDADE_ASS
    Deallocate GERA_MENSALIDADE_ASS

end
