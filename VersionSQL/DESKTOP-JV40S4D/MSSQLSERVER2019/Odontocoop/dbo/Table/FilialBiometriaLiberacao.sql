/****** Object:  Table [dbo].[FilialBiometriaLiberacao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[FilialBiometriaLiberacao](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[cd_filial] [int] NOT NULL,
	[dt_inicio] [datetime] NOT NULL,
	[dt_fim] [datetime] NOT NULL,
	[cd_funcionario_cadastro] [int] NOT NULL,
	[cd_funcionario_exclusao] [int] NULL,
	[dt_cadastro] [datetime] NOT NULL,
	[dt_exclusao] [datetime] NULL,
 CONSTRAINT [PK_FilialBiometriaLiberacao] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[FilialBiometriaLiberacao]  WITH CHECK ADD  CONSTRAINT [FK_FilialBiometriaLiberacao_FILIAL] FOREIGN KEY([cd_filial])
REFERENCES [dbo].[FILIAL] ([cd_filial])
ALTER TABLE [dbo].[FilialBiometriaLiberacao] CHECK CONSTRAINT [FK_FilialBiometriaLiberacao_FILIAL]
