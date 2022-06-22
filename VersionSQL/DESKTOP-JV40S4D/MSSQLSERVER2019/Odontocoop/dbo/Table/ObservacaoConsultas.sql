/****** Object:  Table [dbo].[ObservacaoConsultas]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ObservacaoConsultas](
	[obcId] [int] IDENTITY(1,1) NOT NULL,
	[cd_sequencial_consulta] [int] NOT NULL,
	[obcDtCadastro] [datetime] NOT NULL,
	[cd_funcionarioCadastro] [int] NOT NULL,
	[obcDtExclusao] [datetime] NULL,
	[cd_funcionarioExclusao] [int] NULL,
	[obcObservacao] [varchar](1000) NULL,
 CONSTRAINT [PK_ObservacaoConsultas] PRIMARY KEY CLUSTERED 
(
	[obcId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ObservacaoConsultas]  WITH CHECK ADD  CONSTRAINT [FK_ObservacaoConsultas_Consultas] FOREIGN KEY([cd_sequencial_consulta])
REFERENCES [dbo].[Consultas] ([cd_sequencial])
ALTER TABLE [dbo].[ObservacaoConsultas] CHECK CONSTRAINT [FK_ObservacaoConsultas_Consultas]
ALTER TABLE [dbo].[ObservacaoConsultas]  WITH CHECK ADD  CONSTRAINT [FK_ObservacaoConsultas_FUNCIONARIO] FOREIGN KEY([cd_funcionarioCadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[ObservacaoConsultas] CHECK CONSTRAINT [FK_ObservacaoConsultas_FUNCIONARIO]
ALTER TABLE [dbo].[ObservacaoConsultas]  WITH CHECK ADD  CONSTRAINT [FK_ObservacaoConsultas_FUNCIONARIO1] FOREIGN KEY([cd_funcionarioExclusao])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[ObservacaoConsultas] CHECK CONSTRAINT [FK_ObservacaoConsultas_FUNCIONARIO1]
