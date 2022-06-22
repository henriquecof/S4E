/****** Object:  Table [dbo].[permissao_motivocancelamento]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[permissao_motivocancelamento](
	[cd_funcionario] [int] NOT NULL,
	[cd_motivo_cancelamento] [int] NOT NULL,
 CONSTRAINT [PK_permissao_motivocancelamento] PRIMARY KEY CLUSTERED 
(
	[cd_funcionario] ASC,
	[cd_motivo_cancelamento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[permissao_motivocancelamento]  WITH NOCHECK ADD  CONSTRAINT [FK_permissao_motivocancelamento_MOTIVO_CANCELAMENTO] FOREIGN KEY([cd_motivo_cancelamento])
REFERENCES [dbo].[MOTIVO_CANCELAMENTO] ([cd_motivo_cancelamento])
ALTER TABLE [dbo].[permissao_motivocancelamento] CHECK CONSTRAINT [FK_permissao_motivocancelamento_MOTIVO_CANCELAMENTO]
