/****** Object:  Procedure [dbo].[D_Med_Analitico]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE dbo.D_Med_Analitico (
                 @ano INT ,
                 @CPF VARCHAR(11) = '' ,
                 @CentroCusto VARCHAR(MAX) = '' ,
                 @TipoUsuarioImpressao INT = -1 ,
                 @Ordem INT = -1 ,
                 @cd_associado INT = -1 ,
                 @cd_empresa INT = -1
)
AS
-- =============================================
-- Author:      henrique.almeida
-- Create date: 10/09/2021 10:59
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO DE ESTILO T-SQL
-- REALIZAR DOCUMENTAÇÃO DA PROCEDURE USANDO EXTENDED PROPERTIES
-- =============================================



  BEGIN

    --*******************************************************************    
    --A T E N Ç Ã O !    
    --*******************************************************************    
    --Cada cliente tem o seu diferente.    
    --*******************************************************************    

    DECLARE @dtini VARCHAR(16)
    DECLARE @dtfim VARCHAR(16)
    DECLARE @sql VARCHAR(MAX)
    DECLARE @localCentroCustoEnvioDMED TINYINT --1: centro de custo da empresa, 2: centro de custo do tipo de pagamento
    DECLARE @tipoValorEnvioDMED TINYINT --1: Valor da parcela, 2: Valor pago (positivo ou negativo)

    SELECT @localCentroCustoEnvioDMED = ISNULL(localCentroCustoEnvioDMED , 1) , @tipoValorEnvioDMED = ISNULL(tipoValorEnvioDMED , 1)
    FROM Configuracao

    SET @dtini = '01/01/' + CONVERT(VARCHAR(4) , @ano) + ' 00:00'
    SET @dtfim = '12/31/' + CONVERT(VARCHAR(4) , @ano) + ' 23:59'

    --*******************************************************************    
    --PF
    --*******************************************************************    

    SET @sql
    = '
  select    
  e.nm_fantasia,    
  a.cd_associado,    
  a.nr_cpf,    
  a.nm_completo,    
  d.nr_cpf_dep,    
  convert(varchar(10),d.dt_nascimento,103) dt_nascimento,    
  d.nm_dependente,    
  d.cd_sequencial cd_sequencial_dep,    
  g.nm_grau_parentesco,    
  g.nm_sigla,    
  d.nm_mae_dep,    
		'

    IF (@tipoValorEnvioDMED = 2)
      BEGIN
        SET @sql = @sql + ' isnull(isnull(mp.vl_dmed,mp.valorPago),0) valor, '
      END
    ELSE
      BEGIN
        SET @sql = @sql + ' isnull(isnull(mp.vl_dmed,mp.valor),0) valor, '
      END

    SET @sql
    = @sql
    + '
  d.dt_nascimento dt_nascimentoOrder,    
  case when d.cd_grau_parentesco = 1 then 1 else 0 end Titular,    
  (    
   select count(distinct d1.cd_sequencial)    
   from dependentes d1, associados a1, empresa e1, mensalidades_planos mp1, mensalidades m1, planos p1, tipo_pagamento tp1
   where d1.cd_associado = a1.cd_associado    
   and a1.cd_empresa = e1.cd_empresa    
   and d1.cd_sequencial = mp1.cd_sequencial_dep    
   and mp1.cd_parcela_mensalidade = m1.cd_parcela
   and d1.cd_plano = p1.cd_plano    
   and m1.cd_tipo_pagamento = tp1.cd_tipo_pagamento   
   and d1.cd_grau_parentesco = 1    
   and m1.tp_associado_empresa = 1    
   and m1.cd_tipo_recebimento > 2    
   and mp1.dt_exclusao is null    
   and m1.dt_pagamento >= ''' + @dtini + '''    
   and m1.dt_pagamento <= ''' + @dtfim
    + '''     
   and a1.nr_cpf = a.nr_cpf
   and (select count(0) from classificacao_ans where IdConvenio is not null and cd_classificacao = p1.cd_classificacao) = 0
   '

    IF (@CentroCusto <> '')
      BEGIN
        SET @sql
        = @sql + ' and case when ' + CONVERT(VARCHAR , @localCentroCustoEnvioDMED)
        + ' = 2 then tp1.cd_centro_custo else e1.cd_centro_custo end in (' + @CentroCusto + ') '
      END

    IF (@cd_empresa > 0)
      BEGIN
        SET @sql = @sql + ' and a1.cd_empresa = ' + CONVERT(VARCHAR , @cd_empresa)
      END

    SET @sql
    = @sql
    + '    
  ) QtdeCPFTitular, m.dt_pagamento    
  from dependentes d, associados a, empresa e, mensalidades_planos mp, mensalidades m, planos p, grau_parentesco g, tipo_pagamento tp
  where d.cd_associado = a.cd_associado    
  and a.cd_empresa = e.cd_empresa    
  and d.cd_sequencial = mp.cd_sequencial_dep    
  and mp.cd_parcela_mensalidade = m.cd_parcela    
  and d.cd_plano = p.cd_plano    
  and d.cd_grau_parentesco = g.cd_grau_parentesco    
  and m.cd_tipo_pagamento = tp.cd_tipo_pagamento
  and m.tp_associado_empresa = 1    
  and m.cd_tipo_recebimento > 2     
  and mp.dt_exclusao is null     
  and m.dt_pagamento >= ''' + @dtini + '''     
  and m.dt_pagamento <= ''' + @dtfim
    + '''    
  and (select count(0) from classificacao_ans where IdConvenio is not null and cd_classificacao = p.cd_classificacao) = 0
   '

    IF (@CentroCusto <> '')
      BEGIN
        SET @sql
        = @sql + ' and case when ' + CONVERT(VARCHAR , @localCentroCustoEnvioDMED)
        + ' = 2 then tp.cd_centro_custo else e.cd_centro_custo end in (' + @CentroCusto + ') '
      END

    IF (@CPF <> '')
      BEGIN
        SET @sql = @sql + ' and a.nr_cpf = ''' + @CPF + ''''
      END

    IF (@cd_empresa > 0)
      BEGIN
        SET @sql = @sql + ' and a.cd_empresa = ' + CONVERT(VARCHAR , @cd_empresa)
      END

    --*******************************************************************    
    --Coletivo por adesão ou empresas específicas ou PF pago em coletivo empresarial
    --*******************************************************************    

    SET @sql
    = @sql
    + '    
  union all    
    
  select    
  e.nm_fantasia,    
  a.cd_associado,    
  a.nr_cpf,    
  a.nm_completo,    
  d.nr_cpf_dep,    
  convert(varchar(10),d.dt_nascimento,103) dt_nascimento,    
  d.nm_dependente,    
  d.cd_sequencial cd_sequencial_dep,    
  g.nm_grau_parentesco,    
  g.nm_sigla,    
  d.nm_mae_dep,    
		'

    IF (@tipoValorEnvioDMED = 2)
      BEGIN
        SET @sql = @sql + ' isnull(isnull(mp.vl_dmed,mp.valorPago),0) valor, '
      END
    ELSE
      BEGIN
        SET @sql = @sql + ' isnull(isnull(mp.vl_dmed,mp.valor),0) valor, '
      END

    SET @sql
    = @sql
    + '
  d.dt_nascimento dt_nascimentoOrder,    
  case when d.cd_grau_parentesco = 1 then 1 else 0 end Titular,    
  (    
   select count(distinct d1.cd_sequencial)    
   from dependentes d1, associados a1, mensalidades_planos mp1, mensalidades m1, planos p1, empresa e1, tipo_pagamento tp1
   where d1.cd_associado = a1.cd_associado    
   and d1.cd_sequencial = mp1.cd_sequencial_dep    
   and mp1.cd_parcela_mensalidade = m1.cd_parcela    
   and d1.cd_plano = p1.cd_plano    
   and d1.cd_grau_parentesco = 1    
   and m1.cd_associado_empresa = e1.cd_empresa
   and m1.cd_tipo_pagamento = tp1.cd_tipo_pagamento
   and m1.tp_associado_empresa = 2    
   and (e1.tp_empresa = 8 or isnull(convert(int,e1.enviarDMED),0) = 1 or mp1.vl_dmed > 0)
   and m1.cd_tipo_recebimento > 2    
   and mp1.dt_exclusao is null    
   and m1.dt_pagamento >= ''' + @dtini + '''    
   and m1.dt_pagamento <= ''' + @dtfim
    + '''     
   and a1.nr_cpf = a.nr_cpf    
   and (select count(0) from classificacao_ans where IdConvenio is not null and cd_classificacao = p1.cd_classificacao) = 0
   '

    IF (@CentroCusto <> '')
      BEGIN
        SET @sql
        = @sql + ' and case when ' + CONVERT(VARCHAR , @localCentroCustoEnvioDMED)
        + ' = 2 then tp1.cd_centro_custo else e1.cd_centro_custo end in (' + @CentroCusto + ') '
      END

    IF (@cd_empresa > 0)
      BEGIN
        SET @sql = @sql + ' and a1.cd_empresa = ' + CONVERT(VARCHAR , @cd_empresa)
      END

    SET @sql
    = @sql
    + '    
  ) QtdeCPFTitular,m.dt_pagamento    
  from dependentes d, associados a, mensalidades_planos mp, mensalidades m, planos p, grau_parentesco g, empresa e, tipo_pagamento tp
  where d.cd_associado = a.cd_associado    
  and d.cd_sequencial = mp.cd_sequencial_dep    
  and mp.cd_parcela_mensalidade = m.cd_parcela    
  and d.cd_plano = p.cd_plano    
  and d.cd_grau_parentesco = g.cd_grau_parentesco    
  and m.cd_associado_empresa = e.cd_empresa    
  and m.cd_tipo_pagamento = tp.cd_tipo_pagamento
  and m.tp_associado_empresa = 2    
  and (e.tp_empresa = 8 or isnull(convert(int,e.enviarDMED),0) = 1 or mp.vl_dmed > 0)
  and m.cd_tipo_recebimento > 2     
  and mp.dt_exclusao is null     
  and m.dt_pagamento >= ''' + @dtini + '''     
  and m.dt_pagamento <= ''' + @dtfim
    + '''    
  and (select count(0) from classificacao_ans where IdConvenio is not null and cd_classificacao = p.cd_classificacao) = 0
   '

    IF (@CentroCusto <> '')
      BEGIN
        SET @sql
        = @sql + ' and case when ' + CONVERT(VARCHAR , @localCentroCustoEnvioDMED)
        + ' = 2 then tp.cd_centro_custo else e.cd_centro_custo end in (' + @CentroCusto + ') '
      END

    IF (@CPF <> '')
      BEGIN
        SET @sql = @sql + ' and a.nr_cpf = ''' + @CPF + ''''
      END

    IF (@cd_empresa > 0)
      BEGIN
        SET @sql = @sql + ' and a.cd_empresa = ' + CONVERT(VARCHAR , @cd_empresa)
      END

    --*********************************************************************    
    --PF FORA DA MENSALIDADE_PLANO
    --*********************************************************************    

    SET @sql
    = @sql
    + '    
  union all    
      
  select    
  e.nm_fantasia,    
  a.cd_associado,    
  a.nr_cpf,    
  a.nm_completo,    
  d.nr_cpf_dep,    
  convert(varchar(10),d.dt_nascimento,103) dt_nascimento,    
  d.nm_dependente,    
  d.cd_sequencial cd_sequencial_dep,    
  g.nm_grau_parentesco,    
  g.nm_sigla,    
  d.nm_mae_dep,    
		'

    IF (@tipoValorEnvioDMED = 2)
      BEGIN
        SET @sql = @sql + ' isnull(m.vl_pago,0) valor, '
      END
    ELSE
      BEGIN
        SET @sql = @sql + ' isnull(m.vl_parcela,0) valor, '
      END

    SET @sql
    = @sql
    + '
  d.dt_nascimento dt_nascimentoOrder,    
  1 Titular,    
  1 QtdeCPFTitular,m.dt_pagamento    
  from dependentes d, associados a, empresa e, mensalidades m, planos p, grau_parentesco g, tipo_pagamento tp
  where d.cd_associado = a.cd_associado    
  and a.cd_empresa = e.cd_empresa    
  and a.cd_associado = m.cd_associado_empresa    
  and d.cd_plano = p.cd_plano    
  and d.cd_grau_parentesco = g.cd_grau_parentesco    
  and m.cd_tipo_pagamento = tp.cd_tipo_pagamento
  and m.tp_associado_empresa = 1    
  and m.cd_tipo_recebimento > 2     
  and d.cd_grau_parentesco = 1    
  and m.dt_pagamento >= ''' + @dtini + '''     
  and m.dt_pagamento <= ''' + @dtfim
    + '''    
  and (select count(0) from mensalidades_planos where cd_parcela_mensalidade = m.cd_parcela) = 0    
  and (select count(0) from classificacao_ans where IdConvenio is not null and cd_classificacao = p.cd_classificacao) = 0
   '

    IF (@CentroCusto <> '')
      BEGIN
        SET @sql
        = @sql + ' and case when ' + CONVERT(VARCHAR , @localCentroCustoEnvioDMED)
        + ' = 2 then tp.cd_centro_custo else e.cd_centro_custo end in (' + @CentroCusto + ')'
      END

    IF (@CPF <> '')
      BEGIN
        SET @sql = @sql + ' and a.nr_cpf = ''' + @CPF + ''''
      END

    IF (@cd_empresa > 0)
      BEGIN
        SET @sql = @sql + ' and a.cd_empresa = ' + CONVERT(VARCHAR , @cd_empresa)
      END

    --*********************************************************************    

    /*    
@Ordem    
-1: Geração do arquivo DMED    
1: Impressao de IR    
*/

    IF (@Ordem = 1)
      BEGIN
        SET @sql = @sql + ' order by Titular desc, d.nm_dependente asc '
      END
    ELSE
      BEGIN
        SET @sql = @sql + ' order by a.nr_cpf asc, Titular desc, d.nr_cpf_dep asc, dt_nascimentoOrder asc '
      END

    --print @sql    
    EXEC (@sql)

  END
