/****** Object:  Procedure [dbo].[SP_AUTORIZA_ATENDIMENTO]    Committed by VersionSQL https://www.versionsql.com ******/

 
--COMECO
--************************************
CREATE PROCEDURE [dbo].[SP_AUTORIZA_ATENDIMENTO]
    @cd_sequencial_dep int,
    @cd_funcionario int,
    @motivo varchar(200),
    @cd_sequencial int, --Chave Primária
    @qTabela int,
    @nr_autorizacao varchar(30) OUTPUT
AS
BEGIN
    if @cd_sequencial_dep is null
  Begin
     RAISERROR ('Usuário não informado.', 16, 1)
     RETURN
  End
  
 Declare @mdeId int
 Declare @chaId int
  
 BEGIN TRANSACTION
 
 set @nr_autorizacao = left(replace(convert(varchar(10),getdate(),112)+convert(varchar(20),getdate(),114),':',''),14) + convert(varchar,@cd_funcionario)
 --****************************************************************
 --CRM
 --****************************************************************
 if @qTabela = 1
  begin
   --Liberação de atendimento (consulta)
   select @mdeId = T1.mdeId
   from Processos T1, CRMMotivoDetalhado T2
   where T1.mdeId = T2.mdeId
   and T1.cd_processo = 4
  end
 else
  begin
   --Liberação de procedimento
   select @mdeId = T1.mdeId
   from Processos T1, CRMMotivoDetalhado T2
   where T1.mdeId = T2.mdeId
   and T1.cd_processo = 5
  end
 if @mdeId is not null
  begin
   --Inclusão dos dados principais do chamado
   insert into CRMChamado
   (tsoId, chaSolicitante, mdeId, chaDtCadastro, chaRespostaEmail, chaRespostaSMS, chaChave, Usuario, sitId, chaProtocolo, chaDtFechamento, tinId)
   values (2, @cd_sequencial_dep, @mdeId, getdate(), 0, 0, 'AUTOMATICO', @cd_funcionario, 3, @nr_autorizacao, getdate(), 2)
   --Código do chamado
   select @chaId = chaId
   from CRMChamado
   where chaProtocolo = @nr_autorizacao
   --Ocorrência
   insert into CRMChamadoOcorrencia
   (chaId, cocDescricao, cocDtCadastro, Usuario)
   values (@chaId, @motivo, getdate(), @cd_funcionario)
  end
 --****************************************************************
 insert into Autorizacao_Atendimento
 (nr_autorizacao, dt_solicitacao, cd_funcionario, nm_motivo, cd_sequencial_dep, cd_usuario_autorizou)
 values(@nr_autorizacao, getdate(), @cd_funcionario, @motivo, @cd_sequencial_dep, @cd_funcionario)
    IF @qTabela = 1
        BEGIN
            UPDATE AGENDA SET
            nr_autorizacao = @nr_autorizacao
            WHERE cd_sequencial = @cd_sequencial
        END
    ELSE
        BEGIN
            UPDATE consultas SET
            nr_autorizacao = @nr_autorizacao,
            consultas.status = 6,
            cd_funcionario_analise = @cd_funcionario
            WHERE cd_sequencial = @cd_sequencial
 
            Update Inconsistencia_Consulta Set
            dt_analise = GetDate(),
            status =  1,
            ds_motivo = @motivo,
            cd_funcionario = @cd_funcionario
            Where cd_sequencial_consulta =  @cd_sequencial
        END
      COMMIT TRANSACTION
END
