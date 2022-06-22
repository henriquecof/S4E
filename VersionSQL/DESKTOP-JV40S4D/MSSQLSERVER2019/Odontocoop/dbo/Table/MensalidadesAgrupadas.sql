/****** Object:  Table [dbo].[MensalidadesAgrupadas]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[MensalidadesAgrupadas](
	[cd_parcelaMae] [int] NOT NULL,
	[cd_parcela] [int] NOT NULL,
	[fl_boletoAnual] [bit] NULL,
	[registrado] [bit] NULL,
 CONSTRAINT [PK_MensalidadesAgrupadas] PRIMARY KEY CLUSTERED 
(
	[cd_parcelaMae] ASC,
	[cd_parcela] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
