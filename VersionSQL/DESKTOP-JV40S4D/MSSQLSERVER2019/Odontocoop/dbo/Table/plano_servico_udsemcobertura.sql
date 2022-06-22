/****** Object:  Table [dbo].[plano_servico_udsemcobertura]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[plano_servico_udsemcobertura](
	[cd_plano] [int] NOT NULL,
	[cd_servico] [int] NOT NULL,
	[cd_ud] [smallint] NOT NULL,
 CONSTRAINT [PK_plano_servico_udsemcobertura] PRIMARY KEY CLUSTERED 
(
	[cd_plano] ASC,
	[cd_servico] ASC,
	[cd_ud] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[plano_servico_udsemcobertura]  WITH CHECK ADD  CONSTRAINT [FK_plano_servico_udsemcobertura_PLANO_SERVICO] FOREIGN KEY([cd_plano], [cd_servico])
REFERENCES [dbo].[PLANO_SERVICO] ([cd_plano], [cd_servico])
ALTER TABLE [dbo].[plano_servico_udsemcobertura] CHECK CONSTRAINT [FK_plano_servico_udsemcobertura_PLANO_SERVICO]
