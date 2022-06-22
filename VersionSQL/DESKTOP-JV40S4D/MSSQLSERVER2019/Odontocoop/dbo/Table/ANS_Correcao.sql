/****** Object:  Table [dbo].[ANS_Correcao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ANS_Correcao](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[cd_movimento] [smallint] NOT NULL,
	[cd_sequencial_dep] [int] NOT NULL,
 CONSTRAINT [PK_ANS_Correcao] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ANS_Correcao]  WITH NOCHECK ADD  CONSTRAINT [FK_ANS_Correcao_ANS_Movimento] FOREIGN KEY([cd_movimento])
REFERENCES [dbo].[ANS_Movimento] ([cd_movimento])
ALTER TABLE [dbo].[ANS_Correcao] CHECK CONSTRAINT [FK_ANS_Correcao_ANS_Movimento]
ALTER TABLE [dbo].[ANS_Correcao]  WITH NOCHECK ADD  CONSTRAINT [FK_ANS_Correcao_DEPENDENTES] FOREIGN KEY([cd_sequencial_dep])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
ALTER TABLE [dbo].[ANS_Correcao] CHECK CONSTRAINT [FK_ANS_Correcao_DEPENDENTES]
