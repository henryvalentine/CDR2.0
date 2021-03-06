USE [master]
GO
/****** Object:  Database [CDR]    Script Date: 06/08/2019 4:09:37 PM ******/
CREATE DATABASE [CDR]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'CDR', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\CDR.mdf' , SIZE = 204800KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'CDR_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\CDR_log.ldf' , SIZE = 204800KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [CDR] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [CDR].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [CDR] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [CDR] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [CDR] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [CDR] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [CDR] SET ARITHABORT OFF 
GO
ALTER DATABASE [CDR] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [CDR] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [CDR] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [CDR] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [CDR] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [CDR] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [CDR] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [CDR] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [CDR] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [CDR] SET  DISABLE_BROKER 
GO
ALTER DATABASE [CDR] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [CDR] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [CDR] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [CDR] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [CDR] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [CDR] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [CDR] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [CDR] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [CDR] SET  MULTI_USER 
GO
ALTER DATABASE [CDR] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [CDR] SET DB_CHAINING OFF 
GO
ALTER DATABASE [CDR] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [CDR] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [CDR] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [CDR] SET QUERY_STORE = OFF
GO
USE [CDR]
GO
/****** Object:  UserDefinedTableType [dbo].[ArtBaselineInfo]    Script Date: 06/08/2019 4:09:37 PM ******/
CREATE TYPE [dbo].[ArtBaselineInfo] AS TABLE(
	[EnrolmentId] [nvarchar](450) NULL,
	[IdNo] [int] NULL,
	[HivConfirmationDate] [date] NULL,
	[EnrolmentDate] [date] NULL,
	[ArtDate] [date] NULL,
	[DispositionDate] [nvarchar](450) NULL,
	[DispositionCode] [nvarchar](450) NULL,
	[SiteId] [int] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[ArtPaedVisit]    Script Date: 06/08/2019 4:09:37 PM ******/
CREATE TYPE [dbo].[ArtPaedVisit] AS TABLE(
	[EnrolmentId] [nvarchar](450) NULL,
	[IdNo] [int] NULL,
	[VisitDate] [date] NULL,
	[Weight] [float] NULL,
	[WhoStage] [nvarchar](450) NULL,
	[TbScreen] [nvarchar](450) NULL,
	[TbDiagnosed] [bit] NULL,
	[TbSuspected] [bit] NULL,
	[TbTreatmentReceived] [bit] NULL,
	[ReceivingContrime] [bit] NULL,
	[ArtStarted] [bit] NULL,
	[ArvRegimenCode] [nvarchar](450) NULL,
	[ArvAdherenceCode] [nvarchar](450) NULL,
	[ArvNonAdherenceCode] [nvarchar](450) NULL,
	[ArvRegimen1] [nvarchar](450) NULL,
	[ArvRegimen2] [nvarchar](450) NULL,
	[ArvRegimen3] [nvarchar](450) NULL,
	[ArvStopCode] [nvarchar](450) NULL,
	[ArvStopDate] [date] NULL,
	[AppointmentDate] [date] NULL,
	[AdvDrugCode] [nvarchar](450) NULL,
	[SiteId] [int] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[ArtVisitInfo]    Script Date: 06/08/2019 4:09:37 PM ******/
CREATE TYPE [dbo].[ArtVisitInfo] AS TABLE(
	[EnrolmentId] [nvarchar](450) NULL,
	[IdNo] [int] NULL,
	[VisitDate] [date] NULL,
	[Weight] [float] NULL,
	[Height] [float] NULL,
	[Temperature] [float] NULL,
	[WhoStage] [nvarchar](450) NULL,
	[IsPregnant] [bit] NULL,
	[TbScreen] [nvarchar](450) NULL,
	[TbDiagnosedTreatment] [nvarchar](450) NULL,
	[TbTreatmentStarted] [nvarchar](450) NULL,
	[CotrimeProphylaxis] [nvarchar](450) NULL,
	[ArtStarted] [bit] NULL,
	[ArvRegisterationCode] [nvarchar](450) NULL,
	[ArvAdherenceCode] [nvarchar](450) NULL,
	[ArvNonAdherenceCode] [nvarchar](450) NULL,
	[DrugReactionCode] [nvarchar](450) NULL,
	[ArvStopCode] [nvarchar](450) NULL,
	[ArvStopDate] [date] NULL,
	[Cd4Count] [nvarchar](450) NULL,
	[BloodPressure] [nvarchar](450) NULL,
	[FamilyPlanningCode] [nvarchar](450) NULL,
	[AppointmentDate] [date] NULL,
	[StatusCode] [nvarchar](450) NULL,
	[SiteId] [int] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[LabResultInfo]    Script Date: 06/08/2019 4:09:37 PM ******/
CREATE TYPE [dbo].[LabResultInfo] AS TABLE(
	[EnrolmentId] [nvarchar](450) NULL,
	[IdNo] [nvarchar](450) NULL,
	[LabNumber] [nvarchar](450) NULL,
	[Description] [nvarchar](450) NULL,
	[TestGroup] [nvarchar](450) NULL,
	[TestResult] [nvarchar](450) NULL,
	[TestDate] [date] NULL,
	[DateReported] [date] NULL,
	[SiteId] [int] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[PatientInfo]    Script Date: 06/08/2019 4:09:37 PM ******/
CREATE TYPE [dbo].[PatientInfo] AS TABLE(
	[FirstName] [nvarchar](450) NULL,
	[LastName] [nvarchar](450) NULL,
	[EnrolmentId] [nvarchar](450) NULL,
	[IdNo] [int] NULL,
	[VisitDate] [date] NULL,
	[StateId] [nvarchar](450) NULL,
	[SiteId] [int] NULL,
	[DateOfBirth] [date] NULL,
	[Age] [int] NULL,
	[Sex] [nvarchar](50) NULL,
	[Village] [nvarchar](max) NULL,
	[Town] [nvarchar](max) NULL,
	[PhoneNumber] [nvarchar](100) NULL,
	[AddressLine1] [nvarchar](max) NULL,
	[State] [nvarchar](450) NULL,
	[Lga] [nvarchar](450) NULL,
	[MaritalStatus] [nvarchar](50) NULL,
	[PreferredLanguage] [nvarchar](450) NULL
)
GO
/****** Object:  Table [dbo].[__EFMigrationsHistory]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[__EFMigrationsHistory](
	[MigrationId] [nvarchar](150) NOT NULL,
	[ProductVersion] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY CLUSTERED 
(
	[MigrationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ArtBaseline]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ArtBaseline](
	[Id] [bigint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[PatientId] [bigint] NOT NULL,
	[HivConfirmationDate] [date] NULL,
	[EnrolmentDate] [date] NULL,
	[ArtDate] [date] NULL,
	[DispositionCode] [nvarchar](max) NULL,
	[DispositionDate] [nvarchar](max) NULL,
	[IdNo] [int] NOT NULL,
	[SiteId] [int] NOT NULL,
	[EnrolmentId] [nvarchar](450) NULL,
 CONSTRAINT [PK_AdultBaselineArt] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ArtVisit]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ArtVisit](
	[Id] [bigint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[PatientId] [bigint] NOT NULL,
	[VisitDate] [date] NULL,
	[Weight] [float] NULL,
	[Height] [float] NULL,
	[Temperature] [float] NULL,
	[BloodPressure] [nvarchar](50) NULL,
	[WhoStage] [nvarchar](50) NULL,
	[IsPregnant] [bit] NULL,
	[TbScreen] [nvarchar](50) NULL,
	[TbSuspected] [bit] NULL,
	[TbDiagnosed] [bit] NULL,
	[ReceivingContrime] [bit] NULL,
	[TbTreatmentReceived] [bit] NULL,
	[TbDiagnosedTreatment] [nvarchar](50) NULL,
	[TbTreatmentStarted] [nvarchar](50) NULL,
	[CotrimeProphylaxis] [nvarchar](50) NULL,
	[ArtStarted] [bit] NULL,
	[ArvRegisterationCode] [nvarchar](50) NULL,
	[ArvRegimen1] [nvarchar](50) NULL,
	[ArvRegimen2] [nvarchar](50) NULL,
	[ArvRegimen3] [nvarchar](50) NULL,
	[ArvRegimenCode] [nvarchar](50) NULL,
	[AdvDrugCode] [nvarchar](50) NULL,
	[ArvAdherenceCode] [nvarchar](50) NULL,
	[ArvNonAdherenceCode] [nvarchar](50) NULL,
	[DrugReactionCode] [nvarchar](50) NULL,
	[ArvStopCode] [nvarchar](50) NULL,
	[ArvStopDate] [date] NULL,
	[FamilyPlanningCode] [nvarchar](50) NULL,
	[AppointmentDate] [date] NULL,
	[StatusCode] [nvarchar](50) NULL,
	[Cd4Count] [nvarchar](50) NULL,
	[IdNo] [int] NOT NULL,
	[SiteId] [int] NOT NULL,
 CONSTRAINT [PK_AdultArtVisit] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetRoleClaims]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetRoleClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RoleId] [nvarchar](450) NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
 CONSTRAINT [PK_AspNetRoleClaims] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetRoles]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetRoles](
	[Id] [nvarchar](450) NOT NULL,
	[Name] [nvarchar](256) NULL,
	[NormalizedName] [nvarchar](256) NULL,
	[ConcurrencyStamp] [nvarchar](max) NULL,
 CONSTRAINT [PK_AspNetRoles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserClaims]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](450) NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
 CONSTRAINT [PK_AspNetUserClaims] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserLogins]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserLogins](
	[LoginProvider] [nvarchar](128) NOT NULL,
	[ProviderKey] [nvarchar](128) NOT NULL,
	[ProviderDisplayName] [nvarchar](max) NULL,
	[UserId] [nvarchar](450) NOT NULL,
 CONSTRAINT [PK_AspNetUserLogins] PRIMARY KEY CLUSTERED 
(
	[LoginProvider] ASC,
	[ProviderKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserRoles]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserRoles](
	[UserId] [nvarchar](450) NOT NULL,
	[RoleId] [nvarchar](450) NOT NULL,
 CONSTRAINT [PK_AspNetUserRoles] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUsers]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUsers](
	[Id] [nvarchar](450) NOT NULL,
	[UserName] [nvarchar](256) NULL,
	[NormalizedUserName] [nvarchar](256) NULL,
	[Email] [nvarchar](256) NULL,
	[NormalizedEmail] [nvarchar](256) NULL,
	[EmailConfirmed] [bit] NOT NULL,
	[PasswordHash] [nvarchar](max) NULL,
	[SecurityStamp] [nvarchar](max) NULL,
	[ConcurrencyStamp] [nvarchar](max) NULL,
	[PhoneNumber] [nvarchar](max) NULL,
	[PhoneNumberConfirmed] [bit] NOT NULL,
	[TwoFactorEnabled] [bit] NOT NULL,
	[LockoutEnd] [datetimeoffset](7) NULL,
	[LockoutEnabled] [bit] NOT NULL,
	[AccessFailedCount] [int] NOT NULL,
	[FirstName] [nvarchar](max) NULL,
	[LastName] [nvarchar](max) NULL,
 CONSTRAINT [PK_AspNetUsers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserTokens]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserTokens](
	[UserId] [nvarchar](450) NOT NULL,
	[LoginProvider] [nvarchar](128) NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](max) NULL,
 CONSTRAINT [PK_AspNetUserTokens] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[LoginProvider] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ErrorHandlerLog]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ErrorHandlerLog](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ErrorDate] [datetimeoffset](7) NOT NULL,
	[Severity] [tinyint] NOT NULL,
	[State] [tinyint] NOT NULL,
	[Number] [int] NOT NULL,
	[Line] [int] NOT NULL,
	[Procedure] [sysname] NULL,
	[Message] [nvarchar](2048) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LabResult]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LabResult](
	[Id] [bigint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[PatientId] [bigint] NULL,
	[TestDate] [date] NOT NULL,
	[DateReported] [date] NOT NULL,
	[LabNumber] [nvarchar](150) NULL,
	[TestGroup] [nvarchar](50) NULL,
	[Description] [nvarchar](max) NULL,
	[TestResult] [nvarchar](250) NULL,
	[IdNo] [int] NOT NULL,
	[SiteId] [int] NOT NULL,
 CONSTRAINT [PK_LabResult] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Patient]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Patient](
	[Id] [bigint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[FirstName] [nvarchar](450) NOT NULL,
	[LastName] [nvarchar](450) NOT NULL,
	[SiteId] [int] NOT NULL,
	[EnrolmentId] [nvarchar](450) NULL,
	[VisitDate] [date] NULL,
	[StateId] [nvarchar](100) NULL,
	[Sex] [nvarchar](50) NULL,
	[DateOfBirth] [date] NULL,
	[Age] [int] NOT NULL,
	[Village] [nvarchar](max) NULL,
	[Town] [nvarchar](max) NULL,
	[Lga] [nvarchar](max) NULL,
	[State] [nvarchar](max) NULL,
	[AddressLine1] [nvarchar](max) NULL,
	[PhoneNumber] [nvarchar](max) NULL,
	[MaritalStatus] [nvarchar](max) NULL,
	[PreferredLanguage] [nvarchar](max) NULL,
	[IdNo] [int] NOT NULL,
 CONSTRAINT [PK_Patient] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Site]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Site](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[LGA] [nvarchar](50) NULL,
	[StateCode] [nvarchar](50) NOT NULL,
	[SiteId] [nvarchar](50) NOT NULL,
	[StateId] [int] NOT NULL,
 CONSTRAINT [PK_Site] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SiteDataTracking]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SiteDataTracking](
	[Id] [bigint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[SiteId] [int] NOT NULL,
	[LastAdultArvVistPage] [int] NOT NULL,
	[LastPaediatricArvVisitPage] [int] NOT NULL,
	[LastAdultArtBaselinePage] [int] NOT NULL,
	[LastPaediatricArtBaselinePage] [int] NOT NULL,
	[LastPatientPage] [int] NOT NULL,
	[LastLabResultPage] [int] NOT NULL,
	[TrackingDate] [datetime] NOT NULL,
 CONSTRAINT [PK_SiteDataTracking] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SiteTxTarget]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SiteTxTarget](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[TxCurrTarget] [bigint] NOT NULL,
	[TxNewTarget] [bigint] NOT NULL,
	[FiscalYear] [int] NOT NULL,
	[SiteId] [int] NOT NULL,
 CONSTRAINT [PK_SiteTxTarget] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[State]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[State](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Code] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_State] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AspNetRoleClaims_RoleId]    Script Date: 06/08/2019 4:09:37 PM ******/
CREATE NONCLUSTERED INDEX [IX_AspNetRoleClaims_RoleId] ON [dbo].[AspNetRoleClaims]
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [RoleNameIndex]    Script Date: 06/08/2019 4:09:37 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [RoleNameIndex] ON [dbo].[AspNetRoles]
(
	[NormalizedName] ASC
)
WHERE ([NormalizedName] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AspNetUserClaims_UserId]    Script Date: 06/08/2019 4:09:37 PM ******/
CREATE NONCLUSTERED INDEX [IX_AspNetUserClaims_UserId] ON [dbo].[AspNetUserClaims]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AspNetUserLogins_UserId]    Script Date: 06/08/2019 4:09:37 PM ******/
CREATE NONCLUSTERED INDEX [IX_AspNetUserLogins_UserId] ON [dbo].[AspNetUserLogins]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AspNetUserRoles_RoleId]    Script Date: 06/08/2019 4:09:37 PM ******/
CREATE NONCLUSTERED INDEX [IX_AspNetUserRoles_RoleId] ON [dbo].[AspNetUserRoles]
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [EmailIndex]    Script Date: 06/08/2019 4:09:37 PM ******/
CREATE NONCLUSTERED INDEX [EmailIndex] ON [dbo].[AspNetUsers]
(
	[NormalizedEmail] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UserNameIndex]    Script Date: 06/08/2019 4:09:37 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UserNameIndex] ON [dbo].[AspNetUsers]
(
	[NormalizedUserName] ASC
)
WHERE ([NormalizedUserName] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ArtBaseline]  WITH CHECK ADD  CONSTRAINT [FK_ArtBaseline_Patient] FOREIGN KEY([PatientId])
REFERENCES [dbo].[Patient] ([Id])
GO
ALTER TABLE [dbo].[ArtBaseline] CHECK CONSTRAINT [FK_ArtBaseline_Patient]
GO
ALTER TABLE [dbo].[ArtBaseline]  WITH CHECK ADD  CONSTRAINT [FK_ArtBaseline_Site] FOREIGN KEY([SiteId])
REFERENCES [dbo].[Site] ([Id])
GO
ALTER TABLE [dbo].[ArtBaseline] CHECK CONSTRAINT [FK_ArtBaseline_Site]
GO
ALTER TABLE [dbo].[ArtVisit]  WITH CHECK ADD  CONSTRAINT [FK_ArtVisit_Patient] FOREIGN KEY([PatientId])
REFERENCES [dbo].[Patient] ([Id])
GO
ALTER TABLE [dbo].[ArtVisit] CHECK CONSTRAINT [FK_ArtVisit_Patient]
GO
ALTER TABLE [dbo].[ArtVisit]  WITH CHECK ADD  CONSTRAINT [FK_ArtVisit_Site] FOREIGN KEY([SiteId])
REFERENCES [dbo].[Site] ([Id])
GO
ALTER TABLE [dbo].[ArtVisit] CHECK CONSTRAINT [FK_ArtVisit_Site]
GO
ALTER TABLE [dbo].[AspNetRoleClaims]  WITH CHECK ADD  CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[AspNetRoles] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetRoleClaims] CHECK CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId]
GO
ALTER TABLE [dbo].[AspNetUserClaims]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserClaims] CHECK CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserLogins]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserLogins] CHECK CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[AspNetRoles] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId]
GO
ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserTokens]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserTokens] CHECK CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[LabResult]  WITH CHECK ADD  CONSTRAINT [FK_LabResult_Patient] FOREIGN KEY([PatientId])
REFERENCES [dbo].[Patient] ([Id])
GO
ALTER TABLE [dbo].[LabResult] CHECK CONSTRAINT [FK_LabResult_Patient]
GO
ALTER TABLE [dbo].[Patient]  WITH CHECK ADD  CONSTRAINT [FK_Patient_Site] FOREIGN KEY([SiteId])
REFERENCES [dbo].[Site] ([Id])
GO
ALTER TABLE [dbo].[Patient] CHECK CONSTRAINT [FK_Patient_Site]
GO
ALTER TABLE [dbo].[Site]  WITH CHECK ADD  CONSTRAINT [FK_Site_State] FOREIGN KEY([StateId])
REFERENCES [dbo].[State] ([Id])
GO
ALTER TABLE [dbo].[Site] CHECK CONSTRAINT [FK_Site_State]
GO
ALTER TABLE [dbo].[SiteDataTracking]  WITH CHECK ADD  CONSTRAINT [FK_SiteDataTracking_Site] FOREIGN KEY([SiteId])
REFERENCES [dbo].[Site] ([Id])
GO
ALTER TABLE [dbo].[SiteDataTracking] CHECK CONSTRAINT [FK_SiteDataTracking_Site]
GO
ALTER TABLE [dbo].[SiteTxTarget]  WITH CHECK ADD  CONSTRAINT [FK_SiteTxTarget_Site] FOREIGN KEY([SiteId])
REFERENCES [dbo].[Site] ([Id])
GO
ALTER TABLE [dbo].[SiteTxTarget] CHECK CONSTRAINT [FK_SiteTxTarget_Site]
GO
/****** Object:  StoredProcedure [dbo].[sp_CallProcedureLog]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_CallProcedureLog]
 @ObjectID       INT,
 @DatabaseID     INT = NULL,
 @AdditionalInfo NVARCHAR(MAX) = NULL
AS
BEGIN
 SET NOCOUNT ON;

 DECLARE 
  @ProcedureName NVARCHAR(400);

 SELECT
  @DatabaseID = COALESCE(@DatabaseID, DB_ID()),
  @ProcedureName = COALESCE
  (
   QUOTENAME(DB_NAME(@DatabaseID)) + '.'
   + QUOTENAME(OBJECT_SCHEMA_NAME(@ObjectID, @DatabaseID)) 
   + '.' + QUOTENAME(OBJECT_NAME(@ObjectID, @DatabaseID)),
   ERROR_PROCEDURE()
  );

 insert into ProcedureLog(DatabaseID,ObjectID,ProcedureName,ErrorLine,ErrorMessage,AdditionalInfo)
 select @DatabaseID, @ObjectID, @ProcedureName, ERROR_LINE(), ERROR_MESSAGE(), @AdditionalInfo;
END
GO
/****** Object:  StoredProcedure [dbo].[stActives28ByPartition]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stActives28ByPartition]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select count(distinct Id) actives from
(select Id from Patient as p 
where exists (select distinct PatientId = p.Id from ArtBaseline)) o

left outer join (select u.PatientId,AppointmentDate dd,
             row_number() over (partition by PatientId order by AppointmentDate desc) as seqnum
      from ArtVisit u
     ) u on o.Id = u.PatientId where seqnum = 1 and cast(getdate() as date) <= cast(dateadd(day, 28, u.dd) as date)

END
GO
/****** Object:  StoredProcedure [dbo].[stCountClientsOnArt]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stCountClientsOnArt]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	 select count(Id) as clients from
	((select Id from Patient s where exists 

	(select distinct PatientId = s.Id from ArtBaseline )))f

END
GO
/****** Object:  StoredProcedure [dbo].[stCountSearch]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stCountSearch] 
	-- Add the parameters for the stored procedure here
	@searchTerm as nvarchar(MAX)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select count(Id) as users from AspNetUsers where (FirstName like '%' + @searchTerm + '%') or (LastName like '%' + @searchTerm + '%')
END
GO
/****** Object:  StoredProcedure [dbo].[stCountSites]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stCountSites] 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
select count(distinct Id) counts from Site s join (select SiteId from Patient group by SiteId having count(distinct SiteId) > 0 ) d on s.Id = d.SiteId

END
GO
/****** Object:  StoredProcedure [dbo].[stCountTxCurrByPeriod]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stCountTxCurrByPeriod] 
	-- Add the parameters for the stored procedure here
	@startDate date,
	@endDate date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
declare @start date = cast(@startDate as date);
declare @end date = cast(@endDate as date);

select count(site.Id) as count
from
    (select Id, Name, StateCode from Site s join (select SiteId from Patient group by SiteId having count(distinct SiteId) > 0 ) d on s.Id = d.SiteId) as site

 right join 
 (

 select
        count(w.PatientId) as active, u.SiteId as site

		from

    (select Id, SiteId from Patient) as u

   left outer join
(select distinct PatientId, max(AppointmentDate) d from ArtVisit g where @start <= cast(dateadd(day, 28, AppointmentDate) as date) and @end <= cast(dateadd(day, 28, AppointmentDate) as date) group by PatientId) w on  u.Id = w.PatientId group by u.SiteId

) c on site.Id = c.site
join (select TxCurrTarget, FiscalYear, SiteId from SiteTxTarget where (FiscalYear >= year(@start) and FiscalYear <= year(@end))) t on site.Id = t.SiteId
END
GO
/****** Object:  StoredProcedure [dbo].[stCountTxNewByPeriod]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stCountTxNewByPeriod]
	-- Add the parameters for the stored procedure here
	@startDate date,
	@endDate date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
declare @start date = cast(@startDate as date);
declare @end date = cast(@endDate as date);

select count(site.Id) as count
from
    (select Id, Name, StateCode from Site s join (select SiteId from Patient group by SiteId having count(distinct SiteId) > 0 ) d on s.Id = d.SiteId) as site

 right join 
 (

 select count(nc.PatientId) as txNew, u.SiteId as site

		from

	(select Id, SiteId from Patient p)as u

    left outer join 
	
	(select distinct PatientId from ArtBaseline where ArtDate >= @start and ArtDate <= @end) nc on u.Id = nc.PatientId
	group by u.SiteId

) c on site.Id = c.site
join (select TxNewTarget, FiscalYear, SiteId from SiteTxTarget where (FiscalYear >= year(@start) and FiscalYear <= year(@end))) t on site.Id = t.SiteId
END
GO
/****** Object:  StoredProcedure [dbo].[stCountUsers]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stCountUsers]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT count(Id) as users from AspNetUsers
END
GO
/****** Object:  StoredProcedure [dbo].[stCountViralSuppressionByPeriod]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stCountViralSuppressionByPeriod] 
	-- Add the parameters for the stored procedure here
	@startDate date,
	@endDate date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
declare @start date = cast(@startDate as date);
declare @end date = cast(@endDate as date);

select count(site.Id) as counts
from
    (select Id, Name, StateCode from Site s join (select SiteId from Patient group by SiteId having count(distinct SiteId) > 0 ) d on s.Id = d.SiteId) as site

 right join 
 (

 select
        count(u.Id) as total, count(h.PatientId) as suppressed , u.SiteId as site

		from

	(select Id, SiteId from Patient p)as u

    inner join 
	
	(select distinct PatientId from ArtBaseline) nc on u.Id = nc.PatientId
	
	 left outer join 
	
(select distinct PatientId, max(AppointmentDate) d from ArtVisit g where @start <= cast(dateadd(day, 28, AppointmentDate) as date) and @end <= cast(dateadd(day, 28, AppointmentDate) as date) group by PatientId) w on  u.Id = w.PatientId

left outer join 

(select o.PatientId
from (select o.PatientId,
             row_number() over (partition by PatientId order by TestDate desc) as seqnum
      from LabResult o where o.TestDate >= @start and o.TestDate <= @end
     ) o

where seqnum = 1)h on u.Id = h.PatientId

	group by u.SiteId

) c on site.Id = c.site
join (select FiscalYear, SiteId from SiteTxTarget where (FiscalYear >= year(@start) and FiscalYear <= year(@end))) t on site.Id = t.SiteId
END
GO
/****** Object:  StoredProcedure [dbo].[stDashboard]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stDashboard]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	declare @today as date = cast(getdate() as date); 	

	------Clients ever enrolled on ART
	
	select count(Id) as clients from
	((select distinct Id from Patient s where exists 

	(select distinct PatientId = s.Id from ArtBaseline)))f
	
	--------------------- Sites with Clients Ever enrolled on ART

	select count(distinct Id) as sites from Site s where exists (select SiteId = s.Id from Patient)

	------------------- Tx_Curr based on 28 days

	select count(n.PatientId) as patients28 from
	((select distinct Id from Patient s where exists (select distinct PatientId = s.Id from ArtBaseline))j 
	left outer join
	(select distinct PatientId, max(AppointmentDate) as dt1 from ArtVisit where @today <= cast(dateadd(day, 28, AppointmentDate) as date) group by PatientId) n on j.Id = n.PatientId)

	------------------- Tx_Curr based on 90 days
	
	select count(n.PatientId) as patient90 from
	((select distinct Id from Patient s where exists (select distinct PatientId = s.Id from ArtBaseline))j 
	left outer join
	(select distinct PatientId, max(AppointmentDate) as dt1 from ArtVisit where @today <= cast(dateadd(day, 90, AppointmentDate) as date) group by PatientId) n on j.Id = n.PatientId)
	
	------------------- Clients newly Enrolled on ART

select sum(r.nc) as newC from
	 (select Id from Patient p where exists (select PatientId = p.Id from ArtBaseline))as u

    left outer join 
	
	(select sum(case when year(v.d) = year(@today) and ((((month(dateadd(month, -9, v.d))) + 2)/3) = (((month(dateadd(month, -9, @today))) + 2)/3)) then 1 else 0 end) as nc, PatientId 
from (select distinct PatientId, ArtDate as d from ArtBaseline group by PatientId, ArtDate) as v group by PatientId) r on u.Id = r.PatientId

END
GO
/****** Object:  StoredProcedure [dbo].[stErrorHandler]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stErrorHandler] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
    -- Insert statements for procedure here
	set nocount, xact_abort on;
  declare
      @error_date datetimeoffset(7) = sysdatetimeoffset()
    , @severity tinyint = isnull(error_severity(),16)
    , @state tinyint = isnull(error_state(),1)
    , @number int = isnull(error_number(),0)
    , @line int = isnull(error_line(),0)
    , @procedure sysname = error_procedure()
    , @message nvarchar(2048) = error_message();
  insert into [dbo].[ErrorHandlerLog] 
    ([ErrorDate],[Procedure],[Severity],[State],[Number],[Line],[Message]) values 
    (@error_date, @procedure, @severity, @state, @number, @line, @message);
  --raiserror(@message, @severity, @state); /* don't re-raise error to continue code execution */
