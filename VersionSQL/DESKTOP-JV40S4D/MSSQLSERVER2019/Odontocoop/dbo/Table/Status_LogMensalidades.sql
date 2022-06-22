/****** Object:  Table [dbo].[Status_LogMensalidades]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Status_LogMensalidades](
	[cd_statusLog] [smallint] NOT NULL,
	[ds_statusLog] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Status_LogMensalidades] PRIMARY KEY CLUSTERED 
(
	[cd_statusLog] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Status' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Status_LogMensalidades', @level2type=N'COLUMN',@level2name=N'ds_statusLog'
