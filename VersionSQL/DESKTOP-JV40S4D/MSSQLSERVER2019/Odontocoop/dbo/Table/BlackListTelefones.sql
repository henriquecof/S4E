/****** Object:  Table [dbo].[BlackListTelefones]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[BlackListTelefones](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[telefone] [varchar](13) NOT NULL,
	[usuarioCadastro] [int] NOT NULL,
	[dataCadastro] [datetime] NOT NULL,
	[usuarioExclusao] [int] NULL,
	[dataExclusao] [datetime] NULL,
 CONSTRAINT [PK_BlackListTelefones] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[BlackListTelefones]  WITH CHECK ADD  CONSTRAINT [FK_BlackListTelefones_FUNCIONARIO] FOREIGN KEY([usuarioCadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[BlackListTelefones] CHECK CONSTRAINT [FK_BlackListTelefones_FUNCIONARIO]
ALTER TABLE [dbo].[BlackListTelefones]  WITH CHECK ADD  CONSTRAINT [FK_BlackListTelefones_FUNCIONARIO1] FOREIGN KEY([usuarioExclusao])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[BlackListTelefones] CHECK CONSTRAINT [FK_BlackListTelefones_FUNCIONARIO1]
