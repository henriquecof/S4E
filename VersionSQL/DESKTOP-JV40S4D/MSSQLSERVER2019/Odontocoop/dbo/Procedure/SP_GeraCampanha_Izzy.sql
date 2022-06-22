/****** Object:  Procedure [dbo].[SP_GeraCampanha_Izzy]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SP_GeraCampanha_Izzy]
AS
BEGIN/*
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

-- Apagar a Tabelas dos atrasados. Caso de erro nao fica registro do dia anterior
delete tb_izzy

Declare @DataGeracao as date 
set @DataGeracao = getdate()-1 

--exec SP_AnaliseCobranca_Izzy 1, 0 

-- Exclui parcelas virtual quando data de vencimento maior que data definida na configuração ou 7 dias.
--update mensalidades	
--set	CD_TIPO_RECEBIMENTO = 1
--from mensalidades T1
--where T1.cd_tipo_parcela = 101
--	and T1.DT_VENCIMENTO < DATEADD(DAY, -isnull((Select top 1 qt_dias_expira_boletovirtual from configuracao),7),CONVERT(date,getdate()))
--	and CD_TIPO_RECEBIMENTO = 0 --ABERTA
	
-- Processar mudancas de Situacoes

IF  not EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MensalidadeResumo]') AND type in (N'U'))
Begin
    Raiserror('Mensalidade Resumo não criada.',16,1)
    return
End     

if (select COUNT(0) from MensalidadeResumo where tipo=1)=0
Begin
    Raiserror('Mensalidade Resumo não povoada.',16,1)
    return
End     

 --   print 'Se Situacao = 1 -- Ativo e Dias > 60 mover para INADIMPLENTE (4)'
	--insert into historico (CD_SEQUENCIAL_dep, DT_SITUACAO, CD_SITUACAO)
	--Select cd_seqdep ,@DataGeracao,18 
	--  from MensalidadeResumo as m, ASSOCIADOS as a, DEPENDENTES as d, empresa as e , HISTORICO as h , historico as eh -- Historico da Empresa
	-- where m.codigo=a.cd_associado and 
	--	   a.cd_empresa=e.CD_EMPRESA and 
	--	   e.cd_sequencial_historico = eh.cd_sequencial and eh.cd_situacao = 1 and 
	--	   a.cd_associado=d.CD_ASSOCIADO and d.CD_GRAU_PARENTESCO=1 and 
	--	   d.CD_Sequencial_historico=h.CD_SEQUENCIAL and
	--	   h.CD_SITUACAO = 1 and 
	--	   m.situacao=1 and 
	--	   m.tipo=1 and 
	--	   m.dias>90  and m.qtde_abertas >= 3 and 
	--	   e.TP_EMPRESA in (3,10)        
          
-- Cobranca

declare @dt_i date
declare @dt_f date 
Declare @qt_dias int 

--1	5 a 30 dias de atraso PF
--2	31 a 60 dias de atraso PF
--3	61 a 90 dias de atraso PF
--4	Superior a 90 dias de atraso PF

set @qt_dias=5
Set @dt_i = DATEADD(year,-5,@DataGeracao)
Set @dt_f = DATEADD(day,-10,@DataGeracao)

insert into tb_izzy 
SELECT Case When t16.dias <= 30 then 1
            When t16.dias <= 60 then 2  
            When t16.dias <= 90 then 3
            Else 4 End as Campanha, 
       T2.cd_associado as ID_ERP_CRM, 
       T2.nm_completo as Nome_Prospect , 
       T2.dt_nascimento as Nascimento, 
       T2.nr_cpf as CPF_CNPJ, 
       T2.nr_identidade RG_CGF, 
       (select top 1 tusTelefone 
          from TB_Contato as I1
          where I1.cd_sequencial = T2.cd_associado and
                I1.cd_origeminformacao=1 and  
                I1.tteSequencial=50 and 
                i1.fl_ativo=1 
           order by i1.tusQuantidade desc) as email , 
       null as sexo,
       ltrim(isnull(t8.nome_tipo,'')+' ')+isnull(T2.EndLogradouro,'') + ' '+ convert(varchar(10),isnull(T2.EndNumero,'')) as Logradouro, 
       T2.EndComplemento as Complemento, 
       T6.baiDescricao as Bairro,
       T2.LogCep as CEP,
       T5.NM_MUNICIPIO as Cidade,
       T4.ufSigla as Estado,
       Null as Data_ERP_CRM, 
       null as Telefone_Contato_1,	
       null as Telefone_Contato_2,	
       null as Telefone_Contato_3,
       T2.nm_completo as Contato_1,
       T1.CD_PARCELA as Numero_Titulo, 
       t15.nm_tipo_pagamento Tipo_Titulo, 
       T1.DT_VENCIMENTO as Data_Titulo,
       T1.VL_PARCELA+isnull(T1.VL_Acrescimo,0)-isnull(T1.VL_Desconto,0)-isnull(t1.VL_JurosMultaReferencia,0) as Valor_Titulo,  
       T2.nm_completo as Produto,
       t12.ds_centro_custo as Filial, 
       day(T1.DT_VENCIMENTO) as Dia_Vencimento,
       Null as Informacao_Adicional_1,
       Null as Informacao_Adicional_2,
       Null as Informacao_Adicional_3,
       t13.ds_associado_empresa as Auxiliar_1,
       t14.ds_tipo_parcela as Auxiliar_2,
       (select ds_campanha from campanha where cd_campanha = 
													Case When t16.dias <= 30 then 1
														When t16.dias <= 60 then 2  
														When t16.dias <= 90 then 3
														Else 4 End) as Auxiliar_3,
       Null as Agrupador, null, null, null, null, T11.cd_centro_custo , null , null , null , null, null, null
FROM  MensalidadeResumo T16,      
      MENSALIDADES T1, ASSOCIADOS T2, DEPENDENTES T3 , 
      UF T4, MUNICIPIO T5, Bairro T6, TB_TIPOLOGRADOURO T8, 
--      -- TB_Contato T9, 
      EMPRESA T11 ,
      centro_custo t12, 
      tipo_associado_empresa t13,
      tipo_parcela t14,
      tipo_pagamento t15, 
      HISTORICO T17
where t16.codigo = t1.cd_Associado_empresa and t16.tipo=1 and T1.TP_ASSOCIADO_EMPRESA = 1
  and t16.dias >= @qt_dias --and t16.dias <= 90
  and t16.codigo = t2.cd_associado 
  and t16.codigo = t3.CD_ASSOCIADO and t3.CD_GRAU_PARENTESCO=1 
  and t3.cd_sequencial_historico = t17.cd_sequencial and t17.cd_situacao not in (5) -- SPC
  and T2.ufId *= T4.ufId
  and T2.CidID *= T5.CD_MUNICIPIO
  and T2.BaiId *= T6.baiId 
  and t2.chave_tipologradouro *= t8.chave_tipologradouro 
-- --  and T2.cd_associado = T9.cd_sequencial
-- --  and T9.cd_origeminformacao = 1
-- --  and T9.tteSequencial In (1)
-- --  and T9.fl_ativo = 1
  and T2.cd_empresa = T11.CD_EMPRESA
  and t11.cd_centro_custo = t12.cd_centro_custo 
  and t1.tp_associado_empresa = t13.tp_associado_empresa
  and t1.cd_tipo_parcela = t14.cd_tipo_parcela 
  and t1.cd_tipo_pagamento = t15.cd_tipo_pagamento 
  and t1.cd_tipo_recebimento = 0 -- Aberta 
  and t1.dt_vencimento >= @dt_i
  and t1.dt_vencimento <= @dt_f 
  and t11.tp_empresa in (3,10)
  
  
print 'Campanha 01/05/06'
Print @@rowcount

--5	Clientes negativados em SPC PF
--6	Suspensos PF

insert into tb_izzy 
SELECT Case when T16.CD_SITUACAO=5 then 5 -- SPC
            else 6 end, -- Suspensos
       T2.cd_associado as ID_ERP_CRM, 
       T2.nm_completo as Nome_Prospect , 
       T2.dt_nascimento as Nascimento, 
       T2.nr_cpf as CPF_CNPJ, 
       T2.nr_identidade RG_CGF, 
       (select top 1 tusTelefone 
          from TB_Contato as I1
          where I1.cd_sequencial = T2.cd_associado and
                I1.cd_origeminformacao=1 and  
                I1.tteSequencial=50 and 
                i1.fl_ativo=1 
           order by i1.tusQuantidade desc) as email , 
       null as sexo,
       ltrim(isnull(t8.nome_tipo,'')+' ')+isnull(T2.EndLogradouro,'') + ' '+ convert(varchar(10),isnull(T2.EndNumero,'')) as Logradouro, 
       T2.EndComplemento as Complemento, 
       T6.baiDescricao as Bairro,
       T2.LogCep as CEP,
       T5.NM_MUNICIPIO as Cidade,
       T4.ufSigla as Estado,
       Null as Data_ERP_CRM, 
       null as Telefone_Contato_1,	
       null as Telefone_Contato_2,	
       null as Telefone_Contato_3,
       T2.nm_completo as Contato_1,
       T1.CD_PARCELA as Numero_Titulo, 
       t15.nm_tipo_pagamento Tipo_Titulo, 
       T1.DT_VENCIMENTO as Data_Titulo,
       T1.VL_PARCELA+isnull(T1.VL_Acrescimo,0)-isnull(T1.VL_Desconto,0)-isnull(t1.VL_JurosMultaReferencia,0) as Valor_Titulo,  
       T2.nm_completo as Produto,
       t12.ds_centro_custo as Filial, 
       day(T1.DT_VENCIMENTO) as Dia_Vencimento,
       Null as Informacao_Adicional_1,
       Null as Informacao_Adicional_2,
       Null as Informacao_Adicional_3,
       t13.ds_associado_empresa as Auxiliar_1,
       t14.ds_tipo_parcela as Auxiliar_2,
       (select ds_campanha from campanha where cd_campanha = 
													Case when T16.CD_SITUACAO=5 then 5 -- SPC
														 else 6 end) as Auxiliar_3,
       Null as Agrupador, null, null, null, null, T11.cd_centro_custo , null , null , null , null, null, null
FROM        
      MENSALIDADES T1, ASSOCIADOS T2, DEPENDENTES T3 , 
      UF T4, MUNICIPIO T5, Bairro T6, TB_TIPOLOGRADOURO T8, 
      EMPRESA T11 ,
      centro_custo t12, 
      tipo_associado_empresa t13,
      tipo_parcela t14,
      tipo_pagamento t15,
      HISTORICO T16
	
where t1.cd_Associado_empresa = t2.cd_associado 
  and T1.TP_ASSOCIADO_EMPRESA = 1
  and T2.ufId *= T4.ufId
  and T2.CidID *= T5.CD_MUNICIPIO
  and T2.BaiId *= T6.baiId 
  and t2.chave_tipologradouro *= t8.chave_tipologradouro 
  and T2.cd_empresa = T11.CD_EMPRESA
  and t11.cd_centro_custo = t12.cd_centro_custo 
  and t1.tp_associado_empresa = t13.tp_associado_empresa
  and t1.cd_tipo_parcela = t14.cd_tipo_parcela 
  and t1.cd_tipo_pagamento = t15.cd_tipo_pagamento 
  and t1.cd_tipo_recebimento = 0 -- Aberta 
  AND T2.cd_associado = T3.CD_ASSOCIADO AND T3.CD_GRAU_PARENTESCO=1
  AND T3.CD_Sequencial_historico = T16.CD_SEQUENCIAL 
  AND T16.CD_SITUACAO in (3,5)
  and t1.DT_VENCIMENTO<=@dt_f 
  and t11.tp_empresa in (3,10) 

-- Dom : 1
-- Seg : 2
-- Ter : 3
-- Qua : 4
-- Qui : 5
-- Sex : 6
-- Sab : 7

--7	Consultas marcadas com usuarios atrasados PF'
set @dt_i = DATEADD(day,1,@DataGeracao)
set @dt_f = dateadd(DAY,case when DATEPART(dw,@dt_i)in (3,4,5) then 1
							 when DATEPART(dw,@dt_i)in (1,6,7) then 3 
                             else 2 end , @dt_i)

insert into tb_izzy 
SELECT 7 as Campanha, 
       T2.cd_associado as ID_ERP_CRM, 
       T2.nm_completo as Nome_Prospect , 
       T2.dt_nascimento as Nascimento, 
       T2.nr_cpf as CPF_CNPJ, 
       T2.nr_identidade RG_CGF, 
       (select top 1 tusTelefone 
          from TB_Contato as I1
          where I1.cd_sequencial = T2.cd_associado and
                I1.cd_origeminformacao=1 and  
                I1.tteSequencial=50 and 
                i1.fl_ativo=1 
           order by i1.tusQuantidade desc) as email , 
       null as sexo,
       ltrim(isnull(t8.nome_tipo,'')+' ')+isnull(T2.EndLogradouro,'') + ' '+ convert(varchar(10),isnull(T2.EndNumero,'')) as Logradouro, 
       T2.EndComplemento as Complemento, 
       T6.baiDescricao as Bairro,
       T2.LogCep as CEP,
       T5.NM_MUNICIPIO as Cidade,
       T4.ufSigla as Estado,
       Null as Data_ERP_CRM, 
       null as Telefone_Contato_1,	
       null as Telefone_Contato_2,	
       null as Telefone_Contato_3,
       T2.nm_completo as Contato_1,
       T1.CD_PARCELA as Numero_Titulo, 
       t15.nm_tipo_pagamento Tipo_Titulo, 
       T1.DT_VENCIMENTO as Data_Titulo,
       T1.VL_PARCELA+isnull(T1.VL_Acrescimo,0)-isnull(T1.VL_Desconto,0)-isnull(t1.VL_JurosMultaReferencia,0) as Valor_Titulo,  
       T2.nm_completo as Produto,
       t12.ds_centro_custo as Filial, 
       day(T1.DT_VENCIMENTO) as Dia_Vencimento,
       Null as Informacao_Adicional_1,
       Null as Informacao_Adicional_2,
       Null as Informacao_Adicional_3,
       t13.ds_associado_empresa as Auxiliar_1,
       convert(varchar(10),t18.dt_compromisso,103) + ' Clinica:' + t19.nm_filial + ' Dentista:' + t20.nm_empregado + ' Usuário:' + t3.nm_dependente as Auxiliar_2,
      (select ds_campanha from campanha where cd_campanha = 7) as Auxiliar_3,
       --convert(varchar(10),t18.dt_compromisso,103) + ' ' + t19.nm_filial + ' ' + t20.nm_empregado + ' ' + t3.nm_dependente  as Auxiliar_3,
       Null as Agrupador, null, null, null, null, T11.cd_centro_custo , null , null , null , null, null, null
FROM  MensalidadeResumo T16, AGENDA t18, FILIAL T19, FUNCIONARIO T20,      
      MENSALIDADES T1, ASSOCIADOS T2, DEPENDENTES T3 , 
      UF T4, MUNICIPIO T5, Bairro T6, TB_TIPOLOGRADOURO T8, 
--      -- TB_Contato T9, 
      EMPRESA T11 ,
      centro_custo t12, 
      tipo_associado_empresa t13,
      tipo_parcela t14,
      tipo_pagamento t15
where t18.cd_Associado = t16.codigo and t18.dt_compromisso >= @dt_i and t18.dt_compromisso <= @dt_f
  and t16.codigo = t1.cd_Associado_empresa and t16.tipo=1 and T1.TP_ASSOCIADO_EMPRESA = 1
  and t16.dias >= 2 
  and t18.cd_associado = t2.cd_associado 
  and t18.cd_sequencial_dep = t3.CD_sequencial 
  and T2.ufId *= T4.ufId
  and T2.CidID *= T5.CD_MUNICIPIO
  and T2.BaiId *= T6.baiId 
  and t2.chave_tipologradouro *= t8.chave_tipologradouro 
  and T2.cd_empresa = T11.CD_EMPRESA
  and t11.cd_centro_custo = t12.cd_centro_custo 
  and t1.tp_associado_empresa = t13.tp_associado_empresa
  and t1.cd_tipo_parcela = t14.cd_tipo_parcela 
  and t1.cd_tipo_pagamento = t15.cd_tipo_pagamento 
  and t1.cd_tipo_recebimento = 0 -- Aberta 
  and t18.cd_filial = t19.cd_filial 
  and t18.cd_funcionario = t20.cd_funcionario 
  and t1.DT_VENCIMENTO<= DATEADD(DAY,-2,@DataGeracao) 
  and t11.tp_empresa in (1,3,4,5,10)
order by t18.dt_compromisso   


--11	5 a 30 dias de atraso PJ
--12	31 a 60 dias de atraso PJ
--13	61 a 90 dias de atraso PJ
--14	Superior a 90 dias de atraso PJ

set @qt_dias = 5 
Set @dt_i = DATEADD(day,-180,@DataGeracao)
Set @dt_f = DATEADD(day,-5,@DataGeracao)

insert into tb_izzy 
SELECT Case When t16.dias <= 30 then 11
            When t16.dias <= 60 then 12  
            When t16.dias <= 90 then 13
            Else 14 End, 
       T11.CD_EMPRESA  as ID_ERP_CRM, 
       T11.NM_FANTASIA  as Nome_Prospect , 
       NULL  as Nascimento, 
       T11.NR_CGC as CPF_CNPJ, 
       NULL as RG_CGF, 
       (select top 1 tusTelefone 
          from TB_Contato as I1
          where I1.cd_sequencial = T11.CD_EMPRESA and
                I1.cd_origeminformacao=3 and  
                I1.tteSequencial=50 and 
                i1.fl_ativo=1 
           order by i1.tusQuantidade desc) as email , 
       null as sexo,
       ltrim(isnull(t8.nome_tipo,'')+' ')+isnull(T11.EndLogradouro,'') + ' '+ convert(varchar(10),isnull(T11.EndNumero,'')) as Logradouro, 
       T11.EndComplemento as Complemento, 
       T6.baiDescricao as Bairro,
       T11.Cep as CEP,
       T5.NM_MUNICIPIO as Cidade,
       T4.ufSigla as Estado,
       Null as Data_ERP_CRM, 
       null as Telefone_Contato_1,	
       null as Telefone_Contato_2,	
       null as Telefone_Contato_3,
       T11.NM_RAZSOC as Contato_1,
       T1.CD_PARCELA as Numero_Titulo, 
       t15.nm_tipo_pagamento Tipo_Titulo, 
       T1.DT_VENCIMENTO as Data_Titulo,
       T1.VL_PARCELA+isnull(T1.VL_Acrescimo,0)-isnull(T1.VL_Desconto,0)-isnull(t1.VL_JurosMultaReferencia,0) as Valor_Titulo,  
       T11.NM_FANTASIA  as Produto,
       t12.ds_centro_custo as Filial, 
       day(T1.DT_VENCIMENTO) as Dia_Vencimento,
       Null as Informacao_Adicional_1,
       Null as Informacao_Adicional_2,
       Null as Informacao_Adicional_3,
       t13.ds_associado_empresa as Auxiliar_1,
       t14.ds_tipo_parcela as Auxiliar_2,
      (select ds_campanha from campanha where cd_campanha = 
											Case When t16.dias <= 30 then 1
												When t16.dias <= 60 then 2  
												When t16.dias <= 90 then 3
												Else 4 End) as Auxiliar_3,
       Null as Agrupador, null, null, null, null, T11.cd_centro_custo , null , null , null , null, null, null
FROM  MensalidadeResumo T16 , 
      MENSALIDADES T1, 
      UF T4, MUNICIPIO T5, Bairro T6, TB_TIPOLOGRADOURO T8, 
      EMPRESA T11 ,
      centro_custo t12, 
      tipo_associado_empresa t13,
      tipo_parcela t14,
      tipo_pagamento t15
where t16.codigo = t1.cd_associado_empresa and t16.tipo in (2,3) 
  and t16.dias >= @qt_dias 
  and t1.cd_Associado_empresa = t11.CD_EMPRESA 
  and T1.TP_ASSOCIADO_EMPRESA in (2,3)
  and T11.ufId *= T4.ufId
  and T11.cd_municipio  *= T5.CD_MUNICIPIO
  and T11.BaiId *= T6.baiId 
  and t11.chave_tipologradouro *= t8.chave_tipologradouro 
  and t11.cd_centro_custo = t12.cd_centro_custo 
  and t1.tp_associado_empresa = t13.tp_associado_empresa
  and t1.cd_tipo_parcela = t14.cd_tipo_parcela 
  and t1.cd_tipo_pagamento = t15.cd_tipo_pagamento 
  and t1.cd_tipo_recebimento = 0 -- Aberta 
  and t1.dt_vencimento >=  @dt_i
  and t1.dt_vencimento <=  @dt_f


--15	Clientes negativados em SPC PJ
--16	Suspensos PJ

--5	Clientes negativados em SPC PF
--6	Suspensos PF

insert into tb_izzy 
SELECT Case when T16.CD_SITUACAO=5 then 15 -- SPC
            else 16 end, -- Suspensos
       T2.cd_associado as ID_ERP_CRM, 
       T2.nm_completo as Nome_Prospect , 
       T2.dt_nascimento as Nascimento, 
       T2.nr_cpf as CPF_CNPJ, 
       T2.nr_identidade RG_CGF, 
       (select top 1 tusTelefone 
          from TB_Contato as I1
          where I1.cd_sequencial = T2.cd_associado and
                I1.cd_origeminformacao=1 and  
                I1.tteSequencial=50 and 
                i1.fl_ativo=1 
           order by i1.tusQuantidade desc) as email , 
       null as sexo,
       ltrim(isnull(t8.nome_tipo,'')+' ')+isnull(T2.EndLogradouro,'') + ' '+ convert(varchar(10),isnull(T2.EndNumero,'')) as Logradouro, 
       T2.EndComplemento as Complemento, 
       T6.baiDescricao as Bairro,
       T2.LogCep as CEP,
       T5.NM_MUNICIPIO as Cidade,
       T4.ufSigla as Estado,
       Null as Data_ERP_CRM, 
       null as Telefone_Contato_1,	
       null as Telefone_Contato_2,	
       null as Telefone_Contato_3,
       T2.nm_completo as Contato_1,
       T1.CD_PARCELA as Numero_Titulo, 
       t15.nm_tipo_pagamento Tipo_Titulo, 
       T1.DT_VENCIMENTO as Data_Titulo,
       T1.VL_PARCELA+isnull(T1.VL_Acrescimo,0)-isnull(T1.VL_Desconto,0)-isnull(t1.VL_JurosMultaReferencia,0) as Valor_Titulo,  
       T2.nm_completo as Produto,
       t12.ds_centro_custo as Filial, 
       day(T1.DT_VENCIMENTO) as Dia_Vencimento,
       Null as Informacao_Adicional_1,
       Null as Informacao_Adicional_2,
       Null as Informacao_Adicional_3,
       t13.ds_associado_empresa as Auxiliar_1,
       t14.ds_tipo_parcela as Auxiliar_2,
       (select ds_campanha from campanha where cd_campanha = 
													Case when T16.CD_SITUACAO=5 then 15 -- SPC
														 else 16 end) as Auxiliar_3,
       Null as Agrupador, null, null, null, null, T11.cd_centro_custo , null , null , null , null, null, null
FROM        
      MENSALIDADES T1, ASSOCIADOS T2, DEPENDENTES T3 , 
      UF T4, MUNICIPIO T5, Bairro T6, TB_TIPOLOGRADOURO T8, 
      EMPRESA T11 ,
      centro_custo t12, 
      tipo_associado_empresa t13,
      tipo_parcela t14,
      tipo_pagamento t15,
      HISTORICO T16
	
where t1.cd_Associado_empresa = t2.cd_associado 
  and T1.TP_ASSOCIADO_EMPRESA = 1
  and T2.ufId *= T4.ufId
  and T2.CidID *= T5.CD_MUNICIPIO
  and T2.BaiId *= T6.baiId 
  and t2.chave_tipologradouro *= t8.chave_tipologradouro 
  and T2.cd_empresa = T11.CD_EMPRESA
  and t11.cd_centro_custo = t12.cd_centro_custo 
  and t1.tp_associado_empresa = t13.tp_associado_empresa
  and t1.cd_tipo_parcela = t14.cd_tipo_parcela 
  and t1.cd_tipo_pagamento = t15.cd_tipo_pagamento 
  and t1.cd_tipo_recebimento = 0 -- Aberta 
  AND T2.cd_associado = T3.CD_ASSOCIADO AND T3.CD_GRAU_PARENTESCO=1
  AND T3.CD_Sequencial_historico = T16.CD_SEQUENCIAL 
  AND T16.CD_SITUACAO in (3,5)
  and t1.DT_VENCIMENTO<=@dt_f 
  and t11.tp_empresa in (2) 


  


--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
--
--17	SMS - 2 Dias Antes do Vencimento
--
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

insert into tb_Izzy    
(cd_campanha, id_erp_crm, Nome_Prospect, Telefone_Contato_1, Informacao_Adicional_1, cd_centro_custo,  cd_tipo_campanha, Filial)        
	
SELECT 
		17 as cd_campanha,
		T2.cd_associado as id_erp_crm, 
		t2.nm_completo as Nome_Prospect, 
		t4.tusTelefone as Telefone_Contato_1, 
		'Odontocoop:' + left(T2.nm_completo,charindex(' ',T2.nm_completo)-1) + ', seu vencimento está próximo. Para pagamento use: '+ [dbo].[FF_LinhaDigitavel](T1.CD_PARCELA) as Informacao_Adicional_1, 
		1 as cd_centro_custo,  
		5 as cd_tipo_campanha, 
		'Odontocoop' as Filial

FROM MENSALIDADES t1
inner join ASSOCIADOS T2 on t1.CD_ASSOCIADO_empresa = T2.cd_associado
inner join tb_contato T4 on t2.cd_associado = t4.cd_sequencial    
inner join tipo_pagamento T10 on t1.cd_tipo_pagamento = t10.cd_tipo_pagamento

WHERE isnull(T1.exibir, 1) = 1
	and T1.CD_TIPO_RECEBIMENTO = 0
	and isnull(t1.dt_vencimento_new, t1.dt_vencimento) >= convert(DATE, getdate()+2)
	and isnull(t1.dt_vencimento_new, t1.dt_vencimento) <= convert(DATE, getdate()+2)
	and t1.TP_ASSOCIADO_EMPRESA = 1
	and isnull([dbo].[FF_LinhaDigitavel](T1.CD_PARCELA),'Erro Busca Parcela')<> 'Erro Busca Parcela'
	and t1.VL_PARCELA>0
	and t10.fl_boleto = 1 
	and t1.cd_tipo_parcela not in (101)

	and T4.tteSequencial < 50 -- Telefone
	and LEN(T4.tustelefone) = 11
	and ISNUMERIC(T4.tustelefone)=1
	and SUBSTRING(T4.tustelefone,3,1) > 7 -- Celular
	and T4.cd_origeminformacao = 1 -- Associado
	and T4.fl_ativo = 1

UNION

SELECT 
		17 as cd_campanha,
		T2.cd_associado as id_erp_crm, 
		t2.nm_completo as Nome_Prospect, 
		t4.tusTelefone as Telefone_Contato_1, 
		'Odontocoop:' + left(T2.nm_completo,charindex(' ',T2.nm_completo)-1) + ', seu vencimento está próximo. Para pagamento use: '+ [dbo].[FF_LinhaDigitavel](T1.CD_PARCELA) as Informacao_Adicional_1, 
		1 as cd_centro_custo,  
		5 as cd_tipo_campanha, 
		'Odontocoop' as Filial

FROM MENSALIDADES t1
inner join ASSOCIADOS T2 on t1.CD_ASSOCIADO_empresa = T2.cd_associado
inner join DEPENDENTES T3 ON T2.cd_associado = t3.CD_ASSOCIADO
inner join tb_contato T4 on t3.CD_SEQUENCIAL = t4.cd_sequencial    
inner join tipo_pagamento T10 on t1.cd_tipo_pagamento = t10.cd_tipo_pagamento

WHERE isnull(T1.exibir, 1) = 1
	and T1.CD_TIPO_RECEBIMENTO = 0
	and isnull(t1.dt_vencimento_new, t1.dt_vencimento) >= convert(DATE, getdate()+2)
	and isnull(t1.dt_vencimento_new, t1.dt_vencimento) <= convert(DATE, getdate()+2)
	and t1.TP_ASSOCIADO_EMPRESA = 1
	and isnull([dbo].[FF_LinhaDigitavel](T1.CD_PARCELA),'Erro Busca Parcela')<> 'Erro Busca Parcela'
	and t1.VL_PARCELA>0
	and t10.fl_boleto = 1 
	and t1.cd_tipo_parcela not in (101)

	and T4.tteSequencial < 50 -- Telefone
	and LEN(T4.tustelefone) = 11
	and ISNUMERIC(T4.tustelefone)=1
	and SUBSTRING(T4.tustelefone,3,1) > 7 -- Celular
	and T4.cd_origeminformacao = 5 -- Dependente
	and T4.fl_ativo = 1

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
	

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
--
--18	SMS - Dia do Vencimento
--
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

insert into tb_Izzy    
(cd_campanha, id_erp_crm, Nome_Prospect, Telefone_Contato_1, Informacao_Adicional_1, cd_centro_custo,  cd_tipo_campanha, Filial)        
	
SELECT 
		18 as cd_campanha,
		T2.cd_associado as id_erp_crm, 
		t2.nm_completo as Nome_Prospect, 
		t4.tusTelefone as Telefone_Contato_1, 
		'Odontocoop:' + left(T2.nm_completo,charindex(' ',T2.nm_completo)-1) + ', seu boleto vence hoje. Para pagamento use: '+ [dbo].[FF_LinhaDigitavel](T1.CD_PARCELA) as Informacao_Adicional_1, 
		1 as cd_centro_custo,  
		5 as cd_tipo_campanha, 
		'Odontocoop' as Filial

FROM MENSALIDADES t1
inner join ASSOCIADOS T2 on t1.CD_ASSOCIADO_empresa = T2.cd_associado
inner join tb_contato T4 on t2.cd_associado = t4.cd_sequencial    
inner join tipo_pagamento T10 on t1.cd_tipo_pagamento = t10.cd_tipo_pagamento

WHERE isnull(T1.exibir, 1) = 1
	and T1.CD_TIPO_RECEBIMENTO = 0
	and isnull(t1.dt_vencimento_new, t1.dt_vencimento) >= convert(DATE, getdate())
	and isnull(t1.dt_vencimento_new, t1.dt_vencimento) <= convert(DATE, getdate())
	and t1.TP_ASSOCIADO_EMPRESA = 1
	and isnull([dbo].[FF_LinhaDigitavel](T1.CD_PARCELA),'Erro Busca Parcela')<> 'Erro Busca Parcela'
	and t1.VL_PARCELA>0
	and t10.fl_boleto = 1 
	and t1.cd_tipo_parcela not in (101)

	and T4.tteSequencial < 50 -- Telefone
	and LEN(T4.tustelefone) = 11
	and ISNUMERIC(T4.tustelefone)=1
	and SUBSTRING(T4.tustelefone,3,1) > 7 -- Celular
	and T4.cd_origeminformacao = 1 -- Associado
	and T4.fl_ativo = 1

UNION

SELECT 
		18 as cd_campanha,
		T2.cd_associado as id_erp_crm, 
		t2.nm_completo as Nome_Prospect, 
		t4.tusTelefone as Telefone_Contato_1, 
		'Odontocoop:' + left(T2.nm_completo,charindex(' ',T2.nm_completo)-1) + ', seu boleto vence hoje. Para pagamento use: '+ [dbo].[FF_LinhaDigitavel](T1.CD_PARCELA) as Informacao_Adicional_1, 
		1 as cd_centro_custo,  
		5 as cd_tipo_campanha, 
		'Odontocoop' as Filial

FROM MENSALIDADES t1
inner join ASSOCIADOS T2 on t1.CD_ASSOCIADO_empresa = T2.cd_associado
inner join DEPENDENTES T3 ON T2.cd_associado = t3.CD_ASSOCIADO
inner join tb_contato T4 on t3.CD_SEQUENCIAL = t4.cd_sequencial    
inner join tipo_pagamento T10 on t1.cd_tipo_pagamento = t10.cd_tipo_pagamento

WHERE isnull(T1.exibir, 1) = 1
	and T1.CD_TIPO_RECEBIMENTO = 0
	and isnull(t1.dt_vencimento_new, t1.dt_vencimento) >= convert(DATE, getdate())
	and isnull(t1.dt_vencimento_new, t1.dt_vencimento) <= convert(DATE, getdate())
	and t1.TP_ASSOCIADO_EMPRESA = 1
	and isnull([dbo].[FF_LinhaDigitavel](T1.CD_PARCELA),'Erro Busca Parcela')<> 'Erro Busca Parcela'
	and t1.VL_PARCELA>0
	and t10.fl_boleto = 1 
	and t1.cd_tipo_parcela not in (101)

	and T4.tteSequencial < 50 -- Telefone
	and LEN(T4.tustelefone) = 11
	and ISNUMERIC(T4.tustelefone)=1
	and SUBSTRING(T4.tustelefone,3,1) > 7 -- Celular
	and T4.cd_origeminformacao = 5 -- Dependente
	and T4.fl_ativo = 1

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
	
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
--
--19	SMS - 4 Dias Após o Vencimento
--
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

insert into tb_Izzy    
(cd_campanha, id_erp_crm, Nome_Prospect, Telefone_Contato_1, Informacao_Adicional_1, cd_centro_custo,  cd_tipo_campanha, Filial)        
	
SELECT 
		19 as cd_campanha,
		T2.cd_associado as id_erp_crm, 
		t2.nm_completo as Nome_Prospect, 
		t4.tusTelefone as Telefone_Contato_1, 
		'Odontocoop:' + left(T2.nm_completo,charindex(' ',T2.nm_completo)-1) + ', seu boleto venceu ha 4 dias. Para pagamento sem multas e juros use: '+ [dbo].[FF_LinhaDigitavel](T1.CD_PARCELA) as Informacao_Adicional_1, 
		1 as cd_centro_custo,  
		5 as cd_tipo_campanha, 
		'Odontocoop' as Filial

FROM MENSALIDADES t1
inner join ASSOCIADOS T2 on t1.CD_ASSOCIADO_empresa = T2.cd_associado
inner join tb_contato T4 on t2.cd_associado = t4.cd_sequencial    
inner join tipo_pagamento T10 on t1.cd_tipo_pagamento = t10.cd_tipo_pagamento

WHERE isnull(T1.exibir, 1) = 1
	and T1.CD_TIPO_RECEBIMENTO = 0
	and datediff(day,isnull(t1.dt_vencimento_new, t1.dt_vencimento),convert(DATE, getdate())) in (4)
	and t1.TP_ASSOCIADO_EMPRESA = 1
	and isnull([dbo].[FF_LinhaDigitavel](T1.CD_PARCELA),'Erro Busca Parcela')<> 'Erro Busca Parcela'
	and t1.VL_PARCELA>0
	and t10.fl_boleto = 1 
	and t1.cd_tipo_parcela not in (101)

	and T4.tteSequencial < 50 -- Telefone
	and LEN(T4.tustelefone) = 11
	and ISNUMERIC(T4.tustelefone)=1
	and SUBSTRING(T4.tustelefone,3,1) > 7 -- Celular
	and T4.cd_origeminformacao = 1 -- Associado
	and T4.fl_ativo = 1

UNION

SELECT 
		19 as cd_campanha,
		T2.cd_associado as id_erp_crm, 
		t2.nm_completo as Nome_Prospect, 
		t4.tusTelefone as Telefone_Contato_1, 
		'Odontocoop:' + left(T2.nm_completo,charindex(' ',T2.nm_completo)-1) + ', seu boleto venceu ha 4 dias. Para pagamento sem multas e juros use: '+ [dbo].[FF_LinhaDigitavel](T1.CD_PARCELA) as Informacao_Adicional_1, 
		1 as cd_centro_custo,  
		5 as cd_tipo_campanha, 
		'Odontocoop' as Filial

FROM MENSALIDADES t1
inner join ASSOCIADOS T2 on t1.CD_ASSOCIADO_empresa = T2.cd_associado
inner join DEPENDENTES T3 ON T2.cd_associado = t3.CD_ASSOCIADO
inner join tb_contato T4 on t3.CD_SEQUENCIAL = t4.cd_sequencial    
inner join tipo_pagamento T10 on t1.cd_tipo_pagamento = t10.cd_tipo_pagamento

WHERE isnull(T1.exibir, 1) = 1
	and T1.CD_TIPO_RECEBIMENTO = 0
	and datediff(day,isnull(t1.dt_vencimento_new, t1.dt_vencimento),convert(DATE, getdate())) in (4)
	and t1.TP_ASSOCIADO_EMPRESA = 1
	and isnull([dbo].[FF_LinhaDigitavel](T1.CD_PARCELA),'Erro Busca Parcela')<> 'Erro Busca Parcela'
	and t1.VL_PARCELA>0
	and t10.fl_boleto = 1 
	and t1.cd_tipo_parcela not in (101)

	and T4.tteSequencial < 50 -- Telefone
	and LEN(T4.tustelefone) = 11
	and ISNUMERIC(T4.tustelefone)=1
	and SUBSTRING(T4.tustelefone,3,1) > 7 -- Celular
	and T4.cd_origeminformacao = 5 -- Dependente
	and T4.fl_ativo = 1

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
	
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
--
--20	SMS - 4 Dias Após o Vencimento (CARTÃO DE CRÉDITO)
--
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

insert into tb_Izzy    
(cd_campanha, id_erp_crm, Nome_Prospect, Telefone_Contato_1, Informacao_Adicional_1, cd_centro_custo,  cd_tipo_campanha, Filial)        
	
SELECT 
		20 as cd_campanha,
		T2.cd_associado as id_erp_crm, 
		t2.nm_completo as Nome_Prospect, 
		t4.tusTelefone as Telefone_Contato_1, 
		'Odontocoop:' + left(T2.nm_completo,charindex(' ',T2.nm_completo)-1) + ', seu cartao de credito nao foi debitado, favor entrar em contato. 79 3142-0808.',
		1 as cd_centro_custo,  
		5 as cd_tipo_campanha, 
		'Odontocoop' as Filial

FROM MENSALIDADES t1
inner join ASSOCIADOS T2 on t1.CD_ASSOCIADO_empresa = T2.cd_associado
inner join tb_contato T4 on t2.cd_associado = t4.cd_sequencial    
inner join tipo_pagamento T10 on t1.cd_tipo_pagamento = t10.cd_tipo_pagamento

WHERE isnull(T1.exibir, 1) = 1
	and T1.CD_TIPO_RECEBIMENTO = 0
	and datediff(day,isnull(t1.dt_vencimento_new, t1.dt_vencimento),convert(DATE, getdate())) in (4)
	and t1.TP_ASSOCIADO_EMPRESA = 1
	and isnull([dbo].[FF_LinhaDigitavel](T1.CD_PARCELA),'Erro Busca Parcela')<> 'Erro Busca Parcela'
	and t1.VL_PARCELA>0
	and t10.fl_exige_Dados_cartao = 1
	and t1.cd_tipo_parcela not in (101)

	and T4.tteSequencial < 50 -- Telefone
	and LEN(T4.tustelefone) = 11
	and ISNUMERIC(T4.tustelefone)=1
	and SUBSTRING(T4.tustelefone,3,1) > 7 -- Celular
	and T4.cd_origeminformacao = 1 -- Associado
	and T4.fl_ativo = 1

UNION

SELECT 
		20 as cd_campanha,
		T2.cd_associado as id_erp_crm, 
		t2.nm_completo as Nome_Prospect, 
		t4.tusTelefone as Telefone_Contato_1, 
		'Odontocoop:' + left(T2.nm_completo,charindex(' ',T2.nm_completo)-1) + ', seu cartao de credito nao foi debitado, favor entrar em contato. 79 3142-0808.',
		1 as cd_centro_custo,  
		5 as cd_tipo_campanha, 
		'Odontocoop' as Filial

FROM MENSALIDADES t1
inner join ASSOCIADOS T2 on t1.CD_ASSOCIADO_empresa = T2.cd_associado
inner join DEPENDENTES T3 ON T2.cd_associado = t3.CD_ASSOCIADO
inner join tb_contato T4 on t3.CD_SEQUENCIAL = t4.cd_sequencial    
inner join tipo_pagamento T10 on t1.cd_tipo_pagamento = t10.cd_tipo_pagamento

WHERE isnull(T1.exibir, 1) = 1
	and T1.CD_TIPO_RECEBIMENTO = 0
	and datediff(day,isnull(t1.dt_vencimento_new, t1.dt_vencimento),convert(DATE, getdate())) in (4)
	and t1.TP_ASSOCIADO_EMPRESA = 1
	and isnull([dbo].[FF_LinhaDigitavel](T1.CD_PARCELA),'Erro Busca Parcela')<> 'Erro Busca Parcela'
	and t1.VL_PARCELA>0
	and t10.fl_exige_Dados_cartao = 1
	and t1.cd_tipo_parcela not in (101)

	and T4.tteSequencial < 50 -- Telefone
	and LEN(T4.tustelefone) = 11
	and ISNUMERIC(T4.tustelefone)=1
	and SUBSTRING(T4.tustelefone,3,1) > 7 -- Celular
	and T4.cd_origeminformacao = 5 -- Dependente
	and T4.fl_ativo = 1

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
	







  
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
--- Organizar o Historico 
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

print 'Campanha 04'
Print @@rowcount

-- drop table MensalidadeResumo

-- Apagar registros de quem nao tem telefone informado    
  delete tb_Izzy where Telefone_Contato_1 is null  

update tb_Izzy 
   set tb_Izzy.cd_tipo_campanha = c.cd_tipo_campanha ,
       tb_Izzy.ds_tipo_campanha = tc.ds_tipo_campanha 
  from Campanha as c, tipo_campanha as tc
 where tb_Izzy.cd_campanha = c.cd_campanha and 
       c.cd_tipo_campanha = tc.cd_tipo_campanha 

--update associados 
--   set dt_cobranca = '01/01/2000'
-- where dt_cobranca is null and cd_associado in (select id_erp_crm from tb_izzy)

-- Excluir registros que estao ativos nos BOletos Virtuais 
 Delete from tb_izzy 
  where Numero_Titulo in (
            select a.cd_parcela 
			  from MensalidadesAgrupadas as a, mensalidades as m 
			 where a.cd_parcelaMae = m.CD_PARCELA 
			    and m.DT_VENCIMENTO >= DATEADD(DAY, -isnull((Select top 1 qt_dias_expira_boletovirtual from configuracao),7),CONVERT(date,getdate()))
			)
            */
            return

END
