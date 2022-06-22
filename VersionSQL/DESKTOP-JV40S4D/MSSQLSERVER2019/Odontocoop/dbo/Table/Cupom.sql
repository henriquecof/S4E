/****** Object:  Table [dbo].[Cupom]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Cupom](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CodigoCupom] [varchar](20) NOT NULL,
	[CodigoFilial] [int] NOT NULL,
	[DataCadastro] [datetime] NOT NULL,
	[DataValidade] [datetime] NOT NULL,
	[DataExclusao] [datetime] NULL,
	[cd_sequencial_dep] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Cupom]  WITH CHECK ADD FOREIGN KEY([CodigoFilial])
REFERENCES [dbo].[FILIAL] ([cd_filial])
