/****** Object:  Function [dbo].[FS_RetornaCodEspecialidade]    Committed by VersionSQL https://www.versionsql.com ******/

create Function [dbo].[FS_RetornaCodEspecialidade](@funcionario int)
Returns varchar(1000)
As
Begin
   Declare @retorno varchar(1000)
   Declare @cd_especialidade as varchar(50)

   Set @retorno = ''
   
   Declare Cursor01 CURSOR FOR
   
   select T1.cd_especialidade
   from especialidade T1, funcionario_especialidade T2
   where T1.cd_especialidade = T2.cd_especialidade
   and T2.cd_funcionario = @funcionario
   order by T1.cd_especialidade
   
   open Cursor01
   fetch next from Cursor01 into @cd_especialidade
   while (@@fetch_status<>-1)
   begin
     if (@retorno <> '')
        set @retorno = @retorno + ', '
     Set @retorno = @retorno + @cd_especialidade
     fetch next from Cursor01 into @cd_especialidade
   End 
   Close Cursor01
   Deallocate Cursor01
   
   Return @retorno  
End
