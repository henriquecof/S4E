/****** Object:  Table [dbo].[Tipo_Clinica]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Tipo_Clinica](
	[cd_tipoClinica] [smallint] IDENTITY(1,1) NOT NULL,
	[ds_tipoClinica] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Tipo_Clinica] PRIMARY KEY CLUSTERED 
(
	[cd_tipoClinica] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
