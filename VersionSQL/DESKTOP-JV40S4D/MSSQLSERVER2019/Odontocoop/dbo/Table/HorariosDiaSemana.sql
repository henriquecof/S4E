/****** Object:  Table [dbo].[HorariosDiaSemana]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[HorariosDiaSemana](
	[cd_sequencial] [int] IDENTITY(1,1) NOT NULL,
	[cd_horario] [int] NOT NULL,
	[dia_semana] [tinyint] NOT NULL,
	[entrada_1turno] [varchar](5) NOT NULL,
	[saida_1turno] [varchar](5) NOT NULL,
	[entrada_2turno] [varchar](5) NULL,
	[saida_2turno] [varchar](5) NULL,
	[intervalo_almoco] [varchar](5) NULL,
 CONSTRAINT [PK_HorariosDiaSemana] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[HorariosDiaSemana]  WITH NOCHECK ADD  CONSTRAINT [FK_HorariosDiaSemana_Horarios] FOREIGN KEY([cd_horario])
REFERENCES [dbo].[Horarios] ([cd_horario])
ALTER TABLE [dbo].[HorariosDiaSemana] CHECK CONSTRAINT [FK_HorariosDiaSemana_Horarios]
