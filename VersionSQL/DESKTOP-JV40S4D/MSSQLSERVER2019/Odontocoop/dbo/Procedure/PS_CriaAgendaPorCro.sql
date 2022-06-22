/****** Object:  Procedure [dbo].[PS_CriaAgendaPorCro]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PS_CriaAgendaPorCro] 
@cro integer, @QuantidadeDiasGeracao integer = 180
AS
/*
	Ticket 8308: Alterado o limite para chamar a trigger para melhorar a performance da geração de agendas na ortoestética
*/
Begin -- Inicio

SET NoCount ON;

declare @tempDt_compromisso datetime
declare @executarTrigger int = 1
declare @dt_inicio datetime 
declare @dt_fim datetime 
Declare @HI integer
Declare @HF integer
Declare @hi_i integer
Declare @hi_e integer
Declare @cd_funcionario integer
Declare @cd_empresa int
Declare @qt_tempo_atend integer
declare @dia_semana integer
declare @dia_semana_1 integer
declare @dia_semana_2 integer
declare @dia_semana_3 integer
declare @dia_semana_4 integer
declare @dia_semana_5 integer
declare @dia_semana_6 integer
declare @dia_semana_7 integer
declare @cd_sequencial int 
declare @i int 
Declare @especialidade int 
Declare @qt_encaixe smallint 
Declare @qt_tempo_atend_encaixe smallint 
Declare @qt_encaixe_dia smallint 
Declare @motivo varchar(50) 

CREATE Table #TBAgenda  (hora INT NOT NULL,motivo varCHAR(60) )  

/* colocar como fl_ativo=0 quem ja passou a dt_fim */
print '1'
update atuacao_dentista set
fl_ativo = 0
where convert(date,dateadd(day,7,dt_fim)) < convert(date,getdate())
and fl_ativo = 1 

/* colocar como fl_ativo=0 quem está cancelado */
print '2'
update atuacao_dentista set
fl_ativo = 0
where (select count(0) from funcionario where cd_funcionario = atuacao_dentista.cd_funcionario and cd_situacao != 1) > 0
and fl_ativo = 1

/* colocar como fl_ativo=1 quem ainda nao alcancou dt_fim */
print '3'
update atuacao_dentista set
fl_ativo = 1 
where convert(date,dt_fim) >= convert(date,getdate())
and (select count(0) from funcionario where cd_funcionario = atuacao_dentista.cd_funcionario and cd_situacao = 1) > 0
and isnull(fl_ativo,0) = 0

-- Excluir agenda de atuação inativa ou dentista inativo ou clínica inativa
print '4'
delete agenda
where (select count(0) from atuacao_dentista where cd_sequencial = agenda.cd_sequencial_atuacao_dent and fl_ativo = 0) > 0
and convert(date,dt_compromisso) >= convert(date,getdate())
and cd_associado is null
and cd_sequencial_dep is null
and nm_anotacao is null

delete agenda
where (select count(0) from funcionario where cd_funcionario = agenda.cd_funcionario and cd_situacao != 1) > 0
and convert(date,dt_compromisso) >= convert(date,getdate())
and cd_associado is null
and cd_sequencial_dep is null
and nm_anotacao is null

delete agenda
where (select count(0) from filial where cd_filial = agenda.cd_filial and fl_ativa != 1) > 0
and convert(date,dt_compromisso) >= convert(date,getdate())
and cd_associado is null
and cd_sequencial_dep is null
and nm_anotacao is null

--Excluir agendas nao marcadas passadas
if (@cro=0)
	begin
		Declare @s int 
		while 1=1
		begin
			select @s = MAX(cd_sequencial) from (select top 10000 cd_sequencial from agenda where cd_associado is null and cd_sequencial_dep is null and nm_anotacao is null and dt_compromisso < convert(date,dateadd(month,-2,getdate())) order by cd_sequencial) as x
			delete agenda where cd_sequencial <= @s and cd_associado is null and cd_sequencial_dep is null and nm_anotacao is null and dt_compromisso < convert(date,dateadd(month,-2,getdate()))
		  
		  if @@ROWCOUNT=0
			 break 
		end	
	end

