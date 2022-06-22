/****** Object:  Table [dbo].[HistoricoResumo]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[HistoricoResumo](
	[pk] [int] IDENTITY(1,1) NOT NULL,
	[cd_sequencial_dep] [int] NULL,
	[dt_inclusao] [date] NULL,
	[dt_exclusao] [date] NULL,
	[fl_tit] [smallint] NULL,
	[fl_emp] [smallint] NULL,
 CONSTRAINT [PK_HistoricoResumo] PRIMARY KEY CLUSTERED 
(
	[pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[HistoricoResumo]  WITH NOCHECK ADD  CONSTRAINT [FK_HistoricoResumo_DEPENDENTES] FOREIGN KEY([cd_sequencial_dep])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
ALTER TABLE [dbo].[HistoricoResumo] CHECK CONSTRAINT [FK_HistoricoResumo_DEPENDENTES]
