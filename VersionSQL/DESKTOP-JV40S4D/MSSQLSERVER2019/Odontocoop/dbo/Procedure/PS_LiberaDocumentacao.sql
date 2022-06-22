/****** Object:  Procedure [dbo].[PS_LiberaDocumentacao]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[PS_LiberaDocumentacao](@Lista varchar(2000))
As
Begin

	--ATENÇÃO. SENDO UTILIZADO DIRETAMENTE NA APLICAÇÃO
	return

   Declare @Sequencial varchar(15)
   Declare @Filial int
   Declare @cd_sequencial int

   While @Lista <> ''
     Begin
       Set @Sequencial = substring(@lista,1,dbo.instr(',',@lista)-1)
       Set @lista = substring(@lista,dbo.instr(',',@lista)+1,len(@lista))

       Select @cd_sequencial = cd_sequencial from TB_ConsultasDocumentacao where Sequencial_ConsultasDocumentacao = @Sequencial

       Select @Filial = cd_filial from consultas where cd_sequencial = @cd_sequencial
     
--       if @Filial is not null
--         Begin
--          if (Select cd_clinica from filial where cd_filial = @Filial) <> 2
--             Begin
--                Update consultas set 
--                   nr_procedimentoliberado = 1
--                   where cd_sequencial = @cd_sequencial

----                 Update consultasTemp set 
----                   nr_procedimentoliberado = 1
----                   where cd_sequencial = @cd_sequencial

--                 --Quando o procedimento aceitar RX acrescentar o procedimento 210 já liberado para ser pago.
--                   /*Insert Into Consultas 
--                     (cd_Sequencial,cd_sequencial_dep,cd_associado,dt_servico,dt_pericia,
--                      cd_servico,dt_baixa, cd_funcionario, cd_filial, cd_sequencial_agenda, fl_analisa, 
--                      dt_cadastro,usuario_cadastro,usuario_baixa,cd_ud,
--                      oclusal,distral,mesial,vestibular,lingual,nr_procedimentoliberado)
--                   Select (Select Max(cd_sequencial)+1 From Consultas),cd_sequencial_dep,cd_associado,dt_servico,dt_pericia,
--                      210,dt_baixa,cd_funcionario,cd_filial,cd_sequencial_agenda,0,
--                      getdate(),usuario_cadastro,usuario_baixa,cd_ud, 
--                      oclusal,distral,mesial,vestibular,lingual,1
--                   From consultas           
--                   where cd_sequencial = @cd_sequencial
--                   */
--             End 
--         End

        Update TB_ConsultasDocumentacao set foto_digitalizada = 1 where Sequencial_ConsultasDocumentacao = @Sequencial

     End
End
