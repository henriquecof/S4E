/****** Object:  Table [dbo].[TB_AcessoIP_Funcionario]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_AcessoIP_Funcionario](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[cd_funcionario] [int] NOT NULL,
	[cd_sequencial_acesso] [int] NOT NULL,
 CONSTRAINT [PK_TB_AcessoIP_Funcionario] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TB_AcessoIP_Funcionario]  WITH CHECK ADD  CONSTRAINT [FK_TB_AcessoIP_Funcionario_TB_AcessoIP] FOREIGN KEY([cd_sequencial_acesso])
REFERENCES [dbo].[TB_AcessoIP] ([id])
ALTER TABLE [dbo].[TB_AcessoIP_Funcionario] CHECK CONSTRAINT [FK_TB_AcessoIP_Funcionario_TB_AcessoIP]
