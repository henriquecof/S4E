/****** Object:  Procedure [dbo].[SP_Email_Fatura_Vencida_50dias]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SP_Email_Fatura_Vencida_50dias]

AS BEGIN try

		--RETURN

		DECLARE @nome_site varchar(100)
		DECLARE @URL_CorporativoS4E varchar(100)
		DECLARE @email_faturamento varchar(100)
		DECLARE @Vencimento_Parcela varchar(10)
		DECLARE @Valor_parcela varchar(10)
		DECLARE @sql varchar(MAX)
		DECLARE @LicencaS4E varchar(50)
		DECLARE @Chave varchar(50)
		DECLARE @cd_associado integer
		DECLARE @nm_completo varchar(500)
		DECLARE @valor money
		DECLARE @Vencimento varchar(10)
		DECLARE @cd_parcela integer
		DECLARE @AUX AS integer
		DECLARE @dataExtenso AS varchar(100)
		DECLARE @plano AS varchar(100)
		DECLARE @codigoPlanoANS AS varchar(100)
		DECLARE @cep AS varchar(100)
		DECLARE @nomeTipoLogradouro AS varchar(100)
		DECLARE @municipio AS varchar(100)
		DECLARE @bairro AS varchar(100)
		DECLARE @uf AS varchar(2)
		DECLARE @valorAtualizado AS money
		DECLARE @EndLogradouro AS varchar(100)
		DECLARE @EndNumero AS integer
		DECLARE @diasAtraso AS integer
		DECLARE @telefone AS varchar(10)


		SELECT
        	@nome_site = nome_site ,
        	@url_corporativos4e = url_corporativos4e ,
        	@licencas4e = licencas4e ,
        	@telefone = telefone_geral
        FROM configuracao

		SELECT TOP 1
        	@email_faturamento = esiemail
        FROM emailsistema

		SELECT
        	@dataextenso = dbo.ff_dataextenso(GETDATE())

		SET @aux = 0

		SET @sql = '<br /><br />'
		SET @sql = @sql + ' Aracajú - SE, ' + @dataextenso
		SET @sql = @sql + ' <br /><br /> '
		SET @sql = @sql + ' Prezado(a) senhor(a), '

		DECLARE cursor_dados_cliente CURSOR FOR
		SELECT DISTINCT
        	   T2.cd_associado ,
        	   T2.nm_completo ,
        	   ISNULL(T7.ds_classificacao, T6.nm_plano) AS PLANO ,
        	   T7.cd_ans ,
        	   T2.logcep ,
        	   T8.nome_tipo ,
        	   T9.nm_municipio ,
        	   T10.baidescricao ,
        	   T11.ufsigla ,
        	   T2.endlogradouro ,
        	   T2.endnumero

        FROM mensalidades T1
        	INNER JOIN associados T2 ON T1.cd_associado_empresa = T2.cd_associado
        	INNER JOIN dependentes T3 ON T2.cd_associado = T3.cd_associado
        		AND T3.cd_grau_parentesco = 1
        	INNER JOIN historico T4 ON T3.cd_sequencial_historico = T4.cd_sequencial
        	INNER JOIN situacao_historico T5 ON T4.cd_situacao = T5.cd_situacao_historico
        	INNER JOIN planos T6 ON T3.cd_plano = T6.cd_plano
        	INNER JOIN classificacao_ans T7 ON T6.cd_classificacao = T7.cd_classificacao
        	LEFT JOIN tb_tipologradouro T8 ON T2.chave_tipologradouro = T8.chave_tipologradouro
        	LEFT JOIN municipio T9 ON T2.cidid = T9.cd_municipio
        	LEFT JOIN bairro T10 ON T2.baiid = T10.baiid
        	LEFT JOIN uf T11 ON T2.ufid = T11.ufid

        WHERE T1.cd_tipo_recebimento = 0
        AND ISNULL(T1.exibir, 1) = 1
        AND T1.tp_associado_empresa IN (1)
        AND DATEDIFF(d, ISNULL(T1.dt_vencimento_new, T1.dt_vencimento), CONVERT(VARCHAR(10), GETDATE(), 103)) = 51
        AND T5.fl_envia_cobranca = 1
        AND T1.vl_parcela > 0
        AND T1.cd_tipo_parcela NOT IN (101)
        AND T1.cd_parcela NOT IN (SELECT DISTINCT
                                  	     A.cd_parcela
                                  FROM mensalidadesagrupadas AS A,
                                  	mensalidades AS M,
                                  	mensalidades AS M1
                                  WHERE A.cd_parcela = M.cd_parcela
                                  AND A.cd_parcelamae = M1.cd_parcela
                                  AND M1.cd_tipo_parcela = 101
                                  AND M1.cd_tipo_recebimento = 0)
        AND ISNULL(T1.exibir, 1) = 1
        --AND T1.cd_associado_empresa IN (712898, 713773, 714485)
        ORDER BY 2


		OPEN cursor_dados_cliente
		FETCH NEXT FROM cursor_dados_cliente INTO @cd_associado, @nm_completo, @plano, @codigoplanoans, @cep, @nometipologradouro, @municipio, @bairro, @uf, @endlogradouro, @endnumero
		WHILE (@@fetch_status <> -1)
		BEGIN

			SET @sql = @sql + '<br /><br />  ' +
			CONVERT(VARCHAR, @cd_associado) +
			' - ' +
			UPPER(CONVERT(VARCHAR, @nm_completo)) +
			' <br /> Endereço: ' +
			CONVERT(VARCHAR, @nometipologradouro) +
			' ' +
			CONVERT(VARCHAR, @endlogradouro) +
			CASE
				    WHEN @endnumero IS NOT NULL
					AND @endnumero > 0
					THEN ', ' +
					CONVERT(VARCHAR, @endnumero)
					ELSE ''
			END +
			' ' +
			CONVERT(VARCHAR, @bairro) +
			' <br />' +
			CASE
				    WHEN @cep IS NOT NULL
					AND @cep <> ''
					THEN 'CEP ' +
					CONVERT(VARCHAR, @cep)
					ELSE ''
			END +
			CASE
				    WHEN @municipio IS NOT NULL
					AND @municipio <> ''
					THEN ' - ' +
					CONVERT(VARCHAR, @municipio)
					ELSE ''
			END +
			CASE
				    WHEN @uf IS NOT NULL
					AND @uf <> ''
					THEN ' - ' +
					CONVERT(VARCHAR, @uf)
					ELSE ''
			END +
			' <br /><br /> NOME COMERCIAL DO PLANO CONTRATADO: ' +
			CONVERT(VARCHAR, @plano) +
			' <br /> NÚMERO DE REGISTRO DO PRODUTO NA ANS: ' +
			CONVERT(VARCHAR, @codigoplanoans) +
			' <br /><br /> O PLANO VIDA SAUDE SERVICOS ODONTOLOGICOS LTDA – Oral Santa Helena, inscrito no CNPJ sob 04.430.627/0001-33 e registrado na ANS – Agência Nacional de Saúde Suplementar sob o nº <b>41.598-7</b>, vem sobre avisar conforme consta na <b><font color = "red">cláusula 16.1</font></b> 
							do nosso contrato que: <b>“O contrato poderá ser rescindido unilateralmente pela CONTRATADA, como previsto no inciso II do art. 13 da Lei nº 9.656, de 1998, por não-pagamento da mensalidade por período superior a 60 (Sessenta) dias, consecutivos ou não, nos últimos doze meses de vigência do contrato.” </b>
							<br /><br />
							Informamos que foi constatado que na data de emissão desta notificação, o seu contrato já completou <b>50 (cinquenta)</b> dias de atraso consecutivos conforme consta abaixo e pelo exposto solicitamos a regularização do(s) pagamento(s) em aberto e a manutenção regular dos próximos pagamentos, pois dessa forma você usufrui da melhor forma dos nossos serviços e assim mantem a sua saúde bucal em dias, distante de perdas e dores.
							<br /><br />
							<table cellpadding="3">
							<tr>
							<th>Vencimento</th>
							<th>Valor Original</th>
							<th>Valor Atualizado</th>
							<th>Dias de atraso</th>
							</tr>	'

			DECLARE cursor_fatura_vencida CURSOR FOR
			SELECT
            	CONVERT(VARCHAR(10), ISNULL(T1.dt_vencimento_new, T1.dt_vencimento), 103) AS VENCIMENTO ,
            	T1.vl_parcela ,
            	T1.cd_parcela ,
            	(T1.vl_parcela + ISNULL(T1.vl_jurosmultareferencia, 0) + ISNULL(T1.vl_multa, 0) + ISNULL(T1.vl_acrescimo, 0) + ISNULL(T1.vl_acrescimoavulso, 0) - ISNULL(T1.vl_imposto, 0) - ISNULL(T1.vl_desconto, 0) - ISNULL(T1.vl_descontoavulso, 0) + ISNULL(T1.vl_taxa, 0)) VALORATUALIZADO ,
            	DATEDIFF(d, ISNULL(T1.dt_vencimento_new, T1.dt_vencimento), CONVERT(VARCHAR(10), GETDATE(), 101))

            FROM mensalidades T1
            	INNER JOIN associados T2 ON T1.cd_associado_empresa = T2.cd_associado
            	INNER JOIN dependentes T3 ON T2.cd_associado = T3.cd_associado
            		AND T3.cd_grau_parentesco = 1
            	INNER JOIN historico T4 ON T3.cd_sequencial_historico = T4.cd_sequencial
            	INNER JOIN situacao_historico T5 ON T4.cd_situacao = T5.cd_situacao_historico
            	INNER JOIN planos T6 ON T3.cd_plano = T6.cd_plano
            	INNER JOIN classificacao_ans T7 ON T6.cd_classificacao = T7.cd_classificacao
            	LEFT JOIN tb_tipologradouro T8 ON T2.chave_tipologradouro = T8.chave_tipologradouro
            	LEFT JOIN municipio T9 ON T2.cidid = T9.cd_municipio
            	LEFT JOIN bairro T10 ON T2.baiid = T10.baiid
            	LEFT JOIN uf T11 ON T2.ufid = T11.ufid

            WHERE T1.cd_tipo_recebimento = 0
            AND ISNULL(T1.exibir, 1) = 1
            AND T1.tp_associado_empresa IN (1)
            AND DATEDIFF(d, ISNULL(T1.dt_vencimento_new, T1.dt_vencimento), CONVERT(VARCHAR(10), GETDATE(), 101)) >= 5
            AND DATEDIFF(d, ISNULL(T1.dt_vencimento_new, T1.dt_vencimento), CONVERT(VARCHAR(10), GETDATE(), 101)) <= 51
            AND T5.fl_envia_cobranca = 1
            AND T1.vl_parcela > 0
            AND T1.cd_tipo_parcela NOT IN (101)
            AND T1.cd_parcela NOT IN (SELECT DISTINCT
                                      	     A.cd_parcela
                                      FROM mensalidadesagrupadas AS A,
                                      	mensalidades AS M,
                                      	mensalidades AS M1
                                      WHERE A.cd_parcela = M.cd_parcela
                                      AND A.cd_parcelamae = M1.cd_parcela
                                      AND M1.cd_tipo_parcela = 101
                                      AND M1.cd_tipo_recebimento = 0)
            AND ISNULL(T1.exibir, 1) = 1
            AND T1.cd_associado_empresa = 712898

            ORDER BY ISNULL(T1.dt_vencimento_new, T1.dt_vencimento)

			OPEN cursor_fatura_vencida
			FETCH NEXT FROM cursor_fatura_vencida INTO @vencimento_parcela, @valor, @cd_parcela, @valoratualizado, @diasatraso
			WHILE (@@fetch_status <> -1)
			BEGIN
				SET @sql = @sql + '<tr>'
				SET @sql = @sql + '<td align="left">' + CONVERT(VARCHAR, @vencimento_parcela) + '</td>'
				SET @sql = @sql + '<td align="right">' + CONVERT(VARCHAR, @valor) + '</td>'
				SET @sql = @sql + '<td align="right">' + CONVERT(VARCHAR, @valoratualizado) + '</td>'
				SET @sql = @sql + '<td align="center">' + CONVERT(VARCHAR, @diasatraso) + '</td>'
				SET @sql = @sql + '</tr>'
				FETCH NEXT FROM cursor_fatura_vencida INTO @Vencimento_Parcela, @valor, @cd_parcela, @valorAtualizado, @diasAtraso
			END
			CLOSE cursor_fatura_vencida
			DEALLOCATE cursor_fatura_vencida


			SET @sql = @sql + '</table>
						<br /><br />
						Informamos que o seu contrato poderá ser suspenso ou cancelado caso complete 60(sessenta) dias de atraso consecutivos ou não conforme determina os normativos da Lei. 9.656/98 em especifico a instrução da SÚMULA NORMATIVA Nº 28, DE 30 DE NOVEMBRO DE 2015. Estamos a sua disposição para prestar maiores informações e/ou duvidas através do numero ' + CONVERT(VARCHAR, @telefone) + '.
						<br /><br />  
						Atenciosamente
							'

			--insert tbSaidaEmail (semEmailRemetente, semEmail, semAssunto, semMensagem, semChave, semDtCadastro, codigo, cd_origeminformacao)
			--select @email_faturamento, lower(isnull(tustelefone,'')), 'Carta de fatura vencida ' + @nome_site, @sql, @Chave, getdate(), @cd_empresa , 3
			--from tb_contato as t
			--where t.ttesequencial=50
			--	  and t.cd_origeminformacao=3
			--	  and t.cd_sequencial = @cd_empresa
			--	  and fl_ativo=1

			--insert tbSaidaEmail (semEmailRemetente, semEmail, semAssunto, semMensagem, semChave, semDtCadastro, codigo, cd_origeminformacao)
			--			select @email_faturamento, lower(isnull(tustelefone,'')), 'Carta de fatura VENCIDA ' + @nome_site, @sql, @Chave, getdate(), @cd_associado , 1
			--			from tb_contato as t
			--			where t.ttesequencial=50
			--				  and t.cd_origeminformacao=1
			--				  and t.cd_sequencial = @cd_associado
			--				  and fl_ativo=1

			PRINT @sql

			FETCH NEXT FROM cursor_dados_cliente INTO @cd_associado, @nm_completo, @plano, @codigoPlanoANS, @cep , @nomeTipoLogradouro , @municipio , @bairro, @uf , @EndLogradouro,@EndNumero
		END

		CLOSE cursor_dados_cliente
		DEALLOCATE cursor_dados_cliente
		PRINT @@rowcount

	END try

	begin catch

	select ERROR_LINE () as errolinha,
	ERROR_MESSAGE() as mensagem,
	ERROR_NUMBER() as numero

	end catch
