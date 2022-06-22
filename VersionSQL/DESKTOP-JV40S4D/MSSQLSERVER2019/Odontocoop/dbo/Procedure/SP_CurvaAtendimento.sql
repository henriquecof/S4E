/****** Object:  Procedure [dbo].[SP_CurvaAtendimento]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_CurvaAtendimento] as 
Begin 
 delete S4Ebi..curva_atendimento 

 insert into S4Ebi..curva_atendimento (cd_filial)
  select cd_filial from filial -- where cd_filial in (5105,904,1154)

 -- declare @fil int
 declare @mm int
 declare @cd_fil int
 Declare @qtde int 
 declare @x varchar(1000)

 set @mm = 12

 -- Pendentes antes do inicio do periodo
 declare c_emp cursor for
 select c.cd_filial , count(0)
   from consultas as c, associados as a , dependentes as d 
  --where c.cd_servico not in (100,130,1188, 490,495,500,140,144,618) and 
  where c.cd_servico not in (81000065,80000130,1188, 80000490,80000495,80000500,80000140,80000144,618) and 
        --c.cd_funcionario != 11102407 and 
        --c.cd_filial != 657 and 
        c.dt_pericia <= dateadd(month, -1*@mm, getdate()) and 
        ( c.dt_servico is null or c.dt_servico>dateadd(month, -1*@mm, getdate()) ) and 
        c.dt_cancelamento is null and 
        -- c.cd_filial in (5105,904,1154) and  
        c.cd_funcionario is not null and 
        --c.cd_Associado = a.cd_Associado and 
        a.cd_associado = d.cd_Associado and 
        c.cd_sequencial_dep = d.cd_sequencial and 
        --a.cd_situacao in (select cd_situacao_historico from situacao_historico where fl_atendido_clinica=1) and 
        d.cd_situacao in (select cd_situacao_historico from situacao_historico where fl_atendido_clinica=1)
  group by c.cd_filial 
 open c_emp
 fetch next from c_emp into @cd_fil, @qtde
 while (@@fetch_status<>-1)
 begin

  Set @x = 'update  S4Ebi..curva_atendimento set qtde_inicial = ' + convert(varchar(10),@qtde) + ' where cd_filial = ' + convert(varchar(10),@cd_fil)
  exec (@x)

  fetch next from c_emp into @cd_fil, @qtde

 End
 Close c_emp
 Deallocate c_emp

 While @mm>0
 Begin

 print '-------------'
 print dateadd(month, -1*@mm, getdate())
 print dateadd(month, (-1*@mm)+1, getdate())
 print '-------------'

 -- Exames 
 declare c_emp cursor for
 select c.cd_filial , count(0)
   from consultas as c, associados as a , dependentes as d 
  where c.cd_servico  in (81000065,80000130) and 
        --c.cd_funcionario != 11102407 and 
        --c.cd_filial != 657 and 
        c.dt_pericia >= dateadd(month, -1*@mm, getdate()) and 
        c.dt_pericia <  dateadd(month, (-1*@mm)+1, getdate()) and 
        c.dt_cancelamento is null and 
        -- c.cd_filial in (5105,904,1154) and  
        c.cd_funcionario is not null and 
        --c.cd_Associado = a.cd_Associado and 
        a.cd_associado = d.cd_Associado and 
        c.cd_sequencial_dep = d.cd_sequencial --and 
        --a.cd_situacao in (select cd_situacao_historico from situacao_historico where fl_atendido_clinica=1) and 
        --d.cd_situacao in (select cd_situacao_historico from situacao_historico where fl_atendido_clinica=1)
   group by c.cd_filial
 open c_emp
 fetch next from c_emp into @cd_fil, @qtde
 while (@@fetch_status<>-1)
 begin

  Set @x = 'update  S4Ebi..curva_atendimento set exame_' +convert(varchar(2),@mm) + ' = ' + convert(varchar(10),@qtde) + ' where cd_filial = ' + convert(varchar(10),@cd_fil)
  exec (@x)

  fetch next from c_emp into @cd_fil, @qtde

 End
 Close c_emp
 Deallocate c_emp


 -- Encontrados no periodo 
 declare c_emp cursor for
  select c.cd_filial ,count(0)
   from consultas as c, associados as a , dependentes as d 
  --where c.cd_servico not in (100,130,1188, 490,495,500,140,144,618) and 
  where c.cd_servico not in (81000065,80000130,1188, 80000490,80000495,80000500,80000140,80000144,618) and  
        --c.cd_funcionario != 11102407 and 
        --c.cd_filial != 657 and 
        c.dt_pericia >= dateadd(month, -1*@mm, getdate()) and 
        c.dt_pericia <  dateadd(month, (-1*@mm)+1, getdate()) and 
        c.dt_cancelamento is null and 
        -- c.cd_filial in (5105,904,1154) and  
        c.cd_funcionario is not null and 
        --c.cd_Associado = a.cd_Associado and 
        a.cd_associado = d.cd_Associado and 
        c.cd_sequencial_dep = d.cd_sequencial --and  
        --c.cd_sequencial_Exame is not null  -- and 
        --a.cd_situacao in (select cd_situacao_historico from situacao_historico where fl_atendido_clinica=1) and 
        --d.cd_situacao in (select cd_situacao_historico from situacao_historico where fl_atendido_clinica=1)
  group by c.cd_filial 
 open c_emp
 fetch next from c_emp into @cd_fil, @qtde
 while (@@fetch_status<>-1)
 begin

  Set @x = 'update  S4Ebi..curva_atendimento set encontrado_' +convert(varchar(2),@mm) + ' = ' + convert(varchar(10),@qtde) + ' where cd_filial = ' + convert(varchar(10),@cd_fil)
  exec (@x)

  fetch next from c_emp into @cd_fil, @qtde

 End
 Close c_emp
 Deallocate c_emp

  -- Executado
 declare c_emp cursor for
 select c.cd_filial , count(0)
   from consultas as c, associados as a , dependentes as d 
  --where c.cd_servico not in (100,130,1188, 490,495,500,140,144,618) and 
  where c.cd_servico not in (81000065,80000130,1188, 80000490,80000495,80000500,80000140,80000144,618) and 
        --c.cd_funcionario != 11102407 and 
        --c.cd_filial != 657 and 
        c.dt_servico >= dateadd(month, -1*@mm, getdate()) and 
        c.dt_servico <  dateadd(month, (-1*@mm)+1, getdate()) and 
        c.dt_cancelamento is null and 
        -- c.cd_filial in (5105,904,1154) and  
        c.cd_funcionario is not null and 
        --c.cd_Associado = a.cd_Associado and 
        a.cd_associado = d.cd_Associado and 
        c.cd_sequencial_dep = d.cd_sequencial -- and  
        --c.cd_sequencial_Exame is not null  -- and 
        --a.cd_situacao in (select cd_situacao_historico from situacao_historico where fl_atendido_clinica=1) and 
        --d.cd_situacao in (select cd_situacao_historico from situacao_historico where fl_atendido_clinica=1)
   group by c.cd_filial 
 open c_emp
 fetch next from c_emp into @cd_fil, @qtde
 while (@@fetch_status<>-1)
 begin

  Set @x = 'update  S4Ebi..curva_atendimento set executado_' +convert(varchar(2),@mm) + ' = ' + convert(varchar(10),@qtde) + ' where cd_filial = ' + convert(varchar(10),@cd_fil)
  exec (@x)

  fetch next from c_emp into @cd_fil, @qtde

 End
 Close c_emp
 Deallocate c_emp

   set @mm = @mm - 1 
 End 

 -- Pendentes retirando os bloqueados para atendimento
 declare c_emp cursor for
 select c.cd_filial , count(0)
   from consultas as c, associados as a , dependentes as d 
  --where c.cd_servico not in (100,130,1188, 490,495,500,140,144,618) and 
  where c.cd_servico not in (81000065,80000130,1188, 80000490,80000495,80000500,80000140,80000144,618) and 
        --c.cd_funcionario != 11102407 and 
        --c.cd_filial != 657 and 
        c.dt_servico is null and 
        c.dt_cancelamento is null and 
        -- c.cd_filial in (5105,904,1154) and  
        c.cd_funcionario is not null and 
        --c.cd_Associado = a.cd_Associado and 
        a.cd_associado = d.cd_Associado and 
        c.cd_sequencial_dep = d.cd_sequencial and 
        --a.cd_situacao in (select cd_situacao_historico from situacao_historico where fl_atendido_clinica=1) and 
        d.cd_situacao in (select cd_situacao_historico from situacao_historico where fl_atendido_clinica=1)
  group by c.cd_filial 
 open c_emp
 fetch next from c_emp into @cd_fil, @qtde
 while (@@fetch_status<>-1)
 begin

  Set @x = 'update  S4Ebi..curva_atendimento set pendentes = ' + convert(varchar(10),@qtde) + ' where cd_filial = ' + convert(varchar(10),@cd_fil)
  exec (@x)

  fetch next from c_emp into @cd_fil, @qtde

 End
 Close c_emp
 Deallocate c_emp

 update S4Ebi..curva_atendimento
    set qtde_exame = exame_12+exame_11+exame_10+exame_9+exame_8+exame_7+exame_6+exame_5+exame_4+exame_3+exame_2+exame_1,
        qtde_executado = executado_12+executado_11+executado_10+executado_9+executado_8+executado_7+executado_6+executado_5+executado_4+executado_3+executado_2+executado_1,
        qtde_encontrado = encontrado_12+encontrado_11+encontrado_10+encontrado_9+encontrado_8+encontrado_7+encontrado_6+encontrado_5+encontrado_4+encontrado_3+encontrado_2+encontrado_1

  update S4Ebi..curva_atendimento
    set media = qtde_encontrado/(case when qtde_exame=0 then 1 else qtde_exame end)

  delete S4Ebi..curva_atendimento where media = 0 

End 
