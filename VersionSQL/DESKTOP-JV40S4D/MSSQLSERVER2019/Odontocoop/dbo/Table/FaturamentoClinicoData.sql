/****** Object:  Table [dbo].[FaturamentoClinicoData]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[FaturamentoClinicoData](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[tipoData] [tinyint] NOT NULL,
	[dataOperacao] [date] NOT NULL,
	[dataInicial] [date] NOT NULL,
	[dataFinal] [date] NOT NULL,
	[dataCadastro] [datetime] NOT NULL,
	[cd_funcionarioCadastro] [int] NOT NULL,
	[dataExclusao] [datetime] NULL,
	[cd_funcionarioExclusao] [int] NULL,
 CONSTRAINT [PK_FaturamentoClinicoData] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[FaturamentoClinicoData]  WITH CHECK ADD  CONSTRAINT [FK_FaturamentoClinicoData_FUNCIONARIO] FOREIGN KEY([cd_funcionarioCadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[FaturamentoClinicoData] CHECK CONSTRAINT [FK_FaturamentoClinicoData_FUNCIONARIO]
ALTER TABLE [dbo].[FaturamentoClinicoData]  WITH CHECK ADD  CONSTRAINT [FK_FaturamentoClinicoData_FUNCIONARIO1] FOREIGN KEY([cd_funcionarioExclusao])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[FaturamentoClinicoData] CHECK CONSTRAINT [FK_FaturamentoClinicoData_FUNCIONARIO1]
