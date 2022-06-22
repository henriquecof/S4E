/****** Object:  Table [dbo].[ext_contato]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ext_contato](
	[id_ext_contato] [int] IDENTITY(1,1) NOT NULL,
	[id_ext_cadastro] [int] NOT NULL,
	[id_ext_tipo_contato] [int] NOT NULL,
	[contato] [varchar](255) NOT NULL,
 CONSTRAINT [ext_contato_1_3] PRIMARY KEY CLUSTERED 
(
	[id_ext_contato] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ext_contato]  WITH CHECK ADD  CONSTRAINT [ext_contato_ext_cadastro] FOREIGN KEY([id_ext_cadastro])
REFERENCES [dbo].[ext_cadastro] ([id_ext_cadastro])
ALTER TABLE [dbo].[ext_contato] CHECK CONSTRAINT [ext_contato_ext_cadastro]
ALTER TABLE [dbo].[ext_contato]  WITH CHECK ADD  CONSTRAINT [ext_contato_ext_tipo_contato] FOREIGN KEY([id_ext_tipo_contato])
REFERENCES [dbo].[ext_tipo_contato] ([id_ext_tipo_contato])
ALTER TABLE [dbo].[ext_contato] CHECK CONSTRAINT [ext_contato_ext_tipo_contato]
