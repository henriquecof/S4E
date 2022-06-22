/****** Object:  Table [dbo].[Tipo_Documentos]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Tipo_Documentos](
	[Cd_Documento] [int] IDENTITY(1,1) NOT NULL,
	[Nm_Documento] [varchar](20) NOT NULL,
	[Abv_documento] [varchar](5) NOT NULL,
	[Fl_DocAtivo] [bit] NOT NULL,
	[Fl_Associado] [bit] NOT NULL,
 CONSTRAINT [PK_Tipo_Documentos] PRIMARY KEY CLUSTERED 
(
	[Cd_Documento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Tipo_Documentos] ADD  CONSTRAINT [DF_Tipo_Documentos_DocAtivo]  DEFAULT ((1)) FOR [Fl_DocAtivo]
ALTER TABLE [dbo].[Tipo_Documentos] ADD  CONSTRAINT [DF_Tipo_Documentos_Fl_Associado]  DEFAULT ((1)) FOR [Fl_Associado]
