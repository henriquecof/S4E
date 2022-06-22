/****** Object:  Table [dbo].[Log_reajuste]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Log_reajuste](
	[cd_empresa] [int] NOT NULL,
	[dt_reajuste] [datetime] NOT NULL,
	[cd_sequencial_dep] [int] NOT NULL,
	[vl_anterior] [money] NULL,
	[vl_atual] [money] NULL,
	[id_reajuste] [int] NOT NULL,
 CONSTRAINT [PK_Log_reajuste] PRIMARY KEY CLUSTERED 
(
	[cd_empresa] ASC,
	[dt_reajuste] ASC,
	[cd_sequencial_dep] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Log_reajuste]  WITH NOCHECK ADD  CONSTRAINT [FK_Log_reajuste_Log_reajuste] FOREIGN KEY([cd_sequencial_dep])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
ALTER TABLE [dbo].[Log_reajuste] CHECK CONSTRAINT [FK_Log_reajuste_Log_reajuste]
ALTER TABLE [dbo].[Log_reajuste]  WITH CHECK ADD  CONSTRAINT [FK_Log_reajuste_reajuste1] FOREIGN KEY([id_reajuste])
REFERENCES [dbo].[reajuste] ([id_reajuste])
ALTER TABLE [dbo].[Log_reajuste] CHECK CONSTRAINT [FK_Log_reajuste_reajuste1]
