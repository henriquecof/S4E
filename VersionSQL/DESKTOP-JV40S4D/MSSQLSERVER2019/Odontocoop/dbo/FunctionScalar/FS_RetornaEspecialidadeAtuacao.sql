/****** Object:  Function [dbo].[FS_RetornaEspecialidadeAtuacao]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Function [dbo].[FS_RetornaEspecialidadeAtuacao](@funcionario int, @clinica int)
Returns varchar(1000)
As
Begin
   Declare @retorno varchar(1000)
   Declare @nm_especialidade as varchar(50)
 
   Set @retorno = ''
  
   Declare Cursor01 CURSOR FOR
  
   select distinct T1.nm_especialidade
   from especialidade T1
   inner join atuacao_dentista T2 on T2.cd_especialidade = T1.cd_especialidade
   where T2.cd_funcionario = @funcionario
   and T2.cd_filial = @clinica
   and T2.fl_ativo = 1
   and T2.fl_divulgar_rede_atendimento = 1
   order by T1.nm_especialidade
  
   open Cursor01
   fetch next from Cursor01 into @nm_especialidade
   while (@@fetch_status<>-1)
   begin
     if (@retorno <> '')
        set @retorno = @retorno + ', '
     Set @retorno = @retorno + @nm_especialidade
     fetch next from Cursor01 into @nm_especialidade
   End
   Close Cursor01
   Deallocate Cursor01
  
   Return @retorno
End
