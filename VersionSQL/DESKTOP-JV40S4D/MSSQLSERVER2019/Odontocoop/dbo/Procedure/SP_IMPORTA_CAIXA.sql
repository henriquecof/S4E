/****** Object:  Procedure [dbo].[SP_IMPORTA_CAIXA]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SP_IMPORTA_CAIXA]
AS

DECLARE @cd_sequencial_lancamento integer
DECLARE @cd_conta char(10)
DECLARE @cd_conta_SQL char(10)
DECLARE @dt_lancamento dateTime
DECLARE @documento varchar(20)
DECLARE @historico varchar(100)
DECLARE @dt_vencimento dateTime
DECLARE @dt_pagamento dateTime
DECLARE @vl_lancamento money
DECLARE @vl_decrescimo_acrescimo money


DECLARE cur_CaixaVelho CURSOR FOR 
	SELECT cc.cd_conta_sql, lf.dt_emissao, lf.nr_doc, CONVERT(VARCHAR(100),lf.instrucoes) AS instrucoes, 
		   il.dt_vencimento, il.dt_pagamento, il.vl_parcela,
		   il.vl_desconto, il.cd_sequencial
	FROM lancamento_financeiro_velho AS lf,
		 item_lancamento_financeiro_velho AS il,
		 ABS..contas_conversao as cc
	WHERE lf.cd_sequencial = il.cd_sequencial AND
		  lf.cd_conta = cc.cd_conta_acc AND
		  dt_pagamento IS NOT NULL

OPEN cur_CaixaVelho

FETCH NEXT FROM cur_CaixaVelho INTO
	@cd_conta, @dt_lancamento, @documento, @historico, 
	@dt_vencimento, @dt_pagamento, @vl_lancamento,
	@vl_decrescimo_acrescimo, @cd_sequencial_lancamento


WHILE (@@FETCH_STATUS <> -1)
	BEGIN
        -- select @cd_conta_SQL = cd_conta_sql from abs..contas_conversao               
          -- where cd_conta_acc = @cd_conta
   
		INSERT INTO ABS..Item_Lancamento
		(
		 cd_sequencial_lancamento, cd_sequencial, cd_conta, dt_lancamento, dt_vencimento, 
		 dt_pagamento, tp_lancamento, cd_forma_pagamento, documento, historico, vl_lancamento, 
		 vl_decrescimo_acrescimo, vl_pagamento, banco, agencia, conta, cheque
		)
		VALUES
		(
		 @cd_sequencial_lancamento, 6, @cd_conta_SQL, @dt_lancamento, @dt_vencimento,
		 @dt_pagamento, 1, 1, @documento, @historico, @vl_lancamento,
		 @vl_decrescimo_acrescimo, @vl_lancamento, NULL, NULL, NULL, NULL
		)
	
		FETCH NEXT FROM cur_CaixaVelho INTO
			@cd_conta, @dt_lancamento, @documento, @historico, 
			@dt_vencimento, @dt_pagamento, @vl_lancamento,
			@vl_decrescimo_acrescimo, @cd_sequencial_lancamento
	
	END

CLOSE cur_CaixaVelho
DEALLOCATE cur_CaixaVelho
