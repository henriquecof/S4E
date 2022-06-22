/****** Object:  Table [dbo].[PlanejamentoOrtodonticoImagens]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PlanejamentoOrtodonticoImagens](
	[poiId] [int] IDENTITY(1,1) NOT NULL,
	[poiArquivo] [varchar](105) NOT NULL,
	[poiDescricao] [varchar](100) NULL,
	[poiDtCadastro] [datetime] NOT NULL,
	[poiDtExclusao] [datetime] NULL,
	[cd_sequencial_dep] [int] NOT NULL,
	[cd_funcionarioDentista] [int] NULL,
	[cd_filial] [int] NULL,
 CONSTRAINT [PK_PlanejamentoOrtodonticoImagens] PRIMARY KEY CLUSTERED 
(
	[poiId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PlanejamentoOrtodonticoImagens]  WITH CHECK ADD  CONSTRAINT [FK_PlanejamentoOrtodonticoImagens_DEPENDENTES] FOREIGN KEY([cd_sequencial_dep])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
ALTER TABLE [dbo].[PlanejamentoOrtodonticoImagens] CHECK CONSTRAINT [FK_PlanejamentoOrtodonticoImagens_DEPENDENTES]
ALTER TABLE [dbo].[PlanejamentoOrtodonticoImagens]  WITH CHECK ADD  CONSTRAINT [FK_PlanejamentoOrtodonticoImagens_FILIAL] FOREIGN KEY([cd_filial])
REFERENCES [dbo].[FILIAL] ([cd_filial])
ALTER TABLE [dbo].[PlanejamentoOrtodonticoImagens] CHECK CONSTRAINT [FK_PlanejamentoOrtodonticoImagens_FILIAL]
