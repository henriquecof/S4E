/****** Object:  Table [dbo].[ServicoRegiaoBoca]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ServicoRegiaoBoca](
	[cd_servico] [int] NOT NULL,
	[rboId] [tinyint] NOT NULL,
 CONSTRAINT [PK_ServicoRegiaoBoca] PRIMARY KEY CLUSTERED 
(
	[cd_servico] ASC,
	[rboId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ServicoRegiaoBoca]  WITH CHECK ADD  CONSTRAINT [FK_ServicoRegiaoBoca_RegiaoBoca] FOREIGN KEY([rboId])
REFERENCES [dbo].[RegiaoBoca] ([rboId])
ALTER TABLE [dbo].[ServicoRegiaoBoca] CHECK CONSTRAINT [FK_ServicoRegiaoBoca_RegiaoBoca]
ALTER TABLE [dbo].[ServicoRegiaoBoca]  WITH CHECK ADD  CONSTRAINT [FK_ServicoRegiaoBoca_SERVICO] FOREIGN KEY([cd_servico])
REFERENCES [dbo].[SERVICO] ([CD_SERVICO])
ALTER TABLE [dbo].[ServicoRegiaoBoca] CHECK CONSTRAINT [FK_ServicoRegiaoBoca_SERVICO]
