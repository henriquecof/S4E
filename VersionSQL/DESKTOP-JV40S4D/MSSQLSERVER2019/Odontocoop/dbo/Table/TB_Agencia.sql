/****** Object:  Table [dbo].[TB_Agencia]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_Agencia](
	[Sequencial_Agencia] [int] IDENTITY(1,1) NOT NULL,
	[Sequencial_Banco] [int] NOT NULL,
	[Codigo_Agencia] [varchar](20) NOT NULL,
	[Nome_Agencia] [varchar](80) NOT NULL,
	[nome_usuario] [varchar](20) NULL,
 CONSTRAINT [PK_TB_Agencia] PRIMARY KEY CLUSTERED 
(
	[Sequencial_Agencia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

SET ANSI_PADDING ON

CREATE UNIQUE NONCLUSTERED INDEX [IX_TB_Agencia] ON [dbo].[TB_Agencia]
(
	[Codigo_Agencia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[TB_Agencia]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_Agencia_TB_Banco] FOREIGN KEY([Sequencial_Banco])
REFERENCES [dbo].[TB_Banco] ([Sequencial_Banco])
ALTER TABLE [dbo].[TB_Agencia] CHECK CONSTRAINT [FK_TB_Agencia_TB_Banco]
