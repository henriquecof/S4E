/****** Object:  Procedure [dbo].[ps_a]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE procedure [dbo].[ps_a](@a2 int,@saida int OUTPUT)
as
Begin
   
    update a set a2 = 9001 where a2 = @a2
    set @saida =  999
    RAISERROR ('isso e um teste', 16, 1)
  

End
