/****** Object:  Procedure [dbo].[PS_ValorProcedimento]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[PS_ValorProcedimento](
@CD_SequencialDEP int,
@CD_Servico int,
@CD_Filial int)
As
Begin

----------------VARIAVEIS------------------------------------------------------------
Declare @cd_tabelaparticular int
Declare @perc_coparticipacao decimal(12,2)
Declare @CD_PLANO int
Declare @CD_Tabela int
Declare @ID_Coparticipacao int
Declare @dt_assinaturaContrato datetime
Declare @qt_diascarencia int
Declare @DS_Mensagem varchar(2000)
Declare @VL_Servico decimal(12,2)
Declare @nm_servico varchar(200)
Declare @tp_procedimento int
Declare @carencia smallint

---------------CORPO PROGRAMA--------------------------------------------------------

Set @nm_servico = Null

Select @nm_servico = nm_servico, 
       @tp_procedimento = tp_procedimento
From servico
Where cd_servico = @CD_Servico

if @nm_servico = Null 
   Begin
      rollback 
      RAISERROR ('Procedimento inexistente.', 16, 1)               
      Return 
   End

If @tp_procedimento = 5
   Begin
      rollback 
      RAISERROR ('Codigo de procedimento esta inativo, não podendo ser usado.', 16, 1)               
      Return 
   End

Select @cd_tabelaparticular = t1.cd_tabelaparticular, 
       @perc_coparticipacao = Isnull(t1.perc_coparticipacao,0),
       @CD_PLANO            = t1.CD_PLANO,
       @dt_assinaturaContrato = isnull(dt_assinaturaContrato,getdate()) 
From   planos t1, dependentes t2
Where  t1.cd_plano = t2.cd_plano and
       t2.cd_sequencial = @CD_SequencialDEP

Set @CD_Tabela = null

Select @CD_Tabela = CD_TABELA
        From plano_filial
        Where CD_PLANO = @CD_PLANO And
              CD_FILIAL = @CD_Filial

If @CD_Tabela is null
   Set @CD_Tabela = @cd_tabelaparticular  

 Set @ID_Coparticipacao = 0

 Set @carencia = 0

Select  @ID_Coparticipacao = isnull(ID_Coparticipacao,0),
        @qt_diascarencia = isnull(qt_diascarencia,0)        
  From  plano_servico
  Where CD_PLANO = @CD_PLANO And
        CD_SERVICO = @CD_Servico
       
    If @qt_diascarencia > 0 
      Begin
        if datediff(day,@dt_assinaturaContrato,getdate()) <= @qt_diascarencia
              Set @carencia = 1
      end

Set @VL_Servico = null

Select @VL_Servico = vl_servico
 from  tabela_servicos 
 where CD_Servico = @CD_Servico And
       CD_Tabela  = @CD_Tabela

If @VL_Servico is null
   Begin
      --rollback 
      --RAISERROR ('Procedimento não foi cadastrado na tabela de valores dos servicos.', 16, 1)               
      Set @VL_Servico = 0.00
      Select @nm_servico as nm_servico, @VL_Servico as vl_servico, @dt_assinaturaContrato as AssinaturaContrato, isnull(@qt_diascarencia,0) as diascarencia,@carencia as carencia
      Return 
   End

If @ID_Coparticipacao > 0  And @perc_coparticipacao > 0 And @carencia = 0
   Set @VL_Servico = @VL_Servico * convert(decimal(12,2),convert(decimal(12,2),@perc_coparticipacao)/convert(decimal(12,2),100)) 

Select @nm_servico as nm_servico, @VL_Servico as vl_servico, @dt_assinaturaContrato as AssinaturaContrato, isnull(@qt_diascarencia,0) as diascarencia,@carencia as carencia


End
