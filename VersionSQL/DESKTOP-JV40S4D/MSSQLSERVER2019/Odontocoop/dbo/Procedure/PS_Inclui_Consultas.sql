/****** Object:  Procedure [dbo].[PS_Inclui_Consultas]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[PS_Inclui_Consultas]
  As
  Begin

   --update _Consultas 
   --   set CD_SEQUENCIAL = REPLACE(cd_sequencial,'.',''),
   --       CD_SEQUENCIAL_DEP = REPLACE(cd_sequencial_dep,'"',''),
   --       CD_FUNCIONARIO = REPLACE(cd_funcionario,'.',''),
   --       CD_SERVICO = REPLACE(cd_servico,'"',''),
   --       cd_ud =  REPLACE(cd_ud,'.',''),
   --       MOTIVO_CANCELAMENTO = case when MOTIVO_CANCELAMENTO = '""' then null else MOTIVO_CANCELAMENTO end , 
   --       VL_PAGO_PRODUTIVIDADE = replace(REPLACE(VL_PAGO_PRODUTIVIDADE,'.',''),',','.'),
   --       nr_numero_lote = case when VL_PAGO_PRODUTIVIDADE <> '0,00' then 0 else null end 
       
       
     Declare @cd int 
     Declare @cdsequencial int
     Declare @cdFUNCIONARIO int
     Declare @cdservico varchar(20)
     Declare @cdUD nvarchar(100)
     Declare @CD_FACES nvarchar(100)
     Declare @dtservico datetime
     Declare @dtpericia datetime
     Declare @dtbaixa datetime
     Declare @dtcancelamento datetime
     Declare @vlpagoprodutividade money
     Declare @Satus int
     Declare @nrnumerolote int
     Declare @dtcadastro datetime
     Declare @linha int
     Declare @Incluir smallint
     Declare @cdsequencialdep int
     Declare @oclusal smallint 
     Declare @distral smallint 
     Declare @mesial smallint
     Declare @vestibular smallint
     Declare @lingual  smallint
     Declare @Usuario_Baixa int
     Declare @Usuario_Cancelamento int
     Declare @nr_procedimentoliberado int
     Declare @Motivo_Cancelamento varchar(100)
     Declare @cdfilial int
     Declare @Status int
     Declare @cdservicoNOVO int
     Declare @linha1 int 
     
     DECLARE cursor_inclui CURSOR FOR  
     Select cd_sequencial, cd_sequencial_dep, isnull(codigo_colaborador,0), cd_servico , cd_UD,
         oclusal, distal, mesial, vestibular, lingual, 
         convert(datetime,substring(dt_servico,4,3)+LEFT(dt_servico,3)+RIGHT(dt_servico,4)), 
         convert(datetime,substring(dt_pericia,4,3)+LEFT(dt_pericia,3)+RIGHT(dt_pericia,4)),
         convert(datetime,substring(dt_baixa,4,3)+LEFT(dt_baixa,3)+RIGHT(dt_baixa,4)),
         convert(datetime,substring(dt_cancelamento,4,3)+LEFT(dt_cancelamento,3)+RIGHT(dt_cancelamento,4)),
         vl_pago_produtividade ,   0,
         Status,nr_numero_lote,
         convert(datetime,substring(dt_pericia,4,3)+LEFT(dt_pericia,3)+RIGHT(dt_pericia,4)), 
         cd_sequencial_dep
     From  _consultas as c, _DE_PARA_dentista_consultas as f
     where c.cd_funcionario = f.codigo_prestador and
           cd_sequencial not in (select cd_sequencial from consultas) and
           cd_sequencial_dep in (select cd_sequencial from dependentes) --and 
           --cdsequencial in (5320700,5231602,6009001,7042600)
  	 order by cd_sequencial 
	 OPEN cursor_inclui  
	 FETCH NEXT FROM cursor_inclui INTO @cd, 
	                                    @cdsequencial,
	                                    @cdFUNCIONARIO,
	                                    @cdservico,
	                                    @cdUD,
                                        @oclusal, @distral, @mesial, @vestibular, @lingual, 
                                        @dtservico , 
                                        @dtpericia, @dtbaixa, 
                                        @dtcancelamento ,
                                        @vlpagoprodutividade ,   @cdfilial, @Status, 
                                        @nrnumerolote, 
                                        @dtcadastro,
                                        @cdsequencialdep 

    set @linha1=1
	WHILE (@@FETCH_STATUS <> -1)  
	begin  -- Inicio Cursor
                     
          Set @Incluir = 1
            Set @linha = @cd
           
          set @cdfilial = null 
		  select top 1 @cdfilial = CD_filial 
		    from atuacao_dentista 
		   where CD_FUNCIONARIO=@CDFuncionario  
          if  @cdfilial is null 
          Begin
			select @cdfilial = CD_filial 
			  from FILIAL 
			 where nm_filial = 'Clinica ' + (select nm_empregado from funcionario where cd_funcionario = @cdfuncionario)
           End
      
          set @cdfilial = case when @cdfilial IS null then 153 else @cdfilial end   
            
		  if @cdservico is null 
			  Begin
				Select @linha,'Codigo do servico esta NULO' 
                Set @Incluir = 0
			   End
		   Else
		      Begin	   
		        Set @cdservicoNOVO = null 
		        
		        Select @cdservicoNOVO = Min(CD_Servico) from SERVICO 
				    where cd_servico_antigo like '%,' + CONVERT(varchar,@cdservico) + ',%'
	        
	       	    If 	@cdservicoNOVO is null and @cdservico<>'1'
					  Begin
						Select @linha,'Codigo do servico não existe como codigo antigo na tabela de servicos' + + CONVERT(varchar,@cdservico)
						Set @Incluir = 0 
	             	   End
	          End      	   

          If @cdud = 'ASAI'
             Set @cdud = null
          
          if @cdUD is not null 
          begin
            if @cdud not in (11,12,13,14,15,16,17,18,19,21,22,23,24,25,26,27,28,29,31,32,33,34,35,36,37,38,39,41,42,43,44,45,46,47,48,49,51,52,53,54,55,59,61,62,63,64,65,69,71,72,73,74,75,79,81,82,83,84,85,89)   
               Set @cdud = null 
          end 
          
          If @dtservico is null
             Set @Usuario_Baixa = null
          else
             Set @Usuario_Baixa = 7222

          If @dtcancelamento is null
             Begin 
                Set @Motivo_Cancelamento = null
                Set @Usuario_Cancelamento = null
             End
          else
             Begin
                Set @Usuario_Cancelamento = 7222
                Set @Motivo_Cancelamento = 'Procedimento Cancelado'
             End 

        If @vlpagoprodutividade is not null 
             Set @nr_procedimentoliberado = 1
           else
             Set @nr_procedimentoliberado = null

          If @Incluir = 1
          begin
             print @linha1
             

             insert into consultas (cd_sequencial, cd_sequencial_dep, cd_funcionario, cd_servico, cd_ud,
             oclusal, distral, mesial, vestibular, lingual,dt_servico,dt_pericia,
             dt_impressao_guia, dt_baixa, dt_cancelamento, motivo_cancelamento,
             usuario_cadastro, usuario_baixa, usuario_cancelamento, vl_pago_produtividade,
             qt_parcela, cd_filial, nr_autorizacao, cd_sequencial_agenda, fl_foto,
             Status, ds_informacao_complementar, ds_informacao_glosa,nr_numero_lote,
             nr_procedimentoliberado, cd_funcionario_analise, cd_sequencial_Exame,
             cd_sequencial_pericia)
              values (@cd, @cdsequencialdep,@cdFUNCIONARIO,@cdservicoNOVO,
             @cdud,@oclusal,@distral,@mesial,
             @vestibular,@lingual,@dtservico,
             @dtcadastro,null, @dtservico, @dtcancelamento,@Motivo_Cancelamento,41, @Usuario_Baixa,
             @Usuario_Cancelamento,@vlpagoprodutividade,0,@cdfilial, null, null, null,@Status, null, null, 
             @nrnumerolote,@nr_procedimentoliberado, null, null,null)


             --print ' insert into consultas (cd_sequencial, cd_sequencial_dep, cd_funcionario, cd_servico, cd_ud,
             --oclusal, distral, mesial, vestibular, lingual,dt_servico,dt_pericia,
             --dt_impressao_guia, dt_baixa, dt_cancelamento, motivo_cancelamento,
             --usuario_cadastro, usuario_baixa, usuario_cancelamento, vl_pago_produtividade,
             --qt_parcela, cd_filial, nr_autorizacao, cd_sequencial_agenda, fl_foto,
             --Status, ds_informacao_complementar, ds_informacao_glosa,nr_numero_lote,
             --nr_procedimentoliberado, cd_funcionario_analise, cd_sequencial_Exame,
             --cd_sequencial_pericia)'+ 
             --' values ('+convert(varchar(10),@cd)+', '+
             --convert(varchar(10),@cdsequencialdep)+', '+
             --convert(varchar(10),isnull(@cdFUNCIONARIO,''))+', '+
             --convert(varchar(10),@cdservicoNOVO)+','+
             --convert(varchar(10),isnull(@cdud,''))+','+
             --convert(varchar(10),@oclusal)+', '+
             --convert(varchar(10),@distral)+', '+
             --convert(varchar(10),@mesial)+', '+
             --convert(varchar(10),@vestibular)+', '+
             --convert(varchar(10),@lingual)+', '+
             --convert(varchar(100),isnull(@dtservico,''))+', '+
             --convert(varchar(100),isnull(@dtcadastro,''))+','+
             --'null, '+
             --convert(varchar(100),@dtservico)+', '
             
             --print ''+
             --convert(varchar(100),isnull(@dtcancelamento,''))+', '+
             --convert(varchar(1000),isnull(@Motivo_Cancelamento,''))+','+
             --'41, '+
             --convert(varchar(100),isnull(@Usuario_Baixa,''))+', '+
             --convert(varchar(100),isnull(@Usuario_Cancelamento,''))+', '+
             --convert(varchar(10),isnull(@vlpagoprodutividade,''))+','+
             --'0, '+
             --convert(varchar(10),@cdfilial)+', null, null, null,'+
             --convert(varchar(10),@Status)+', null, null, '+
             --convert(varchar(10),@nrnumerolote)+','+
             --convert(varchar(10),@nr_procedimentoliberado)+', null, null,null)'
            
           end 
                      
           Set @linha1 = @linha1 + 1   

           FETCH NEXT FROM cursor_inclui INTO @cd, @cdsequencial,@cdFUNCIONARIO,@cdservico,@cdUD,
                                        @oclusal, @distral, @mesial, @vestibular, @lingual,
                                        @dtservico, @dtpericia, @dtbaixa, 
                                        @dtcancelamento ,
                                        @vlpagoprodutividade ,   @cdfilial, @Status, 
                                        @nrnumerolote, 
                                        @dtcadastro, @cdsequencialdep

    end
    Close cursor_inclui
    DEALLOCATE cursor_inclui 


  
  End
  
  
