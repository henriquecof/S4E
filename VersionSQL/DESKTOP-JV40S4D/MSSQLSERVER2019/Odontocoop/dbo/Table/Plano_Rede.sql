/****** Object:  Table [dbo].[Plano_Rede]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Plano_Rede](
	[cd_sequencial] [int] IDENTITY(1,1) NOT NULL,
	[cd_plano] [smallint] NOT NULL,
	[cd_filial] [int] NOT NULL,
	[cd_especialidade] [int] NULL,
 CONSTRAINT [PK_Plano_Rede] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Plano_Rede]  WITH CHECK ADD  CONSTRAINT [FK_Plano_Rede_ESPECIALIDADE] FOREIGN KEY([cd_especialidade])
REFERENCES [dbo].[ESPECIALIDADE] ([cd_especialidade])
ALTER TABLE [dbo].[Plano_Rede] CHECK CONSTRAINT [FK_Plano_Rede_ESPECIALIDADE]
ALTER TABLE [dbo].[Plano_Rede]  WITH CHECK ADD  CONSTRAINT [FK_Plano_Rede_FILIAL] FOREIGN KEY([cd_filial])
REFERENCES [dbo].[FILIAL] ([cd_filial])
ALTER TABLE [dbo].[Plano_Rede] CHECK CONSTRAINT [FK_Plano_Rede_FILIAL]
