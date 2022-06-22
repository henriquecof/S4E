/****** Object:  Table [dbo].[TextoContratos]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TextoContratos](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[descricao] [varchar](100) NULL,
	[textoHTML] [varchar](max) NOT NULL,
	[origemInformacao] [int] NULL,
 CONSTRAINT [PK_TextoContratos] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[TextoContratos]  WITH CHECK ADD  CONSTRAINT [FK_TextoContratos_TB_OrigemInformacao] FOREIGN KEY([origemInformacao])
REFERENCES [dbo].[TB_OrigemInformacao] ([cd_origeminformacao])
ALTER TABLE [dbo].[TextoContratos] CHECK CONSTRAINT [FK_TextoContratos_TB_OrigemInformacao]
