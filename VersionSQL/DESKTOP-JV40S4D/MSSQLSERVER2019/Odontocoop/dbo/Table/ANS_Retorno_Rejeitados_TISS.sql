/****** Object:  Table [dbo].[ANS_Retorno_Rejeitados_TISS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ANS_Retorno_Rejeitados_TISS](
	[cd_pk] [int] IDENTITY(1,1) NOT NULL,
	[cd_sequencialLote] [int] NOT NULL,
	[idGuiaPrestador] [varchar](50) NULL,
	[idCampo] [nvarchar](255) NULL,
	[errCod] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[cd_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
