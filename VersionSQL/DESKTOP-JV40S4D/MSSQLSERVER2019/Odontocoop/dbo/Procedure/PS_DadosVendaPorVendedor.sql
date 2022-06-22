/****** Object:  Procedure [dbo].[PS_DadosVendaPorVendedor]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PS_DadosVendaPorVendedor] (

@DT_Inicial varchar(20),
@DT_Final varchar(20),
@CD_Equipe int,
@CD_Funcionario int,
@plano varchar (max),
@tipo_empresa varchar (max),
@tipo_pagamento varchar (max),
@cd_grupo_empresa int = -1,
@cd_centro_custo int = -1,
@situacao varchar (max),
@uf Int = -1,
@municipio Int = -1,
@tipoRecebimento varchar(1000) = ''

)
AS
BEGIN

DECLARE @configbusca tinyint
declare @SQL varchar(max)
SELECT TOP 1
  @ConfigBusca = tipo_DataVendaContrato
FROM Configuracao
set @SQL = ''
IF @ConfigBusca = 1
BEGIN
set @SQL += '  SELECT '
set @SQL += '    t1.cd_sequencial_lote, '
set @SQL += '   T1.dt_cadastro AS data, '
set @SQL += '    CONVERT(varchar(10), T1.dt_cadastro, 103) AS dt_cadastro, '
set @SQL += '    T2.cd_associado, '
set @SQL += '    T2.nm_completo, '
set @SQL += '    T3.nm_dependente, '
set @SQL += '    T1.vl_contrato, '
set @SQL += '    T5.nm_fantasia, '
set @SQL += '    t2.cd_empresa, '
set @SQL += '    T6.nm_plano, '
set @SQL += '    t3.cd_sequencial, '
set @SQL += '    t8.nm_situacao_historico, '
set @SQL += '     case when charindex('' '',t9.nm_empregado) > 0 then left(t9.nm_empregado,charindex('' '',t9.nm_empregado)-1) else t9.nm_empregado end as nm_empregado, '
set @SQL += '    T1.usuario_recebimento, convert(varchar(10), t1.data_horarecebimento, 103) + '' '' + convert(varchar(8), t1.data_horarecebimento, 108) DataHoraRecebimento '
set @SQL += '    , T11.depDescricao '
set @SQL += '    FROM Lote_Contratos_Contratos_Vendedor T1, UF AS uf, municipio AS mu, lote_contratos LC, '
set @SQL += '       Associados T2, '
set @SQL += '       Dependentes T3, '
set @SQL += '       empresa AS t5, '
set @SQL += '       Planos t6, '
set @SQL += '       Historico t7, '
set @SQL += '       Situacao_Historico t8, '
set @SQL += '       Funcionario t9, '         
set @SQL += '       Funcionario t10, '         
set @SQL += '       Departamento T11 '         
set @SQL += '  WHERE T1.dt_cadastro BETWEEN '''+convert(varchar(10),@DT_Inicial,101) +''' AND '''+ convert(varchar(10),@DT_Final,101)+ ' 23:59'''	  
set @SQL += '  AND T1.cd_sequencial_dep = T3.cd_sequencial '
set @SQL += '  AND T3.cd_associado = T2.cd_associado '
set @SQL += '  AND T2.cd_empresa = t5.cd_empresa '
set @SQL += '	 AND T2.cidid = mu.cd_municipio '
set @SQL += '	 AND T2.ufid = uf.ufid '	
set @SQL += '  AND t3.cd_plano = t6.cd_plano '
set @SQL += '  AND T3.cd_funcionario_vendedor = '+convert(varchar, @cd_funcionario)
set @SQL += '  AND T3.cd_funcionario_vendedor = T10.cd_funcionario '
set @SQL += '  AND t3.cd_sequencial_historico = t7.cd_sequencial '
set @SQL += '  AND t7.cd_situacao = t8.cd_situacao_historico '
set @SQL += '  and t1.usuario_recebimento = t9.cd_funcionario '
set @SQL += '  and T1.cd_sequencial_lote = LC.cd_sequencial '
set @SQL += '  And T2.depId = T11.depId '

if(@CD_Equipe > 0)
  begin
    set @SQL += ' And case when LC.cd_empresa is null then isnull(t10.cd_equipe,LC.cd_equipe) else t10.cd_equipe end = ' + convert(varchar,@CD_Equipe)
  end 

if (@uf<>-1)
begin
	set @SQL += ' And uf.ufid  = ' + convert(varchar,@uf )
end

if (@municipio<>-1)
begin
	set @SQL += 'And mu.cd_municipio = ' + convert(varchar,@municipio ) 
end		

if @plano<>''
begin
	set @SQL += ' and t3.cd_plano in (' + @plano + ')'
  end		
		
if @tipo_empresa <>''
begin
	set @SQL += ' and t5.tp_empresa in (' + @tipo_empresa + ')'
end	

if @situacao <>''
begin
	set @SQL += ' and t7.cd_situacao in (' + @situacao + ') '
end	
	
if (@tipo_pagamento <> '')
begin
	set @SQL += ' and t5.cd_tipo_pagamento in (' + @tipo_pagamento + ')'
end

--##TIPORECEBIMENTO##
if (@tipoRecebimento <> '')
begin
set @SQL = @SQL + 'and (select count(0)                                 
					from mensalidades_planos t1000,                     
							mensalidades t2000                             
					where t1000.cd_sequencial_dep = t1.cd_sequencial_dep 
					and t2000.cd_parcela = t1000.cd_parcela_mensalidade 
					and t2000.cd_tipo_recebimento in('+ @tipoRecebimento +') 
					) > 0 '                                              
end


set @SQL += '  ORDER BY nm_fantasia, 1, 2, nm_completo '
END
ELSE
BEGIN
set @SQL += '  SELECT '
set @SQL += '    t1.cd_sequencial_lote, '
set @SQL += '    T1.dt_assinaturaContrato AS data, '
set @SQL += '    CONVERT(varchar(10), T1.dt_assinaturaContrato, 103) AS dt_cadastro, '
set @SQL += '    T2.cd_associado, '
set @SQL += '    T2.nm_completo, '
set @SQL += '    T3.nm_dependente, '
set @SQL += '    T1.vl_contrato, '
set @SQL += '    T5.nm_fantasia, '
set @SQL += '    t2.cd_empresa, '
set @SQL += '    T6.nm_plano, '
set @SQL += '    t3.cd_sequencial, '
set @SQL += '    t8.nm_situacao_historico, '
set @SQL += '    case when charindex('' '',t9.nm_empregado) > 0 then left(t9.nm_empregado,charindex('' '',t9.nm_empregado)-1) else t9.nm_empregado end as nm_empregado, '
set @SQL += '    T1.usuario_recebimento, convert(varchar(10), t1.data_horarecebimento, 103) + '' '' + convert(varchar(8), t1.data_horarecebimento, 108) DataHoraRecebimento '      
set @SQL += '    , T11.depDescricao '
set @SQL += '  FROM Lote_Contratos_Contratos_Vendedor T1,  UF AS uf, municipio AS mu, lote_contratos LC, '
set @SQL += '       Associados T2, '
set @SQL += '       Dependentes T3, '
set @SQL += '       empresa AS t5, '
set @SQL += '       Planos t6, '
set @SQL += '       Historico t7, '
set @SQL += '       Situacao_Historico t8, '
set @SQL += '		 Funcionario t9, '
set @SQL += '		 Funcionario t10, '
set @SQL += '		 Departamento T11 '
set @SQL += '  WHERE T1.dt_assinaturaContrato BETWEEN '''+convert(varchar(10),@DT_Inicial,101) +''' AND '''+ convert(varchar(10),@DT_Final,101)+ ' 23:59'''       
set @SQL += '  AND T1.cd_sequencial_dep = T3.cd_sequencial '
set @SQL += '  AND T3.cd_associado = T2.cd_associado '
set @SQL += '  AND T2.cd_empresa = t5.cd_empresa '
set @SQL += '	 AND T2.cidid = mu.cd_municipio '
set @SQL += '	 AND T2.ufid = uf.ufid '		
set @SQL += '  AND t3.cd_plano = t6.cd_plano '
set @SQL += '  AND T3.cd_funcionario_vendedor = '+convert(varchar, @cd_funcionario)
set @SQL += '  AND T3.cd_funcionario_vendedor = t10.cd_funcionario '
set @SQL += '  AND t3.cd_sequencial_historico = t7.cd_sequencial '
set @SQL += '  AND t7.cd_situacao = t8.cd_situacao_historico '
set @SQL += '  and t1.usuario_recebimento = t9.cd_funcionario '
set @SQL += '  and T1.cd_sequencial_lote = LC.cd_sequencial '
set @SQL += '  And T2.depId = T11.depId '
  
if(@CD_Equipe > 0)
  begin
    set @SQL += ' And case when LC.cd_empresa is null then isnull(t10.cd_equipe,LC.cd_equipe) else t10.cd_equipe end = ' + convert(varchar,@CD_Equipe)
  end 

if (@uf<>-1)
begin
	set @SQL += ' And uf.ufid  = ' + convert(varchar,@uf )
end

if (@municipio<>-1)
begin
	set @SQL += 'And mu.cd_municipio = ' + convert(varchar,@municipio ) 
end		

if @plano<>''
begin
	set @SQL += ' and t3.cd_plano in (' + @plano + ')'
  end		
		
if @tipo_empresa <>''
begin
	set @SQL += ' and t5.tp_empresa in (' + @tipo_empresa + ')'
end	

if @situacao <>''
begin
	set @SQL += ' and t7.cd_situacao in (' + @situacao + ') '
end	
	
if (@tipo_pagamento <> '')
begin
	set @SQL += ' and t5.cd_tipo_pagamento in (' + @tipo_pagamento + ')'
end


set @SQL += '  ORDER BY nm_fantasia, 1, 2, nm_completo '
END
	EXEC (@SQL)
  PRINT @sql
END
