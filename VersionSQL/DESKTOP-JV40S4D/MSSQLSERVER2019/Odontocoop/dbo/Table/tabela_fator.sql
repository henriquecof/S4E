/****** Object:  Table [dbo].[tabela_fator]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tabela_fator](
	[cd_tabela_fator] [int] IDENTITY(1,1) NOT NULL,
	[cd_funcionario] [int] NULL,
	[cd_filial] [int] NULL,
	[valor] [money] NOT NULL,
	[tipoValor] [tinyint] NOT NULL,
	[cd_servico] [int] NULL,
	[cd_especialidade] [int] NULL,
	[cd_plano] [smallint] NULL,
	[dataInicial] [date] NOT NULL,
	[dataFinal] [date] NULL,
	[cd_tabela_fatorInativo] [int] NULL,
	[dataCadastro] [datetime] NULL,
	[cd_funcionarioCadastro] [int] NULL,
	[dataExclusao] [datetime] NULL,
	[cd_funcionarioExclusao] [int] NULL,
	[DescontoPorcentagem] [decimal](18, 0) NULL,
 CONSTRAINT [PK_tabela_fator] PRIMARY KEY CLUSTERED 
(
	[cd_tabela_fator] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tabela_fator]  WITH CHECK ADD  CONSTRAINT [FK_tabela_fator_ESPECIALIDADE] FOREIGN KEY([cd_especialidade])
REFERENCES [dbo].[ESPECIALIDADE] ([cd_especialidade])
ALTER TABLE [dbo].[tabela_fator] CHECK CONSTRAINT [FK_tabela_fator_ESPECIALIDADE]
ALTER TABLE [dbo].[tabela_fator]  WITH CHECK ADD  CONSTRAINT [FK_tabela_fator_FILIAL] FOREIGN KEY([cd_filial])
REFERENCES [dbo].[FILIAL] ([cd_filial])
ALTER TABLE [dbo].[tabela_fator] CHECK CONSTRAINT [FK_tabela_fator_FILIAL]
ALTER TABLE [dbo].[tabela_fator]  WITH CHECK ADD  CONSTRAINT [FK_tabela_fator_SERVICO] FOREIGN KEY([cd_servico])
REFERENCES [dbo].[SERVICO] ([CD_SERVICO])
ALTER TABLE [dbo].[tabela_fator] CHECK CONSTRAINT [FK_tabela_fator_SERVICO]
