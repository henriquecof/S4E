/****** Object:  Table [dbo].[ProcedimentoLiberadoPrestador]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ProcedimentoLiberadoPrestador](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[cd_servico] [int] NULL,
	[cd_especialidade] [int] NULL,
	[procedimentoPendente] [bit] NULL,
	[procedimentoRealizado] [bit] NULL,
	[cd_funcionarioDentista] [int] NULL,
	[cd_filial] [int] NULL,
	[cd_funcionarioCadastro] [int] NOT NULL,
	[dataCadastro] [datetime] NOT NULL,
	[cd_funcionarioExclusao] [int] NULL,
	[dataExclusao] [datetime] NULL,
 CONSTRAINT [PK_ProcedimentoLiberadoPrestador] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ProcedimentoLiberadoPrestador]  WITH CHECK ADD  CONSTRAINT [FK_ProcedimentoLiberadoPrestador_ESPECIALIDADE] FOREIGN KEY([cd_especialidade])
REFERENCES [dbo].[ESPECIALIDADE] ([cd_especialidade])
ALTER TABLE [dbo].[ProcedimentoLiberadoPrestador] CHECK CONSTRAINT [FK_ProcedimentoLiberadoPrestador_ESPECIALIDADE]
ALTER TABLE [dbo].[ProcedimentoLiberadoPrestador]  WITH CHECK ADD  CONSTRAINT [FK_ProcedimentoLiberadoPrestador_FILIAL] FOREIGN KEY([cd_filial])
REFERENCES [dbo].[FILIAL] ([cd_filial])
ALTER TABLE [dbo].[ProcedimentoLiberadoPrestador] CHECK CONSTRAINT [FK_ProcedimentoLiberadoPrestador_FILIAL]
ALTER TABLE [dbo].[ProcedimentoLiberadoPrestador]  WITH CHECK ADD  CONSTRAINT [FK_ProcedimentoLiberadoPrestador_SERVICO] FOREIGN KEY([cd_servico])
REFERENCES [dbo].[SERVICO] ([CD_SERVICO])
ALTER TABLE [dbo].[ProcedimentoLiberadoPrestador] CHECK CONSTRAINT [FK_ProcedimentoLiberadoPrestador_SERVICO]
