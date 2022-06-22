/****** Object:  Procedure [dbo].[PS_CorteProdutividadeDentista]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE proc [dbo].[PS_CorteProdutividadeDentista]
    @wl_diaCorte int = 0 
as
begin
	Declare @CRO int
	Declare @cd_filial int 
	Declare @Data as smalldatetime
	Declare @DataLimite as varchar(10)
	
	set @Data = dateadd(m,-1,getdate())
	set @DataLimite = convert(varchar(10),convert(varchar,datepart(month,@Data)) + '/' + dbo.FF_UltimoDiaMes(datepart(month,@Data),datepart(year,@Data)) + '/' + convert(varchar,datepart(year,@Data)),101)
	
	if @wl_diaCorte=0 
	   Set @wl_diaCorte=datepart(day,getdate())
	   
	DECLARE vCursor CURSOR FOR
		--select distinct cro from funcionario
		--where cd_cargo in (30,32)
		--and cro is not null
		--and cro > 0 
		--and dia_corte is not null
		--and cd_situacao = 1
		--and dia_corte = @wl_diaCorte 
		
		select 0, cd_filial from filial where fl_consultorio = 1 and fl_ativa = 1 and dt_corte = @wl_diaCorte 
	OPEN vCursor
	
	FETCH NEXT FROM vCursor INTO @CRO,@cd_filial 
	
	WHILE @@FETCH_STATUS = 0
		BEGIN
		    print @CRO
		    print @DataLimite
			Exec PS_CriaLotesPagamentoDentista @CRO, @DataLimite,@cd_filial 

			FETCH NEXT FROM vCursor INTO @CRO,@cd_filial 
		END
	
	CLOSE vCursor
	
	DEALLOCATE vCursor
end
