USE [reports22]
GO
/****** Object:  Table [dbo].[bent_dialect]    Script Date: 4/6/22 10:00:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[bent_dialect](
	[uid] [varchar](60) NOT NULL,
	[sample_code] [varchar](50) NULL,
	[login] [varchar](20) NULL,
	[group_assignment] [varchar](5) NULL,
	[created] [datetime] NULL,
	[first_login] [datetime] NULL,
	[completed] [datetime] NULL,
 CONSTRAINT [PK_bent_dialect] PRIMARY KEY CLUSTERED 
(
	[uid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[bent_dialect_paradata]    Script Date: 4/6/22 10:00:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[bent_dialect_paradata](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[uid] [varchar](60) NOT NULL,
	[name] [varchar](50) NULL,
	[value] [varchar](50) NULL,
	[created] [datetime] NULL,
 CONSTRAINT [PK_bent_dialect_paradata] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[bent_dialect_results]    Script Date: 4/6/22 10:00:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[bent_dialect_results](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[uid] [varchar](60) NOT NULL,
	[page] [varchar](50) NULL,
	[audio] [varchar](50) NULL,
	[position] [varchar](50) NULL,
	[created] [datetime] NULL,
	[finalized] [bit] NULL,
 CONSTRAINT [PK_bent_dialect_results] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[bent_dialect] ADD  CONSTRAINT [DF_bent_dialect_login]  DEFAULT ([dbo].[GeneratePassword_nosymbols]()) FOR [login]
GO
