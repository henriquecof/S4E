/****** Object:  Function [dbo].[ProximoDiaUtil]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Function [dbo].[ProximoDiaUtil](@data datetime,@SabadoDiaUtil smallint) 
Returns date
as 
Begin
   Set @data = CONVERT(varchar(10),@data,101)
   
   Declare @i smallint = 0
   While @i = 0 
   Begin
      Set @i = 1 
      if (select COUNT(0) from CRMFeriado where ferData = @data)>0
         Set @i = 0 
      if DATEPART(dw,@data) in (1,case when @SabadoDiaUtil=0 then 7 else 1 end)  
         Set @i = 0 
          
      if @i = 0 
         Set @data = DATEADD(DAY,1,@data)
                
   End
   
   Return @data
   
End
