/****** Object:  Function [dbo].[FS_Gera_NossoNumero]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		João Paulo
-- Create date: 29/11/2012
-- Description:	Gera Nosso Numero para parcelas com Nosso_numero vazio
-- =============================================
CREATE FUNCTION [dbo].[FS_Gera_NossoNumero](@cd_parcela int)
RETURNS  varchar(50)
AS
BEGIN
	Declare @variacao varchar(10) = '0'
	Declare @nn varchar(50)
	Declare @ag varchar(10)
	Declare @dv_ag varchar(10)
	Declare @conta varchar(10)
	Declare @nngravado varchar(50)
	Declare @cd_tipo_pagamento int
	Declare @cd_tipo_servico_bancario int


select @cd_tipo_pagamento = T1.cd_tipo_pagamento, @cd_tipo_servico_bancario = T2.cd_tipo_servico_bancario
   from Mensalidades t1, tipo_pagamento T2
   where T1.CD_PARCELA =  @cd_parcela and 
   T1.CD_TIPO_PAGAMENTO = t2.CD_TIPO_PAGAMENTO

	Select @variacao = VariacaoCarteira , @ag = ag, @dv_ag = right('0'+convert(varchar(10),ISNULL(dv_ag,0)),2), @conta = right('00000'+cta,5)
    from tipo_pagamento 
    where cd_tipo_pagamento = @cd_tipo_pagamento and 
          cd_tipo_servico_bancario = @cd_tipo_servico_bancario
   
   
	Set @nn = right(YEAR(GETDATE()) ,2) + @variacao + '%'
	Select @nn = MAX(nosso_numero) 
	from MENSALIDADES 
	where nosso_numero like @nn and LEN(nosso_numero)=9
	
	if @nn is null -- Se nao existe nosso numero 
  		Set @nn = right(YEAR(GETDATE()) ,2) + @variacao + '00000'
  	else -- Remover o digito e somar + 1 
  		Set @nn = LEFT(@nn,8)
  		
		Set @nn = convert(varchar(8),CONVERT(bigint,@nn)+1)

--		Set @nn = '14202158'
        Set @nngravado = @nn + dbo.FS_CalculoModulo11(@ag+@dv_ag+@conta+@nn, 3) 
       
                
	RETURN @nngravado

END
