/****** Object:  Table [dbo].[tipo_preco]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tipo_preco](
	[cd_tipo_preco] [int] NOT NULL,
	[ds_tipo_preco] [varchar](50) NULL,
 CONSTRAINT [PK_tipo_preco] PRIMARY KEY CLUSTERED 
(
	[cd_tipo_preco] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tipo_preco]  WITH CHECK ADD  CONSTRAINT [FK_tipo_preco_tipo_preco] FOREIGN KEY([cd_tipo_preco])
REFERENCES [dbo].[tipo_preco] ([cd_tipo_preco])
ALTER TABLE [dbo].[tipo_preco] CHECK CONSTRAINT [FK_tipo_preco_tipo_preco]
