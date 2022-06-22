/****** Object:  Table [dbo].[ArquivoFuncionario]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ArquivoFuncionario](
	[afuId] [int] IDENTITY(1,1) NOT NULL,
	[cd_funcionario] [int] NOT NULL,
	[CD_UsuarioInclusao] [int] NULL,
	[afuDtInclusao] [datetime] NULL,
	[CD_UsuarioExclusao] [int] NULL,
	[afuDtExclusao] [datetime] NULL,
	[afuNome] [varchar](50) NOT NULL,
	[afuExtensao] [varchar](5) NOT NULL,
 CONSTRAINT [PK_ArquivoFuncionario] PRIMARY KEY CLUSTERED 
(
	[afuId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ArquivoFuncionario]  WITH CHECK ADD  CONSTRAINT [FK_ArquivoFuncionario] FOREIGN KEY([cd_funcionario])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[ArquivoFuncionario] CHECK CONSTRAINT [FK_ArquivoFuncionario]
ALTER TABLE [dbo].[ArquivoFuncionario]  WITH CHECK ADD  CONSTRAINT [FK_ArquivoFuncionario1] FOREIGN KEY([CD_UsuarioInclusao])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[ArquivoFuncionario] CHECK CONSTRAINT [FK_ArquivoFuncionario1]
