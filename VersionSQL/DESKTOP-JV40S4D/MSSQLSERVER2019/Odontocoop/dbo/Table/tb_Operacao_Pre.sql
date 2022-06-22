/****** Object:  Table [dbo].[tb_Operacao_Pre]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tb_Operacao_Pre](
	[cd_sequencial_dep] [int] NOT NULL,
	[dt_operacao] [datetime] NULL,
 CONSTRAINT [PK_tb_Operacao_Pre] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial_dep] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tb_Operacao_Pre]  WITH NOCHECK ADD  CONSTRAINT [FK_tb_Operacao_Pre_DEPENDENTES] FOREIGN KEY([cd_sequencial_dep])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
ALTER TABLE [dbo].[tb_Operacao_Pre] CHECK CONSTRAINT [FK_tb_Operacao_Pre_DEPENDENTES]
