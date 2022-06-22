/****** Object:  Table [dbo].[max_mensalidades]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[max_mensalidades](
	[id] [int] NOT NULL,
	[cd_parcela] [int] NULL,
	[status] [int] NULL,
 CONSTRAINT [PK_max_mensalidades] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[max_mensalidades]  WITH CHECK ADD  CONSTRAINT [FK_max_mensalidades_MENSALIDADES] FOREIGN KEY([cd_parcela])
REFERENCES [dbo].[MENSALIDADES] ([CD_PARCELA])
ALTER TABLE [dbo].[max_mensalidades] CHECK CONSTRAINT [FK_max_mensalidades_MENSALIDADES]