if (@cro=0)
	DECLARE cursor_agenda CURSOR FOR
	Select atuacao_dentista_new.cd_filial, atuacao_dentista_new.cd_funcionario, qt_tempo_atend as intervalo, 
			 left(convert(varchar(5),HI,108),2)*60 + right(convert(varchar(5),HI,108),2) as HI, 
			 left(convert(varchar(5),HF,108),2)*60 + right(convert(varchar(5),HF,108),2) as HF, Dt_inicio , 
			 dia_semana_1,dia_semana_2,dia_semana_3,dia_semana_4,dia_semana_5,dia_semana_6,dia_semana_7, 
			 cd_sequencial, isnull(dt_fim,'12/31/2049') as dt_fim, cd_especialidade, isnull(qt_encaixe,0) , isnull(qt_tempo_atend_encaixe,0)
	FROM atuacao_dentista as atuacao_dentista_new, filial, funcionario
	WHERE (convert(date,dt_fim) >= convert(date,getdate()) or dt_fim is null)
	AND atuacao_dentista_new.cd_filial = filial.cd_filial
	AND atuacao_dentista_new.cd_funcionario = funcionario.cd_funcionario
	AND filial.fl_ativa = 1
	AND funcionario.cd_situacao = 1
	and qt_tempo_atend > 0
	and atuacao_dentista_new.fl_ativo = 1
	and filial.cd_tipo_baixa_agenda in (1,3)
else
	DECLARE cursor_agenda CURSOR FOR
	Select atuacao_dentista_new.cd_filial, atuacao_dentista_new.cd_funcionario, qt_tempo_atend as intervalo, 
			 left(convert(varchar(5),HI,108),2)*60 + right(convert(varchar(5),HI,108),2) as HI, 
			 left(convert(varchar(5),HF,108),2)*60 + right(convert(varchar(5),HF,108),2) as HF, Dt_inicio , 
			 dia_semana_1,dia_semana_2,dia_semana_3,dia_semana_4,dia_semana_5,dia_semana_6,dia_semana_7, 
			 cd_sequencial, isnull(dt_fim,'12/31/2049') as dt_fim, cd_especialidade, isnull(qt_encaixe,0), isnull(qt_tempo_atend_encaixe,0)
	FROM atuacao_dentista as atuacao_dentista_new , filial, funcionario
	WHERE (convert(date,dt_fim) >= convert(date,getdate()) or dt_fim is null)
	AND atuacao_dentista_new.cd_filial = filial.cd_filial
	AND atuacao_dentista_new.cd_funcionario = funcionario.cd_funcionario
	AND filial.fl_ativa = 1
	AND funcionario.cd_situacao = 1
	and atuacao_dentista_new.cd_funcionario = @cro
	and qt_tempo_atend > 0
	and atuacao_dentista_new.fl_ativo = 1
	and filial.cd_tipo_baixa_agenda in (1,3)

OPEN cursor_agenda
FETCH NEXT FROM cursor_agenda INTO @cd_empresa, @cd_funcionario, @qt_tempo_atend, @HI, @HF, @dt_inicio,
      @dia_semana_1,@dia_semana_2,@dia_semana_3,@dia_semana_4,@dia_semana_5,@dia_semana_6,@dia_semana_7, @cd_sequencial, @dt_fim,@especialidade, @qt_encaixe, @qt_tempo_atend_encaixe
