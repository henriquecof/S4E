/****** Object:  Table [dbo].[MobileClientDepartmentFones]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[MobileClientDepartmentFones](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](200) NULL,
	[fone] [varchar](20) NULL,
	[mobile_client_department_id] [int] NULL,
 CONSTRAINT [PK_MobileClientDepartmentFones] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[MobileClientDepartmentFones]  WITH CHECK ADD  CONSTRAINT [FK_MobileClientDepartmentFones_MobileClientDepartment] FOREIGN KEY([mobile_client_department_id])
REFERENCES [dbo].[MobileClientDepartment] ([id])
ALTER TABLE [dbo].[MobileClientDepartmentFones] CHECK CONSTRAINT [FK_MobileClientDepartmentFones_MobileClientDepartment]
