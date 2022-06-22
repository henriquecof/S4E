/****** Object:  Table [dbo].[categoriaANS_Servico]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[categoriaANS_Servico](
	[cd_categoria_ans] [smallint] NOT NULL,
	[cd_servico] [int] NOT NULL,
 CONSTRAINT [PK_categoriaANS_Servico] PRIMARY KEY CLUSTERED 
(
	[cd_categoria_ans] ASC,
	[cd_servico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[categoriaANS_Servico]  WITH NOCHECK ADD  CONSTRAINT [FK_categoriaANS_Servico_Categoria_Ans] FOREIGN KEY([cd_categoria_ans])
REFERENCES [dbo].[Categoria_Ans] ([cd_categoria_ans])
ALTER TABLE [dbo].[categoriaANS_Servico] CHECK CONSTRAINT [FK_categoriaANS_Servico_Categoria_Ans]
ALTER TABLE [dbo].[categoriaANS_Servico]  WITH NOCHECK ADD  CONSTRAINT [FK_categoriaANS_Servico_SERVICO] FOREIGN KEY([cd_servico])
REFERENCES [dbo].[SERVICO] ([CD_SERVICO])
ALTER TABLE [dbo].[categoriaANS_Servico] CHECK CONSTRAINT [FK_categoriaANS_Servico_SERVICO]
