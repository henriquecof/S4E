/****** Object:  Function [dbo].[NExtenso_Extenso]    Committed by VersionSQL https://www.versionsql.com ******/

 CREATE FUNCTION [dbo].[NExtenso_Extenso](@Num INTEGER)
	RETURNS VARCHAR(50)
AS
BEGIN 

	RETURN CASE @Num 
		WHEN 1000 THEN 'Mil' WHEN 1000000 THEN 'Milhões' WHEN 1000000000 THEN 'Bilhões'
		WHEN 100 THEN 'Cento' WHEN 200 THEN 'Duzentos' WHEN 300 THEN 'Trezentos' WHEN 400 THEN 'Quatrocentos' WHEN 500 THEN 'Quinhentos' WHEN 600 THEN 'Seiscentos' WHEN 700 THEN 'Setecentos' WHEN 800 THEN 'Oitocentos' WHEN 900 THEN 'Novecentos'
		WHEN 10 THEN 'Dez' WHEN 11 THEN 'Onze' WHEN 12 THEN 'Doze' WHEN 13 THEN 'Treze' WHEN 14 THEN 'Quartorze' WHEN 15 THEN 'Quinze' WHEN 16 THEN 'Dezesseis' WHEN 17 THEN 'Dezesete' WHEN 18 THEN 'Dezoito' WHEN 19 THEN 'Dezenove'
		WHEN 20 THEN 'Vinte' WHEN 30 THEN 'Trinta' WHEN 40 THEN 'Quarenta' WHEN 50 THEN 'Cinquenta' WHEN 60 THEN 'Sessenta' WHEN 70 THEN 'Setenta' WHEN 80 THEN 'Oitenta' WHEN 90 THEN 'Noventa' 
		WHEN 1 THEN 'Um' WHEN 2 THEN 'Dois' WHEN 3 THEN 'Tres' WHEN 4 THEN 'Quatro' WHEN 5 THEN 'Cinco' WHEN 6 THEN 'Seis' WHEN 7 THEN 'Sete' WHEN 8 THEN 'Oito' WHEN 9 THEN 'Nove' 
		ELSE NULL END
END
