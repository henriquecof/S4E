/****** Object:  Table [dbo].[AtendimentoRestricao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[AtendimentoRestricao](
	[cdAtendimentoRestricao] [int] IDENTITY(1,1) NOT NULL,
	[cdDependente] [int] NULL,
	[cdEmpresa] [int] NULL,
	[cdFilial] [int] NULL,
	[cdColaborador] [int] NULL,
	[cdMunicipio] [int] NULL,
	[ufId] [smallint] NULL,
	[cdUsuarioCadastro] [int] NULL,
	[dataCadastro] [datetime] NULL,
	[cdUsuarioExclusao] [int] NULL,
	[dataExclusao] [datetime] NULL,
 CONSTRAINT [PK_AtendimentoRestricao] PRIMARY KEY CLUSTERED 
(
	[cdAtendimentoRestricao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[AtendimentoRestricao]  WITH CHECK ADD  CONSTRAINT [FK_AtendimentoRestricao_DEPENDENTES] FOREIGN KEY([cdDependente])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
ALTER TABLE [dbo].[AtendimentoRestricao] CHECK CONSTRAINT [FK_AtendimentoRestricao_DEPENDENTES]
ALTER TABLE [dbo].[AtendimentoRestricao]  WITH CHECK ADD  CONSTRAINT [FK_AtendimentoRestricao_FILIAL] FOREIGN KEY([cdFilial])
REFERENCES [dbo].[FILIAL] ([cd_filial])
ALTER TABLE [dbo].[AtendimentoRestricao] CHECK CONSTRAINT [FK_AtendimentoRestricao_FILIAL]
ALTER TABLE [dbo].[AtendimentoRestricao]  WITH CHECK ADD  CONSTRAINT [FK_AtendimentoRestricao_MUNICIPIO] FOREIGN KEY([cdMunicipio])
REFERENCES [dbo].[MUNICIPIO] ([CD_MUNICIPIO])
ALTER TABLE [dbo].[AtendimentoRestricao] CHECK CONSTRAINT [FK_AtendimentoRestricao_MUNICIPIO]
ALTER TABLE [dbo].[AtendimentoRestricao]  WITH CHECK ADD  CONSTRAINT [FK_AtendimentoRestricao_UF] FOREIGN KEY([ufId])
REFERENCES [dbo].[UF] ([ufId])
ALTER TABLE [dbo].[AtendimentoRestricao] CHECK CONSTRAINT [FK_AtendimentoRestricao_UF]
