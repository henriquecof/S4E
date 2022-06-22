/****** Object:  Function [dbo].[DVContaCaixa]    Committed by VersionSQL https://www.versionsql.com ******/

 CREATE function [dbo].[DVContaCaixa](@Conta varchar(15)) 
   RETURNS Varchar(1)
  AS
  Begin

            Declare  @i          int
            Declare  @NumeroPeso int
            Declare  @total      int
            Declare  @resto      int
            Declare  @peso       varchar(15)
          
            --------PESO-----------------------------
            Set @Peso = '876543298765432'

            --------CALCULO DO TOTAL-----------------------------
            Set @total = 0
            Set @i = 1
            while @i <= 15
               Begin
                Set @total = @total + (convert(int,substring(@peso,@i,1)) * convert(int,substring(@Conta, @i, 1)))
                Set @i = @i + 1
               End

            Set @total = @total * 10

            Set @resto = @total  % 11

            If @resto = 10 
               Set @resto = 0
           

            Return @resto

        End 
