/****** Object:  Procedure [dbo].[SP_FaturamentoGeraBI]    Committed by VersionSQL https://www.versionsql.com ******/

create PROCEDURE [dbo].[SP_FaturamentoGeraBI]
	@dataInicial VARCHAR(10),
	@dataFinal VARCHAR(10)
AS
BEGIN
	DECLARE @dt_i DATE
	DECLARE @dt_f DATEtime
	DECLARE @i INT = 1 
	DECLARE @SQL VARCHAR(MAX)

	--CONVERTENDO DATAS DE ENTRADA
	SET @dt_i = CONVERT(DATETIME, @dataInicial, 103)
	SET @dt_f = CONVERT(DATETIME, @dataFinal, 103) + ' 23:59'
	
	print @dt_i
	print @dt_f

	--DELETA TABELA EXISTENTE PARA ATUALIZAÇÃO
	DELETE S4EBI..comercial

	--INSERE DADOS NA TABELA
	INSERT S4EBI..comercial (
		  Lote, dt_assinaturaContrato, cd_sequencial_Dep, Usuario, cd_associado,Responsavel,
		  cd_plano,Plano, orto, tp_empresa, ds_empresa, 		  
		  cd_funcionario, Vendedor, cd_tipo_pagamento, TipoPagamento,
		  cd_centro_custo, ds_centro_custo,
		  Valor, cd_grau_parentesco)

	SELECT l.cd_sequencial_lote, l.dt_assinaturaContrato , d.cd_sequencial , d.nm_dependente,  
        a.cd_associado , a.nm_completo, 
        p.cd_plano , p.nm_plano , CASE WHEN p.fl_exige_dentista=1 THEN 1 ELSE 0 END AS Orto , 
        t.tp_empresa, t.ds_empresa , 
        f.cd_funcionario , f.nm_empregado, 
        tp.cd_tipo_pagamento, tp.nm_tipo_pagamento , 
        CASE WHEN e.TP_EMPRESA=3 THEN CC_Ass.cd_centro_custo ELSE cc_e.cd_centro_custo END AS cod_cc, 
        CASE WHEN e.TP_EMPRESA=3 THEN CC_Ass.ds_centro_custo ELSE cc_e.ds_centro_custo END AS desc_cc, 
        l.vl_contrato , d.cd_grau_parentesco 
	FROM lote_contratos_contratos_vendedor AS l 
        INNER JOIN lote_contratos lc ON l.cd_sequencial_lote = lc.cd_sequencial  
        INNER JOIN DEPENDENTES AS d ON l.cd_sequencial_dep = d.CD_SEQUENCIAL 
        INNER JOIN PLANOS AS p ON  d.cd_plano = p.cd_plano  
        INNER JOIN ASSOCIADOS AS a ON d.CD_ASSOCIADO = a.cd_associado
        INNER JOIN EMPRESA AS e ON a.cd_empresa = e.CD_EMPRESA  
        INNER JOIN TIPO_EMPRESA AS t ON e.tp_empresa = t.tp_empresa 
        INNER JOIN tipo_pagamento as tp on e.cd_tipo_pagamento = tp.cd_tipo_pagamento 
         LEFT JOIN UF AS uf ON a.ufid = uf.ufid
         LEFT JOIN municipio AS mu ON a.cidid = mu.cd_municipio         
         LEFT JOIN funcionario f on d.cd_funcionario_vendedor = f.cd_funcionario 
        INNER JOIN Centro_Custo AS CC_e ON ISNULL(e.cd_centro_custo,1) = cc_e.cd_centro_custo
        INNER JOIN Centro_Custo AS CC_Ass ON ISNULL(mu.cd_centro_custo,1) = cc_ass.cd_centro_custo 
	WHERE l.dt_assinaturaContrato >=  @dt_i and l.dt_assinaturaContrato <= @dt_f
	-- Incluido aqui :: usado d
	AND (SELECT TOP 1 cd_situacao 
                        FROM historico WHERE cd_sequencial_dep = d.cd_sequencial 
                         AND dt_situacao >= @dt_i 
                         AND dt_situacao <=  @dt_f
                       ORDER BY CONVERT(DATE,dt_situacao) DESC, cd_sequencial DESC) IN (1,20)

	WHILE @i<=12
	BEGIN 

	   SET @SQL = ' update S4EBI..comercial 
		   Set vl_pago'+CONVERT(VARCHAR(2),@i)+'=x.vl 
		   from (
				select mp.cd_sequencial_dep as cd_sequencial_dep, sum(mp.valor) as vl
				from S4EBI..comercial as c, mensalidades as m , mensalidades_planos as mp 
			   where c.vl_pago'+CONVERT(VARCHAR(2),@i)+' is null
				 and c.cd_sequencial_Dep = mp.cd_sequencial_dep
				 and mp.cd_parcela_mensalidade = m.cd_parcela 
				 and mp.dt_exclusao is null 
				 and m.cd_tipo_recebimento > 2
				 and m.dt_pagamento is not null 
				 and m.cd_tipo_parcela<3
				 and m.dt_pagamento >= '''+CONVERT(VARCHAR(20),DATEADD(MONTH,@i,@dt_i),101)+''' 
				 and m.dt_pagamento <=  '''+CONVERT(VARCHAR(20),DATEADD(MONTH,@i,@dt_f),101)+''' 
			 group by mp.cd_sequencial_dep 
		   ) as x 
		where S4EBI..comercial.cd_sequencial_dep = x.cd_sequencial_dep'
    
		PRINT @SQL
		SET @i = @i + 1 
    
		EXEC(@SQL)
    
	END
END
