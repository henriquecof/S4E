/****** Object:  Function [dbo].[ContaPalavras]    Committed by VersionSQL https://www.versionsql.com ******/

Create FUNCTION [dbo].[ContaPalavras] (       
	@Word Varchar(100),       
	@String Varchar(Max) ) 
RETURNS int
AS
BEGIN        
-- Declaração Variáveis       
Declare @Count int, @CountWord int        
-- Contador de quantas vezes apareceu a palavra       
Set @CountWord = 0         
-- Contador do Loop       
Set @Count = 0         
-- Loop       
While @Count <= Len(@String)       
Begin              
-- Se encontrar a palavra soma mais um para @CountWord             
Set @CountWord = Case When Substring(@String, @Count, Len(@Word)) = @Word                         
                   Then @CountWord + 1                         
                   Else @CountWord                   
                 End              
-- Soma mais um ao contador             
Set @Count = @Count + 1         
End        
-- Retorna Valor       
Return @CountWord   
END 
