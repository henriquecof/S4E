/****** Object:  Table [dbo].[PlanejamentoOrtodonticoRelatorio]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PlanejamentoOrtodonticoRelatorio](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[cd_sequencial_dep] [int] NOT NULL,
	[dataCadastro] [datetime] NOT NULL,
	[cd_funcionarioCadastro] [int] NOT NULL,
	[cd_funcionarioDentista] [int] NOT NULL,
	[cd_filial] [int] NOT NULL,
	[procedimentosA] [varchar](max) NULL,
	[procedimentosB] [varchar](max) NULL,
 CONSTRAINT [PK_PlanejamentoOrtodonticoRelatorio] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[PlanejamentoOrtodonticoRelatorio]  WITH CHECK ADD  CONSTRAINT [FK_PlanejamentoOrtodonticoRelatorio_DEPENDENTES] FOREIGN KEY([cd_sequencial_dep])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
ALTER TABLE [dbo].[PlanejamentoOrtodonticoRelatorio] CHECK CONSTRAINT [FK_PlanejamentoOrtodonticoRelatorio_DEPENDENTES]
ALTER TABLE [dbo].[PlanejamentoOrtodonticoRelatorio]  WITH CHECK ADD  CONSTRAINT [FK_PlanejamentoOrtodonticoRelatorio_FILIAL] FOREIGN KEY([cd_filial])
REFERENCES [dbo].[FILIAL] ([cd_filial])
ALTER TABLE [dbo].[PlanejamentoOrtodonticoRelatorio] CHECK CONSTRAINT [FK_PlanejamentoOrtodonticoRelatorio_FILIAL]
