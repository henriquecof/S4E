/****** Object:  Table [dbo].[valor_hora_dentista_interno]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[valor_hora_dentista_interno](
	[cd_sequencial] [int] NOT NULL,
	[dt_inicio] [datetime] NOT NULL,
	[cd_filial] [int] NOT NULL,
	[cd_especialidade] [int] NULL,
	[cd_funcionario] [int] NULL,
	[vl_hora] [money] NOT NULL,
	[cd_funcionario_inc] [int] NOT NULL,
	[dt_inclusao] [datetime] NOT NULL,
	[cd_funcionario_exc] [int] NULL,
	[dt_exclusao] [datetime] NULL,
 CONSTRAINT [PK_valor_hora_dentista_interno] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[valor_hora_dentista_interno]  WITH NOCHECK ADD  CONSTRAINT [FK_valor_hora_dentista_interno_ESPECIALIDADE] FOREIGN KEY([cd_especialidade])
REFERENCES [dbo].[ESPECIALIDADE] ([cd_especialidade])
ALTER TABLE [dbo].[valor_hora_dentista_interno] CHECK CONSTRAINT [FK_valor_hora_dentista_interno_ESPECIALIDADE]
ALTER TABLE [dbo].[valor_hora_dentista_interno]  WITH NOCHECK ADD  CONSTRAINT [FK_valor_hora_dentista_interno_FILIAL] FOREIGN KEY([cd_filial])
REFERENCES [dbo].[FILIAL] ([cd_filial])
ALTER TABLE [dbo].[valor_hora_dentista_interno] CHECK CONSTRAINT [FK_valor_hora_dentista_interno_FILIAL]
