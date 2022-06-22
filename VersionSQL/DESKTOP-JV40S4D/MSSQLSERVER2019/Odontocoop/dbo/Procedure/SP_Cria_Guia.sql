/****** Object:  Procedure [dbo].[SP_Cria_Guia]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  PROCEDURE [dbo].[SP_Cria_Guia]
	@cd_sequencial_pp1 int,
	@cd_sequencial_pp2 int,
	@cd_sequencial_pp3 int,
	@cd_sequencial_pp4 int,
        @cd_filial int ,
        @cd_funcionario int ,  
        @nr_guia int output
AS
Begin

        Declare @nr_guia_check int 
        Declare @cd_associado int
        Declare @cd_sequencial_dep int 
        declare @dt_inicial smalldatetime

        While 0=0
        Begin

             select @nr_guia = nr_guia + 1
               from guia
              where cd_filial = @cd_filial

             update guia 
                set nr_guia = nr_guia + 1
              where cd_filial = @cd_filial             

             select @nr_guia_check = nr_guia
               from guia
              where cd_filial = @cd_filial
             
             if @nr_guia = @nr_guia_check
             begin
               break
             End 

        End  

        select @cd_associado = cd_associado , @cd_sequencial_dep = cd_sequencial_dep 
          from Procedimentos_Pendentes 
         where cd_sequencial = @cd_sequencial_pp1

        select @dt_inicial= isnull(max(dt_servico),getdate()) 
          from Procedimentos_Pendentes 
         where cd_associado = @cd_associado and 
               cd_sequencial_dep = @cd_sequencial_dep and 
               dt_cancelado is null

        if @dt_inicial < getdate()
        Begin
           select @dt_inicial = getdate()
        End 
 
        UPDATE Procedimentos_Pendentes 
           SET nr_guia = @nr_guia, cd_funcionario = @cd_funcionario , 
               dt_servico = dateadd(d,7,@dt_inicial) ,dt_impressao_guia = getdate()
         WHERE cd_sequencial = @cd_sequencial_pp1

        If @cd_sequencial_pp2 > 0 
        Begin
          UPDATE Procedimentos_Pendentes 
             SET nr_guia = @nr_guia, cd_funcionario = @cd_funcionario , 
                 dt_servico = dateadd(d,14,@dt_inicial) ,dt_impressao_guia = getdate()
           WHERE cd_sequencial = @cd_sequencial_pp2
        End 

        If @cd_sequencial_pp3 > 0 
        Begin
          UPDATE Procedimentos_Pendentes 
             SET nr_guia = @nr_guia, cd_funcionario = @cd_funcionario , 
                 dt_servico = dateadd(d,21,@dt_inicial) ,dt_impressao_guia = getdate()
           WHERE cd_sequencial = @cd_sequencial_pp3
        End  

        If @cd_sequencial_pp4 > 0 
        Begin
          UPDATE Procedimentos_Pendentes 
             SET nr_guia = @nr_guia, cd_funcionario = @cd_funcionario , 
                 dt_servico = dateadd(d,28,@dt_inicial) ,dt_impressao_guia = getdate()
           WHERE cd_sequencial = @cd_sequencial_pp4
        End 

End
