/****** Object:  Table [dbo].[max_interacao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[max_interacao](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[max_parcela] [int] NULL,
	[data] [datetime] NULL,
	[erro] [bit] NULL,
	[mensagem] [varchar](500) NULL,
 CONSTRAINT [PK_max_interacao] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[max_interacao]  WITH CHECK ADD  CONSTRAINT [FK_max_interacao_max_mensalidades] FOREIGN KEY([max_parcela])
REFERENCES [dbo].[max_mensalidades] ([id])
ALTER TABLE [dbo].[max_interacao] CHECK CONSTRAINT [FK_max_interacao_max_mensalidades]
