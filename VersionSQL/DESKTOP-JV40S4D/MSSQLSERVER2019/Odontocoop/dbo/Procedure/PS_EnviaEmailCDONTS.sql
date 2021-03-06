/****** Object:  Procedure [dbo].[PS_EnviaEmailCDONTS]    Committed by VersionSQL https://www.versionsql.com ******/

/*
    PROCEDURE QUE ENVIA UM EMAIL ATRAVÉS DO COMPONENTE CDONTS.DLL
    PARAMETROS:
        @FROM_ADDRESS      	- ENDEREÇO DE EMAIL FROM
        @TO_ADDRESS        	- ENDEREÇOS DE EMAILS TO (SEPARADOS POR ;)
        @CC_ADDRESS        	- ENDEREÇOS DE EMAILS CC (CÓPIA CARBONO) (SEPARADOS POR ;)
        @BCC_ADDRESS       	- ENDEREÇOS DE EMAILS BCC (CÓPIA CARBONO OCULTA) (SEPARADOS POR ;)
        @ASSUNTO_EMAIL    	- ASSUNTO DO EMAIL
        @MENSAGEM_EMAIL    	- CORPO DO EMAIL (MENSAGEM)
        @TIPO_EMAIL        	- TIPO DA MENSAGEM (TEXTO=1 OU HTML=0), O DEFAULT É HTML
*/

CREATE PROCEDURE [dbo].[PS_EnviaEmailCDONTS]
    @FROM_ADDRESS VARCHAR(100),
    @TO_ADDRESS VARCHAR(1000),
    @CC_ADDRESS VARCHAR(1000) = '',
    @BCC_ADDRESS VARCHAR(1000) = '',
    @ASSUNTO_EMAIL VARCHAR(200) = '',
    @MENSAGEM_EMAIL TEXT = '',
    @TIPO_EMAIL INT = 0
AS    

SET NOCOUNT ON

    DECLARE @OMAIL        INT -- OBJETO CDONTS
    DECLARE @RESULTADO    INT -- RESULTADO DAS CHAMADAS DO OBJETO

    -- CORRIGINDO OS ENDEREÇOS DE EMAILS 
    SET @FROM_ADDRESS = REPLACE(@FROM_ADDRESS, ' ', '')
    SET @FROM_ADDRESS = REPLACE(@FROM_ADDRESS, ';', ',')
    
    SET @TO_ADDRESS = REPLACE(@TO_ADDRESS, ' ', '')
    SET @TO_ADDRESS = REPLACE(@TO_ADDRESS, ';', ',')
    
    SET @CC_ADDRESS = REPLACE(@CC_ADDRESS, ' ', '')
    SET @CC_ADDRESS = REPLACE(@CC_ADDRESS, ';', ',')
    
    SET @BCC_ADDRESS = REPLACE(@BCC_ADDRESS, ' ', '')
    SET @BCC_ADDRESS = REPLACE(@BCC_ADDRESS, ';', ',')
    
    EXEC @RESULTADO = SP_OACREATE 'CDOSYS.NEWMAIL', @OMAIL OUT -- INSTANCIANDO O OBJETO CDONTS

    IF @RESULTADO = 0 -- VERIFICANDO SE FOI POSSÍVEL CRIAR O OBJETO
    BEGIN 
        EXEC @RESULTADO = SP_OASETPROPERTY @OMAIL, 'FROM'    , @FROM_ADDRESS -- ENDEREÇO DE EMAIL FROM

        EXEC @RESULTADO = SP_OASETPROPERTY @OMAIL, 'TO'        ,    @TO_ADDRESS    -- ENDEREÇO DE EMAIL TO
        
        -- VERIFICANDO SE O ENDEREÇO CC NÃO ESTÁ VAZIO
        IF @CC_ADDRESS <> ''
        BEGIN
            EXEC @RESULTADO = SP_OASETPROPERTY @OMAIL, 'CC',  @CC_ADDRESS    -- ENDEREÇO DE EMAIL CC
        END
            
        -- VERIFICANDO SE O ENDEREÇO BCC NÃO ESTÁ VAZIO
        IF @BCC_ADDRESS <> ''
        BEGIN
            EXEC @RESULTADO = SP_OASETPROPERTY @OMAIL, 'BCC',  @BCC_ADDRESS    -- ENDEREÇO DE EMAIL BCC
        END

        EXEC @RESULTADO = SP_OASETPROPERTY @OMAIL, 'SUBJECT', @ASSUNTO_EMAIL    -- ASSUNTO
        
        EXEC @RESULTADO = SP_OASETPROPERTY @OMAIL, 'BODY', @MENSAGEM_EMAIL    -- CORPO DO EMAIL
        
        -- TIPO DE EMAIL (TEXTO/HTML)
        EXEC @RESULTADO = SP_OASETPROPERTY @OMAIL, 'BODYFORMAT', @TIPO_EMAIL 
        EXEC @RESULTADO = SP_OASETPROPERTY @OMAIL, 'MAILFORMAT', @TIPO_EMAIL

        -- ENVIANDO O EMAIL        
        EXEC @RESULTADO = SP_OAMETHOD @OMAIL, 'SEND', NULL
        
        EXEC SP_OADESTROY @OMAIL -- DESTRUINDO A INSTANCIA DO OBJETO CDONTS
    END
SET NOCOUNT OFF