While (@@fetch_status<>-1)
Begin --1.0

      --print ''
      --print '********************'
      --print 'Dentista:' + convert(varchar(10),@cd_funcionario) + ' Atuação: ' + convert(varchar(10),@cd_sequencial)
      
      select @i=-1 
      While @i <= @QuantidadeDiasGeracao
      Begin -- 2.0

        set @i=@i+1

        select @dia_semana =
         (select case   when datePart(dw, dateadd(day, @i, getdate()))=1 and @dia_semana_1 = 1 then 1
                        when datePart(dw, dateadd(day, @i, getdate()))=2 and @dia_semana_2 = 1 then 1 
						when datePart(dw, dateadd(day, @i, getdate()))=3 and @dia_semana_3 = 1 then 1
						when datePart(dw, dateadd(day, @i, getdate()))=4 and @dia_semana_4 = 1 then 1
						when datePart(dw, dateadd(day, @i, getdate()))=5 and @dia_semana_5 = 1 then 1
						when datePart(dw, dateadd(day, @i, getdate()))=6 and @dia_semana_6 = 1 then 1
						when datePart(dw, dateadd(day, @i, getdate()))=7 and @dia_semana_7 = 1 then 1
						else 0 end)
        
        if dateadd(day, @i, convert(varchar(10),getdate(),101)) >= @dt_inicio and 
           dateadd(day, @i, convert(varchar(10),getdate(),101)) <= @dt_fim and 
           @dia_semana = 1 
        Begin -- 2.1
			set @tempDt_compromisso = dateadd(day, @i, convert(varchar(10),getdate(),101))
			
			set @executarTrigger = 1
			if datediff(day ,getdate(),@tempDt_compromisso) > 3
			   set @executarTrigger = 0
			
			set @hi_i = @hi 
            
            -- Hora Inicial do encaixe
            set @hi_e= @hi_i+10
            delete #TBAgenda            

			while (@hi_i<@hf)
			Begin -- 2.4

			   insert #TBAgenda (hora) values (@hi_i) 

   			   select @hi_i = @hi_i + @qt_tempo_atend

			 End -- 2.4

            --print @qt_tempo_atend_encaixe
            set @qt_encaixe_dia = @qt_encaixe
            
			while (@hi_e<@hf) and (@qt_encaixe_dia>0) and (@qt_tempo_atend_encaixe>0)
			Begin -- 2.4

			    insert #TBAgenda (hora) values (@hi_e) 

				select @hi_e = @hi_e + @qt_tempo_atend_encaixe , @qt_encaixe_dia=@qt_encaixe_dia-1
			 End -- 2.4

			 -- incluir motivos 
			 update A 
			    set motivo = case when cd_funcionario_substituicao is null then f.motivo else 'Substituicao' end 
			   from #TBAgenda as A , falta_substituicao_dentista as f
			  where cd_filial = @cd_empresa 
			    and dt_exclusao is null 
				and (cd_funcionario = @cd_funcionario or cd_funcionario is null) 
				and convert(date,dt_compromisso) >= convert(date,dateadd(day, @i, getdate())) 
				and convert(date,dt_compromisso) < convert(date,dateadd(day, @i+1, getdate())) 
				and A.hora >= dbo.InverteHora (convert(varchar(5),HI,114)) 
				and a.hora <= dbo.InverteHora (convert(varchar(5),HF,114)) 

			 -- incluir motivos 
			 update A 
			    set motivo = FerDescricao 
			   from #TBAgenda as A , crmferiado as f, filial as fi
			  where fi.cd_filial = @cd_empresa 
			    and fi.CidID = isnull(f.CD_MUNICIPIO, fi.CidID)
				and convert(date,f.ferdata) = convert(date,@tempDt_compromisso)  
				and A.hora >= f.ferHorarioInicial
				and a.hora <= f.ferHorarioFinal
				and a.motivo is null 

				--select @tempDt_compromisso, @cd_empresa, @cd_funcionario, * from #TBAgenda
				
				INSERT INTO agenda (dt_compromisso, hr_compromisso, cd_funcionario, cd_filial, cd_tipo_horario, cd_sequencial_atuacao_dent,nm_anotacao, executarTrigger) 
				select @tempDt_compromisso, a.hora, @cd_funcionario, @cd_empresa,1,@cd_sequencial,a.motivo ,@executarTrigger
				  from #TBAgenda as a
                 where a.hora not in 
				    (
					   select hr_compromisso
					     from agenda 
						where dt_compromisso = @tempDt_compromisso
						  and cd_funcionario = @cd_funcionario
						  and cd_filial = @cd_empresa
					)
                 

					--print '-------------------'
					--print @cd_sequencial
					--print @tempDt_compromisso
					--print '-------------------' 


        End -- 2.1 

      End -- 2.0

   FETCH NEXT FROM cursor_agenda INTO @cd_empresa, @cd_funcionario, @qt_tempo_atend, @HI, @HF, @dt_inicio,
      @dia_semana_1,@dia_semana_2,@dia_semana_3,@dia_semana_4,@dia_semana_5,@dia_semana_6,@dia_semana_7, @cd_sequencial, @dt_fim,@especialidade, @qt_encaixe, @qt_tempo_atend_encaixe

End -- 1.0
CLOSE cursor_agenda
DEALLOCATE cursor_agenda

End -- Inicio 
