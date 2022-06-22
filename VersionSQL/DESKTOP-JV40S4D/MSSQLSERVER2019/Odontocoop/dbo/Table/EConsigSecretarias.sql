/****** Object:  Table [dbo].[EConsigSecretarias]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EConsigSecretarias](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[codigo] [varchar](50) NULL,
	[nome] [varchar](150) NULL,
	[funcionarioCadastro] [int] NULL,
	[dataCadastro] [datetime] NULL,
 CONSTRAINT [PK_EConsigSecretarias] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[EConsigSecretarias]  WITH CHECK ADD  CONSTRAINT [FK_EConsigSecretarias_FUNCIONARIO1] FOREIGN KEY([funcionarioCadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[EConsigSecretarias] CHECK CONSTRAINT [FK_EConsigSecretarias_FUNCIONARIO1]
