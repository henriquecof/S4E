/****** Object:  Procedure [dbo].[SP_ParcelasArcodadas]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_ParcelasArcodadas]
@dataInicial varchar(10),
@datafinal varchar(10)
As
Begin

DECLARE @sql varchar(max)

SET @sql = 'SELECT DISTINCT t1.CD_PARCELA AS parcela_mae,
                CONVERT(varchar(10), isnull(t1.dt_vencimento_new, t1.dt_vencimento), 103) AS vencimento,
                t9.nm_tipo_pagamento AS tipo_pagamento,
                t1.VL_PARCELA,
                convert(varchar(10), t1.DT_PAGAMENTO, 103) AS dt_pagamento,
                t10.nm_tipo_pagamento AS tipo_recebimento,
                ISNULL(t1.VL_PAGO,0) AS vl_pago,
                isnull(t1.vl_acrescimo,0) vl_acrescimo,
                isnull(t1.vl_desconto,0) AS vl_desconto,
                isnull(t1.vl_imposto,0) AS vl_imposto,
                isnull(t1.vl_JurosMultaReferencia,0) AS vl_JurosMultaReferencia,
                isnull(t1.vl_servico, 0) AS vl_servico,
                (t1.vl_parcela + isnull(t1.vl_acrescimo,0) - isnull(t1.vl_desconto,0) - isnull(t1.vl_imposto,0)) AS vl_titulo,
                isnull((isnull(t1.vl_pago,0) + isnull(t1.vl_JurosMultaReferencia,0) - isnull(t1.vl_desconto_recebimento,0)),0) AS total_pago,
                isnull(t1.vl_desconto_recebimento,0) AS vl_desconto_recebimento,
                t3.nm_completo,
                t6.NM_SITUACAO_HISTORICO,
                t3.cd_associado,
                t8.nm_empregado AS empregadoBaixa,
                CONVERT(varchar(10), t1.DT_BAIXA, 103) AS data_baixa ,
                t7.CD_PARCELA AS parcela_filha,
                CONVERT(varchar(10), isnull(t7.dt_vencimento_new, t7.dt_vencimento), 103) AS vencimento_filha,
                t12.nm_tipo_pagamento AS tipo_pagamento_filha,
                t7.VL_PARCELA AS vl_parcela_filha,
                convert(varchar(10), t7.DT_PAGAMENTO, 103) AS dt_pagamento_filha,
                t13.nm_tipo_pagamento AS tipo_recebimento_filha,
                ISNULL(t7.VL_PAGO,0) AS vl_pago_filha,
                isnull(t7.vl_acrescimo,0) vl_acrescimo_filho,
                isnull(t7.vl_desconto,0) AS vl_desconto_filha,
                isnull(t7.vl_imposto,0) AS vl_imposto_filha,
                isnull(t7.vl_JurosMultaReferencia,0) AS vl_JurosMultaReferencia_filha,
                isnull(t7.vl_servico, 0) AS vl_servico_filha,
                (t7.vl_parcela + isnull(t7.vl_acrescimo,0) - isnull(t7.vl_desconto,0) - isnull(t7.vl_imposto,0)) AS vl_titulo_filha,
                isnull((isnull(t7.vl_pago,0) + isnull(t7.vl_JurosMultaReferencia,0) - isnull(t7.vl_desconto_recebimento,0)),0) AS total_pago_filha,
                isnull(t7.vl_desconto_recebimento,0) AS vl_desconto_recebimento_filha, t11.nm_empregado as empregadoBaixaFilha
                ,(select T14.nm_empregado from funcionario T14 where T14.cd_funcionario = t4.cd_funcionario_adesionista) As Adesionista
                ,convert(varchar(10), t3.dt_assinatura_contrato, 103) as data_assinatura
FROM mensalidades t1
INNER JOIN MensalidadesAgrupadas t2 ON t1.CD_PARCELA = t2.cd_parcelaMae
INNER JOIN ASSOCIADOS t3 ON t1.cd_associado_empresa = t3.cd_associado
INNER JOIN dependentes t4 ON t3.cd_associado = t4.cd_associado
AND t4.cd_grau_parentesco = 1
INNER JOIN historico t5 ON t4.cd_sequencial_historico = t5.cd_sequencial
INNER JOIN situacao_historico t6 ON t5.cd_situacao = t6.CD_SITUACAO_HISTORICO
INNER JOIN mensalidades t7 ON t2.cd_parcela = t7.cd_parcela
LEFT JOIN funcionario t8 ON t1.CD_USUARIO_BAIXA = t8.cd_funcionario
INNER JOIN TIPO_PAGAMENTO t9 ON t1.cd_tipo_pagamento = t9.cd_tipo_pagamento
INNER JOIN tipo_pagamento t10 ON t1.cd_tipo_recebimento = t10.cd_tipo_pagamento
LEFT JOIN funcionario t11 ON t7.CD_USUARIO_BAIXA = t11.cd_funcionario
INNER JOIN TIPO_PAGAMENTO t12 ON t7.cd_tipo_pagamento = t12.cd_tipo_pagamento
INNER JOIN tipo_pagamento t13 ON t7.cd_tipo_recebimento = t13.cd_tipo_pagamento
WHERE t1.TP_ASSOCIADO_EMPRESA = 1
  AND t1.CD_TIPO_RECEBIMENTO NOT IN (1)'
   if @dataInicial <> ''
	begin
		Set @sql += 'AND ISNULL(t1.dt_vencimento_new, t1.dt_vencimento) >= '''+CONVERT(varchar(10),@dataInicial,103)+''' '
	end
   if @datafinal <> ''
	begin
		Set @sql += ' AND ISNULL(t1.dt_vencimento_new, t1.dt_vencimento) <= '''+CONVERT(varchar(10),@datafinal,103)+''' '
	end
	  
Set @sql += ' UNION
SELECT DISTINCT t1.CD_PARCELA AS parcela_mae,
                CONVERT(varchar(10), isnull(t1.dt_vencimento_new, t1.dt_vencimento), 103) AS vencimento,
                t9.nm_tipo_pagamento AS tipo_pagamento,
                t1.VL_PARCELA,
                convert(varchar(10), t1.DT_PAGAMENTO, 103) AS dt_pagamento,
                t10.nm_tipo_pagamento AS tipo_recebimento,
                ISNULL(t1.VL_PAGO,0) AS vl_pago,
                isnull(t1.vl_acrescimo,0) vl_acrescimo,
                isnull(t1.vl_desconto,0) AS vl_desconto,
                isnull(t1.vl_imposto,0) AS vl_imposto,
                isnull(t1.vl_JurosMultaReferencia,0) AS vl_JurosMultaReferencia,
                isnull(t1.vl_servico, 0) AS vl_servico,
                (t1.vl_parcela + isnull(t1.vl_acrescimo,0) - isnull(t1.vl_desconto,0) - isnull(t1.vl_imposto,0)) AS vl_titulo,
                isnull((isnull(t1.vl_pago,0) + isnull(t1.vl_JurosMultaReferencia,0) - isnull(t1.vl_desconto_recebimento,0)),0) AS total_pago,
                isnull(t1.vl_desconto_recebimento,0) AS vl_desconto_recebimento,
                t3.NM_FANTASIA,
                t6.NM_SITUACAO_HISTORICO,
                t3.CD_EMPRESA,
                t8.nm_empregado AS empregadoBaixa,
                CONVERT(varchar(10), t1.DT_BAIXA, 103) AS data_baixa ,
                t7.CD_PARCELA AS parcela_filha,
                CONVERT(varchar(10), isnull(t7.dt_vencimento_new, t7.dt_vencimento), 103) AS vencimento_filha,
                t12.nm_tipo_pagamento AS tipo_pagamento_filha,
                t7.VL_PARCELA AS vl_parcela_filha,
                convert(varchar(10), t7.DT_PAGAMENTO, 103) AS dt_pagamento_filha,
                t13.nm_tipo_pagamento AS tipo_recebimento_filha,
                ISNULL(t7.VL_PAGO,0) AS vl_pago_filha,
                isnull(t7.vl_acrescimo,0) vl_acrescimo_filho,
                isnull(t7.vl_desconto,0) AS vl_desconto_filha,
                isnull(t7.vl_imposto,0) AS vl_imposto_filha,
                isnull(t7.vl_JurosMultaReferencia,0) AS vl_JurosMultaReferencia_filha,
                isnull(t7.vl_servico, 0) AS vl_servico_filha,
                (t7.vl_parcela + isnull(t7.vl_acrescimo,0) - isnull(t7.vl_desconto,0) - isnull(t7.vl_imposto,0)) AS vl_titulo_filha,
                isnull((isnull(t7.vl_pago,0) + isnull(t7.vl_JurosMultaReferencia,0) - isnull(t7.vl_desconto_recebimento,0)),0) AS total_pago_filha,
                isnull(t7.vl_desconto_recebimento,0) AS vl_desconto_recebimento_filha, t11.nm_empregado as empregadoBaixaFilha
                ,   (select T14.nm_empregado from funcionario T14 where T14.cd_funcionario = t3.cd_func_adesionista) As Adesionista
                , convert(varchar(10), t3.dt_fechamento_contrato, 103) as data_assinatura
FROM mensalidades t1
INNER JOIN MensalidadesAgrupadas t2 ON t1.CD_PARCELA = t2.cd_parcelaMae
INNER JOIN empresa t3 ON t1.cd_associado_empresa = t3.cd_empresa
INNER JOIN historico t5 ON t3.cd_sequencial_historico = t5.cd_sequencial
INNER JOIN situacao_historico t6 ON t5.cd_situacao = t6.CD_SITUACAO_HISTORICO
INNER JOIN mensalidades t7 ON t2.cd_parcela = t7.cd_parcela
LEFT JOIN funcionario t8 ON t1.CD_USUARIO_BAIXA = t8.cd_funcionario
INNER JOIN TIPO_PAGAMENTO t9 ON t1.cd_tipo_pagamento = t9.cd_tipo_pagamento
INNER JOIN tipo_pagamento t10 ON t1.cd_tipo_recebimento = t10.cd_tipo_pagamento
LEFT JOIN funcionario t11 ON t7.CD_USUARIO_BAIXA = t11.cd_funcionario
INNER JOIN TIPO_PAGAMENTO t12 ON t7.cd_tipo_pagamento = t12.cd_tipo_pagamento
INNER JOIN tipo_pagamento t13 ON t7.cd_tipo_recebimento = t13.cd_tipo_pagamento
WHERE t1.TP_ASSOCIADO_EMPRESA = 2
  AND t1.CD_TIPO_RECEBIMENTO NOT IN (1)'
   if @dataInicial <> ''
	begin
		Set @sql += 'AND ISNULL(t1.dt_vencimento_new, t1.dt_vencimento) >= '''+CONVERT(varchar(10),@dataInicial,103)+''' '
	end
   if @datafinal <> ''
	begin
		Set @sql += ' AND ISNULL(t1.dt_vencimento_new, t1.dt_vencimento) <= '''+CONVERT(varchar(10),@datafinal,103)+''' '
	end
	  
Set @sql += ' UNION
SELECT DISTINCT t1.CD_PARCELA AS parcela_mae,
                CONVERT(varchar(10), isnull(t1.dt_vencimento_new, t1.dt_vencimento), 103) AS vencimento,
                t9.nm_tipo_pagamento AS tipo_pagamento,
                t1.VL_PARCELA,
                convert(varchar(10), t1.DT_PAGAMENTO, 103) AS dt_pagamento,
                t10.nm_tipo_pagamento AS tipo_recebimento,
                ISNULL(t1.VL_PAGO,0) AS vl_pago,
                isnull(t1.vl_acrescimo,0) vl_acrescimo,
                isnull(t1.vl_desconto,0) AS vl_desconto,
                isnull(t1.vl_imposto,0) AS vl_imposto,
                isnull(t1.vl_JurosMultaReferencia,0) AS vl_JurosMultaReferencia,
                isnull(t1.vl_servico, 0) AS vl_servico,
                (t1.vl_parcela + isnull(t1.vl_acrescimo,0) - isnull(t1.vl_desconto,0) - isnull(t1.vl_imposto,0)) AS vl_titulo,
                isnull((isnull(t1.vl_pago,0) + isnull(t1.vl_JurosMultaReferencia,0) - isnull(t1.vl_desconto_recebimento,0)),0) AS total_pago,
                isnull(t1.vl_desconto_recebimento,0) AS vl_desconto_recebimento,
                t3.nm_completo,
                t6.NM_SITUACAO_HISTORICO,
                t3.cd_associado,
                t8.nm_empregado AS empregadoBaixa,
                CONVERT(varchar(10), t1.DT_BAIXA, 103) AS data_baixa ,
                NULL AS parcela_filha,
                NULL AS vencimento_filha,
                NULL AS tipo_pagamento_filha,
                NULL AS vl_parcela_filha,
                NULL AS dt_pagamento_filha,
                NULL AS tipo_recebimento_filha,
                NULL AS vl_pago_filha,
                NULL vl_acrescimo_filho,
                     NULL AS vl_desconto_filha,
                     NULL AS vl_imposto_filha,
                     NULL AS vl_JurosMultaReferencia_filha,
                     NULL AS vl_servico_filha,
                     NULL AS vl_titulo_filha,
                     NULL AS total_pago_filha,
                     NULL AS vl_desconto_recebimento_filha,
                     NULL as empregadoBaixaFilha
                     ,  (select T14.nm_empregado from funcionario T14 where T14.cd_funcionario = t4.cd_funcionario_adesionista) As Adesionista
                     ,convert(varchar(10), t3.dt_assinatura_contrato, 103) as data_assinatura
FROM mensalidades t1
INNER JOIN ASSOCIADOS t3 ON t1.cd_associado_empresa = t3.cd_associado
INNER JOIN dependentes t4 ON t3.cd_associado = t4.cd_associado
AND t4.cd_grau_parentesco = 1
INNER JOIN historico t5 ON t4.cd_sequencial_historico = t5.cd_sequencial
INNER JOIN situacao_historico t6 ON t5.cd_situacao = t6.CD_SITUACAO_HISTORICO
LEFT JOIN funcionario t8 ON t1.CD_USUARIO_BAIXA = t8.cd_funcionario
INNER JOIN TIPO_PAGAMENTO t9 ON t1.cd_tipo_pagamento = t9.cd_tipo_pagamento
INNER JOIN tipo_pagamento t10 ON t1.cd_tipo_recebimento = t10.cd_tipo_pagamento
WHERE t1.TP_ASSOCIADO_EMPRESA = 1
  AND t1.CD_TIPO_RECEBIMENTO = 2'    
  if @dataInicial <> ''
	begin
		Set @sql += 'AND ISNULL(t1.dt_vencimento_new, t1.dt_vencimento) >= '''+CONVERT(varchar(10),@dataInicial,103)+''' '
	end
   if @datafinal <> ''
	begin
		Set @sql += ' AND ISNULL(t1.dt_vencimento_new, t1.dt_vencimento) <= '''+CONVERT(varchar(10),@datafinal,103)+''' '
	end	  
Set @sql += ' UNION
SELECT DISTINCT t1.CD_PARCELA AS parcela_mae,
                CONVERT(varchar(10), isnull(t1.dt_vencimento_new, t1.dt_vencimento), 103) AS vencimento,
                t9.nm_tipo_pagamento AS tipo_pagamento,
                t1.VL_PARCELA,
                convert(varchar(10), t1.DT_PAGAMENTO, 103) AS dt_pagamento,
                t10.nm_tipo_pagamento AS tipo_recebimento,
                ISNULL(t1.VL_PAGO,0) AS vl_pago,
                isnull(t1.vl_acrescimo,0) vl_acrescimo,
                isnull(t1.vl_desconto,0) AS vl_desconto,
                isnull(t1.vl_imposto,0) AS vl_imposto,
                isnull(t1.vl_JurosMultaReferencia,0) AS vl_JurosMultaReferencia,
                isnull(t1.vl_servico, 0) AS vl_servico,
                (t1.vl_parcela + isnull(t1.vl_acrescimo,0) - isnull(t1.vl_desconto,0) - isnull(t1.vl_imposto,0)) AS vl_titulo,
                isnull((isnull(t1.vl_pago,0) + isnull(t1.vl_JurosMultaReferencia,0) - isnull(t1.vl_desconto_recebimento,0)),0) AS total_pago,
                isnull(t1.vl_desconto_recebimento,0) AS vl_desconto_recebimento,
                t3.NM_FANTASIA,
                t6.NM_SITUACAO_HISTORICO,
                t3.CD_EMPRESA,
                t8.nm_empregado AS empregadoBaixa,
                CONVERT(varchar(10), t1.DT_BAIXA, 103) AS data_baixa ,
                NULL AS parcela_filha,
                NULL AS vencimento_filha,
                NULL AS tipo_pagamento_filha,
                NULL AS vl_parcela_filha,
                NULL AS dt_pagamento_filha,
                NULL AS tipo_recebimento_filha,
                NULL AS vl_pago_filha,
                NULL vl_acrescimo_filho,
                     NULL AS vl_desconto_filha,
                     NULL AS vl_imposto_filha,
                     NULL AS vl_JurosMultaReferencia_filha,
                     NULL AS vl_servico_filha,
                     NULL AS vl_titulo_filha,
                     NULL AS total_pago_filha,
                     NULL AS vl_desconto_recebimento_filha,
                     NULL as empregadoBaixaFilha
                     ,(select T14.nm_empregado from funcionario T14 where T14.cd_funcionario = t3.cd_func_adesionista) As Adesionista
                     ,convert(varchar(10), t3.dt_fechamento_contrato, 103) as data_assinatura
FROM mensalidades t1
INNER JOIN empresa t3 ON t1.cd_associado_empresa = t3.cd_empresa
INNER JOIN historico t5 ON t3.cd_sequencial_historico = t5.cd_sequencial
INNER JOIN situacao_historico t6 ON t5.cd_situacao = t6.CD_SITUACAO_HISTORICO
LEFT JOIN funcionario t8 ON t1.CD_USUARIO_BAIXA = t8.cd_funcionario
INNER JOIN TIPO_PAGAMENTO t9 ON t1.cd_tipo_pagamento = t9.cd_tipo_pagamento
INNER JOIN tipo_pagamento t10 ON t1.cd_tipo_recebimento = t10.cd_tipo_pagamento
WHERE t1.TP_ASSOCIADO_EMPRESA = 2
  AND t1.CD_TIPO_RECEBIMENTO = 2'
  	if @dataInicial <> ''
	begin
		Set @sql += 'AND ISNULL(t1.dt_vencimento_new, t1.dt_vencimento) >= '''+CONVERT(varchar(10),@dataInicial,103)+''' '
	end
   if @datafinal <> ''
	begin
		Set @sql += ' AND ISNULL(t1.dt_vencimento_new, t1.dt_vencimento) <= '''+CONVERT(varchar(10),@datafinal,103)+''' '
	end
  	Set @sql += 'ORDER BY 1'			  
	
	exec (@sql)
	print (@sql)
End
