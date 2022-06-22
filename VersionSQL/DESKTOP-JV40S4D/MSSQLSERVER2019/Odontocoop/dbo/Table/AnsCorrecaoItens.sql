/****** Object:  Table [dbo].[AnsCorrecaoItens]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[AnsCorrecaoItens](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idCorrecao] [int] NOT NULL,
	[sequencialDependente] [int] NULL,
	[cco] [varchar](12) NULL,
	[obs] [varchar](255) NULL,
	[visualizado] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[AnsCorrecaoItens]  WITH CHECK ADD  CONSTRAINT [FK_AnsCorrecao_id] FOREIGN KEY([idCorrecao])
REFERENCES [dbo].[AnsCorrecao] ([id])
ALTER TABLE [dbo].[AnsCorrecaoItens] CHECK CONSTRAINT [FK_AnsCorrecao_id]
ALTER TABLE [dbo].[AnsCorrecaoItens]  WITH CHECK ADD  CONSTRAINT [FK_DEPENDENTES_cd_sequencial] FOREIGN KEY([sequencialDependente])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
ALTER TABLE [dbo].[AnsCorrecaoItens] CHECK CONSTRAINT [FK_DEPENDENTES_cd_sequencial]
