/****** Object:  Table [dbo].[Banner]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Banner](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[descricao] [varchar](500) NOT NULL,
	[imagem] [varchar](500) NOT NULL,
	[url] [varchar](500) NULL,
	[ativo] [bit] NOT NULL,
	[dataCadastro] [datetime] NOT NULL,
	[cd_funcionarioCadastro] [int] NOT NULL,
	[dataExclusao] [datetime] NULL,
	[cd_funcionarioExclusao] [int] NULL,
	[exibirAssociado] [bit] NULL,
	[exibirClinica] [bit] NULL,
	[exibirColaborador] [bit] NULL,
	[exibirDentista] [bit] NULL,
	[exibirEmpresa] [bit] NULL,
	[exibirCorretorPF] [bit] NULL,
	[exibirCorretorPJ] [bit] NULL,
	[exibirUsuarioNaoIdentificado] [bit] NULL,
	[empresaEspecifica] [varchar](1000) NULL,
	[associadoEmpresaEspecifica] [varchar](1000) NULL,
	[exibeAPP] [bit] NULL,
	[exibeWEB] [bit] NULL,
	[ColaboradoresEspecificos] [varchar](255) NULL,
 CONSTRAINT [PK_Banner] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Banner]  WITH CHECK ADD  CONSTRAINT [FK_Banner_FUNCIONARIO] FOREIGN KEY([cd_funcionarioCadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[Banner] CHECK CONSTRAINT [FK_Banner_FUNCIONARIO]
ALTER TABLE [dbo].[Banner]  WITH CHECK ADD  CONSTRAINT [FK_Banner_FUNCIONARIO1] FOREIGN KEY([cd_funcionarioExclusao])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[Banner] CHECK CONSTRAINT [FK_Banner_FUNCIONARIO1]