END
GO
/****** Object:  StoredProcedure [dbo].[stGet28DayActivesBand]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stGet28DayActivesBand] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	declare @today as date = cast(getdate() as date);
	select Id as patient, datediff(year, cast(DateOfBirth as date), @today) as age, Sex as gender from
	((select distinct Id, DateOfBirth, Sex  from Patient s where exists (select distinct PatientId = s.Id from ArtBaseline))j 
	left outer join
	(select distinct PatientId, max(AppointmentDate) as dt1 from ArtVisit where @today <= cast(dateadd(day, 28, AppointmentDate) as date)  group by PatientId) n on j.Id = n.PatientId) order by age
END
GO
/****** Object:  StoredProcedure [dbo].[stGet90DayActives]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stGet90DayActives]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	declare @today as date = cast(getdate() as date);
	select Id as patient, datediff(year, cast(DateOfBirth as date), @today) as age, Sex as gender from
	((select distinct Id, DateOfBirth, Sex  from Patient s where exists (select distinct PatientId = s.Id from ArtBaseline))j 
	left outer join
	(select distinct PatientId, max(AppointmentDate) as dt1 from ArtVisit where @today <= cast(dateadd(day, 90, AppointmentDate) as date)  group by PatientId) n on j.Id = n.PatientId) order by age
END
GO
/****** Object:  StoredProcedure [dbo].[stGetAllByPeriod]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stGetAllByPeriod]
	-- Add the parameters for the stored procedure here
	@startDate date,
	@endDate date,
	@pageNumber as int,
	@itemsPerPage as int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
declare @start date = cast(@startDate as date);
declare @end date = cast(@endDate as date);

declare @startQuarter int = (((month(dateadd(month, -9, @start))) + 2)/3);
declare @endQuarter int = (((month(dateadd(month, -9, @end))) + 2)/3);

select site.Id as sId, site.Name as site, site.StateCode as code, sum(total) as total, t.TxCurrTarget, t.TxNewTarget, t.FiscalYear, sum(active) as active, sum(inActive) as inactive, sum(loss) as loss, sum(tx_new) as tx_new
from
    (select Id, Name, StateCode from Site s join (select SiteId from Patient group by SiteId having count(distinct SiteId) > 0 ) d on s.Id = d.SiteId order by Id offset  ((@pageNumber-1 )*@itemsPerPage)  rows fetch next @itemsPerPage rows only) as site

 right join 
 (

 select
        count(u.Id) as total, sum(w.a) as active, sum(w.i) as inActive, sum(w.l) as loss, count(nc.PatientId) as tx_new, u.SiteId as site

		from

    (select Id, SiteId from Patient p where exists (select distinct PatientId = p.Id from ArtBaseline where EnrolmentDate >=@start and  EnrolmentDate <= @end))as u

    left outer join 
	
	(select distinct PatientId from ArtBaseline where (year(ArtDate) = year(@start) and ((((month(dateadd(month, -9, ArtDate))) + 2)/3) = @startQuarter) or year(ArtDate) = year(@end) and ((((month(dateadd(month, -9, ArtDate))) + 2)/3) = @endQuarter)) group by PatientId) nc on u.Id = nc.PatientId

   left outer join

	(select sum(case when (@start <= cast(dateadd(day, 28, h.d) as date)) then 1 else 0 end) as a, 
sum(case when ((@start > cast(dateadd(day, 28, h.d) as date)) and (@start <= cast(dateadd(day, 90, h.d) as date)) and (@end <= cast(dateadd(day, 90, h.d) as date))) then 1 else 0 end) as i,
sum(case when (@start >  cast(dateadd(day, 90, h.d) as date) or @end >  cast(dateadd(day, 90, h.d) as date)) then 1 else 0 end) as l, PatientId 
from (select distinct PatientId, max(AppointmentDate) as d from ArtVisit group by PatientId) as h group by h.PatientId)
w on  u.Id = w.PatientId group by u.SiteId
) c on site.Id = c.site
join (select TxCurrTarget, TxNewTarget, FiscalYear, SiteId from SiteTxTarget where (FiscalYear >= year(@start) and FiscalYear <= year(@end))) t on site.Id = t.SiteId
 group by site.Id, site.Name, site.StateCode, t.TxCurrTarget, t.TxNewTarget, t.FiscalYear
END
GO
/****** Object:  StoredProcedure [dbo].[stGetClientBands]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stGetClientBands]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

     ----------- Active clients based on 28 days
	declare @today as date = cast(getdate() as date); 

	select Id as patient, datediff(year, cast(DateOfBirth as date), @today) as age, Sex as gender from
	((select distinct Id, DateOfBirth, Sex  from Patient s where exists (select distinct PatientId = s.Id from ArtBaseline))j 
	left outer join
	(select distinct PatientId, max(AppointmentDate) as dt1 from ArtVisit where @today <= cast(dateadd(day, 28, AppointmentDate) as date)  group by PatientId) n on j.Id = n.PatientId) order by age

	----------------- Active Clients based on 90 days

	select Id as patient, datediff(year, cast(DateOfBirth as date), @today) as age, Sex as gender from
	((select distinct Id, DateOfBirth, Sex  from Patient s where exists (select distinct PatientId = s.Id from ArtBaseline))j 
	left outer join
	(select distinct PatientId, max(AppointmentDate) as dt1 from ArtVisit where @today <= cast(dateadd(day, 90, AppointmentDate) as date)  group by PatientId) n on j.Id = n.PatientId) order by age
END
GO
/****** Object:  StoredProcedure [dbo].[stGetDashboardStats]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stGetDashboardStats]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	declare @today as date = cast(getdate() as date); 	

                select count(u.Id) as total, sum(site.ss) as sites, sum(r.nc) newC, sum(w.a) active, sum(w.i) defaulters  from  
                (
					(select distinct Id  from Patient s join (select distinct PatientId from ArtBaseline group by PatientId having count(PatientId) > 0)n on s.Id = n.PatientId) u
					join

					(select sum(case when year(v.d) = year(@today) and ((((month(dateadd(month, -9, v.d))) + 2)/3) = (((month(dateadd(month, -9, @today))) + 1)/3)) then 1 else 0 end) as nc, PatientId 
                    from (select distinct PatientId, ArtDate as d from ArtBaseline group by PatientId, ArtDate) as v group by v.PatientId) as r on u.Id = r.PatientId

					join

				(select sum(case when (@today <= cast(dateadd(day, 28, v.d) as date)) then 1 else 0 end) as a, 
                    sum(case when (@today > cast(dateadd(day, 28, v.d) as date)) then 1 else 0 end) as i, v.PatientId 
                    from (select distinct PatientId, max(AppointmentDate) as d from ArtVisit group by PatientId) as v group by v.PatientId) as w on u.Id = w.PatientId
            cross join 
            (select count(distinct(Id)) as ss from Site) as site)
END
GO
/****** Object:  StoredProcedure [dbo].[stGetSitesByPage]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stGetSitesByPage] 
	-- Add the parameters for the stored procedure here
@pageNumber as int,
@itemsPerPage as int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

declare @today as date = cast(getdate() as date);

select site.Id as sId, site.Name as site, site.StateCode as code, sum(total) as total, sum(active) as active, sum(inActive) as inactive, sum(loss) as loss, sum(tx_new) as tx_new
from
    (select Id, Name, StateCode from Site s join (select SiteId from Patient group by SiteId having count(distinct SiteId) > 0 ) d on s.Id = d.SiteId order by Id offset  ((@pageNumber-1 )*@itemsPerPage)  rows fetch next @itemsPerPage rows only) as site

 right join 
 (

 select
        count(u.Id) as total, sum(w.a) as active, sum(w.i) as inActive, sum(w.l) as loss, count(nc.PatientId) as tx_new, u.SiteId as site

		from

    (select Id, SiteId from Patient p where exists (select PatientId = p.Id from ArtBaseline))as u

    left outer join 

	(select distinct PatientId from ArtBaseline where year(ArtDate) = year(@today) and ((((month(dateadd(month, -9, ArtDate))) + 2)/3) = (((month(dateadd(month, -9, @today))) + 2)/3)) group by PatientId) nc on u.Id = nc.PatientId

   left outer join

	(select sum(case when (@today <= cast(dateadd(day, 28, h.d) as date)) then 1 else 0 end) as a, 
sum(case when ((@today > cast(dateadd(day, 28, h.d) as date)) and (@today <= cast(dateadd(day, 90, h.d) as date))) then 1 else 0 end) as i,
sum(case when (@today >  cast(dateadd(day, 90, h.d) as date)) then 1 else 0 end) as l, PatientId 
from (select distinct PatientId, max(AppointmentDate) as d from ArtVisit group by PatientId) as h group by h.PatientId)
w on  u.Id = w.PatientId group by u.SiteId
) c on site.Id = c.site group by site.Id, site.Name, site.StateCode

END
GO
/****** Object:  StoredProcedure [dbo].[stGetSiteTxCurrByPeriod]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stGetSiteTxCurrByPeriod] 
	-- Add the parameters for the stored procedure here
	@startDate date,
	@endDate date,
	@siteId as int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
declare @start date = cast(@startDate as date);
declare @end date = cast(@endDate as date);

select site.Id as sId, site.Name as site, site.StateCode as code, sum(total) as total, t.TxCurrTarget, t.FiscalYear, sum(active) as active
from
    (select Id, Name, StateCode from Site s join (select SiteId from Patient group by SiteId having count(distinct SiteId) > 0 ) d on s.Id = d.SiteId where Id = @siteId) as site

 right join 
 (

 select
        count(u.Id) as total, count(w.PatientId) as active, u.SiteId as site

		from

    (select Id, SiteId from Patient) as u

   left outer join
(select distinct PatientId, max(AppointmentDate) d from ArtVisit g where @start <= cast(dateadd(day, 28, AppointmentDate) as date) and @end <= cast(dateadd(day, 28, AppointmentDate) as date) group by PatientId) w on  u.Id = w.PatientId group by u.SiteId

) c on site.Id = c.site
join (select TxCurrTarget, FiscalYear, SiteId from SiteTxTarget where (FiscalYear >= year(@start) and FiscalYear <= year(@end))) t on site.Id = t.SiteId
 group by site.Id, site.Name, site.StateCode, t.TxCurrTarget, t.FiscalYear
END
GO
/****** Object:  StoredProcedure [dbo].[stGetSiteTxNewByPeriod]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stGetSiteTxNewByPeriod]
	-- Add the parameters for the stored procedure here
	@startDate date,
	@endDate date,
	@siteId as int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
declare @start date = cast(@startDate as date);
declare @end date = cast(@endDate as date);

select site.Id as sId, site.Name as site, site.StateCode as code, sum(total) as total, sum(txNew) as txNew, t.TxNewTarget, t.FiscalYear
from
    (select Id, Name, StateCode from Site s join (select SiteId from Patient group by SiteId having count(distinct SiteId) > 0 ) d on s.Id = d.SiteId where Id = @siteId) as site

 right join 
 (

 select
        count(u.Id) as total, count(nc.PatientId) as txNew, u.SiteId as site

		from

	(select Id, SiteId from Patient p)as u

    left outer join 
	
	(select distinct PatientId from ArtBaseline where ArtDate >= @start and ArtDate <= @end) nc on u.Id = nc.PatientId
	group by u.SiteId

) c on site.Id = c.site
join (select TxNewTarget, FiscalYear, SiteId from SiteTxTarget where (FiscalYear >= year(@start) and FiscalYear <= year(@end))) t on site.Id = t.SiteId
 group by site.Id, site.Name, site.StateCode, t.TxNewTarget, t.FiscalYear
END
GO
/****** Object:  StoredProcedure [dbo].[stGetSiteVLByPeriod]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stGetSiteVLByPeriod]
	-- Add the parameters for the stored procedure here
	@startDate date,
	@endDate date,
	@siteId as int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
declare @start date = cast(@startDate as date);
declare @end date = cast(@endDate as date);

select site.Id as sId, site.Name as site, site.StateCode as code, sum(active) as active,sum(suppressed) as suppressed, t.FiscalYear
from
    (select Id, Name, StateCode from Site s join (select SiteId from Patient group by SiteId having count(distinct SiteId) > 0 ) d on s.Id = d.SiteId where Id = @siteId) as site

 right join 
 (
  select
        count(w.PatientId) as active, count(h.PatientId) as suppressed , u.SiteId as site

		from

	(select Id, SiteId from Patient p)as u

    inner join 
	
	(select distinct PatientId from ArtBaseline) nc on u.Id = nc.PatientId
	
	 left outer join 
	
(select distinct PatientId, max(AppointmentDate) d from ArtVisit g where @start <= cast(dateadd(day, 28, AppointmentDate) as date) and @end <= cast(dateadd(day, 28, AppointmentDate) as date) group by PatientId) w on  u.Id = w.PatientId

left outer join 

(select o.PatientId
from (select o.PatientId,
             row_number() over (partition by PatientId order by TestDate desc) as seqnum
      from LabResult o where o.TestDate >= @start and o.TestDate <= @end
     ) o

where seqnum = 1)h on u.Id = h.PatientId

	group by u.SiteId

) c on site.Id = c.site
join (select TxNewTarget, FiscalYear, SiteId from SiteTxTarget where (FiscalYear >= year(@start) and FiscalYear <= year(@end))) t on site.Id = t.SiteId
 group by site.Id, site.Name, site.StateCode, t.FiscalYear
END
GO
/****** Object:  StoredProcedure [dbo].[stGetStatesTxCurrByPeriod]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stGetStatesTxCurrByPeriod]
	-- Add the parameters for the stored procedure here
	@startDate date,
	@endDate date
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
declare @start date = cast(@startDate as date);
declare @end date = cast(@endDate as date);

select site.StateId as state, sum(total) as total, t.TxCurrTarget, t.FiscalYear, sum(active) as active
from
    (select Id, StateId from Site s join (select SiteId from Patient group by SiteId having count(distinct SiteId) > 0 ) d on s.Id = d.SiteId) as site

 right join 
 (

 select
        count(u.Id) as total, count(w.PatientId) as active, u.SiteId as site

		from

    (select Id, SiteId from Patient) as u

   left outer join
(select distinct PatientId, max(AppointmentDate) d from ArtVisit g where @start <= cast(dateadd(day, 28, AppointmentDate) as date) and @end <= cast(dateadd(day, 28, AppointmentDate) as date) group by PatientId) w on  u.Id = w.PatientId group by u.SiteId

) c on site.Id = c.site
join (select TxCurrTarget, FiscalYear, SiteId from SiteTxTarget where (FiscalYear >= year(@start) and FiscalYear <= year(@end))) t on site.Id = t.SiteId
 group by site.StateId, t.TxCurrTarget, t.FiscalYear
END
GO
/****** Object:  StoredProcedure [dbo].[stGetStatesTxNewByPeriod]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stGetStatesTxNewByPeriod]
	-- Add the parameters for the stored procedure here
	@startDate date,
	@endDate date
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
declare @start date = cast(@startDate as date);
declare @end date = cast(@endDate as date);

select site.StateId as state, sum(total) as total, sum(txNew) as txNew, t.TxNewTarget, t.FiscalYear
from
    (select Id, StateId from Site s join (select SiteId from Patient group by SiteId having count(distinct SiteId) > 0 ) d on s.Id = d.SiteId) as site

 right join 
 (

 select
        count(u.Id) as total, count(nc.PatientId) as txNew, u.SiteId as site

		from

	(select Id, SiteId from Patient p)as u

    left outer join 
	
	(select distinct PatientId from ArtBaseline where ArtDate >= @start and ArtDate <= @end) nc on u.Id = nc.PatientId
	group by u.SiteId

) c on site.Id = c.site
join (select TxNewTarget, FiscalYear, SiteId from SiteTxTarget where (FiscalYear >= year(@start) and FiscalYear <= year(@end))) t on site.Id = t.SiteId
 group by site.StateId, t.TxNewTarget, t.FiscalYear
END
GO
/****** Object:  StoredProcedure [dbo].[stGetStatesVLByPeriod]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stGetStatesVLByPeriod] 
	-- Add the parameters for the stored procedure here
	@startDate date,
	@endDate date
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
declare @start date = cast(@startDate as date);
declare @end date = cast(@endDate as date);

select site.StateId as state, sum(active) as active,sum(suppressed) as suppressed, t.FiscalYear
from
    (select Id, StateId from Site s join (select SiteId from Patient group by SiteId having count(distinct SiteId) > 0 ) d on s.Id = d.SiteId) as site

 right join 
 (
  select
        count(w.PatientId) as active, count(h.PatientId) as suppressed , u.SiteId as site

		from

	(select Id, SiteId from Patient p)as u

    inner join 
	
	(select distinct PatientId from ArtBaseline) nc on u.Id = nc.PatientId
	
	 left outer join 
	
(select distinct PatientId, max(AppointmentDate) d from ArtVisit g where @start <= cast(dateadd(day, 28, AppointmentDate) as date) and @end <= cast(dateadd(day, 28, AppointmentDate) as date) group by PatientId) w on  u.Id = w.PatientId

left outer join 

(select o.PatientId
from (select o.PatientId,
             row_number() over (partition by PatientId order by TestDate desc) as seqnum
      from LabResult o where o.TestDate >= @start and o.TestDate <= @end
     ) o

where seqnum = 1)h on u.Id = h.PatientId

	group by u.SiteId

) c on site.Id = c.site
join (select TxNewTarget, FiscalYear, SiteId from SiteTxTarget where (FiscalYear >= year(@start) and FiscalYear <= year(@end))) t on site.Id = t.SiteId
 group by site.StateId, t.FiscalYear
END
GO
/****** Object:  StoredProcedure [dbo].[stGetStateTxCurrByPeriod]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stGetStateTxCurrByPeriod] 
	-- Add the parameters for the stored procedure here
	@startDate date,
	@endDate date,
	@stateId as int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
declare @start date = cast(@startDate as date);
declare @end date = cast(@endDate as date);

select site.StateId as state, sum(total) as total, t.TxCurrTarget, t.FiscalYear, sum(active) as active
from
    (select Id, StateId from Site s join (select SiteId from Patient group by SiteId having count(distinct SiteId) > 0 ) d on s.Id = d.SiteId where StateId = @stateId) as site

 right join 
 (

 select
        count(u.Id) as total, count(w.PatientId) as active, u.SiteId as site

		from

    (select Id, SiteId from Patient) as u

   left outer join
(select distinct PatientId, max(AppointmentDate) d from ArtVisit g where @start <= cast(dateadd(day, 28, AppointmentDate) as date) and @end <= cast(dateadd(day, 28, AppointmentDate) as date) group by PatientId) w on  u.Id = w.PatientId group by u.SiteId

) c on site.Id = c.site
join (select TxCurrTarget, FiscalYear, SiteId from SiteTxTarget where (FiscalYear >= year(@start) and FiscalYear <= year(@end))) t on site.Id = t.SiteId
 group by site.StateId, t.TxCurrTarget, t.FiscalYear
END
GO
/****** Object:  StoredProcedure [dbo].[stGetStateTxNewByPeriod]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stGetStateTxNewByPeriod]
	-- Add the parameters for the stored procedure here
	@startDate date,
	@endDate date,
	@stateId as int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
declare @start date = cast(@startDate as date);
declare @end date = cast(@endDate as date);

select site.StateId as state, sum(total) as total, sum(txNew) as txNew, t.TxNewTarget, t.FiscalYear
from
    (select Id, StateId from Site s join (select SiteId from Patient group by SiteId having count(distinct SiteId) > 0 ) d on s.Id = d.SiteId where StateId = @stateId) as site

 right join 
 (

 select
        count(u.Id) as total, count(nc.PatientId) as txNew, u.SiteId as site

		from

	(select Id, SiteId from Patient p)as u

    left outer join 
	
	(select distinct PatientId from ArtBaseline where ArtDate >= @start and ArtDate <= @end) nc on u.Id = nc.PatientId
	group by u.SiteId

) c on site.Id = c.site
join (select TxNewTarget, FiscalYear, SiteId from SiteTxTarget where (FiscalYear >= year(@start) and FiscalYear <= year(@end))) t on site.Id = t.SiteId
 group by site.StateId, t.TxNewTarget, t.FiscalYear
END
GO
/****** Object:  StoredProcedure [dbo].[stGetStateVLByPeriod]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stGetStateVLByPeriod] 
	-- Add the parameters for the stored procedure here
	@startDate date,
	@endDate date,
	@stateId as int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
declare @start date = cast(@startDate as date);
declare @end date = cast(@endDate as date);

select site.StateId as state, sum(active) as active,sum(suppressed) as suppressed, t.FiscalYear
from
    (select Id, StateId from Site s join (select SiteId from Patient group by SiteId having count(distinct SiteId) > 0 ) d on s.Id = d.SiteId where StateId = @stateId) as site

 right join 
 (
  select
        count(w.PatientId) as active, count(h.PatientId) as suppressed , u.SiteId as site

		from

	(select Id, SiteId from Patient p)as u

    inner join 
	
	(select distinct PatientId from ArtBaseline) nc on u.Id = nc.PatientId
	
	 left outer join 
	
(select distinct PatientId, max(AppointmentDate) d from ArtVisit g where @start <= cast(dateadd(day, 28, AppointmentDate) as date) and @end <= cast(dateadd(day, 28, AppointmentDate) as date) group by PatientId) w on  u.Id = w.PatientId

left outer join 

(select o.PatientId
from (select o.PatientId,
             row_number() over (partition by PatientId order by TestDate desc) as seqnum
      from LabResult o where o.TestDate >= @start and o.TestDate <= @end
     ) o

where seqnum = 1)h on u.Id = h.PatientId

	group by u.SiteId

) c on site.Id = c.site
join (select TxNewTarget, FiscalYear, SiteId from SiteTxTarget where (FiscalYear >= year(@start) and FiscalYear <= year(@end))) t on site.Id = t.SiteId
 group by site.StateId, t.FiscalYear
END
GO
/****** Object:  StoredProcedure [dbo].[stGetTxCurrByPeriod]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stGetTxCurrByPeriod]
	-- Add the parameters for the stored procedure here
	@startDate date,
	@endDate date,
	@pageNumber as int,
	@itemsPerPage as int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
declare @start date = cast(@startDate as date);
declare @end date = cast(@endDate as date);

select site.Id as sId, site.Name as site, site.StateCode as code, sum(total) as total, t.TxCurrTarget, t.FiscalYear, sum(active) as active
from
    (select Id, Name, StateCode from Site s join (select SiteId from Patient group by SiteId having count(distinct SiteId) > 0 ) d on s.Id = d.SiteId order by Id offset  ((@pageNumber-1 )*@itemsPerPage)  rows fetch next @itemsPerPage rows only) as site

 right join 
 (

 select
        count(u.Id) as total, count(w.PatientId) as active, u.SiteId as site

		from

    (select Id, SiteId from Patient) as u

   left outer join
(select distinct PatientId, max(AppointmentDate) d from ArtVisit g where @start <= cast(dateadd(day, 28, AppointmentDate) as date) and @end <= cast(dateadd(day, 28, AppointmentDate) as date) group by PatientId) w on  u.Id = w.PatientId group by u.SiteId

) c on site.Id = c.site
join (select TxCurrTarget, TxNewTarget, FiscalYear, SiteId from SiteTxTarget where (FiscalYear >= year(@start) and FiscalYear <= year(@end))) t on site.Id = t.SiteId
 group by site.Id, site.Name, site.StateCode, t.TxCurrTarget, t.FiscalYear
END
GO
/****** Object:  StoredProcedure [dbo].[stGetTxNewByPeriod]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stGetTxNewByPeriod]
	-- Add the parameters for the stored procedure here
	@startDate date,
	@endDate date,
	@pageNumber as int,
	@itemsPerPage as int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
declare @start date = cast(@startDate as date);
declare @end date = cast(@endDate as date);

select site.Id as sId, site.Name as site, site.StateCode as code, sum(total) as total, sum(txNew) as txNew, t.TxNewTarget, t.FiscalYear
from
    (select Id, Name, StateCode from Site s join (select SiteId from Patient group by SiteId having count(distinct SiteId) > 0 ) d on s.Id = d.SiteId order by Id offset  ((@pageNumber-1 )*@itemsPerPage)  rows fetch next @itemsPerPage rows only) as site

 right join 
 (

 select
        count(u.Id) as total, count(nc.PatientId) as txNew, u.SiteId as site

		from

	(select Id, SiteId from Patient p)as u

    left outer join 
	
	(select distinct PatientId from ArtBaseline where ArtDate >= @start and ArtDate <= @end) nc on u.Id = nc.PatientId
	group by u.SiteId

) c on site.Id = c.site
join (select TxNewTarget, FiscalYear, SiteId from SiteTxTarget where (FiscalYear >= year(@start) and FiscalYear <= year(@end))) t on site.Id = t.SiteId
 group by site.Id, site.Name, site.StateCode, t.TxNewTarget, t.FiscalYear
END
GO
/****** Object:  StoredProcedure [dbo].[stGetUsers]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stGetUsers] 
	-- Add the parameters for the stored procedure here
	@pageNumber as int,
	@itemsPerPage as int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
select * from AspNetUsers order by FirstName desc  offset  ((@pageNumber-1 )*@itemsPerPage)  rows fetch next @itemsPerPage rows only
END
GO
/****** Object:  StoredProcedure [dbo].[stGetViralSuppressionByPeriod]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stGetViralSuppressionByPeriod] 
	@startDate date,
	@endDate date,
	@pageNumber as int,
	@itemsPerPage as int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
declare @start date = cast(@startDate as date);
declare @end date = cast(@endDate as date);

select site.Id as sId, site.Name as site, site.StateCode as code, sum(active) as active,sum(suppressed) as suppressed, t.FiscalYear
from
    (select Id, Name, StateCode from Site s join (select SiteId from Patient group by SiteId having count(distinct SiteId) > 0 ) d on s.Id = d.SiteId order by Id offset  ((@pageNumber-1 )*@itemsPerPage)  rows fetch next @itemsPerPage rows only) as site

 right join 
 (
  select
        count(w.PatientId) as active, count(h.PatientId) as suppressed , u.SiteId as site

		from

	(select Id, SiteId from Patient p)as u

    inner join 
	
	(select distinct PatientId from ArtBaseline) nc on u.Id = nc.PatientId
	
	 left outer join 
	
(select distinct PatientId, max(AppointmentDate) d from ArtVisit g where @start <= cast(dateadd(day, 28, AppointmentDate) as date) and @end <= cast(dateadd(day, 28, AppointmentDate) as date) group by PatientId) w on  u.Id = w.PatientId

left outer join 

(select o.PatientId
from (select o.PatientId,
             row_number() over (partition by PatientId order by TestDate desc) as seqnum
      from LabResult o where o.TestDate >= @start and o.TestDate <= @end
     ) o

where seqnum = 1)h on u.Id = h.PatientId

	group by u.SiteId

) c on site.Id = c.site
join (select TxNewTarget, FiscalYear, SiteId from SiteTxTarget where (FiscalYear >= year(@start) and FiscalYear <= year(@end))) t on site.Id = t.SiteId
 group by site.Id, site.Name, site.StateCode, t.FiscalYear
END
GO
/****** Object:  StoredProcedure [dbo].[stInsertArtVisit]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stInsertArtVisit]
	-- Add the parameters for the stored procedure here
	@dtArtVisit ArtVisitInfo readonly,
    @outputMessage NVARCHAR(MAX) OUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	BEGIN TRY
         BEGIN TRANSACTION [stInsertArtVisit]	
    -- Insert statements for procedure here
	insert into ArtVisit(IdNo,VisitDate,Weight,Height,Temperature,WhoStage,IsPregnant,TbScreen,TbDiagnosedTreatment,TbTreatmentStarted,CotrimeProphylaxis,ArtStarted,ArvRegisterationCode,ArvAdherenceCode,ArvNonAdherenceCode,DrugReactionCode,ArvStopCode,ArvStopDate,Cd4Count,BloodPressure,FamilyPlanningCode,AppointmentDate,StatusCode,SiteId,PatientId) select IdNo,VisitDate,Weight,Height,Temperature,WhoStage,IsPregnant,TbScreen,TbDiagnosedTreatment,TbTreatmentStarted,CotrimeProphylaxis,ArtStarted,ArvRegisterationCode,ArvAdherenceCode,ArvNonAdherenceCode,DrugReactionCode,ArvStopCode,ArvStopDate,Cd4Count,BloodPressure,FamilyPlanningCode,AppointmentDate,StatusCode,SiteId,(select top 1 Id from Patient where EnrolmentId = a.EnrolmentId and SiteId = a.SiteId) from @dtArtVisit a where exists(select top 1 Id from Patient where EnrolmentId = a.EnrolmentId and SiteId = a.SiteId);
	
	SET @outputMessage = 'success'; 
	
	COMMIT Transaction
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION [stInsertArtVisit];  

        SELECT  
            'Error - Rollbacked -' AS CustomMessage,
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_SEVERITY() AS ErrorSeverity,
            ERROR_STATE() AS ErrorState,
            ERROR_PROCEDURE() AS ErrorProcedure,
            ERROR_LINE() AS ErrorLine,
            ERROR_MESSAGE() AS ErrorMessage;  
           SET @outputMessage = 'error - ' + ERROR_MESSAGE();
    END CATCH   
END
GO
/****** Object:  StoredProcedure [dbo].[stInsertBaseline]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[stInsertBaseline] 
	-- Add the parameters for the stored procedure here
	@dtArtBaseline ArtBaselineInfo readonly,
    @outputMessage NVARCHAR(MAX) OUT
	
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
	set transaction isolation level serializable
        BEGIN TRANSACTION		 

		MERGE ArtBaseline  WITH (HOLDLOCK) AS a

		-- processes the rows of the tvp but first determining if a corresponding patient with 
		-- matching EnrolmentId and SiteId exists in the Patient table.
		-- If Patient exists, use their Id as 'b.e' when inserting their baseline fresh
		USING (SELECT * FROM @dtArtBaseline f join (select Id e, SiteId s, EnrolmentId r from Patient)g on f.EnrolmentId = g.r and f.SiteId = g.s) AS b		
		
		ON a.EnrolmentId = b.EnrolmentId AND a.SiteId = b.SiteId

		WHEN MATCHED THEN 
		
		UPDATE SET 		
		a.HivConfirmationDate = b.HivConfirmationDate, 
		a.EnrolmentDate = b.EnrolmentDate, 
		a.ArtDate = b.ArtDate, 
		a.DispositionDate = b.DispositionDate, 
		a.DispositionCode = b.DispositionCode
		
		WHEN NOT MATCHED by target THEN
		
		INSERT(EnrolmentId, IdNo,HivConfirmationDate,EnrolmentDate,ArtDate,DispositionDate,DispositionCode,SiteId, PatientId)
		VALUES(b.EnrolmentId, b.IdNo,b.HivConfirmationDate, b.EnrolmentDate,b.ArtDate,b.DispositionDate,b.DispositionCode,b.SiteId, b.e);
		
          SET @outputMessage = 'success';   
		 COMMIT Transaction
    END TRY
    BEGIN CATCH
		SET @outputMessage = 'error - ' + ERROR_MESSAGE();
		DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
		RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[stInsertLabResult]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stInsertLabResult]
	-- Add the parameters for the stored procedure here
	@dtLabResult LabResultInfo readonly,
    @outputMessage NVARCHAR(MAX) OUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from	
	SET NOCOUNT ON;
	BEGIN TRY
	-- interfering with SELECT statements.
         BEGIN TRANSACTION [stInsertLabResult]
    -- Insert statements for procedure here
	insert into LabResult(IdNo,LabNumber,Description,TestGroup,TestResult,TestDate,DateReported,SiteId, PatientId) 
	select l.IdNo,l.LabNumber,l.Description,l.TestGroup,l.TestResult,l.TestDate,l.DateReported,l.SiteId,(select top 1 Id from Patient where EnrolmentId = l.EnrolmentId and SiteId = l.SiteId) from @dtLabResult l where exists(select top 1 Id from Patient where EnrolmentId = l.EnrolmentId and SiteId = l.SiteId)
	
	SET @outputMessage = 'success'; 	
	COMMIT Transaction
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION [stInsertLabResult];  

        SELECT  
            'Error - Rollbacked -' AS CustomMessage,
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_SEVERITY() AS ErrorSeverity,
            ERROR_STATE() AS ErrorState,
            ERROR_PROCEDURE() AS ErrorProcedure,
            ERROR_LINE() AS ErrorLine,
            ERROR_MESSAGE() AS ErrorMessage;  
           SET @outputMessage = 'error - ' + ERROR_MESSAGE();
    END CATCH   
END
GO
/****** Object:  StoredProcedure [dbo].[stInsertPaedVisits]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stInsertPaedVisits] 
	-- Add the parameters for the stored procedure here

	@dtArtVisit ArtPaedVisit readonly,
    @outputMessage NVARCHAR(MAX) OUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	BEGIN TRY
         BEGIN TRANSACTION [stInsertPaedVisits]

    -- Insert statements for procedure here
	insert into ArtVisit(IdNo,VisitDate,Weight,WhoStage,TbScreen,TbDiagnosed,TbSuspected,TbTreatmentReceived,ReceivingContrime,ArtStarted,ArvRegimenCode,ArvAdherenceCode,ArvNonAdherenceCode,ArvRegimen1,ArvRegimen2,ArvRegimen3,ArvStopCode,ArvStopDate,AppointmentDate,AdvDrugCode,SiteId,PatientId) select q.IdNo,q.VisitDate,q.Weight,q.WhoStage,q.TbScreen,q.TbDiagnosed,q.TbSuspected,q.TbTreatmentReceived,q.ReceivingContrime,q.ArtStarted,q.ArvRegimenCode,q.ArvAdherenceCode,q.ArvNonAdherenceCode,q.ArvRegimen1,q.ArvRegimen2,q.ArvRegimen3,q.ArvStopCode,q.ArvStopDate,q.AppointmentDate,q.AdvDrugCode,q.SiteId, (select top 1 Id from Patient where EnrolmentId = q.EnrolmentId and SiteId = q.SiteId) from @dtArtVisit q where exists(select top 1 Id from Patient where EnrolmentId = q.EnrolmentId and SiteId = q.SiteId)
	
	SET @outputMessage = 'success'; 	
	COMMIT Transaction
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION [stInsertPaedVisits];  

        SELECT  
            'Error - Rollbacked -' AS CustomMessage,
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_SEVERITY() AS ErrorSeverity,
            ERROR_STATE() AS ErrorState,
            ERROR_PROCEDURE() AS ErrorProcedure,
            ERROR_LINE() AS ErrorLine,
            ERROR_MESSAGE() AS ErrorMessage;  
           SET @outputMessage = 'error - ' + ERROR_MESSAGE();
    END CATCH   
END
GO
/****** Object:  StoredProcedure [dbo].[stInsertPatients]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Henry Otuadinma>
-- Create date: <01/08/2019>
-- Description:	<Inserts a list of patients using SqlRecord as a tvp>
-- =============================================
CREATE PROCEDURE  [dbo].[stInsertPatients]
	-- Add the parameters for the stored procedure here
	@dtPatients PatientInfo readonly,
    @outputMessage NVARCHAR(MAX) OUT
	--@rowsAffected int OUT
	
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
	set transaction isolation level serializable
         BEGIN TRANSACTION		 
		 
		MERGE Patient WITH (HOLDLOCK) AS a
		USING (SELECT * FROM @dtPatients) AS p		
		ON a.EnrolmentId = p.EnrolmentId AND a.SiteId = p.SiteId
		WHEN MATCHED THEN 
		
		UPDATE SET 		
		a.FirstName = p.FirstName, 
		a.LastName = p.LastName, 
		a.VisitDate = p.VisitDate, 
		a.DateOfBirth = p.DateOfBirth, 
		a.Age = p.Age, 
		a.Sex = p.Sex, 
		a.Village = p.Village, 
		a.Town = p.Town, 
		a.PhoneNumber = p.PhoneNumber, 
		a.AddressLine1 = p.AddressLine1,  
		a.Lga = p.Lga, 
		a.MaritalStatus = p.MaritalStatus, 
		a.PreferredLanguage = p.PreferredLanguage

		WHEN NOT MATCHED by target THEN
		INSERT(FirstName, LastName, EnrolmentId, IdNo, VisitDate, StateId, SiteId, DateOfBirth, Age, Sex, Village, Town, PhoneNumber, AddressLine1, State, Lga, MaritalStatus, PreferredLanguage)
		VALUES(p.FirstName, p.LastName, p.EnrolmentId, p.IdNo, p.VisitDate, p.StateId, p.SiteId, p.DateOfBirth, p.Age, p.Sex, p.Village, p.Town, p.PhoneNumber, p.AddressLine1, p.State, p.Lga, p.MaritalStatus, p.PreferredLanguage);

          SET @outputMessage = 'success';   
		 COMMIT Transaction
    END TRY
    BEGIN CATCH
		SET @outputMessage = 'error - ' + ERROR_MESSAGE();
		DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
		RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[stpGetClientStatsByStates]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Henry Otuadinma
-- Create date: 14/07/2019
-- Description:	Gets total, active, inactive, LTFU, and new clients in each state
-- =============================================
CREATE PROCEDURE [dbo].[stpGetClientStatsByStates] 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

declare @today as date = cast(getdate() as date);

select site.StateCode as stateCode, sum(total) as total, sum(active) as active, sum(inActive) as inActive, sum(loss) as loss, sum(tx_new) as tx_new
FROM
    (select Id, StateCode from Site s where exists (select SiteId = s.Id from Patient))as site 
 right JOIN 
 (

 SELECT
        count(u.Id) as total, sum(w.a) as active, sum(w.i) as inActive, sum(w.l) as loss, sum(r.nc) as tx_new, u.SiteId as site

		from

    (select Id, SiteId from Patient p where exists (select PatientId = p.Id from ArtBaseline))as u

    left outer join 
	
	(select sum(case when year(v.d) = year(@today) and ((((month(dateadd(month, -9, v.d))) + 2)/3) = (((month(dateadd(month, -9, @today))) + 2)/3)) then 1 else 0 end) as nc, PatientId 
from (select distinct PatientId, ArtDate as d from ArtBaseline group by PatientId, ArtDate) as v group by PatientId) r on u.Id = r.PatientId

   left outer join

	(select sum(case when (@today <= cast(dateadd(day, 28, h.d) as date)) then 1 else 0 end) as a, 
sum(case when ((@today > cast(dateadd(day, 28, h.d) as date)) and (@today <= cast(dateadd(day, 90, h.d) as date))) then 1 else 0 end) as i,
sum(case when (@today >  cast(dateadd(day, 90, h.d) as date)) then 1 else 0 end) as l, PatientId 
from (select distinct PatientId, max(AppointmentDate) as d from ArtVisit group by PatientId) as h group by h.PatientId)
w on  u.Id = w.PatientId group by u.SiteId
) c on site.Id = c.site group by site.StateCode

END
GO
/****** Object:  StoredProcedure [dbo].[stSearchUsers]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stSearchUsers]
	-- Add the parameters for the stored procedure here
	@pageNumber as int,
	@itemsPerPage as int,
	@searchTerm as nvarchar(MAX)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select * from AspNetUsers where (FirstName like '%' + @searchTerm + '%') or (LastName like '%' + @searchTerm + '%')  order by FirstName desc  offset  ((@pageNumber-1 )*@itemsPerPage)  rows fetch next @itemsPerPage rows only
END
GO
/****** Object:  StoredProcedure [dbo].[stTxCurrAgeSexByPeriod]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stTxCurrAgeSexByPeriod] 
	-- Add the parameters for the stored procedure here
	@startDate date,
	@endDate date,
	@pageNumber as int,
	@itemsPerPage as int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	declare @start date = cast(@startDate as date);
	declare @end date = cast(@endDate as date);
	declare @today as date = cast(getdate() as date);
	
select site.Id as id, site.Name as site, site.StateCode as stateCode, c.patient as patient, c.age as age, c.gender as gender
from
    (select Id, Name, StateCode from Site s join (select SiteId from Patient group by SiteId having count(distinct SiteId) > 0 ) d on s.Id = d.SiteId order by Id offset  ((@pageNumber-1 )*@itemsPerPage)  rows fetch next @itemsPerPage rows only) as site

 right join 
 (

 select u.Id as patient, SiteId, datediff(year, cast(DateOfBirth as date), @today) as age, Sex as gender from
 
    (select distinct Id, DateOfBirth, Sex , SiteId from Patient s where exists (select distinct PatientId = s.Id from ArtBaseline))u

	inner join
	
(select distinct PatientId, max(AppointmentDate) as dt1 from ArtVisit where @start <= cast(dateadd(day, 28, AppointmentDate) as date) and @end <= cast(dateadd(day, 28, AppointmentDate) as date)  group by PatientId) n on u.Id = n.PatientId 
group by u.SiteId, u.Id, DateOfBirth, Sex
) c on site.Id = c.SiteId group by site.Id, site.Name, site.StateCode, c.patient, c.age, c.gender
END
GO
/****** Object:  StoredProcedure [dbo].[stTxNewAgeSexByPeriod]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stTxNewAgeSexByPeriod]
	-- Add the parameters for the stored procedure here
	@startDate date,
	@endDate date,
	@pageNumber as int,
	@itemsPerPage as int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	declare @start date = cast(@startDate as date);
	declare @end date = cast(@endDate as date);
	declare @today as date = cast(getdate() as date);
	
select site.Id as id, site.Name as site, site.StateCode as stateCode, c.patient as patient, c.age as age, c.gender as gender
from
    (select Id, Name, StateCode from Site s join (select SiteId from Patient group by SiteId having count(distinct SiteId) > 0 ) d on s.Id = d.SiteId order by Id offset  ((@pageNumber-1 )*@itemsPerPage)  rows fetch next @itemsPerPage rows only) as site

 right join 
 (

 select u.Id as patient, SiteId, datediff(year, cast(DateOfBirth as date), @today) as age, Sex as gender from
 
    (select distinct Id, DateOfBirth, Sex , SiteId from Patient s where exists (select distinct PatientId = s.Id from ArtBaseline))u

	inner join

	(select distinct PatientId from ArtBaseline where ArtDate >= @start and ArtDate <= @end) nc on u.Id = nc.PatientId
	
group by u.SiteId, u.Id, DateOfBirth, Sex

) c on site.Id = c.SiteId group by site.Id, site.Name, site.StateCode, c.patient, c.age, c.gender
END
GO
/****** Object:  StoredProcedure [dbo].[stVLoadAgeSexByPeriod]    Script Date: 06/08/2019 4:09:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stVLoadAgeSexByPeriod]
	-- Add the parameters for the stored procedure here
	@startDate date,
	@endDate date,
	@pageNumber as int,
	@itemsPerPage as int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	declare @start date = cast(@startDate as date);
	declare @end date = cast(@endDate as date);
	declare @today as date = cast(getdate() as date);
	
select site.Id as id, site.Name as site, site.StateCode as stateCode, c.patient as patient, c.age as age, c.gender as gender
from
    (select Id, Name, StateCode from Site s join (select SiteId from Patient group by SiteId having count(distinct SiteId) > 0 ) d on s.Id = d.SiteId order by Id offset  ((@pageNumber-1 )*@itemsPerPage)  rows fetch next @itemsPerPage rows only) as site

 right join 
 (

 select u.Id as patient, SiteId, datediff(year, cast(DateOfBirth as date), @today) as age, Sex as gender from
 
    (select distinct Id, DateOfBirth, Sex , SiteId from Patient s where exists (select distinct PatientId = s.Id from ArtBaseline))u

	inner join

	(select o.PatientId
from (select o.PatientId,
             row_number() over (partition by PatientId order by TestDate desc) as seqnum
      from LabResult o where o.TestDate >= @start and o.TestDate <= @end
     ) o

where seqnum = 1)h on u.Id = h.PatientId
	
group by u.SiteId, u.Id, DateOfBirth, Sex

) c on site.Id = c.SiteId group by site.Id, site.Name, site.StateCode, c.patient, c.age, c.gender
END
GO
USE [master]
GO
ALTER DATABASE [CDR] SET  READ_WRITE 
GO
