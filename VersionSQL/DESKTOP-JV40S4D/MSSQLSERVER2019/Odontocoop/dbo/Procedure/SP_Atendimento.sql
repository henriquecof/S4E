/****** Object:  Procedure [dbo].[SP_Atendimento]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_Atendimento] 
   @dt_ini varchar(10) , @dt_fim varchar(10), @cd_filial varchar(1000) = '' , @contabilizados smallint = 1 
as 
Begin

  -- Existe a Procedure SP_Atendimento_Sintetico
  -- Caso modifique essa acerta a outra

  if @cd_filial <> '' and RIGHT(@cd_filial,1)<>','
  begin
    return
  End 
  
  Declare @lin varchar(max) 
  Declare @qtde int = 3 
  Declare @cod varchar(10) 
  Declare @pos int 
  
  Set @lin = 'select c.cd_servico, s.nm_servico , '
  While @cd_filial <> ''
  Begin
     Set @pos = PATINDEX('%,%',@cd_filial)
     Set @cod = LEFT(@cd_filial,@pos-1)
     Set @cd_filial = substring(@cd_filial , @pos+1,LEN(@cd_filial)-@pos)
     Set @qtde = @qtde + 1 
     
       Set @lin = @lin + ' 
				(select COUNT(0) 
				   from Consultas as c1 
				  where c1.cd_servico = c.cd_servico and 
						c1.Status in (3,6,7) and
						c1.dt_servico >= ''' + @dt_ini + ''' and 
		                c1.dt_servico <= ''' + @dt_fim + ' 23:59''  and
		                c1.cd_servico not in (80000618, 80000140,80000144) and 
						c1.cd_filial='+ CONVERT(varchar(10),@cod) +  
				  'group by c1.cd_servico), '

  End 		
  
  Set @lin = @lin + ' COUNT(0) 
	  from Consultas as c, SERVICO as s
	 where c.cd_servico = s.cd_servico and 
	       s.fl_ContagemBaixaAgenda = ' + CONVERT(varchar(1),@contabilizados) + ' and 
		   c.Status in (3,6,7) and
		   c.dt_servico >= ''' + @dt_ini + ''' and 
		   c.dt_servico <= ''' + @dt_fim + ' 23:59'' and 
		   c.cd_servico not in (80000618, 80000140,80000144)
	group by c.cd_servico, s.nm_servico
	Order by ' + convert(varchar(10),@qtde) + ' desc , s.NM_SERVICO '       

print @lin

  exec (@lin)
    
End
