/****** Object:  Procedure [dbo].[SP_Atendimento_Sintetico]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_Atendimento_Sintetico] 
   @dt_ini varchar(10) , @dt_fim varchar(10), @cd_filial varchar(1000) = '' 
as 
Begin

  -- Existe a Procedure SP_Atendimento
  -- Caso modifique essa acerta a outra

  if @cd_filial <> '' and RIGHT(@cd_filial,1)<>','
  begin
    return
  End 
  
  Declare @lin varchar(max) 
  Declare @qtde int = 3 
  Declare @cod varchar(10) 
  Declare @pos int 
  Declare @cd_filialaux varchar(1000) 
  
  Set @cd_filialaux = @cd_filial
  
  Set @lin = 'select 1 as SEQUENCIAL,''CONSULTA AGENDADA - GERAL'' AS RESUMO, '
  While @cd_filial <> ''
  Begin
     Set @pos = PATINDEX('%,%',@cd_filial)
     Set @cod = LEFT(@cd_filial,@pos-1)
     Set @cd_filial = substring(@cd_filial , @pos+1,LEN(@cd_filial)-@pos)
     Set @qtde = @qtde + 1 
     
       Set @lin = @lin + ' 
				(select COUNT(0) 
				   from Agenda as c1 
				  where c1.cd_associado is not null and
						c1.dt_compromisso >= ''' + @dt_ini + ''' and 
		                c1.dt_compromisso <= ''' + @dt_fim + ' 23:59''  and
						c1.cd_filial='+ CONVERT(varchar(10),@cod) +  
				  '), '

  End 		
  
  Set @lin = @lin + ' COUNT(0), 0 as TipoOperacao
	  from Agenda as c
	 where c.cd_associado is not null and
		   c.dt_compromisso >= ''' + @dt_ini + ''' and 
		   c.dt_compromisso <= ''' + @dt_fim + ' 23:59'''

  Set @cd_filial = @cd_filialaux 

--**********************************************************************
  
  Set @lin = @lin + '
      union 
      select 1.1 as SEQUENCIAL, ''CONSULTA AGENDADA - URGÊNCIA'' AS RESUMO, '
  While @cd_filial <> ''
  Begin
     Set @pos = PATINDEX('%,%',@cd_filial)
     Set @cod = LEFT(@cd_filial,@pos-1)
     Set @cd_filial = substring(@cd_filial , @pos+1,LEN(@cd_filial)-@pos)
     Set @qtde = @qtde + 1 
     
       Set @lin = @lin + ' 
				(select COUNT(0) 
				   from Agenda as c1 
				  where c1.cd_associado is not null and
						c1.fl_urgencia = 1 and
						c1.dt_compromisso >= ''' + @dt_ini + ''' and 
		                c1.dt_compromisso <= ''' + @dt_fim + ' 23:59''  and
						c1.cd_filial='+ CONVERT(varchar(10),@cod) +  
				  '), '

  End 		
  
  Set @lin = @lin + ' COUNT(0), 1 as TipoOperacao
	  from Agenda as c
	 where c.cd_associado is not null and
		   c.fl_urgencia = 1 and
		   c.dt_compromisso >= ''' + @dt_ini + ''' and 
		   c.dt_compromisso <= ''' + @dt_fim + ' 23:59'''

  Set @cd_filial = @cd_filialaux 
  
--**********************************************************************
  
  Set @lin = @lin + '
      union 
      select 1.2 as SEQUENCIAL, ''CONSULTA AGENDADA - MARCAÇÃO AVULSA'' AS RESUMO, '
  While @cd_filial <> ''
  Begin
     Set @pos = PATINDEX('%,%',@cd_filial)
     Set @cod = LEFT(@cd_filial,@pos-1)
     Set @cd_filial = substring(@cd_filial , @pos+1,LEN(@cd_filial)-@pos)
     Set @qtde = @qtde + 1 
     
       Set @lin = @lin + ' 
				(select COUNT(0) 
				   from Agenda as c1 
				  where c1.cd_associado is not null and
						isnull(c1.fl_marcacao_avulsa,0) = 1 and
						c1.dt_compromisso >= ''' + @dt_ini + ''' and 
		                c1.dt_compromisso <= ''' + @dt_fim + ' 23:59''  and
						c1.cd_filial='+ CONVERT(varchar(10),@cod) +  
				  '), '

  End 		
  
  Set @lin = @lin + ' COUNT(0), 1 as TipoOperacao
	  from Agenda as c
	 where c.cd_associado is not null and
		   isnull(c.fl_marcacao_avulsa,0) = 1 and
		   c.dt_compromisso >= ''' + @dt_ini + ''' and 
		   c.dt_compromisso <= ''' + @dt_fim + ' 23:59'''

  Set @cd_filial = @cd_filialaux 
  
--**********************************************************************

  Set @lin = @lin + '
      union 
      select 1.3 as SEQUENCIAL, ''HORÁRIO GERADO'' AS RESUMO, '
  While @cd_filial <> ''
  Begin
     Set @pos = PATINDEX('%,%',@cd_filial)
     Set @cod = LEFT(@cd_filial,@pos-1)
     Set @cd_filial = substring(@cd_filial , @pos+1,LEN(@cd_filial)-@pos)
     Set @qtde = @qtde + 1 
     
       Set @lin = @lin + ' 
				(select COUNT(0) 
				   from Agenda as c1 
				  where c1.nm_anotacao is null and 
				        c1.dt_compromisso >= ''' + @dt_ini + ''' and 
		                c1.dt_compromisso <= ''' + @dt_fim + ' 23:59''  and
						c1.cd_filial='+ CONVERT(varchar(10),@cod) +  
				  '), '

  End 		
  
  Set @lin = @lin + ' COUNT(0), 0 as TipoOperacao
	  from Agenda as c
	 where c.nm_anotacao is null and 
	       c.dt_compromisso >= ''' + @dt_ini + ''' and 
		   c.dt_compromisso <= ''' + @dt_fim + ' 23:59'''

  Set @cd_filial = @cd_filialaux 
  
  --**********************************************************************
  
  Set @lin = @lin + '
      union 
      select 2 as SEQUENCIAL, ''FALTA'' AS RESUMO, '
  While @cd_filial <> ''
  Begin
     Set @pos = PATINDEX('%,%',@cd_filial)
     Set @cod = LEFT(@cd_filial,@pos-1)
     Set @cd_filial = substring(@cd_filial , @pos+1,LEN(@cd_filial)-@pos)
     Set @qtde = @qtde + 1 
     
       Set @lin = @lin + ' 
				(select COUNT(0) 
				   from Consultas as c1 
				  where c1.Status in (3,6,7) and
						c1.dt_servico >= ''' + @dt_ini + ''' and 
		                c1.dt_servico <= ''' + @dt_fim + ' 23:59''  and
						c1.cd_filial='+ CONVERT(varchar(10),@cod) +  ' and 
				        c1.cd_servico in (80000618, 80000140,80000144) and 
				        c1.cd_sequencial_agenda is not null 
				  ), '

  End 		
  
  Set @lin = @lin + ' COUNT(0), 1 as TipoOperacao
	  from Consultas as c 
	 where c.Status in (3,6,7) and
		   c.dt_servico >= ''' + @dt_ini + ''' and 
		   c.dt_servico <= ''' + @dt_fim + ' 23:59'' and 
		   c.cd_servico in (80000618, 80000140,80000144) and 
		   c.cd_sequencial_agenda is not null 
		   '


  Set @cd_filial = @cd_filialaux 
  
  --**********************************************************************
  
  Set @lin = @lin + '
      union 
      select 2.1 as SEQUENCIAL, ''DESMARCAÇÃO'' AS RESUMO, '
  While @cd_filial <> ''
  Begin
     Set @pos = PATINDEX('%,%',@cd_filial)
     Set @cod = LEFT(@cd_filial,@pos-1)
     Set @cd_filial = substring(@cd_filial , @pos+1,LEN(@cd_filial)-@pos)
     Set @qtde = @qtde + 1 
     
       Set @lin = @lin + ' 
				(select COUNT(0) 
				   from Consultas as c1 
				  where c1.Status in (3,6,7) and
						c1.dt_servico >= ''' + @dt_ini + ''' and 
		                c1.dt_servico <= ''' + @dt_fim + ' 23:59''  and
						c1.cd_filial='+ CONVERT(varchar(10),@cod) +  ' and 
				        c1.cd_servico in (80000618, 80000140,80000144) and 
				        c1.cd_sequencial_agenda is null 
				  ), '

  End 		
  
  Set @lin = @lin + ' COUNT(0), 1 as TipoOperacao
	  from Consultas as c 
	 where c.Status in (3,6,7) and
		   c.dt_servico >= ''' + @dt_ini + ''' and 
		   c.dt_servico <= ''' + @dt_fim + ' 23:59'' and 
		   c.cd_servico in (80000618, 80000140,80000144) and 
		   c.cd_sequencial_agenda is null 
		   '


  Set @cd_filial = @cd_filialaux 
  
  --**********************************************************************

  Set @lin = @lin + ' 
            union 
            select 3 as SEQUENCIAL, ''ATEND REALIZADOS CONTAB'' AS RESUMO, '
  While @cd_filial <> ''
  Begin
     Set @pos = PATINDEX('%,%',@cd_filial)
     Set @cod = LEFT(@cd_filial,@pos-1)
     Set @cd_filial = substring(@cd_filial , @pos+1,LEN(@cd_filial)-@pos)
     Set @qtde = @qtde + 1 
     
       Set @lin = @lin + ' 
				(select COUNT(0) 
				   from Consultas as c1 , servico as s1
				  where c1.cd_servico = s1.cd_servico and 
	                    s1.fl_ContagemBaixaAgenda = 1 and 
				        c1.Status in (3,6,7) and
						c1.dt_servico >= ''' + @dt_ini + ''' and 
		                c1.dt_servico <= ''' + @dt_fim + ' 23:59''  and
						c1.cd_filial='+ CONVERT(varchar(10),@cod) +  ' and 
				        c1.cd_servico not in (80000618, 80000140,80000144)
				  ), '

  End 		
  
  Set @lin = @lin + ' COUNT(0), 1 as TipoOperacao
	  from Consultas as c , servico as s 
	 where c.cd_servico = s.cd_servico and 
	       s.fl_ContagemBaixaAgenda = 1 and 
	       c.Status in (3,6,7) and
		   c.dt_servico >= ''' + @dt_ini + ''' and 
		   c.dt_servico <= ''' + @dt_fim + ' 23:59'' and 
		   c.cd_servico not in (80000618, 80000140,80000144)
		   '

  Set @cd_filial = @cd_filialaux 
  
  --**********************************************************************

  Set @lin = @lin + '
      union 
      select 4 AS SEQUENCIAL, ''ATEND REALIZADOS NAO CONTAB'' AS RESUMO, '
  While @cd_filial <> ''
  Begin
     Set @pos = PATINDEX('%,%',@cd_filial)
     Set @cod = LEFT(@cd_filial,@pos-1)
     Set @cd_filial = substring(@cd_filial , @pos+1,LEN(@cd_filial)-@pos)
     Set @qtde = @qtde + 1 
     
       Set @lin = @lin + ' 
				(select COUNT(0) 
				   from Consultas as c1 , servico as s1
				  where c1.cd_servico = s1.cd_servico and 
	                    s1.fl_ContagemBaixaAgenda = 0 and 
				        c1.Status in (3,6,7) and
						c1.dt_servico >= ''' + @dt_ini + ''' and 
		                c1.dt_servico <= ''' + @dt_fim + ' 23:59''  and
						c1.cd_filial='+ CONVERT(varchar(10),@cod) +  ' and 
				        c1.cd_servico not in (80000618, 80000140,80000144)
				  ), '

  End 		
  
  Set @lin = @lin + ' COUNT(0), 1 as TipoOperacao
	  from Consultas as c , servico as s 
	 where c.cd_servico = s.cd_servico and 
	       s.fl_ContagemBaixaAgenda = 0 and 
	       c.Status in (3,6,7) and
		   c.dt_servico >= ''' + @dt_ini + ''' and 
		   c.dt_servico <= ''' + @dt_fim + ' 23:59'' and 
		   c.cd_servico not in (80000618, 80000140,80000144)
		   '


  Set @cd_filial = @cd_filialaux 
  
  --**********************************************************************

  Set @lin = @lin + '
      union 
      select 5 AS SEQUENCIAL, ''TEMPO CHEGOU ATRASO'' AS RESUMO, '
  While @cd_filial <> ''
  Begin
     Set @pos = PATINDEX('%,%',@cd_filial)
     Set @cod = LEFT(@cd_filial,@pos-1)
     Set @cd_filial = substring(@cd_filial , @pos+1,LEN(@cd_filial)-@pos)
     Set @qtde = @qtde + 1 
     
       Set @lin = @lin + ' 
				(select SUM(hr_chegou - hr_compromisso)   
				   from Agenda as c1 
				  where c1.dt_compromisso >= ''' + @dt_ini + ''' and 
		                c1.dt_compromisso <= ''' + @dt_fim + ' 23:59''  and
						c1.cd_filial='+ CONVERT(varchar(10),@cod) +  ' and 
				        hr_chegou is not null and 
		                hr_chegou > hr_compromisso 
				  ), '

  End 		
  
  Set @lin = @lin + ' SUM(hr_chegou - hr_compromisso), 2 as TipoOperacao
	  from Agenda as c 
	 where c.dt_compromisso >= ''' + @dt_ini + ''' and 
		   c.dt_compromisso <= ''' + @dt_fim + ' 23:59'' and 
		   hr_chegou is not null and 
		   hr_chegou > hr_compromisso 
		   '


  Set @cd_filial = @cd_filialaux 
  
  --**********************************************************************

  Set @lin = @lin + '
      union 
      select 6 AS SEQUENCIAL, ''QTDE CHEGOU ATRASADO'' AS RESUMO, '
  While @cd_filial <> ''
  Begin
     Set @pos = PATINDEX('%,%',@cd_filial)
     Set @cod = LEFT(@cd_filial,@pos-1)
     Set @cd_filial = substring(@cd_filial , @pos+1,LEN(@cd_filial)-@pos)
     Set @qtde = @qtde + 1 
     
       Set @lin = @lin + ' 
				(select Count(0)  
				   from Agenda as c1 
				  where c1.dt_compromisso >= ''' + @dt_ini + ''' and 
		                c1.dt_compromisso <= ''' + @dt_fim + ' 23:59''  and
						c1.cd_filial='+ CONVERT(varchar(10),@cod) +  ' and 
				        hr_chegou is not null and 
		                hr_chegou > hr_compromisso 
				  ), '

  End 		
  
  Set @lin = @lin + ' Count(0), 1 as TipoOperacao
	  from Agenda as c 
	 where c.dt_compromisso >= ''' + @dt_ini + ''' and 
		   c.dt_compromisso <= ''' + @dt_fim + ' 23:59'' and 
		   hr_chegou is not null and 
		   hr_chegou > hr_compromisso 
		   '

  Set @cd_filial = @cd_filialaux 
  
  --**********************************************************************

  Set @lin = @lin + '
      union 
      select 7 AS SEQUENCIAL, ''TEMPO ESPERA'' AS RESUMO, '
  While @cd_filial <> ''
  Begin
     Set @pos = PATINDEX('%,%',@cd_filial)
     Set @cod = LEFT(@cd_filial,@pos-1)
     Set @cd_filial = substring(@cd_filial , @pos+1,LEN(@cd_filial)-@pos)
     Set @qtde = @qtde + 1 
     
       Set @lin = @lin + ' 
				(select SUM(hr_entrou - hr_compromisso)  
				   from Agenda as c1 
				  where c1.dt_compromisso >= ''' + @dt_ini + ''' and 
		                c1.dt_compromisso <= ''' + @dt_fim + ' 23:59''  and
						c1.cd_filial='+ CONVERT(varchar(10),@cod) +  ' and 
				        hr_chegou is not null and 
	 				    hr_entrou is not null and 
					    hr_entrou > hr_compromisso and 
					    hr_compromisso >= hr_chegou  
				  ), '

  End 		
  
  Set @lin = @lin + ' SUM(hr_entrou - hr_compromisso), 2 as TipoOperacao
	  from Agenda as c 
	 where c.dt_compromisso >= ''' + @dt_ini + ''' and 
		   c.dt_compromisso <= ''' + @dt_fim + ' 23:59'' and 
           hr_chegou is not null and 
		   hr_entrou is not null and 
		   hr_entrou > hr_compromisso and 
		   hr_compromisso >= hr_chegou  
		   '

  Set @cd_filial = @cd_filialaux 
  
  --**********************************************************************

  Set @lin = @lin + '
      union 
      select 8 AS SEQUENCIAL, ''QTDE ATEND ESPERA'' AS RESUMO, '
  While @cd_filial <> ''
  Begin
     Set @pos = PATINDEX('%,%',@cd_filial)
     Set @cod = LEFT(@cd_filial,@pos-1)
     Set @cd_filial = substring(@cd_filial , @pos+1,LEN(@cd_filial)-@pos)
     Set @qtde = @qtde + 1 
     
       Set @lin = @lin + ' 
				(select COUNT(0) 
				   from Agenda as c1 
				  where c1.dt_compromisso >= ''' + @dt_ini + ''' and 
		                c1.dt_compromisso <= ''' + @dt_fim + ' 23:59''  and
						c1.cd_filial='+ CONVERT(varchar(10),@cod) +  ' and 
				        hr_chegou is not null and 
	 				    hr_entrou is not null and 
					    hr_entrou > hr_compromisso and 
					    hr_compromisso >= hr_chegou  
				  ), '

  End 		
  
  Set @lin = @lin + ' COUNT(0), 1 as TipoOperacao
	  from Agenda as c 
	 where c.dt_compromisso >= ''' + @dt_ini + ''' and 
		   c.dt_compromisso <= ''' + @dt_fim + ' 23:59'' and 
           hr_chegou is not null and 
		   hr_entrou is not null and 
		   hr_entrou > hr_compromisso and 
		   hr_compromisso >= hr_chegou  
		   '

  Set @lin = @lin + ' Order by 1 '       

  print @lin

  exec (@lin)
    
End
