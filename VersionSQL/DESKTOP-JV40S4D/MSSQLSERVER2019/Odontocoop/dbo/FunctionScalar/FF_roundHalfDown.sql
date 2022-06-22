/****** Object:  Function [dbo].[FF_roundHalfDown]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Function [dbo].[FF_roundHalfDown] (@valor as float) 
Returns float
as
Begin
--Declare @vl_ref money = 100 -- 785.11
--Declare @perc_aliquota int = 5
Declare @pi int 
Declare @pd int 
--Declare @valor float
Declare @comparacao int = 5
Declare @i int 

Set @valor = @valor * 100
if PATINDEX('%.%',CONVERT(Varchar(100), @valor))>0
begin
   Set @pi = left(CONVERT(Varchar(100), @valor), PATINDEX('%.%',CONVERT(Varchar(100), @valor))-1)
   Set @pd = SUBSTRING (CONVERT(Varchar(100), @valor),PATINDEX('%.%',CONVERT(Varchar(100), @valor))+1,100)
End  
else 
begin
   Set @pi = @valor
   Set @pd=0 
End  

Set @i = 1
While @i < LEN(@pd)
Begin 
  Set @comparacao = @comparacao*10
  Set @i = @i + 1 
End 

if @pd > @comparacao 
   Set @pi = @pi + 1 
   
Return convert(float,@pi)/100 

End    
