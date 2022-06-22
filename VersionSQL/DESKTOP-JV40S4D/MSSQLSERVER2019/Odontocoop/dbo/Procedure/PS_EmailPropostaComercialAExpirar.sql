/****** Object:  Procedure [dbo].[PS_EmailPropostaComercialAExpirar]    Committed by VersionSQL https://www.versionsql.com ******/

create procedure [dbo].[PS_EmailPropostaComercialAExpirar]
	as
	begin
	declare @cd_funcionario as int	
	declare @nm_empregado as varchar(100)
	declare @emailDestinatario as varchar(100)
	declare @contratante as varchar(100)
	declare @emailRemetente as varchar(100) = (SELECT email_remetente FROM configuracao)
	declare @aniversarioProposta as varchar(50) 
	declare @chave varchar(50) = Right('00000000000000000000000000000000000000000000000000' + convert(varchar, cast(rand() * 99999999 as integer)) + right(year(getdate()), 4) + right('00' + month(getdate()), 2) + right('00' + day(getdate()), 2) + Right('00' + left(convert(varchar(10), getdate(),108),2), 2) + Right('00' + Right(left(convert(varchar(10), getdate(),108),5),2), 2) + Right('00' + right(convert(varchar(10), getdate(),108),2), 2),50);  
  
	declare cursor_proposta cursor for         
		SELECT 
			  T1.corretora	
			 ,T1.nome_contratante	
			 ,t3.nm_empregado
			 ,T2.tusTelefone
			 ,CONVERT(varchar(10), dateadd(day, T1.validade, T1.data_cadastro), 103)  as aniversarioProposta	
		FROM PropostaComercial T1
		INNER JOIN tb_contato T2 ON T2.cd_sequencial = T1.corretora 
		INNER JOIN FUNCIONARIO t3 on t3.cd_funcionario = T1.corretora	
		WHERE T1.id IS NOT NULL AND T1.data_exclusao IS NULL	
			AND T2.cd_origeminformacao = 2 
			and t3.cd_situacao =1
			AND T2.tteSequencial = 50
			AND datediff(day,getdate(),dateadd(day, T1.validade, T1.data_cadastro)) = 10
		ORDER BY T1.data_cadastro
	open cursor_proposta    
	   fetch next from cursor_proposta into @cd_funcionario, @contratante, @nm_empregado, @emailDestinatario, @aniversarioProposta
										
	   while (@@fetch_status<>-1) 
	   begin	  
		   begin					  			
				--Email para o associado com a carta de reajuste.
				INSERT INTO tbSaidaEmail (semEmailRemetente, cd_origeminformacao, codigo, semEmail, semAssunto, semMensagem, semChave, semDtCadastro, semTipoMensagem, semPrioridadeMensagem, semAssinaturaMensagem, semMensagemConfidencial)
				VALUES (@emailRemetente, --semEmailRemetente
						2, --cd_origeminformacao
						@cd_funcionario, --codigo
						@emailDestinatario , --semEmail
						'Proposta Comercial', --semAssunto
						'Prezado ' + upper(@nm_empregado) + ' a proposta comercial para empresa ' + upper(@contratante) + ' expira em 10 (dez) dias.',--semMensagem
						@chave, --semChave
						getdate(), --semDtCadastro  
						1, --semTipoMensagem
						1, --semPrioridadeMensagem
						1, --semAssinaturaMensagem
						0 --semMensagemConfidencial
				); 
	     
		 fetch next from cursor_proposta into @cd_funcionario, @contratante, @nm_empregado, @emailDestinatario, @aniversarioProposta
	   end 																						
		   close cursor_proposta																
		   deallocate cursor_proposta   														
	end
end
