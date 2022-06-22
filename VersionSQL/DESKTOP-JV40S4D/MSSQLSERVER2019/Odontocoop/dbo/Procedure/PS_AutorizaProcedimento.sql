/****** Object:  Procedure [dbo].[PS_AutorizaProcedimento]    Committed by VersionSQL https://www.versionsql.com ******/

Create Procedure [dbo].[PS_AutorizaProcedimento](
      @CD_Associado Int,
      @CD_Sequencial_Dep Int,
      @Sequencial_Agenda Int,
      @Sequencial_Consulta Int,
      @CD_Funcionario Int,
      @DT_Servico DateTime,
      @Filial Int)
AS
Begin
  
   Declare @cd_servico Int
   Declare @CD_UD      Nvarchar(100)
   Declare @Mesial     Int
   Declare @Oclusal    Int
   Declare @Vestibular Int
   Declare @Lingual    Int
   Declare @Distral    Int   
   Declare @ErrorMessage Varchar(2000)

Select @cd_servico = cd_servico, 
       @CD_UD      =  CD_UD, 
       @Mesial     = Mesial, 
       @Oclusal    = Oclusal,
       @Vestibular = Vestibular,
       @Lingual    = Lingual,
       @Distral    = Distral   
  From  Consultas 
  Where CD_Sequencial = @Sequencial_Consulta

  Exec PS_ValidaConsulta  @CD_Associado,@CD_Sequencial_Dep,@CD_Servico,null,@CD_Funcionario,@CD_UD,@Mesial,@Oclusal,@Vestibular,@Lingual,@Distral,@DT_Servico,null,@Filial,null,null       

  /*Select @ErrorMessage = ERROR_MESSAGE() 

  Select @ErrorMessage */
  PRINT N'The job candidate has been deleted.'

End
