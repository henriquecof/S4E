/****** Object:  Function [dbo].[PS_CalculaDigito_CPF_CNPJ_PIS]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Function [dbo].[PS_CalculaDigito_CPF_CNPJ_PIS]
 
/**************************************************************
 *                                                            *
 *    spCalcDigMod11:                       Jan/98 - <CJD>    *
 *                                                            *
 *    Retorna o(s) NumDig Dígitos de Controle Módulo 11 do    *
 *    Dado, limitando o Valor de Multiplicação em LimMult:    *
 *                                                            *
 *    Números Comuns:          NumDig       LimMult           *
 *    CNPJ                       2            9               *
 *    CPF                        2           12               *
 *    PIS,C/C,Age,etc            1            9               *
 *                                                            *
 **************************************************************/
(
   @Dado            varchar(100),
   @NumDig          tinyint,
   @LimMult         tinyint
)
returns varchar(2) 
AS
Begin

   DECLARE @@Soma        int
   DECLARE @@Mult        tinyint
   DECLARE @@i           tinyint
   DECLARE @@n           tinyint

   -- Para o Numero de Digitos Verificadores pedidos:
   SELECT @@n = 1
   WHILE (@@n <= @NumDig)
   BEGIN
      SELECT @@Soma = 0
      SELECT @@Mult = 2

      -- Para cada um dos digitos dados:
      SELECT @@i = DATALENGTH(@Dado)
      WHILE (@@i >= 1)
      BEGIN
         -- Totaliza a soma e Atualiza Multiplicador:
         SELECT @@Soma = @@Soma + (@@Mult * CONVERT(Int, SUBSTRING(@Dado, @@i, 1)))
         SELECT @@Mult = @@Mult + 1
         IF (@@Mult > @LimMult) SELECT @@Mult = 2

         -- Proximo Digito dado:
         SELECT @@i = @@i - 1
      END

      -- Calcula o Modulo 11:
      SELECT @@Soma = (@@Soma * 10) % 11
      SELECT @Dado = @Dado + RIGHT(STR(@@Soma, 10, 0), 1)

      -- Pr¢ximo D¡gito de Controle:
      SELECT @@n = @@n + 1
   END

   -- Retorna Digitos convertidos para inteiro:
   RETURN RIGHT(@Dado, @NumDig)
End    
