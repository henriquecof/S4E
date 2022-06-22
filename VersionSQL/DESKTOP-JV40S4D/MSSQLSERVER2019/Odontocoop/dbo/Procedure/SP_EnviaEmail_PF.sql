/****** Object:  Procedure [dbo].[SP_EnviaEmail_PF]    Committed by VersionSQL https://www.versionsql.com ******/

create procedure [dbo].[SP_EnviaEmail_PF]
as
begin

declare @cd_associado int
declare @email varchar(100)

DECLARE ENVIA_EMAIL CURSOR FOR
	
	select distinct t1.cd_associado,
	(select top 1 lower(tustelefone)
			  from tb_contato as t
			 where t.ttesequencial=50 
			 and t.cd_origeminformacao=1 
			 and t.cd_sequencial = t1.cd_associado 
			 and t.fl_ativo=1)
	from associados t1, dependentes t2, historico t3, mensalidades t4, empresa t5, situacao_historico t6, historico t7, situacao_historico t8
	where t1.cd_associado = t2.cd_associado 
	and t1.cd_associado  = t4.cd_associado_empresa
	and t1.cd_empresa = t5.cd_empresa
	and t2.cd_sequencial_historico = t3.cd_sequencial
	and t3.cd_situacao = t6.cd_situacao_historico
	and t5.cd_sequencial_historico = t7.cd_sequencial
	and t7.cd_situacao  = t8.cd_situacao_historico
	and t6.fl_envia_cobranca = 1
	and t8.fl_envia_cobranca = 1
	and t5.fl_online = 1
	and t4.tp_associado_empresa = 1
	and t2.cd_grau_parentesco = 1
	and t4.cd_tipo_recebimento = 0
	and t4.cd_tipo_parcela = 1
	and datediff(day, t4.dt_vencimento, getdate()) = -5    -- x dias antes do vencimento
	order by 1
	
open ENVIA_EMAIL

FETCH NEXT FROM ENVIA_EMAIL INTO @cd_associado, @email

WHILE (@@FETCH_STATUS <> -1)

begin
	print 'iniciou cursor'
	if @email is not null
		begin
			print 'email not null'
			exec SP_Email_Fatura @email, 0 , @cd_associado
		end
		
	fetch next from ENVIA_EMAIL into @cd_associado, @email 
end		

	
	Close ENVIA_EMAIL
	DEALLOCATE ENVIA_EMAIL

end
