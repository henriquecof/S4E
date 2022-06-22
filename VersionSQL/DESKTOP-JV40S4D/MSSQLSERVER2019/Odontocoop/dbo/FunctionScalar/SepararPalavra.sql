/****** Object:  Function [dbo].[SepararPalavra]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [dbo].[SepararPalavra] ( 
	@delimitador varchar(10),
	@indice smallint,
	@String Varchar(Max)
	 ) 
RETURNS varchar(1000)
AS
BEGIN        
-- Declaração Variáveis       
Declare @Count int = 0 
Declare @pos int 
Declare @Word varchar(1000)=''

	-- Loop       
	While @Count < @indice
	Begin              
		Set @pos = patindex('%'+@delimitador+'%',@string) 
		if @pos = 0 
		begin 
		   Set @word = @String
		   Set @String =''
		end    
		else   
		begin
		  Set @word = left(@String,@pos-1)
		  Set @String = substring(@String,@pos+1,Len(@String)-@pos)       
		End 	
		Set @Count = @Count + 1    	
	End      
	-- Retorna Valor       
	Return @Word
	
END 
