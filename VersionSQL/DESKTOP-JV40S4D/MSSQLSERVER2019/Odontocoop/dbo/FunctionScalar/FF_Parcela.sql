/****** Object:  Function [dbo].[FF_Parcela]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Function [dbo].[FF_Parcela] (@cd_sequencial_dep int , @parc int, @venc date, @seq_mp int) returns Int 
as
Begin  
	Declare @parc_c int , @seq_mp_c int 
	Declare @qtde int = 0 

	DECLARE cursor_pro CURSOR FOR 
	  select top 1000 t10.cd_parcela, t20.cd_sequencial 
		from mensalidades t10, mensalidades_planos t20
		where t10.dt_vencimento <= @venc And
			  t10.cd_tipo_recebimento  not in (1) And 
			  t10.cd_tipo_parcela in (1)         And
			 -- t10.TP_ASSOCIADO_EMPRESA=1 and 
			  t10.cd_parcela = t20.cd_parcela_mensalidade And
			  t20.cd_sequencial_dep = @cd_sequencial_dep  And
			  isnull(t20.cd_tipo_parcela,1) in (1,11)	and 
			  t20.dt_exclusao is null 
	order by t10.dt_vencimento , t10.CD_PARCELA desc , t20.cd_sequencial   
	   
	OPEN cursor_pro
	FETCH NEXT FROM cursor_pro INTO @parc_c,@seq_mp_c

	WHILE (@@FETCH_STATUS <> -1)
	BEGIN

	   Set @qtde = @qtde + 1 
	   if @parc = @parc_c and @seq_mp=@seq_mp_c
		  break 

	   FETCH NEXT FROM cursor_pro INTO @parc_c,@seq_mp_c
	End 
	Close cursor_pro
	Deallocate cursor_pro   		  

	return @qtde
End 	
