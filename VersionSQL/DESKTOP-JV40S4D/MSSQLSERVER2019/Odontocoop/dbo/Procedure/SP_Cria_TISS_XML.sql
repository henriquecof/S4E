/****** Object:  Procedure [dbo].[SP_Cria_TISS_XML]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_Cria_TISS_XML] @sequencial int
as
Begin
    Declare @sql varchar(max)
    Set @sql = 'select T.sequenciaArquivo,L.variacao, L.referencia,case when indicadorEnvioPapel = 1 then ''S'' else ''N'' end indicadorEnvioPapel, CNES, case when len(codigoCNPJ_CPF)>11 then 1 else 2 end as identificadorExecutante, codigoCNPJ_CPF, 
			           municipioExecutante_ibge, numeroCartaoNacionalSaude, sexo, convert(varchar(10),dataNascimento,120) dataNascimento, municipioResidencia_ibge,
			           numeroRegistroPlano, 4 as tipoEventoAtencao, origemEventoAtencao, numeroGuia_prestador, t.numeroGuia_operadora, 
			           identificacaoReembolso, convert(varchar(10),dataSolicitacao,120) dataSolicitacao, convert(varchar(10),dataAutorizacao,120) dataAutorizacao, convert(varchar(10),dataRealizacao,120) dataRealizacao, convert(varchar(10),dataProtocoloCobranca,120) dataProtocoloCobranca, 
			           convert(varchar(10),dataPagamento,120) dataPagamento, convert(varchar(10),dataProcessamentoGuia,120) dataProcessamentoGuia, tipoFaturamento, declaracaoNascido, codigoProcedimento, 
			           codDente, codRegiao, denteFace, valorInformado, quantidadeInformada, isnull(quantidadePaga,0) quantidadePaga, isnull(valorPagoProc,0) valorPagoProc,
			           isnull(valorTotalInformado,0) valorTotalInformado, valorTotalProcessado , 
			           case when isnull(dataPagamento,'''') <> '''' then  valorTotalProcessado else ''0'' end as valorTotalPagoProcedimentos,
			           isnull(valorTotalInformado,0) - isnull(valorTotalProcessado,0) as valorGlosaGuia,
			           case when isnull(dataPagamento,'''') <> '''' then  valorTotalProcessado else ''0'' end as valorPagoGuia,
			           right(''0000''+convert(varchar(10),cd_grupoprocedimento),3) as cd_grupoprocedimento,
			           4 as formaEnvio, ''0.00'' as valorTotalCoParticipacao, ''0.00'' as valorCoParticipacao, T.cboExecutante, T.cd_tabelaANS
				  from TISS_lote_item as T, TISS_lote L,
				   (select numeroGuia_operadora, 
						   SUM(valorPagoProc) as valorPagoGuia
					  from TISS_lote_item
					 where cd_sequencial_lote='+convert(varchar(10),@sequencial)+' 
					 group by numeroGuia_operadora) as x 
				 where t.cd_sequencial_lote='+convert(varchar(10),@sequencial)+' and t.cd_sequencial_lote = L.cd_sequencial and t.numeroGuia_operadora = x.numeroGuia_operadora 
				   and (t.cd_grupoprocedimento is null or cd_grupoprocedimento>0)
				   and isnull(T.quantidadeInformada,0) > 0
				 order by T.sequenciaArquivo,t.numeroGuia_operadora,
				 isnull((
					 select top 1 X1.cd_sequencial
					 from TISS_lote_item X1
					 inner join TISS_lote X2 on X2.cd_sequencial = X1.cd_sequencial_lote
					 where X1.cd_sequencial_consulta = T.cd_sequencial_consulta
					 and X1.dataPagamento is null
					 and X1.cd_sequencial_lote < T.cd_sequencial_lote
					 and X1.errCod is null
					 and X2.fl_processado != 0
					 order by X1.cd_sequencial
					 ),t.cd_sequencial)
				  '
   --print @sql
   exec(@sql)

End
