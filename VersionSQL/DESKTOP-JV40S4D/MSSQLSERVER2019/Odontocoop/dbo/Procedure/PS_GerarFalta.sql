/****** Object:  Procedure [dbo].[PS_GerarFalta]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[PS_GerarFalta](
       @Dentista Int,
       @Clinica Int,
       @DataFalta SmallDateTime,
       @TipoFalta Int,
       @HrInicial Int,
       @HrFinal Int,
       @UsuarioIdentificado Int,
       @Operacao Int
)
As
Begin
	--Operacao >> 1: Sem procedimento baixado, 2: Não chegou, 3: Não entrou

	Declare @cd_sequencial_agenda Int
	Declare @cd_sequencial_dep Int
	Declare @cd_servico Int
	Declare @cd_servicoTEMP Int
	Declare @qtde Int
	Declare @SQL varchar(max)

	If @TipoFalta = 1
		Set @cd_servico = 80000140 --Falta do paciente
	Else
		Set @cd_servico = 80000144 --Falta do dentista

    Set @SQL = ''
    Set @SQL += ' Declare Dados_Cursor cursor for '
    Set @SQL += ' select T1.cd_sequencial, T1.cd_sequencial_dep '
    Set @SQL += ' from agenda T1 '
    Set @SQL += ' where (select count(0) from consultas where cd_sequencial_agenda = T1.cd_sequencial and cd_sequencial_dep = T1.cd_sequencial_dep and dt_cancelamento is null) = 0 '
    Set @SQL += ' and T1.dt_compromisso between ''' + convert(varchar(10),@DataFalta,101) + ' 00:00'' And ''' + convert(varchar(10),@DataFalta,101) + ' 23:59'' '
    Set @SQL += ' and T1.cd_funcionario = ' + convert(varchar,@Dentista)
    Set @SQL += ' and T1.cd_filial = ' + convert(varchar,@Clinica)
    Set @SQL += ' and T1.cd_associado is not null '
    Set @SQL += ' and year(dt_compromisso) >= 2019 '
    Set @SQL += ' and T1.hr_compromisso >= ' + convert(varchar,@hrInicial)
    Set @SQL += ' and T1.hr_compromisso <= ' + convert(varchar,@hrFinal)
    
    if (@Operacao = 2)
		Set @SQL += ' and T1.hr_chegou is null '

    if (@Operacao = 3)
		Set @SQL += ' and T1.hr_entrou is null '
    
    Set @SQL += ' Open Dados_Cursor '

	Execute(@SQL)
    
	Fetch next from Dados_Cursor into @cd_sequencial_agenda, @cd_sequencial_dep

		While (@@fetch_status  <> -1)
			Begin
				set @cd_servicoTEMP = @cd_servico
			
				If (@TipoFalta = 1)
					begin
						select @qtde = count(0)
						from agenda T1
						inner join consultas T2 on T1.cd_sequencial = T2.cd_sequencial_agenda
						where T1.dt_compromisso between @DataFalta + ' 00:00' and @DataFalta + ' 23:59'
						and T1.cd_sequencial_dep = T2.cd_sequencial_dep
						and T1.cd_funcionario = @Dentista
						and T1.cd_filial = @Clinica
						and T1.cd_sequencial_dep = @cd_sequencial_dep
						and T2.dt_cancelamento is null
						and T2.cd_servico in (80000140, 80000618)
						
						if (@qtde > 0)
							begin
								set @cd_servicoTEMP = 80000618
							end
						else
							begin
								select @qtde = count(0)
								from agenda T1
								inner join consultas T2 on T1.cd_sequencial = T2.cd_sequencial_agenda
								where T1.dt_compromisso between @DataFalta + ' 00:00' and @DataFalta + ' 23:59'
								and T1.cd_sequencial_dep = T2.cd_sequencial_dep
								and T1.cd_funcionario = @Dentista
								and T1.cd_filial = @Clinica
								and T1.cd_sequencial_dep = @cd_sequencial_dep
								and T2.dt_cancelamento is null
								
								if (@qtde > 0)
									begin
										set @cd_servicoTEMP = 80000617
									end
							end
					end
			
				insert into consultas
				(cd_sequencial, cd_sequencial_dep, dt_servico, dt_pericia, cd_servico, dt_baixa, cd_funcionario, cd_filial, cd_sequencial_agenda, status, usuario_cadastro, usuario_baixa, oclusal, distral, mesial, vestibular, lingual, nr_procedimentoliberado)
				select isnull(max(cd_sequencial), 0) + 1, @cd_sequencial_dep, @DataFalta, getdate(), @cd_servicoTEMP, getdate(), @Dentista, @Clinica, @cd_sequencial_agenda, 6, @UsuarioIdentificado, @UsuarioIdentificado, 0, 0, 0, 0, 0, 1
				from consultas

				Fetch next from Dados_Cursor into @cd_sequencial_agenda, @cd_sequencial_dep
			End

	Close Dados_Cursor
	Deallocate Dados_Cursor
End
