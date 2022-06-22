/****** Object:  Table [dbo].[TB_Chamadas]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_Chamadas](
	[CodigoRegistro] [nvarchar](1) NULL,
	[Chamador] [nvarchar](10) NULL,
	[DataChamada] [datetime] NULL,
	[HoraChamada] [nvarchar](8) NULL,
	[Chamado] [nvarchar](50) NULL,
	[Duracao] [nvarchar](9) NULL,
	[Local] [nvarchar](30) NULL,
	[SiglaLocal] [nvarchar](4) NULL,
	[Degrau] [nvarchar](2) NULL,
	[GrupoHora] [nvarchar](1) NULL,
	[Valor] [float] NULL,
	[Tipo] [nvarchar](1) NULL
) ON [PRIMARY]
