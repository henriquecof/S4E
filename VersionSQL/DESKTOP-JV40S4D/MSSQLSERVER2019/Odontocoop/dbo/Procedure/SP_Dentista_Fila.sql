/****** Object:  Procedure [dbo].[SP_Dentista_Fila]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_Dentista_Fila] 
   @cd_associado int, 
   @cd_Sequencial_dep int, 
   @cd_Filial int, 
   @cd_especialidade int = 1, 
   @cd_func int = 0 ,
   @cd_usuario int,
   @cd_sequencial_Agenda int Out,
   @data VARCHAR(20)	
    
As
Begin 
   
  DECLARE @dataTime datetime
  set @dataTime = convert(datetime, @data)
  
  Declare @qtde integer
  Declare @cd_seq_at int --- Atuacao Dentista

  if @cd_func > 0 
   begin
       Select top 1 @cd_seq_at = cd_sequencial_atuacao_dent  from agenda where cd_funcionario=@cd_func and dt_compromisso = CONVERT(varchar(10),@dataTime,101) and cd_filial = @cd_Filial 
	   if @cd_seq_at is null 
		Begin
		   RAISERROR ('Dentista nao possui agenda na clinica no dia de hoje.', 16, 1)
		   Return
		End
   End 
  else
  begin   
	select top 1 @cd_func = func_taxi.cd_funcionario --, max(dt_marcado)
	from (
	select distinct a.cd_funcionario
	  from agenda as a, atuacao_dentista as ad , especialidade as e
	 where a.cd_filial=@cd_Filial and 
		   a.cd_sequencial_atuacao_dent = ad.cd_sequencial and 
		   ad.cd_especialidade = e.cd_especialidade and 
		   --a.nr_autorizacao is not null and 
		   a.dt_compromisso = CONVERT(varchar(10),@dataTime,101) and 
		   ad.cd_especialidade=@cd_especialidade and 
		   convert(varchar(8),ad.hi,114) <= convert(varchar(8),@dataTime,114) and 
		   convert(varchar(8),ad.hf,114) >= convert(varchar(8),@dataTime,114) and 
		   a.cd_funcionario not in 
		   (
					  select distinct a.cd_funcionario 
						from agenda as a, atuacao_dentista as ad , especialidade as e
					  where a.cd_filial=@cd_Filial and 
							   a.cd_sequencial_atuacao_dent = ad.cd_sequencial and 
							   ad.cd_especialidade = e.cd_especialidade and 
							   a.nr_autorizacao is not null and 
							   a.dt_compromisso = CONVERT(varchar(10),@dataTime,101) and 
							   ad.cd_especialidade=@cd_especialidade and 
							   hr_chegou is not null and 
							   a.cd_sequencial not in (select cd_sequencial_agenda from consultas where dt_servico = CONVERT(varchar(10),@dataTime,101) and cd_filial = 5) and 
							   convert(varchar(8),ad.hi,114) <= convert(varchar(8),@dataTime,114) and 
							   convert(varchar(8),ad.hf,114) >= convert(varchar(8),@dataTime,114)
		  )
	) as func_taxi, agenda as ag
	where func_taxi.cd_funcionario = ag.cd_funcionario and 
		  ag.dt_compromisso = CONVERT(varchar(10),@dataTime,101) and
		  ag.cd_filial=@cd_Filial
	group by func_taxi.cd_funcionario       
	order by max(dt_marcado) desc
	
	--exec @sql 
	
	print @@ROWCOUNT
	
	if @@ROWCOUNT = 0 -- Nao tem nenhum dentista disponivel 
	Begin 
    print '----'
    print 'SEM DENTISTA DISPONIVEL'
	select top 1 @cd_func = func_taxi.cd_funcionario --, max(dt_marcado)
	  from funcionario as func_taxi, agenda as ag, atuacao_dentista as ad , especialidade as e
	 where func_taxi.cd_funcionario = ag.cd_funcionario and 
	       ag.cd_sequencial_atuacao_dent = ad.cd_sequencial and 
		   ad.cd_especialidade = e.cd_especialidade and 
		   ad.cd_especialidade=@cd_especialidade and 
		    CONVERT(varchar(10),ag.dt_compromisso,101) = CONVERT(varchar(10),@dataTime,101) and
		   ag.cd_filial=@cd_Filial 
	 group by func_taxi.cd_funcionario       
	 order by max(dt_marcado) desc

	End 
   End	
   
	print @cd_func
	Declare @hr_compromisso int 
	
	set @hr_compromisso = dbo.invertehora(convert(varchar(5),@dataTime,108))
	
	
	if CONVERT(varchar(10),@dataTime,101) = CONVERT(varchar(10),GETDATE(),101) 
		begin
			-- Verificar qual o horario que nao tem agenda gerada 
			While 1=1 
			Begin 

			   Select @qtde = COUNT(0) 
				 from agenda 
				where cd_funcionario=@cd_func and 
					  dt_compromisso = CONVERT(varchar(10),@dataTime,101) and 
					  cd_filial = @cd_Filial and 
					  hr_compromisso = @hr_compromisso
		             
						              
			   if @qtde = 0 
				Begin
				   insert agenda (cd_funcionario,dt_compromisso,hr_compromisso,cd_associado,cd_sequencial_dep,
						dt_marcado,cd_usuario,hr_chegou,cd_filial,cd_sequencial_atuacao_dent,fl_marcacao_avulsa,tp_usuario)
				   values (@cd_func,convert(varchar(10),@dataTime,101),@hr_compromisso,@cd_associado,@cd_Sequencial_dep,
						@dataTime,@cd_usuario,@hr_compromisso,@cd_Filial,@cd_seq_at,1,5)      
				        
				   -- Verificar se gravou e devolver o sequencial 
				   select @cd_sequencial_Agenda = cd_sequencial from agenda
					where cd_funcionario=@cd_func and 
						  dt_compromisso = CONVERT(varchar(10),@dataTime,101) and 
						  cd_filial = @cd_Filial and 
						  hr_compromisso = @hr_compromisso and 
						  cd_sequencial_dep = @cd_Sequencial_dep
					if @cd_sequencial_Agenda is not null       
					   return 
				       
					print 'break' 
					break 
				       
				End      
				
			   Set @hr_compromisso = @hr_compromisso + 1 -- Aumenta 1 minuto
			    
			End
		end
	
	else
		begin
			Declare @seqAgenda int
			set @seqAgenda = 0
		
			Select top 1 @seqAgenda = cd_sequencial from agenda 
			where cd_funcionario = @cd_func and 
			CONVERT(varchar(10),dt_compromisso,101) = CONVERT(varchar(10),@dataTime,101) and 
			cd_filial = @cd_Filial and 
			cd_sequencial_dep is null
			order by hr_compromisso
			
			 if @seqAgenda > 0 
				Begin
				  Update agenda 
				  set cd_funcionario = @cd_func, 
				  cd_associado = @cd_associado,
				  cd_sequencial_dep = @cd_Sequencial_dep,
				  dt_marcado = GETDATE(),
				  cd_usuario = @cd_usuario,
				  cd_filial = @cd_Filial, 
				  fl_marcacao_avulsa = 1,
				  tp_usuario= 5
				  where cd_sequencial = @seqAgenda
				   
				end
				
						
		end
	
	

End 
