/****** Object:  Table [dbo].[CorretorAdesionista]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CorretorAdesionista](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idAdesionista] [int] NULL,
	[idCorretor] [int] NULL,
 CONSTRAINT [PK_CorretorAdesionista_3] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CorretorAdesionista]  WITH CHECK ADD  CONSTRAINT [FK_CorretorAdesionista_FUNCIONARIO1] FOREIGN KEY([idAdesionista])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[CorretorAdesionista] CHECK CONSTRAINT [FK_CorretorAdesionista_FUNCIONARIO1]
ALTER TABLE [dbo].[CorretorAdesionista]  WITH CHECK ADD  CONSTRAINT [FK_CorretorAdesionista1_FUNCIONARIO2] FOREIGN KEY([idCorretor])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[CorretorAdesionista] CHECK CONSTRAINT [FK_CorretorAdesionista1_FUNCIONARIO2]
