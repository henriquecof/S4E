/****** Object:  Procedure [dbo].[PS_SMS]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PS_SMS]
AS
Begin
	SET NOCOUNT ON;

	----Declarando variáveis
	Declare @ListaSMS smallint = 1
	Declare @proPortaSaida int = 8
        
	----Declarando variáveis do select
	Declare @WL_Protocolo int
	Declare @Titulo varchar(100)
	Declare @WL_CodigoAssociado int
	Declare @WL_Telefone varchar(13)
	Declare @WL_Mensagem varchar(300)
	Declare @SQL varchar(max)
		
	Declare @qtde_maxlote int = 890 -- Qtde maxima de registros por Lote
	Declare @contador int = 0 -- Qtde de Registros dentro do lote. Serve para calcular a qtde maxima enviada por cada chip
	Declare @Automatico smallint = 1 -- Se o lote inicia sozinho
        
	While @ListaSMS <= 4
		Begin -- 1
        
			print @ListaSMS
			Set @WL_Protocolo = 0
           
			if @ListaSMS = 1 -- CONFIRMAÇÃO DE CONSULTA (AGENDA DE AMANHÃ)
				begin -- 1.1
					Set @Titulo = 'CONFIRMAÇÃO DE CONSULTA (AGENDA DE AMANHÃ)'
					DECLARE cursor_SMS CURSOR FOR
					select distinct T2.cd_associado, T4.tusTelefone,
					T2.nm_dependente + ', confirmamos a sua consulta amanha, dia ' + convert(varchar(10),T1.dt_compromisso,103) + ' as ' + dbo.ConvHora(T1.hr_compromisso) + ' na clinica ' + T5.nm_filial + '. Aguardamos voce!'
					from Agenda T1, Dependentes T2, Associados T3, tb_contato T4, Filial T5, Funcionario T6
					where T1.cd_sequencial_dep = T2.cd_sequencial
					and T2.cd_associado = T3.cd_associado
					and T2.cd_sequencial = T4.cd_sequencial
					and T1.cd_filial = T5.cd_filial
					and T1.cd_funcionario = T6.cd_funcionario
					and T4.tteSequencial < 50 -- Telefone
					and LEN(T4.tustelefone) = 10
					and SUBSTRING(T4.tustelefone,3,1) > 7 -- Celular
					and T4.cd_origeminformacao = 5 -- Dependente
					and T4.fl_ativo = 1
					and T1.dt_compromisso = convert(varchar(10),dateadd(day,1,getdate()),101)
					order by T2.cd_associado
				End -- 1.1
			
			if @ListaSMS = 2 -- SMS - 5 A 89 DIAS DE ATRASO PF
				begin -- 1.2
					Set @Titulo = 'SMS - 5 A 89 DIAS DE ATRASO PF'
					DECLARE cursor_SMS CURSOR FOR
					select distinct T3.cd_associado, T4.tusTelefone,
					T1.Nome_Prospect + ', '
					from CampanhaLoteItens T1, CampanhaLote T2, Dependentes T3, tb_contato T4
					where T1.cd_campanha = T2.cd_campanha
					and T1.ID_ERP_CRM = T3.cd_associado
					and T3.cd_sequencial = T4.cd_sequencial
					and T2.cd_campanha = 4
					and T2.dt_inicio = convert(varchar(10),getdate(),101)
					and T2.dt_fim = convert(varchar(10),getdate(),101)
					and T3.cd_grau_parentesco = 1
					and T4.tteSequencial < 50 -- Telefone
					and LEN(T4.tustelefone) = 10
					and SUBSTRING(T4.tustelefone,3,1) > 7 -- Celular
					and T4.cd_origeminformacao = 5 -- Dependente
					and T4.fl_ativo = 1
					order by T3.cd_associado
				End -- 1.2

			if @ListaSMS = 3 -- SMS - 90 DIAS DE ATRASO PF
				begin -- 1.2
					Set @Titulo = 'SMS - 90 DIAS DE ATRASO PF'
					DECLARE cursor_SMS CURSOR FOR
					select distinct T3.cd_associado, T4.tusTelefone,
					T1.Nome_Prospect + ', '
					from CampanhaLoteItens T1, CampanhaLote T2, Dependentes T3, tb_contato T4
					where T1.cd_campanha = T2.cd_campanha
					and T1.ID_ERP_CRM = T3.cd_associado
					and T3.cd_sequencial = T4.cd_sequencial
					and T2.cd_campanha = 5
					and T2.dt_inicio = convert(varchar(10),getdate(),101)
					and T2.dt_fim = convert(varchar(10),getdate(),101)
					and T3.cd_grau_parentesco = 1
					and T4.tteSequencial < 50 -- Telefone
					and LEN(T4.tustelefone) = 10
					and SUBSTRING(T4.tustelefone,3,1) > 7 -- Celular
					and T4.cd_origeminformacao = 5 -- Dependente
					and T4.fl_ativo = 1
					order by T3.cd_associado
				End -- 1.2 

			if @ListaSMS = 4 -- SMS - SPC PF
				begin -- 1.2
					Set @Titulo = 'SMS - SPC PF'
					DECLARE cursor_SMS CURSOR FOR
					select distinct T3.cd_associado, T4.tusTelefone,
					T1.Nome_Prospect + ', '
					from CampanhaLoteItens T1, CampanhaLote T2, Dependentes T3, tb_contato T4
					where T1.cd_campanha = T2.cd_campanha
					and T1.ID_ERP_CRM = T3.cd_associado
					and T3.cd_sequencial = T4.cd_sequencial
					and T2.cd_campanha = 6
					and T2.dt_inicio = convert(varchar(10),getdate(),101)
					and T2.dt_fim = convert(varchar(10),getdate(),101)
					and T3.cd_grau_parentesco = 1
					and T4.tteSequencial < 50 -- Telefone
					and LEN(T4.tustelefone) = 10
					and SUBSTRING(T4.tustelefone,3,1) > 7 -- Celular
					and T4.cd_origeminformacao = 5 -- Dependente
					and T4.fl_ativo = 1
					order by T3.cd_associado
				End -- 1.2
			OPEN cursor_SMS
			FETCH NEXT FROM cursor_SMS INTO @WL_CodigoAssociado, @WL_Telefone, @WL_Mensagem
			WHILE (@@FETCH_STATUS <> -1)  
				begin  -- Inicio Cursor
		      
					if @WL_Protocolo = 0
						Begin -- Protocolo
		        
		        
		        
							--insert into [192.168.254.2].SMS.dbo.Protocolo
							--(proQtLote, proAssunto, proDtCadastro, usiIdCadastro, proDtAgendamentoInicio, proDtAgendamentoFim, 
							--proHrAgendamentoInicio, proHrAgendamentoFim, proPortaSaida, proQtContadorParcial, tspId, BaudRate, DataBits, StopBits, proChave)
							--values(@qtde_maxlote, @Titulo + CONVERT(varchar(10),getdate(),112), getdate(), 1, case when @Automatico=1 then convert(varchar(10),getdate(),101) else null end, case when @Automatico=1 then convert(varchar(10),getdate(),101) else null end, 
							--480, 1320, @proPortaSaida, 0, 2, 115200, 8, '1', 'Dental Gold - AUTOMATICO')

							--select @WL_Protocolo = max(proId)
							--from [192.168.254.2].SMS.dbo.Protocolo
							--where proChave = 'Dental Gold - AUTOMATICO'

							set @ListaSMS = @ListaSMS 
				
						End -- Protocolo		   
              
						--insert into [192.168.254.2].SMS.dbo.Mensagem (proId, menNumero, menMensagem, menDtCadastro, tsmId)
						--values (@WL_Protocolo, @WL_Telefone, @WL_Mensagem, getdate(), 1)
   		      
						Set @contador = @contador + 1
						
						if @contador >= @qtde_maxlote
							Begin
								Select @contador=0 , @WL_Protocolo=0 , @Automatico = 0 
								
								
								
								
							End
							
				
				FETCH NEXT FROM cursor_SMS INTO @WL_CodigoAssociado, @WL_Telefone, @WL_Mensagem
			End -- Fim Cursor
			Close cursor_SMS
			Deallocate cursor_SMS

			Set @ListaSMS = @ListaSMS + 1 -- Proximo Select 
		End -- 1
End
