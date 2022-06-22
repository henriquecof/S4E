/****** Object:  Procedure [dbo].[Spro_aprazamento]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  procedure [dbo].[Spro_aprazamento] as
DECLARE @INICIO AS DATETIME,
        @DESCRICAO AS VARCHAR(40),
        @VALOR AS MONEY,
        @vencimento as datetime
begin

begin transaction	  
DECLARE cursor_a CURSOR FOR 
SELECT DT_INICIAL,NM_DESCRICAO,VL_LANCAMENTO FROM APRAZAMENTO 
WHERE DATEDIFF(month,DT_INICIAL, dateadd(mm,1,getdate()))%SINISTRALIDADE  = 0
AND DATEDIFF(month,DT_INICIAL, dateadd(mm,1,getdate())) >= 0
AND GETDATE()<= DT_FINAL

OPEN cursor_a 
FETCH NEXT FROM cursor_a INTO @INICIO , @DESCRICAO, @VALOR
WHILE (@@FETCH_STATUS <> -1)
 begin
set @vencimento =convert(varchar(2),month( dateadd(mm,1,getdate())))+'/'
+convert(varchar(2),day(@INICIO))+'/'+convert(varchar(4),year(@INICIO))
INSERT INTO Item_Lancamento (tp_lancamento,  historico, dt_vencimento, 
                             vl_lancamento, dt_lancamento,cd_forma_pagamento)
                      values(1,@DESCRICAO,convert(varchar(12),@vencimento,101)
                             ,@valor,getdate(),1)

FETCH NEXT FROM cursor_a INTO @INICIO , @DESCRICAO, @VALOR
end
DEALLOCATE cursor_a
--print convert(varchar(10), @wl_acumula,101)

commit transaction
end
