/****** Object:  Table [dbo].[Newsletter]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Newsletter](
	[nwsId] [int] IDENTITY(1,1) NOT NULL,
	[nwsNome] [varchar](100) NULL,
	[nwsSexo] [bit] NULL,
	[ufId] [smallint] NULL,
	[nwsEmail] [varchar](100) NULL,
	[nwsDtCancelamento] [datetime] NULL,
	[gnwId] [int] NULL,
 CONSTRAINT [PK_Newsletter] PRIMARY KEY CLUSTERED 
(
	[nwsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Newsletter]  WITH CHECK ADD  CONSTRAINT [FK_Newsletter_GrupoNewsletter] FOREIGN KEY([gnwId])
REFERENCES [dbo].[GrupoNewsletter] ([gnwId])
ALTER TABLE [dbo].[Newsletter] CHECK CONSTRAINT [FK_Newsletter_GrupoNewsletter]
