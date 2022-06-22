/****** Object:  Procedure [dbo].[PS_CriaLotesPagamentoDentistaTeste]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE procedure [dbo].[PS_CriaLotesPagamentoDentistaTeste] (@cro int)
As
Begin

  
---------Declaração de variaveis.  ----------------------------------------------------------------------
	Declare @Data_Atual DateTime  
	Declare @CD_Funcionario Int  
	Declare @CD_Empresa Int  
	Declare @CD_Sequencial Int  
	Declare @Valor_Teto Money  
	Declare @Valor_Procedimento Money  
	Declare @Valor_Total_Pagar Money  
	Declare @CD_Pagamento_Dentista Int  
	Declare @Quantidade_Procedimento Int  
	Declare @Aviso_Numero_Procedimentos Int  
	Declare @NM_Funcionario varchar(80)  
	Declare @NM_Filial varchar(80)  
	Declare @CriarLote int  
	Declare @CD_Tabela int  
	Declare @Data varchar(10)  
	Declare @cd_clinica int  
	Declare @Data_Corte_Final varchar(10)  
    Declare @Dia_Corte int	 

	Set @Data_Atual = getdate()  

    ----Buscar datas de corte do dentista-----------------------------------------
    Select @Dia_Corte = dia_corte 
        From  funcionario
        Where cro = @CRO

    Set @Data_Corte_final = convert(varchar,month(@Data_Atual)) + '/' + convert(varchar,@dia_corte) + '/' +  convert(varchar,year(@Data_Atual))

	--Pegar todos os dentistas que tem dia de corte nesse dia.  
	--Cada credenciado têm um valor maximo de teto que deve ser pago no mês.  
	Declare Dados_Cursor Cursor For  
		Select T1.CD_Funcionario, T1.CD_Filial, T4.NM_Filial, T2.NM_Empregado,  
			min(t2.CD_TABELA) as CD_Tabela,  
			min(T3.VL_Faixa) as Valor_Teto  
	    From Atuacao_Dentista T1, Funcionario T2,  
   		     Funcionario_Faixa T3, Filial T4  
	    Where T1.CD_Funcionario = T2.CD_Funcionario And  
      		  T2.CD_Faixa = T3.CD_Faixa And  
			  --T2.CD_Situacao = 1 And  
			  T2.CRO = 5235 And  
			  T1.CD_Filial = T4.CD_Filial  
   	    Group by T1.CD_Funcionario, T1.CD_Filial, T4.NM_Filial, T2.NM_Empregado  
	    Order By T1.CD_Funcionario  
 
	Open Dados_Cursor  
	Fetch next from Dados_Cursor  
	Into @CD_Funcionario, @CD_Empresa, @NM_Filial, @NM_Funcionario,  
		 @CD_Tabela, @Valor_Teto
 
	/*Iniciando loop dos dentistas*/  
	Set @Aviso_Numero_Procedimentos = 0  
 
 
	While (@@fetch_status <> -1)  
  	  Begin  
	 
		Set @CD_Pagamento_Dentista = Null  
		Set @Valor_Total_Pagar = 0  
		Set @Quantidade_Procedimento = 0  
		Set @CriarLote = 0  
		 
		Select t1.cd_sequencial, t3.vl_servico  
			From consultas t1, tabela_servicos T3  
			Where 
                  t3.cd_tabela    = @CD_Tabela And
                  T1.cd_servico   = T3.CD_Servico And
			  	  T1.DT_Servico <= GETDATE() and  
				  T1.DT_Servico Is Not null And
                  T1.Status in (3,6)  And
				  T1.CD_Filial = @CD_Empresa And  
				  T1.nr_numero_lote is null And  
				  T1.nr_procedimentoliberado = 1 And  
				  T3.vl_servico > 0 And  
				  T1.cd_funcionario = @CD_Funcionario And
                  T1.CD_Sequencial_Dep not in (
                     Select t10.cd_sequencial 
                     From  dependentes  t10, ASSOCIADOS t20, EMPRESA t30
                     Where t10.cd_associado = t20.cd_associado And
                           t20.cd_empresa = t30.CD_EMPRESA and
                           t30.TP_EMPRESA = 10) And				  
				  T1.CD_SERVICO Not in (Select cd_servico from Servico where tp_procedimento=3) And  
				  T1.cd_sequencial Not in (Select cd_sequencial from tb_consultasdocumentacao t100 where t1.cd_sequencial = t100.cd_sequencial and t100.foto_digitalizada = 0) And 
				  T1.cd_sequencial Not in (select cd_sequencial_pp from orcamento_servico t100 where t1.cd_sequencial = t100.cd_sequencial_pp) and  
				  T1.cd_sequencial Not In (Select cd_sequencial From TB_ConsultasGlosados t100 Where t100.cd_sequencial = t1.cd_sequencial)  
	  	   Union all 
		/*troca de procedimento*/  
  	   Select t1.cd_sequencial, t3.vl_servico  
		From consultas t1,   
		     tabela_servicos T3, TB_ConsultasGlosados t4  
	 Where 
              t3.cd_tabela    = @CD_Tabela And
              T1.cd_servico   = T3.CD_Servico And
		  	  T1.DT_Servico <= GETDATE() and  
			  T1.DT_Servico Is Not null And
              T1.Status in (3,6)  And
			  T1.CD_Filial = @CD_Empresa And  
			  T1.nr_numero_lote is null And  
			  T1.nr_procedimentoliberado = 1 And  
			  T3.vl_servico > 0 And  
			  T1.cd_funcionario = @CD_Funcionario And
			  T1.CD_Sequencial_Dep not in (
                     Select t10.cd_sequencial 
                     From  dependentes  t10, ASSOCIADOS t20, EMPRESA t30
                     Where t10.cd_associado = t20.cd_associado And
                           t20.cd_empresa = t30.CD_EMPRESA and
                           t30.TP_EMPRESA = 10) And				  
 		      T1.cd_sequencial Not in (Select cd_sequencial from tb_consultasdocumentacao t100 where t1.cd_sequencial = t100.cd_sequencial and t100.foto_digitalizada = 0) And   
			  T1.cd_sequencial not in (select cd_sequencial_pp from orcamento_servico t100 where t1.cd_sequencial = t100.cd_sequencial_pp) and  
	          T1.cd_sequencial = t4.cd_sequencial and
              T4.tipo = 1
     	Union all  
		/*glosa total*/  
	  Select t1.cd_sequencial, 0  
		From consultas t1,   
		     tabela_servicos T3, TB_ConsultasGlosados t4  
	    Where 
              t3.cd_tabela    = @CD_Tabela And
              T1.cd_servico   = T3.CD_Servico And
		  	  T1.DT_Servico <= GETDATE() and  
			  T1.DT_Servico Is Not null And
              T1.Status in (3,6)  And 
			  T1.CD_Filial = @CD_Empresa And  
			  T1.nr_numero_lote is null And  
			  T1.nr_procedimentoliberado = 1 And  
			  T3.vl_servico > 0 And  
			  T1.cd_funcionario = @CD_Funcionario And 
			  T1.cd_sequencial Not in (Select cd_sequencial from tb_consultasdocumentacao t100 where t1.cd_sequencial = t100.cd_sequencial and t100.foto_digitalizada = 0) And  
			  T1.cd_sequencial not in (select cd_sequencial_pp from orcamento_servico t100 where t1.cd_sequencial = t100.cd_sequencial_pp) and  
	          T1.cd_sequencial = t4.cd_sequencial and
              T4.tipo = 2
       Union All
      /*glosa total - procedimentos glosados no processo de liberação das regras*/  
	  Select t1.cd_sequencial, 0  
		From consultas t1 
	    Where 
              T1.DT_Servico <= GETDATE() and  
			  T1.DT_Servico Is Not null And
              T1.Status = 7  And 
			  T1.CD_Filial = @CD_Empresa And  
			  T1.nr_numero_lote is null And  
			  T1.nr_procedimentoliberado = 1 And  
			  T1.cd_funcionario = @CD_Funcionario 	
     

     --Proximo  clinica.  
    Fetch next from Dados_Cursor  
	Into @CD_Funcionario, @CD_Empresa, @NM_Filial, @NM_Funcionario,  
		 @CD_Tabela, @Valor_Teto
   End  
   Close Dados_Cursor  
   Deallocate Dados_Cursor  


End
