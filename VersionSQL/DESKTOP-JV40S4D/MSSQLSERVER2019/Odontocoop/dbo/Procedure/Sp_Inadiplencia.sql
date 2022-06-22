/****** Object:  Procedure [dbo].[Sp_Inadiplencia]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Sp_Inadiplencia] 
  @dt_inicio       VARCHAR(10), 
  @dt_fim          VARCHAR(10), 
  @cd_centro_custo VARCHAR(MAX), 
  @cd_fp           VARCHAR(MAX),    -- tipo pagamento   (varchar)
  @tp_empresa      VARCHAR(MAX)  --tipo empresa      (varchar) 
AS 
  BEGIN 
	--VARIÁVEL PARA SQL
      DECLARE @sql VARCHAR(MAX)
      SET @sql = ''
    
    --DECLARÇÃO E VARIÁVEIS
      SET @sql = @sql + ' DECLARE @Valor MONEY '
      SET @sql = @sql + ' DECLARE @Qtde MONEY '
      SET @sql = @sql + ' DECLARE @Tp_pagamento MONEY '
      SET @sql = @sql + ' DECLARE @vl_atrasados MONEY '
      SET @sql = @sql + ' DECLARE @cd_centro_custo_f INT '
      SET @sql = @sql + ' DECLARE @cd_fp_f INT '
      SET @sql = @sql + ' DECLARE @tp_empresa_f INT '
      SET @sql = @sql + ' DECLARE @tp SMALLINT '
      SET @sql = @sql + ' DECLARE @fp SMALLINT '
      --END DECLARÇÃO E VARIÁVEIS

      PRINT 'limpar tabela' 

      DELETE Inadiplentes 
      
      PRINT 'insert tabela' 

      --GERA UMA TABELA COM CARTEZIANO DAS TABELAS
      SET @sql = @sql + ' INSERT INTO Inadiplentes  '
      SET @sql = @sql + ' SELECT p.cd_tipo_pagamento, t.tp_associado_empresa, tp.cd_tipo_parcela, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  '
      SET @sql = @sql + ' FROM tipo_pagamento AS p, tipo_associado_empresa AS t, tipo_parcela AS tp  '
      SET @sql = @sql + ' WHERE t.tp_associado_empresa <= 2 '
    
      IF (@cd_fp = '0') SET @sql = @sql + ' AND cd_tipo_pagamento >= 0 AND cd_tipo_pagamento <= 9999 '
      ELSE SET @sql = @sql + ' AND cd_tipo_pagamento IN (' + @cd_fp  + ') '

      /***********************/
      /*      FATURADO       */
      /***********************/
      SET @sql = @sql + ' DECLARE cursor_faturado CURSOR FOR '

      SET @sql = @sql + ' SELECT m.cd_tipo_pagamento , m.tp_associado_empresa , m.cd_tipo_parcela , Sum(Isnull(m.vl_parcela  + Isnull(vl_acrescimo, 0)  - Isnull(vl_desconto, 0) - Isnull( vl_imposto, 0), 0))  , Count(0) '
      SET @sql = @sql + ' FROM   mensalidades AS m, associados AS a, empresa    AS e, Inadiplentes AS t '
      SET @sql = @sql + ' WHERE m.cd_associado_empresa = a.cd_associado AND m.cd_tipo_pagamento = t.cd_tipo_pagamento AND m.tp_associado_empresa             = t.tp_associado_empresa AND m.cd_tipo_parcela = t.cd_tipo_parcela AND a.cd_empresa = e.cd_empresa AND (m.cd_tipo_recebimento NOT IN ( 1 , 2 ) OR (m.cd_tipo_recebimento IN (2) AND m.DT_BAIXA > ''' + cast( @dt_fim as varchar) + ''' )) AND m.tp_associado_empresa = 1 '
      SET @sql = @sql + ' AND Isnull(m.dt_vencimento_new, m.dt_vencimento) >= ''' + cast( @dt_inicio as varchar) + ''' AND Isnull(m.dt_vencimento_new, m.dt_vencimento) <= ''' + cast( @dt_fim as varchar) + ''''

      SET @sql = @sql + ' GROUP  BY m.cd_tipo_pagamento, m.tp_associado_empresa, m.cd_tipo_parcela '

      SET @sql = @sql + ' UNION '

      SET @sql = @sql + ' SELECT m.cd_tipo_pagamento, m.tp_associado_empresa, m.cd_tipo_parcela, Sum(Isnull(m.vl_parcela + Isnull(vl_acrescimo, 0) - Isnull(vl_desconto, 0) - Isnull(vl_imposto, 0), 0)), Count(0) '
      SET @sql = @sql + ' FROM   mensalidades AS m, empresa AS e, Inadiplentes AS t '
      SET @sql = @sql + ' WHERE m.cd_associado_empresa = e.cd_empresa AND m.cd_tipo_pagamento = t.cd_tipo_pagamento AND m.tp_associado_empresa = t.tp_associado_empresa AND m.cd_tipo_parcela = t.cd_tipo_parcela AND (m.cd_tipo_recebimento NOT IN ( 1 , 2 ) OR (m.cd_tipo_recebimento IN (2) AND m.DT_BAIXA > ''' + cast( @dt_fim as varchar) + ''' )) AND m.tp_associado_empresa = 2 '
      SET @sql = @sql + ' AND Isnull(m.dt_vencimento_new, m.dt_vencimento) >= ''' + cast( @dt_inicio as varchar) + ''' AND Isnull(m.dt_vencimento_new, m.dt_vencimento) <= ''' + cast( @dt_fim as varchar) + ''''
      
      SET @sql = @sql + ' GROUP  BY m.cd_tipo_pagamento, m.tp_associado_empresa, m.cd_tipo_parcela '

      SET @sql = @sql + ' OPEN cursor_faturado '

      SET @sql = @sql + ' FETCH next FROM cursor_faturado INTO @tp_pagamento, @tp, @fp, @Valor, @Qtde '

      SET @sql = @sql + ' WHILE ( @@FETCH_STATUS <> -1 ) BEGIN '
      SET @sql = @sql + ' UPDATE Inadiplentes SET    FaturadoValor = FaturadoValor + Isnull(@Valor, 0), FaturadoQtd = FaturadoQtd + Isnull(@Qtde, 0) '
      SET @sql = @sql + ' WHERE  cd_tipo_pagamento = @tp_pagamento AND tp_associado_empresa = @tp  AND cd_tipo_parcela = @fp '
      SET @sql = @sql + ' FETCH next FROM cursor_faturado INTO @tp_pagamento, @tp, @fp, @Valor, @Qtde END '

      SET @sql = @sql + ' CLOSE cursor_faturado '
      SET @sql = @sql + ' DEALLOCATE cursor_faturado '

      /***********************/
      /*   RECEBIDO DO MÊS   */
      /***********************/

      SET @sql = @sql + ' DECLARE cursor_recebidodomes CURSOR FOR '
      SET @sql = @sql + ' SELECT m.cd_tipo_pagamento, m.tp_associado_empresa, m.cd_tipo_parcela, Sum(Isnull(m.vl_pago, 0)), NULL AS diferenca, Count(0) '
      SET @sql = @sql + ' FROM   mensalidades AS m, associados AS a, empresa AS e, Inadiplentes AS t '
      SET @sql = @sql + ' WHERE  m.cd_associado_empresa = a.cd_associado AND m.cd_tipo_pagamento = t.cd_tipo_pagamento '
      SET @sql = @sql + ' AND m.tp_associado_empresa = t.tp_associado_empresa AND m.cd_tipo_parcela = t.cd_tipo_parcela '
      SET @sql = @sql + ' AND a.cd_empresa = e.cd_empresa AND m.tp_associado_empresa = 1 AND m.cd_tipo_recebimento > 2  '
      SET @sql = @sql + ' AND Isnull(m.dt_vencimento_new, m.dt_vencimento) >= ''' + cast( @dt_inicio as varchar) + ''' AND Isnull(m.dt_vencimento_new, m.dt_vencimento) <= ''' + cast( @dt_fim as varchar) + ''''

      IF (@cd_centro_custo = '0') SET @sql = @sql + ' AND e.cd_centro_custo >= 0 AND e.cd_centro_custo <= 9999 '
      ELSE SET @sql = @sql + ' AND e.cd_centro_custo IN (' + @cd_centro_custo  + ') '
        
      IF (@tp_empresa = '0') SET @sql = @sql + ' AND e.tp_empresa >= 0 AND e.tp_empresa <= 9999 '
      ELSE SET @sql = @sql + ' AND e.tp_empresa IN (' + @tp_empresa  + ') '

      SET @sql = @sql + ' AND Isnull(m.dt_pagamento, 0) <> 0 '
      SET @sql = @sql + ' GROUP  BY m.cd_tipo_pagamento, m.tp_associado_empresa, m.cd_tipo_parcela '

      SET @sql = @sql + ' UNION '

      SET @sql = @sql + ' SELECT m.cd_tipo_pagamento, m.tp_associado_empresa, m.cd_tipo_parcela, Sum(Isnull(m.vl_pago, 0)), NULL AS diferenca, Count(0) '
      SET @sql = @sql + ' FROM   mensalidades AS m, empresa AS a, Inadiplentes AS t '
      SET @sql = @sql + ' WHERE  m.cd_associado_empresa = a.cd_empresa AND m.cd_tipo_pagamento = t.cd_tipo_pagamento '
      SET @sql = @sql + ' AND m.tp_associado_empresa = t.tp_associado_empresa AND m.cd_tipo_parcela = t.cd_tipo_parcela '
      SET @sql = @sql + ' AND m.tp_associado_empresa = 2 AND m.cd_tipo_recebimento > 2 '
      SET @sql = @sql + ' AND Isnull(m.dt_vencimento_new, m.dt_vencimento) >= ''' + cast( @dt_inicio as varchar) + ''' AND Isnull(m.dt_vencimento_new, m.dt_vencimento) <= ''' + cast(@dt_fim as varchar) + ''''

      --centro de custo
      IF (@cd_centro_custo = '0') SET @sql = @sql + ' AND a.cd_centro_custo >= 0 AND a.cd_centro_custo <= 9999 '
      ELSE SET @sql = @sql + ' AND a.cd_centro_custo IN (' + @cd_centro_custo  + ') '
      -- tipo empresa
      IF (@tp_empresa = '0') SET @sql = @sql + ' AND a.tp_empresa >= 0 AND a.tp_empresa <= 9999 '
      ELSE SET @sql = @sql + ' AND a.tp_empresa IN (' + @tp_empresa + ') '

      SET @sql = @sql + ' AND Isnull(m.dt_pagamento, 0) <> 0 '
      SET @sql = @sql + ' GROUP  BY m.cd_tipo_pagamento, m.tp_associado_empresa, m.cd_tipo_parcela '

      SET @sql = @sql + ' OPEN cursor_recebidodomes ' 

      SET @sql = @sql + ' FETCH next FROM cursor_recebidodomes INTO @tp_pagamento, @tp, @fp, @Valor, @vl_atrasados, @Qtde ' 

      SET @sql = @sql + ' WHILE ( @@FETCH_STATUS <> -1 ) '
      SET @sql = @sql + ' BEGIN '
      SET @sql = @sql + ' SELECT CONVERT(VARCHAR, @tp_pagamento), CONVERT(VARCHAR, @Qtde), CONVERT(VARCHAR, @Valor) '
      SET @sql = @sql + ' UPDATE Inadiplentes SET    RecebidodoMesValor = RecebidodoMesValor + Isnull(@Valor, 0), RecebidodoMesQtd = RecebidodoMesQtd + Isnull(@Qtde, 0) '
      SET @sql = @sql + ' WHERE  cd_tipo_pagamento = @tp_pagamento AND tp_associado_empresa = @tp AND cd_tipo_parcela = @fp '
      
      SET @sql = @sql + ' FETCH next FROM cursor_recebidodomes INTO @tp_pagamento, @tp, @fp, @Valor, @vl_atrasados, @Qtde '
      SET @sql = @sql + ' END '
      
      SET @sql = @sql + ' CLOSE cursor_recebidodomes '
      SET @sql = @sql + ' DEALLOCATE cursor_recebidodomes '

      /***********************/
      /* RECEBIDO ADIANTADO  */
      /***********************/ 
      
      SET @sql = @sql + ' DECLARE cursor_adiantado CURSOR FOR '
      SET @sql = @sql + ' SELECT m.cd_tipo_pagamento, m.tp_associado_empresa, m.cd_tipo_parcela, Sum(Isnull(m.vl_pago, 0)), NULL AS diferenca, Count(0) '
      SET @sql = @sql + ' FROM   mensalidades AS m, associados AS a, empresa AS e, Inadiplentes AS t '
      SET @sql = @sql + ' WHERE  m.cd_associado_empresa = a.cd_associado AND m.cd_tipo_pagamento = t.cd_tipo_pagamento AND m.tp_associado_empresa = t.tp_associado_empresa AND m.cd_tipo_parcela = t.cd_tipo_parcela AND a.cd_empresa = e.cd_empresa AND m.tp_associado_empresa = 1 AND m.cd_tipo_recebimento > 2  '
      SET @sql = @sql + ' AND Isnull(m.dt_vencimento_new, m.dt_vencimento) >= ''' + cast( @dt_inicio as varchar) + ''' AND Isnull(m.dt_vencimento_new, m.dt_vencimento) <= ''' + cast(@dt_fim as varchar) + ''''
      
      IF (@cd_centro_custo = '0') SET @sql = @sql + ' AND e.cd_centro_custo >= 0 AND e.cd_centro_custo <= 9999 '
      ELSE SET @sql = @sql + ' AND e.cd_centro_custo IN (' + @cd_centro_custo  + ') '
        
      IF (@tp_empresa = '0') SET @sql = @sql + ' AND e.tp_empresa >= 0 AND e.tp_empresa <= 9999 '
      ELSE SET @sql = @sql + ' AND e.tp_empresa IN (' + @tp_empresa  + ') '

      SET @sql = @sql + ' AND m.dt_pagamento <= DATEADD(M, -1, Isnull(m.dt_vencimento_new, m.dt_vencimento)) '
      SET @sql = @sql + ' GROUP BY m.cd_tipo_pagamento, m.tp_associado_empresa, m.cd_tipo_parcela '

      SET @sql = @sql + ' UNION '

      SET @sql = @sql + ' SELECT m.cd_tipo_pagamento, m.tp_associado_empresa, m.cd_tipo_parcela, Sum(Isnull(m.vl_pago, 0)), NULL AS diferenca, Count(0) '
      SET @sql = @sql + ' FROM mensalidades AS m, empresa AS a, Inadiplentes AS t '
      SET @sql = @sql + ' WHERE  m.cd_associado_empresa = a.cd_empresa AND m.cd_tipo_pagamento = t.cd_tipo_pagamento AND m.tp_associado_empresa = t.tp_associado_empresa AND m.cd_tipo_parcela = t.cd_tipo_parcela AND m.tp_associado_empresa = 2 AND m.cd_tipo_recebimento > 2  '
      SET @sql = @sql + ' AND Isnull(m.dt_vencimento_new, m.dt_vencimento) >= ''' + cast( @dt_inicio as varchar) + ''' AND Isnull(m.dt_vencimento_new, m.dt_vencimento) <= ''' + cast(@dt_fim as varchar) + ''''
      
      --centro de custo
      IF (@cd_centro_custo = '0') SET @sql = @sql + ' AND a.cd_centro_custo >= 0 AND a.cd_centro_custo <= 9999 '
      ELSE SET @sql = @sql + ' AND a.cd_centro_custo IN (' + @cd_centro_custo  + ') '
      -- tipo empresa
      IF (@tp_empresa = '0') SET @sql = @sql + ' AND a.tp_empresa >= 0 AND a.tp_empresa <= 9999 '
      ELSE SET @sql = @sql + ' AND a.tp_empresa IN (' + @tp_empresa + ') '

      SET @sql = @sql + ' AND m.dt_pagamento <= DATEADD(M, -1, Isnull(m.dt_vencimento_new, m.dt_vencimento)) '

      SET @sql = @sql + ' GROUP  BY m.cd_tipo_pagamento, m.tp_associado_empresa, m.cd_tipo_parcela'

      SET @sql = @sql + ' OPEN cursor_adiantado '
      SET @sql = @sql + ' FETCH next FROM cursor_adiantado INTO @tp_pagamento, @tp, @fp, @Valor, @vl_atrasados, @Qtde '
      SET @sql = @sql + ' WHILE ( @@FETCH_STATUS <> -1 ) BEGIN '
      SET @sql = @sql + ' UPDATE Inadiplentes SET RecebidoAdiantadoValor = RecebidoAdiantadoValor + @Valor, RecebidoAdiantadoQtd = RecebidoAdiantadoQtd + @Qtde '
      SET @sql = @sql + ' WHERE  cd_tipo_pagamento = @tp_pagamento AND tp_associado_empresa = @tp AND cd_tipo_parcela = @fp '
      SET @sql = @sql + ' FETCH next FROM cursor_adiantado INTO @tp_pagamento, @tp, @fp, @Valor, @vl_atrasados, @Qtde END '

      SET @sql = @sql + ' CLOSE cursor_adiantado '
      SET @sql = @sql + ' DEALLOCATE cursor_adiantado '

      /******************************/
      /* RECEBIDO ATÉ O VENCIMENTO  */
      /******************************/  
      SET @sql = @sql + ' DECLARE cursor_recebidoateovencimento CURSOR FOR  '
      SET @sql = @sql + ' SELECT m.cd_tipo_pagamento, m.tp_associado_empresa, m.cd_tipo_parcela, Sum(Isnull(m.vl_pago, 0)), NULL AS diferenca, Count(0) '
      SET @sql = @sql + ' FROM mensalidades AS m, associados AS a, empresa AS e, Inadiplentes  AS t '
      SET @sql = @sql + ' WHERE m.cd_associado_empresa = a.cd_associado AND m.cd_tipo_pagamento = t.cd_tipo_pagamento AND m.tp_associado_empresa = t.tp_associado_empresa AND m.cd_tipo_parcela = t.cd_tipo_parcela AND a.cd_empresa = e.cd_empresa AND m.tp_associado_empresa = 1 AND m.cd_tipo_recebimento > 2  '
      SET @sql = @sql + ' AND Isnull(m.dt_vencimento_new, m.dt_vencimento) >= ''' + cast( @dt_inicio as varchar) + ''' AND Isnull(m.dt_vencimento_new, m.dt_vencimento) <= ''' + cast(@dt_fim as varchar) + ''''
      
      IF (@cd_centro_custo = '0') SET @sql = @sql + ' AND e.cd_centro_custo >= 0 AND e.cd_centro_custo <= 9999 '
      ELSE SET @sql = @sql + ' AND e.cd_centro_custo IN (' + @cd_centro_custo  + ') '
        
      IF (@tp_empresa = '0') SET @sql = @sql + ' AND e.tp_empresa >= 0 AND e.tp_empresa <= 9999 '
      ELSE SET @sql = @sql + ' AND e.tp_empresa IN (' + @tp_empresa  + ') '

      SET @sql = @sql + ' AND m.dt_pagamento <= Isnull(m.dt_vencimento_new, m.dt_vencimento) '
      SET @sql = @sql + ' GROUP  BY m.cd_tipo_pagamento, m.tp_associado_empresa, m.cd_tipo_parcela '

      SET @sql = @sql + ' UNION '

      SET @sql = @sql + ' SELECT m.cd_tipo_pagamento, m.tp_associado_empresa, m.cd_tipo_parcela, Sum(Isnull(m.vl_pago, 0)), NULL AS diferenca, Count(0) '
      SET @sql = @sql + ' FROM mensalidades AS m, empresa AS a, Inadiplentes  AS t '
      SET @sql = @sql + ' WHERE m.cd_associado_empresa = a.cd_empresa AND m.cd_tipo_pagamento = t.cd_tipo_pagamento AND m.tp_associado_empresa = t.tp_associado_empresa AND m.cd_tipo_parcela = t.cd_tipo_parcela AND m.tp_associado_empresa = 2 AND m.cd_tipo_recebimento > 2  '
      SET @sql = @sql + ' AND Isnull(m.dt_vencimento_new, m.dt_vencimento) >= ''' + cast( @dt_inicio as varchar) + ''' AND Isnull(m.dt_vencimento_new, m.dt_vencimento) <= ''' + cast(@dt_fim as varchar) + ''''
      
      --centro de custo
      IF (@cd_centro_custo = '0') SET @sql = @sql + ' AND a.cd_centro_custo >= 0 AND a.cd_centro_custo <= 9999 '
      ELSE SET @sql = @sql + ' AND a.cd_centro_custo IN (' + @cd_centro_custo  + ') '
      -- tipo empresa
      IF (@tp_empresa = '0') SET @sql = @sql + ' AND a.tp_empresa >= 0 AND a.tp_empresa <= 9999 '
      ELSE SET @sql = @sql + ' AND a.tp_empresa IN (' + @tp_empresa + ') '

      SET @sql = @sql + ' AND m.dt_pagamento <= Isnull(m.dt_vencimento_new, m.dt_vencimento) '

      SET @sql = @sql + ' GROUP  BY m.cd_tipo_pagamento, m.tp_associado_empresa, m.cd_tipo_parcela '

      SET @sql = @sql + ' OPEN cursor_recebidoateovencimento '
      SET @sql = @sql + ' FETCH next FROM cursor_recebidoateovencimento INTO @tp_pagamento, @tp, @fp, @Valor, @vl_atrasados, @Qtde '

      SET @sql = @sql + ' WHILE ( @@FETCH_STATUS <> -1 ) BEGIN '
      SET @sql = @sql + ' UPDATE Inadiplentes '
      SET @sql = @sql + ' SET RecebidoateoVencimentoValor = RecebidoateoVencimentoValor + Isnull(@Valor, 0), RecebidoateoVencimentoQtd = RecebidoateoVencimentoQtd + Isnull(@Qtde, 0) '
      SET @sql = @sql + ' WHERE  cd_tipo_pagamento = @tp_pagamento AND tp_associado_empresa = @tp AND cd_tipo_parcela = @fp '

      SET @sql = @sql + ' FETCH next FROM cursor_recebidoateovencimento INTO @tp_pagamento, @tp, @fp, @Valor, @vl_atrasados, @Qtde END '

      SET @sql = @sql + ' CLOSE cursor_recebidoateovencimento '
      SET @sql = @sql + ' DEALLOCATE cursor_recebidoateovencimento '

      /******************************/
      /*    RECEBIDO ATRASADO      */
      /******************************/ 
      SET @sql = @sql + ' DECLARE cursor_recebidoatrasado CURSOR FOR '
      SET @sql = @sql + ' SELECT m.cd_tipo_pagamento, m.tp_associado_empresa, m.cd_tipo_parcela, Sum(Isnull(m.vl_pago, 0)), NULL AS diferenca, Count(0)'
      SET @sql = @sql + ' FROM mensalidades AS m, associados AS a, empresa AS e, Inadiplentes AS t'
      SET @sql = @sql + ' WHERE m.cd_associado_empresa = a.cd_associado AND m.cd_tipo_pagamento = t.cd_tipo_pagamento AND m.tp_associado_empresa = t.tp_associado_empresa AND m.cd_tipo_parcela = t.cd_tipo_parcela AND a.cd_empresa = e.cd_empresa AND m.tp_associado_empresa = 1 AND m.cd_tipo_recebimento > 2  '
      SET @sql = @sql + ' AND m.dt_vencimento >= ''' + cast( @dt_inicio as varchar) + ''' AND m.dt_vencimento <= ''' + cast(@dt_fim as varchar) + ''''
      
      IF (@cd_centro_custo = '0') SET @sql = @sql + ' AND e.cd_centro_custo >= 0 AND e.cd_centro_custo <= 9999 '
      ELSE SET @sql = @sql + ' AND e.cd_centro_custo IN (' + @cd_centro_custo  + ') '
        
      IF (@tp_empresa = '0') SET @sql = @sql + ' AND e.tp_empresa >= 0 AND e.tp_empresa <= 9999 '
      ELSE SET @sql = @sql + ' AND e.tp_empresa IN (' + @tp_empresa  + ') '
		
	  SET @sql = @sql + ' AND m.dt_pagamento > Isnull(m.dt_vencimento_new, m.dt_vencimento) '
      SET @sql = @sql + 'GROUP  BY m.cd_tipo_pagamento, m.tp_associado_empresa, m.cd_tipo_parcela '

      SET @sql = @sql + 'UNION '

      SET @sql = @sql + 'SELECT m.cd_tipo_pagamento, m.tp_associado_empresa, m.cd_tipo_parcela, Sum(Isnull(m.vl_pago, 0)), NULL AS diferenca, Count(0)'
      SET @sql = @sql + 'FROM mensalidades AS m, empresa AS a, Inadiplentes AS t'
      SET @sql = @sql + ' WHERE m.cd_associado_empresa = a.cd_empresa AND m.cd_tipo_pagamento = t.cd_tipo_pagamento AND m.tp_associado_empresa = t.tp_associado_empresa AND m.cd_tipo_parcela = t.cd_tipo_parcela AND m.tp_associado_empresa = 2 AND m.cd_tipo_recebimento > 2  '
      SET @sql = @sql + ' AND m.dt_vencimento >= ''' + cast( @dt_inicio as varchar) + ''' AND m.dt_vencimento <= ''' + cast(@dt_fim as varchar) + ''''
      
      --centro de custo
      IF (@cd_centro_custo = '0') SET @sql = @sql + ' AND a.cd_centro_custo >= 0 AND a.cd_centro_custo <= 9999 '
      ELSE SET @sql = @sql + ' AND a.cd_centro_custo IN (' + @cd_centro_custo  + ') '
      -- tipo empresa
      IF (@tp_empresa = '0') SET @sql = @sql + ' AND a.tp_empresa >= 0 AND a.tp_empresa <= 9999 '
      ELSE SET @sql = @sql + ' AND a.tp_empresa IN (' + @tp_empresa + ') '

      SET @sql = @sql + ' AND m.dt_pagamento > Isnull(m.dt_vencimento_new, m.dt_vencimento) '
      SET @sql = @sql + 'GROUP BY m.cd_tipo_pagamento, m.tp_associado_empresa, m.cd_tipo_parcela '

      SET @sql = @sql + 'OPEN cursor_recebidoatrasado '

      SET @sql = @sql + 'FETCH next FROM cursor_recebidoatrasado INTO @tp_pagamento, @tp, @fp, @Valor, @vl_atrasados, @Qtde '

      SET @sql = @sql + 'WHILE ( @@FETCH_STATUS <> -1 ) '
      SET @sql = @sql + 'BEGIN UPDATE Inadiplentes '
      SET @sql = @sql + 'SET RecebidoAtrasadoValor = RecebidoAtrasadoValor + Isnull(@Valor, 0), RecebidoAtrasadoQtd = RecebidoAtrasadoQtd + Isnull(@Qtde, 0)'
      SET @sql = @sql + 'WHERE  cd_tipo_pagamento = @tp_pagamento AND tp_associado_empresa = @tp AND cd_tipo_parcela = @fp '

      SET @sql = @sql + 'FETCH next FROM cursor_recebidoatrasado INTO @tp_pagamento, @tp, @fp, @Valor, @vl_atrasados, @Qtde END '

      SET @sql = @sql + 'CLOSE cursor_recebidoatrasado '
      SET @sql = @sql + 'DEALLOCATE cursor_recebidoatrasado '

      /******************************/
      /* RECEBIDO ATÉ 30 DIAS  */
      /******************************/   
      SET @sql = @sql + ' DECLARE cursor_recebido30dias CURSOR FOR  '
      
      SET @sql = @sql + ' SELECT m.cd_tipo_pagamento, m.tp_associado_empresa, m.cd_tipo_parcela, Sum(Isnull(m.vl_pago, 0)), NULL AS diferenca, Count(0)'
      SET @sql = @sql + ' FROM mensalidades AS m, associados AS a, empresa AS e, Inadiplentes AS t'
      SET @sql = @sql + ' WHERE m.cd_associado_empresa = a.cd_associado AND m.cd_tipo_pagamento = t.cd_tipo_pagamento AND m.tp_associado_empresa = t.tp_associado_empresa AND m.cd_tipo_parcela = t.cd_tipo_parcela AND a.cd_empresa = e.cd_empresa AND m.tp_associado_empresa = 1 AND m.cd_tipo_recebimento > 2  '
      SET @sql = @sql + ' AND m.dt_vencimento >= ''' + cast( @dt_inicio as varchar) + ''' AND m.dt_vencimento <= ''' + cast(@dt_fim as varchar) + ''''
      
      IF (@cd_centro_custo = '0') SET @sql = @sql + ' AND e.cd_centro_custo >= 0 AND e.cd_centro_custo <= 9999 '
      ELSE SET @sql = @sql + ' AND e.cd_centro_custo IN (' + @cd_centro_custo  + ') '
        
      IF (@tp_empresa = '0') SET @sql = @sql + ' AND e.tp_empresa >= 0 AND e.tp_empresa <= 9999 '
      ELSE SET @sql = @sql + ' AND e.tp_empresa IN (' + @tp_empresa  + ') '
	  
	  SET @sql = @sql + ' AND m.dt_pagamento > Isnull(m.dt_vencimento_new, m.dt_vencimento) '
	  SET @sql = @sql + ' AND DATEDIFF(DAY, m.dt_vencimento, m.dt_pagamento) > 0 AND DATEDIFF(DAY, m.dt_vencimento, m.dt_pagamento) <= 30'
      SET @sql = @sql + ' GROUP  BY m.cd_tipo_pagamento, m.tp_associado_empresa, m.cd_tipo_parcela '

      SET @sql = @sql + ' UNION '

      SET @sql = @sql + ' SELECT m.cd_tipo_pagamento, m.tp_associado_empresa, m.cd_tipo_parcela, Sum(Isnull(m.vl_pago, 0)), NULL AS diferenca, Count(0)'
      SET @sql = @sql + ' FROM mensalidades AS m, empresa AS a, Inadiplentes AS t'
      SET @sql = @sql + ' WHERE m.cd_associado_empresa = a.cd_empresa AND m.cd_tipo_pagamento = t.cd_tipo_pagamento AND m.tp_associado_empresa = t.tp_associado_empresa AND m.cd_tipo_parcela = t.cd_tipo_parcela AND m.tp_associado_empresa = 2 AND m.cd_tipo_recebimento > 2  '
      SET @sql = @sql + ' AND m.dt_vencimento >= ''' + cast( @dt_inicio as varchar) + ''' AND m.dt_vencimento <= ''' + cast(@dt_fim as varchar) + ''''
      
      --centro de custo
      IF (@cd_centro_custo = '0') SET @sql = @sql + ' AND a.cd_centro_custo >= 0 AND a.cd_centro_custo <= 9999 '
      ELSE SET @sql = @sql + ' AND a.cd_centro_custo IN (' + @cd_centro_custo  + ') '
      -- tipo empresa
      IF (@tp_empresa = '0') SET @sql = @sql + ' AND a.tp_empresa >= 0 AND a.tp_empresa <= 9999 '
      ELSE SET @sql = @sql + ' AND a.tp_empresa IN (' + @tp_empresa + ') '

      SET @sql = @sql + ' AND m.dt_pagamento > Isnull(m.dt_vencimento_new, m.dt_vencimento) '
      SET @sql = @sql + ' AND DATEDIFF(DAY, m.dt_vencimento, m.dt_pagamento) > 0 AND DATEDIFF(DAY, m.dt_vencimento, m.dt_pagamento) <= 30'
      SET @sql = @sql + ' GROUP BY m.cd_tipo_pagamento, m.tp_associado_empresa, m.cd_tipo_parcela  '

      SET @sql = @sql + ' OPEN cursor_recebido30dias  '
      SET @sql = @sql + ' FETCH next FROM cursor_recebido30dias INTO @tp_pagamento, @tp, @fp, @Valor, @vl_atrasados, @Qtde  '

      SET @sql = @sql + ' WHILE ( @@FETCH_STATUS <> -1 ) BEGIN  '
      SET @sql = @sql + ' UPDATE Inadiplentes  '
      SET @sql = @sql + ' SET    Recebidoate30diasValor = Recebidoate30diasValor + Isnull(@Valor, 0), Recebidoate30diasQtd = Recebidoate30diasQtd + Isnull(@Qtde, 0)  '
      SET @sql = @sql + ' WHERE  cd_tipo_pagamento = @tp_pagamento AND tp_associado_empresa = @tp AND cd_tipo_parcela = @fp  '

      SET @sql = @sql + ' FETCH next FROM cursor_recebido30dias INTO @tp_pagamento, @tp, @fp, @Valor, @vl_atrasados, @Qtde END  '

      SET @sql = @sql + ' CLOSE cursor_recebido30dias '
      SET @sql = @sql + ' DEALLOCATE cursor_recebido30dias '

      /******************************/
      /* RECEBIDO ATÉ 60 DIAS  */
      /******************************/
      SET @sql = @sql + ' DECLARE cursor_recebido60dias CURSOR FOR  '
      
      SET @sql = @sql + ' SELECT m.cd_tipo_pagamento, m.tp_associado_empresa, m.cd_tipo_parcela, Sum(Isnull(m.vl_pago, 0)), NULL AS diferenca, Count(0)'
      SET @sql = @sql + ' FROM mensalidades AS m, associados AS a, empresa AS e, Inadiplentes AS t'
      SET @sql = @sql + ' WHERE m.cd_associado_empresa = a.cd_associado AND m.cd_tipo_pagamento = t.cd_tipo_pagamento AND m.tp_associado_empresa = t.tp_associado_empresa AND m.cd_tipo_parcela = t.cd_tipo_parcela AND a.cd_empresa = e.cd_empresa AND m.tp_associado_empresa = 1 AND m.cd_tipo_recebimento > 2  '
      SET @sql = @sql + ' AND m.dt_vencimento >= ''' + cast( @dt_inicio as varchar) + ''' AND m.dt_vencimento <= ''' + cast(@dt_fim as varchar) + ''''
      
      IF (@cd_centro_custo = '0') SET @sql = @sql + ' AND e.cd_centro_custo >= 0 AND e.cd_centro_custo <= 9999 '
      ELSE SET @sql = @sql + ' AND e.cd_centro_custo IN (' + @cd_centro_custo  + ') '
        
      IF (@tp_empresa = '0') SET @sql = @sql + ' AND e.tp_empresa >= 0 AND e.tp_empresa <= 9999 '
      ELSE SET @sql = @sql + ' AND e.tp_empresa IN (' + @tp_empresa  + ') '

	  SET @sql = @sql + ' AND DATEDIFF(DAY, m.dt_vencimento, m.dt_pagamento) > 30 AND DATEDIFF(DAY, m.dt_vencimento, m.dt_pagamento) <= 60'
	  SET @sql = @sql + ' AND m.dt_pagamento > Isnull(m.dt_vencimento_new, m.dt_vencimento) '
      SET @sql = @sql + ' GROUP  BY m.cd_tipo_pagamento, m.tp_associado_empresa, m.cd_tipo_parcela '

      SET @sql = @sql + ' UNION '

      SET @sql = @sql + ' SELECT m.cd_tipo_pagamento, m.tp_associado_empresa, m.cd_tipo_parcela, Sum(Isnull(m.vl_pago, 0)), NULL AS diferenca, Count(0)'
      SET @sql = @sql + ' FROM mensalidades AS m, empresa AS a, Inadiplentes AS t'
      SET @sql = @sql + ' WHERE m.cd_associado_empresa = a.cd_empresa AND m.cd_tipo_pagamento = t.cd_tipo_pagamento AND m.tp_associado_empresa = t.tp_associado_empresa AND m.cd_tipo_parcela = t.cd_tipo_parcela AND m.tp_associado_empresa = 2 AND m.cd_tipo_recebimento > 2  '
      SET @sql = @sql + ' AND m.dt_vencimento >= ''' + cast( @dt_inicio as varchar) + ''' AND m.dt_vencimento <= ''' + cast(@dt_fim as varchar) + ''''
      
      --centro de custo
      IF (@cd_centro_custo = '0') SET @sql = @sql + ' AND a.cd_centro_custo >= 0 AND a.cd_centro_custo <= 9999 '
      ELSE SET @sql = @sql + ' AND a.cd_centro_custo IN (' + @cd_centro_custo  + ') '
      -- tipo empresa
      IF (@tp_empresa = '0') SET @sql = @sql + ' AND a.tp_empresa >= 0 AND a.tp_empresa <= 9999 '
      ELSE SET @sql = @sql + ' AND a.tp_empresa IN (' + @tp_empresa + ') '

      SET @sql = @sql + ' AND m.dt_pagamento > Isnull(m.dt_vencimento_new, m.dt_vencimento) '
      SET @sql = @sql + ' AND DATEDIFF(DAY, m.dt_vencimento, m.dt_pagamento) > 30 AND DATEDIFF(DAY, m.dt_vencimento, m.dt_pagamento) <= 60'
      SET @sql = @sql + ' GROUP BY m.cd_tipo_pagamento, m.tp_associado_empresa, m.cd_tipo_parcela  '

      SET @sql = @sql + ' OPEN cursor_recebido60dias  '

      SET @sql = @sql + ' FETCH next FROM cursor_recebido60dias INTO @tp_pagamento, @tp, @fp, @Valor, @vl_atrasados, @Qtde  '

      SET @sql = @sql + ' WHILE ( @@FETCH_STATUS <> -1 ) BEGIN  '
      SET @sql = @sql + ' UPDATE Inadiplentes  '
      SET @sql = @sql + ' SET Recebidoate60diasValor = Recebidoate60diasValor + Isnull(@Valor, 0), Recebidoate60diasQtd = Recebidoate60diasQtd + Isnull(@Qtde, 0)  '
      SET @sql = @sql + ' WHERE  cd_tipo_pagamento = @tp_pagamento AND tp_associado_empresa = @tp AND cd_tipo_parcela = @fp  '

      SET @sql = @sql + ' FETCH next FROM cursor_recebido60dias INTO @tp_pagamento, @tp, @fp, @Valor, @vl_atrasados, @Qtde END  '

      SET @sql = @sql + ' CLOSE cursor_recebido60dias  '
      SET @sql = @sql + ' DEALLOCATE cursor_recebido60dias '

      /******************************/
      /* RECEBIDO ATÉ 90 DIAS  */
      /******************************/
      SET @sql = @sql + ' DECLARE cursor_recebido90dias CURSOR FOR '
      
      SET @sql = @sql + ' SELECT m.cd_tipo_pagamento, m.tp_associado_empresa, m.cd_tipo_parcela, Sum(Isnull(m.vl_pago, 0)), NULL AS diferenca, Count(0)'
      SET @sql = @sql + ' FROM mensalidades AS m, associados AS a, empresa AS e, Inadiplentes AS t'
      SET @sql = @sql + ' WHERE m.cd_associado_empresa = a.cd_associado AND m.cd_tipo_pagamento = t.cd_tipo_pagamento AND m.tp_associado_empresa = t.tp_associado_empresa AND m.cd_tipo_parcela = t.cd_tipo_parcela AND a.cd_empresa = e.cd_empresa AND m.tp_associado_empresa = 1 AND m.cd_tipo_recebimento > 2  '
      SET @sql = @sql + ' AND m.dt_vencimento >= ''' + cast( @dt_inicio as varchar) + ''' AND m.dt_vencimento <= ''' + cast(@dt_fim as varchar) + ''''
      
      IF (@cd_centro_custo = '0') SET @sql = @sql + ' AND e.cd_centro_custo >= 0 AND e.cd_centro_custo <= 9999 '
      ELSE SET @sql = @sql + ' AND e.cd_centro_custo IN (' + @cd_centro_custo  + ') '
        
      IF (@tp_empresa = '0') SET @sql = @sql + ' AND e.tp_empresa >= 0 AND e.tp_empresa <= 9999 '
      ELSE SET @sql = @sql + ' AND e.tp_empresa IN (' + @tp_empresa  + ') '

	  SET @sql = @sql + ' AND DATEDIFF(DAY, m.dt_vencimento, m.dt_pagamento) > 60 AND DATEDIFF(DAY, m.dt_vencimento, m.dt_pagamento) <= 90'
	  SET @sql = @sql + ' AND m.dt_pagamento > Isnull(m.dt_vencimento_new, m.dt_vencimento) '
      SET @sql = @sql + ' GROUP  BY m.cd_tipo_pagamento, m.tp_associado_empresa, m.cd_tipo_parcela '

      SET @sql = @sql + ' UNION '

      SET @sql = @sql + ' SELECT m.cd_tipo_pagamento, m.tp_associado_empresa, m.cd_tipo_parcela, Sum(Isnull(m.vl_pago, 0)), NULL AS diferenca, Count(0)'
      SET @sql = @sql + ' FROM mensalidades AS m, empresa AS a, Inadiplentes AS t'
      SET @sql = @sql + ' WHERE m.cd_associado_empresa = a.cd_empresa AND m.cd_tipo_pagamento = t.cd_tipo_pagamento AND m.tp_associado_empresa = t.tp_associado_empresa AND m.cd_tipo_parcela = t.cd_tipo_parcela AND m.tp_associado_empresa = 2 AND m.cd_tipo_recebimento > 2  '
      SET @sql = @sql + ' AND m.dt_vencimento >= ''' + cast( @dt_inicio as varchar) + ''' AND m.dt_vencimento <= ''' + cast(@dt_fim as varchar) + ''''
      
      --centro de custo
      IF (@cd_centro_custo = '0') SET @sql = @sql + ' AND a.cd_centro_custo >= 0 AND a.cd_centro_custo <= 9999 '
      ELSE SET @sql = @sql + ' AND a.cd_centro_custo IN (' + @cd_centro_custo  + ') '
      -- tipo empresa
      IF (@tp_empresa = '0') SET @sql = @sql + ' AND a.tp_empresa >= 0 AND a.tp_empresa <= 9999 '
      ELSE SET @sql = @sql + ' AND a.tp_empresa IN (' + @tp_empresa + ') '

      SET @sql = @sql + ' AND m.dt_pagamento > Isnull(m.dt_vencimento_new, m.dt_vencimento) '
      SET @sql = @sql + ' AND DATEDIFF(DAY, m.dt_vencimento, m.dt_pagamento) > 60 AND DATEDIFF(DAY, m.dt_vencimento, m.dt_pagamento) <= 90'
      SET @sql = @sql + ' GROUP BY m.cd_tipo_pagamento, m.tp_associado_empresa, m.cd_tipo_parcela  '

      SET @sql = @sql + ' OPEN cursor_recebido90dias '

      SET @sql = @sql + ' FETCH next FROM cursor_recebido90dias INTO @tp_pagamento, @tp, @fp, @Valor, @vl_atrasados, @Qtde  '

      SET @sql = @sql + ' WHILE ( @@FETCH_STATUS <> -1 ) BEGIN '
      SET @sql = @sql + ' UPDATE Inadiplentes '
      SET @sql = @sql + ' SET Recebidoate90diasValor = Recebidoate90diasValor + Isnull(@Valor, 0), Recebidoate90diasQtd = Recebidoate90diasQtd + Isnull(@Qtde, 0) '
      SET @sql = @sql + ' WHERE  cd_tipo_pagamento = @tp_pagamento AND tp_associado_empresa = @tp AND cd_tipo_parcela = @fp '

      SET @sql = @sql + ' FETCH next FROM cursor_recebido90dias INTO @tp_pagamento, @tp, @fp, @Valor, @vl_atrasados, @Qtde END '

      SET @sql = @sql + ' CLOSE cursor_recebido90dias '
      SET @sql = @sql + ' DEALLOCATE cursor_recebido90dias '

      /******************************/
      /* RECEBIDO ATÉ 120 DIAS  */
      /******************************/
      SET @sql = @sql + ' DECLARE cursor_recebido120dias CURSOR FOR '
      
      SET @sql = @sql + ' SELECT m.cd_tipo_pagamento, m.tp_associado_empresa, m.cd_tipo_parcela, Sum(Isnull(m.vl_pago, 0)), NULL AS diferenca, Count(0)'
      SET @sql = @sql + ' FROM mensalidades AS m, associados AS a, empresa AS e, Inadiplentes AS t'
      SET @sql = @sql + ' WHERE m.cd_associado_empresa = a.cd_associado AND m.cd_tipo_pagamento = t.cd_tipo_pagamento AND m.tp_associado_empresa = t.tp_associado_empresa AND m.cd_tipo_parcela = t.cd_tipo_parcela AND a.cd_empresa = e.cd_empresa AND m.tp_associado_empresa = 1 AND m.cd_tipo_recebimento > 2  '
      SET @sql = @sql + ' AND m.dt_vencimento >= ''' + cast( @dt_inicio as varchar) + ''' AND m.dt_vencimento <= ''' + cast(@dt_fim as varchar) + ''''
      
      IF (@cd_centro_custo = '0') SET @sql = @sql + ' AND e.cd_centro_custo >= 0 AND e.cd_centro_custo <= 9999 '
      ELSE SET @sql = @sql + ' AND e.cd_centro_custo IN (' + @cd_centro_custo  + ') '
        
      IF (@tp_empresa = '0') SET @sql = @sql + ' AND e.tp_empresa >= 0 AND e.tp_empresa <= 9999 '
      ELSE SET @sql = @sql + ' AND e.tp_empresa IN (' + @tp_empresa  + ') '

	  SET @sql = @sql + ' AND DATEDIFF(DAY, m.dt_vencimento, m.dt_pagamento) > 90 AND DATEDIFF(DAY, m.dt_vencimento, m.dt_pagamento) <= 120'
	  SET @sql = @sql + ' AND m.dt_pagamento > Isnull(m.dt_vencimento_new, m.dt_vencimento) '
      SET @sql = @sql + ' GROUP  BY m.cd_tipo_pagamento, m.tp_associado_empresa, m.cd_tipo_parcela '

      SET @sql = @sql + ' UNION '

      SET @sql = @sql + ' SELECT m.cd_tipo_pagamento, m.tp_associado_empresa, m.cd_tipo_parcela, Sum(Isnull(m.vl_pago, 0)), NULL AS diferenca, Count(0)'
      SET @sql = @sql + ' FROM mensalidades AS m, empresa AS a, Inadiplentes AS t'
      SET @sql = @sql + ' WHERE m.cd_associado_empresa = a.cd_empresa AND m.cd_tipo_pagamento = t.cd_tipo_pagamento AND m.tp_associado_empresa = t.tp_associado_empresa AND m.cd_tipo_parcela = t.cd_tipo_parcela AND m.tp_associado_empresa = 2 AND m.cd_tipo_recebimento > 2  '
      SET @sql = @sql + ' AND m.dt_vencimento >= ''' + cast( @dt_inicio as varchar) + ''' AND m.dt_vencimento <= ''' + cast(@dt_fim as varchar) + ''''
      
      --centro de custo
      IF (@cd_centro_custo = '0') SET @sql = @sql + ' AND a.cd_centro_custo >= 0 AND a.cd_centro_custo <= 9999 '
      ELSE SET @sql = @sql + ' AND a.cd_centro_custo IN (' + @cd_centro_custo  + ') '
      -- tipo empresa
      IF (@tp_empresa = '0') SET @sql = @sql + ' AND a.tp_empresa >= 0 AND a.tp_empresa <= 9999 '
      ELSE SET @sql = @sql + ' AND a.tp_empresa IN (' + @tp_empresa + ') '

      SET @sql = @sql + ' AND m.dt_pagamento > Isnull(m.dt_vencimento_new, m.dt_vencimento) '
      SET @sql = @sql + ' AND DATEDIFF(DAY, m.dt_vencimento, m.dt_pagamento) > 90 AND DATEDIFF(DAY, m.dt_vencimento, m.dt_pagamento) <= 120'
      SET @sql = @sql + ' GROUP BY m.cd_tipo_pagamento, m.tp_associado_empresa, m.cd_tipo_parcela  '

      SET @sql = @sql + ' OPEN cursor_recebido120dias  '
      SET @sql = @sql + ' FETCH next FROM cursor_recebido120dias INTO @tp_pagamento, @tp, @fp, @Valor, @vl_atrasados, @Qtde  '

      SET @sql = @sql + ' WHILE ( @@FETCH_STATUS <> -1 ) BEGIN  '
      SET @sql = @sql + ' UPDATE Inadiplentes  '
      SET @sql = @sql + ' SET Recebidoate120diasValor = Recebidoate120diasValor + Isnull(@Valor, 0), Recebidoate120diasQtd = Recebidoate120diasQtd + Isnull(@Qtde, 0)  '
      SET @sql = @sql + ' WHERE  cd_tipo_pagamento = @tp_pagamento AND tp_associado_empresa = @tp AND cd_tipo_parcela = @fp  '

      SET @sql = @sql + ' FETCH next FROM cursor_recebido120dias INTO @tp_pagamento, @tp, @fp, @Valor, @vl_atrasados, @Qtde END  '

      SET @sql = @sql + ' CLOSE cursor_recebido120dias  '
      SET @sql = @sql + ' DEALLOCATE cursor_recebido120dias  '

      EXEC(@sql)
      --SELECT @sql
      

      DELETE 
      Inadiplentes

      WHERE  
      FaturadoQtd = 0 
      AND RecebidodoMesQtd = 0 
      AND RecebidoAdiantadoQtd = 0 
      AND RecebidoateoVencimentoQtd = 0 
      AND RecebidoAtrasadoQtd = 0 
      AND Recebidoate30diasQtd = 0 
      AND Recebidoate60diasQtd = 0 
      AND Recebidoate90diasQtd = 0 
      AND Recebidoate120diasQtd = 0 
    

  END 
