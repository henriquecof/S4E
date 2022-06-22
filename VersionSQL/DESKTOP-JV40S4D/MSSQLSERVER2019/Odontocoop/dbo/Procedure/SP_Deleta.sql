/****** Object:  Procedure [dbo].[SP_Deleta]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_Deleta] @nome varchar(20), @sql varchar(255)
As Begin
 
  declare @tb char(50)
  declare @update varchar(255)
  declare @where varchar(255)
 
  select @tb = ltrim(substring(@sql,charindex('from',@sql)+5,charindex('where',@sql)-1 - charindex('from',@sql)-5))


  select @where = ltrim(substring(@sql,charindex('where',@sql),255))

  select @update = 'update ' + ltrim(@tb) + ' set nome_usuario = ''' + ltrim(@nome) + ''' ' + ltrim(@where)

  Begin Transaction
 
  	exec (@update)
 
 	If @@error <> 0
  	Begin
 		Rollback Transaction
		Return
  	End 
 
  	SET CONCAT_NULL_YIELDS_NULL Off

  	Exec (@sql)	
 
 	If @@error <> 0
	Begin
 		Rollback Transaction
 		SET CONCAT_NULL_YIELDS_NULL On
 		Return
  	End 
 
  Commit Transaction
 
  SET CONCAT_NULL_YIELDS_NULL On 
 
End
