/****** Object:  Procedure [dbo].[PS_GerarFalta_Automatico]    Committed by VersionSQL https://www.versionsql.com ******/

--sp_helptext PS_GerarFalta_Automatico

create Procedure [dbo].[PS_GerarFalta_Automatico]
as
Begin 
	Declare @dt SmallDatetime
	Declare @dent int 
	Declare @clinica int 
	Declare @func int 

	declare @datafinal date = getdate()
	
    Declare Dados_CursorFalta cursor for
	select convert(varchar(10),T1.dt_compromisso,101) Data, T1.cd_funcionario, T1.cd_filial, (select cd_funcionario from Processos where cd_processo = 6)
	from agenda T1, filial T2, funcionario T3
	where T1.cd_filial = T2.cd_filial
	and T1.cd_funcionario = T3.cd_funcionario
	and T1.cd_sequencial_dep is not null
	and T1.cd_sequencial not in (
	select cd_sequencial_agenda from consultas where cd_sequencial_agenda = T1.cd_sequencial and dt_cancelamento is null
	)
	and convert(datetime, T1.dt_compromisso) < convert(datetime,@datafinal)
	group by T1.dt_compromisso, T1.cd_funcionario, T1.cd_filial, T2.nm_filial, T3.nm_empregado, T3.nr_cpf, T3.cro
	order by T2.nm_filial, T3.nm_empregado, T1.cd_funcionario, T1.dt_compromisso
    Open Dados_CursorFalta
      Fetch next from Dados_CursorFalta Into @dt, @dent, @clinica, @func
    While (@@fetch_status  <> -1)
       Begin      
         exec PS_GerarFalta  @dent, @clinica, @dt , 1, 1, 1439, @func
		print @dent
         Fetch next from Dados_CursorFalta Into @dt, @dent, @clinica, @func         
       End
         
    Close Dados_CursorFalta     	
    Deallocate Dados_CursorFalta
    
End 
