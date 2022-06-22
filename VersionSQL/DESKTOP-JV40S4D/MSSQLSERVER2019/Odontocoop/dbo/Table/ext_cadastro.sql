/****** Object:  Table [dbo].[ext_cadastro]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ext_cadastro](
	[id_ext_cadastro] [int] IDENTITY(1,1) NOT NULL,
	[id_ext_dado] [int] NOT NULL,
	[nome] [varchar](255) NULL,
	[data_nasc] [date] NULL,
	[sexo] [char](1) NULL,
	[mae] [varchar](255) NULL,
 CONSTRAINT [ext_cadastro_1_3] PRIMARY KEY CLUSTERED 
(
	[id_ext_cadastro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ext_cadastro]  WITH CHECK ADD  CONSTRAINT [ext_cadastro_ext_dado] FOREIGN KEY([id_ext_dado])
REFERENCES [dbo].[ext_dado] ([id_ext_dado])
ALTER TABLE [dbo].[ext_cadastro] CHECK CONSTRAINT [ext_cadastro_ext_dado]
