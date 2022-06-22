/****** Object:  Procedure [dbo].[PS_TestaConsulta]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[PS_TestaConsulta]
As
Begin

   --update _Consultas 
   --   set CD_SEQUENCIAL = REPLACE(cd_sequencial,'.',''),
   --       CD_SEQUENCIAL_DEP = REPLACE(cd_sequencial_dep,'"',''),
   --       CD_FUNCIONARIO = REPLACE(cd_funcionario,'.',''),
   --       CD_FILIAL = REPLACE(CD_FILIAL ,'.',''),
   --       CD_SERVICO = REPLACE(cd_servico,'"',''),
   --       cd_ud =  REPLACE(cd_ud,'.',''),
   --       MOTIVO_CANCELAMENTO = case when MOTIVO_CANCELAMENTO = '""' then null else MOTIVO_CANCELAMENTO end , 
   --       VL_PAGO_PRODUTIVIDADE = case when VL_PAGO_PRODUTIVIDADE = '' then null else replace(REPLACE(VL_PAGO_PRODUTIVIDADE,'.',''),',','.') end,
   --       nr_numero_lote = case when nr_numero_lote = '' then null else 0 end 
          

     --Select case when dt_servico is null then null else convert(varchar(1000),substring(dt_servico,4,3)+LEFT(dt_servico,3)+RIGHT(dt_servico,4)) end  
     --From  _consultas as c
     --where dt_servico is not null and isdate(substring(dt_servico,4,3)+LEFT(dt_servico,3)+RIGHT(dt_servico,4))=0

   -- update _consultas set dt_servico = LEFT(dt_servico,6)+'20'+RIGHT(dt_servico,2) where dt_servico is not null and isdate(substring(dt_servico,4,3)+LEFT(dt_servico,3)+RIGHT(dt_servico,4))=0 and SUBSTRING(dt_servico,7,2)='00'

   --  Select case when dt_pericia is null then null else convert(varchar(1000),substring(dt_pericia,4,3)+LEFT(dt_pericia,3)+RIGHT(dt_pericia,4)) end
   --  From  _consultas as c
   --  where dt_pericia is not null and isdate(substring(dt_pericia,4,3)+LEFT(dt_pericia,3)+RIGHT(dt_pericia,4))=0

     --Select case when dt_baixa is null then null else convert(varchar(1000),substring(dt_baixa,4,3)+LEFT(dt_baixa,3)+RIGHT(dt_baixa,4)) end
     --From  _consultas as c
     --where dt_baixa is not null and isdate(substring(dt_baixa,4,3)+LEFT(dt_baixa,3)+RIGHT(dt_baixa,4))=0
     
   -- update _consultas set dt_baixa = LEFT(dt_baixa,6)+'20'+RIGHT(dt_baixa,2) where dt_baixa is not null and isdate(substring(dt_baixa,4,3)+LEFT(dt_baixa,3)+RIGHT(dt_baixa,4))=0 and SUBSTRING(dt_baixa,7,2)='00'

   --  Select case when dt_cancelamento is null then null else convert(varchar(1000),substring(dt_cancelamento,4,3)+LEFT(dt_cancelamento,3)+RIGHT(dt_cancelamento,4)) end
   --  From  _consultas as c
   --  where dt_cancelamento is not null and isdate(substring(dt_cancelamento,4,3)+LEFT(dt_cancelamento,3)+RIGHT(dt_cancelamento,4))=0




----------VARIAVEIS-----------------------------------------------------------------
Declare @cd int 
Declare @CD_Funcionario int
Declare @Linha int
Declare @cd_servico varchar(20)
Declare @dtservico varchar(10)
Declare @dtpericia varchar(10)
Declare @dtbaixa varchar(10)
Declare @dtcancelamento varchar(10)
Declare @vlpagoprodutividade money
Declare @status int
Declare @nrnumerolote int
Declare @dtcadastro varchar(10)
Declare @cdfilial int
Declare @cdservico varchar(10)
Declare @cdsequencial int

 Create Table #TB_Resultado
    (linha int Null,  
     erro varchar(4000) Null)     

 --update _Consultas 
 --   set DT_SERVICO = case when DT_SERVICO = '' then null else DT_SERVICO end,
 --       dt_pericia = case when dt_pericia = '' then null else dt_pericia end,
 --       dt_baixa = case when dt_baixa = '' then null else dt_baixa end,
 --       dt_cancelamento = case when dt_cancelamento = '' then null else dt_cancelamento end,
 --       MOTIVO_CANCELAMENTO = case when MOTIVO_CANCELAMENTO = '' then null else MOTIVO_CANCELAMENTO end


 -- update _Consultas 
 --    set status = 4 
 --  where DT_CANCELAMENTO is not null    


---------DADOS CONSULTA -----------------------------------------------------------
Declare cursor_dados Cursor For
Select CD_SEQUENCIAL, CD_SEQUENCIAL_DEP, isnull(codigo_colaborador,0), cd_servico, dt_servico,dt_pericia,dt_baixa,dt_cancelamento,
        isnull(vl_pago_produtividade,0), isnull(Status,0)
        , isnull(nr_numero_lote,0), dt_pericia, isnull(cd_filial,0), cd_servico
 From  _consultas as c, _DE_PARA_dentista_consultas as f
 where c.cd_funcionario = f.codigo_prestador 

   OPEN cursor_dados 
   FETCH NEXT FROM cursor_dados INTO @cd, @cdsequencial, @CD_Funcionario, @cd_servico,
        @dtservico,@dtpericia,@dtbaixa,@dtcancelamento,
        @vlpagoprodutividade, @status, @nrnumerolote, @dtcadastro, @cdfilial, @cdservico

   -- Inicio do Loop.
   WHILE (@@FETCH_STATUS <> -1)
   BEGIN

     Set @Linha = @cd 
   
     set @cdfilial = null 
     select top 1 @cdfilial = CD_filial 
       from atuacao_dentista 
      where CD_FUNCIONARIO=@CD_Funcionario  
     if  @cdfilial is null 
      Begin
        select @cdfilial = CD_filial 
          from FILIAL 
         where nm_filial = 'Clinica ' + (select nm_empregado from funcionario where cd_funcionario = @cd_funcionario)
      End
      
      set @cdfilial = case when @cdfilial IS null then 153 else @cdfilial end 
   
     --PRIMEIRO - Testa funcionario
     If (Select count(*) from funcionario where cd_funcionario = @CD_Funcionario) = 0 
      Begin
        insert into #TB_Resultado values 
        (@linha,'Dentista Não Existente :' + convert(varchar,@CD_Funcionario))          
      End

     --SEGUNDO - Testa servico
     If (Select count(*) from servico where cd_servico_antigo like '%,' + @CD_Servico + ',%') = 0 
      Begin
        insert into #TB_Resultado values 
        (@linha,'procedimento Não Existente :' + @cd_servico)          
      End

     --TERCEIRO - Filial
      If (Select count(*) from filial where cd_filial = @cdfilial) = 0 
         Begin
          insert into #TB_Resultado values 
          (@linha,'Filial Não Existente :' + convert(varchar,@cdfilial))          
         End

   If (Select count(*) from Consultas_Status where status = @status) = 0 
         Begin
          insert into #TB_Resultado values 
          (@linha,'Status Não Existente :' + convert(varchar,@status))          
         End

      --STATUS
       If @status = 1
         Begin
			  If @dtservico is not null            
				  Begin
					insert into #TB_Resultado values 
					(@linha,'Procedimento antes do plano não pode ter data de servico. STATUS = 1') 
				   End

			  If @nrnumerolote > 0            
				  Begin
					insert into #TB_Resultado values 
					(@linha,'Procedimento antes do plano não pode estar em lote de pagamento. STATUS = 1' )
				   End

               If @dtcancelamento is not null            
				  Begin
					insert into #TB_Resultado values 
					(@linha,'Procedimento antes do plano não pode ter data de cancelamento preenchida. STATUS = 1')
				   End
		 End

       If @status = 2
         Begin
			  If @dtservico is not null            
				  Begin
					insert into #TB_Resultado values 
					(@linha,'Procedimento pendente não pode ter data de servico. STATUS = 2' )
				   End

			  If @nrnumerolote  > 0            
				  Begin
					insert into #TB_Resultado values 
					(@linha,'Procedimento pendente não pode estar em lote de pagamento. STATUS = 2' )
				   End

			  If @dtcancelamento is not null            
				  Begin
					insert into #TB_Resultado values 
					(@linha,'Procedimento pendente não pode ter data de cancelamento preenchida. STATUS = 2' )
				   End
		 End

     If @status = 3
         Begin
			  If @dtservico is null            
				  Begin
					insert into #TB_Resultado values 
					(@linha,'Procedimento executado não pode ter data de servico NULO. STATUS = 3') 
				   End

			  If @dtcancelamento is not null         
				  Begin
					insert into #TB_Resultado values 
					(@linha,'Procedimento executado não pode ter data de cancelamento preenchida. STATUS = 3' )
				   End

		 End

     If @status = 4
         Begin
			  
			  If @dtcancelamento is null            
				  Begin
					insert into #TB_Resultado values 
					(@linha,'Procedimento cancelado deve ter data de cancelamento preenchida. STATUS = 4') 
				   End

		 End

     If @status = 5
         Begin

               If @nrnumerolote > 0             
				  Begin
					insert into #TB_Resultado values 
					(@linha,'Procedimento inconsistente com as regras não pode estar em lote de pagamento. STATUS = 5') 
				   End

			  If @dtcancelamento is not null            
				  Begin
					insert into #TB_Resultado values 
					(@linha,'Procedimento inconsistente não pode ter data de cancelamento preenchida. STATUS = 5') 
				   End
			  			  
		 End


     If @status = 6
         Begin

			  If @dtcancelamento is not null            
				  Begin
					insert into #TB_Resultado values 
					(@linha,'Procedimento liberado não pode ter data de cancelamento preenchida. STATUS = 6' )
				   End
			  			  
		 End
		 
     if @cdservico is null 
		  Begin
			insert into #TB_Resultado values 
			(@linha,'Codigo do servico esta NULO' )
		   End
		   
      If (Select COUNT(*) from SERVICO 
              where cd_servico_antigo like '%' + @cdservico + '%') = 0
          Begin
			insert into #TB_Resultado values 
			(@linha,'Codigo do servico não existe como codigo antigo na tabela de servicos' + @cdservico )
		   End
	
	 if @cdsequencial is null 
		  Begin
			insert into #TB_Resultado values 
			(@linha,'Sequencial Dep esta NULO' )
		   End
	
	  --If (Select COUNT(*) from DEPENDENTES  
   --           where CD_SEQUENCIAL  = @cdsequencial) = 0
   --       Begin
			--insert into #TB_Resultado values 
			--(@linha,'Sequencial Dep não existe na tabela de DEPENDENTES:' + CONVERT(varchar(20),@cdsequencial) )
		 --  End
		  		   

      -- Set @Linha = @Linha +1

   FETCH NEXT FROM cursor_dados INTO @cd, @cdsequencial,@CD_Funcionario, @cd_servico,
        @dtservico,@dtpericia,@dtbaixa,@dtcancelamento,
        @vlpagoprodutividade, @status, @nrnumerolote, @dtcadastro, @cdfilial, @cdservico

 END
 Close cursor_dados
 DEALLOCATE cursor_dados

 Select * from  #TB_Resultado

 Drop Table #TB_Resultado 

End
