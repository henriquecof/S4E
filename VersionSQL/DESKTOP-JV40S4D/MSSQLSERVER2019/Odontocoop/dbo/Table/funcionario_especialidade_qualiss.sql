/****** Object:  Table [dbo].[funcionario_especialidade_qualiss]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[funcionario_especialidade_qualiss](
	[cd_funcionario] [int] NOT NULL,
	[cd_especialidade] [int] NOT NULL,
	[cd_qualiss] [tinyint] NOT NULL,
 CONSTRAINT [PK_funcionario_especialidade_qualiss] PRIMARY KEY CLUSTERED 
(
	[cd_funcionario] ASC,
	[cd_especialidade] ASC,
	[cd_qualiss] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[funcionario_especialidade_qualiss]  WITH CHECK ADD  CONSTRAINT [FK_funcionario_especialidade_qualiss_ESPECIALIDADE] FOREIGN KEY([cd_especialidade])
REFERENCES [dbo].[ESPECIALIDADE] ([cd_especialidade])
ALTER TABLE [dbo].[funcionario_especialidade_qualiss] CHECK CONSTRAINT [FK_funcionario_especialidade_qualiss_ESPECIALIDADE]
ALTER TABLE [dbo].[funcionario_especialidade_qualiss]  WITH CHECK ADD  CONSTRAINT [FK_funcionario_especialidade_qualiss_qualiss] FOREIGN KEY([cd_qualiss])
REFERENCES [dbo].[qualiss] ([cd_qualiss])
ALTER TABLE [dbo].[funcionario_especialidade_qualiss] CHECK CONSTRAINT [FK_funcionario_especialidade_qualiss_qualiss]
