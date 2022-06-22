/****** Object:  Table [dbo].[Lote_Protocolo_Precadastro]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Lote_Protocolo_Precadastro](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[cd_sequencial_lote] [int] NOT NULL,
	[nomeCompleto] [varchar](60) NOT NULL,
	[dataNascimento] [datetime] NULL,
	[nr_cpf] [varchar](11) NULL,
	[cd_associado] [int] NULL,
	[cd_empresa] [bigint] NOT NULL,
	[dataCadastro] [datetime] NOT NULL,
	[usuarioCadastro] [int] NOT NULL,
	[dataExclusao] [datetime] NULL,
	[usuarioExclusao] [int] NULL,
	[cd_sequencialDep] [int] NULL,
	[observacao] [varchar](500) NULL,
	[dt_venda] [datetime] NULL,
	[cd_adesionista] [int] NULL,
	[cd_vendedor] [int] NULL,
	[cdPlano] [int] NULL,
	[cdPlataforma] [int] NULL,
 CONSTRAINT [PK_Lote_Protocolo_Precadastro] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Lote_Protocolo_Precadastro]  WITH CHECK ADD  CONSTRAINT [FK__Lote_Prot__cd_ad__1D082751] FOREIGN KEY([cd_adesionista])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[Lote_Protocolo_Precadastro] CHECK CONSTRAINT [FK__Lote_Prot__cd_ad__1D082751]
ALTER TABLE [dbo].[Lote_Protocolo_Precadastro]  WITH CHECK ADD  CONSTRAINT [FK__Lote_Prot__cd_ad__38B041C6] FOREIGN KEY([cd_adesionista])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[Lote_Protocolo_Precadastro] CHECK CONSTRAINT [FK__Lote_Prot__cd_ad__38B041C6]
ALTER TABLE [dbo].[Lote_Protocolo_Precadastro]  WITH CHECK ADD  CONSTRAINT [FK__Lote_Prot__cd_ad__61B25759] FOREIGN KEY([cd_adesionista])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[Lote_Protocolo_Precadastro] CHECK CONSTRAINT [FK__Lote_Prot__cd_ad__61B25759]
ALTER TABLE [dbo].[Lote_Protocolo_Precadastro]  WITH CHECK ADD  CONSTRAINT [FK__Lote_Prot__cd_ad__639A9FCB] FOREIGN KEY([cd_adesionista])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[Lote_Protocolo_Precadastro] CHECK CONSTRAINT [FK__Lote_Prot__cd_ad__639A9FCB]
ALTER TABLE [dbo].[Lote_Protocolo_Precadastro]  WITH CHECK ADD  CONSTRAINT [FK__Lote_Prot__cd_ve__1DFC4B8A] FOREIGN KEY([cd_vendedor])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[Lote_Protocolo_Precadastro] CHECK CONSTRAINT [FK__Lote_Prot__cd_ve__1DFC4B8A]
ALTER TABLE [dbo].[Lote_Protocolo_Precadastro]  WITH CHECK ADD  CONSTRAINT [FK__Lote_Prot__cd_ve__39A465FF] FOREIGN KEY([cd_vendedor])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[Lote_Protocolo_Precadastro] CHECK CONSTRAINT [FK__Lote_Prot__cd_ve__39A465FF]
ALTER TABLE [dbo].[Lote_Protocolo_Precadastro]  WITH CHECK ADD  CONSTRAINT [FK__Lote_Prot__cd_ve__62A67B92] FOREIGN KEY([cd_vendedor])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[Lote_Protocolo_Precadastro] CHECK CONSTRAINT [FK__Lote_Prot__cd_ve__62A67B92]
ALTER TABLE [dbo].[Lote_Protocolo_Precadastro]  WITH CHECK ADD  CONSTRAINT [FK__Lote_Prot__cd_ve__648EC404] FOREIGN KEY([cd_vendedor])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[Lote_Protocolo_Precadastro] CHECK CONSTRAINT [FK__Lote_Prot__cd_ve__648EC404]
ALTER TABLE [dbo].[Lote_Protocolo_Precadastro]  WITH CHECK ADD  CONSTRAINT [FK_Lote_Protocolo_Precadastro_ASSOCIADOS] FOREIGN KEY([cd_associado])
REFERENCES [dbo].[ASSOCIADOS] ([cd_associado])
ALTER TABLE [dbo].[Lote_Protocolo_Precadastro] CHECK CONSTRAINT [FK_Lote_Protocolo_Precadastro_ASSOCIADOS]
ALTER TABLE [dbo].[Lote_Protocolo_Precadastro]  WITH CHECK ADD  CONSTRAINT [FK_Lote_Protocolo_Precadastro_DEPENDENTES] FOREIGN KEY([cd_sequencialDep])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
ALTER TABLE [dbo].[Lote_Protocolo_Precadastro] CHECK CONSTRAINT [FK_Lote_Protocolo_Precadastro_DEPENDENTES]
ALTER TABLE [dbo].[Lote_Protocolo_Precadastro]  WITH CHECK ADD  CONSTRAINT [FK_Lote_Protocolo_Precadastro_EMPRESA] FOREIGN KEY([cd_empresa])
REFERENCES [dbo].[EMPRESA] ([CD_EMPRESA])
ALTER TABLE [dbo].[Lote_Protocolo_Precadastro] CHECK CONSTRAINT [FK_Lote_Protocolo_Precadastro_EMPRESA]
ALTER TABLE [dbo].[Lote_Protocolo_Precadastro]  WITH CHECK ADD  CONSTRAINT [FK_Lote_Protocolo_Precadastro_FUNCIONARIO] FOREIGN KEY([usuarioCadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[Lote_Protocolo_Precadastro] CHECK CONSTRAINT [FK_Lote_Protocolo_Precadastro_FUNCIONARIO]
ALTER TABLE [dbo].[Lote_Protocolo_Precadastro]  WITH CHECK ADD  CONSTRAINT [FK_Lote_Protocolo_Precadastro_FUNCIONARIO1] FOREIGN KEY([usuarioExclusao])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[Lote_Protocolo_Precadastro] CHECK CONSTRAINT [FK_Lote_Protocolo_Precadastro_FUNCIONARIO1]
ALTER TABLE [dbo].[Lote_Protocolo_Precadastro]  WITH CHECK ADD  CONSTRAINT [FK_Lote_Protocolo_Precadastro_Planos] FOREIGN KEY([cdPlano])
REFERENCES [dbo].[PLANOS] ([cd_plano])
ALTER TABLE [dbo].[Lote_Protocolo_Precadastro] CHECK CONSTRAINT [FK_Lote_Protocolo_Precadastro_Planos]
