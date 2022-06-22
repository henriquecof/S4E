/****** Object:  Procedure [dbo].[PS_GeraCarne]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PS_GeraCarne] 
	-- Add the parameters for the stored procedure here
	@cd_tipopagamento smallint, 
	@INcd_parcela varchar(max),
	@cd_funcionario int
AS
BEGIN
	Declare @sequencial int
	select @sequencial= isnull(min(cd_sequencial_lote),0) -1 from Boleto
	
	Declare @cd_tiposervico smallint  
    Declare @nm_tipopagamento varchar(10) 
    Declare @cd_banco int 
    Declare @convenio varchar(10)
    Declare @convenio_dv char(1)
    Declare @cedente varchar(300)
    Declare @nm_banco varchar(100)
    Declare @nsa int 
    Declare @dt_finalizado datetime 
    Declare @nr_cnpj char(14)
    Declare @tp_ag varchar(10)
    Declare @tp_ag_dv char(1)
    Declare @cta varchar(20)
    Declare @dv_cta varchar(1)
    Declare @carteira int 
    Declare @juros int 
    Declare @multa int 
    Declare @taxa money 
    Declare @qt_diasminimo int 
    Declare @dt_ref datetime 
    Declare @nome varchar(100)
    Declare @endereco varchar(100)
    Declare @bairro varchar(100)
    Declare @cep varchar(8)
    Declare @cidade varchar(50)
    Declare @uf varchar(2)
    Declare @parc_atual int 
    Declare @parc_total int 
    Declare @val_cartao varchar(6)
    Declare @cd_seguranca int 
    Declare @cd_bandeira smallint 

    Declare @codbarras varchar(440)
    Declare @CampoLivre varchar(25)
    Declare @linhaDig1 varchar(54)  
    Declare @linhaDig2 varchar(54)  
    Declare @linhaDig3 varchar(54)  
    Declare @linhaDig4 varchar(54)  
    Declare @linhaDig5 varchar(54)        
     
    Declare @instrucao1 varchar(100) = ''
    Declare @instrucao2 varchar(100) = ''
    Declare @instrucao3 varchar(100) = ''
    Declare @instrucao4 varchar(100) = ''
    Declare @instrucao5 varchar(100) = ''
    Declare @instrucao6 varchar(100) = ''    
    
    -- Variaveis do Arquivo
    Declare @cd_associado_empresa int 
    Declare @cd_parcela int 
    Declare @cd_tipo_pagamento_M smallint 
    Declare @vl_parcela_M money  
    Declare @dt_vencimento datetime 
    Declare @dt_vencimento_parc datetime 
    Declare @agencia int 
    Declare @dv_ag varchar(1) 
    Declare @nr_conta varchar(20)
    Declare @nr_conta_DV varchar(1)
    Declare @nr_autorizacao varchar(20)
    Declare @vl_parcela_L money
    Declare @cd_tipo_recebimento smallint
    Declare @G005 varchar(1)
    Declare @cpf_cnpj as varchar(14)
    Declare @tp_associado_Empresa as smallint 
    Declare @nr_contrato varchar(20)
    Declare @nn varchar(20)
    Declare @tipo_cartao_Hiper smallint = 0 
    Declare @count_parcela int 
    -- Variavel de Erro
    Declare @erro bit 
 
    -- Variaveis do Trailler
    Declare @qtde int 
    Declare @vl_total bigint
    Declare @qtde_no int = 0  
    Declare @vl_total_no bigint = 0 
    Declare @numerolinha int = 1 
    Declare @numero_nos int = 1 
	
	
	Begin Transaction
		select @cd_tiposervico = t.cd_tipo_servico_bancario, 
           --@cd_tipopagamento = t.cd_tipo_pagamento ,  
           @nm_tipopagamento = t.nm_tipo_pagamento, 
           @cd_banco = t.banco ,
           @convenio = t.convenio ,
           @convenio_dv = t.dv_convenio,
           @cedente = t.cedente + ' - '+ t.nr_cnpj + ' <br>' + t.EndCedente,
           @nm_banco = b.nm_banco, 
           @dt_finalizado = getdate(), 
           @nr_cnpj = t.nr_cnpj,
           @tp_ag = t.ag,
           @tp_ag_dv = t.dv_ag,
           @cta = t.cta,
           @dv_cta = t.dv_cta,
           @carteira = carteira,
           @juros = isnull(perc_juros,0),
           @multa = isnull(perc_multa,0),
           @taxa = ISNULL(vl_taxa,0),
           @agencia = t.ag ,
           @dv_ag = t.dv_ag,
           @qt_diasminimo = ISNULL(tsb.qt_diasminimo,0),
           @instrucao3 = nm_mensagem1,
           @instrucao4 = nm_mensagem2,
           @instrucao5 = nm_mensagem3
     from tipo_pagamento as t , TB_Banco_Contratos as b, tipo_servico_bancario as tsb   
     where t.cd_tipo_pagamento = @cd_tipopagamento and 
           t.cd_tipo_servico_bancario = tsb.cd_tipo_servico_bancario and             
           t.banco = b.cd_banco 
           
    IF @@ROWCOUNT = 0
    Begin -- 1.2
	  Raiserror('Sequencial nao encontrado.',16,1)
	  RETURN
    End -- 1.2
    
    
	Select @qt_diasminimo = qt_diasminimo from tipo_servico_bancario where cd_tipo_servico_bancario=@cd_tiposervico
    Set @dt_ref = DATEADD(day,@qt_diasminimo,GETDATE())
    while DATEPART(dw,@dt_ref)=1 or DATEPART(dw,@dt_ref)=7
    Begin 
      set @dt_ref = DATEADD(day,1,@dt_ref)
    End 
    
    print 'tipo serviço: ' + convert(varchar(10), isnull(@cd_tiposervico,0))
    if @cd_tiposervico = 6 or -- Debito Automatico
       @cd_tiposervico = 1 or -- CNAB 240
       @cd_tiposervico = 12 or-- CNAB 400 Santander
       @cd_tiposervico = 21 -- CNAB 400
    Begin -- 1.4

        -- Validar variaveis obrigatorias 
        if @cd_banco is null or @convenio is null or @cedente is null 
		Begin -- 2.1
		  Raiserror('Banco, Convênio ou Cedente não definidos na tabela de Tipo de Pagamento.',16,1)
		  RETURN
		End -- 2.1
    End -- 1.4
	
	
	--Trabalhando CD_Parcela
	DECLARE @SEPERATOR as VARCHAR(1)
	DECLARE @SP INT
	DECLARE @VALUE VARCHAR(1000)
	SET @SEPERATOR = ','
	DECLARE  @tempTab TABLE (id int not null)
	WHILE PATINDEX('%' + @SEPERATOR + '%', @INcd_parcela ) <> 0 
	BEGIN
	   SELECT  @SP = PATINDEX('%' + @SEPERATOR + '%',@INcd_parcela)
	   SELECT  @VALUE = LEFT(@INcd_parcela , @SP - 1)
	   SELECT  @INcd_parcela = STUFF(@INcd_parcela, 1, @SP, '')
	   INSERT INTO @tempTab (id) VALUES (@VALUE)
	END
	
	set @count_parcela = 0
	delete boleto where cd_sequencial_lote = @sequencial
        
        --Set @instrucao1='Após o vencimento cobrar:'
        print 'convenio: ' + convert(varchar(10),@convenio)
        if (@convenio is null or LEN(@convenio)<6) 
		Begin -- 4.0.3
		  Raiserror('Convenio deve ser informado com no minimo 6 digitos.',16,1)
		  RETURN
		End -- 4.0.3    

        Select @erro = 0 , @vl_total = 0 , @qtde=0 
	
	
	DECLARE cursor_gera_processos_bancos_mens CURSOR FOR  
		select m.cd_associado_empresa , m.cd_parcela, m.cd_tipo_pagamento, 
               m.vl_parcela+isnull(m.vl_acrescimo,0)-isnull(m.vl_desconto,0)-isnull(m.vl_imposto,0) , 
			   m.dt_vencimento as dt_vencimento ,  
			   convert(money,m.vl_parcela+isnull(m.vl_acrescimo,0)-isnull(m.vl_desconto,0)-isnull(m.vl_imposto,0) 
			   + Case 
				When Datediff(Day,isnull(m.dt_vencimento_new,m.DT_VENCIMENTO),isnull(m.dt_pagamento,getdate())) > 0 
				Then convert(decimal(10,2),((m.vl_parcela - isnull(m.vl_imposto,0) + isnull(m.vl_acrescimo,0) - isnull(m.vl_desconto,0)) * isnull(T5.perc_multa,0))/100) 
				Else 0 
				End +
				Case 
				When Datediff(Day,Isnull(m.dt_vencimento_new,m.DT_VENCIMENTO),isnull(m.dt_pagamento,getdate())) > 0  
				Then convert(decimal(10,2),((((m.vl_parcela - isnull(m.vl_imposto,0) + isnull(m.vl_acrescimo,0) - isnull(m.vl_desconto,0)) * isnull(T5.perc_juros,0))/30)/100) * datediff(day,isnull(m.dt_vencimento_new,m.DT_VENCIMENTO),getdate())) 
				Else 0
				End)
			   valor ,
			   m.cd_tipo_recebimento , 
               a.nr_cpf ,a.nm_completo, ltrim(Isnull(TL.NOME_TIPO,'')+' '+a.EndLogradouro+' '+Case When a.EndNumero is null then '' When a.endNumero=0 then '' else ', num. '+convert(varchar(10),a.endnumero) end+' '+ISNULL(a.EndComplemento,'')) , 
		       isnull(b.baiDescricao,''), a.logcep,  isnull(Cid.NM_MUNICIPIO,'') , isnull(UF.ufSigla,''),  m.nosso_numero, 
		       case when isnull(a.taxa_cobranca,1) = 1 then isnull(m.vl_taxa,0) else 0 end 
   		  from Mensalidades as M, Associados as a  , TB_TIPOLOGRADOURO as TL, Bairro as B, MUNICIPIO as CID, UF , TIPO_PAGAMENTO T5 
		 where m.cd_parcela in (SELECT id FROM @tempTab) and 
               m.cd_Associado_empresa = a.cd_Associado and 
               m.tp_Associado_empresa = 1  and 
               a.CHAVE_TIPOLOGRADOURO = tl.CHAVE_TIPOLOGRADOURO and 
               a.BaiId=b.baiId and 
               a.cidid = CId.CD_MUNICIPIO and 
               a.ufId = Uf.ufId and
               m.CD_TIPO_PAGAMENTO = T5.cd_tipo_pagamento
         union 
		select m.cd_associado_empresa , m.cd_parcela, m.cd_tipo_pagamento, 
               m.vl_parcela+isnull(m.vl_acrescimo,0)-isnull(m.vl_desconto,0)-isnull(m.vl_imposto,0) , 
               m.dt_vencimento ,  
               m.vl_parcela+isnull(m.vl_acrescimo,0)-isnull(m.vl_desconto,0)-isnull(m.vl_imposto,0) 
               + Case 
				When Datediff(Day,isnull(m.dt_vencimento_new,m.DT_VENCIMENTO),isnull(m.dt_pagamento,getdate())) > 0 
				Then convert(decimal(10,2),((m.vl_parcela - isnull(m.vl_imposto,0) + isnull(m.vl_acrescimo,0) - isnull(m.vl_desconto,0)) * isnull(T5.perc_multa,0))/100) 
				Else 0 
				End +
				Case 
				When Datediff(Day,Isnull(m.dt_vencimento_new,m.DT_VENCIMENTO),isnull(m.dt_pagamento,getdate())) > 0  
				Then convert(decimal(10,2),((((m.vl_parcela - isnull(m.vl_imposto,0) + isnull(m.vl_acrescimo,0) - isnull(m.vl_desconto,0)) * isnull(T5.perc_juros,0))/30)/100) * datediff(day,isnull(m.dt_vencimento_new,m.DT_VENCIMENTO),getdate())) 
				Else 0
				End
               valor, 
               m.cd_tipo_recebimento ,
               a.nr_cgc, a.nm_razsoc , ltrim(Isnull(TL.NOME_TIPO,'')+' '+a.EndLogradouro+' '+Case When a.EndNumero is null then '' When a.endNumero=0 then '' else ', num. '+convert(varchar(10),a.endnumero) end+' '+ISNULL(a.EndComplemento,'')) , 
	           isnull(b.baiDescricao,''), a.cep,  isnull(Cid.NM_MUNICIPIO,'') , isnull(UF.ufSigla,'') , m.nosso_numero, 0 
   		  from Mensalidades as M, empresa as a, TB_TIPOLOGRADOURO as TL, Bairro as B, MUNICIPIO as CID, UF , TIPO_PAGAMENTO T5 
		 where m.cd_parcela in (SELECT id FROM @tempTab) and 
               m.cd_Associado_empresa = a.cd_empresa and 
               m.tp_Associado_empresa in (2,3) and 
               a.CHAVE_TIPOLOGRADOURO = tl.CHAVE_TIPOLOGRADOURO and 
               a.BaiId=b.baiId and 
               a.cd_municipio = CId.CD_MUNICIPIO and 
               a.ufId = Uf.ufId and
               m.CD_TIPO_PAGAMENTO = T5.cd_tipo_pagamento
         order by m.DT_VENCIMENTO asc--m.cd_parcela 
       
		OPEN cursor_gera_processos_bancos_mens  
		FETCH NEXT FROM cursor_gera_processos_bancos_mens INTO @cd_associado_empresa,@cd_parcela ,@cd_tipo_pagamento_M, @vl_parcela_M,@dt_vencimento,
		      @vl_parcela_L,@cd_tipo_recebimento,@cpf_cnpj ,@nome, @endereco, @bairro, @cep, @cidade, @uf ,@nn,@taxa

		WHILE (@@FETCH_STATUS <> -1)  
		begin  -- 4.2 
		
		   set @count_parcela = @count_parcela + 1
           set @dt_vencimento_parc = @dt_vencimento
           
           set @instrucao1='Após o vencimento cobrar:'
		   Select @instrucao1=@instrucao1 + ' Juros de R$ ' + convert(varchar(10),round(@vl_parcela_L*@juros/100/30*100,0)/100) + ' ao dia.'
		   Select @instrucao1=@instrucao1 + ' Multa de R$ ' + convert(varchar(10),round(@vl_parcela_L*@multa/100*100,0)/100) + '.'          
           
           set @instrucao2 = 'Após 30 (trinta) dias de atraso protestar.'
                      
           --***Gerando NN caso nao exista**************************
			if (@nn is null or @nn = '')
			begin
			   Set @nn = '1'+right('0000000000'+convert(varchar(10),@cd_parcela),10)-- alterado 21/09/2015
			   
			   print 'NN novo: ' + @nn
			   update mensalidades 
			   set cd_lote_processo_banco = @sequencial, 
				   cd_usuario_alteracao = @cd_funcionario ,
				   DT_ALTERACAO= GETDATE(), 
				   NOSSO_NUMERO = @nn
			   where cd_parcela = @cd_parcela 
			end
			--*****************************************************
		
		Set @vl_total = @vl_total + convert(int,@vl_parcela_L*100)
           Set @qtde= @qtde + 1 
           
			Set @nn = right('000000000000'+@nn,15)
           print 'carteira: ' + convert(varchar(10),@carteira)
           print 'nn: ' + isnuLL(@nn,'')
           
           Set @nn = convert(varchar(2),@carteira) + @nn + convert(varchar(5),dbo.FS_CalculoModulo11_CNAB240(convert(varchar(2),@carteira) + @nn,4))

  		---***CAMPO LIVRE***************************************
  		   Set @CampoLivre = @convenio+@convenio_dv+substring(@nn,3,3)+SUBSTRING(@nn,1,1)+substring(@nn,6,3)+SUBSTRING(@nn,2,1)+SUBSTRING(@nn,9,9)
		   Set @CampoLivre = @CampoLivre +  dbo.FS_CalculoModulo11_CNAB240(@CampoLivre,3)
		   	
		   Set @codbarras = right('00'+convert(varchar(3),@cd_banco),3)+ '9' + convert(varchar(4),DATEDIFF(day,'10/07/1997',@dt_vencimento_parc)) + -- Fator de Vencimento
		       right('00000000000'+Replace(convert(varchar(12),convert(int,Floor((@vl_parcela_M+@taxa)*100))),'.',''),10) + -- Valor da Parcela 
			   @CampoLivre
	
	   ---********************************************************
	
	
	print '---'
			print 'convenio: ' + @convenio
			print 'digto: ' + convert(varchar(5),@convenio_dv)
            print 'nn: ' + isnull(@nn,'')
            print 'campo livre: ' + isnull(@CampoLivre,'')
            print 'Codigo Br: ' + isnull(@codbarras, '')
            print 'Tamanho CodBR:' + convert(varchar(10),  isnull(Len(@codbarras),0) )
            print 'DigCodBarras: ' + convert(varchar(2),dbo.FS_DigitoVerificarCodigoBarras(@codbarras))
            print 'sequencial: ' + convert(varchar(10), @sequencial)
            print 'cd_associado_empresa: ' + convert(varchar(10),@cd_associado_empresa)
            print 'parcela: ' + convert(varchar(10),@cd_parcela)
            print 'cedente: ' + @cedente
            print 'cedente: ' + @nr_cnpj
            print 'vencimento: ' + CONVERT(varchar(10),@dt_vencimento,103)
            print 'agencia: ' + convert(varchar(10),@agencia)
            print 'digAg: ' + convert(varchar(1),@dv_ag)
            print 'cta: ' + convert(varchar(10),@cta)
            print 'digCta: ' + convert(varchar(10),@dv_cta)
            print 'convencio: ' + convert(varchar(10),@convenio)
            print 'digConv: ' + convert(varchar(1),@convenio_dv)
            print 'carteira: ' + convert(varchar(10),@carteira)
            print 'NN: ' + @nn
            print 'valor: ' + convert(varchar(15),@vl_parcela_L)
            print 'Nome: ' + @nome
            print 'CPF/CNPJ: ' + @cpf_cnpj
            print 'Endereço: ' + @endereco
            print 'Bairro: ' + @bairro
            print 'CEP: ' + @cep
            print 'Cidade: ' + @cidade
            print 'UF: ' + @uf
            print 'multas: ' + convert(varchar(15),round(@vl_parcela_L*@multa/100*100,0)/100)
            print 'juros: ' + convert(varchar(15),round(@vl_parcela_L*@juros/100/30*100,0)/100)
            print 'inst1: ' + @instrucao1
            print 'inst2: ' + @instrucao2
            print 'inst3: ' + @instrucao3
            print 'inst4: ' + @instrucao4
            print 'LinhaDig: ' + @linhaDig1 + ' ' + @linhaDig2 + ' ' + @linhaDig3 + ' ' + @linhaDig4 + ' ' + @linhaDig5 
            print 'CodBr: ' + @codbarras
            print 'codBrVisual: ' + dbo.FG_TRADUZ_Codbarras(@codbarras)
            print 'inst5: ' + @instrucao5
            print 'inst6: ' + @instrucao6            
print '---'
	
		Set @codbarras = left(@codbarras,4) + dbo.FS_DigitoVerificarCodigoBarras(@codbarras) + right(@codbarras,39)
			 
			Set @linhaDig1 = left(@codbarras,4) + left(@CampoLivre,5) 
			Set @linhaDig1 = left(@linhaDig1,5) + '.' + right(@linhaDig1,4) + dbo.FS_CalculoModulo10(@linhaDig1) 
            
			Set @linhaDig2 = substring(@CampoLivre,6,10) 
			Set @linhaDig2 = left(@linhaDig2,5) + '.' + right(@linhaDig2,5) + dbo.FS_CalculoModulo10(@linhaDig2) 

			Set @linhaDig3 = substring(@CampoLivre,16,10) 
			Set @linhaDig3 = left(@linhaDig3,5) + '.' + right(@linhaDig3,5) + dbo.FS_CalculoModulo10(@linhaDig3) 

			Set @linhaDig4 = substring(@codbarras,5,1)

			Set @linhaDig5 = substring(@codbarras,6,14)

           print @linhaDig1
           print @linhaDig2
           print @linhaDig3
           print @linhaDig4
           print @linhaDig5 
           print 'CodBr: ' + @codbarras                                           
			
		   Set @nn = LEFT(@nn,LEN(@nn)-1)+'-'+RIGHT(@nn,1)
		   
           
           ---*****GRAVANDO TB BOLETO***************************
           insert Boleto (cd_sequencial_lote,cd_associado_empresa,cd_parcela,cedente,cnpj,
             dt_vencimento,agencia,dg_ag,conta,dg_conta,convenio,dg_convenio,carteira,
             nn,valor,pagador,cpf_cnpj_pagador,end_pagador,bai_pagador,cep_pagador,mun_pagador,
             uf_pagador,vl_multa,vl_juros,instrucao1,instrucao2,instrucao3,instrucao4,linha,barra,cod_barra,instrucao5,instrucao6, count_Parcela)
             
           values (@sequencial,@cd_associado_empresa,@cd_parcela,@cedente,@nr_cnpj,
           CONVERT(varchar(10),@dt_vencimento,103),@agencia,@dv_ag,@cta,@dv_cta, @convenio,@convenio_dv,@carteira,
           @nn,@vl_parcela_L,@nome,@cpf_cnpj, @endereco, @bairro, @cep, @cidade, @uf, 
           round(@vl_parcela_L*@multa/100*100,0)/100, round(@vl_parcela_L*@juros/100/30*100,0)/100,
           @instrucao1, @instrucao2, @instrucao3, @instrucao4, @linhaDig1 + ' ' + @linhaDig2 + ' ' + @linhaDig3 + ' ' + @linhaDig4 + ' ' + @linhaDig5, 
           @codbarras, dbo.FG_TRADUZ_Codbarras(@codbarras),@instrucao5,@instrucao6,@count_parcela)
		 ---**********************************************************
	
		
	
	FETCH NEXT FROM cursor_gera_processos_bancos_mens INTO @cd_associado_empresa,@cd_parcela ,@cd_tipo_pagamento_M, @vl_parcela_M,@dt_vencimento,
		      @vl_parcela_L,@cd_tipo_recebimento,@cpf_cnpj ,@nome, @endereco, @bairro, @cep, @cidade, @uf ,@nn,@taxa

    end -- 3.2
    Close cursor_gera_processos_bancos_mens
    Deallocate cursor_gera_processos_bancos_mens 
	
	Commit 
	Select @sequencial as SequencialLote, @cd_banco cd_banco
END
