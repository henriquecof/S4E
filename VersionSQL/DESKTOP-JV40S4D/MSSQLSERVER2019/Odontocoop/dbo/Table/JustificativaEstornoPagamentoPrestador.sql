/****** Object:  Table [dbo].[JustificativaEstornoPagamentoPrestador]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[JustificativaEstornoPagamentoPrestador](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[descricao] [varchar](100) NOT NULL,
	[texto] [varchar](500) NOT NULL,
	[dataCadastro] [datetime] NOT NULL,
	[cd_funcionarioCadastro] [int] NOT NULL,
	[dataExclusao] [datetime] NULL,
	[cd_funcionarioExclusao] [int] NULL,
 CONSTRAINT [PK_JustificativaEstornoPagamentoPrestador] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[JustificativaEstornoPagamentoPrestador]  WITH CHECK ADD  CONSTRAINT [FK_JustificativaEstornoPagamentoPrestador_FUNCIONARIO] FOREIGN KEY([cd_funcionarioCadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[JustificativaEstornoPagamentoPrestador] CHECK CONSTRAINT [FK_JustificativaEstornoPagamentoPrestador_FUNCIONARIO]
ALTER TABLE [dbo].[JustificativaEstornoPagamentoPrestador]  WITH CHECK ADD  CONSTRAINT [FK_JustificativaEstornoPagamentoPrestador_FUNCIONARIO1] FOREIGN KEY([cd_funcionarioExclusao])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[JustificativaEstornoPagamentoPrestador] CHECK CONSTRAINT [FK_JustificativaEstornoPagamentoPrestador_FUNCIONARIO1]
