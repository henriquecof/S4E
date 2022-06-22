/****** Object:  Table [dbo].[competencia]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[competencia](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Competencia] [varchar](8) NULL,
	[IndiceId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[competencia]  WITH CHECK ADD  CONSTRAINT [fk_indice] FOREIGN KEY([IndiceId])
REFERENCES [dbo].[IndiceReajuste] ([id])
ALTER TABLE [dbo].[competencia] CHECK CONSTRAINT [fk_indice]
