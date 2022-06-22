/****** Object:  Table [dbo].[EspecialidadeCorrelacionada]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EspecialidadeCorrelacionada](
	[cd_especialidade1] [int] NOT NULL,
	[cd_especialidade2] [int] NOT NULL,
 CONSTRAINT [PK_EspecialidadeCorrelacionada] PRIMARY KEY CLUSTERED 
(
	[cd_especialidade1] ASC,
	[cd_especialidade2] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[EspecialidadeCorrelacionada]  WITH CHECK ADD  CONSTRAINT [FK_EspecialidadeCorrelacionada_ESPECIALIDADE] FOREIGN KEY([cd_especialidade1])
REFERENCES [dbo].[ESPECIALIDADE] ([cd_especialidade])
ALTER TABLE [dbo].[EspecialidadeCorrelacionada] CHECK CONSTRAINT [FK_EspecialidadeCorrelacionada_ESPECIALIDADE]
ALTER TABLE [dbo].[EspecialidadeCorrelacionada]  WITH CHECK ADD  CONSTRAINT [FK_EspecialidadeCorrelacionada_ESPECIALIDADE1] FOREIGN KEY([cd_especialidade2])
REFERENCES [dbo].[ESPECIALIDADE] ([cd_especialidade])
ALTER TABLE [dbo].[EspecialidadeCorrelacionada] CHECK CONSTRAINT [FK_EspecialidadeCorrelacionada_ESPECIALIDADE1]
