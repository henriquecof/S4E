/****** Object:  Procedure [dbo].[PS_TEMPNossosNumeros]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PS_TEMPNossosNumeros]
AS
Begin

	--Limpar tabela
	delete tbNossosNumeros

	--Dentistas da rede credenciada
	insert into tbNossosNumeros (nnuDescricao, nnuValor, nnuPeriodo)
	select 'Dentistas na rede credenciada', count(distinct cd_funcionario), 0 from atuacao_dentista_new where fl_ativo = 1
	--select 'Dentistas na rede credenciada', count(distinct T1.cd_funcionario), 0 from atuacao_dentista_new T1, funcionario T2 where T1.cd_funcionario = T2.cd_funcionario and T1.fl_ativo = 1 and (datediff(day,T2.dt_situacao,getdate()) <= 30 or T2.cd_funcionario in (select cd_funcionario from ABS_BI..Acompanhamento_Dentista where cd_funcionario = T2.cd_funcionario and convert(money,prod_aberta) > 0))

	--Consultas marcadas ontem
	insert into tbNossosNumeros (nnuDescricao, nnuValor, nnuPeriodo)
	select 'Consultas marcadas', count(0), 1 from agenda where datediff(day,dt_marcado,getdate())=1

	--Procedimentos realizados ontem
	insert into tbNossosNumeros (nnuDescricao, nnuValor, nnuPeriodo)
	select 'Procedimentos realizados', count(0), 1 from consultas where datediff(day,dt_servico,getdate())=1 and cd_servico not in (490,500, 140, 144, 618)

	--Acessos ontem
	insert into tbNossosNumeros (nnuDescricao, nnuValor, nnuPeriodo)
	select 'Acessos ao Portal ABS', count(0), 1 from ABS_LOGPortal..TB_Acesso_Ace where datediff(day,DtAcesso_Ace,getdate())=1

	--Consultas marcadas no ano
	insert into tbNossosNumeros (nnuDescricao, nnuValor, nnuPeriodo)
	select 'Consultas marcadas', count(0) + (select count(0) from AgendaArquivo where datediff(year,dt_marcado,getdate())=0), 2 from agenda where datediff(year,dt_marcado,getdate())=0
	
	--Procedimentos realizados no ano
	insert into tbNossosNumeros (nnuDescricao, nnuValor, nnuPeriodo)
	select 'Procedimentos realizados', count(0), 2 from consultas where datediff(year,dt_servico,getdate())=0 and cd_servico not in (490,500, 140, 144, 618)

	--Acessos no ano
	insert into tbNossosNumeros (nnuDescricao, nnuValor, nnuPeriodo)
	select 'Acessos ao Portal ABS', count(0), 2 from ABS_LOGPortal..TB_Acesso_Ace where datediff(year,DtAcesso_Ace,getdate())=0
	
	--Consultas marcadas no ano passado
	insert into tbNossosNumeros (nnuDescricao, nnuValor, nnuPeriodo)
	select 'Consultas marcadas', count(0) + (select count(0) from AgendaArquivo where datediff(year,dt_marcado,getdate())=1), 3 from agenda where datediff(year,dt_marcado,getdate())=1

	--Procedimentos realizados no ano passado
	insert into tbNossosNumeros (nnuDescricao, nnuValor, nnuPeriodo)
	select 'Procedimentos realizados', count(0), 3 from consultas where datediff(year,dt_servico,getdate())=1 and cd_servico not in (490,500, 140, 144, 618)

	--Acessos no ano passado
	insert into tbNossosNumeros (nnuDescricao, nnuValor, nnuPeriodo)
	select 'Acessos ao Portal ABS', count(0), 3 from ABS_LOGPortal..TB_Acesso_Ace where datediff(year,DtAcesso_Ace,getdate())=1

End
