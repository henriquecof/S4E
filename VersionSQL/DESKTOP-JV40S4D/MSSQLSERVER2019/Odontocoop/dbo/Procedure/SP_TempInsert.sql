/****** Object:  Procedure [dbo].[SP_TempInsert]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SP_TempInsert]
@cd_situacao INT,
@dt_situacao datetime,
@fl_iss int,
@cd_empresa_gerais int
AS
insert into [abs]..empresa(
CD_EMPRESA       , NR_CGC,NM_RAZSOC,NM_FANTASIA,TP_EMPRESA,  NM_ENDERECO, NM_BAIRRO,  CD_MUNICIPIO, CD_UF,NR_CEP,NR_FONE1,NR_FONE2,NR_FAX, DT_FECHAMENTO_CONTRATO, NM_CONTATO, dt_vencimento, cd_forma_pagamento,  CD_ORGAO,  CD_VERBA,  cd_situacao,  dt_situacao , cd_grupo, nm_comentario, cd_usuario, dt_usuario, vl_desconto, cd_filial,  Perc_Iss, Perc_Irrf)
select 
CD_EMPRESA_GERAIS, NR_CGC,NM_RAZSOC,NM_FANTASIA,TP_EMPRESA,  NM_ENDERECO, NM_BAIRRO , CD_MUNICIPIO, CD_UF,NR_CEP,NR_FONE1,NR_FONE2,NR_FAX, DT_FECHAMENTO_CONTRATO, NM_CONTATO, dt_vencimento, cd_forma_pagamento,  CD_ORGAO,  CD_VERBA,  @cd_situacao, @dt_situacao, null   ,  NM_COMENTARIO, null      , null      , 0          , 1             ,  @fl_iss  , 0        
from abs1..empresa_gerais where cd_empresa_gerais = @cd_empresa_gerais
