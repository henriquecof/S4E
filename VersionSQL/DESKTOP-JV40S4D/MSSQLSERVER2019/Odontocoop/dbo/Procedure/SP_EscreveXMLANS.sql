/****** Object:  Procedure [dbo].[SP_EscreveXMLANS]    Committed by VersionSQL https://www.versionsql.com ******/

--exec SP_EscreveXMLANS 53

CREATE Procedure [dbo].[SP_EscreveXMLANS] 
  @sequencial int
As
Begin

	Declare @caminho VARCHAR(255)
	Declare @retEcho INT --variavel para verificar se o comando foi executado com exito ou ocorreu alguma falha 
	Declare @Linha varchar(8000)
	Declare @Md5 varchar(8000) = ''
    Declare @arquivo varchar(1000)
    
	Select top 1 @caminho = pasta_site from configuracao -- Verificar o caminho a ser gravado os arquivos
	IF @@ROWCOUNT = 0
	Begin -- 1.1
	  Raiserror('Pasta dos Arquivos não definida.',16,1)
	  RETURN
	End -- 1.1
    
	Declare @hr varchar(6) = replace(convert(varchar(8),getdate(),114),':','') --- Formato hhmmss
	Declare @dt varchar(10) = convert(varchar(10),getdate(),120) -- Formato yyyy-mm-dd
	Declare @NRANS varchar(6) = '' 

	select top 1 @NRANS = nr_ans from Configuracao 
	if isnull(@NRANS,'') = '' 
	Begin 
	 Raiserror('Arquivo nao pode ser gerado sem o Codigo da ANs. Tabela Configuração.',16,1)
	 return
	End 

    Set @arquivo = @caminho + '\arquivos\ans\envio\'+ @NRANS + replace(@dt,'-','') + @hr + '.sbx'

    Set @Linha = '?xml version="1.0" encoding="ISO-8859-1" standalone="no"?>a '
    -- + 
    --   '<mensagemSIB xmlns:ansSIB="http://www.ans.gov.br/padroes/sib/schemas" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.ans.gov.br/padroes/sib/schemas http://www.ans.gov.br/padroes/sib/schemas/sib.xsd">' + 
    --   ' <cabecalho>' + 
	   --'  <identificacaoTransacao>' + 
	   --'   <tipoTransacao>Atualização SIB</tipoTransacao>' + 
	   --'   <sequencialTransacao>' + convert(varchar(10),@sequencial) +  '</sequencialTransacao>' + 
	   --'   <dataHoraRegistroTransacao>' + @dt + 'T' + @hr + 'Z</dataHoraRegistroTransacao>' + 
	   --'  </identificacaoTransacao>' + 
	   --'  <origem>' +
	   --'   <registroANS>' + @NRANS + '</registroANS>' +
	   --'  </origem>' +
	   --'  <destino>' +
	   --'   <cnpj>03589068000146</cnpj>' +
	   --'  </destino>' +
	   --'  <versaoPadrao>1.1</versaoPadrao>' +
	   --'  <identificacaoSoftwareGerador>' +
	   --'   <nomeAplicativo>S4E</nomeAplicativo>' +
	   --'   <versaoAplicativo>1</versaoAplicativo>' +
	   --'   <fabricanteAplicativo>S4E</fabricanteAplicativo>' +
	   --'  </identificacaoSoftwareGerador>' +
	   --' </cabecalho>' +
	   --' <mensagem>' +
	   --'  <operadoraParaANS>' +
	   --'   <beneficiarios>'
	   
   Set @linha = 'ECHO ' + @linha +  ' >> ' + @arquivo 
   EXEC SP_Shell @linha
 		   
   Set @Md5 = @Md5 + 'http://www.ans.gov.br/padroes/sib/schemas http://www.ans.gov.br/padroes/sib/schemas/sib.xsdAtualização SIB' + convert(varchar(10),@sequencial) +  @dt + 'T' + @hr + 'Z' + @NRANS + '035890680001461.1S4E1S4E'



End 
