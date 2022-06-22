/****** Object:  Procedure [dbo].[SP_GeraCampanha_S4E]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SP_GeraCampanha_S4E]
AS
BEGIN
      SET NOCOUNT ON;
     
	 /*
      delete CampanhaLoteItens
      where cd_campanha_lote in (select cd_campanha_lote from CampanhaLote where datediff(day,dt_cadastro,getdate()) > 7)
      and cd_campanha in (select cd_campanha from Campanha where cd_origem_campanha = 1)
      and chaId is null
     */
	 
      insert into CampanhaLoteItens
      (cd_campanha, ID_ERP_CRM, Nome_Prospect, DtNascimento, CPF_CNPJ, RG_CGF, email, sexo, Logradouro, Complemento, Bairro, cep, cidade, estado, Data_ERP_CRM, Telefone_Contato_1, Telefone_Contato_2, Telefone_Contato_3, Contato_1, Numero_Titulo, Tipo_Titulo, Data_Titulo, Valor_Titulo, Produto, Filial, Dia_Vencimento, Informacao_Adicional_1, Informacao_Adicional_2, Informacao_Adicional_3, Auxiliar_1, Auxiliar_2, Auxiliar_3, Agrupador, Dt_Atendimento, Nm_Funcionario, Nm_Clinica, Cd_empresa, Cd_centro_custo, cd_parcela, cd_sequencial_agenda, dt_ordenacao, cd_sequencial_dep)
      select cd_campanha, ID_ERP_CRM, Nome_Prospect, DtNascimento, CPF_CNPJ, RG_CGF, email, sexo, Logradouro, Complemento, Bairro, cep, cidade, estado, Data_ERP_CRM, Telefone_Contato_1, Telefone_Contato_2, Telefone_Contato_3, Contato_1, Numero_Titulo, Tipo_Titulo, Data_Titulo, Valor_Titulo, Produto, Filial, Dia_Vencimento, Informacao_Adicional_1, Informacao_Adicional_2, Informacao_Adicional_3, Auxiliar_1, Auxiliar_2, Auxiliar_3, Agrupador, Dt_Atendimento, Nm_Funcionario, Nm_Clinica, Cd_empresa, Cd_centro_custo, cd_parcela, cd_sequencial_agenda, dt_ordenacao, cd_sequencial_dep
      from tb_izzy
	  where cd_campanha not in (select cd_campanha from Campanha where cd_tipo_campanha = 6)
END
