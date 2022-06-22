/****** Object:  Table [dbo].[ImagemConsultaLog]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ImagemConsultaLog](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[arcId] [int] NULL,
	[dataEnvio] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ImagemConsultaLog]  WITH CHECK ADD FOREIGN KEY([arcId])
REFERENCES [dbo].[ArquivoConsultas] ([arcId])
