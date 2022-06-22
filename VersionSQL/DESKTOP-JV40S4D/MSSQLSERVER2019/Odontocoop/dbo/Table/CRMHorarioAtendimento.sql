/****** Object:  Table [dbo].[CRMHorarioAtendimento]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CRMHorarioAtendimento](
	[hatId] [int] IDENTITY(1,1) NOT NULL,
	[hatDiaSemana] [tinyint] NOT NULL,
	[hatHorarioInicial] [int] NOT NULL,
	[hatHorarioFinal] [int] NOT NULL,
 CONSTRAINT [PK_CRMHorarioAtendimento] PRIMARY KEY CLUSTERED 
(
	[hatId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
