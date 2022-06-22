/****** Object:  Table [dbo].[_CRM_Final]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[_CRM_Final](
	[MOTID] [float] NULL,
	[Motivos] [nvarchar](255) NULL,
	[MDEID] [float] NULL,
	[MotivosDetalhados] [nvarchar](255) NULL,
	[mdeTempoMinutoResposta] [float] NULL,
	[cgrId] [float] NULL,
	[Grupo] [nvarchar](255) NULL,
	[Func] [nvarchar](255) NULL,
	[Clinica] [nvarchar](255) NULL,
	[Dentista] [nvarchar](255) NULL,
	[Empresa] [nvarchar](255) NULL,
	[Associado] [nvarchar](255) NULL,
	[Interno] [nvarchar](255) NULL
) ON [PRIMARY]
