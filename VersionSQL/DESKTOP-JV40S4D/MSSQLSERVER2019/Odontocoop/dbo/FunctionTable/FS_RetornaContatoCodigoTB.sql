/****** Object:  Function [dbo].[FS_RetornaContatoCodigoTB]    Committed by VersionSQL https://www.versionsql.com ******/

Create Function [dbo].[FS_RetornaContatoCodigoTB](@fone varchar(11))
Returns @Result Table( cd_associado int)
As
Begin
	Insert Into @Result
	select T2.CD_ASSOCIADO --as cod 
   from TB_Contato T1,  ASSOCIADOS T2 
   where  T1.cd_sequencial = T2.cd_associado  
    AND TUSTELEFONE = @fone
    and T1.cd_origeminformacao = 1  
    
   union  
    
   select  T2.cd_associado --as cod
   from TB_Contato T1,  DEPENDENTES T2 
   where T1.cd_sequencial = T2.cd_sequencial  
    AND TUSTELEFONE = @fone
    and T1.cd_origeminformacao = 5  
  order by 1
  RETURN 
End
