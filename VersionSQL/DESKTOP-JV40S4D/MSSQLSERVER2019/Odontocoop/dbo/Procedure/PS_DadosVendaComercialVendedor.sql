/****** Object:  Procedure [dbo].[PS_DadosVendaComercialVendedor]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PS_DadosVendaComercialVendedor]
(
    @DT_Inicial VARCHAR(20),
    @DT_Final VARCHAR(20),
    @CD_Equipe INT,
    @cd_funcionario INT = 0,
    @cd_funcionario_supervisor INT = 0,
    @cpfvendedor VARCHAR(11) = '',
    @plano VARCHAR(MAX),
    @tipo_empresa VARCHAR(MAX),
    @tipo_pagamento VARCHAR(MAX),
    @grupoEmpresa INTEGER = -1,
    @centroCusto INTEGER = -1,
    @situacao VARCHAR(MAX),
    @uf INT = -1,
    @municipio INT = -1,
    @tipoRecebimento VARCHAR(1000) = ''
)
AS
BEGIN
    /*
	Ticket 17704: Correção da procedure por conta de erros de digitação na área onde era utilizado o supervisor.
*/
    DECLARE @cd_funcionario_final INT;
    DECLARE @SQL VARCHAR(MAX);
    DECLARE @SQL2 VARCHAR(MAX);
    DECLARE @configbusca TINYINT;

    SELECT TOP 1
           @configbusca = tipo_DataVendaContrato
    FROM Configuracao;

    SET @SQL = '';
    SET @SQL2 = '';

    IF @configbusca = 1
    BEGIN
        IF @CD_Equipe > 0
        BEGIN
            PRINT 1;

            SET @SQL += 'Select distinct t2.nm_empregado, t2.cd_funcionario, T1.cd_equipe, T1.nm_equipe,';

            SET @SQL += '(Select Count(T100.cd_sequencial_lote)  ';

            /*COMENTADOS FORAM REALIZADOS OS JOINS*/
            --SET @SQL += 'From lote_contratos_contratos_vendedor T100, Dependentes T200, associados t300, empresa t400, 
            -- historico t500, UF AS uf, municipio AS mu, lote_contratos t800 ';
            --SET @SQL += ' Where T100.cd_sequencial_dep = T200.cd_sequencial And  '; ok
            --SET @SQL += '      T200.cd_funcionario_vendedor = T2.cd_funcionario And  '; WHERE
            --SET @SQL += '      t200.cd_associado = t300.cd_associado and '; OK
            --SET @SQL += '      t300.cd_empresa = t400.cd_empresa and'; OK
            --SET @SQL += '      t200.cd_sequencial_historico = t500.cd_sequencial and'; OK
            --SET @SQL += '      t300.cidid *= mu.cd_municipio And'; OK
            --SET @SQL += '      t300.ufid *= uf.ufid And'; OK
            --SET @SQL += '      t100.cd_sequencial_lote = t800.cd_sequencial And'; OK
            --SET @SQL += '      T2.cd_equipe = T1.cd_equipe And '; WHERE
            SET @SQL += '      T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
                        + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';


            SET @SQL += ' FROM dbo.lote_contratos_contratos_vendedor T100
            INNER JOIN dbo.DEPENDENTES T200 ON T200.CD_SEQUENCIAL = T100.cd_sequencial_dep
            INNER JOIN dbo.ASSOCIADOS T300 ON T300.cd_associado = T200.CD_ASSOCIADO
            INNER JOIN dbo.EMPRESA T400 ON T300.cd_empresa = T400.CD_EMPRESA
            INNER JOIN dbo.HISTORICO T500 ON T200.CD_Sequencial_historico = T500.cd_sequencial
            LEFT JOIN dbo.MUNICIPIO MU ON MU.CD_MUNICIPIO = T300.CidID
            LEFT JOIN dbo.UF ON UF.ufId = T300.ufId
            INNER JOIN dbo.lote_contratos T800 ON T100.cd_sequencial_lote = T800.cd_sequencial ';

            SET @SQL += ' WHERE T200.cd_funcionario_vendedor = T2.cd_funcionario And T2.cd_equipe = T1.cd_equipe And ';
            SET @SQL += '      T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
                        + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';




            IF (@uf <> -1)
            BEGIN
                SET @SQL += ' And uf.ufid  = ' + CONVERT(VARCHAR, @uf);
            END;

            IF (@municipio <> -1)
            BEGIN
                SET @SQL += 'And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
            END;

            IF @plano <> ''
            BEGIN
                SET @SQL += ' and t200.cd_plano in (' + @plano + ')';
            END;

            IF @tipo_empresa <> ''
            BEGIN
                SET @SQL += ' and t400.tp_empresa in (' + @tipo_empresa + ')';
            END;

            IF @situacao <> ''
            BEGIN
                SET @SQL += ' and t500.cd_situacao in (' + @situacao + ') ';
            END;

            IF (@tipo_pagamento <> '')
            BEGIN
                SET @SQL += ' and T400.cd_tipo_pagamento in (' + @tipo_pagamento + ')';
            END;

            --##TIPORECEBIMENTO##
            IF (@tipoRecebimento <> '')
            BEGIN
                SET @SQL
                    = @SQL
                      + 'and (select count(0)                                 
						from mensalidades_planos t1000,                     
							 mensalidades t2000                             
						where t1000.cd_sequencial_dep = T100.cd_sequencial_dep 
						and t2000.cd_parcela = t1000.cd_parcela_mensalidade 
						and t2000.cd_tipo_recebimento in(' + @tipoRecebimento + ') 
						) > 0 ';
            END;

            IF (@grupoEmpresa > 0)
            BEGIN
                SET @SQL = @SQL + ' and T400.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
            END;
            IF (@centroCusto > 0)
            BEGIN
                SET @SQL = @SQL + ' and T400.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
            END;

            SET @SQL += ') As QuantidadeContrato,  ';

            SET @SQL += '(Select IsNull(Sum(T100.vl_contrato),0)  ';

            /*COMENTADOS FORAM REALIZADOS OS JOINS*/
            --SET @SQL += '  From lote_contratos_contratos_vendedor T100, Dependentes T200, associados t300,  
            -- empresa t400, historico t500, UF AS uf, municipio AS mu, lote_contratos t800 ';
            --SET @SQL += '  Where T100.cd_sequencial_dep = T200.cd_sequencial And  '; OK
            --SET @SQL += '      T200.cd_funcionario_vendedor = T2.cd_funcionario And  '; WHERE
            --SET @SQL += '      t200.cd_associado = t300.cd_associado and ';
            --SET @SQL += '      t300.cd_empresa = t400.cd_empresa and';
            --SET @SQL += '      t200.cd_sequencial_historico = t500.cd_sequencial and';
            --SET @SQL += '      t300.cidid *= mu.cd_municipio And';
            --SET @SQL += '      t300.ufid *= uf.ufid And';
            --SET @SQL += '      t100.cd_sequencial_lote = t800.cd_sequencial And';
            --SET @SQL += '      T2.cd_equipe = T1.cd_equipe And '; WHERE
            --SET @SQL += '      T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
            --            + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';

            SET @SQL += ' FROM dbo.lote_contratos_contratos_vendedor T100
            INNER JOIN dbo.DEPENDENTES T200 ON T200.CD_SEQUENCIAL = T100.cd_sequencial_dep
            INNER JOIN dbo.ASSOCIADOS T300 ON T300.cd_associado = T200.CD_ASSOCIADO
            INNER JOIN dbo.EMPRESA T400 ON T300.cd_empresa = T400.CD_EMPRESA
            INNER JOIN dbo.HISTORICO T500 ON T200.CD_Sequencial_historico = T500.cd_sequencial
            LEFT JOIN dbo.MUNICIPIO MU ON MU.CD_MUNICIPIO = T300.CidID
            LEFT JOIN dbo.UF ON UF.ufId = T300.ufId
            INNER JOIN dbo.lote_contratos T800 ON T800.cd_sequencial = T100.cd_sequencial_lote';



            SET @SQL += ' WHERE T200.cd_funcionario_vendedor = T2.cd_funcionario And T2.cd_equipe = T1.cd_equipe And ';
            SET @SQL += '      T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
                        + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';






            IF (@uf <> -1)
            BEGIN
                SET @SQL += ' And uf.ufid  = ' + CONVERT(VARCHAR, @uf);
            END;

            IF (@municipio <> -1)
            BEGIN
                SET @SQL += 'And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
            END;

            IF @plano <> ''
            BEGIN
                SET @SQL += ' and t200.cd_plano in (' + @plano + ')';
            END;

            IF @tipo_empresa <> ''
            BEGIN
                SET @SQL += ' and t400.tp_empresa in (' + @tipo_empresa + ')';
            END;

            IF @situacao <> ''
            BEGIN
                SET @SQL += ' and t500.cd_situacao in (' + @situacao + ') ';
            END;

            IF (@tipo_pagamento <> '')
            BEGIN
                SET @SQL += ' and T400.cd_tipo_pagamento in (' + @tipo_pagamento + ')';
            END;

            --##TIPORECEBIMENTO##
            IF (@tipoRecebimento <> '')
            BEGIN
                SET @SQL
                    = @SQL
                      + 'and (select count(0)                                 
							from mensalidades_planos t1000,                     
								 mensalidades t2000                             
							where t1000.cd_sequencial_dep = T100.cd_sequencial_dep 
							and t2000.cd_parcela = t1000.cd_parcela_mensalidade 
							and t2000.cd_tipo_recebimento in(' + @tipoRecebimento + ') 
							) > 0 ';
            END;

            IF (@grupoEmpresa > 0)
            BEGIN
                SET @SQL = @SQL + ' and T400.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
            END;
            IF (@centroCusto > 0)
            BEGIN
                SET @SQL = @SQL + ' and T400.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
            END;
            SET @SQL += ' )As ValorContrato,  ';

            -- Numero de vidas contrato importado.  
            SET @SQL += 'IsNull((Select Count(T100.cd_sequencial)  ';
            SET @SQL += 'From Dependentes T100, Historico T300 ';
            SET @SQL += 'Where T100.cd_funcionario_vendedor = T2.cd_funcionario  ';
            SET @SQL += '   And t100.CD_Sequencial_historico = t300.cd_sequencial  ';
            SET @SQL += '      And T300.cd_situacao = 6),0)      ';
            SET @SQL += 'As QuantidadeImportado,  ';

            -- Valor de vidas contrato importado.  
            SET @SQL += ' IsNull((Select Sum(T100.vl_plano)  ';
            SET @SQL += 'From Dependentes T100, Historico T300 ';
            SET @SQL += 'Where T100.cd_funcionario_vendedor = T2.cd_funcionario  ';
            SET @SQL += '   And t100.CD_Sequencial_historico = t300.cd_sequencial  ';
            SET @SQL += '     And T300.cd_situacao = 6),0)      ';
            SET @SQL += 'As ValorImportado';


            /*COMENTADOS FORAM REALIZADOS OS JOINS*/


            -- contratosCartao
            SET @SQL += ',(Select Count(T100.cd_sequencial_lote)  ';
            --SET @SQL += '  From lote_contratos_contratos_vendedor T100, Dependentes T200, ASSOCIADOS T300,
            -- EMPRESA T400, TIPO_PAGAMENTO T500, historico t600, UF AS uf, municipio AS mu, lote_contratos t800 ';
            --SET @SQL += '  Where T100.cd_sequencial_dep = T200.cd_sequencial And  ';OK
            --SET @SQL += '      T200.cd_funcionario_vendedor = T2.cd_funcionario And  '; WHERE
            --SET @SQL += '      T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
            --            + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and '; WHERE
            --SET @SQL += '      T200.cd_associado = T300.cd_associado and ';
            --SET @SQL += '      T300.cd_empresa = T400.cd_empresa and ';
            --SET @SQL += '      T400.TP_EMPRESA in (3) and ';
            --SET @SQL += '      T400.cd_tipo_pagamento = T500.cd_tipo_pagamento and ';
            --SET @SQL += '      t200.cd_sequencial_historico = t600.cd_sequencial and';
            --SET @SQL += '      t300.cidid *= mu.cd_municipio And';
            --SET @SQL += '      t300.ufid *= uf.ufid And';
            --SET @SQL += '      t100.cd_sequencial_lote = t800.cd_sequencial And';
            --SET @SQL += '      T2.cd_equipe = T1.cd_equipe And '; WHERE
            --SET @SQL += '      isnull(T500.fl_exige_Dados_cartao,0) = 1'; WHERE

            SET @SQL += ' FROM dbo.lote_contratos_contratos_vendedor T100
            INNER JOIN dbo.DEPENDENTES T200 ON T200.CD_SEQUENCIAL = T100.cd_sequencial_dep
            INNER JOIN dbo.ASSOCIADOS T300 ON T300.cd_associado = T200.CD_ASSOCIADO
            INNER JOIN dbo.EMPRESA T400 ON T300.cd_empresa = T400.CD_EMPRESA AND T400.TP_EMPRESA IN (3)
            INNER JOIN dbo.TIPO_PAGAMENTO T500 ON T500.cd_tipo_pagamento = T400.cd_tipo_pagamento
            INNER JOIN dbo.HISTORICO T600 ON T200.CD_Sequencial_historico = T600.cd_sequencial
            LEFT JOIN dbo.MUNICIPIO MU ON MU.CD_MUNICIPIO = T300.CidID
            LEFT JOIN dbo.UF ON UF.ufId = T300.ufId
            INNER JOIN dbo.lote_contratos T800 ON T800.cd_sequencial = T100.cd_sequencial_lote ';


            SET @SQL += ' WHERE T200.cd_funcionario_vendedor = T2.cd_funcionario And';
            SET @SQL += '      T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
                        + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and ';
            SET @SQL += '      T2.cd_equipe = T1.cd_equipe And ';
            SET @SQL += '      isnull(T500.fl_exige_Dados_cartao,0) = 1';






            IF (@uf <> -1)
            BEGIN
                SET @SQL += ' And uf.ufid  = ' + CONVERT(VARCHAR, @uf);
            END;

            IF (@municipio <> -1)
            BEGIN
                SET @SQL += 'And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
            END;

            IF @plano <> ''
            BEGIN
                SET @SQL += ' and t200.cd_plano in (' + @plano + ')';
            END;

            IF @tipo_empresa <> ''
            BEGIN
                SET @SQL += ' and t400.tp_empresa in (' + @tipo_empresa + ')';
            END;

            IF @situacao <> ''
            BEGIN
                SET @SQL += ' and t600.cd_situacao in (' + @situacao + ') ';
            END;

            IF (@tipo_pagamento <> '')
            BEGIN
                SET @SQL += ' and T400.cd_tipo_pagamento in (' + @tipo_pagamento + ')';
            END;

            --##TIPORECEBIMENTO##
            IF (@tipoRecebimento <> '')
            BEGIN
                SET @SQL
                    = @SQL
                      + 'and (select count(0)                                 
							from mensalidades_planos t1000,                     
								 mensalidades t2000                             
							where t1000.cd_sequencial_dep = T100.cd_sequencial_dep 
							and t2000.cd_parcela = t1000.cd_parcela_mensalidade 
							and t2000.cd_tipo_recebimento in(' + @tipoRecebimento + ') 
							) > 0 ';
            END;

            IF (@grupoEmpresa > 0)
            BEGIN
                SET @SQL = @SQL + ' and T400.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
            END;
            IF (@centroCusto > 0)
            BEGIN
                SET @SQL = @SQL + ' and T400.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
            END;

            SET @SQL += ' ) As contratosCartao';

            /*COMENTADOS FORAM REALIZADOS OS JOINS*/

            -- contratosDebito
            SET @SQL += ',(Select Count(T100.cd_sequencial_lote)  ';
            --SET @SQL += '  From lote_contratos_contratos_vendedor T100, Dependentes T200, ASSOCIADOS T300, 
            --EMPRESA T400, TIPO_PAGAMENTO T500, historico t600, UF AS uf, municipio AS mu, lote_contratos t800 ';
            --SET @SQL += '  Where T100.cd_sequencial_dep = T200.cd_sequencial And  ';
            --SET @SQL += '      T200.cd_funcionario_vendedor = T2.cd_funcionario And  ';
            --SET @SQL += '      T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
            --            + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and ';
            --SET @SQL += '      T200.cd_associado = T300.cd_associado and ';
            --SET @SQL += '      T300.cd_empresa = T400.cd_empresa and ';
            --SET @SQL += '      T400.TP_EMPRESA in (3) and ';
            --SET @SQL += '      T400.cd_tipo_pagamento = T500.cd_tipo_pagamento and ';
            --SET @SQL += '      t200.cd_sequencial_historico = t600.cd_sequencial and';
            --SET @SQL += '      t300.cidid *= mu.cd_municipio And';
            --SET @SQL += '      t300.ufid *= uf.ufid And';
            --SET @SQL += '      t100.cd_sequencial_lote = t800.cd_sequencial And';
            --SET @SQL += '      T2.cd_equipe = T1.cd_equipe And ';
            --SET @SQL += '      isnull(T500.fl_exige_Dados_cartao,0) = 0 And';
            --SET @SQL += '      isnull(T500.fl_boleto,0) = 0 And';
            --SET @SQL += '      isnull(T500.fl_exige_dados_conta, 0) = 1 ';

            SET @SQL += ' FROM dbo.lote_contratos_contratos_vendedor T100
            INNER JOIN dbo.DEPENDENTES T200 ON T200.CD_SEQUENCIAL = T100.cd_sequencial_dep
            INNER JOIN dbo.ASSOCIADOS T300 ON T300.cd_associado = T200.CD_ASSOCIADO
            INNER JOIN dbo.EMPRESA T400 ON T300.cd_empresa = T400.CD_EMPRESA AND T400.TP_EMPRESA IN (3)
            INNER JOIN dbo.TIPO_PAGAMENTO T500 ON T400.cd_tipo_pagamento = T500.cd_tipo_pagamento
            INNER JOIN dbo.HISTORICO T600 ON T200.CD_Sequencial_historico = T600.cd_sequencial
            LEFT JOIN dbo.MUNICIPIO MU ON MU.CD_MUNICIPIO = T300.CidID
            LEFT JOIN dbo.UF ON UF.ufId = T300.ufId
            INNER JOIN dbo.lote_contratos T800 ON T800.cd_sequencial = T100.cd_sequencial_lote';



            SET @SQL += ' WHERE T200.cd_funcionario_vendedor = T2.cd_funcionario And';
            SET @SQL += '      T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
                        + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and ';
            SET @SQL += '      T2.cd_equipe = T1.cd_equipe And ';
            SET @SQL += '      isnull(T500.fl_exige_Dados_cartao,0) = 0 And';
            SET @SQL += '      isnull(T500.fl_boleto,0) = 0 And';
            SET @SQL += '      isnull(T500.fl_exige_dados_conta, 0) = 1 ';






            IF (@uf <> -1)
            BEGIN
                SET @SQL += ' And uf.ufid  = ' + CONVERT(VARCHAR, @uf);
            END;

            IF (@municipio <> -1)
            BEGIN
                SET @SQL += 'And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
            END;

            IF @plano <> ''
            BEGIN
                SET @SQL += ' and t200.cd_plano in (' + @plano + ')';
            END;

            IF @tipo_empresa <> ''
            BEGIN
                SET @SQL += ' and t400.tp_empresa in (' + @tipo_empresa + ')';
            END;

            IF @situacao <> ''
            BEGIN
                SET @SQL += ' and t600.cd_situacao in (' + @situacao + ') ';
            END;

            IF (@tipo_pagamento <> '')
            BEGIN
                SET @SQL += ' and T400.cd_tipo_pagamento in (' + @tipo_pagamento + ')';
            END;

            --##TIPORECEBIMENTO##
            IF (@tipoRecebimento <> '')
            BEGIN
                SET @SQL
                    = @SQL
                      + 'and (select count(0)                                 
							from mensalidades_planos t1000,                     
								 mensalidades t2000                             
							where t1000.cd_sequencial_dep = T100.cd_sequencial_dep 
							and t2000.cd_parcela = t1000.cd_parcela_mensalidade 
							and t2000.cd_tipo_recebimento in(' + @tipoRecebimento + ') 
							) > 0 ';
            END;

            IF (@grupoEmpresa > 0)
            BEGIN
                SET @SQL = @SQL + ' and T400.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
            END;
            IF (@centroCusto > 0)
            BEGIN
                SET @SQL = @SQL + ' and T400.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
            END;

            SET @SQL += ' ) As contratosDebito';



            /*COMENTADOS FORAM REALIZADOS OS JOINS*/

            --contratosBoleto
            SET @SQL += ',(Select Count(T100.cd_sequencial_lote)  ';
            --SET @SQL += '  From lote_contratos_contratos_vendedor T100, Dependentes T200, ASSOCIADOS T300, EMPRESA T400, 
            --TIPO_PAGAMENTO T500, historico t600, UF AS uf, municipio AS mu, lote_contratos t800 ';
            --SET @SQL += '  Where T100.cd_sequencial_dep = T200.cd_sequencial And  '; OK
            --SET @SQL += '      T200.cd_funcionario_vendedor = T2.cd_funcionario And  '; WHERE
            --SET @SQL += '      T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
            --            + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and '; WHERE
            --SET @SQL += '      T200.cd_associado = T300.cd_associado and ';OK
            --SET @SQL += '      T400.TP_EMPRESA in (3) and ';OK
            --SET @SQL += '      T300.cd_empresa = T400.cd_empresa and ';OK
            --SET @SQL += '      T400.cd_tipo_pagamento = T500.cd_tipo_pagamento and ';OK
            --SET @SQL += '      t200.cd_sequencial_historico = t600.cd_sequencial and '; OK
            --SET @SQL += '      t300.cidid *= mu.cd_municipio And ';OK
            --SET @SQL += '      t300.ufid *= uf.ufid And ';OK
            --SET @SQL += '      t100.cd_sequencial_lote = t800.cd_sequencial And';OK
            --SET @SQL += '      T2.cd_equipe = T1.cd_equipe And ';
            --SET @SQL += '      isnull(T500.fl_boleto,0) = 1';

            --contratosBoleto
            SET @SQL += ' FROM dbo.lote_contratos_contratos_vendedor T100 
            INNER JOIN dbo.DEPENDENTES T200 ON T200.CD_SEQUENCIAL = T100.cd_sequencial_dep
            INNER JOIN dbo.ASSOCIADOS T300 ON T300.cd_associado = T200.CD_ASSOCIADO
            INNER JOIN dbo.EMPRESA T400 ON T300.cd_empresa = T400.CD_EMPRESA AND T400.TP_EMPRESA IN (3)
            INNER JOIN dbo.TIPO_PAGAMENTO T500 ON T500.cd_tipo_pagamento = T400.cd_tipo_pagamento
            INNER JOIN dbo.HISTORICO T600 ON T200.CD_Sequencial_historico = T600.cd_sequencial
            LEFT JOIN dbo.MUNICIPIO MU ON MU.CD_MUNICIPIO = T300.CidID
            LEFT JOIN dbo.UF ON UF.ufId = T300.ufId
            INNER JOIN dbo.lote_contratos T800 ON T800.cd_sequencial = T100.cd_sequencial_lote';


            SET @SQL += ' WHERE T200.cd_funcionario_vendedor = T2.cd_funcionario And ';
            SET @SQL += '      T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
                        + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and ';
            SET @SQL += '      T2.cd_equipe = T1.cd_equipe And ';
            SET @SQL += '      isnull(T500.fl_boleto,0) = 1';



            IF (@uf <> -1)
            BEGIN
                SET @SQL += ' And uf.ufid  = ' + CONVERT(VARCHAR, @uf);
            END;

            IF (@municipio <> -1)
            BEGIN
                SET @SQL += ' And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
            END;

            IF @plano <> ''
            BEGIN
                SET @SQL += ' and t200.cd_plano in (' + @plano + ')';
            END;

            IF @tipo_empresa <> ''
            BEGIN
                SET @SQL += ' and t400.tp_empresa in (' + @tipo_empresa + ')';
            END;

            IF @situacao <> ''
            BEGIN
                SET @SQL += ' and t600.cd_situacao in (' + @situacao + ') ';
            END;

            IF (@tipo_pagamento <> '')
            BEGIN
                SET @SQL += ' and T400.cd_tipo_pagamento in (' + @tipo_pagamento + ')';
            END;

            --##TIPORECEBIMENTO##
            IF (@tipoRecebimento <> '')
            BEGIN
                SET @SQL
                    = @SQL
                      + 'and (select count(0)                                 
							from mensalidades_planos t1000,                     
								 mensalidades t2000                             
							where t1000.cd_sequencial_dep = T100.cd_sequencial_dep 
							and t2000.cd_parcela = t1000.cd_parcela_mensalidade 
							and t2000.cd_tipo_recebimento in(' + @tipoRecebimento + ') 
							) > 0 ';
            END;

            IF (@grupoEmpresa > 0)
            BEGIN
                SET @SQL = @SQL + ' and T400.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
            END;
            IF (@centroCusto > 0)
            BEGIN
                SET @SQL = @SQL + ' and T400.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
            END;
            SET @SQL += ') As contratosBoleto';


            /*COMENTADOS FORAM REALIZADOS OS JOINS*/

            ----contratosConsignado
            SET @SQL += ',(Select Count(T100.cd_sequencial_lote)  ';
            --SET @SQL += '     From lote_contratos_contratos_vendedor T100, Dependentes T200, ASSOCIADOS T300, EMPRESA T400, 
            --TIPO_PAGAMENTO T500, historico t600, UF AS uf, municipio AS mu, lote_contratos t800 ';
            --SET @SQL += '     Where T100.cd_sequencial_dep = T200.cd_sequencial And  '; OK
            --SET @SQL += '         T200.cd_funcionario_vendedor = T2.cd_funcionario And  '; WHERE
            --SET @SQL += '         T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
            --            + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and '; WHERE
            --SET @SQL += '         T200.cd_associado = T300.cd_associado and ';OK
            --SET @SQL += '         T300.cd_empresa = T400.cd_empresa and ';OK
            --SET @SQL += '         T400.TP_EMPRESA in (1,4,5) and ';OK
            --SET @SQL += '         T400.cd_tipo_pagamento = T500.cd_tipo_pagamento and ';OK
            --SET @SQL += '         t200.cd_sequencial_historico = t600.cd_sequencial and ';OK
            --SET @SQL += '         t300.cidid *= mu.cd_municipio And ';OK
            --SET @SQL += '         t300.ufid *= uf.ufid and ';OK
            --SET @SQL += '         t100.cd_sequencial_lote = t800.cd_sequencial And';OK
            --SET @SQL += '         T2.cd_equipe = T1.cd_equipe ';


            SET @SQL += ' FROM dbo.lote_contratos_contratos_vendedor T100 
            INNER JOIN dbo.DEPENDENTES T200 ON T200.CD_SEQUENCIAL = T100.cd_sequencial_dep
            INNER JOIN dbo.ASSOCIADOS T300 ON T300.cd_associado = T200.CD_ASSOCIADO
            INNER JOIN dbo.EMPRESA T400 ON T300.cd_empresa = T400.CD_EMPRESA AND T400.TP_EMPRESA IN (1,4,5)
            INNER JOIN dbo.TIPO_PAGAMENTO T500 ON T500.cd_tipo_pagamento = T400.cd_tipo_pagamento
            INNER JOIN dbo.HISTORICO T600 ON T200.CD_Sequencial_historico = T600.cd_sequencial
            LEFT JOIN dbo.MUNICIPIO MU ON MU.CD_MUNICIPIO = T300.CidID
            LEFT JOIN dbo.UF ON UF.ufId = T300.ufId
            INNER JOIN dbo.lote_contratos T800 ON T800.cd_sequencial = T100.cd_sequencial_lote ';

            SET @SQL += ' WHERE ';
            SET @SQL += '         T200.cd_funcionario_vendedor = T2.cd_funcionario And  ';
            SET @SQL += '         T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
                        + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and ';
            SET @SQL += '         T2.cd_equipe = T1.cd_equipe ';



            IF (@uf <> -1)
            BEGIN
                SET @SQL += ' And uf.ufid  = ' + CONVERT(VARCHAR, @uf);
            END;

            IF (@municipio <> -1)
            BEGIN
                SET @SQL += ' And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
            END;

            IF @plano <> ''
            BEGIN
                SET @SQL += ' and t200.cd_plano in (' + @plano + ')';
            END;

            IF @tipo_empresa <> ''
            BEGIN
                SET @SQL += ' and t400.tp_empresa in (' + @tipo_empresa + ')';
            END;

            IF @situacao <> ''
            BEGIN
                SET @SQL += ' and t600.cd_situacao in (' + @situacao + ') ';
            END;

            IF (@tipo_pagamento <> '')
            BEGIN
                SET @SQL += ' and T400.cd_tipo_pagamento in (' + @tipo_pagamento + ')';
            END;

            --##TIPORECEBIMENTO##
            IF (@tipoRecebimento <> '')
            BEGIN
                SET @SQL
                    = @SQL
                      + 'and (select count(0)                                 
							from mensalidades_planos t1000,                     
								 mensalidades t2000                             
							where t1000.cd_sequencial_dep = T100.cd_sequencial_dep 
							and t2000.cd_parcela = t1000.cd_parcela_mensalidade 
							and t2000.cd_tipo_recebimento in(' + @tipoRecebimento + ') 
							) > 0 ';
            END;

            IF (@grupoEmpresa > 0)
            BEGIN
                SET @SQL = @SQL + ' and T400.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
            END;
            IF (@centroCusto > 0)
            BEGIN
                SET @SQL = @SQL + ' and T400.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
            END;

            SET @SQL += '    ) As contratosConsignado ';


            /*COMENTADOS FORAM REALIZADOS OS JOINS*/

            ----contratosPJ
            SET @SQL += '    ,(Select Count(T100.cd_sequencial_lote)  ';
            --SET @SQL += '     From lote_contratos_contratos_vendedor T100, Dependentes T200, ASSOCIADOS T300, EMPRESA T400, 
            -- TIPO_PAGAMENTO T500 , historico t600, UF AS uf, municipio AS mu, lote_contratos t800 ';
            --SET @SQL += '     Where T100.cd_sequencial_dep = T200.cd_sequencial And  ';
            --SET @SQL += '         T200.cd_funcionario_vendedor = T2.cd_funcionario And  '; WHERE
            --SET @SQL += '         T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
            --            + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and '; WHERE
            --SET @SQL += '         T200.cd_associado = T300.cd_associado and ';
            --SET @SQL += '         T300.cd_empresa = T400.cd_empresa and ';
            --SET @SQL += '         T400.TP_EMPRESA in (2,6,7) and ';
            --SET @SQL += '         t200.cd_sequencial_historico = t600.cd_sequencial and ';
            --SET @SQL += '         t300.cidid *= mu.cd_municipio And ';
            --SET @SQL += '         t300.ufid *= uf.ufid and';
            --SET @SQL += '         t100.cd_sequencial_lote = t800.cd_sequencial And';
            --SET @SQL += '         T2.cd_equipe = T1.cd_equipe And '; WHERE
            --SET @SQL += '         T400.cd_tipo_pagamento = T500.cd_tipo_pagamento ';


            SET @SQL += ' FROM dbo.lote_contratos_contratos_vendedor T100 
            INNER JOIN dbo.DEPENDENTES T200 ON T200.CD_SEQUENCIAL = T100.cd_sequencial_dep
            INNER JOIN dbo.ASSOCIADOS T300 ON T300.cd_associado = T200.CD_ASSOCIADO
            INNER JOIN dbo.EMPRESA T400 ON T300.cd_empresa = T400.CD_EMPRESA AND T400.TP_EMPRESA IN (2,6,7)
            INNER JOIN dbo.HISTORICO T600 ON T600.cd_sequencial = T200.CD_Sequencial_historico
            LEFT JOIN dbo.MUNICIPIO MU ON MU.CD_MUNICIPIO = T300.CidID
            LEFT JOIN dbo.UF ON UF.ufId = T300.ufId
            INNER JOIN dbo.lote_contratos T800 ON T800.cd_sequencial = T100.cd_sequencial_lote
            INNER JOIN dbo.TIPO_PAGAMENTO T500 ON T500.cd_tipo_pagamento = T400.cd_tipo_pagamento';


            SET @SQL += ' WHERE ';
            SET @SQL += '         T200.cd_funcionario_vendedor = T2.cd_funcionario And  ';
            SET @SQL += '         T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
                        + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and ';
            SET @SQL += '         T2.cd_equipe = T1.cd_equipe And ';



            IF (@uf <> -1)
            BEGIN
                SET @SQL += ' And uf.ufid  = ' + CONVERT(VARCHAR, @uf);
            END;

            IF (@municipio <> -1)
            BEGIN
                SET @SQL += ' And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
            END;

            IF @plano <> ''
            BEGIN
                SET @SQL += ' and t200.cd_plano in (' + @plano + ')';
            END;

            IF @tipo_empresa <> ''
            BEGIN
                SET @SQL += ' and t400.tp_empresa in (' + @tipo_empresa + ')';
            END;

            IF @situacao <> ''
            BEGIN
                SET @SQL += ' and t600.cd_situacao in (' + @situacao + ') ';
            END;

            IF (@tipo_pagamento <> '')
            BEGIN
                SET @SQL += ' and T400.cd_tipo_pagamento in (' + @tipo_pagamento + ')';
            END;

            --##TIPORECEBIMENTO##
            IF (@tipoRecebimento <> '')
            BEGIN
                SET @SQL
                    = @SQL
                      + 'and (select count(0)                                 
							from mensalidades_planos t1000,                     
								 mensalidades t2000                             
							where t1000.cd_sequencial_dep = T100.cd_sequencial_dep 
							and t2000.cd_parcela = t1000.cd_parcela_mensalidade 
							and t2000.cd_tipo_recebimento in(' + @tipoRecebimento + ') 
							) > 0 ';
            END;

            IF (@grupoEmpresa > 0)
            BEGIN
                SET @SQL = @SQL + ' and T400.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
            END;
            IF (@centroCusto > 0)
            BEGIN
                SET @SQL = @SQL + ' and T400.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
            END;

            SET @SQL += ')     As contratosPJ, ';


            /*COMENTADOS FORAM REALIZADOS OS JOINS*/

            --QuantidadeAssociados     
            SET @SQL += ' (Select IsNull(Count(distinct T200.cd_associado),0)  ';
            --SET @SQL += '     From lote_contratos_contratos_vendedor T100, Dependentes T200 , ASSOCIADOS T300, 
            --EMPRESA T400, historico T500, UF AS uf, municipio AS mu, lote_contratos t800 ';
            --SET @SQL += '     Where T100.cd_sequencial_dep = T200.cd_sequencial And  ';
            --SET @SQL += '       T200.cd_funcionario_vendedor = T2.cd_funcionario And  ';WHERE
            --SET @SQL += '       t300.cd_empresa = t400.cd_empresa and';
            --SET @SQL += '       t200.cd_associado = t300.cd_associado and ';
            --SET @SQL += '       t200.cd_sequencial_historico = t500.cd_sequencial and';
            --SET @SQL += '       t300.cidid *= mu.cd_municipio And';
            --SET @SQL += '       t300.ufid *= uf.ufid And';
            --SET @SQL += '       t100.cd_sequencial_lote = t800.cd_sequencial And';
            --SET @SQL += '       T2.cd_equipe = T1.cd_equipe And '; WHERE
            --SET @SQL += '       T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
            --            + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'''; WHERE


            SET @SQL += ' FROM dbo.lote_contratos_contratos_vendedor T100
            INNER JOIN dbo.DEPENDENTES T200 ON T200.CD_SEQUENCIAL = T100.cd_sequencial_dep
            INNER JOIN dbo.ASSOCIADOS T300 ON T300.cd_associado = T200.CD_ASSOCIADO
            INNER JOIN dbo.EMPRESA T400 ON T300.cd_empresa = T400.CD_EMPRESA
            INNER JOIN dbo.HISTORICO T500 ON T200.CD_Sequencial_historico = T500.cd_sequencial
            LEFT JOIN dbo.MUNICIPIO MU ON MU.CD_MUNICIPIO = T300.CidID
            LEFT JOIN dbo.UF ON UF.ufId = T300.ufId
            INNER JOIN dbo.lote_contratos T800 ON T800.cd_sequencial = T100.cd_sequencial_lote ';

            SET @SQL += ' WHERE ';
            SET @SQL += '       T200.cd_funcionario_vendedor = T2.cd_funcionario And  ';
            SET @SQL += '       T2.cd_equipe = T1.cd_equipe And ';
            SET @SQL += '       T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
                        + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';


            IF (@uf <> -1)
            BEGIN
                SET @SQL += ' And uf.ufid  = ' + CONVERT(VARCHAR, @uf);
            END;

            IF (@municipio <> -1)
            BEGIN
                SET @SQL += ' And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
            END;

            IF @plano <> ''
            BEGIN
                SET @SQL += ' and t200.cd_plano in (' + @plano + ')';
            END;

            IF @tipo_empresa <> ''
            BEGIN
                SET @SQL += ' and t400.tp_empresa in (' + @tipo_empresa + ')';
            END;

            IF @situacao <> ''
            BEGIN
                SET @SQL += ' and t500.cd_situacao in (' + @situacao + ') ';
            END;

            IF (@tipo_pagamento <> '')
            BEGIN
                SET @SQL += ' and T400.cd_tipo_pagamento in (' + @tipo_pagamento + ')';
            END;

            --##TIPORECEBIMENTO##
            IF (@tipoRecebimento <> '')
            BEGIN
                SET @SQL
                    = @SQL
                      + 'and (select count(0)                                 
							from mensalidades_planos t1000,                     
								 mensalidades t2000                             
							where t1000.cd_sequencial_dep = T100.cd_sequencial_dep 
							and t2000.cd_parcela = t1000.cd_parcela_mensalidade 
							and t2000.cd_tipo_recebimento in(' + @tipoRecebimento + ') 
							) > 0 ';
            END;

            IF (@grupoEmpresa > 0)
            BEGIN
                SET @SQL = @SQL + ' and T400.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
            END;
            IF (@centroCusto > 0)
            BEGIN
                SET @SQL = @SQL + ' and T400.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
            END;

            SET @SQL += '  )   As QuantidadeAssociados, ';
            SET @SQL += ' isnull(T2.metaNovosPacientes, 0) metaNovosPacientes ';

            /* FROM e WHERE DA PROCEDURE */
            SET @SQL2 += ' From lote_contratos_contratos_vendedor T100, Dependentes T200, lote_contratos LC, Funcionario T2, equipe_vendas T1 ';
            SET @SQL2 += ' Where T100.cd_sequencial_dep = T200.cd_sequencial ';
            SET @SQL2 += ' And T100.cd_sequencial_lote = LC.cd_sequencial ';
            SET @SQL2 += ' and T200.cd_funcionario_vendedor = T2.cd_funcionario ';
            SET @SQL2 += ' and T2.cd_equipe = T1.cd_equipe ';
            SET @SQL2 += ' and t2.cd_funcionario >= case when ''' + CONVERT(VARCHAR, @cd_funcionario)
                         + '''=0 then 0 else ''' + CONVERT(VARCHAR, @cd_funcionario) + ''' end ';
            SET @SQL2 += ' and t2.cd_funcionario <= case when ''' + CONVERT(VARCHAR, @cd_funcionario)
                         + '''=0 then 9999999999 else ''' + CONVERT(VARCHAR, @cd_funcionario) + ''' end ';
            SET @SQL2 += ' and T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
                         + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
            SET @SQL2 += ' and IsNull(t2.nr_cpf,'''') like case when ''' + @cpfvendedor
                         + ''' ='''' then ''%%'' else ''' + @cpfvendedor + ''' end ';

            IF (@CD_Equipe > 0)
            BEGIN
                SET @SQL2 += ' And T1.cd_equipe = ' + CONVERT(VARCHAR, @CD_Equipe);
            END;

            SET @SQL2 += ' group by t2.nm_empregado, t2.cd_funcionario, t1.cd_Equipe, t1.nm_equipe, LC.cd_empresa, LC.cd_equipe, T2.cd_equipe, T2.metaNovosPacientes ';
            SET @SQL2 += ' Order By 6 Desc ';
        END;
        ELSE
        BEGIN
            IF @cd_funcionario_supervisor > 0
            BEGIN
                PRINT 2;
                SET @SQL += ' Select distinct t2.nm_empregado, t2.cd_funcionario, t1.cd_equipe, t1.nm_equipe,';

                SET @SQL += ' (Select Count(T100.cd_sequencial_lote)  ';
                SET @SQL += '    From lote_contratos_contratos_vendedor T100, Dependentes T200, lote_contratos t800 ';
                SET @SQL += '    Where T100.cd_sequencial_dep = T200.cd_sequencial And  ';
                SET @SQL += '          T200.cd_funcionario_vendedor = T2.cd_funcionario and ';
                SET @SQL += '          t100.cd_sequencial_lote = t800.cd_sequencial And';
                SET @SQL += '          T2.cd_equipe = T1.cd_equipe And ';
                SET @SQL += '          T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
                            + ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'')';
                SET @SQL += '  As QuantidadeContrato,  ';

                SET @SQL += ' (Select IsNull(Sum(T100.vl_contrato),0)  ';
                SET @SQL += '    From lote_contratos_contratos_vendedor T100, Dependentes T200, lote_contratos t800 ';
                SET @SQL += '    Where T100.cd_sequencial_dep = T200.cd_sequencial And  ';
                SET @SQL += '        T200.cd_funcionario_vendedor = T2.cd_funcionario and ';
                SET @SQL += '        t100.cd_sequencial_lote = t800.cd_sequencial And';
                SET @SQL += '        T2.cd_equipe = T1.cd_equipe And ';
                SET @SQL += '        T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
                            + ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'')';
                SET @SQL += '  As ValorContrato,  ';

                -- Numero de vidas contrato importado.  
                SET @SQL += ' IsNull((Select Count(T100.cd_sequencial)  ';
                SET @SQL += ' From Dependentes T100, Historico T300 ';
                SET @SQL += ' Where T100.cd_funcionario_vendedor = T2.cd_funcionario  ';
                SET @SQL += '     And t100.CD_Sequencial_historico = t300.cd_sequencial  ';
                SET @SQL += '     And T300.cd_situacao = 6),0)      ';
                SET @SQL += ' As QuantidadeImportado,  ';

                -- Valor de vidas contrato importado.  
                SET @SQL += ' IsNull((Select Sum(T100.vl_plano)  ';
                SET @SQL += ' From Dependentes T100, Historico T300 ';
                SET @SQL += ' Where T100.cd_funcionario_vendedor = T2.cd_funcionario  ';
                SET @SQL += '     And t100.CD_Sequencial_historico = t300.cd_sequencial  ';
                SET @SQL += '     And T300.cd_situacao = 6),0)      ';
                SET @SQL += ' As ValorImportado';

                SET @SQL += ' ,(Select Count(T100.cd_sequencial_lote)  ';
                SET @SQL += ' From lote_contratos_contratos_vendedor T100, Dependentes T200, ASSOCIADOS T300, EMPRESA T400, TIPO_PAGAMENTO T500, lote_contratos t800 ';
                SET @SQL += ' Where T100.cd_sequencial_dep = T200.cd_sequencial And  ';
                SET @SQL += '    T200.cd_funcionario_vendedor = T2.cd_funcionario And  ';
                SET @SQL += '    T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
                            + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and ';
                SET @SQL += '    T200.cd_associado = T300.cd_associado and ';
                SET @SQL += '    T300.cd_empresa = T400.cd_empresa and ';
                SET @SQL += '    T400.TP_EMPRESA in (3) and ';
                SET @SQL += '    T400.cd_tipo_pagamento = T500.cd_tipo_pagamento and ';
                SET @SQL += '    t100.cd_sequencial_lote = t800.cd_sequencial And ';
                SET @SQL += '    T2.cd_equipe = T1.cd_equipe And ';
                SET @SQL += '   isnull(T500.fl_exige_Dados_cartao,0) = 1';
                SET @SQL += '    ) As contratosCartao ';

                SET @SQL += ' ,(Select Count(T100.cd_sequencial_lote)  ';
                SET @SQL += ' From lote_contratos_contratos_vendedor T100, Dependentes T200, ASSOCIADOS T300, EMPRESA T400, TIPO_PAGAMENTO T500, lote_contratos t800 ';
                SET @SQL += ' Where T100.cd_sequencial_dep = T200.cd_sequencial And  ';
                SET @SQL += '    T200.cd_funcionario_vendedor = T2.cd_funcionario And  ';
                SET @SQL += '    T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
                            + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and ';
                SET @SQL += '    T200.cd_associado = T300.cd_associado and ';
                SET @SQL += '    T300.cd_empresa = T400.cd_empresa and ';
                SET @SQL += '    T400.TP_EMPRESA in (3) and ';
                SET @SQL += '    T400.cd_tipo_pagamento = T500.cd_tipo_pagamento and ';
                SET @SQL += '    t100.cd_sequencial_lote = t800.cd_sequencial And ';
                SET @SQL += '    T2.cd_equipe = T1.cd_equipe and ';
                SET @SQL += '    isnull(T500.fl_exige_Dados_cartao,0) = 0 and ';
                SET @SQL += '    isnull(T500.fl_boleto,0) = 0 and ';
                SET @SQL += '    isnull(T500.fl_exige_dados_conta,0) = 1 ';
                SET @SQL += '    ) As contratosDebito ';


                SET @SQL += ',(Select Count(T100.cd_sequencial_lote)  ';
                SET @SQL += '  From lote_contratos_contratos_vendedor T100, Dependentes T200, ASSOCIADOS T300, EMPRESA T400, TIPO_PAGAMENTO T500, lote_contratos t800 ';
                SET @SQL += '  Where T100.cd_sequencial_dep = T200.cd_sequencial And  ';
                SET @SQL += '      T200.cd_funcionario_vendedor = T2.cd_funcionario And  ';
                SET @SQL += '      T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
                            + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and ';
                SET @SQL += '      T200.cd_associado = T300.cd_associado and ';
                SET @SQL += '      T400.TP_EMPRESA in (3) and ';
                SET @SQL += '      T300.cd_empresa = T400.cd_empresa and ';
                SET @SQL += '      T400.cd_tipo_pagamento = T500.cd_tipo_pagamento and ';
                SET @SQL += '      t100.cd_sequencial_lote = t800.cd_sequencial And';
                SET @SQL += '      T2.cd_equipe = T1.cd_equipe And ';
                SET @SQL += '      isnull(T500.fl_boleto,0) = 1';
                SET @SQL += '      )    As contratosBoleto';

                SET @SQL += ',(Select Count(T100.cd_sequencial_lote)  ';
                SET @SQL += '    From lote_contratos_contratos_vendedor T100, Dependentes T200, ASSOCIADOS T300, EMPRESA T400, TIPO_PAGAMENTO T500, lote_contratos t800 ';
                SET @SQL += '    Where T100.cd_sequencial_dep = T200.cd_sequencial And  ';
                SET @SQL += '        T200.cd_funcionario_vendedor = T2.cd_funcionario And  ';
                SET @SQL += '        T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
                            + ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and ';
                SET @SQL += '        T200.cd_associado = T300.cd_associado and ';
                SET @SQL += '        T300.cd_empresa = T400.cd_empresa and ';
                SET @SQL += '        T400.TP_EMPRESA in (1,4,5) and ';
                SET @SQL += '        t100.cd_sequencial_lote = t800.cd_sequencial And';
                SET @SQL += '        T2.cd_equipe = T1.cd_equipe And ';
                SET @SQL += '        T400.cd_tipo_pagamento = T500.cd_tipo_pagamento ';
                SET @SQL += '        )     As contratosConsignado';

                SET @SQL += '     ,(Select Count(T100.cd_sequencial_lote)  ';
                SET @SQL += '    From lote_contratos_contratos_vendedor T100, Dependentes T200, ASSOCIADOS T300, EMPRESA T400, TIPO_PAGAMENTO T500, lote_contratos t800 ';
                SET @SQL += '    Where T100.cd_sequencial_dep = T200.cd_sequencial And  ';
                SET @SQL += '        T200.cd_funcionario_vendedor = T2.cd_funcionario And  ';
                SET @SQL += '        T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
                            + ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and ';
                SET @SQL += '        T200.cd_associado = T300.cd_associado and ';
                SET @SQL += '        T300.cd_empresa = T400.cd_empresa and ';
                SET @SQL += '        T400.TP_EMPRESA in (2,6,7) and ';
                SET @SQL += '        t100.cd_sequencial_lote = t800.cd_sequencial And';
                SET @SQL += '        T2.cd_equipe = T1.cd_equipe And ';
                SET @SQL += '        T400.cd_tipo_pagamento = T500.cd_tipo_pagamento ';
                SET @SQL += '      )   As contratosPJ, ';

                SET @SQL += ' (Select IsNull(Count(distinct T200.cd_associado) , 0)  ';
                SET @SQL += '    From lote_contratos_contratos_vendedor T100, Dependentes T200, lote_contratos t800 ';
                SET @SQL += '    Where T100.cd_sequencial_dep = T200.cd_sequencial And ';
                SET @SQL += '        T200.cd_funcionario_vendedor = T2.cd_funcionario and ';
                SET @SQL += '        t100.cd_sequencial_lote = t800.cd_sequencial And';
                SET @SQL += '        T2.cd_equipe = T1.cd_equipe And ';
                SET @SQL += '        T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
                            + ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'')';
                SET @SQL += '     As QuantidadeAssociados, ';
                SET @SQL += ' isnull(T2.metaNovosPacientes, 0) metaNovosPacientes ';

                /* FROM e WHERE DA PROCEDURE */
                SET @SQL2 += ' From lote_contratos_contratos_vendedor T100, Dependentes T200, lote_contratos LC, Funcionario T2, equipe_vendas T1 ';
                SET @SQL2 += ' Where T100.cd_sequencial_dep = T200.cd_sequencial ';
                SET @SQL2 += ' And T100.cd_sequencial_lote = LC.cd_sequencial ';
                SET @SQL2 += ' and T200.cd_funcionario_vendedor = T2.cd_funcionario ';
                SET @SQL2 += ' and T2.cd_equipe = T1.cd_equipe  ';
                SET @SQL2 += ' and t2.cd_funcionario >= case when ''' + CONVERT(VARCHAR, @cd_funcionario)
                             + '''=0 then 0 else ''' + CONVERT(VARCHAR, @cd_funcionario) + ''' end ';
                SET @SQL2 += ' and t2.cd_funcionario <= case when ''' + CONVERT(VARCHAR, @cd_funcionario)
                             + '''=0 then 9999999999 else ''' + CONVERT(VARCHAR, @cd_funcionario) + ''' end ';
                SET @SQL2 += ' and t1.cd_equipe in (';
                SET @SQL2 += ' Select cd_equipe From equipe_vendas  where cd_equipe is not null ';
                SET @SQL2 += ' and (CD_CHEFE = ''' + CONVERT(VARCHAR, @cd_funcionario_supervisor) + '''';
                SET @SQL2 += ' or CD_CHEFE1 = ''' + CONVERT(VARCHAR, @cd_funcionario_supervisor) + '''';
                SET @SQL2 += ' or CD_CHEFE2 = ''' + CONVERT(VARCHAR, @cd_funcionario_supervisor) + ''')) ';
                SET @SQL2 += ' and T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
                             + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
                SET @SQL2 += ' and IsNull(t2.nr_cpf,'''') like case when ''' + @cpfvendedor
                             + ''' ='''' then ''%%'' else ''' + @cpfvendedor + ''' end ';

                IF (@CD_Equipe > 0)
                BEGIN
                    SET @SQL2 += ' And T1.cd_equipe = ' + CONVERT(VARCHAR, @CD_Equipe);
                END;

                SET @SQL2 += ' group by t2.nm_empregado, t2.cd_funcionario, t1.cd_Equipe, t1.nm_equipe, LC.cd_empresa, LC.cd_equipe, T2.cd_equipe, T2.metaNovosPacientes ';
                SET @SQL2 += ' Order By 6 Desc';
            END;
            ELSE
            BEGIN
                PRINT 3;


                /*COMENTADOS FORAM REALIZADOS OS JOINS*/

                ---- QuantidadeContrato   
                SET @SQL += 'Select distinct t2.nm_empregado, t2.cd_funcionario,  ';
                SET @SQL += 't1.cd_Equipe, t1.nm_equipe,';

                SET @SQL += '(Select Count(T100.cd_sequencial_lote)  ';
                --SET @SQL += 'From lote_contratos_contratos_vendedor T100, Dependentes T200 , ASSOCIADOS T300, 
                --EMPRESA T400, historico T500, UF AS uf, municipio AS mu, lote_contratos t800 ';
                --SET @SQL += 'Where T100.cd_sequencial_dep = T200.cd_sequencial And  ';
                --SET @SQL += 'T200.cd_funcionario_vendedor = T2.cd_funcionario And  '; WHERE
                --SET @SQL += ' t200.cd_associado = t300.cd_associado and ';
                --SET @SQL += ' t300.cd_empresa = t400.cd_empresa and';
                --SET @SQL += ' t200.cd_sequencial_historico = t500.cd_sequencial and';
                --SET @SQL += ' t300.cidid *= mu.cd_municipio And';
                --SET @SQL += ' t300.ufid *= uf.ufid and ';
                --SET @SQL += ' t100.cd_sequencial_lote = t800.cd_sequencial And';
                --SET @SQL += ' T2.cd_equipe = T1.cd_equipe And '; WHERE
                --SET @SQL += ' T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
                --            + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'''; WHERE


                SET @SQL += ' FROM dbo.lote_contratos_contratos_vendedor T100
                INNER JOIN dbo.DEPENDENTES T200 ON T200.CD_SEQUENCIAL = T100.cd_sequencial_dep
                INNER JOIN dbo.ASSOCIADOS T300 ON T300.cd_associado = T200.CD_ASSOCIADO
                INNER JOIN dbo.EMPRESA T400 ON T300.cd_empresa = T400.CD_EMPRESA
                INNER JOIN dbo.HISTORICO T500 ON T200.CD_Sequencial_historico = T500.cd_sequencial
                LEFT JOIN dbo.MUNICIPIO MU ON MU.CD_MUNICIPIO = T300.CidID
                LEFT JOIN dbo.UF ON UF.ufId = T300.ufId
                INNER JOIN dbo.lote_contratos T800 ON T800.cd_sequencial = T100.cd_sequencial_lote';


                SET @SQL += ' WHERE ';
                SET @SQL += ' T200.cd_funcionario_vendedor = T2.cd_funcionario And  ';
                SET @SQL += ' T2.cd_equipe = T1.cd_equipe And ';
                SET @SQL += ' T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
                            + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';


                IF (@uf <> -1)
                BEGIN
                    SET @SQL += ' And uf.ufid  = ' + CONVERT(VARCHAR, @uf);
                END;

                IF (@municipio <> -1)
                BEGIN
                    SET @SQL += ' And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
                END;

                IF @plano <> ''
                BEGIN
                    SET @SQL += ' and t200.cd_plano in (' + @plano + ')';
                END;

                IF @tipo_empresa <> ''
                BEGIN
                    SET @SQL += ' and t400.tp_empresa in (' + @tipo_empresa + ')';
                END;

                IF @situacao <> ''
                BEGIN
                    SET @SQL += ' and t500.cd_situacao in (' + @situacao + ') ';
                END;

                IF (@tipo_pagamento <> '')
                BEGIN
                    SET @SQL += ' and T400.cd_tipo_pagamento in (' + @tipo_pagamento + ')';
                END;

                IF (@grupoEmpresa > 0)
                BEGIN
                    SET @SQL = @SQL + ' and T400.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
                END;
                IF (@centroCusto > 0)
                BEGIN
                    SET @SQL = @SQL + ' and T400.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
                END;

                SET @SQL += ') As QuantidadeContrato,  ';


                /*COMENTADOS FORAM REALIZADOS OS JOINS*/

                ----ValorContrato      
                SET @SQL += '(Select IsNull(Sum(T100.vl_contrato),0)  ';
                --SET @SQL += 'From lote_contratos_contratos_vendedor T100, Dependentes T200 ,ASSOCIADOS T300, EMPRESA T400, historico T500, UF AS uf, municipio AS mu, lote_contratos t800 ';
                --SET @SQL += 'Where T100.cd_sequencial_dep = T200.cd_sequencial And  ';
                --SET @SQL += 'T200.cd_funcionario_vendedor = T2.cd_funcionario And  '; WHERE
                --SET @SQL += ' t200.cd_associado = t300.cd_associado and ';
                --SET @SQL += ' t300.cd_empresa = t400.cd_empresa and';
                --SET @SQL += ' t200.cd_sequencial_historico = t500.cd_sequencial and';
                --SET @SQL += ' t300.cidid *= mu.cd_municipio And';
                --SET @SQL += ' t300.ufid *= uf.ufid and ';
                --SET @SQL += ' t100.cd_sequencial_lote = t800.cd_sequencial And';
                --SET @SQL += ' T2.cd_equipe = T1.cd_equipe And '; WHERE
                --SET @SQL += ' T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
                --            + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'''; WHERE



                SET @SQL += ' FROM dbo.lote_contratos_contratos_vendedor T100
                INNER JOIN dbo.DEPENDENTES T200 ON T200.CD_SEQUENCIAL = T100.cd_sequencial_dep
                INNER JOIN dbo.ASSOCIADOS T300 ON T300.cd_associado = T200.CD_ASSOCIADO
                INNER JOIN dbo.EMPRESA T400 ON T300.cd_empresa = T400.CD_EMPRESA
                INNER JOIN dbo.HISTORICO T500 ON T200.CD_Sequencial_historico = T500.cd_sequencial
                LEFT JOIN dbo.MUNICIPIO MU ON MU.CD_MUNICIPIO = T300.CidID
                LEFT JOIN dbo.UF ON UF.ufId = T300.ufId
                INNER JOIN dbo.lote_contratos T800 ON T800.cd_sequencial = T100.cd_sequencial_lote ';


                SET @SQL += ' WHERE ';
                SET @SQL += 'T200.cd_funcionario_vendedor = T2.cd_funcionario And  ';
                SET @SQL += ' T2.cd_equipe = T1.cd_equipe And ';
                SET @SQL += ' T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
                            + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';





                IF (@uf <> -1)
                BEGIN
                    SET @SQL += ' And uf.ufid  = ' + CONVERT(VARCHAR, @uf);
                END;

                IF (@municipio <> -1)
                BEGIN
                    SET @SQL += ' And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
                END;

                IF @plano <> ''
                BEGIN
                    SET @SQL += ' and t200.cd_plano in (' + @plano + ')';
                END;

                IF @tipo_empresa <> ''
                BEGIN
                    SET @SQL += ' and t400.tp_empresa in (' + @tipo_empresa + ')';
                END;

                IF @situacao <> ''
                BEGIN
                    SET @SQL += ' and t500.cd_situacao in (' + @situacao + ') ';
                END;

                IF (@tipo_pagamento <> '')
                BEGIN
                    SET @SQL += ' and T400.cd_tipo_pagamento in (' + @tipo_pagamento + ')';
                END;

                IF (@grupoEmpresa > 0)
                BEGIN
                    SET @SQL = @SQL + ' and T400.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
                END;
                IF (@centroCusto > 0)
                BEGIN
                    SET @SQL = @SQL + ' and T400.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
                END;

                SET @SQL += ') As ValorContrato,  ';

                -- Numero de vidas contrato importado.  
                SET @SQL += 'IsNull((Select Count(T100.cd_sequencial)  ';
                SET @SQL += 'From Dependentes T100, Historico T300 ';
                SET @SQL += 'Where T100.cd_funcionario_vendedor = T2.cd_funcionario  ';
                SET @SQL += 'And t100.CD_Sequencial_historico = t300.cd_sequencial  ';
                SET @SQL += 'And T300.cd_situacao = 6),0)      ';
                SET @SQL += 'As QuantidadeImportado,  ';

                -- Valor de vidas contrato importado.  
                SET @SQL += 'IsNull((Select Sum(T100.vl_plano)  ';
                SET @SQL += 'From Dependentes T100, Historico T300 ';
                SET @SQL += 'Where T100.cd_funcionario_vendedor = T2.cd_funcionario  ';
                SET @SQL += 'And t100.CD_Sequencial_historico = t300.cd_sequencial  ';
                SET @SQL += 'And T300.cd_situacao = 6),0)      ';
                SET @SQL += 'As ValorImportado ';


                /*COMENTADOS FORAM REALIZADOS OS JOINS*/


                ----contratosCartao      
                SET @SQL += ',(Select Count(T100.cd_sequencial_lote)  ';
                --SET @SQL += 'From lote_contratos_contratos_vendedor T100, Dependentes T200, ASSOCIADOS T300, EMPRESA T400, 
                -- TIPO_PAGAMENTO T500, historico T600, UF AS uf, municipio AS mu, lote_contratos t800 ';
                --SET @SQL += 'Where T100.cd_sequencial_dep = T200.cd_sequencial And  ';
                --SET @SQL += 'T200.cd_funcionario_vendedor = T2.cd_funcionario And  '; WHERE
                --SET @SQL += 'T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
                --            + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' And ';
                --SET @SQL += 'T200.cd_associado = T300.cd_associado and ';
                --SET @SQL += 'T300.cd_empresa = T400.cd_empresa and ';
                --SET @SQL += 'T400.TP_EMPRESA in (3) and ';
                --SET @SQL += ' t200.cd_sequencial_historico = t600.cd_sequencial and ';
                --SET @SQL += ' t300.cidid *= mu.cd_municipio And ';
                --SET @SQL += ' t300.ufid *= uf.ufid And ';
                --SET @SQL += ' T400.cd_tipo_pagamento = T500.cd_tipo_pagamento and ';
                --SET @SQL += ' t100.cd_sequencial_lote = t800.cd_sequencial And';
                --SET @SQL += ' T2.cd_equipe = T1.cd_equipe And '; WHERE
                --SET @SQL += ' isnull(T500.fl_exige_Dados_cartao,0) = 1'; WHERE

                SET @SQL += '    FROM dbo.lote_contratos_contratos_vendedor T100
                INNER JOIN dbo.DEPENDENTES T200 ON T200.CD_SEQUENCIAL = T100.cd_sequencial_dep
                INNER JOIN dbo.ASSOCIADOS T300 ON T300.cd_associado = T200.CD_ASSOCIADO
                INNER JOIN dbo.EMPRESA T400 ON T300.cd_empresa = T400.CD_EMPRESA AND T400.TP_EMPRESA IN (3)
                INNER JOIN dbo.HISTORICO T600 ON T200.CD_Sequencial_historico = T600.cd_sequencial
                LEFT JOIN dbo.MUNICIPIO MU ON MU.CD_MUNICIPIO = T300.CidID
                LEFT JOIN dbo.UF ON UF.ufId = T300.ufId
                INNER JOIN dbo.TIPO_PAGAMENTO T500 ON T500.cd_tipo_pagamento = T400.cd_tipo_pagamento
                INNER JOIN dbo.lote_contratos T800 ON T800.cd_sequencial = T100.cd_sequencial_lote  ';

                SET @SQL += ' WHERE ';
                SET @SQL += '   T200.cd_funcionario_vendedor = T2.cd_funcionario And  ';
                SET @SQL += '   T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
                            + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' And ';
                SET @SQL += '   T2.cd_equipe = T1.cd_equipe And ';
                SET @SQL += '   isnull(T500.fl_exige_Dados_cartao,0) = 1';






                IF (@uf <> -1)
                BEGIN
                    SET @SQL += ' And uf.ufid  = ' + CONVERT(VARCHAR, @uf);
                END;

                IF (@municipio <> -1)
                BEGIN
                    SET @SQL += ' And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
                END;

                IF @plano <> ''
                BEGIN
                    SET @SQL += ' and t200.cd_plano in (' + @plano + ')';
                END;

                IF @tipo_empresa <> ''
                BEGIN
                    SET @SQL += ' and t400.tp_empresa in (' + @tipo_empresa + ')';
                END;

                IF @situacao <> ''
                BEGIN
                    SET @SQL += ' and t600.cd_situacao in (' + @situacao + ') ';
                END;

                IF (@tipo_pagamento <> '')
                BEGIN
                    SET @SQL += ' and T400.cd_tipo_pagamento in (' + @tipo_pagamento + ')';
                END;

                IF (@grupoEmpresa > 0)
                BEGIN
                    SET @SQL = @SQL + ' and T400.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
                END;
                IF (@centroCusto > 0)
                BEGIN
                    SET @SQL = @SQL + ' and T400.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
                END;

                SET @SQL += ') As contratosCartao ';



                /*COMENTADOS FORAM REALIZADOS OS JOINS*/


                ----contratosDebito      
                SET @SQL += ',(Select Count(T100.cd_sequencial_lote)  ';
                --SET @SQL += 'From lote_contratos_contratos_vendedor T100, Dependentes T200, ASSOCIADOS T300, 
                -- EMPRESA T400, TIPO_PAGAMENTO T500, historico T600, UF AS uf, municipio AS mu, lote_contratos t800 ';
                --SET @SQL += 'Where T100.cd_sequencial_dep = T200.cd_sequencial And  ';
                --SET @SQL += 'T200.cd_funcionario_vendedor = T2.cd_funcionario And  '; where
                --SET @SQL += 'T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
                --            + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' And '; where
                --SET @SQL += 'T200.cd_associado = T300.cd_associado and ';
                --SET @SQL += 'T300.cd_empresa = T400.cd_empresa and ';
                --SET @SQL += 'T400.TP_EMPRESA in (3) and ';
                --SET @SQL += ' t200.cd_sequencial_historico = t600.cd_sequencial and ';
                --SET @SQL += ' t300.cidid *= mu.cd_municipio And ';
                --SET @SQL += ' t300.ufid *= uf.ufid And ';
                --SET @SQL += ' T400.cd_tipo_pagamento = T500.cd_tipo_pagamento and ';
                --SET @SQL += ' t100.cd_sequencial_lote = t800.cd_sequencial And';
                --SET @SQL += ' T2.cd_equipe = T1.cd_equipe And '; where
                --SET @SQL += ' isnull(T500.fl_exige_Dados_cartao,0) = 0 and '; where
                --SET @SQL += ' isnull(T500.fl_boleto,0) = 0 and '; where 
                --SET @SQL += ' isnull(T500.fl_exige_dados_conta,0) = 1 '; where


                SET @SQL += ' FROM dbo.lote_contratos_contratos_vendedor t100 
                INNER JOIN dbo.DEPENDENTES t200 ON t200.CD_SEQUENCIAL = t100.cd_sequencial_dep
                INNER JOIN dbo.ASSOCIADOS t300 ON t200.CD_ASSOCIADO = t300.cd_associado
                INNER JOIN dbo.EMPRESA t400 ON t300.cd_empresa = t400.CD_EMPRESA AND t400.TP_EMPRESA IN (3)
                INNER JOIN dbo.HISTORICO t600 ON t200.CD_Sequencial_historico = t600.cd_sequencial
                LEFT JOIN dbo.MUNICIPIO mu ON mu.CD_MUNICIPIO = t300.CidID
                LEFT JOIN dbo.UF ON UF.ufId = t300.ufId
                INNER JOIN dbo.TIPO_PAGAMENTO t500 ON t500.cd_tipo_pagamento = t400.cd_tipo_pagamento
                INNER JOIN dbo.lote_contratos t800 ON t800.cd_sequencial = t100.cd_sequencial_lote';


                SET @SQL += ' where ';
                SET @SQL += 'T200.cd_funcionario_vendedor = T2.cd_funcionario And  ';
                SET @SQL += 'T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
                            + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' And ';
                SET @SQL += ' T2.cd_equipe = T1.cd_equipe And ';
                SET @SQL += ' isnull(T500.fl_exige_Dados_cartao,0) = 0 and ';
                SET @SQL += ' isnull(T500.fl_boleto,0) = 0 and ';
                SET @SQL += ' isnull(T500.fl_exige_dados_conta,0) = 1 ';




                IF (@uf <> -1)
                BEGIN
                    SET @SQL += ' And uf.ufid  = ' + CONVERT(VARCHAR, @uf);
                END;

                IF (@municipio <> -1)
                BEGIN
                    SET @SQL += ' And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
                END;

                IF @plano <> ''
                BEGIN
                    SET @SQL += ' and t200.cd_plano in (' + @plano + ')';
                END;

                IF @tipo_empresa <> ''
                BEGIN
                    SET @SQL += ' and t400.tp_empresa in (' + @tipo_empresa + ')';
                END;

                IF @situacao <> ''
                BEGIN
                    SET @SQL += ' and t600.cd_situacao in (' + @situacao + ') ';
                END;

                IF (@tipo_pagamento <> '')
                BEGIN
                    SET @SQL += ' and T400.cd_tipo_pagamento in (' + @tipo_pagamento + ')';
                END;

                IF (@grupoEmpresa > 0)
                BEGIN
                    SET @SQL = @SQL + ' and T400.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
                END;
                IF (@centroCusto > 0)
                BEGIN
                    SET @SQL = @SQL + ' and T400.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
                END;

                SET @SQL += ') As contratosDebito ';


                /*COMENTADOS FORAM REALIZADOS OS JOINS*/

                --contratosBoleto   
                SET @SQL += ',(Select Count(T100.cd_sequencial_lote)  ';
                --SET @SQL += 'From lote_contratos_contratos_vendedor T100, Dependentes T200, ASSOCIADOS T300, 
                --EMPRESA T400, TIPO_PAGAMENTO T500, historico T600, UF AS uf, municipio AS mu, lote_contratos t800 ';
                --SET @SQL += 'Where T100.cd_sequencial_dep = T200.cd_sequencial And  '; OK
                --SET @SQL += 'T200.cd_funcionario_vendedor = T2.cd_funcionario And  '; WHERE
                --SET @SQL += 'T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
                --            + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and '; WHERE
                --SET @SQL += 'T200.cd_associado = T300.cd_associado and '; OK
                --SET @SQL += 'T400.TP_EMPRESA in (3) and '; OK
                --SET @SQL += ' t200.cd_sequencial_historico = t600.cd_sequencial and '; OK
                --SET @SQL += ' t300.cidid *= mu.cd_municipio And '; OK
                --SET @SQL += ' t300.ufid *= uf.ufid And ';OK
                --SET @SQL += ' T300.cd_empresa = T400.cd_empresa and '; OK
                --SET @SQL += ' T400.cd_tipo_pagamento = T500.cd_tipo_pagamento and '; OK
                --SET @SQL += ' t100.cd_sequencial_lote = t800.cd_sequencial And'; OK
                --SET @SQL += ' T2.cd_equipe = T1.cd_equipe And ';
                --SET @SQL += ' isnull(T500.fl_boleto,0) = 1 ';



                SET @SQL += ' FROM dbo.lote_contratos_contratos_vendedor T100
                INNER JOIN dbo.DEPENDENTES T200 ON T200.CD_SEQUENCIAL = T100.cd_sequencial_dep
                INNER JOIN dbo.ASSOCIADOS T300 ON T300.cd_associado = T200.CD_ASSOCIADO
                INNER JOIN dbo.EMPRESA T400 ON T300.cd_empresa = T400.CD_EMPRESA AND T400.TP_EMPRESA IN (3)
                INNER JOIN dbo.HISTORICO T600 ON T200.CD_Sequencial_historico = T600.cd_sequencial
                LEFT JOIN dbo.MUNICIPIO MU ON MU.CD_MUNICIPIO = T300.CidID
                LEFT JOIN dbo.UF ON UF.ufId = T300.ufId
                INNER JOIN dbo.TIPO_PAGAMENTO T500 ON T500.cd_tipo_pagamento = T400.cd_tipo_pagamento
                INNER JOIN dbo.lote_contratos T800 ON T800.cd_sequencial = T100.cd_sequencial_lote ';


                SET @SQL += ' WHERE ';
                SET @SQL += '   T200.cd_funcionario_vendedor = T2.cd_funcionario And  ';
                SET @SQL += '   T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
                            + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and ';
                SET @SQL += '   T2.cd_equipe = T1.cd_equipe And ';
                SET @SQL += '   isnull(T500.fl_boleto,0) = 1 ';






                IF (@uf <> -1)
                BEGIN
                    SET @SQL += ' And uf.ufid  = ' + CONVERT(VARCHAR, @uf);
                END;

                IF (@municipio <> -1)
                BEGIN
                    SET @SQL += ' And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
                END;

                IF @plano <> ''
                BEGIN
                    SET @SQL += ' and t200.cd_plano in (' + @plano + ')';
                END;

                IF @tipo_empresa <> ''
                BEGIN
                    SET @SQL += ' and t400.tp_empresa in (' + @tipo_empresa + ')';
                END;

                IF @situacao <> ''
                BEGIN
                    SET @SQL += ' and t600.cd_situacao in (' + @situacao + ') ';
                END;

                IF (@tipo_pagamento <> '')
                BEGIN
                    SET @SQL += ' and T400.cd_tipo_pagamento in (' + @tipo_pagamento + ')';
                END;

                IF (@grupoEmpresa > 0)
                BEGIN
                    SET @SQL = @SQL + ' and T400.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
                END;
                IF (@centroCusto > 0)
                BEGIN
                    SET @SQL = @SQL + ' and T400.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
                END;

                SET @SQL += ') As contratosBoleto ';


                /*COMENTADOS FORAM REALIZADOS OS JOINS*/
                ----contratosConsignado
                SET @SQL += ',(Select Count(T100.cd_sequencial_lote)  ';
                --SET @SQL += 'From lote_contratos_contratos_vendedor T100, Dependentes T200, ASSOCIADOS T300, 
                -- EMPRESA T400, TIPO_PAGAMENTO T500, historico T600, UF AS uf, municipio AS mu, lote_contratos t800 ';
                --SET @SQL += 'Where T100.cd_sequencial_dep = T200.cd_sequencial And  ';
                --SET @SQL += 'T200.cd_funcionario_vendedor = T2.cd_funcionario And  '; WHERE
                --SET @SQL += 'T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
                --            + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and '; WHERE
                --SET @SQL += 'T200.cd_associado = T300.cd_associado and ';
                --SET @SQL += 'T300.cd_empresa = T400.cd_empresa and ';
                --SET @SQL += ' t200.cd_sequencial_historico = t600.cd_sequencial and ';
                --SET @SQL += ' t300.cidid *= mu.cd_municipio And ';
                --SET @SQL += ' t300.ufid *= uf.ufid And ';
                --SET @SQL += ' T400.TP_EMPRESA in (1,4,5) and ';
                --SET @SQL += ' T400.cd_tipo_pagamento = T500.cd_tipo_pagamento and ';
                --SET @SQL += ' t100.cd_sequencial_lote = t800.cd_sequencial And';
                --SET @SQL += ' T2.cd_equipe = T1.cd_equipe '; WHERE



                SET @SQL += '    FROM dbo.lote_contratos_contratos_vendedor T100
                INNER JOIN dbo.DEPENDENTES T200 ON T200.CD_SEQUENCIAL = T100.cd_sequencial_dep
                INNER JOIN dbo.ASSOCIADOS T300 ON T200.CD_ASSOCIADO = T300.cd_associado
                INNER JOIN dbo.EMPRESA T400 ON T300.cd_empresa = T400.CD_EMPRESA AND T400.TP_EMPRESA IN (1,4,5)
                INNER JOIN dbo.HISTORICO T600 ON T200.CD_Sequencial_historico = T600.cd_sequencial
                LEFT JOIN dbo.MUNICIPIO MU ON MU.CD_MUNICIPIO = T300.CidID
                LEFT JOIN dbo.UF ON UF.ufId = T300.ufId
                INNER JOIN dbo.TIPO_PAGAMENTO T500 ON T500.cd_tipo_pagamento = T400.cd_tipo_pagamento
                INNER JOIN dbo.lote_contratos T800 ON T800.cd_sequencial = T100.cd_sequencial_lote  ';


                SET @SQL += ' WHERE ';
                SET @SQL += '   T200.cd_funcionario_vendedor = T2.cd_funcionario And  ';
                SET @SQL += '   T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
                            + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and ';
                SET @SQL += '   T2.cd_equipe = T1.cd_equipe ';



                IF (@uf <> -1)
                BEGIN
                    SET @SQL += ' And uf.ufid  = ' + CONVERT(VARCHAR, @uf);
                END;

                IF (@municipio <> -1)
                BEGIN
                    SET @SQL += ' And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
                END;

                IF @plano <> ''
                BEGIN
                    SET @SQL += ' and t200.cd_plano in (' + @plano + ')';
                END;

                IF @tipo_empresa <> ''
                BEGIN
                    SET @SQL += ' and t400.tp_empresa in (' + @tipo_empresa + ')';
                END;

                IF @situacao <> ''
                BEGIN
                    SET @SQL += ' and t600.cd_situacao in (' + @situacao + ') ';
                END;

                IF (@tipo_pagamento <> '')
                BEGIN
                    SET @SQL += ' and T400.cd_tipo_pagamento in (' + @tipo_pagamento + ')';
                END;

                IF (@grupoEmpresa > 0)
                BEGIN
                    SET @SQL = @SQL + ' and T400.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
                END;
                IF (@centroCusto > 0)
                BEGIN
                    SET @SQL = @SQL + ' and T400.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
                END;

                SET @SQL += ') As contratosConsignado ';


                /*COMENTADOS FORAM REALIZADOS OS JOINS*/

                ----contratosPJ
                SET @SQL += ',(Select Count(T100.cd_sequencial_lote)  ';
                --SET @SQL += 'From lote_contratos_contratos_vendedor T100, Dependentes T200, ASSOCIADOS T300, 
                -- EMPRESA T400, TIPO_PAGAMENTO T500 , historico T600, UF AS uf, municipio AS mu, lote_contratos t800 ';
                --SET @SQL += 'Where T100.cd_sequencial_dep = T200.cd_sequencial And  ';
                --SET @SQL += 'T200.cd_funcionario_vendedor = T2.cd_funcionario And  ';
                --SET @SQL += 'T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
                --            + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''and ';
                --SET @SQL += 'T200.cd_associado = T300.cd_associado and ';
                --SET @SQL += 'T300.cd_empresa = T400.cd_empresa and ';
                --SET @SQL += ' t200.cd_sequencial_historico = t600.cd_sequencial and ';
                --SET @SQL += ' t300.cidid *= mu.cd_municipio And ';
                --SET @SQL += ' t300.ufid *= uf.ufid And ';
                --SET @SQL += ' T400.TP_EMPRESA in (2,6,7) and ';
                --SET @SQL += ' T400.cd_tipo_pagamento = T500.cd_tipo_pagamento and ';
                --SET @SQL += ' t100.cd_sequencial_lote = t800.cd_sequencial And';
                --SET @SQL += ' T2.cd_equipe = T1.cd_equipe ';


                SET @SQL += '    FROM dbo.lote_contratos_contratos_vendedor T100
                INNER JOIN dbo.DEPENDENTES T200 ON T200.CD_SEQUENCIAL = T100.cd_sequencial_dep
                INNER JOIN dbo.ASSOCIADOS T300 ON T300.cd_associado = T200.CD_ASSOCIADO
                INNER JOIN dbo.EMPRESA T400 ON T300.cd_empresa = T400.CD_EMPRESA AND T400.TP_EMPRESA IN (2,6,7)
                INNER JOIN dbo.HISTORICO T600 ON T200.CD_Sequencial_historico = T600.cd_sequencial
                LEFT JOIN dbo.MUNICIPIO MU ON MU.CD_MUNICIPIO = T300.CidID
                LEFT JOIN dbo.UF ON UF.ufId = T300.ufId
                INNER JOIN dbo.TIPO_PAGAMENTO T500 ON T500.cd_tipo_pagamento = T400.cd_tipo_pagamento
                INNER JOIN dbo.lote_contratos T800 ON T800.cd_sequencial = T100.cd_sequencial_lote  ';


                SET @SQL += ' WHERE ';
                SET @SQL += 'T200.cd_funcionario_vendedor = T2.cd_funcionario And  ';
                SET @SQL += 'T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
                            + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''and ';
                SET @SQL += ' T2.cd_equipe = T1.cd_equipe ';


                IF (@uf <> -1)
                BEGIN
                    SET @SQL += ' And uf.ufid  = ' + CONVERT(VARCHAR, @uf);
                END;

                IF (@municipio <> -1)
                BEGIN
                    SET @SQL += ' And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
                END;

                IF @plano <> ''
                BEGIN
                    SET @SQL += ' and t200.cd_plano in (' + @plano + ')';
                END;

                IF @tipo_empresa <> ''
                BEGIN
                    SET @SQL += ' and t400.tp_empresa in (' + @tipo_empresa + ')';
                END;

                IF @situacao <> ''
                BEGIN
                    SET @SQL += ' and t600.cd_situacao in (' + @situacao + ') ';
                END;

                IF (@tipo_pagamento <> '')
                BEGIN
                    SET @SQL += ' and T400.cd_tipo_pagamento in (' + @tipo_pagamento + ')';
                END;

                IF (@grupoEmpresa > 0)
                BEGIN
                    SET @SQL = @SQL + ' and T400.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
                END;
                IF (@centroCusto > 0)
                BEGIN
                    SET @SQL = @SQL + ' and T400.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
                END;

                SET @SQL += ') As contratosPJ, ';


                /*COMENTADOS FORAM REALIZADOS OS JOINS*/

                --QuantidadeAssociados     
                SET @SQL += '(Select IsNull(Count(distinct T200.cd_associado),0)  ';
                --SET @SQL += 'From lote_contratos_contratos_vendedor T100, Dependentes T200 , 
                -- associados t300, empresa t400, historico t500, UF AS uf, municipio AS mu, lote_contratos t800 ';
                --SET @SQL += 'Where T100.cd_sequencial_dep = T200.cd_sequencial And  ';
                --SET @SQL += '      t200.cd_associado = t300.cd_associado and ';
                --SET @SQL += '      t300.cd_empresa = t400.cd_empresa and ';
                --SET @SQL += '      t200.cd_sequencial_historico = t500.cd_sequencial and ';
                --SET @SQL += '      t300.cidid *= mu.cd_municipio And ';
                --SET @SQL += '      t300.ufid *= uf.ufid And ';
                --SET @SQL += '      T200.cd_funcionario_vendedor = T2.cd_funcionario And  ';
                --SET @SQL += '      t100.cd_sequencial_lote = t800.cd_sequencial And';
                --SET @SQL += '      T2.cd_equipe = T1.cd_equipe And ';
                --SET @SQL += '      T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
                --            + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';


                SET @SQL += '    FROM dbo.lote_contratos_contratos_vendedor T100
                INNER JOIN dbo.DEPENDENTES T200 ON T200.CD_SEQUENCIAL = T100.cd_sequencial_dep
                INNER JOIN dbo.ASSOCIADOS T300 ON T300.cd_associado = T200.CD_ASSOCIADO
                INNER JOIN dbo.EMPRESA T400 ON T300.cd_empresa = T400.CD_EMPRESA
                INNER JOIN dbo.HISTORICO T500 ON T200.CD_Sequencial_historico = T500.cd_sequencial
                LEFT JOIN dbo.MUNICIPIO MU ON MU.CD_MUNICIPIO = T300.CidID
                LEFT JOIN dbo.UF ON UF.ufId = T300.ufId
                INNER JOIN dbo.lote_contratos T800 ON T800.cd_sequencial = T100.cd_sequencial_lote ';


                SET @SQL += ' WHERE ';
                SET @SQL += '      T200.cd_funcionario_vendedor = T2.cd_funcionario And  ';
                SET @SQL += '      T2.cd_equipe = T1.cd_equipe And ';
                SET @SQL += '      T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
                            + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';

                IF (@uf <> -1)
                BEGIN
                    SET @SQL += ' And uf.ufid  = ' + CONVERT(VARCHAR, @uf);
                END;

                IF (@municipio <> -1)
                BEGIN
                    SET @SQL += 'And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
                END;

                IF @plano <> ''
                BEGIN
                    SET @SQL += ' and t200.cd_plano in (' + @plano + ')';
                END;

                IF @tipo_empresa <> ''
                BEGIN
                    SET @SQL += ' and t400.tp_empresa in (' + @tipo_empresa + ')';
                END;

                IF @situacao <> ''
                BEGIN
                    SET @SQL += ' and t500.cd_situacao in (' + @situacao + ') ';
                END;

                IF (@tipo_pagamento <> '')
                BEGIN
                    SET @SQL += ' and T400.cd_tipo_pagamento in (' + @tipo_pagamento + ')';
                END;

                IF (@grupoEmpresa > 0)
                BEGIN
                    SET @SQL = @SQL + ' and T400.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
                END;
                IF (@centroCusto > 0)
                BEGIN
                    SET @SQL = @SQL + ' and T400.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
                END;

                SET @SQL += ') As QuantidadeAssociados, ';
                SET @SQL += ' isnull(T2.metaNovosPacientes, 0) metaNovosPacientes ';

                /* FROM e WHERE DA PROCEDURE */
                SET @SQL2 += ' From lote_contratos_contratos_vendedor T100, Dependentes T200, lote_contratos LC, Funcionario T2, equipe_vendas T1 ';
                SET @SQL2 += ' Where T100.cd_sequencial_dep = T200.cd_sequencial ';
                SET @SQL2 += ' And T100.cd_sequencial_lote = LC.cd_sequencial ';
                SET @SQL2 += ' and T200.cd_funcionario_vendedor = T2.cd_funcionario ';
                SET @SQL2 += ' and T2.cd_equipe = T1.cd_equipe  ';
                SET @SQL2 += ' and t2.cd_funcionario >= case when ''' + CONVERT(VARCHAR, @cd_funcionario)
                             + '''=0 then 0 else ''' + CONVERT(VARCHAR, @cd_funcionario) + ''' end ';
                SET @SQL2 += ' and t2.cd_funcionario <= case when ''' + CONVERT(VARCHAR, @cd_funcionario)
                             + '''=0 then 9999999999 else ''' + CONVERT(VARCHAR, @cd_funcionario) + ''' end ';
                SET @SQL2 += ' and T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
                             + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
                SET @SQL2 += ' and IsNull(t2.nr_cpf,'''') like case when ''' + @cpfvendedor
                             + ''' ='''' then ''%%'' else ''' + @cpfvendedor + ''' end ';

                IF (@CD_Equipe > 0)
                BEGIN
                    SET @SQL2 += ' And T1.cd_equipe = ' + CONVERT(VARCHAR, @CD_Equipe);
                END;

                SET @SQL2 += ' group by t2.nm_empregado, t2.cd_funcionario, t1.cd_Equipe, t1.nm_equipe, LC.cd_empresa, LC.cd_equipe, T2.cd_equipe, T2.metaNovosPacientes ';
                SET @SQL2 += ' Order By 6 Desc ';
            END;
        END;
    END;
    ELSE
    BEGIN
        IF @CD_Equipe > 0
        BEGIN
            PRINT 4;



            /*COMENTADOS FORAM REALIZADOS OS JOINS*/

            ---- Valor do Contrato
            SET @SQL += 'Select distinct t2.nm_empregado, t2.cd_funcionario,  T1.cd_equipe, t1.nm_equipe,';
            SET @SQL += '(Select Count(T100.cd_sequencial_lote)  ';
            --SET @SQL += 'From lote_contratos_contratos_vendedor T100, Dependentes T200, associados t300, 
            --empresa t400, historico t500, UF AS uf, municipio AS mu, lote_contratos t800 ';
            --SET @SQL += ' Where T100.cd_sequencial_dep = T200.cd_sequencial And  ';
            --SET @SQL += '      T200.cd_funcionario_vendedor = T2.cd_funcionario And  '; where
            --SET @SQL += '      t200.cd_associado = t300.cd_associado and ';
            --SET @SQL += '      t300.cd_empresa = t400.cd_empresa and';
            --SET @SQL += '      t200.cd_sequencial_historico = t500.cd_sequencial and';
            --SET @SQL += '      t300.cidid *= mu.cd_municipio And';
            --SET @SQL += '      t300.ufid *= uf.ufid And';
            --SET @SQL += '      t100.cd_sequencial_lote = t800.cd_sequencial And';
            --SET @SQL += '      T2.cd_equipe = T1.cd_equipe '; where


            SET @SQL += '    FROM dbo.lote_contratos_contratos_vendedor t100 
            INNER JOIN dbo.DEPENDENTES t200 ON t200.CD_SEQUENCIAL = t100.cd_sequencial_dep
            INNER JOIN dbo.ASSOCIADOS t300 ON t300.cd_associado = t200.CD_ASSOCIADO
            INNER JOIN dbo.EMPRESA t400 ON t300.cd_empresa = t400.CD_EMPRESA
            INNER JOIN dbo.HISTORICO t500 ON t200.CD_Sequencial_historico = t500.cd_sequencial
            LEFT JOIN dbo.MUNICIPIO mu ON mu.CD_MUNICIPIO = t300.CidID
            LEFT JOIN dbo.UF ON UF.ufId = t300.ufId
            INNER JOIN dbo.lote_contratos t800 ON t800.cd_sequencial = t100.cd_sequencial_lote  ';

            SET @SQL += ' WHERE ';
            SET @SQL += '      T200.cd_funcionario_vendedor = T2.cd_funcionario And  ';
            SET @SQL += '      T2.cd_equipe = T1.cd_equipe ';




            IF (@uf <> -1)
            BEGIN
                SET @SQL += ' And uf.ufid  = ' + CONVERT(VARCHAR, @uf);
            END;

            IF (@municipio <> -1)
            BEGIN
                SET @SQL += ' And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
            END;

            IF @plano <> ''
            BEGIN
                SET @SQL += ' and t200.cd_plano in (' + @plano + ')';
            END;

            IF @tipo_empresa <> ''
            BEGIN
                SET @SQL += ' and t400.tp_empresa in (' + @tipo_empresa + ')';
            END;

            IF @situacao <> ''
            BEGIN
                SET @SQL += ' and t500.cd_situacao in (' + @situacao + ') ';
            END;

            IF (@tipo_pagamento <> '')
            BEGIN
                SET @SQL += ' and T400.cd_tipo_pagamento in (' + @tipo_pagamento + ')';
            END;

            IF (@grupoEmpresa > 0)
            BEGIN
                SET @SQL = @SQL + ' and T400.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
            END;
            IF (@centroCusto > 0)
            BEGIN
                SET @SQL = @SQL + ' and T400.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
            END;

            SET @SQL += ' and T100.dt_assinaturaContrato between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
                        + ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'')';
            SET @SQL += ' As QuantidadeContrato, ';


            /*COMENTADOS FORAM REALIZADOS OS JOINS*/

            SET @SQL += '(Select IsNull(Sum(T100.vl_contrato),0)  ';
            --SET @SQL += 'From lote_contratos_contratos_vendedor T100, Dependentes T200, associados t300, 
            -- empresa t400, historico t500, UF AS uf, municipio AS mu, lote_contratos t800 ';
            --SET @SQL += ' Where T100.cd_sequencial_dep = T200.cd_sequencial And  ';
            --SET @SQL += '      T200.cd_funcionario_vendedor = T2.cd_funcionario And  '; WHERE
            --SET @SQL += '      t200.cd_associado = t300.cd_associado and ';
            --SET @SQL += '      t300.cd_empresa = t400.cd_empresa and';
            --SET @SQL += '      t200.cd_sequencial_historico = t500.cd_sequencial and';
            --SET @SQL += '      t300.cidid *= mu.cd_municipio And';
            --SET @SQL += '      t300.ufid *= uf.ufid And';
            --SET @SQL += '      t100.cd_sequencial_lote = t800.cd_sequencial And';
            --SET @SQL += '      T2.cd_equipe = T1.cd_equipe '; WHERE


            SET @SQL += '    FROM dbo.lote_contratos_contratos_vendedor t100 
            INNER JOIN dbo.DEPENDENTES t200 ON t200.CD_SEQUENCIAL = t100.cd_sequencial_dep
            INNER JOIN dbo.ASSOCIADOS t300 ON t300.cd_associado = t200.CD_ASSOCIADO
            INNER JOIN dbo.EMPRESA t400 ON t300.cd_empresa = t400.CD_EMPRESA
            INNER JOIN dbo.HISTORICO t500 ON t200.CD_Sequencial_historico = t500.cd_sequencial
            LEFT JOIN dbo.MUNICIPIO mu ON mu.CD_MUNICIPIO = t300.CidID
            LEFT JOIN dbo.UF ON UF.ufId = t300.ufId
            INNER JOIN dbo.lote_contratos t800 ON t800.cd_sequencial = t100.cd_sequencial_lote  ';

            SET @SQL += ' WHERE ';
            SET @SQL += '      T200.cd_funcionario_vendedor = T2.cd_funcionario And  ';
            SET @SQL += '      T2.cd_equipe = T1.cd_equipe ';





            IF (@uf <> -1)
            BEGIN
                SET @SQL += ' And uf.ufid  = ' + CONVERT(VARCHAR, @uf);
            END;

            IF (@municipio <> -1)
            BEGIN
                SET @SQL += ' And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
            END;

            IF @plano <> ''
            BEGIN
                SET @SQL += ' and t200.cd_plano in (' + @plano + ')';
            END;

            IF @tipo_empresa <> ''
            BEGIN
                SET @SQL += ' and t400.tp_empresa in (' + @tipo_empresa + ')';
            END;

            IF @situacao <> ''
            BEGIN
                SET @SQL += ' and t500.cd_situacao in (' + @situacao + ') ';
            END;

            IF (@tipo_pagamento <> '')
            BEGIN
                SET @SQL += ' and T400.cd_tipo_pagamento in (' + @tipo_pagamento + ')';
            END;

            IF (@grupoEmpresa > 0)
            BEGIN
                SET @SQL = @SQL + ' and T400.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
            END;
            IF (@centroCusto > 0)
            BEGIN
                SET @SQL = @SQL + ' and T400.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
            END;

            SET @SQL += ' and T100.dt_assinaturaContrato between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
                        + ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'')';
            SET @SQL += ' As ValorContrato,  ';

            -- Numero de vidas contrato importado.  
            SET @SQL += 'IsNull((Select Count(T100.cd_sequencial)  ';
            SET @SQL += 'From Dependentes T100, Historico T300 ';
            SET @SQL += 'Where T100.cd_funcionario_vendedor = T2.cd_funcionario  ';
            SET @SQL += '   And t100.CD_Sequencial_historico = t300.cd_sequencial  ';
            SET @SQL += '   And T300.cd_situacao = 6),0)      ';
            SET @SQL += 'As QuantidadeImportado, ';

            -- Valor de vidas contrato importado.  '
            SET @SQL += ' IsNull((Select Sum(T100.vl_plano)  ';
            SET @SQL += 'From Dependentes T100, Historico T300 ';
            SET @SQL += 'Where T100.cd_funcionario_vendedor = T2.cd_funcionario ';
            SET @SQL += '   And t100.CD_Sequencial_historico = t300.cd_sequencial ';
            SET @SQL += '   And T300.cd_situacao = 6),0)      ';
            SET @SQL += 'As ValorImportado ';

            -- contratoCartÃƒÂ£o
            SET @SQL += ',(Select Count(T100.cd_sequencial_lote)  ';
            SET @SQL += '  From lote_contratos_contratos_vendedor T100, Dependentes T200, ASSOCIADOS T300, 
            EMPRESA T400, TIPO_PAGAMENTO T500, historico t600, UF AS uf, municipio AS mu, lote_contratos t800 ';
            SET @SQL += '  Where T100.cd_sequencial_dep = T200.cd_sequencial And  ';
            SET @SQL += '      T200.cd_funcionario_vendedor = T2.cd_funcionario And  ';
            SET @SQL += '      T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
                        + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and ';
            SET @SQL += '      T200.cd_associado = T300.cd_associado and ';
            SET @SQL += '      T300.cd_empresa = T400.cd_empresa and ';
            SET @SQL += '      T400.TP_EMPRESA in (3) and ';
            SET @SQL += '      T400.cd_tipo_pagamento = T500.cd_tipo_pagamento and ';
            SET @SQL += '      t200.cd_sequencial_historico = t600.cd_sequencial and';
            SET @SQL += '      t300.cidid *= mu.cd_municipio And ';
            SET @SQL += '      t300.ufid *= uf.ufid and ';
            SET @SQL += '      t100.cd_sequencial_lote = t800.cd_sequencial And';
            SET @SQL += '      T2.cd_equipe = T1.cd_equipe ';

            IF (@uf <> -1)
            BEGIN
                SET @SQL += ' And uf.ufid  = ' + CONVERT(VARCHAR, @uf);
            END;

            IF (@municipio <> -1)
            BEGIN
                SET @SQL += ' And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
            END;

            IF @plano <> ''
            BEGIN
                SET @SQL += ' and t200.cd_plano in (' + @plano + ')';
            END;

            IF @tipo_empresa <> ''
            BEGIN
                SET @SQL += ' and t400.tp_empresa in (' + @tipo_empresa + ')';
            END;

            IF @situacao <> ''
            BEGIN
                SET @SQL += ' and t600.cd_situacao in (' + @situacao + ') ';
            END;

            IF (@tipo_pagamento <> '')
            BEGIN
                SET @SQL += ' and T400.cd_tipo_pagamento in (' + @tipo_pagamento + ')';
            END;

            IF (@grupoEmpresa > 0)
            BEGIN
                SET @SQL = @SQL + ' and T400.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
            END;
            IF (@centroCusto > 0)
            BEGIN
                SET @SQL = @SQL + ' and T400.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
            END;

            SET @SQL += ' and isnull(T500.fl_exige_Dados_cartao,0) = 1';
            SET @SQL += '      ) As contratosCartao ';



            /*COMENTADOS FORAM REALIZADOS OS JOINS*/


            -- contratoDebito
            SET @SQL += ',(Select Count(T100.cd_sequencial_lote)  ';
            --SET @SQL += '  From lote_contratos_contratos_vendedor T100, Dependentes T200, ASSOCIADOS T300, EMPRESA T400, TIPO_PAGAMENTO T500, historico t600, UF AS uf, municipio AS mu, lote_contratos t800 ';
            --SET @SQL += '  Where T100.cd_sequencial_dep = T200.cd_sequencial And  ';
            --SET @SQL += '      T200.cd_funcionario_vendedor = T2.cd_funcionario And  '; WHERE
            --SET @SQL += '      T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
            --            + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and '; WHERE
            --SET @SQL += '      T200.cd_associado = T300.cd_associado and ';
            --SET @SQL += '      T300.cd_empresa = T400.cd_empresa and ';
            --SET @SQL += '      T400.TP_EMPRESA in (3) and ';
            --SET @SQL += '      T400.cd_tipo_pagamento = T500.cd_tipo_pagamento and ';
            --SET @SQL += '      t200.cd_sequencial_historico = t600.cd_sequencial and';
            --SET @SQL += '      t300.cidid *= mu.cd_municipio And ';
            --SET @SQL += '      t300.ufid *= uf.ufid and ';
            --SET @SQL += '      t100.cd_sequencial_lote = t800.cd_sequencial And';
            --SET @SQL += '      T2.cd_equipe = T1.cd_equipe '; WHERE


            SET @SQL += '    FROM dbo.lote_contratos_contratos_vendedor T100
            INNER JOIN dbo.DEPENDENTES T200 ON T200.CD_SEQUENCIAL = T100.cd_sequencial_dep
            INNER JOIN dbo.ASSOCIADOS T300 ON T300.cd_associado = T200.CD_ASSOCIADO
            INNER JOIN dbo.EMPRESA T400 ON T300.cd_empresa = T400.CD_EMPRESA AND T400.TP_EMPRESA IN (3)
            INNER JOIN dbo.TIPO_PAGAMENTO T500 ON T500.cd_tipo_pagamento = T400.cd_tipo_pagamento
            INNER JOIN dbo.HISTORICO T600 ON T200.CD_Sequencial_historico = T600.cd_sequencial
            LEFT JOIN dbo.MUNICIPIO MU ON MU.CD_MUNICIPIO = T300.CidID
            LEFT JOIN dbo.UF UF ON UF.ufId = T300.ufId
            INNER JOIN dbo.lote_contratos T800 ON T800.cd_sequencial = T100.cd_sequencial_lote  ';


            SET @SQL += ' WHERE ';
            SET @SQL += '      T200.cd_funcionario_vendedor = T2.cd_funcionario And  ';
            SET @SQL += '      T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
                        + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and ';
            SET @SQL += '      T2.cd_equipe = T1.cd_equipe ';



            IF (@uf <> -1)
            BEGIN
                SET @SQL += ' And uf.ufid  = ' + CONVERT(VARCHAR, @uf);
            END;

            IF (@municipio <> -1)
            BEGIN
                SET @SQL += ' And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
            END;

            IF @plano <> ''
            BEGIN
                SET @SQL += ' and t200.cd_plano in (' + @plano + ')';
            END;

            IF @tipo_empresa <> ''
            BEGIN
                SET @SQL += ' and t400.tp_empresa in (' + @tipo_empresa + ')';
            END;

            IF @situacao <> ''
            BEGIN
                SET @SQL += ' and t600.cd_situacao in (' + @situacao + ') ';
            END;

            IF (@tipo_pagamento <> '')
            BEGIN
                SET @SQL += ' and T400.cd_tipo_pagamento in (' + @tipo_pagamento + ')';
            END;

            IF (@grupoEmpresa > 0)
            BEGIN
                SET @SQL = @SQL + ' and T400.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
            END;
            IF (@centroCusto > 0)
            BEGIN
                SET @SQL = @SQL + ' and T400.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
            END;

            SET @SQL += ' and isnull(T500.fl_exige_Dados_cartao,0) = 0';
            SET @SQL += ' and isnull(T500.fl_boleto,0) = 0';
            SET @SQL += ' and isnull(T500.fl_exige_dados_conta,0) = 1';
            SET @SQL += '      ) As contratoDebito ';



            /*COMENTADOS FORAM REALIZADOS OS JOINS*/
            -- contratosBoleto
            SET @SQL += ',(Select Count(T100.cd_sequencial_lote)  ';
            --SET @SQL += '  From lote_contratos_contratos_vendedor T100, Dependentes T200, ASSOCIADOS T300, 
            -- EMPRESA T400, TIPO_PAGAMENTO T500, historico t600, UF AS uf, municipio AS mu, lote_contratos t800 ';
            --SET @SQL += '  Where T100.cd_sequencial_dep = T200.cd_sequencial And  ';
            --SET @SQL += '      T200.cd_funcionario_vendedor = T2.cd_funcionario And  '; WHERE
            --SET @SQL += '      T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
            --            + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and '; WHERE
            --SET @SQL += '      T200.cd_associado = T300.cd_associado and ';
            --SET @SQL += '      t300.ufid *= uf.ufid and ';
            --SET @SQL += '      T400.TP_EMPRESA in (3) and ';
            --SET @SQL += '      T300.cd_empresa = T400.cd_empresa and ';
            --SET @SQL += '      T400.cd_tipo_pagamento = T500.cd_tipo_pagamento and ';
            --SET @SQL += '      t200.cd_sequencial_historico = t600.cd_sequencial and';
            --SET @SQL += '      t300.cidid *= mu.cd_municipio And ';
            --SET @SQL += '      t100.cd_sequencial_lote = t800.cd_sequencial And';
            --SET @SQL += '      T2.cd_equipe = T1.cd_equipe And '; WHERE
            --SET @SQL += '      isnull(T500.fl_boleto,0) = 1'; WHERE

            SET @SQL += '    FROM dbo.lote_contratos_contratos_vendedor T100
            INNER JOIN dbo.DEPENDENTES T200 ON T200.CD_SEQUENCIAL = T100.cd_sequencial_dep
            INNER JOIN dbo.ASSOCIADOS T300 ON T300.cd_associado = T200.CD_ASSOCIADO
            LEFT JOIN dbo.UF UF ON UF.ufId = T300.ufId
            INNER JOIN dbo.EMPRESA T400 ON T300.cd_empresa = T400.CD_EMPRESA AND T400.TP_EMPRESA IN (3)
            INNER JOIN dbo.TIPO_PAGAMENTO T500 ON T500.cd_tipo_pagamento = T400.cd_tipo_pagamento
            INNER JOIN dbo.HISTORICO T600 ON T200.CD_Sequencial_historico = T600.cd_sequencial
            LEFT JOIN dbo.MUNICIPIO MU ON MU.CD_MUNICIPIO = T300.CidID
            INNER JOIN dbo.lote_contratos T800 ON T800.cd_sequencial = T100.cd_sequencial_lote  ';


            SET @SQL += ' WHERE ';
            SET @SQL += '      T200.cd_funcionario_vendedor = T2.cd_funcionario And  ';
            SET @SQL += '      T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
                        + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and ';
            SET @SQL += '      T2.cd_equipe = T1.cd_equipe And ';
            SET @SQL += '      isnull(T500.fl_boleto,0) = 1';




            IF (@uf <> -1)
            BEGIN
                SET @SQL += ' And uf.ufid  = ' + CONVERT(VARCHAR, @uf);
            END;

            IF (@municipio <> -1)
            BEGIN
                SET @SQL += ' And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
            END;

            IF @plano <> ''
            BEGIN
                SET @SQL += ' and t200.cd_plano in (' + @plano + ')';
            END;

            IF @tipo_empresa <> ''
            BEGIN
                SET @SQL += ' and t400.tp_empresa in (' + @tipo_empresa + ')';
            END;

            IF @situacao <> ''
            BEGIN
                SET @SQL += ' and t600.cd_situacao in (' + @situacao + ') ';
            END;

            IF (@tipo_pagamento <> '')
            BEGIN
                SET @SQL += ' and T400.cd_tipo_pagamento in (' + @tipo_pagamento + ')';
            END;

            IF (@grupoEmpresa > 0)
            BEGIN
                SET @SQL = @SQL + ' and T400.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
            END;
            IF (@centroCusto > 0)
            BEGIN
                SET @SQL = @SQL + ' and T400.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
            END;

            SET @SQL += '      ) As contratosBoleto ';


            /*COMENTADOS FORAM REALIZADOS OS JOINS*/


            ---- contratosConsignado
            SET @SQL += ',(Select Count(T100.cd_sequencial_lote)  ';
            --SET @SQL += '  From lote_contratos_contratos_vendedor T100, Dependentes T200, 
            --ASSOCIADOS T300, EMPRESA T400, TIPO_PAGAMENTO T500, historico t600, UF AS uf, municipio AS mu, lote_contratos t800 ';
            --SET @SQL += '  Where T100.cd_sequencial_dep = T200.cd_sequencial And  ';
            --SET @SQL += '      T200.cd_funcionario_vendedor = T2.cd_funcionario And  '; WHERE
            --SET @SQL += '      T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
            --            + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and '; WHERE
            --SET @SQL += '      T200.cd_associado = T300.cd_associado and ';
            --SET @SQL += '      T300.cd_empresa = T400.cd_empresa and ';
            --SET @SQL += '      T400.TP_EMPRESA in (1,4,5) and ';
            --SET @SQL += '      T400.cd_tipo_pagamento = T500.cd_tipo_pagamento and ';
            --SET @SQL += '      t200.cd_sequencial_historico = t600.cd_sequencial and';
            --SET @SQL += '      t300.cidid *= mu.cd_municipio And ';
            --SET @SQL += '      t300.ufid *= uf.ufid and ';
            --SET @SQL += '      t100.cd_sequencial_lote = t800.cd_sequencial And';
            --SET @SQL += '      T2.cd_equipe = T1.cd_equipe '; WHERE


            SET @SQL += '    FROM dbo.lote_contratos_contratos_vendedor T100
            INNER JOIN dbo.DEPENDENTES T200 ON T200.CD_SEQUENCIAL = T100.cd_sequencial_dep
            INNER JOIN dbo.ASSOCIADOS T300 ON T300.cd_associado = T200.CD_ASSOCIADO
            INNER JOIN dbo.EMPRESA T400 ON T300.cd_empresa = T400.CD_EMPRESA AND T400.TP_EMPRESA IN (1,4,5)
            INNER JOIN dbo.TIPO_PAGAMENTO T500 ON T500.cd_tipo_pagamento = T400.cd_tipo_pagamento
            INNER JOIN dbo.HISTORICO T600 ON T200.CD_Sequencial_historico = T600.cd_sequencial
            LEFT JOIN dbo.MUNICIPIO MU ON MU.CD_MUNICIPIO = T300.CidID
            LEFT JOIN dbo.UF UF ON UF.ufId = T300.ufId
            INNER JOIN dbo.lote_contratos T800 ON T800.cd_sequencial = T100.cd_sequencial_lote  ';


            SET @SQL += ' WHERE ';
            SET @SQL += '      T200.cd_funcionario_vendedor = T2.cd_funcionario And  ';
            SET @SQL += '      T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
                        + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and ';
            SET @SQL += '      T2.cd_equipe = T1.cd_equipe ';





            IF (@uf <> -1)
            BEGIN
                SET @SQL += ' And uf.ufid  = ' + CONVERT(VARCHAR, @uf);
            END;

            IF (@municipio <> -1)
            BEGIN
                SET @SQL += ' And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
            END;

            IF @plano <> ''
            BEGIN
                SET @SQL += ' and t200.cd_plano in (' + @plano + ')';
            END;

            IF @tipo_empresa <> ''
            BEGIN
                SET @SQL += ' and t400.tp_empresa in (' + @tipo_empresa + ')';
            END;

            IF @situacao <> ''
            BEGIN
                SET @SQL += ' and t600.cd_situacao in (' + @situacao + ') ';
            END;

            IF (@tipo_pagamento <> '')
            BEGIN
                SET @SQL += ' and T400.cd_tipo_pagamento in (' + @tipo_pagamento + ')';
            END;

            IF (@grupoEmpresa > 0)
            BEGIN
                SET @SQL = @SQL + ' and T400.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
            END;
            IF (@centroCusto > 0)
            BEGIN
                SET @SQL = @SQL + ' and T400.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
            END;

            SET @SQL += '      ) As contratosConsignado ';


            /*COMENTADOS FORAM REALIZADOS OS JOINS*/



            -- contratosPJ
            SET @SQL += ',(Select Count(T100.cd_sequencial_lote)  ';
            --SET @SQL += '  From lote_contratos_contratos_vendedor T100, Dependentes T200, 
            --ASSOCIADOS T300, EMPRESA T400, TIPO_PAGAMENTO T500, historico t600, UF AS uf, municipio AS mu, lote_contratos t800 ';
            --SET @SQL += '  Where T100.cd_sequencial_dep = T200.cd_sequencial And  ';
            --SET @SQL += '      T200.cd_funcionario_vendedor = T2.cd_funcionario And  '; WHERE
            --SET @SQL += '      T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
            --            + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and '; WHERE
            --SET @SQL += '      T200.cd_associado = T300.cd_associado and ';
            --SET @SQL += '      T300.cd_empresa = T400.cd_empresa and ';
            --SET @SQL += '      T400.TP_EMPRESA in (2,6,7) and ';
            --SET @SQL += '      T400.cd_tipo_pagamento = T500.cd_tipo_pagamento and ';
            --SET @SQL += '      t200.cd_sequencial_historico = t600.cd_sequencial and';
            --SET @SQL += '      t300.cidid *= mu.cd_municipio And ';
            --SET @SQL += '      t300.ufid *= uf.ufid and ';
            --SET @SQL += '      t100.cd_sequencial_lote = t800.cd_sequencial And';
            --SET @SQL += '      T2.cd_equipe = T1.cd_equipe '; WHERE


            SET @SQL += '    FROM dbo.lote_contratos_contratos_vendedor T100 
            INNER JOIN dbo.DEPENDENTES T200 ON T200.CD_SEQUENCIAL = T100.cd_sequencial_dep
            INNER JOIN dbo.ASSOCIADOS T300 ON T300.cd_associado = T200.CD_ASSOCIADO
            INNER JOIN dbo.EMPRESA T400 ON T300.cd_empresa = T400.CD_EMPRESA AND T400.TP_EMPRESA IN (2,6,7)
            INNER JOIN dbo.TIPO_PAGAMENTO T500 ON T500.cd_tipo_pagamento = T400.cd_tipo_pagamento
            INNER JOIN dbo.HISTORICO T600 ON T200.CD_Sequencial_historico = T600.cd_sequencial
            LEFT JOIN dbo.MUNICIPIO MU ON MU.CD_MUNICIPIO = T300.CidID
            LEFT JOIN dbo.UF UF ON UF.ufId = T300.ufId
            INNER JOIN dbo.lote_contratos T800 ON T800.cd_sequencial = T100.cd_sequencial_lote  ';



            SET @SQL += ' WHERE ';
            SET @SQL += '      T200.cd_funcionario_vendedor = T2.cd_funcionario And  ';
            SET @SQL += '      T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
                        + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and ';
            SET @SQL += '      T2.cd_equipe = T1.cd_equipe ';




            IF (@uf <> -1)
            BEGIN
                SET @SQL += ' And uf.ufid  = ' + CONVERT(VARCHAR, @uf);
            END;

            IF (@municipio <> -1)
            BEGIN
                SET @SQL += ' And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
            END;

            IF @plano <> ''
            BEGIN
                SET @SQL += ' and t200.cd_plano in (' + @plano + ')';
            END;

            IF @tipo_empresa <> ''
            BEGIN
                SET @SQL += ' and t400.tp_empresa in (' + @tipo_empresa + ')';
            END;

            IF @situacao <> ''
            BEGIN
                SET @SQL += ' and t600.cd_situacao in (' + @situacao + ') ';
            END;

            IF (@tipo_pagamento <> '')
            BEGIN
                SET @SQL += ' and T400.cd_tipo_pagamento in (' + @tipo_pagamento + ')';
            END;

            IF (@grupoEmpresa > 0)
            BEGIN
                SET @SQL = @SQL + ' and T400.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
            END;
            IF (@centroCusto > 0)
            BEGIN
                SET @SQL = @SQL + ' and T400.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
            END;

            SET @SQL += '      ) As contratosPJ, ';

            /*COMENTADOS FORAM REALIZADOS OS JOINS*/


            -- QuantidadeAssociados
            SET @SQL += '(Select IsNull(Count(distinct T200.cd_associado),0)  ';
            --SET @SQL += 'From lote_contratos_contratos_vendedor T100, Dependentes T200, associados t300, empresa t400, 
            --historico t500, UF AS uf, municipio AS mu, lote_contratos t800 ';
            --SET @SQL += ' Where T100.cd_sequencial_dep = T200.cd_sequencial And  ';
            --SET @SQL += '      T200.cd_funcionario_vendedor = T2.cd_funcionario And  ';
            --SET @SQL += '      t200.cd_associado = t300.cd_associado and ';
            --SET @SQL += '      t300.cd_empresa = t400.cd_empresa and';
            --SET @SQL += '      t200.cd_sequencial_historico = t500.cd_sequencial and';
            --SET @SQL += '      t300.cidid *= mu.cd_municipio And';
            --SET @SQL += '      t300.ufid *= uf.ufid And';
            --SET @SQL += '      t100.cd_sequencial_lote = t800.cd_sequencial And';
            --SET @SQL += '      T2.cd_equipe = T1.cd_equipe ';


            SET @SQL += '    FROM dbo.lote_contratos_contratos_vendedor t100 
            INNER JOIN dbo.DEPENDENTES t200 ON t200.CD_SEQUENCIAL = t100.cd_sequencial_dep
            INNER JOIN dbo.ASSOCIADOS t300 ON t300.cd_associado = t200.CD_ASSOCIADO
            INNER JOIN dbo.EMPRESA t400 ON t300.cd_empresa = t400.CD_EMPRESA
            INNER JOIN dbo.HISTORICO t500 ON t200.CD_Sequencial_historico = t500.cd_sequencial
            LEFT JOIN dbo.MUNICIPIO mu ON mu.CD_MUNICIPIO = t300.CidID
            LEFT JOIN dbo.UF UF ON UF.ufId = t300.ufId
            INNER JOIN dbo.lote_contratos t800 ON t800.cd_sequencial = t100.cd_sequencial_lote  ';

            SET @SQL += ' WHERE ';
            SET @SQL += '      T200.cd_funcionario_vendedor = T2.cd_funcionario And  ';
            SET @SQL += '      T2.cd_equipe = T1.cd_equipe ';





            IF (@uf <> -1)
            BEGIN
                SET @SQL += ' And uf.ufid  = ' + CONVERT(VARCHAR, @uf);
            END;

            IF (@municipio <> -1)
            BEGIN
                SET @SQL += ' And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
            END;

            IF @plano <> ''
            BEGIN
                SET @SQL += ' and t200.cd_plano in (' + @plano + ')';
            END;

            IF @tipo_empresa <> ''
            BEGIN
                SET @SQL += ' and t400.tp_empresa in (' + @tipo_empresa + ')';
            END;

            IF @situacao <> ''
            BEGIN
                SET @SQL += ' and t500.cd_situacao in (' + @situacao + ') ';
            END;

            IF (@tipo_pagamento <> '')
            BEGIN
                SET @SQL += ' and T400.cd_tipo_pagamento in (' + @tipo_pagamento + ')';
            END;

            IF (@grupoEmpresa > 0)
            BEGIN
                SET @SQL = @SQL + ' and T400.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
            END;
            IF (@centroCusto > 0)
            BEGIN
                SET @SQL = @SQL + ' and T400.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
            END;

            SET @SQL += ' and T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
                        + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' ) ';
            SET @SQL += '   As QuantidadeAssociados, ';
            SET @SQL += ' isnull(T2.metaNovosPacientes, 0) metaNovosPacientes ';

            /* FROM e WHERE DA PROCEDURE */
            SET @SQL2 += ' From lote_contratos_contratos_vendedor T100, Dependentes T200, lote_contratos LC, Funcionario T2, equipe_vendas T1 ';
            SET @SQL2 += ' Where T100.cd_sequencial_dep = T200.cd_sequencial ';
            SET @SQL2 += ' And T100.cd_sequencial_lote = LC.cd_sequencial ';
            SET @SQL2 += ' and T200.cd_funcionario_vendedor = T2.cd_funcionario ';
            SET @SQL2 += ' and T2.cd_equipe = T1.cd_equipe  ';
            SET @SQL2 += ' and T2.cd_funcionario >= case when ''' + CONVERT(VARCHAR, @cd_funcionario)
                         + '''=0 then 0 else ''' + CONVERT(VARCHAR, @cd_funcionario) + ''' end ';
            SET @SQL2 += ' and T2.cd_funcionario <= case when ''' + CONVERT(VARCHAR, @cd_funcionario)
                         + '''=0 then 9999999999 else ''' + CONVERT(VARCHAR, @cd_funcionario) + ''' end ';
            SET @SQL2 += ' and T100.dt_assinaturaContrato between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
                         + ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
            SET @SQL2 += ' and IsNull(t2.nr_cpf,'''') like case when ''' + @cpfvendedor
                         + ''' ='''' then ''%%'' else ''' + @cpfvendedor + ''' end ';

            IF (@CD_Equipe > 0)
            BEGIN
                SET @SQL2 += ' And T1.cd_equipe = ' + CONVERT(VARCHAR, @CD_Equipe);
            END;

            SET @SQL2 += ' group by t2.nm_empregado, t2.cd_funcionario, t1.cd_Equipe, t1.nm_equipe, LC.cd_empresa, LC.cd_equipe, T2.cd_equipe, T2.metaNovosPacientes ';
            SET @SQL2 += ' Order By 6 Desc ';
        END;
        ELSE
        BEGIN
            IF @cd_funcionario_supervisor > 0
            BEGIN
                PRINT 5;
                SET @SQL += 'Select distinct t2.nm_empregado, t2.cd_funcionario, t1.cd_equipe, t1.nm_equipe,';

                SET @SQL += '(Select Count(T100.cd_sequencial_lote)  ';
                SET @SQL += '  From lote_contratos_contratos_vendedor T100, Dependentes T200, lote_contratos t800 ';
                SET @SQL += '  Where T100.cd_sequencial_dep = T200.cd_sequencial And  ';
                SET @SQL += '      T200.cd_funcionario_vendedor = T2.cd_funcionario and ';
                SET @SQL += '      t100.cd_sequencial_lote = t800.cd_sequencial And';
                SET @SQL += '      T2.cd_equipe = T1.cd_equipe And ';
                SET @SQL += '      T100.dt_assinaturaContrato between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
                            + ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'')';
                SET @SQL += ' As QuantidadeContrato,  ';

                SET @SQL += '(Select IsNull(Sum(T100.vl_contrato),0)  ';
                SET @SQL += '  From lote_contratos_contratos_vendedor T100, Dependentes T200, lote_contratos t800 ';
                SET @SQL += '  Where T100.cd_sequencial_dep = T200.cd_sequencial And  ';
                SET @SQL += '      T200.cd_funcionario_vendedor = T2.cd_funcionario and ';
                SET @SQL += '      t100.cd_sequencial_lote = t800.cd_sequencial And';
                SET @SQL += '      T2.cd_equipe = T1.cd_equipe And ';
                SET @SQL += '      T100.dt_assinaturaContrato between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
                            + ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'')';
                SET @SQL += ' As ValorContrato,  ';

                -- Numero de vidas contrato importado.  
                SET @SQL += 'IsNull((Select Count(T100.cd_sequencial)  ';
                SET @SQL += 'From Dependentes T100, Historico T300 ';
                SET @SQL += 'Where T100.cd_funcionario_vendedor = T2.cd_funcionario  ';
                SET @SQL += '   And t100.CD_Sequencial_historico = t300.cd_sequencial  ';
                SET @SQL += '   And T300.cd_situacao = 6),0)      ';
                SET @SQL += 'As QuantidadeImportado,  ';

                -- Valor de vidas contrato importado.  
                SET @SQL += 'IsNull((Select Sum(T100.vl_plano)  ';
                SET @SQL += 'From Dependentes T100, Historico T300 ';
                SET @SQL += 'Where T100.cd_funcionario_vendedor = T2.cd_funcionario  ';
                SET @SQL += '   And t100.CD_Sequencial_historico = t300.cd_sequencial  ';
                SET @SQL += '   And T300.cd_situacao = 6),0)  ';
                SET @SQL += 'As ValorImportado';

                SET @SQL += ',(Select Count(T100.cd_sequencial_lote)  ';
                SET @SQL += 'From lote_contratos_contratos_vendedor T100, Dependentes T200, ASSOCIADOS T300, EMPRESA T400, TIPO_PAGAMENTO T500, lote_contratos t800 ';
                SET @SQL += 'Where T100.cd_sequencial_dep = T200.cd_sequencial And  ';
                SET @SQL += 'T200.cd_funcionario_vendedor = T2.cd_funcionario And  ';
                SET @SQL += 'T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
                            + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and ';
                SET @SQL += 'T200.cd_associado = T300.cd_associado and ';
                SET @SQL += 'T300.cd_empresa = T400.cd_empresa and ';
                SET @SQL += 'T400.TP_EMPRESA in (3) and ';
                SET @SQL += 'T400.cd_tipo_pagamento = T500.cd_tipo_pagamento and ';
                SET @SQL += ' isnull(T500.fl_exige_Dados_cartao,0) = 1 and ';
                SET @SQL += ' t100.cd_sequencial_lote = t800.cd_sequencial And';
                SET @SQL += ' T2.cd_equipe = T1.cd_equipe ';
                SET @SQL += ' ) As contratosCartao ';

                SET @SQL += ',(Select Count(T100.cd_sequencial_lote)  ';
                SET @SQL += 'From lote_contratos_contratos_vendedor T100, Dependentes T200, ASSOCIADOS T300, EMPRESA T400, TIPO_PAGAMENTO T500, lote_contratos t800 ';
                SET @SQL += 'Where T100.cd_sequencial_dep = T200.cd_sequencial And  ';
                SET @SQL += 'T200.cd_funcionario_vendedor = T2.cd_funcionario And  ';
                SET @SQL += 'T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
                            + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and ';
                SET @SQL += 'T200.cd_associado = T300.cd_associado and ';
                SET @SQL += 'T300.cd_empresa = T400.cd_empresa and ';
                SET @SQL += 'T400.TP_EMPRESA in (3) and ';
                SET @SQL += 'T400.cd_tipo_pagamento = T500.cd_tipo_pagamento and ';
                SET @SQL += ' isnull(T500.fl_exige_Dados_cartao,0) = 0 and ';
                SET @SQL += ' isnull(T500.fl_boleto,0) = 0 and ';
                SET @SQL += ' isnull(T500.fl_exige_dados_conta,0) = 1 and ';
                SET @SQL += ' t100.cd_sequencial_lote = t800.cd_sequencial And';
                SET @SQL += ' T2.cd_equipe = T1.cd_equipe ';
                SET @SQL += ' ) As contratosDebito ';

                SET @SQL += ',(Select Count(T100.cd_sequencial_lote)  ';
                SET @SQL += '  From lote_contratos_contratos_vendedor T100, Dependentes T200, ASSOCIADOS T300, EMPRESA T400, TIPO_PAGAMENTO T500, lote_contratos t800 ';
                SET @SQL += '  Where T100.cd_sequencial_dep = T200.cd_sequencial And  ';
                SET @SQL += '      T200.cd_funcionario_vendedor = T2.cd_funcionario And  ';
                SET @SQL += '      T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
                            + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and ';
                SET @SQL += '      T200.cd_associado = T300.cd_associado and ';
                SET @SQL += '      T400.TP_EMPRESA in (3) and ';
                SET @SQL += '      T300.cd_empresa = T400.cd_empresa and ';
                SET @SQL += '      T400.cd_tipo_pagamento = T500.cd_tipo_pagamento and ';
                SET @SQL += '      isnull(T500.fl_boleto,0) = 1 and';
                SET @SQL += '      t100.cd_sequencial_lote = t800.cd_sequencial And';
                SET @SQL += '      T2.cd_equipe = T1.cd_equipe ';
                SET @SQL += '      )    As contratosBoleto ';

                SET @SQL += ',(Select Count(T100.cd_sequencial_lote)  ';
                SET @SQL += '    From lote_contratos_contratos_vendedor T100, Dependentes T200, ASSOCIADOS T300, EMPRESA T400, TIPO_PAGAMENTO T500, lote_contratos t800 ';
                SET @SQL += '    Where T100.cd_sequencial_dep = T200.cd_sequencial And  ';
                SET @SQL += '        T200.cd_funcionario_vendedor = T2.cd_funcionario And  ';
                SET @SQL += '        T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
                            + ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and ';
                SET @SQL += '        T200.cd_associado = T300.cd_associado and ';
                SET @SQL += '        T300.cd_empresa = T400.cd_empresa and ';
                SET @SQL += '        T400.TP_EMPRESA in (1,4,5) and ';
                SET @SQL += '        T400.cd_tipo_pagamento = T500.cd_tipo_pagamento and ';
                SET @SQL += '        t100.cd_sequencial_lote = t800.cd_sequencial And';
                SET @SQL += '        T2.cd_equipe = T1.cd_equipe ';
                SET @SQL += '        )    As contratosConsignado';

                SET @SQL += '     ,(Select Count(T100.cd_sequencial_lote)  ';
                SET @SQL += '    From lote_contratos_contratos_vendedor T100, Dependentes T200, ASSOCIADOS T300, EMPRESA T400, TIPO_PAGAMENTO T500, lote_contratos t800 ';
                SET @SQL += '    Where T100.cd_sequencial_dep = T200.cd_sequencial And  ';
                SET @SQL += '        T200.cd_funcionario_vendedor = T2.cd_funcionario And  ';
                SET @SQL += '        T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
                            + ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and ';
                SET @SQL += '        T200.cd_associado = T300.cd_associado and ';
                SET @SQL += '        T300.cd_empresa = T400.cd_empresa and ';
                SET @SQL += '        T400.TP_EMPRESA in (2,6,7) and ';
                SET @SQL += '        T400.cd_tipo_pagamento = T500.cd_tipo_pagamento and ';
                SET @SQL += '        t100.cd_sequencial_lote = t800.cd_sequencial And';
                SET @SQL += '        T2.cd_equipe = T1.cd_equipe ';
                SET @SQL += '        )     As contratosPJ, ';

                SET @SQL += ' (Select IsNull(Count(distinct T200.cd_associado),0)  ';
                SET @SQL += '    From lote_contratos_contratos_vendedor T100, Dependentes T200, lote_contratos t800 ';
                SET @SQL += '    Where T100.cd_sequencial_dep = T200.cd_sequencial And  ';
                SET @SQL += '        T200.cd_funcionario_vendedor = T2.cd_funcionario and ';
                SET @SQL += '        t100.cd_sequencial_lote = t800.cd_sequencial And';
                SET @SQL += '        T2.cd_equipe = T1.cd_equipe And ';
                SET @SQL += '        T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
                            + ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'')';
                SET @SQL += '    As QuantidadeAssociados, ';
                SET @SQL += ' isnull(T2.metaNovosPacientes, 0) metaNovosPacientes ';

                /* FROM e WHERE DA PROCEDURE */
                SET @SQL2 += ' From lote_contratos_contratos_vendedor T100, Dependentes T200, lote_contratos LC, Funcionario T2, equipe_vendas T1 ';
                SET @SQL2 += ' Where T100.cd_sequencial_dep = T200.cd_sequencial ';
                SET @SQL2 += ' And T100.cd_sequencial_lote = LC.cd_sequencial ';
                SET @SQL2 += ' and T200.cd_funcionario_vendedor = T2.cd_funcionario ';
                SET @SQL2 += ' and T2.cd_equipe = T1.cd_equipe  ';
                SET @SQL2 += ' and t2.cd_funcionario >= case when ''' + CONVERT(VARCHAR, @cd_funcionario)
                             + '''=0 then 0 else ''' + CONVERT(VARCHAR, @cd_funcionario) + ''' end ';
                SET @SQL2 += ' and t2.cd_funcionario <= case when ''' + CONVERT(VARCHAR, @cd_funcionario)
                             + '''=0 then 9999999999 else ''' + CONVERT(VARCHAR, @cd_funcionario) + ''' end ';
                SET @SQL2 += ' and t1.cd_equipe in (';
                SET @SQL2 += ' Select cd_equipe From equipe_vendas  where cd_equipe is not null ';
                SET @SQL2 += ' and (CD_CHEFE = ''' + CONVERT(VARCHAR, @cd_funcionario_supervisor) + '''';
                SET @SQL2 += ' or CD_CHEFE1 = ''' + CONVERT(VARCHAR, @cd_funcionario_supervisor) + '''';
                SET @SQL2 += ' or CD_CHEFE2 = ''' + CONVERT(VARCHAR, @cd_funcionario_supervisor) + ''')) ';
                SET @SQL2 += ' and T100.dt_assinaturaContrato between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
                             + ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
                SET @SQL2 += ' and IsNull(t2.nr_cpf,'''') like case when ''' + @cpfvendedor
                             + ''' ='''' then ''%%'' else ''' + @cpfvendedor + ''' end ';

                IF (@CD_Equipe > 0)
                BEGIN
                    SET @SQL2 += ' And T1.cd_equipe = ' + CONVERT(VARCHAR, @CD_Equipe);
                END;

                SET @SQL2 += ' group by t2.nm_empregado, t2.cd_funcionario, t1.cd_Equipe, t1.nm_equipe, LC.cd_empresa, LC.cd_equipe, T2.cd_equipe, T2.metaNovosPacientes ';
                SET @SQL2 += ' Order By 6 Desc ';

            END;
            ELSE
            BEGIN
                PRINT 6;
                SET @SQL += '       Select distinct t2.nm_empregado, t2.cd_funcionario,  t1.cd_Equipe, t1.nm_equipe,';

                /*COMENTADOS FORAM REALIZADOS OS JOINS*/

                SET @SQL += '       (Select Count(T100.cd_sequencial_lote)  ';
                --SET @SQL += 'From lote_contratos_contratos_vendedor T100, Dependentes T200, associados t300, 
                --empresa t400, historico t500, UF AS uf, municipio AS mu, lote_contratos t800 ';
                --SET @SQL += ' Where T100.cd_sequencial_dep = T200.cd_sequencial And  ';
                --SET @SQL += '      T200.cd_funcionario_vendedor = T2.cd_funcionario And  ';
                --SET @SQL += '      t200.cd_associado = t300.cd_associado and ';
                --SET @SQL += '      t300.cd_empresa = t400.cd_empresa and';
                --SET @SQL += '      t200.cd_sequencial_historico = t500.cd_sequencial and';
                --SET @SQL += '      t300.cidid *= mu.cd_municipio And';
                --SET @SQL += '      t300.ufid *= uf.ufid And';
                --SET @SQL += '      t100.cd_sequencial_lote = t800.cd_sequencial And';
                --SET @SQL += '      T2.cd_equipe = T1.cd_equipe ';




                SET @SQL += '    FROM dbo.lote_contratos_contratos_vendedor t100 
            INNER JOIN dbo.DEPENDENTES t200 ON t200.CD_SEQUENCIAL = t100.cd_sequencial_dep
            INNER JOIN dbo.ASSOCIADOS t300 ON t300.cd_associado = t200.CD_ASSOCIADO
            INNER JOIN dbo.EMPRESA t400 ON t300.cd_empresa = t400.CD_EMPRESA
            INNER JOIN dbo.HISTORICO t500 ON t200.CD_Sequencial_historico = t500.cd_sequencial
            LEFT JOIN dbo.MUNICIPIO mu ON mu.CD_MUNICIPIO = t300.CidID
            LEFT JOIN dbo.UF UF ON UF.ufId = t300.ufId
            INNER JOIN dbo.lote_contratos t800 ON t800.cd_sequencial = t100.cd_sequencial_lote  ';

                SET @SQL += ' WHERE ';
                SET @SQL += '      T200.cd_funcionario_vendedor = T2.cd_funcionario And  ';
                SET @SQL += '      T2.cd_equipe = T1.cd_equipe ';





                IF (@uf <> -1)
                BEGIN
                    SET @SQL += ' And uf.ufid  = ' + CONVERT(VARCHAR, @uf);
                END;

                IF (@municipio <> -1)
                BEGIN
                    SET @SQL += ' And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
                END;

                IF @plano <> ''
                BEGIN
                    SET @SQL += ' and t200.cd_plano in (' + @plano + ')';
                END;

                IF @tipo_empresa <> ''
                BEGIN
                    SET @SQL += ' and t400.tp_empresa in (' + @tipo_empresa + ')';
                END;

                IF @situacao <> ''
                BEGIN
                    SET @SQL += ' and t500.cd_situacao in (' + @situacao + ') ';
                END;

                IF (@tipo_pagamento <> '')
                BEGIN
                    SET @SQL += ' and T400.cd_tipo_pagamento in (' + @tipo_pagamento + ')';
                END;
                IF (@grupoEmpresa > 0)
                BEGIN
                    SET @SQL = @SQL + ' and T400.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
                END;
                IF (@centroCusto > 0)
                BEGIN
                    SET @SQL = @SQL + ' and T400.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
                END;
                SET @SQL += ' and T100.dt_assinaturaContrato between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
                            + ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'')';
                SET @SQL += '        As QuantidadeContrato,  ';



                /*COMENTADOS FORAM REALIZADOS OS JOINS*/

                SET @SQL += '       (Select IsNull(Sum(T100.vl_contrato),0)  ';
                --SET @SQL += 'From lote_contratos_contratos_vendedor T100, Dependentes T200, associados t300, 
                --empresa t400, historico t500, UF AS uf, municipio AS mu, lote_contratos t800 ';
                --SET @SQL += ' Where T100.cd_sequencial_dep = T200.cd_sequencial And  ';
                --SET @SQL += '      T200.cd_funcionario_vendedor = T2.cd_funcionario And  ';
                --SET @SQL += '      t200.cd_associado = t300.cd_associado and ';
                --SET @SQL += '      t300.cd_empresa = t400.cd_empresa and';
                --SET @SQL += '      t200.cd_sequencial_historico = t500.cd_sequencial and';
                --SET @SQL += '      t300.cidid *= mu.cd_municipio And';
                --SET @SQL += '      t300.ufid *= uf.ufid And';
                --SET @SQL += '      t100.cd_sequencial_lote = t800.cd_sequencial And';
                --SET @SQL += '      T2.cd_equipe = T1.cd_equipe ';


                SET @SQL += '    FROM dbo.lote_contratos_contratos_vendedor t100 
            INNER JOIN dbo.DEPENDENTES t200 ON t200.CD_SEQUENCIAL = t100.cd_sequencial_dep
            INNER JOIN dbo.ASSOCIADOS t300 ON t300.cd_associado = t200.CD_ASSOCIADO
            INNER JOIN dbo.EMPRESA t400 ON t300.cd_empresa = t400.CD_EMPRESA
            INNER JOIN dbo.HISTORICO t500 ON t200.CD_Sequencial_historico = t500.cd_sequencial
            LEFT JOIN dbo.MUNICIPIO mu ON mu.CD_MUNICIPIO = t300.CidID
            LEFT JOIN dbo.UF UF ON UF.ufId = t300.ufId
            INNER JOIN dbo.lote_contratos t800 ON t800.cd_sequencial = t100.cd_sequencial_lote  ';

                SET @SQL += ' WHERE ';
                SET @SQL += '      T200.cd_funcionario_vendedor = T2.cd_funcionario And  ';
                SET @SQL += '      T2.cd_equipe = T1.cd_equipe ';




                IF (@uf <> -1)
                BEGIN
                    SET @SQL += ' And uf.ufid  = ' + CONVERT(VARCHAR, @uf);
                END;

                IF (@municipio <> -1)
                BEGIN
                    SET @SQL += ' And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
                END;

                IF @plano <> ''
                BEGIN
                    SET @SQL += ' and t200.cd_plano in (' + @plano + ')';
                END;

                IF @tipo_empresa <> ''
                BEGIN
                    SET @SQL += ' and t400.tp_empresa in (' + @tipo_empresa + ')';
                END;

                IF @situacao <> ''
                BEGIN
                    SET @SQL += ' and t500.cd_situacao in (' + @situacao + ') ';
                END;

                IF (@tipo_pagamento <> '')
                BEGIN
                    SET @SQL += ' and T400.cd_tipo_pagamento in (' + @tipo_pagamento + ')';
                END;
                IF (@grupoEmpresa > 0)
                BEGIN
                    SET @SQL = @SQL + ' and T400.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
                END;
                IF (@centroCusto > 0)
                BEGIN
                    SET @SQL = @SQL + ' and T400.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
                END;
                SET @SQL += ' and T100.dt_assinaturaContrato between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
                            + ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'')';
                SET @SQL += '        As ValorContrato,  ';

                -- Numero de vidas contrato importado.  
                SET @SQL += '       IsNull((Select Count(T100.cd_sequencial)  ';
                SET @SQL += '       From Dependentes T100, Historico T300 ';
                SET @SQL += '       Where T100.cd_funcionario_vendedor = T2.cd_funcionario  ';
                SET @SQL += '             And t100.CD_Sequencial_historico = t300.cd_sequencial  ';
                SET @SQL += '           And T300.cd_situacao = 6),0)      ';
                SET @SQL += '       As QuantidadeImportado,  ';

                -- Valor de vidas contrato importado.  
                SET @SQL += '       IsNull((Select Sum(T100.vl_plano)  ';
                SET @SQL += '       From Dependentes T100, Historico T300 ';
                SET @SQL += '       Where T100.cd_funcionario_vendedor = T2.cd_funcionario  ';
                SET @SQL += '             And t100.CD_Sequencial_historico = t300.cd_sequencial  ';
                SET @SQL += '           And T300.cd_situacao = 6),0)      ';
                SET @SQL += '       As ValorImportado  ';

                SET @SQL += '      ,(Select Count(T100.cd_sequencial_lote)  ';
                SET @SQL += '    From lote_contratos_contratos_vendedor T100, Dependentes T200, ASSOCIADOS T300, EMPRESA T400, TIPO_PAGAMENTO T500, historico t600, UF AS uf, municipio AS mu, lote_contratos t800 ';
                SET @SQL += '    Where T100.cd_sequencial_dep = T200.cd_sequencial And  ';
                SET @SQL += '        T200.cd_funcionario_vendedor = T2.cd_funcionario And  ';
                SET @SQL += '        T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
                            + ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and ';
                SET @SQL += '        T200.cd_associado = T300.cd_associado and ';
                SET @SQL += '        T300.cd_empresa = T400.cd_empresa and ';
                SET @SQL += '        T400.TP_EMPRESA in (3) and ';
                SET @SQL += '        T400.cd_tipo_pagamento = T500.cd_tipo_pagamento and ';
                SET @SQL += '        t200.cd_sequencial_historico = t600.cd_sequencial and';
                SET @SQL += '        t300.cidid *= mu.cd_municipio And ';
                SET @SQL += '        t300.ufid *= uf.ufid and ';
                SET @SQL += '        t100.cd_sequencial_lote = t800.cd_sequencial And';
                SET @SQL += '        T2.cd_equipe = T1.cd_equipe And ';
                SET @SQL += '        isnull(T500.fl_exige_Dados_cartao,0) = 1';

                IF (@uf <> -1)
                BEGIN
                    SET @SQL += ' And uf.ufid  = ' + CONVERT(VARCHAR, @uf);
                END;

                IF (@municipio <> -1)
                BEGIN
                    SET @SQL += ' And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
                END;

                IF @plano <> ''
                BEGIN
                    SET @SQL += ' and t200.cd_plano in (' + @plano + ')';
                END;

                IF @tipo_empresa <> ''
                BEGIN
                    SET @SQL += ' and t400.tp_empresa in (' + @tipo_empresa + ')';
                END;

                IF @situacao <> ''
                BEGIN
                    SET @SQL += ' and t600.cd_situacao in (' + @situacao + ') ';
                END;

                IF (@tipo_pagamento <> '')
                BEGIN
                    SET @SQL += ' and T400.cd_tipo_pagamento in (' + @tipo_pagamento + ')';
                END;
                IF (@grupoEmpresa > 0)
                BEGIN
                    SET @SQL = @SQL + ' and T400.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
                END;
                IF (@centroCusto > 0)
                BEGIN
                    SET @SQL = @SQL + ' and T400.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
                END;
                SET @SQL += '        )  As contratosCartao';

                SET @SQL += '      ,(Select Count(T100.cd_sequencial_lote)  ';


                /*COMENTADOS FORAM REALIZADOS OS JOINS*/


                --SET @SQL += '    From lote_contratos_contratos_vendedor T100, Dependentes T200, ASSOCIADOS T300, 
                --EMPRESA T400, TIPO_PAGAMENTO T500, historico t600, UF AS uf, municipio AS mu, lote_contratos t800 ';
                --SET @SQL += '    Where T100.cd_sequencial_dep = T200.cd_sequencial And  ';
                --SET @SQL += '        T200.cd_funcionario_vendedor = T2.cd_funcionario And  '; WHERE
                --SET @SQL += '        T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
                --            + ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and '; WHERE
                --SET @SQL += '        T200.cd_associado = T300.cd_associado and ';
                --SET @SQL += '        T300.cd_empresa = T400.cd_empresa and ';
                --SET @SQL += '        T400.TP_EMPRESA in (3) and ';
                --SET @SQL += '        T400.cd_tipo_pagamento = T500.cd_tipo_pagamento and ';
                --SET @SQL += '        t200.cd_sequencial_historico = t600.cd_sequencial and';
                --SET @SQL += '        t300.cidid *= mu.cd_municipio And ';
                --SET @SQL += '        t300.ufid *= uf.ufid and ';
                --SET @SQL += '        t100.cd_sequencial_lote = t800.cd_sequencial And';
                --SET @SQL += '        T2.cd_equipe = T1.cd_equipe And '; WHERE
                --SET @SQL += '        isnull(T500.fl_exige_Dados_cartao,0) = 0 and '; WHERE
                --SET @SQL += '        isnull(T500.fl_boleto,0) = 0 and '; WHERE
                --SET @SQL += '        isnull(T500.fl_exige_dados_conta,0) = 1'; WHERE

                SET @SQL += '    FROM dbo.lote_contratos_contratos_vendedor T100
                INNER JOIN dbo.DEPENDENTES T200 ON T200.CD_SEQUENCIAL = T100.cd_sequencial_dep
                INNER JOIN dbo.ASSOCIADOS T300 ON T300.cd_associado = T200.CD_ASSOCIADO
                INNER JOIN dbo.EMPRESA T400 ON T300.cd_empresa = T400.CD_EMPRESA
                INNER JOIN dbo.TIPO_PAGAMENTO T500 ON T500.cd_tipo_pagamento = T400.cd_tipo_pagamento
                INNER JOIN dbo.HISTORICO T600 ON T200.CD_Sequencial_historico = T600.cd_sequencial
                LEFT JOIN dbo.MUNICIPIO MU ON MU.CD_MUNICIPIO = T300.CidID
                LEFT JOIN dbo.UF UF ON UF.ufId = T300.ufId
                INNER JOIN dbo.lote_contratos T800 ON T800.cd_sequencial = T100.cd_sequencial_lote  ';




                SET @SQL += ' WHERE ';
                SET @SQL += '        T200.cd_funcionario_vendedor = T2.cd_funcionario And  ';
                SET @SQL += '        T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
                            + ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and ';
                SET @SQL += '        T2.cd_equipe = T1.cd_equipe And ';
                SET @SQL += '        isnull(T500.fl_exige_Dados_cartao,0) = 0 and ';
                SET @SQL += '        isnull(T500.fl_boleto,0) = 0 and ';
                SET @SQL += '        isnull(T500.fl_exige_dados_conta,0) = 1';







                IF (@uf <> -1)
                BEGIN
                    SET @SQL += ' And uf.ufid  = ' + CONVERT(VARCHAR, @uf);
                END;

                IF (@municipio <> -1)
                BEGIN
                    SET @SQL += ' And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
                END;

                IF @plano <> ''
                BEGIN
                    SET @SQL += ' and t200.cd_plano in (' + @plano + ')';
                END;

                IF @tipo_empresa <> ''
                BEGIN
                    SET @SQL += ' and t400.tp_empresa in (' + @tipo_empresa + ')';
                END;

                IF @situacao <> ''
                BEGIN
                    SET @SQL += ' and t600.cd_situacao in (' + @situacao + ') ';
                END;

                IF (@tipo_pagamento <> '')
                BEGIN
                    SET @SQL += ' and T400.cd_tipo_pagamento in (' + @tipo_pagamento + ')';
                END;
                IF (@grupoEmpresa > 0)
                BEGIN
                    SET @SQL = @SQL + ' and T400.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
                END;
                IF (@centroCusto > 0)
                BEGIN
                    SET @SQL = @SQL + ' and T400.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
                END;
                SET @SQL += '        )  As contratosDebito';

                SET @SQL += ' ,(Select Count(T100.cd_sequencial_lote)  ';

                /*COMENTADOS FORAM REALIZADOS OS JOINS*/

                --SET @SQL += '    From lote_contratos_contratos_vendedor T100, Dependentes T200, ASSOCIADOS T300, 
                --EMPRESA T400, TIPO_PAGAMENTO T500, historico t600, UF AS uf, municipio AS mu, lote_contratos t800 ';
                --SET @SQL += '    Where T100.cd_sequencial_dep = T200.cd_sequencial And  ';
                --SET @SQL += '        T200.cd_funcionario_vendedor = T2.cd_funcionario And  '; WHERE
                --SET @SQL += '        T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
                --            + ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and '; WHERE
                --SET @SQL += '        T200.cd_associado = T300.cd_associado and ';
                --SET @SQL += '        T400.TP_EMPRESA in (3) and ';
                --SET @SQL += '        T300.cd_empresa = T400.cd_empresa and ';
                --SET @SQL += '        T400.cd_tipo_pagamento = T500.cd_tipo_pagamento and ';
                --SET @SQL += '        t200.cd_sequencial_historico = t600.cd_sequencial and';
                --SET @SQL += '        t300.cidid *= mu.cd_municipio And ';
                --SET @SQL += '        t300.ufid *= uf.ufid and ';
                --SET @SQL += '        t100.cd_sequencial_lote = t800.cd_sequencial And';
                --SET @SQL += '        T2.cd_equipe = T1.cd_equipe And '; WHERE
                --SET @SQL += '        isnull(T500.fl_boleto,0) = 1'; WHERE



                SET @SQL += '    FROM dbo.lote_contratos_contratos_vendedor T100
                INNER JOIN dbo.DEPENDENTES T200 ON T200.CD_SEQUENCIAL = T100.cd_sequencial_dep
                INNER JOIN dbo.ASSOCIADOS T300 ON T300.cd_associado = T200.CD_ASSOCIADO
                INNER JOIN dbo.EMPRESA T400 ON T300.cd_empresa = T400.CD_EMPRESA AND T400.TP_EMPRESA IN (3)
                INNER JOIN dbo.TIPO_PAGAMENTO T500 ON T500.cd_tipo_pagamento = T400.cd_tipo_pagamento
                INNER JOIN dbo.HISTORICO T600 ON T200.CD_Sequencial_historico = T600.cd_sequencial
                LEFT JOIN dbo.MUNICIPIO MU ON MU.CD_MUNICIPIO = T300.CidID
                LEFT JOIN dbo.UF UF ON UF.ufId = T300.ufId
                INNER JOIN dbo.lote_contratos T800 ON T800.cd_sequencial = T100.cd_sequencial_lote  ';

                SET @SQL += ' WHERE ';
                SET @SQL += '        T200.cd_funcionario_vendedor = T2.cd_funcionario And  ';
                SET @SQL += '        T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
                            + ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and ';
                SET @SQL += '        T2.cd_equipe = T1.cd_equipe And ';
                SET @SQL += '        isnull(T500.fl_boleto,0) = 1';



                IF (@uf <> -1)
                BEGIN
                    SET @SQL += ' And uf.ufid  = ' + CONVERT(VARCHAR, @uf);
                END;

                IF (@municipio <> -1)
                BEGIN
                    SET @SQL += ' And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
                END;

                IF @plano <> ''
                BEGIN
                    SET @SQL += ' and t200.cd_plano in (' + @plano + ')';
                END;

                IF @tipo_empresa <> ''
                BEGIN
                    SET @SQL += ' and t400.tp_empresa in (' + @tipo_empresa + ')';
                END;

                IF @situacao <> ''
                BEGIN
                    SET @SQL += ' and t600.cd_situacao in (' + @situacao + ') ';
                END;

                IF (@tipo_pagamento <> '')
                BEGIN
                    SET @SQL += ' and T400.cd_tipo_pagamento in (' + @tipo_pagamento + ')';
                END;
                IF (@grupoEmpresa > 0)
                BEGIN
                    SET @SQL = @SQL + ' and T400.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
                END;
                IF (@centroCusto > 0)
                BEGIN
                    SET @SQL = @SQL + ' and T400.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
                END;
                SET @SQL += '        )   As contratosBoleto';


                /*COMENTADOS FORAM REALIZADOS OS JOINS*/


                SET @SQL += ' ,(Select Count(T100.cd_sequencial_lote)  ';
                --SET @SQL += '    From lote_contratos_contratos_vendedor T100, Dependentes T200, ASSOCIADOS T300, 
                --EMPRESA T400, TIPO_PAGAMENTO T500, historico t600, UF AS uf, municipio AS mu, lote_contratos t800 ';
                --SET @SQL += '    Where T100.cd_sequencial_dep = T200.cd_sequencial And  ';
                --SET @SQL += '        T200.cd_funcionario_vendedor = T2.cd_funcionario And  '; WHERE
                --SET @SQL += '        T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
                --            + ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and '; WHERE
                --SET @SQL += '        T200.cd_associado = T300.cd_associado and ';
                --SET @SQL += '        T300.cd_empresa = T400.cd_empresa and ';
                --SET @SQL += '        T400.TP_EMPRESA in (1,4,5) and ';
                --SET @SQL += '        T400.cd_tipo_pagamento = T500.cd_tipo_pagamento and ';
                --SET @SQL += '        t200.cd_sequencial_historico = t600.cd_sequencial and';
                --SET @SQL += '        t300.cidid *= mu.cd_municipio And ';
                --SET @SQL += '        t300.ufid *= uf.ufid and ';
                --SET @SQL += '        t100.cd_sequencial_lote = t800.cd_sequencial And';
                --SET @SQL += '        T2.cd_equipe = T1.cd_equipe '; WHERE

                SET @SQL += '    FROM dbo.lote_contratos_contratos_vendedor t100 
                INNER JOIN dbo.DEPENDENTES T200 ON T200.CD_SEQUENCIAL = t100.cd_sequencial_dep
                INNER JOIN dbo.ASSOCIADOS T300 ON T300.cd_associado = T200.CD_ASSOCIADO
                INNER JOIN dbo.EMPRESA T400 ON T300.cd_empresa = T400.CD_EMPRESA AND T400.TP_EMPRESA IN (1,4,5)
                INNER JOIN dbo.TIPO_PAGAMENTO T500 ON T500.cd_tipo_pagamento = T400.cd_tipo_pagamento
                INNER JOIN dbo.HISTORICO T600 ON T200.CD_Sequencial_historico = T600.cd_sequencial
                LEFT JOIN dbo.MUNICIPIO MU ON MU.CD_MUNICIPIO = T300.CidID
                LEFT JOIN dbo.UF UF ON UF.ufId = T300.ufId
                INNER JOIN dbo.lote_contratos T800 ON T800.cd_sequencial = t100.cd_sequencial_lote  ';



                SET @SQL += ' WHERE ';

                SET @SQL += '        T200.cd_funcionario_vendedor = T2.cd_funcionario And  ';
                SET @SQL += '        T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
                            + ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and ';
                SET @SQL += '        T2.cd_equipe = T1.cd_equipe ';







                IF (@uf <> -1)
                BEGIN
                    SET @SQL += ' And uf.ufid  = ' + CONVERT(VARCHAR, @uf);
                END;

                IF (@municipio <> -1)
                BEGIN
                    SET @SQL += ' And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
                END;

                IF @plano <> ''
                BEGIN
                    SET @SQL += ' and t200.cd_plano in (' + @plano + ')';
                END;

                IF @tipo_empresa <> ''
                BEGIN
                    SET @SQL += ' and t400.tp_empresa in (' + @tipo_empresa + ')';
                END;

                IF @situacao <> ''
                BEGIN
                    SET @SQL += ' and t600.cd_situacao in (' + @situacao + ') ';
                END;

                IF (@tipo_pagamento <> '')
                BEGIN
                    SET @SQL += ' and T400.cd_tipo_pagamento in (' + @tipo_pagamento + ')';
                END;
                IF (@grupoEmpresa > 0)
                BEGIN
                    SET @SQL = @SQL + ' and T400.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
                END;
                IF (@centroCusto > 0)
                BEGIN
                    SET @SQL = @SQL + ' and T400.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
                END;
                SET @SQL += '        ) As contratosConsignado ';

                /*COMENTADOS FORAM REALIZADOS OS JOINS*/



                SET @SQL += '     ,(Select Count(T100.cd_sequencial_lote)  ';
                --SET @SQL += '    From lote_contratos_contratos_vendedor T100, Dependentes T200, ASSOCIADOS T300, 
                --EMPRESA T400, TIPO_PAGAMENTO T500, historico t600, UF AS uf, municipio AS mu, lote_contratos t800 ';
                --SET @SQL += '    Where T100.cd_sequencial_dep = T200.cd_sequencial And  ';
                --SET @SQL += '        T200.cd_funcionario_vendedor = T2.cd_funcionario And  '; WHERE
                --SET @SQL += '        T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
                --            + ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and '; WHERE
                --SET @SQL += '        T200.cd_associado = T300.cd_associado and ';
                --SET @SQL += '        T300.cd_empresa = T400.cd_empresa and ';
                --SET @SQL += '        T400.TP_EMPRESA in (2,6,7) and ';
                --SET @SQL += '        T400.cd_tipo_pagamento = T500.cd_tipo_pagamento and ';
                --SET @SQL += '        t200.cd_sequencial_historico = t600.cd_sequencial and';
                --SET @SQL += '        t300.cidid *= mu.cd_municipio And ';
                --SET @SQL += '        t300.ufid *= uf.ufid and ';
                --SET @SQL += '        t100.cd_sequencial_lote = t800.cd_sequencial And';
                --SET @SQL += '        T2.cd_equipe = T1.cd_equipe '; WHERE


                SET @SQL += '    FROM dbo.lote_contratos_contratos_vendedor T100 
                INNER JOIN dbo.DEPENDENTES T200 ON T200.CD_SEQUENCIAL = T100.cd_sequencial_dep
                INNER JOIN dbo.ASSOCIADOS T300 ON T300.cd_associado = T200.CD_ASSOCIADO
                INNER JOIN dbo.EMPRESA T400 ON T300.cd_empresa = T400.CD_EMPRESA AND T400.TP_EMPRESA IN (2,6,7)
                INNER JOIN dbo.TIPO_PAGAMENTO T500 ON T500.cd_tipo_pagamento = T400.cd_tipo_pagamento
                INNER JOIN dbo.HISTORICO T600 ON T200.CD_Sequencial_historico = T600.cd_sequencial
                LEFT JOIN dbo.MUNICIPIO MU ON MU.CD_MUNICIPIO = T300.CidID
                LEFT JOIN dbo.UF UF ON UF.ufId = T300.ufId
                INNER JOIN dbo.lote_contratos T800 ON T800.cd_sequencial = T100.cd_sequencial_lote ';


                SET @SQL += ' WHERE ';
                SET @SQL += '        T200.cd_funcionario_vendedor = T2.cd_funcionario And  ';
                SET @SQL += '        T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
                            + ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and ';
                SET @SQL += '        T2.cd_equipe = T1.cd_equipe ';


                IF (@uf <> -1)
                BEGIN
                    SET @SQL += ' And uf.ufid  = ' + CONVERT(VARCHAR, @uf);
                END;

                IF (@municipio <> -1)
                BEGIN
                    SET @SQL += ' And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
                END;

                IF @plano <> ''
                BEGIN
                    SET @SQL += ' and t200.cd_plano in (' + @plano + ')';
                END;

                IF @tipo_empresa <> ''
                BEGIN
                    SET @SQL += ' and t400.tp_empresa in (' + @tipo_empresa + ')';
                END;

                IF @situacao <> ''
                BEGIN
                    SET @SQL += ' and t600.cd_situacao in (' + @situacao + ') ';
                END;

                IF (@tipo_pagamento <> '')
                BEGIN
                    SET @SQL += ' and T400.cd_tipo_pagamento in (' + @tipo_pagamento + ')';
                END;
                IF (@grupoEmpresa > 0)
                BEGIN
                    SET @SQL = @SQL + ' and T400.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
                END;
                IF (@centroCusto > 0)
                BEGIN
                    SET @SQL = @SQL + ' and T400.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
                END;
                SET @SQL += '        )     As contratosPJ, ';


                /*COMENTADOS FORAM REALIZADOS OS JOINS*/

                SET @SQL += ' (Select IsNull(Count(distinct T200.cd_associado),0)  ';
                --SET @SQL += 'From lote_contratos_contratos_vendedor T100, Dependentes T200, associados t300, 
                --empresa t400, historico t500, UF AS uf, municipio AS mu, lote_contratos t800 ';
                --SET @SQL += ' Where T100.cd_sequencial_dep = T200.cd_sequencial And  ';
                --SET @SQL += '      T200.cd_funcionario_vendedor = T2.cd_funcionario And  '; WHERE
                --SET @SQL += '      t200.cd_associado = t300.cd_associado and ';
                --SET @SQL += '      t300.cd_empresa = t400.cd_empresa and';
                --SET @SQL += '      t200.cd_sequencial_historico = t500.cd_sequencial and';
                --SET @SQL += '      t300.cidid *= mu.cd_municipio And';
                --SET @SQL += '      t300.ufid *= uf.ufid And';
                --SET @SQL += '      t100.cd_sequencial_lote = t800.cd_sequencial And';
                --SET @SQL += '      T2.cd_equipe = T1.cd_equipe '; WHERE


                SET @SQL += ' FROM dbo.lote_contratos_contratos_vendedor T100
                INNER JOIN dbo.DEPENDENTES T200 ON T200.CD_SEQUENCIAL = T100.cd_sequencial_dep
                INNER JOIN dbo.ASSOCIADOS T300 ON T300.cd_associado = T200.CD_ASSOCIADO
                INNER JOIN dbo.EMPRESA T400 ON T300.cd_empresa = T400.CD_EMPRESA
                INNER JOIN dbo.HISTORICO T500 ON T200.CD_Sequencial_historico = T500.cd_sequencial
                LEFT JOIN dbo.MUNICIPIO MU ON MU.CD_MUNICIPIO = T300.CidID
                LEFT JOIN dbo.UF UF ON UF.ufId = T300.ufId
                INNER JOIN dbo.lote_contratos T800 ON T800.cd_sequencial = T100.cd_sequencial_lote ';


                SET @SQL += ' WHERE ';
                SET @SQL += '      T200.cd_funcionario_vendedor = T2.cd_funcionario And  ';
                SET @SQL += '      T2.cd_equipe = T1.cd_equipe ';


                IF (@uf <> -1)
                BEGIN
                    SET @SQL += ' And uf.ufid  = ' + CONVERT(VARCHAR, @uf);
                END;

                IF (@municipio <> -1)
                BEGIN
                    SET @SQL += ' And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
                END;

                IF @plano <> ''
                BEGIN
                    SET @SQL += ' and t200.cd_plano in (' + @plano + ')';
                END;

                IF @tipo_empresa <> ''
                BEGIN
                    SET @SQL += ' and t400.tp_empresa in (' + @tipo_empresa + ')';
                END;

                IF @situacao <> ''
                BEGIN
                    SET @SQL += ' and t500.cd_situacao in (' + @situacao + ') ';
                END;

                IF (@tipo_pagamento <> '')
                BEGIN
                    SET @SQL += ' and T400.cd_tipo_pagamento in (' + @tipo_pagamento + ')';
                END;
                IF (@grupoEmpresa > 0)
                BEGIN
                    SET @SQL = @SQL + ' and T400.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
                END;
                IF (@centroCusto > 0)
                BEGIN
                    SET @SQL = @SQL + ' and T400.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
                END;
                SET @SQL += ' and T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
                            + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'')';
                SET @SQL += '     As QuantidadeAssociados, ';
                SET @SQL += ' isnull(T2.metaNovosPacientes, 0) metaNovosPacientes ';

                /* FROM e WHERE DA PROCEDURE */
                SET @SQL2 += ' From lote_contratos_contratos_vendedor T100, Dependentes T200, lote_contratos LC, Funcionario T2, equipe_vendas T1 ';
                SET @SQL2 += ' Where T100.cd_sequencial_dep = T200.cd_sequencial ';
                SET @SQL2 += ' And T100.cd_sequencial_lote = LC.cd_sequencial ';
                SET @SQL2 += ' and T200.cd_funcionario_vendedor = T2.cd_funcionario ';
                SET @SQL2 += ' and T2.cd_equipe = T1.cd_equipe  ';
                SET @SQL2 += ' and t2.cd_funcionario >= case when ''' + CONVERT(VARCHAR, @cd_funcionario)
                             + '''=0 then 0 else ''' + CONVERT(VARCHAR, @cd_funcionario) + ''' end ';
                SET @SQL2 += ' and t2.cd_funcionario <= case when ''' + CONVERT(VARCHAR, @cd_funcionario)
                             + '''=0 then 9999999999 else ''' + CONVERT(VARCHAR, @cd_funcionario) + ''' end ';
                SET @SQL2 += ' and T100.dt_assinaturaContrato between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
                             + ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
                SET @SQL2 += ' and IsNull(t2.nr_cpf,'''') like case when ''' + @cpfvendedor
                             + ''' ='''' then ''%%'' else ''' + @cpfvendedor + ''' end ';

                IF (@CD_Equipe > 0)
                BEGIN
                    SET @SQL2 += ' And T1.cd_equipe = ' + CONVERT(VARCHAR, @CD_Equipe);
                END;

                SET @SQL2 += ' group by t2.nm_empregado, t2.cd_funcionario, t1.cd_Equipe, t1.nm_equipe, LC.cd_empresa, LC.cd_equipe, T2.cd_equipe, T2.metaNovosPacientes ';
                SET @SQL2 += ' Order By 6 Desc ';

            END;
        END;
    END;

    PRINT @SQL;
    PRINT @SQL2;

    EXEC (@SQL + @SQL2);


END;
