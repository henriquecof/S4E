/****** Object:  Table [dbo].[PNL_PainelFila_LocalAtendimento]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PNL_PainelFila_LocalAtendimento](
	[cd_sequencial] [int] IDENTITY(1,1) NOT NULL,
	[cd_PainelFila] [int] NULL,
	[cd_LocalAtendimento] [int] NULL,
	[cd_funcionario] [int] NULL,
 CONSTRAINT [PK_PNL_PainelFila_LocalAtendimento] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PNL_PainelFila_LocalAtendimento]  WITH CHECK ADD  CONSTRAINT [FK_PNL_PainelFila_LocalAtendimento_PNL_LocalAtendimento] FOREIGN KEY([cd_LocalAtendimento])
REFERENCES [dbo].[PNL_LocalAtendimento] ([cd_LocalAtendimento])
ALTER TABLE [dbo].[PNL_PainelFila_LocalAtendimento] CHECK CONSTRAINT [FK_PNL_PainelFila_LocalAtendimento_PNL_LocalAtendimento]
ALTER TABLE [dbo].[PNL_PainelFila_LocalAtendimento]  WITH CHECK ADD  CONSTRAINT [FK_PNL_PainelFila_LocalAtendimento_PNL_PainelFila] FOREIGN KEY([cd_PainelFila])
REFERENCES [dbo].[PNL_PainelFila] ([cd_PainelFila])
ALTER TABLE [dbo].[PNL_PainelFila_LocalAtendimento] CHECK CONSTRAINT [FK_PNL_PainelFila_LocalAtendimento_PNL_PainelFila]
