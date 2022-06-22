/****** Object:  Procedure [dbo].[SP_LerArquivoCadastro]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_LerArquivoCadastro] (@cd_usuario int)
as
Begin -- 1

   -- Primeira Linha
   -- Empresa;Carencia;Situacao;Data Adesao;Funcionario;Modelo;Vendedor/Adesionista  --- 198;0;1;1;

   --- Observar o Campo Recorrente (Ajustar Codigo)
   Declare @sequencial int 
   -----------------------------------------------------------
   -- Ambiente Programação
   -----------------------------------------------------------
   Set Quoted_Identifier Off
   Set Nocount On

   -----------------------------------------------------------
   -- Declaração de variaveis
   -----------------------------------------------------------
   Declare @Caminho varchar(200)
   Declare @Arquivo varchar (50)
   Declare @Min int
   Declare @Max int
   Declare @linha varchar(1000)
   Declare @linha_aux varchar(1000) 
   
   ----------------------------
   -- Importar_Contrato
   ----------------------------
   Declare @cd_empresa int
   declare @fl_carenciaAtendimento tinyint
   Declare @cd_situacao smallint
   Declare @dt_adesao date
   Declare @cd_vendedor int 
   Declare @modelo int 
   Declare @cd_adesionista int

   ------------------------------
   -- Importar_Contrato_Registros
   ------------------------------
   Declare @matricula varchar(30)
   Declare @cpf varchar(11)
   Declare @nome varchar(60)
   Declare @dt_nascimento varchar(20)
   Declare @nm_mae varchar(60)
   Declare @Rg varchar(20)
   Declare @cd_grau_parentesco varchar(2)
   Declare @sexo varchar(1)
   Declare @cep varchar(8)
   Declare @EndNumero varchar(20)
   Declare @EndComplemento varchar(100)
   Declare @telefone varchar(11)
   Declare @telefone_1 varchar(11)
   Declare @e_mail varchar(100)   
   Declare @cd_departamento int  
   Declare @cd_plano smallint 
   Declare @cns varchar(20)
   declare @nm_responsavel varchar(60)
   declare @cpf_responsavel varchar(11)
   declare @nr_carteira varchar(30)
   declare @dt_nasc_responsavel varchar(20)
   Declare @cd_ass_inf varchar(20)
   Declare @erro int = 0 
   
   --Declare @complemento varchar(200)
   Declare @obs varchar(200)

   Declare @qtde int = 0 
   Declare @qt int = 0 
   Declare @despreza int = 0 
  
   -----------------------------------------------------------
   -- Corpo de programa
   -----------------------------------------------------------
   --recebe o caminho que vai conter os arquivos H:\ foi substituido por \\dados\areas$
    Select top 1 @caminho = pasta_site from configuracao -- Verificar o caminho a ser gravado os arquivos
    IF @@ROWCOUNT = 0
    Begin -- 1.1
	  Raiserror('Pasta dos Arquivos não definida.',16,1)
	  RETURN
    End -- 1.1
  
    set @caminho = @caminho + '\arquivos\Cadastro'

   -- Criação da tabela que vai receber os
   -- nomes dos arquivos que vão ser lidos
   Create Table #tmp (out Varchar (1000))

   -- Formação do comando que será usado no DOS para listar os arquivos
   Set @linha = 'dir ' + @caminho + '\importacao\*.csv /b'

   -- Insere os arquivos dentro da tabela para usar depois
   Insert Into #tmp (out)   
   Exec xp_cmdshell @linha

   -- apaga registros que não tem arquivo 
   Delete From #tmp Where out is null

   -- Altera a tabela para colocar coluna com auto incremento, para controle
   Alter Table #tmp Add id Int Identity (1,1)

   --Delete from Import

   -- Configurações para repetição
   Select @min = min(id), @max = max(id) From #tmp 
   While @min <= @max
     Begin -- inicio 1 begin

		-- Passa por cada arquivo
		Select @arquivo = rtrim(ltrim(out)), @sequencial=0 from #tmp where id = @min

        print '*********'
        print @arquivo
        print '*********'
        
        -- 
        IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'import_C') AND type in (N'U'))
            DROP TABLE Import_C
        
        CREATE TABLE Import_C(linha varchar(5000) NULL) 

		--Bulk insert TB_TabelaCaixa From @arquivo
     	SET @linha = 'BULK INSERT Import_C FROM ''' + @Caminho + '\importacao\' + @arquivo + ''' WITH (KEEPIDENTITY) '
     	print @linha 
		Exec(@linha)

	  --============================================================================
	  -- Lendo registros do arquivo     
	  --============================================================================
      Declare  Dados_Cursor  cursor for  
	  Select replace(linha,'"','') from Import_C
      Open Dados_Cursor
      Fetch next from Dados_Cursor Into  @linha
      While (@@fetch_status  <> -1)
		Begin -- Inicio 2
        
          print @linha 
          Set @despreza = 0 
          
          if left(REPLACE(@linha,' ',''),14) = ';;;;;;;;;;;;;;'
             Set @despreza=1 
          if substring(@linha,1,16)<>'NOME DO TITULAR;' and @sequencial>0 and @despreza = 0 -- Registros
          Begin -- 2.2

             set @linha_aux = @linha
            
             Set @qtde = @qtde + 1 
             
             --if (SELECT (len(@linha) - len(REPLACE(@linha,';','')))/len(';'))<>14
             --    Set @obs = @obs + case when @obs<>'' then ', ' else '' end + 'Quantidade de separadores (;) diferente do esperado.'
                              
             if LEFT(dbo.SepararPalavra(';',17,@linha_aux),30)<>''
		        Set @matricula = LEFT(dbo.FF_RemoveLetra(dbo.SepararPalavra(';',17,@linha_aux)),30)
		     
		     Set @cd_grau_parentesco = dbo.FF_RemoveLetra(dbo.SepararPalavra(';',5,@linha_aux))
		     
		     Set @nome = LEFT(dbo.SepararPalavra(';',case when @cd_grau_parentesco='1' then 1 else 2 end,@linha_aux),60)
		     
		     Set @cpf = LEFT(dbo.FF_RemoveLetra(dbo.SepararPalavra(';',3,@linha_aux)),11)
		     Set @dt_nascimento = substring(dbo.SepararPalavra(';',4,@linha_aux),4,3)+left(dbo.SepararPalavra(';',4,@linha_aux),3)+Right(dbo.SepararPalavra(';',4,@linha_aux),4)
		     Set @nm_mae = LEFT(dbo.SepararPalavra(';',6,@linha_aux),60)
		     Set @cd_plano = dbo.FF_RemoveLetra(dbo.SepararPalavra(';',7,@linha_aux))
		     Set @sexo = LEFT(dbo.SepararPalavra(';',8,@linha_aux),1)
		     Set @Rg = LEFT(dbo.FF_RemoveLetra(dbo.SepararPalavra(';',9,@linha_aux)),20)
		     Set @cd_departamento = dbo.FF_RemoveLetra(dbo.SepararPalavra(';',10,@linha_aux))
		     Set @e_mail = LEFT(dbo.SepararPalavra(';',11,@linha_aux),100)
		     Set @telefone = LEFT(dbo.SepararPalavra(';',12,@linha_aux),11)
		     Set @telefone_1 = LEFT(dbo.SepararPalavra(';',13,@linha_aux),11)		     
		     		     
		     Set @cep = LEFT(dbo.SepararPalavra(';',14,@linha_aux),8)		     
		     Set @EndNumero = dbo.SepararPalavra(';',15,@linha_aux)
		     Set @EndComplemento = LEFT(dbo.SepararPalavra(';',16,@linha_aux),100)


		     Set @cns = LEFT(dbo.SepararPalavra(';',18,@linha_aux),50)
		     set @nr_carteira = LEFT(dbo.SepararPalavra(';',19,@linha_aux),30)
		     set @nm_responsavel = LEFT(dbo.SepararPalavra(';',20,@linha_aux),60)
		     set @cpf_responsavel = LEFT(dbo.SepararPalavra(';',21,@linha_aux),11)
		     Set @dt_nasc_responsavel = substring(dbo.SepararPalavra(';',22,@linha_aux),4,3)+left(dbo.SepararPalavra(';',22,@linha_aux),3)+Right(dbo.SepararPalavra(';',22,@linha_aux),4)
		     set @cd_ass_inf = LEFT(dbo.SepararPalavra(';',23,@linha_aux),20)
		     Set @obs = ''
            
             if @matricula = '' 
                 Set @obs = @obs + case when @obs<>'' then ', ' else '' end + 'Matricula não informada'
                 
             if @nome = '' 
                 Set @obs = @obs + case when @obs<>'' then ', ' else '' end + 'Nome não informado'
                 
             if @cd_grau_parentesco = '' 
                 Set @obs = @obs + case when @obs<>'' then ', ' else '' end + 'Grau de parentesco não informado'

             if @cd_plano = '' 
                 Set @obs = @obs + case when @obs<>'' then ', ' else '' end + 'Plano não informado'
                 
             --Select @qt = COUNT(0) from ASSOCIADOS where nu_matricula=@matricula and cd_empresa=@cd_empresa
             --if @qt>0
             --  Set @obs = case when @obs<>'' then ', ' end + 'Matricula existente na empresa'

             if @cd_grau_parentesco = '1' and @cpf =''
                 Set @obs = @obs + case when @obs<>'' then ', ' else '' end + 'Cpf não informado'

             if @sexo not in ('M','F')
                 Set @obs = @obs + case when @obs<>'' then ', ' else '' end + 'Sexo deve ser M ou F'
                 
             if @cns <> '' and len(@cns)<>15
                 Set @obs = @obs + case when @obs<>'' then ', ' else '' end + 'Cns com tamanho invalido'
                                                 
             if @cpf <> ''
             Begin
                 if len(@cpf)<9 
                    Set @obs = @obs + case when @obs<>'' then ', ' else '' end + 'Cpf menor que 9 caracteres'             
				 
				 Set @cpf = right('00000'+@cpf,11)
				 
				 if (select dbo.PS_CalculaDigito_CPF_CNPJ_PIS(LEFT(@cpf,9),2,12))<>RIGHT(@cpf,2)
				    Set @obs = @obs + case when @obs<>'' then ', ' else '' end + 'Digito do Cpf invalido'             
				     
				 	
				 Select @qt = COUNT(0) from DEPENDENTES	as d, ASSOCIADOS as a where d.nr_cpf_dep=@cpf and d.CD_ASSOCIADO = a.cd_associado and a.cd_empresa=@cd_empresa
				 if @qt>0
				   Set @obs = @obs + case when @obs<>'' then ', ' else '' end + 'Cpf existente na empresa'        

				 Set @qt = 0   
				 Select @qt = COUNT(0) from importar_contratos_Registros  where cpf=@cpf and cd_sequencial = @sequencial
				 if @qt>0
				   Set @obs = @obs + case when @obs<>'' then ', ' else '' end + 'Cpf duplicado no arquivo'      
				   				        
             End   
             
             if @cpf_responsavel <> ''
             Begin
                 if len(@cpf_responsavel)<9 
                    Set @obs = @obs + case when @obs<>'' then ', ' else '' end + 'Cpf menor que 9 caracteres'             
				 
				 Set @cpf_responsavel = right('00000'+@cpf_responsavel,11)
				 
				 if (select dbo.PS_CalculaDigito_CPF_CNPJ_PIS(LEFT(@cpf_responsavel,9),2,12))<>RIGHT(@cpf_responsavel,2)
				    Set @obs = @obs + case when @obs<>'' then ', ' else '' end + 'Digito do Cpf invalido'             
				 
				 if @nm_responsavel = ''
					Set @obs = @obs + case when @obs<>'' then ', ' else '' end + 'Nome do responsavel invalido'  
				 
				 	
				 --Select @qt = COUNT(0) from DEPENDENTES	as d, ASSOCIADOS as a where d.nr_cpf_dep=@cpf_responsavel and d.CD_ASSOCIADO = a.cd_associado and a.cd_empresa=@cd_empresa
				 --if @qt>0
				 --  Set @obs = @obs + case when @obs<>'' then ', ' else '' end + 'Cpf existente na empresa'        

				 Set @qt = 0   
				 Select @qt = COUNT(0) from importar_contratos_Registros  where cpf=@cpf_responsavel and cd_sequencial = @sequencial
				 if @qt>0
				   Set @obs = @obs + case when @obs<>'' then ', ' else '' end + 'Cpf duplicado no arquivo'      
             End  
             
              if @nm_responsavel = '' and @dt_nasc_responsavel <> ''
					Set @obs = @obs + case when @obs<>'' then ', ' else '' end + 'Nome do responsavel invalido'
             
             -- Verificar se o CEP existe na base 
             if @cep<>'' 
             begin
               Select @qt = COUNT(0) from TB_CEP where CEPLOG=@cep 
			   if @qt=0
			      Set @obs = @obs + case when @obs<>'' then ', ' else '' end + 'Cep não cadastrado'                     
             End
             
             -- Verificar se o Grau de parentesco existe
             if @cd_grau_parentesco <> '1'
             Begin
                Select @qt = COUNT(0) from GRAU_PARENTESCO where cd_grau_parentesco=@cd_grau_parentesco
		        if @qt=0
		           Set @obs = @obs + case when @obs<>'' then ', ' else '' end + 'Grau de parentesco não cadastrado'                   
		     End   
		     
		     if @cd_departamento<>''
		     Begin
				 Select @qt = COUNT(0) from Departamento_Empresa where depId=@cd_departamento and cd_empresa=@cd_empresa 
				 if @qt=0
					Set @obs = @obs + case when @obs<>'' then ', ' else '' end + 'Grupo de Faturamento não cadastrado na empresa'
		     End
		     
		     if @cd_plano <> ''
		     Begin
				 Select @qt = COUNT(0) from preco_plano where cd_empresa=@cd_empresa and cd_plano=@cd_plano and dt_fim_comercializacao is null 
				 if @qt=0
					Set @obs = @obs + case when @obs<>'' then ', ' else '' end + 'Plano não cadastrado na empresa'
				 if @qt>1
					Set @obs = @obs + case when @obs<>'' then ', ' else '' end + 'Plano cadastrado na empresa + de 1 vez.'

				 print 'plano'+ convert(varchar(10),@qt	)
				 print 'obs:'+@obs
		     End
		     		     
		     if @obs<>''
		     begin 
		        Set @erro=1
		        print 'Erro:'
		        print @obs
		     end          
		           
		     print 'Inicio'               
             print @sequencial
             print @qtde
             print @matricula
             print case when @cpf ='' then null else @cpf end
             print @nome
             print case when @dt_nascimento ='' then null else @dt_nascimento end
             print case when @nm_mae ='' then null else @nm_mae end
             print case when @Rg ='' then null else @Rg end
             print case when @cd_grau_parentesco ='' then null else @cd_grau_parentesco end
             print case when @sexo ='' then null else @sexo end
             print case when @cep ='' then null else @cep end
             print case when @EndNumero ='' then null else @EndNumero end
             print case when @EndComplemento ='' then null else @EndComplemento end
             print case when @telefone ='' then null else @telefone end
             print case when @e_mail ='' then null else @e_mail end
             print case when @cd_plano ='' then null else @cd_plano end
             print case when @cd_departamento ='' then null else @cd_departamento end
             print case when @cns ='' then null else @cns end
             print case when @cd_ass_inf ='' then null else @cd_ass_inf end
             print case when @obs ='' then null else @obs end		                    
             print @obs
		     print 'FIM'
		       
		       print 'Gravando Registro'              
             insert importar_contratos_Registros (cd_sequencial,linha,matricula, cpf,nome, dt_nascimento,nm_mae,rg,cd_grau_parentesco,sexo,cep,EndNumero,EndComplemento,telefone,e_mail,cd_plano,depId,obs,cns, nm_responsavel, cpf_responsavel, nr_carteira, dt_nasc_responsavel, cd_associado,telefone1)
             values (@sequencial, @qtde, case when @matricula='' then null else @matricula end,case when @cpf ='' then null else @cpf end, @nome,
				case when @dt_nascimento ='' then null else @dt_nascimento end,
                case when @nm_mae ='' then null else @nm_mae end,
                case when @Rg ='' then null else @Rg end,
                case when @cd_grau_parentesco ='' then null else @cd_grau_parentesco end,
                case when @sexo  ='' then null else @sexo end,
                case when @cep ='' then null else @cep end,
                case when @EndNumero ='' then null else @EndNumero end,
                case when @EndComplemento ='' then null else @EndComplemento end,
                case when @telefone ='' then null else @telefone end,
                case when @e_mail ='' then null else @e_mail end,
                case when @cd_plano ='' then null else @cd_plano end,
                case when isnull(@cd_departamento,0)=0 then null else @cd_departamento end,
                case when @obs ='' then null else @obs end,
                case when @cns ='' then null else @cns end,
                case when @nm_responsavel ='' then null else @nm_responsavel end,
                case when @cpf_responsavel ='' then null else @cpf_responsavel end,
                case when @nr_carteira ='' then null else @nr_carteira end,
				case when @dt_nasc_responsavel ='' then null else @dt_nasc_responsavel end,
                case when @cd_ass_inf ='' then null else @cd_ass_inf end,
                case when @telefone_1 ='' then null else @telefone_1 end
                )

                if @@ROWCOUNT = 0 
                begin -- 2.3.2
                   update Importar_Contratos set obs='Erro na leitura do Arquivo. Arquivo não lido ou lido parcial. Importação não realizada.' where cd_sequencial = @sequencial
                end -- 2.3.2   
                
          End      
         
          if substring(@linha,1,16)<>'NOME DO TITULAR;' and @sequencial = 0 and @despreza = 0 -- Linha Inicial 
          begin 
             Set @cd_empresa = dbo.SepararPalavra(';',1,@linha)
             Set @fl_carenciaAtendimento = dbo.SepararPalavra(';',2,@linha)
             Set @cd_situacao = dbo.SepararPalavra(';',3,@linha)
             Set @dt_adesao = substring(convert(varchar(10),dbo.SepararPalavra(';',4,@linha)),4,2)+'/'+substring(convert(varchar(10),dbo.SepararPalavra(';',4,@linha)),1,2)+'/'+substring(convert(varchar(10),dbo.SepararPalavra(';',4,@linha)),7,4)
             
             Set @cd_vendedor = dbo.SepararPalavra(';',5,@linha)
             if @cd_vendedor=0 
             Begin
                Select @cd_vendedor = cd_func_vendedor from EMPRESA where CD_EMPRESA=@cd_empresa
             End 
             
             Set @modelo = dbo.SepararPalavra(';',6,@linha)
             Set @cd_adesionista = dbo.SepararPalavra(';',7,@linha)
            
             insert importar_contratos (cd_empresa,fl_carenciaAtendimento,cd_situacao,nm_arquivo,dt_importacao , cd_usuario,dt_adesao,cd_vendedor,cd_adesionista)
             values (@cd_empresa,@fl_carenciaAtendimento,@cd_situacao,@arquivo, getdate(),@cd_usuario, @dt_adesao,@cd_vendedor, case when isnull(@cd_adesionista,0)=0 then NULL else @cd_adesionista end)
            
			IF @@ROWCOUNT = 0
			Begin -- 1.1
			  Close Dados_Cursor
			  Deallocate Dados_Cursor			  
			  Raiserror('Erro na sequencial do lote. Importação não realizada.',16,1)
			  RETURN
			End -- 1.1
			
		    SELECT @sequencial = @@IDENTITY   -- Pega o Lote Gerado
		    if @sequencial is null 
			begin
			  Close Dados_Cursor
			  Deallocate Dados_Cursor			  
			  Raiserror('Erro na sequencial do lote. Importação não realizada.',16,1)
			  RETURN
		    End

          end
          
		  --- Proximo registro
		  Fetch next from Dados_Cursor Into  @linha

		End --Fim 2
 
      Close Dados_Cursor
      Deallocate Dados_Cursor
      
      if @erro>0 
      Begin
          update Importar_Contratos set obs='Erro no arquivo. Importação não realizada.' where cd_sequencial = @sequencial      
      End

     -- Critica Arquivo Processado
      if @erro = 0 
      Begin -- 3
      
          declare @lote_contrato int 
          Declare @cd_Associado int 
          Declare @cd_sequencial_dep int 
          declare @cd_equipe int -- Incluida
                
          Begin Transaction

          Select @cd_equipe = f.cd_equipe -- Incluida
            from Importar_Contratos as c inner join funcionario as f on c.cd_vendedor = f.cd_funcionario 
           where c.cd_sequencial=@sequencial
                     
          ---- Criar o Lote_Contratos          
          insert lote_contratos (cd_sequencial, dt_cadastro,cd_usuario_cadastro,cd_equipe) -- Incluida
          select isnull(MAX(cd_sequencial)+1,1), GETDATE(), @cd_usuario,@cd_equipe
            from lote_contratos 
            
          if @@ROWCOUNT = 0 
          begin
             rollback
             update Importar_Contratos set obs='Erro na criação do lote_contratos. Importação não realizada.' where cd_sequencial = @sequencial                     
             return             
          End   
          
          Select @lote_contrato = max(cd_sequencial) from lote_contratos where dt_finalizado is null and cd_usuario_cadastro = @cd_usuario -- Incluida
          
		  Declare Dados_Cursor_RB  cursor for  
		   select linha,cd_grau_parentesco
             from importar_contratos_registros
            where cd_sequencial=@sequencial
  		  Open Dados_Cursor_RB
		  Fetch next from Dados_Cursor_RB Into @qtde, @cd_grau_parentesco 
		  While (@@fetch_status  <> -1)
			Begin -- 3.1

              if @cd_grau_parentesco=1 -- Incluir Associado  
              begin 
                               
                 insert ASSOCIADOS (nm_completo,cd_empresa,dt_nascimento,nr_cpf,nr_identidade,dt_assinatura_contrato,dt_cadastro,
                    dt_atualizacao,LogCep,CHAVE_TIPOLOGRADOURO,EndLogradouro,EndNumero,EndComplemento,BaiId,CidID,ufId,fl_sexo,depId,nu_matricula)
                  
                  select case when i.nm_responsavel is not null then i.nm_responsavel else i.nome end, @cd_empresa, case when i.dt_nasc_responsavel IS not null then i.dt_nasc_responsavel else i.dt_nascimento end, case when i.cpf_responsavel is not null then i.cpf_responsavel else i.cpf end, i.rg, convert(varchar(10),GETDATE(),101), convert(varchar(10),GETDATE(),101), 
                    convert(varchar(10),GETDATE(),101), i.cep, c.CHAVE_TIPOLOGRADOURO,c.LOGRADOURO,i.EndNumero,i.EndComplemento,c.cd_bairro,c.CD_MUNICIPIO, 
                    (select top 1 u.ufId from UF as u where u.ufSigla =c.CD_UF) ,
                    case when i.sexo='M' then 1 else 0 end,i.depId, matricula
                   from Importar_Contratos_Registros as i left join TB_CEP as c on i.cep = c.CEPLOG 
                  where i.cd_sequencial = @sequencial and i.linha =@qtde 

                 if @@ROWCOUNT=0
                 Begin 
					 rollback
					 close Dados_Cursor_RB
					 deallocate Dados_Cursor_RB 
					 update Importar_Contratos set obs='Erro na inclusao do associado linha ('+ CONVERT(varchar(10),@qtde) +'). Importação não realizada.' where cd_sequencial = @sequencial                     
					 return                         
                 End 
                 
                 select @cd_Associado = @@IDENTITY 
                 update ASSOCIADOS set nr_contrato = @cd_Associado where cd_associado=@cd_Associado
                 
                 Print 'Associado:' + convert(varchar(10),@cd_Associado)
                 
              End 
              
             -- Set @cd_Associado = null 
			 select @cd_Associado = case when cd_associado IS null or @cd_grau_parentesco=1 then @cd_Associado else cd_associado end from Importar_Contratos_Registros where cd_sequencial = @sequencial  and linha =@qtde 
			  
			  -- Incluir Dependente
			  insert DEPENDENTES (CD_ASSOCIADO,NM_DEPENDENTE,dt_assinaturaContrato,CD_GRAU_PARENTESCO,DT_NASCIMENTO,fl_sexo,
			     mm_aaaa_1pagamento,cd_plano,vl_plano,cd_funcionario_vendedor,nr_cpf_dep,nm_mae_dep,cd_situacao,fl_BiometricoObrigatorio,
			     fl_CarenciaAtendimento,cd_tipo_rede_atendimento,nr_contrato,cd_funcionario_adesionista, nr_cns, nr_carteira)
                  
                  select --case when @cd_grau_parentesco=1 then convert(int,convert(varchar(10),@cd_associado)+'00') else (select MAX(cd_sequencial)+1 from DEPENDENTES where CD_ASSOCIADO=@cd_Associado) end ,
                    @cd_Associado, nome, CONVERT(varchar(10),@dt_adesao,101), @cd_grau_parentesco, i.dt_nascimento, 
                    case when i.sexo='M' then 1 else 0 end, 
                    CONVERT(varchar(6),@dt_adesao,112), i.cd_plano, 
                    case when @cd_grau_parentesco=1 then p.Vl_tit else p.Vl_dep end,
                    c.cd_vendedor, i.cpf, i.nm_mae, c.cd_situacao,1,c.fl_carenciaAtendimento,1, @cd_Associado, c.cd_adesionista, i.cns, i.nr_carteira
                    from Importar_Contratos_Registros as i, Importar_Contratos as c , EMPRESA as e, preco_plano as p 
                   where i.cd_sequencial = @sequencial and i.linha =@qtde and 
                         i.cd_sequencial = c.cd_sequencial and 
                         c.cd_empresa = e.CD_EMPRESA and
                         e.CD_EMPRESA =	p.cd_empresa and i.cd_plano = p.cd_plano and p.dt_fim_comercializacao is null 	  

                 if @@ROWCOUNT=0
                 Begin 
					 rollback
					 close Dados_Cursor_RB
					 deallocate Dados_Cursor_RB 					 
					 update Importar_Contratos set obs='Erro na inclusao do dependente linha ('+ CONVERT(varchar(10),@qtde) +'). Importação não realizada.' where cd_sequencial = @sequencial                     
					 return                         
                 End 

                 Select @cd_sequencial_dep= MAX(cd_sequencial) from DEPENDENTES where CD_ASSOCIADO = @cd_Associado                                 
                 
                 update Importar_Contratos_Registros set cd_sequencial_dep = @cd_sequencial_dep where cd_sequencial = @sequencial  and linha=@qtde                  
                 if @@ROWCOUNT=0
                 Begin 
					 rollback
					 close Dados_Cursor_RB
					 deallocate Dados_Cursor_RB 					 
					 update Importar_Contratos set obs='Erro na inclusao do dependente linha ('+ CONVERT(varchar(10),@qtde) +'). Importação não realizada.' where cd_sequencial = @sequencial                     
					 return                         
                 End                  
                 
			     -- Incluir Contatos                  
                 insert TB_Contato (cd_origeminformacao,cd_sequencial,tteSequencial,tusTelefone,tusDtCadastro,fl_ativo,tusDtAtualizacao,tusQuantidade)
                 select case when @cd_grau_parentesco=1 then 1 else 5 end ,
                        case when @cd_grau_parentesco=1 then @cd_Associado else @cd_sequencial_dep end , 
                        1, i.telefone , CONVERT(varchar(10),getdate(),101) ,1, CONVERT(varchar(10),getdate(),101),1
                   from Importar_Contratos_Registros as i
                  where i.cd_sequencial = @sequencial and i.linha =@qtde and i.telefone is not null             

                 insert TB_Contato (cd_origeminformacao,cd_sequencial,tteSequencial,tusTelefone,tusDtCadastro,fl_ativo,tusDtAtualizacao,tusQuantidade)
                 select case when @cd_grau_parentesco=1 then 1 else 5 end ,
                        case when @cd_grau_parentesco=1 then @cd_Associado else @cd_sequencial_dep end , 
                        1, i.telefone1 , CONVERT(varchar(10),getdate(),101) ,1, CONVERT(varchar(10),getdate(),101),1
                   from Importar_Contratos_Registros as i
                  where i.cd_sequencial = @sequencial and i.linha =@qtde and i.telefone1 is not null             
                  
                 insert TB_Contato (cd_origeminformacao,cd_sequencial,tteSequencial,tusTelefone,tusDtCadastro,fl_ativo,tusDtAtualizacao,tusQuantidade)
                 select case when @cd_grau_parentesco=1 then 1 else 5 end ,
                        case when @cd_grau_parentesco=1 then @cd_Associado else @cd_sequencial_dep end , 
                        50, i.e_mail , CONVERT(varchar(10),getdate(),101) ,1, CONVERT(varchar(10),getdate(),101),1
                   from Importar_Contratos_Registros as i
                  where i.cd_sequencial = @sequencial and i.linha =@qtde  and i.e_mail is not null  

				  ---- Criar o Lote_Contratos_Vendedor
				  if @cd_situacao=1
				  Begin
				    insert lote_contratos_contratos_vendedor (cd_sequencial_lote,cd_contrato,cd_sequencial_dep,
				       vl_contrato,dt_cadastro,dt_assinaturaContrato)
				    select @lote_contrato, convert(varchar(30),@cd_Associado) , @cd_sequencial_dep, vl_plano,  CONVERT(varchar(10),getdate(),101), CONVERT(varchar(10),getdate(),101)
				      from DEPENDENTES 
				     where CD_SEQUENCIAL = @cd_sequencial_dep
				     
					 if @@ROWCOUNT=0
					 Begin 
						 rollback
						 close Dados_Cursor_RB
						 deallocate Dados_Cursor_RB 						 
						 update Importar_Contratos set obs='Erro na inclusao do lote contrato vendedor linha ('+ CONVERT(varchar(10),@qtde) +'). Importação não realizada.' where cd_sequencial = @sequencial                     
						 return                         
					 End 				     
					 
				  End   
			  
               Fetch next from Dados_Cursor_RB Into @qtde, @cd_grau_parentesco 
            End -- 3.1  
            Close Dados_Cursor_RB
            Deallocate Dados_Cursor_RB
            
            Commit    
            update Importar_Contratos 
               set obs='Importação realizada com sucesso.' , 
                   qt_registros = (select COUNT(0) from Importar_Contratos_Registros where cd_sequencial= @sequencial)
             where cd_sequencial = @sequencial                     
           
      End -- 3
 
      -- Movendo arquivos lidos para outro local
      Set @linha = 'move /y "' + @caminho + '\importacao\'+@arquivo+'" "' + @caminho + '\importacao_processados\'+@arquivo+'"'
      EXEC SP_Shell @linha , 0 

      -- incrementa variável de controle para passar para o próximo arquivo
      Set @min = @min + 1
      
     End -- fim 1

     -- drop da tabela temporária usada
     Drop table #tmp
   
              
End --1
