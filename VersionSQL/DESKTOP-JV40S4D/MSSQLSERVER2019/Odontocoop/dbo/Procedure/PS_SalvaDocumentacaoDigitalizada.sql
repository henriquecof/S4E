/****** Object:  Procedure [dbo].[PS_SalvaDocumentacaoDigitalizada]    Committed by VersionSQL https://www.versionsql.com ******/

/*-----------------------------------------------------------
Criado por Marcio N. Costa
Objetivo : Fazer com que as glosa realizdas sejam validadas, pois são feitas em telas
           diferentes. Fazer com que o campo Foto_Digitalizada seja preenchida.
-------------------------------------------------------------*/
CREATE Procedure [dbo].[PS_SalvaDocumentacaoDigitalizada](
                 @Documentos varchar(1000))
As
Begin
   Declare @Sequencial_Documentacao varchar(20)
   Declare @Situacao varchar
   Declare @Glosa_Valida smallint
   -- 1 - Pendente.
   -- 2 - Aceito.
   -- 3 - Glosado.   
   While @Documentos <> ''
     Begin
       Set @Sequencial_Documentacao = Substring(@Documentos,1,dbo.InStr('|',@Documentos)-1) 
       Set @Situacao =  Substring(@Documentos,dbo.InStr('|',@Documentos)+1,(dbo.InStr('*',@Documentos)-1)-(dbo.InStr('|',@Documentos)))        
       Set @Documentos = Substring(@Documentos,dbo.InStr('*',@Documentos)+1,len(@Documentos)) 

--       select @Sequencial_Documentacao, @Situacao, @Documentos
       
       Select @Glosa_Valida = isnull(Glosa_Valida,3) 
        From consultas_documentacao
        Where Sequencial_ConsultasDocumentacao = @Sequencial_Documentacao    				

       --Possibilidades.
       if @Situacao='1' And @Glosa_Valida='3'
         Begin
          update Consultas_Documentacao
             Set Situacao = 1,
                 Foto_Digitalizada = 1
           Where Sequencial_ConsultasDocumentacao = @Sequencial_Documentacao
         End 

       if @Situacao='1' And (@Glosa_Valida='0' or @Glosa_Valida='1')
         Begin
          update Consultas_Documentacao
             Set Situacao = 1,
                 Foto_Digitalizada = 1,
                 Glosa = null,
                 Tipo_Glosa = null,
                 Codigo_Novo_Servico = null,
                 Glosa_Valida = null
           Where Sequencial_ConsultasDocumentacao = @Sequencial_Documentacao
         End 

       if @Situacao='2' And @Glosa_Valida='3'
         Begin
          update Consultas_Documentacao
             Set Situacao = 2,
                 Foto_Digitalizada = 1
           Where Sequencial_ConsultasDocumentacao = @Sequencial_Documentacao
         End 
       
        if @Situacao='2' And (@Glosa_Valida='0' or @Glosa_Valida='1')
         Begin
          update Consultas_Documentacao
             Set Situacao = 2,
                 Foto_Digitalizada = 1,
                 Glosa = null,
                 Tipo_Glosa = null,
                 Codigo_Novo_Servico = null,
                 Glosa_Valida = null
           Where Sequencial_ConsultasDocumentacao = @Sequencial_Documentacao
         End         

       if @Situacao='3' And @Glosa_Valida='3'
         Begin
            RAISERROR ('Existe uma glosa que não foi preenchida com o motivo. Por favor, verifique os dados.', 16, 1)
            Return
         End 

       if @Situacao='3' And @Glosa_Valida='0'
         Begin
            update Consultas_Documentacao
             Set Situacao = 3,         
                 Foto_Digitalizada = 1,        
                 Glosa_Valida = 1
            Where Sequencial_ConsultasDocumentacao = @Sequencial_Documentacao            
         End                         
     End      
End 
