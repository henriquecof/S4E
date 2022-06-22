/****** Object:  Function [dbo].[FF_QtdeMesRenovacao]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Function [dbo].[FF_QtdeMesRenovacao] (@cod int, @venc date, @referencia smallint) returns Int 
Begin
	Declare @dt_renov date 

    -- @referencia 
    -- 1 - Dt assinatura contrato
    -- 2 - MM ANO 1 PAGAMENTO     
    
	-- Qual a proxima renovacao
	if  @referencia=1
	begin
	   select top 1 @dt_renov= dt_assinaturaContrato from dependentes where cd_Associado= @cod and cd_grau_parentesco = 1 
    end 
    
	if @referencia=2
	begin
	   select top 1 @dt_renov= convert(date,right(mm_aaaa_1pagamento,2)+'/01/'+LEFT(mm_aaaa_1pagamento,4),101) from dependentes where cd_Associado= @cod and cd_grau_parentesco = 1 
    end 
    
	While convert(varchar(6),@dt_renov,112) <= convert(varchar(6),@venc,112)
	Begin
	  Set @dt_renov=dateadd(year,1,@dt_renov)
	End 
	--Set @dt_renov=dateadd(month,-1,@dt_renov)

	--print @venc
	--print @dt_renov

	Return DATEDIFF(month,@venc,@dt_renov)

End 

--@cod int = 2610 
--@venc date = '03/30/2017'
