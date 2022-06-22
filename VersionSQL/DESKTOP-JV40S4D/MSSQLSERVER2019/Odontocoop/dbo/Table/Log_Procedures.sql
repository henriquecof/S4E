/****** Object:  Table [dbo].[Log_Procedures]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Log_Procedures](
	[Id_Auditoria] [int] IDENTITY(1,1) NOT NULL,
	[Dt_Evento] [datetime] NOT NULL,
	[Nm_Procedure] [varchar](100) NULL,
	[Nm_Login] [varchar](100) NULL,
	[Ds_Procedure] [varchar](max) NULL,
	[Ds_Alt] [xml] NULL,
	[Ds_Doc] [xml] NULL,
	[Ds_Query] [xml] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

CREATE CLUSTERED INDEX [SK01_Log_Procedures] ON [dbo].[Log_Procedures]
(
	[Id_Auditoria] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
