/****** Object:  Function [dbo].[FS_ContaDiasUteis]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE function [dbo].[FS_ContaDiasUteis] (@Dataini smalldatetime , @DataFim smallDatetime, @desprezaSabado int, @limite smallint = 0 )  
RETURNS Int  
AS  
BEGIN  
 Declare @Count Int  
 Select @Count = 0
 While @Dataini <= @DataFim  
 Begin  
  If DatePart(WeekDay, @Dataini) Not In (1, case when @desprezaSabado=0 then 1 else 7 end) --And @DateStart Not In ( Select Holiday_Date from Holiday )  -- para os feriados tem que ter uma tabela
      Select @Count = @Count + 1 
      
  Select @Dataini = Dateadd(day,1,@Dataini)
 End  
 
 if @limite > 0 and @Count > @limite
    Set @Count = @limite
    
 RETURN  @Count 
END 
