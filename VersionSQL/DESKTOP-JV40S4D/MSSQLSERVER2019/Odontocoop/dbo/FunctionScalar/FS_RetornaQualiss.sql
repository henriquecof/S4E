/****** Object:  Function [dbo].[FS_RetornaQualiss]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Function [dbo].[FS_RetornaQualiss](@funcionario int)
Returns varchar(50)
As
Begin
   Declare @retorno varchar(50)
   Declare @cd_qualiss as int

   Set @retorno = ''
   
   Declare Cursor01 CURSOR FOR
   
   select T1.cd_qualiss
   from funcionario_especialidade_qualiss T1
   inner join qualiss T2 on T1.cd_qualiss = T2.cd_qualiss
   where isnull(T2.ativo,1) = 1
   and T1.cd_funcionario = @funcionario
   order by T1.cd_qualiss
   
   open Cursor01
   fetch next from Cursor01 into @cd_qualiss
   while (@@fetch_status<>-1)
   begin
     if (@retorno <> '')
        set @retorno = @retorno + ','
     Set @retorno = @retorno + convert(varchar,@cd_qualiss)
     fetch next from Cursor01 into @cd_qualiss
   End 
   Close Cursor01
   Deallocate Cursor01
   
   Return @retorno  
End
