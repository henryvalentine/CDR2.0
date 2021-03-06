USE [master]
GO
/****** Object:  Database [CDR]    Script Date: 06/03/2020 2:18:34 PM ******/
CREATE DATABASE [CDR]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'CDR', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\CDR.mdf' , SIZE = 925696KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'CDR_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\CDR_log.ldf' , SIZE = 335872KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
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
ALTER DATABASE [CDR] SET AUTO_CLOSE ON 
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
/****** Object:  UserDefinedTableType [dbo].[ArtBaselineInfo]    Script Date: 06/03/2020 2:18:35 PM ******/
CREATE TYPE [dbo].[ArtBaselineInfo] AS TABLE(
	[EnrolmentId] [nvarchar](450) NULL,
	[IdNo] [int] NULL,
	[HivConfirmationDate] [datetime2](7) NULL,
	[EnrolmentDate] [datetime2](7) NULL,
	[ArtDate] [datetime2](7) NULL,
	[DispositionDate] [nvarchar](450) NULL,
	[DispositionCode] [nvarchar](450) NULL,
	[SiteId] [int] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[ArtPaedVisit]    Script Date: 06/03/2020 2:18:35 PM ******/
CREATE TYPE [dbo].[ArtPaedVisit] AS TABLE(
	[EnrolmentId] [nvarchar](450) NULL,
	[IdNo] [int] NULL,
	[VisitDate] [datetime2](7) NULL,
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
	[ArvStopDate] [datetime2](7) NULL,
	[AppointmentDate] [datetime2](7) NULL,
	[AdvDrugCode] [nvarchar](450) NULL,
	[SiteId] [int] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[ArtVisitInfo]    Script Date: 06/03/2020 2:18:35 PM ******/
CREATE TYPE [dbo].[ArtVisitInfo] AS TABLE(
	[EnrolmentId] [nvarchar](450) NULL,
	[IdNo] [int] NULL,
	[VisitDate] [datetime2](7) NULL,
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
	[ArvAdherenceCode] [nvarchar](450) NULL,
	[ArvNonAdherenceCode] [nvarchar](450) NULL,
	[DrugReactionCode] [nvarchar](450) NULL,
	[ArvStopCode] [nvarchar](450) NULL,
	[ArvStopDate] [datetime2](7) NULL,
	[Cd4Count] [nvarchar](450) NULL,
	[BloodPressure] [nvarchar](450) NULL,
	[FamilyPlanningCode] [nvarchar](450) NULL,
	[AppointmentDate] [datetime2](7) NULL,
	[StatusCode] [nvarchar](450) NULL,
	[SiteId] [int] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[LabResultInfo]    Script Date: 06/03/2020 2:18:35 PM ******/
CREATE TYPE [dbo].[LabResultInfo] AS TABLE(
	[EnrolmentId] [nvarchar](450) NULL,
	[IdNo] [nvarchar](450) NULL,
	[LabNumber] [nvarchar](450) NULL,
	[Description] [nvarchar](450) NULL,
	[TestGroup] [nvarchar](450) NULL,
	[TestResult] [nvarchar](450) NULL,
	[TestDate] [datetime2](7) NULL,
	[DateReported] [datetime2](7) NULL,
	[SiteId] [int] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[PatientInfo]    Script Date: 06/03/2020 2:18:35 PM ******/
CREATE TYPE [dbo].[PatientInfo] AS TABLE(
	[FirstName] [nvarchar](450) NULL,
	[LastName] [nvarchar](450) NULL,
	[EnrolmentId] [nvarchar](450) NULL,
	[IdNo] [int] NULL,
	[VisitDate] [datetime2](7) NULL,
	[StateId] [nvarchar](450) NULL,
	[SiteId] [int] NULL,
	[DateOfBirth] [datetime2](7) NULL,
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
/****** Object:  UserDefinedFunction [dbo].[RemoveNonNumericChars]    Script Date: 06/03/2020 2:18:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Function [dbo].[RemoveNonNumericChars](@string VarChar(1000))
Returns VarChar(1000)
AS
Begin

	WHILE PATINDEX('%[^0-9]%',@string) <> 0 SET @string = STUFF(@string,PATINDEX('%[^0-9]%',@string),1,'')

    Return @string
End
GO
/****** Object:  Table [dbo].[__EFMigrationsHistory]    Script Date: 06/03/2020 2:18:35 PM ******/
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
/****** Object:  Table [dbo].[AspNetRoleClaims]    Script Date: 06/03/2020 2:18:35 PM ******/
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
/****** Object:  Table [dbo].[AspNetRoles]    Script Date: 06/03/2020 2:18:35 PM ******/
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
/****** Object:  Table [dbo].[AspNetUserClaims]    Script Date: 06/03/2020 2:18:35 PM ******/
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
/****** Object:  Table [dbo].[AspNetUserLogins]    Script Date: 06/03/2020 2:18:35 PM ******/
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
/****** Object:  Table [dbo].[AspNetUserRoles]    Script Date: 06/03/2020 2:18:35 PM ******/
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
/****** Object:  Table [dbo].[AspNetUsers]    Script Date: 06/03/2020 2:18:35 PM ******/
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
/****** Object:  Table [dbo].[AspNetUserTokens]    Script Date: 06/03/2020 2:18:35 PM ******/
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
/****** Object:  Table [dbo].[FingerPrint]    Script Date: 06/03/2020 2:18:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FingerPrint](
	[Id] [bigint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[PatientId] [bigint] NOT NULL,
	[Source] [nvarchar](50) NULL,
	[Present] [bit] NOT NULL,
	[Hand] [int] NOT NULL,
	[Template] [nvarchar](max) NOT NULL,
	[FingerPosition] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_FingerPrint] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HivEncounter]    Script Date: 06/03/2020 2:18:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HivEncounter](
	[Id] [bigint] NOT NULL,
	[PatientId] [bigint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[VisitID] [bigint] NOT NULL,
	[VisitDate] [date] NOT NULL,
	[DurationOnArt] [int] NOT NULL,
	[Weight] [float] NULL,
	[ChildHeight] [float] NULL,
	[BloodPressure] [nvarchar](50) NULL,
	[FunctionalStatus] [nvarchar](20) NULL,
	[WHOClinicalStage] [nvarchar](5) NULL,
	[NextAppointmentDate] [date] NULL,
	[ARVDrugRegimenCode] [nvarchar](20) NULL,
	[ARVDrugRegimenDesc] [nvarchar](50) NULL,
 CONSTRAINT [PK_HivEncounter_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LaboratoryReport]    Script Date: 06/03/2020 2:18:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LaboratoryReport](
	[Id] [bigint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[PatientId] [bigint] NOT NULL,
	[VisitID] [bigint] NOT NULL,
	[VisitDate] [date] NULL,
	[CollectionDate] [date] NULL,
	[ARTStatusCode] [nvarchar](20) NULL,
	[OrderedTestDate] [date] NULL,
	[ResultedTestDate] [date] NULL,
	[LabResult] [float] NULL,
	[LabTestCode] [nvarchar](20) NULL,
	[LabTestDesc] [nvarchar](150) NULL,
 CONSTRAINT [PK_LaboratoryReport] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PatientDemography]    Script Date: 06/03/2020 2:18:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PatientDemography](
	[Id] [bigint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[SiteId] [int] NOT NULL,
	[EnrolleeCode] [nvarchar](50) NULL,
	[PatientDateOfBirth] [date] NULL,
	[PatientIdentifier] [nvarchar](50) NOT NULL,
	[PatientSexCode] [nvarchar](5) NULL,
	[FacilityID] [nvarchar](150) NOT NULL,
	[OtherIDNumber] [nvarchar](150) NULL,
	[OtherIDTypeCode] [nvarchar](50) NULL,
	[ConditionCode] [nvarchar](50) NULL,
	[AddressTypeCode] [nvarchar](50) NULL,
	[StateCode] [nvarchar](50) NULL,
	[CountryCode] [nvarchar](50) NULL,
	[ProgramAreaCode] [nvarchar](50) NULL,
	[FirstConfirmedHIVTestDate] [date] NULL,
	[ARTStartDate] [date] NULL,
	[TransferredOutStatus] [nvarchar](50) NULL,
	[EnrolledInHIVCareDate] [date] NULL,
	[HospitalNumber] [nvarchar](50) NULL,
	[DateOfFirstReport] [date] NULL,
	[DateOfLastReport] [date] NULL,
	[DiagnosisDate] [date] NULL,
	[PatientDieFromThisIllness] [bit] NOT NULL,
	[PatientAge] [int] NOT NULL,
 CONSTRAINT [PK_PatientDemography] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PatientRegimen]    Script Date: 06/03/2020 2:18:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PatientRegimen](
	[Id] [bigint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[PatientId] [bigint] NOT NULL,
	[VisitID] [bigint] NOT NULL,
	[VisitDate] [date] NULL,
	[PrescribedRegimenCode] [nvarchar](20) NULL,
	[PrescribedRegimenDesc] [nvarchar](150) NULL,
	[PrescribedRegimenTypeCode] [nvarchar](50) NULL,
	[PrescribedRegimenLineCode] [nvarchar](50) NULL,
	[PrescribedRegimenDuration] [int] NOT NULL,
	[PrescribedRegimenDispensedDate] [date] NULL,
	[DateRegimenStarted] [date] NULL,
	[DateRegimenEnded] [nchar](10) NULL,
	[PrescribedRegimenInitialIndicator] [nvarchar](20) NULL,
	[SubstitutionIndicator] [nvarchar](20) NULL,
	[SwitchIndicator] [nvarchar](20) NULL,
 CONSTRAINT [PK_PatientRegimen] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Regimen]    Script Date: 06/03/2020 2:18:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Regimen](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Combination] [nvarchar](250) NOT NULL,
	[Code] [nvarchar](50) NOT NULL,
	[Line] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Regimen] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Site]    Script Date: 06/03/2020 2:18:35 PM ******/
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
/****** Object:  Table [dbo].[SiteTxTarget]    Script Date: 06/03/2020 2:18:35 PM ******/
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
/****** Object:  Table [dbo].[State]    Script Date: 06/03/2020 2:18:35 PM ******/
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
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20190726232935_CreateIdentitySchema', N'2.2.6-servicing-10079')
INSERT [dbo].[AspNetRoles] ([Id], [Name], [NormalizedName], [ConcurrencyStamp]) VALUES (N'1', N'Admin', NULL, NULL)
INSERT [dbo].[AspNetRoles] ([Id], [Name], [NormalizedName], [ConcurrencyStamp]) VALUES (N'2', N'Management', NULL, NULL)
INSERT [dbo].[AspNetRoles] ([Id], [Name], [NormalizedName], [ConcurrencyStamp]) VALUES (N'3', N'User', NULL, NULL)
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'd570945c-1314-4615-b162-f62b13e8abba', N'1')
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'0f8b30e3-0f5b-418c-93eb-c2e13016a1e0', N'3')
INSERT [dbo].[AspNetUsers] ([Id], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount], [FirstName], [LastName]) VALUES (N'0f8b30e3-0f5b-418c-93eb-c2e13016a1e0', N'cdruser@cihpng.org', NULL, N'cdruser@cihpng.org', NULL, 1, N'AK0xEPwZVdPOmbg/AWcQdoIyk9d0BDZm6BuikEYSVfINuIrh9ydRrzeOVe6TTNxfOg==', N'4d64069d-efde-453f-937a-e7bb59e83be7', NULL, NULL, 0, 0, NULL, 0, 0, N'John', N'Doe')
INSERT [dbo].[AspNetUsers] ([Id], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount], [FirstName], [LastName]) VALUES (N'd570945c-1314-4615-b162-f62b13e8abba', N'cdr@cihpng.org', NULL, N'cdr@cihpng.org', NULL, 1, N'AK0xEPwZVdPOmbg/AWcQdoIyk9d0BDZm6BuikEYSVfINuIrh9ydRrzeOVe6TTNxfOg==', N'e9167314-f20c-47ba-acdf-f23b50d596bf', NULL, NULL, 0, 0, NULL, 0, 0, N'Henry', N'Otuadinma')
SET IDENTITY_INSERT [dbo].[Regimen] ON 

INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (1, N'TDF+3TC+EFV', N'1a', N'Adult First Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (2, N'TDF+FTC+EFV', N'1a-i', N'Adult First Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (3, N'TDF+3TC+DTG', N'1b', N'Adult First Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (4, N'TDF+FTC+DTG', N'1b-i', N'Adult First Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (5, N'AZT+3TC+NVP', N'1c', N'Adult First Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (6, N'AZT+3TC+EFV', N'1c-i', N'Adult First Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (7, N'TDF+3TC+EFV', N'1d', N'Adult First Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (8, N'TDF+FTC+EFV', N'1d-i', N'Adult First Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (9, N'ABC+3TC+EFV', N'1e', N'Adult First Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (10, N'TDF+3TC+NVP', N'1f', N'Adult First Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (11, N'TDF+FTC+NVP', N'1e-i', N'Adult First Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (12, N'AZT+3TC+LPV/R', N'2a', N'Adult Second Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (13, N'AZT+3TC+ATV/R', N'2b', N'Adult Second Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (14, N'TDF+3TC+ATV/R', N'2c', N'Adult Second Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (15, N'TDF+3TC+LPV/R', N'2d', N'Adult Second Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (16, N'AZT+TDF+3TC+ATV/R', N'2e', N'Adult Second Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (17, N'AZT+TDF+3TC+LPV/R', N'2f', N'Adult Second Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (18, N'DRV/R+DTG+(1-2)NRTIs', N'3a', N'Adult Third Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (19, N'DRV/R+2NRTIs+NNRTI', N'3b', N'Adult Third Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (20, N'DRV/R+2NRTIs-NNRTI', N'3b-i', N'Adult Third Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (21, N'DRV/R+DTG-(1-2)NRTIs', N'3a-i', N'Adult Third Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (22, N'TDF+3TC+EFV', N'4a', N'Paed. First Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (23, N'TDF+FTC+EFV', N'4a-i', N'Paed. First Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (24, N'TDF+3TC+DTG', N'4b', N'Paed. Second Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (25, N'TDF+FTC+DTG', N'4b-i', N'Paed. First Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (26, N'TDF+3TC+EFV400', N'4c', N'Paed. First Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (27, N'TDF+FTC+EFV400', N'4c-i', N'Paed. First Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (28, N'AZT+3TC+NPV', N'4d', N'Paed. First Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (29, N'AZT+3TC+EFV', N'4d-i', N'Paed. First Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (30, N'ABC+3TC+DTG', N'4e', N'Paed. First Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (31, N'ABC+FTC+DTG', N'4e-i', N'Paed. First Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (32, N'ABC+3TC+EFV400', N'4f', N'Paed. First Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (33, N'ABC+FTC+EFV400', N'4f-i', N'Paed. First Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (34, N'TDF+3TC+NVP', N'4g', N'Paed. First Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (35, N'TDF+FTC+NVP', N'4g-i', N'Paed. First Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (36, N'ABC+3TC+NVP', N'4h', N'Paed. First Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (37, N'ABC+FTC+NVP', N'4h-i', N'Paed. First Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (38, N'ABC+3TC+EFV', N'4i', N'Paed. First Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (39, N'ABC+3TC+LPV/R', N'4j', N'Paed. First Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (40, N'AZT+3TC+LPV/R', N'4k', N'Paed. First Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (41, N'TDF+3TC+EFV', N'4l', N'Paed. First Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (42, N'TDF+FTC+EFV', N'4l-i', N'Paed. First Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (43, N'AZT+3TC+RAL', N'4m', N'Paed. First Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (44, N'AZT+3TC+LPV/R', N'5a', N'Paed Second Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (45, N'AZT+3TC+ATV/R', N'5b', N'Paed. Second Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (46, N'TDF+3TC+ATV/R', N'5c', N'Paed. Second Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (47, N'TDF+3TC+LPV/R', N'5d', N'Paed. Second Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (48, N'AZT+3TC+RAL', N'5e', N'Paed. Second Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (49, N'ABC+3TC+RAL', N'5e-i', N'Paed. Second Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (50, N'AZT+3TC+LPV/R', N'5f', N'Paed. Second Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (51, N'ABC+3TC+LPV/R', N'5g', N'Paed. Second Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (52, N'DRV/R+DTG+(1-2)NRTIs', N'6a', N'Paed. Third Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (53, N'DRV/R+2NRTIs+NNRTI', N'6b', N'Paed. Third Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (54, N'DRV/R+2NRTIs-NNRTI', N'6b-i', N'Paed. Third Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (55, N'RAL+2NRTIs', N'6c', N'Paed. Third Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (56, N'DTG+2NRTIs', N'6c-i', N'Paed. Third Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (57, N'DRV/R+2NRTIs', N'6d', N'Paed. Third Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (58, N'DRV/R+RAL+(1-2)NRTIs', N'6e', N'Paed. Third Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (59, N'DRV/R+RAL-(1-2)NRTIs', N'6e-i', N'Paed. Third Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (60, N'DRV/R+DTG+(1-2)NRTIs ', N'6e-ii', N'Paed. Third Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (61, N'DRV/R+DTG-(1-2)NRTIs ', N'6e-iii', N'Paed. Third Line')
INSERT [dbo].[Regimen] ([Id], [Combination], [Code], [Line]) VALUES (62, N'DRV/R+DTG-(1-2)NRTIs', N'6a-i', N'Paed. Third line')
SET IDENTITY_INSERT [dbo].[Regimen] OFF
SET IDENTITY_INSERT [dbo].[Site] ON 

INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (1, N'Bogo Model Primary Health Center', NULL, N'GB        ', N'hnu8aVM6eMV', 1)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (2, N'Garun Kurama Primary Health Center', NULL, N'KD        ', N'XyGNdts89ji', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (3, N'Jingir Primary Health Center', NULL, N'KD        ', N'Y8LrXkR1LuJ', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (4, N'Kaki Dare Primary Health Center', NULL, N'KD        ', N'bicj8vjb7BV', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (5, N'Krosha Maternal Child Health', NULL, N'KD        ', N's7dVL9iRI0l', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (6, N'Lere Primary Health Center', NULL, N'KD        ', N'Eq0SMoSZuRc', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (7, N'Ramin Kura Primary Health Center', NULL, N'KD        ', N'FIyoBlcRtsm', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (8, N'Saminaka General Hospital', NULL, N'KD        ', N'XCixcBgl6uz', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (9, N'Yarkasuwa Primary Health Center', NULL, N'KD        ', N'iiN0GpCCS79', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (10, N'Gazara Primary Health Center', NULL, N'KD        ', N'nu9c0w9q0CA', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (11, N'Gwanki Primary Health Center', NULL, N'KD        ', N'Rkng2n9u1rk', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (12, N'Kasuwar Mata Primary Health Center', NULL, N'KD        ', N'qwEWFTHOXSA', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (13, N'Makarfi General Hospital', NULL, N'KD        ', N'QuiAPHqPxwY', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (14, N'Makarfi Primary Health Center', NULL, N'KD        ', N'uEhcBbwErng', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (15, N'Mayere Primary Health Center', NULL, N'KD        ', N'n19QNSdO3Yu', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (16, N'Tashan Yari Primary Health Center', NULL, N'KD        ', N'GcbMxeF89uA', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (17, N'Major Ibrahim Bello Abdullahi Memorial Hospital', NULL, N'KD        ', N'nDa1uUKmVhb', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (18, N'Akwankwa Health Center', NULL, N'KD        ', N'BaBLiZhRPoS', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (19, N'Combila Health Center', NULL, N'KD        ', N'GDk0Y7jIeAz', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (20, N'Evangelical Reformed Church of Christ (ERCC) Primary Health Center - Karshi', NULL, N'KD        ', N'FSeEcYTr3h8', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (21, N'Gwantu General Hospital', NULL, N'KD        ', N'CXY35SPtbPf', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (22, N'Gwantu Primary Health Center', NULL, N'KD        ', N'HwVtJkZK6mX', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (23, N'Evangelical Church of West Africa (ECWA) Health Clinic - Mariri', NULL, N'KD        ', N'P6wb6qxR4rk', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (24, N'Evangelical Church of West Africa (ECWA) Comprehensive Health Center - Ungwan Bawa', NULL, N'KD        ', N'IO38n1uX0Z7', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (25, N'Angwan Bawa Primary Health Center', NULL, N'KD        ', N'Oe98Skgwrs3', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (26, N'Abadawa Primary Health Center', NULL, N'KD        ', N'rmUzUVT7bwW', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (27, N'Yusuf Dantsoho Memorial Hospital', NULL, N'KD        ', N'pt20jaMEKHx', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (28, N'Jere Primary Health Center', NULL, N'KD        ', N'k9ShWQ2CK5c', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (29, N'Kagarko General Hospital', NULL, N'KD        ', N'A5a1HEarbxU', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (30, N'Kagarko Primary Health Center', NULL, N'KD        ', N'pyCjMH0xPyt', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (31, N'Taffa Health Center', NULL, N'KD        ', N'uDPDgMxSdDU', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (32, N'Idon Rural Hospital', NULL, N'KD        ', N'mMBatyNbrv0', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (33, N'Mararaba Rido Primary Health Center', NULL, N'KD        ', N'Dg2qT9iJTaq', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (34, N'Evangelical Church of West Africa (ECWA) Health Center - Kagoro', NULL, N'KD        ', N'Q08WuqBqOrs', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (35, N'Kaura Rural Hospital', NULL, N'KD        ', N'NOFJMZXfbFx', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (36, N'Laruth Health Facility', NULL, N'KD        ', N'VSapwRuy9o3', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (37, N'Karshi Daji Health Center', NULL, N'KD        ', N'hduP3AR3vqA', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (38, N'Manchok Maternal and Child Health Clinic', NULL, N'KD        ', N'aGArDGnLt5O', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (39, N'Damakasuwa Health Clinic', NULL, N'KD        ', N'HneMVa1g1rl', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (40, N'Dandaura Primary Health Center', NULL, N'KD        ', N'Vm4aGg3q90l', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (41, N'Kauru Primary Health Center', NULL, N'KD        ', N'cDo6JpmV6bP', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (42, N'Kauru Rural Hospital', NULL, N'KD        ', N'GRhndXkuvmD', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (43, N'Kidugu II Model Primary Health Center', NULL, N'KD        ', N'DzcxGhh17ZF', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (44, N'Anchau Primary Health Center', NULL, N'KD        ', N'bWhHCsWrqie', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (45, N'Church of Christ in Nigeria (COCIN) Clinic and Maternity - Mararaba Kaduna', NULL, N'KD        ', N'bpGqH11T26K', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (46, N'Pambegua General Hospital', NULL, N'KD        ', N'PoIQpdF8RTG', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (47, N'Pambegua Health Clinic', NULL, N'KD        ', N'XSyW7R4zeNp', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (48, N'Hunkuyi General Hospital', NULL, N'KD        ', N'XRzMMtgxpMU', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (49, N'Turaki Buga Memorial Hospital', NULL, N'KD        ', N'VYk8FuLG2G1', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (50, N'Virtual Hospital', NULL, N'KD        ', N'kz6Rbf9tmeF', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (51, N'Mayir Primary Health Center', NULL, N'KD        ', N'iY9AWY5Juy5', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (52, N'Maigana General Hospital', NULL, N'KD        ', N'fEZq6XgTLT2', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (53, N'St. Luke''s Clinic - Egume', NULL, N'KG        ', N'HrGggd9x1os', 3)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (54, N'Idah General Hospital', NULL, N'KG        ', N'PawBgipJAZe', 3)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (55, N'Ajaka Primary Health Center', NULL, N'KG        ', N'g6NVwIeNfgD', 3)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (56, N'Iyamoye General Hospital', NULL, N'KG        ', N'UfIvllU0iwE', 3)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (57, N'Iyara Comprehensive Health Center', NULL, N'KG        ', N'W81ILVochtJ', 3)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (58, N'Kabba General Hospital', NULL, N'KG        ', N'CGwIyxDpwT8', 3)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (59, N'St John''s Hospital Kabba', NULL, N'KG        ', N'EOO49s5EOt4', 3)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (60, N'Almumin Hospital', NULL, N'KG        ', N'K2Dy4I3wcn9', 3)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (61, N'Gegu Beki Primary Health Center', NULL, N'KG        ', N'RWUuGmSxMC8', 3)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (62, N'Ideal Hospital - Koton-Karfe', NULL, N'KG        ', N'ebtsGbWllYg', 3)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (63, N'Koton-Karfe General Hospital', NULL, N'KG        ', N'KzgNOUrEB8m', 3)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (64, N'Kogi State Specialist Hospital', NULL, N'KG        ', N'Aq2CeR3h187', 3)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (65, N'Lokoja Federal Medical Center', NULL, N'KG        ', N'KsNbhiCMPvu', 3)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (66, N'Holley Memorial - Ochadamu', NULL, N'KG        ', N'aMZiWfMiJd9', 3)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (67, N'Ugwolawo General Hospital', NULL, N'KG        ', N'mf9bRBuufwN', 3)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (68, N'Ogori General Hospital', NULL, N'KG        ', N'H7M8CLeCiXD', 3)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (69, N'Obangede General Hospital', NULL, N'KG        ', N'YxjPfHv2bdg', 3)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (70, N'Nagazi Clinic', NULL, N'KG        ', N'rlB4mUoaEdr', 3)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (71, N'Okene General Hospital', NULL, N'KG        ', N'sKytXCdZsh5', 3)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (72, N'Okengwe General Hospital', NULL, N'KG        ', N'CLVU561R6tp', 3)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (73, N'Okpo General Hospital', NULL, N'KG        ', N'h9drujCcifQ', 3)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (74, N'Maria Goretti Hospital', NULL, N'KG        ', N'riZZbajMMKD', 3)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (75, N'Kogi Diagnosis Referral Hospital', NULL, N'KG        ', N'Qiq81djsOyv', 3)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (76, N'Grimmard Hospital - Anyingba', NULL, N'KG        ', N'nlLwNEPKFnR', 3)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (77, N'Egume General Hospital', NULL, N'KG        ', N'KkDXS9Qv3oE', 3)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (78, N'St. Louis Hospital - Zonkwa', NULL, N'KD        ', N'uYxACgpJgI9', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (79, N'Zango-Kataf General Hospital', NULL, N'KD        ', N'jHjDEUVD87x', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (80, N'Anna-Kitcher Hospital', NULL, N'KD        ', N'LOJ8j4vLoJZ', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (81, N'Hajiya Gambo Sawaba Hospital', NULL, N'KD        ', N'V0IswqM1byH', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (82, N'National Tuberculosis And Leprosy Training Center - Zaria', NULL, N'KD        ', N'lLdc7dRUqzs', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (83, N'Tukur Tukur Primary Health Center', NULL, N'KD        ', N'o4cmDXLnMGz', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (84, N'Aimoizza Clinic', NULL, N'KG        ', N'oyiQ8ltpF2c', 3)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (85, N'Ogaminana Clinic - Adavi', NULL, N'KG        ', N'e5aGNsUPSvn', 3)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (86, N'Ajaokuta Steel Medical Clinic', NULL, N'KG        ', N'CzwWiALrME8', 3)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (87, N'Ankpa General Hospital', NULL, N'KG        ', N'mJgQrfBTx3f', 3)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (88, N'Nimbe Health Center', NULL, N'KD        ', N'tVjg7MfEpfY', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (89, N'Ankpa Primary Health Center', NULL, N'KG        ', N'DaTMu3rYeQK', 3)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (90, N'Emere Primary Health Center', NULL, N'KG        ', N'wHuOS6cG6Sr', 3)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (91, N'Ika Christian Hospital', NULL, N'KG        ', N'Et6wjYLz9Sj', 3)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (92, N'Living Hope Hospital', NULL, N'KG        ', N'CFi2osDSAQt', 3)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (93, N'Madonna Hospital', NULL, N'KG        ', N'PYnrIREwfpU', 3)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (94, N'Ojapata Primary Health Center', NULL, N'KG        ', N'aYbTGRJerjM', 3)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (95, N'Oguma General Hospital', NULL, N'KG        ', N'LVbNrbnD8x5', 3)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (96, N'All Stars Clinic - Egume', NULL, N'KG        ', N'OJxr3xSwtVx', 3)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (97, N'Ayingba Comprehensive Health Center', NULL, N'KG        ', N'WwVbcxjtu79', 3)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (98, N'Blue House Hospital', NULL, N'KG        ', N'TguuBcW7SeK', 3)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (99, N'Dekina General Hospital', NULL, N'KG        ', N'p8ukk5eOdZA', 3)
GO
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (100, N'Bethel Hospital', NULL, N'KG        ', N'N2YrIzbDRkx', 3)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (101, N'Abejukolo General Hospital', NULL, N'KG        ', N'PRHYgNR5CUO', 3)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (102, N'Tudun Wada Family Health Unit', NULL, N'KD        ', N'BTfKBTk1iJ9', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (103, N'St. Gerald''s Hospital - Kaduna', NULL, N'KD        ', N'yfPEukzMBhy', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (104, N'Tudun Wada Primary Health Center', NULL, N'GB        ', N'dxf5N2oFePK', 1)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (105, N'Amdo Medical Clinic', NULL, N'GB        ', N'kjkBvkvr0Rj', 1)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (106, N'Kaltungo General Hospital', NULL, N'GB        ', N'CnFTZ4Yu5A8', 1)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (107, N'Tula Cottage Hospital', NULL, N'GB        ', N'KLEiRw5efPW', 1)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (108, N'Daban Fulani Maternal and Child Health Clinic', NULL, N'GB        ', N'K4zAO0M2Kmq', 1)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (109, N'Mallam Sidi Cottage Hospital', NULL, N'GB        ', N'qjAHaXsYrWi', 1)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (110, N'Nafada General Hospital', NULL, N'GB        ', N'gO6hDzeSBgl', 1)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (111, N'Filiya Primary Health Center', NULL, N'GB        ', N'vaP8U6qfGIa', 1)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (112, N'Majidadi Maternal and Child Health Clinic', NULL, N'GB        ', N'U1gAYFD9UHr', 1)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (113, N'Pero Primary Health Center', NULL, N'GB        ', N'udBc8MM1Szr', 1)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (114, N'Dadinkowa Town Maternity', NULL, N'GB        ', N'rrBhu5e1MfW', 1)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (115, N'Deba General Hospital', NULL, N'GB        ', N'HwC7f1qYg2o', 1)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (116, N'Diffa Primary Health Center', NULL, N'GB        ', N'LwSI1JO6CRg', 1)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (117, N'Hinna Primary Health Center', NULL, N'GB        ', N'rRFHOH95mcF', 1)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (118, N'Infectious Disesase Hospital - Zambuk', NULL, N'GB        ', N'P9815pFCx4Y', 1)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (119, N'Kwadon Primary Health Center', NULL, N'GB        ', N'QR7EfY7yNgb', 1)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (120, N'Lanu Maternity', NULL, N'GB        ', N'lXDHEJLTcvA', 1)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (121, N'Maikaho Primary Health Center', NULL, N'GB        ', N'e3IPIkjbbRD', 1)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (122, N'Birningwari Maternal Child Health Care', NULL, N'KD        ', N'VTv6H1vQyde', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (123, N'Jibrin Maigwari General Hospital', NULL, N'KD        ', N'm4mw3TJxbJy', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (124, N'Sabonlayi Health Center', NULL, N'KD        ', N'oLJpdUHh2sK', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (125, N'Town Maternity Gombe', NULL, N'GB        ', N'aGOQB2fZ1Bt', 1)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (126, N'Sunnah Hospital', NULL, N'GB        ', N'TiAwIXFMkLy', 1)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (127, N'Salem Medical Center', NULL, N'GB        ', N'HSix7em1VzC', 1)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (128, N'Pantami Primary Health Center', NULL, N'GB        ', N'pU92ZUAY68L', 1)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (129, N'Kashere General Hospital', NULL, N'GB        ', N'bW4cbw8Kloh', 1)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (130, N'Bam Bam Cottage Hospital', NULL, N'GB        ', N'yAtYirMpXuz', 1)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (131, N'Cham Primary Health Center', NULL, N'GB        ', N'tIEFDNyv2IV', 1)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (132, N'Talase General Hospital', NULL, N'GB        ', N'LzmgjtL87kh', 1)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (133, N'Billiri General Hospital', NULL, N'GB        ', N'ItQqTK4vrzT', 1)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (134, N'Lafiya Clinic', NULL, N'GB        ', N'LTuv4a79XvG', 1)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (135, N'Pobaure Primary Health Center', NULL, N'GB        ', N'frnHxx8ZcTF', 1)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (136, N'Dukku Comprehensive Health Center', NULL, N'GB        ', N'VvdGo3jc0D0', 1)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (137, N'Dukku General Hospital', NULL, N'GB        ', N'X8smKtvqUob', 1)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (138, N'Ashaka Cement Clinic', NULL, N'GB        ', N'XNy0j3RUrI6', 1)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (139, N'Amina Hospital', NULL, N'KD        ', N'J4Ec3FWnH6Q', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (140, N'Bajoga General Hospital', NULL, N'GB        ', N't0ulFJivm9P', 1)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (141, N'Bolari Maternal and Child Health Clinic', NULL, N'GB        ', N've4UhhWPdtv', 1)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (142, N'Doma Hospital', NULL, N'GB        ', N'hX8Nrf3AEz7', 1)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (143, N'Federal Medical Center - Gombe', NULL, N'GB        ', N'UeAxwJmzoPH', 1)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (144, N'Gombe State Specialist Hospital', NULL, N'GB        ', N'kQSAihTQQep', 1)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (145, N'Herwagana Maternal and Child Health Clinic', NULL, N'GB        ', N'TinjgNiJrB4', 1)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (146, N'Kasuwan Mata Health Clinic', NULL, N'GB        ', N'y6Kk5VUXOX7', 1)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (147, N'London Maidorawa Health Clinic', NULL, N'GB        ', N'oso9UXCPxTW', 1)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (148, N'Miyetti Hospital', NULL, N'GB        ', N'Lx9SQTEgXS3', 1)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (149, N'Musaba Clinic', NULL, N'GB        ', N'jRNyO3ImWmI', 1)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (150, N'Nasarawo Maternal and Child Health Clinic', NULL, N'GB        ', N'tRkbi8NqKzg', 1)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (151, N'Jalingo Primary Health Center', NULL, N'GB        ', N'I9vA78jcthr', 1)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (152, N'Television Primary Health Center', NULL, N'KD        ', N'zVAiLsWRBQb', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (153, N'Hope for the Village Child', NULL, N'KD        ', N'uQx06yCByKI', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (154, N'Kujama Primary Health Center', NULL, N'KD        ', N'nwcnPbXH2SR', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (155, N'Badarawa Primary Health Center', NULL, N'KD        ', N'HWkSjwMUDvc', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (156, N'Barau Dikko Specialist Hospital', NULL, N'KD        ', N'aQTk0pRk6eY', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (157, N'Federation of Muslim Women Association of Nigeria (FOMWAN) Hospital', NULL, N'KD        ', N'dwAvWQFlxx2', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (158, N'Hayin Banki Primary Health Center', NULL, N'KD        ', N'V5Le2Ban78U', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (159, N'Kawo General Hospital', NULL, N'KD        ', N'ZD8SEdhkeTQ', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (160, N'Muslim Specialist Hospital', NULL, N'KD        ', N'rWfabrVIqeg', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (161, N'Police Medical Center', NULL, N'KD        ', N'JDudfxSTSrO', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (162, N'Rafin Guza Primary Health Center', NULL, N'KD        ', N'ZKGDUXMpiQh', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (163, N'Tukur Malali Primary Health Center', NULL, N'KD        ', N'Gh18S2BxHKn', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (164, N'Ungwan Shanu Primary Health Center', NULL, N'KD        ', N'hD3xRpPBnWf', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (165, N'Zakari Isah Memorial Clinic', NULL, N'KD        ', N'QwrkbFl3Uvj', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (166, N'Barnawa Primary Health Center', NULL, N'KD        ', N'gZeeGIFJ9KY', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (167, N'Biba Hospital', NULL, N'KD        ', N'ka5T5cXKFup', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (168, N'Gwamna Awan General Hospital', NULL, N'KD        ', N'uq98eMvdS5R', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (169, N'Harmony Hospital', NULL, N'KD        ', N'mX4PekSaaS2', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (170, N'Jowako Hospital', NULL, N'KD        ', N'T0cw021kccu', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (171, N'Kudenda Primary Health Center', NULL, N'KD        ', N'Xs1MosdNYO5', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (172, N'Kurmi Mashi Primary Health Center', NULL, N'KD        ', N'oB3NepeAtXB', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (173, N'Makera I Primary Health Center', NULL, N'KD        ', N'IzbxBJjD6IG', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (174, N'Maneks Hospital', NULL, N'KD        ', N'xoXTB4clfGL', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (175, N'Narayi Primary Health Center', NULL, N'KD        ', N'OF6w1FUfvSf', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (176, N'Al-Munnir Hospital', NULL, N'KD        ', N'vpRIpHsK1EG', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (177, N'Kachia General Hospital', NULL, N'KD        ', N'bSDq2EfthjS', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (178, N'Foltz Medical Center - Katari', NULL, N'KD        ', N'vuo72rgedTZ', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (179, N'Doka Rural Hospital', NULL, N'KD        ', N'WdArBhoOacf', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (180, N'Kujama Rural Hospital', NULL, N'KD        ', N'yXnTcKW3nuk', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (181, N'Nasarawa Primary Health Center', NULL, N'KD        ', N'qq4e0kfaUvb', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (182, N'Romi Primary Health Center', NULL, N'KD        ', N'FLqvfq0KBA4', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (183, N'Sabo Tsaha Primary Health Center', NULL, N'KD        ', N'i6Rcojd7d9S', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (184, N'Sabon Tasha General Hospital', NULL, N'KD        ', N'Os1iE6RNSnx', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (185, N'Ahmadu Bello University Teaching Hospital - Shika', NULL, N'KD        ', N'fiC3mpkjajt', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (186, N'Giwa General Hospital', NULL, N'KD        ', N'ebLQTZgsfgz', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (187, N'Jaji Comprehensive Health Center', NULL, N'KD        ', N'P2CO8dS7XTK', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (188, N'Mararaban Jos Primary Health Center', NULL, N'KD        ', N'OKrnMlZFkFf', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (189, N'Nasiha Hospital Rigasa', NULL, N'KD        ', N'K0BNByM2t5V', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (190, N'Kasuwa Magani Primary Health Center', NULL, N'KD        ', N'JWZaYKHTAvt', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (191, N'Turunku Rural Hospital', NULL, N'KD        ', N'yjpPIoeNQLj', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (192, N'Barde Primary Health Center', NULL, N'KD        ', N'nnO4MwYN93D', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (193, N'Gidan Waya Primary Health Center', NULL, N'KD        ', N'zDhjewQr48h', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (194, N'Godogodo Primary Health Center', NULL, N'KD        ', N'gOO2jNM0enh', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (195, N'Jagindi Tasha Health Clinic', NULL, N'KD        ', N'Md3GGdU4n1S', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (196, N'Kafanchan Family Health Unit', NULL, N'KD        ', N'yR3KYnURaLT', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (197, N'Kafanchan General Hospital', NULL, N'KD        ', N'GPe3nnQbHA6', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (198, N'Mailafiya Health Clinic', NULL, N'KD        ', N'uYOS4lYipBj', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (199, N'New Era Maternity and Hospital', NULL, N'KD        ', N'tumi2lmViL2', 2)
GO
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (200, N'Salem Medical Center - Kafanchan', NULL, N'KD        ', N'f0wy9MgKtUx', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (201, N'Crossing Primary Health Center', NULL, N'KD        ', N'u2YY3OW0w6X', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (202, N'Kwoi General Hospital', NULL, N'KD        ', N'b54iXGWcmCB', 2)
INSERT [dbo].[Site] ([Id], [Name], [LGA], [StateCode], [SiteId], [StateId]) VALUES (203, N'Ufedo Ojo Clinic', NULL, N'KG        ', N'XhbFzfINb7z', 3)
SET IDENTITY_INSERT [dbo].[Site] OFF
SET IDENTITY_INSERT [dbo].[SiteTxTarget] ON 

INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (1, 41, 2, 2019, 107)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (2, 4640, 495, 2019, 156)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (3, 4609, 315, 2019, 103)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (4, 4418, 373, 2019, 185)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (5, 3962, 303, 2019, 197)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (6, 3871, 514, 2019, 168)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (7, 3656, 495, 2019, 27)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (8, 2906, 392, 2019, 184)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (9, 2834, 287, 2019, 21)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (10, 50, 15, 2019, 68)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (11, 2620, 504, 2019, 8)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (12, 1586, 270, 2019, 81)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (13, 1329, 122, 2019, 202)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (14, 1257, 154, 2019, 177)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (15, 1244, 303, 2019, 159)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (16, 1126, 198, 2019, 13)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (17, 1102, 66, 2019, 78)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (18, 992, 186, 2019, 123)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (19, 835, 150, 2019, 46)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (20, 2619, 250, 2019, 82)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (21, 721, 116, 2019, 29)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (22, 58, 5, 2019, 57)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (23, 121, 16, 2019, 77)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (24, 2051, 324, 2019, 76)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (25, 1956, 205, 2019, 75)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (26, 1882, 281, 2019, 66)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (27, 1865, 270, 2019, 71)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (28, 1236, 140, 2019, 64)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (29, 1103, 130, 2019, 54)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (30, 892, 115, 2019, 73)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (31, 852, 108, 2019, 101)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (32, 71, 16, 2019, 56)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (33, 761, 116, 2019, 99)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (34, 687, 123, 2019, 69)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (35, 538, 84, 2019, 86)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (36, 482, 30, 2019, 63)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (37, 415, 44, 2019, 59)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (38, 339, 26, 2019, 74)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (39, 225, 35, 2019, 95)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (40, 165, 16, 2019, 72)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (41, 162, 36, 2019, 67)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (42, 698, 88, 2019, 58)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (43, 619, 109, 2019, 183)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (44, 556, 82, 2019, 186)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (45, 533, 126, 2019, 17)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (46, 25, 0, 2019, 196)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (47, 5802, 384, 2019, 143)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (48, 4858, 624, 2019, 144)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (49, 2080, 168, 2019, 106)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (50, 1979, 190, 2019, 133)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (51, 1896, 187, 2019, 118)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (52, 1441, 127, 2019, 140)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (53, 857, 87, 2019, 138)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (54, 39, 3, 2019, 161)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (55, 756, 126, 2019, 130)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (56, 636, 90, 2019, 111)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (57, 540, 82, 2019, 137)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (58, 429, 118, 2019, 142)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (59, 400, 80, 2019, 110)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (60, 286, 57, 2019, 115)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (61, 240, 43, 2019, 132)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (62, 145, 23, 2019, 149)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (63, 117, 19, 2019, 148)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (64, 743, 117, 2019, 129)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (65, 49, 9, 2019, 80)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (66, 84, 18, 2019, 160)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (67, 87, 32, 2019, 165)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (68, 520, 95, 2019, 180)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (69, 498, 84, 2019, 79)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (70, 435, 48, 2019, 166)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (71, 399, 51, 2019, 42)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (72, 391, 36, 2019, 155)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (73, 360, 55, 2019, 35)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (74, 358, 1, 2019, 157)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (75, 325, 65, 2019, 52)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (76, 317, 34, 2019, 179)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (77, 291, 36, 2019, 49)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (78, 251, 27, 2019, 32)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (79, 242, 36, 2019, 191)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (80, 201, 46, 2019, 48)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (81, 172, 0, 2019, 173)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (82, 172, 9, 2019, 50)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (83, 135, 12, 2019, 170)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (84, 131, 58, 2019, 187)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (85, 121, 24, 2019, 169)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (86, 116, 109, 2019, 174)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (87, 2170, 183, 2019, 65)
INSERT [dbo].[SiteTxTarget] ([Id], [TxCurrTarget], [TxNewTarget], [FiscalYear], [SiteId]) VALUES (88, 2241, 335, 2019, 87)
SET IDENTITY_INSERT [dbo].[SiteTxTarget] OFF
SET IDENTITY_INSERT [dbo].[State] ON 

INSERT [dbo].[State] ([Id], [Name], [Code]) VALUES (1, N'Gombe', N'GB')
INSERT [dbo].[State] ([Id], [Name], [Code]) VALUES (2, N'Kaduna', N'KD')
INSERT [dbo].[State] ([Id], [Name], [Code]) VALUES (3, N'Kogi', N'KG')
INSERT [dbo].[State] ([Id], [Name], [Code]) VALUES (4, N'Lagos', N'LG')
SET IDENTITY_INSERT [dbo].[State] OFF
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AspNetRoleClaims_RoleId]    Script Date: 06/03/2020 2:18:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_AspNetRoleClaims_RoleId] ON [dbo].[AspNetRoleClaims]
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [RoleNameIndex]    Script Date: 06/03/2020 2:18:35 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [RoleNameIndex] ON [dbo].[AspNetRoles]
(
	[NormalizedName] ASC
)
WHERE ([NormalizedName] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AspNetUserClaims_UserId]    Script Date: 06/03/2020 2:18:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_AspNetUserClaims_UserId] ON [dbo].[AspNetUserClaims]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AspNetUserLogins_UserId]    Script Date: 06/03/2020 2:18:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_AspNetUserLogins_UserId] ON [dbo].[AspNetUserLogins]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AspNetUserRoles_RoleId]    Script Date: 06/03/2020 2:18:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_AspNetUserRoles_RoleId] ON [dbo].[AspNetUserRoles]
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [EmailIndex]    Script Date: 06/03/2020 2:18:35 PM ******/
CREATE NONCLUSTERED INDEX [EmailIndex] ON [dbo].[AspNetUsers]
(
	[NormalizedEmail] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UserNameIndex]    Script Date: 06/03/2020 2:18:35 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UserNameIndex] ON [dbo].[AspNetUsers]
(
	[NormalizedUserName] ASC
)
WHERE ([NormalizedUserName] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
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
ALTER TABLE [dbo].[FingerPrint]  WITH CHECK ADD  CONSTRAINT [FK_FingerPrint_PatientDemography] FOREIGN KEY([PatientId])
REFERENCES [dbo].[PatientDemography] ([Id])
GO
ALTER TABLE [dbo].[FingerPrint] CHECK CONSTRAINT [FK_FingerPrint_PatientDemography]
GO
ALTER TABLE [dbo].[HivEncounter]  WITH CHECK ADD  CONSTRAINT [FK_HivEncounter_PatientDemography] FOREIGN KEY([PatientId])
REFERENCES [dbo].[PatientDemography] ([Id])
GO
ALTER TABLE [dbo].[HivEncounter] CHECK CONSTRAINT [FK_HivEncounter_PatientDemography]
GO
ALTER TABLE [dbo].[LaboratoryReport]  WITH CHECK ADD  CONSTRAINT [FK_LaboratoryReport_PatientDemography] FOREIGN KEY([PatientId])
REFERENCES [dbo].[PatientDemography] ([Id])
GO
ALTER TABLE [dbo].[LaboratoryReport] CHECK CONSTRAINT [FK_LaboratoryReport_PatientDemography]
GO
ALTER TABLE [dbo].[PatientDemography]  WITH CHECK ADD  CONSTRAINT [FK_PatientDemography_Site] FOREIGN KEY([SiteId])
REFERENCES [dbo].[Site] ([Id])
GO
ALTER TABLE [dbo].[PatientDemography] CHECK CONSTRAINT [FK_PatientDemography_Site]
GO
ALTER TABLE [dbo].[PatientRegimen]  WITH CHECK ADD  CONSTRAINT [FK_PatientRegimen_PatientDemography] FOREIGN KEY([PatientId])
REFERENCES [dbo].[PatientDemography] ([Id])
GO
ALTER TABLE [dbo].[PatientRegimen] CHECK CONSTRAINT [FK_PatientRegimen_PatientDemography]
GO
ALTER TABLE [dbo].[Site]  WITH CHECK ADD  CONSTRAINT [FK_Site_State] FOREIGN KEY([StateId])
REFERENCES [dbo].[State] ([Id])
GO
ALTER TABLE [dbo].[Site] CHECK CONSTRAINT [FK_Site_State]
GO
ALTER TABLE [dbo].[SiteTxTarget]  WITH CHECK ADD  CONSTRAINT [FK_SiteTxTarget_Site] FOREIGN KEY([SiteId])
REFERENCES [dbo].[Site] ([Id])
GO
ALTER TABLE [dbo].[SiteTxTarget] CHECK CONSTRAINT [FK_SiteTxTarget_Site]
GO
/****** Object:  StoredProcedure [dbo].[sp_CallProcedureLog]    Script Date: 06/03/2020 2:18:35 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stActives28ByPartition]    Script Date: 06/03/2020 2:18:35 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stAllSiteDrilldown]    Script Date: 06/03/2020 2:18:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Henry Otuadinma
-- Create date: 31/10/2019
-- Description:	Gets drilldown of data elements for all states
-- =============================================
CREATE PROCEDURE [dbo].[stAllSiteDrilldown]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @today as date = cast(getdate() as date);

    -- Insert statements for procedure here
	select site.Id as sId, site.StateCode as code, count(u.PatientId) as total, sum(n.a) as active, sum(n.i) as inActive, sum(n.l) as loss, count(nc.PatientId) as tx_new
from
    
	(select Id, Name, StateCode from Site) as site

 join 
 
 (select * from (select PatientId, SiteId,
             row_number() over (partition by PatientId order by AppointmentDate desc) as seqnum
      from ArtVisit) o where seqnum = 1)u on site.Id = u.SiteId
  
   left join 

	(select * from (select PatientId,
             row_number() over (partition by PatientId order by ArtDate desc) as seqnum
      from ArtBaseline where  year(ArtDate) = year(@today) and ((((month(dateadd(month, -9, ArtDate))) + 2)/3) = (((month(dateadd(month, -9, @today))) + 2)/3))
     ) o where seqnum = 1) nc on u.PatientId = nc.PatientId

  left join

   (select sum(case when (@today <= cast(dateadd(day, 28, o.AppointmentDate) as date)) then 1 else 0 end) as a, 
sum(case when ((@today > cast(dateadd(day, 28, o.AppointmentDate) as date)) and (@today <= cast(dateadd(day, 90, o.AppointmentDate) as date))) then 1 else 0 end) as i,
sum(case when (@today >  cast(dateadd(day, 90, o.AppointmentDate) as date)) then 1 else 0 end) as l, PatientId

from 

	(select PatientId, AppointmentDate,
	row_number() over (partition by PatientId order by AppointmentDate desc) as seqnum 
	from ArtVisit) o 
	where seqnum = 1 group by PatientId)n on u.PatientId = n.PatientId  group by site.Id, site.StateCode
END
GO
/****** Object:  StoredProcedure [dbo].[stCountClientsOnArt]    Script Date: 06/03/2020 2:18:35 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stCountSearch]    Script Date: 06/03/2020 2:18:35 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stCountSites]    Script Date: 06/03/2020 2:18:35 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stCountTxCurrByPeriod]    Script Date: 06/03/2020 2:18:35 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stCountTxNewByPeriod]    Script Date: 06/03/2020 2:18:35 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stCountUsers]    Script Date: 06/03/2020 2:18:35 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stCountViralSuppressionByPeriod]    Script Date: 06/03/2020 2:18:35 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stDashboard]    Script Date: 06/03/2020 2:18:35 PM ******/
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

	SELECT count(distinct PatientId) clients FROM ArtVisit
	
	--------------------- Sites with Clients Ever enrolled on ART

	select *, count(d.SiteId) as hasPatients 
	from
	(select Id, Name, StateId from Site) s 
	left outer join 
	(select SiteId from ArtVisit) d on s.Id = d.SiteId group by d.SiteId, s.Id, s.Name, s.StateId

	------------------- Tx_Curr based on 28 days
		
	select count(distinct w.PatientId) as patients28 from
	(select * from (select PatientId,
				 row_number() over (partition by PatientId order by AppointmentDate desc) as seqnum
		  from ArtVisit where (@today <= cast(dateadd(day, 28, AppointmentDate) as date))
		 ) o where seqnum = 1) w

	------------------- Tx_Curr based on 90 days
	
	select count(distinct w.PatientId) as patient90 from
	(select * from (select PatientId,
				 row_number() over (partition by PatientId order by AppointmentDate desc) as seqnum
		  from ArtVisit where (@today <= cast(dateadd(day, 90, AppointmentDate) as date))
		 ) o where seqnum = 1) w
	
	------------------- Clients newly Enrolled on ART

select count(r.PatientId) as newC from
	 (select Id from Patient p join (select PatientId from ArtBaseline where  ArtDate is not null and year(ArtDate) > 2000) d on p.Id = d.PatientId)as u

    inner join 
	
	(select distinct PatientId from ArtBaseline where year(ArtDate) = year(@today) and ((((month(dateadd(month, -9, ArtDate))) + 2)/3) = (((month(dateadd(month, -9, @today))) + 2)/3)) group by PatientId)r on u.Id = r.PatientId
END
GO
/****** Object:  StoredProcedure [dbo].[stErrorHandler]    Script Date: 06/03/2020 2:18:35 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stGet28DayActivesBand]    Script Date: 06/03/2020 2:18:35 PM ******/
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
	
	(select distinct Id, DateOfBirth, Sex  from Patient)j 
	
	right join

	(select * from (select PatientId,
             row_number() over (partition by PatientId order by AppointmentDate desc) as seqnum
      from ArtVisit o where @today <= cast(dateadd(day, 28, AppointmentDate) as date) 
     ) o where seqnum = 1) n on j.Id = n.PatientId

END
GO
/****** Object:  StoredProcedure [dbo].[stGet90DayActives]    Script Date: 06/03/2020 2:18:35 PM ******/
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
	((select distinct Id, DateOfBirth, Sex  from Patient)j 
	right join
	(select distinct PatientId, max(AppointmentDate) as dt1 from ArtVisit where @today <= cast(dateadd(day, 90, AppointmentDate) as date)  group by PatientId) n on j.Id = n.PatientId) order by age
END
GO
/****** Object:  StoredProcedure [dbo].[stGetAllByPeriod]    Script Date: 06/03/2020 2:18:35 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stGetClientBands]    Script Date: 06/03/2020 2:18:35 PM ******/
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
	((select distinct Id, DateOfBirth, Sex  from Patient)j 
	inner join
	(select distinct PatientId, max(AppointmentDate) as dt1 from ArtVisit where @today <= cast(dateadd(day, 28, AppointmentDate) as date)  group by PatientId) n on j.Id = n.PatientId) order by age

	----------------- Active Clients based on 90 days

	select Id as patient, datediff(year, cast(DateOfBirth as date), @today) as age, Sex as gender from
	((select distinct Id, DateOfBirth, Sex  from Patient)j 
	inner join
	(select distinct PatientId, max(AppointmentDate) as dt1 from ArtVisit where @today <= cast(dateadd(day, 90, AppointmentDate) as date)  group by PatientId) n on j.Id = n.PatientId) order by age
END
GO
/****** Object:  StoredProcedure [dbo].[stGetClientStatsByStates]    Script Date: 06/03/2020 2:18:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Henry Otuadinma
-- Create date: 14/07/2019
-- Description:	Gets total, active, inactive, LTFU, and new clients in each state
-- =============================================
CREATE PROCEDURE [dbo].[stGetClientStatsByStates] 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

declare @today as date = cast(getdate() as date);

select site.StateCode, sum(totalArt) as totalArt, sum(active) as active, sum(inActive) as inactive, sum(loss) as loss, sum(tx_new) as tx_new
from
    (select Id, Name, StateCode from Site s join (select SiteId from Patient group by SiteId having count(distinct SiteId) > 0 ) d on s.Id = d.SiteId) as site

 left outer join 
 (

select
        count(u.PatientId) as totalArt, sum(n.a) as active, sum(n.i) as inActive, sum(n.l) as loss, count(nc.PatientId) as tx_new, u.SiteId as site

		from

    (select * from (select PatientId, SiteId,
				 row_number() over (partition by PatientId order by Id desc) as seqnum
		  from ArtVisit) o where seqnum = 1) u

    left outer join 

	(select * from (select PatientId,
             row_number() over (partition by PatientId order by ArtDate desc) as seqnum
      from ArtBaseline where  year(ArtDate) = year(@today) and ((((month(dateadd(month, -9, ArtDate))) + 2)/3) = (((month(dateadd(month, -9, @today))) + 2)/3))
     ) o where seqnum = 1) nc on u.PatientId = nc.PatientId

   left outer join

   (select sum(case when (@today <= cast(dateadd(day, 28, o.AppointmentDate) as date)) then 1 else 0 end) as a, 
sum(case when (@today <= cast(dateadd(day, 90, o.AppointmentDate) as date)) then 1 else 0 end) as i,
sum(case when (@today >  cast(dateadd(day, 90, o.AppointmentDate) as date)) then 1 else 0 end) as l, PatientId

from 

	(select PatientId, AppointmentDate,
	row_number() over (partition by PatientId order by AppointmentDate desc) as seqnum 
	from ArtVisit) o 
	where seqnum = 1 group by PatientId)n on u.PatientId = n.PatientId  group by u.SiteId
) c on site.Id = c.site group by site.StateCode

END
GO
/****** Object:  StoredProcedure [dbo].[stGetDashboardStats]    Script Date: 06/03/2020 2:18:35 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stGetSitesByPage]    Script Date: 06/03/2020 2:18:35 PM ******/
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

;WITH sitePage AS (select site.Id as sId, site.Name as site, site.StateCode as code, sum(totalArt) as totalArt, sum(active) as active, sum(inActive) as inactive, sum(loss) as loss, sum(tx_new) as tx_new
from
    (select Id, Name, StateCode from Site s join (select SiteId from Patient group by SiteId having count(distinct SiteId) > 0 ) d on s.Id = d.SiteId) as site

 left outer join 
 (

select
        count(u.PatientId) as totalArt, sum(n.a) as active, sum(n.i) as inActive, sum(n.l) as loss, count(nc.PatientId) as tx_new, u.SiteId as site

		from

     (select * from (select PatientId, SiteId,
				 row_number() over (partition by PatientId order by Id desc) as seqnum
		  from ArtVisit) o where seqnum = 1) u

    left outer join 

	(select * from (select PatientId,
             row_number() over (partition by PatientId order by ArtDate desc) as seqnum
      from ArtBaseline where  year(ArtDate) = year(@today) and ((((month(dateadd(month, -9, ArtDate))) + 2)/3) = (((month(dateadd(month, -9, @today))) + 2)/3))
     ) o where seqnum = 1) nc on u.PatientId = nc.PatientId

   left outer join

   (select sum(case when (@today <= cast(dateadd(day, 28, o.AppointmentDate) as date)) then 1 else 0 end) as a, 
sum(case when ((@today > cast(dateadd(day, 28, o.AppointmentDate) as date)) and (@today <= cast(dateadd(day, 90, o.AppointmentDate) as date))) then 1 else 0 end) as i,
sum(case when (@today >  cast(dateadd(day, 90, o.AppointmentDate) as date)) then 1 else 0 end) as l, PatientId

from 

	(select PatientId, AppointmentDate,
	row_number() over (partition by PatientId order by AppointmentDate desc) as seqnum 
	from ArtVisit) o 
	where seqnum = 1 group by PatientId)n on u.PatientId = n.PatientId  group by u.SiteId
) c on site.Id = c.site group by site.Id, site.Name, site.StateCode
)

SELECT * FROM sitePage
 cross join (select count(sId) as totalSites from sitePage) countAll
order by sId offset  ((@pageNumber-1 )*@itemsPerPage)  rows fetch next @itemsPerPage rows only;

END
GO
/****** Object:  StoredProcedure [dbo].[stGetSiteTxCurrByPeriod]    Script Date: 06/03/2020 2:18:35 PM ******/
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
	@start as date,
	@end as date,
	@siteId as int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
select site.Id as sId, site.Name as site, site.StateCode as code, sum(total) as total, t.TxCurrTarget, t.FiscalYear, sum(active) as active

from
    (select Id, Name, StateCode from Site where Id = @siteId) as site

   join
 (

 select count(u.PatientId) as total, count(w.PatientId) as active, u.SiteId as site from

(select * from (select PatientId, SiteId,
             row_number() over (partition by PatientId order by AppointmentDate desc) as seqnum
      from ArtVisit) o where seqnum = 1)u

   left join

(select * from (select PatientId, row_number() over (partition by PatientId order by AppointmentDate desc) as seqnum
      from ArtVisit where (@start <= cast(dateadd(day, 28, AppointmentDate) as date) and @end <= cast(dateadd(day, 28, AppointmentDate) as date))) o where seqnum = 1) w on u.PatientId = w.PatientId group by u.SiteId

) c on site.Id = c.site
  
left join 

(select TxCurrTarget, FiscalYear, SiteId from SiteTxTarget where (FiscalYear >= year(@start) and FiscalYear <= year(@end))) t on site.Id = t.SiteId

 group by site.Id, site.Name, site.StateCode, t.TxCurrTarget, t.FiscalYear
END
GO
/****** Object:  StoredProcedure [dbo].[stGetSiteTxNewByPeriod]    Script Date: 06/03/2020 2:18:35 PM ******/
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
	@start date,
	@end date,
	@siteId as int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
select site.Id as sId, site.Name as site, site.StateCode as code, sum(total) as total, t.TxNewTarget, t.FiscalYear, sum(txNew) as txNew
from
    
	(select Id, Name, StateCode from Site where Id = @siteId) as site

 join 
 
 ( select count(u.PatientId) as total, count(nc.PatientId) as txNew, u.SiteId as site from

(select * from (select PatientId, SiteId, row_number() over (partition by PatientId order by AppointmentDate desc) as seqnum from ArtVisit) o where seqnum = 1)u

   left join

(select * from (select PatientId, row_number() over (partition by PatientId order by ArtDate desc) as seqnum from ArtBaseline where ArtDate >= @start and ArtDate <= @end) o where seqnum = 1) nc on u.PatientId = nc.PatientId group by u.SiteId

) c on site.Id = c.site

left join 

(select TxNewTarget, FiscalYear, SiteId from SiteTxTarget where (FiscalYear >= year(@start) and FiscalYear <= year(@end))) t on site.Id = t.SiteId

 group by site.Id, site.Name, site.StateCode, t.TxNewTarget, t.FiscalYear

END
GO
/****** Object:  StoredProcedure [dbo].[stGetSiteVLByPeriod]    Script Date: 06/03/2020 2:18:35 PM ******/
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
	@start date,
	@end date,
	@siteId as int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
select site.Id as sId, site.StateId as state, site.Name as site, site.StateCode as code, sum(active) as active,sum(tested) as tested, sum(suppressed) as suppressed,sum(unsuppressed) as unsuppressed
from
    (select Id, Name, StateCode, StateId from Site where Id = @siteId) as site

 join 
 (
 select 
  sum(case when w.PatientId > 0 then 1 else 0 end) as active,
  sum(case when TestDate is not null and TestDate != '' then 1 else 0 end) as tested,
  sum(case when cast(dbo.RemoveNonNumericChars(TestResult) as int) >= 1000 then 1 else 0 end) as unsuppressed, 
  sum(case when cast(dbo.RemoveNonNumericChars(TestResult) as int) > 0 and cast(dbo.RemoveNonNumericChars(TestResult) as int) < 1000 then 1 else 0 end) as suppressed, w.PatientId, w.SiteId
 
 from

(select * from (select PatientId, SiteId, row_number() over (partition by PatientId order by AppointmentDate desc) as seqnum
      from ArtVisit  where @start <= cast(dateadd(day, 28, AppointmentDate) as date) and @end <= cast(dateadd(day, 28, AppointmentDate) as date)) o where seqnum = 1) w

left join

(select * from (select PatientId, TestDate, DateReported, TestResult, row_number() over (partition by PatientId order by TestDate desc) as seqnum
      from LabResult o where Description like '%viral%' and TestResult is not null and TestResult != '' and (TestDate >= @start and TestDate <= @end)) o where seqnum = 1) n on w.PatientId = n.PatientId group by w.SiteId, w.PatientId

) c on site.Id = c.SiteId group by site.Id, site.StateId, site.Name, site.StateCode

END
GO
/****** Object:  StoredProcedure [dbo].[stGetStatesTxCurrByPeriod]    Script Date: 06/03/2020 2:18:35 PM ******/
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
	@start as date,
	@end as date
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

select site.StateId as state, sum(total) as total, t.TxCurrTarget, t.FiscalYear, sum(active) as active
from
    (select Id, StateId from Site) as site

 join 
 (

 select
        count(u.PatientId) as total, count(w.PatientId) as active, u.SiteId as site

		from

    (select * from (select PatientId, SiteId,
             row_number() over (partition by PatientId order by AppointmentDate desc) as seqnum
      from ArtVisit) o where seqnum = 1) as u

   left join
(select * from (select PatientId, row_number() over (partition by PatientId order by AppointmentDate desc) as seqnum
      from ArtVisit where (@start <= cast(dateadd(day, 28, AppointmentDate) as date) and @end <= cast(dateadd(day, 28, AppointmentDate) as date))) o where seqnum = 1) w on  u.PatientId = w.PatientId group by u.SiteId

) c on site.Id = c.site

left join (select TxCurrTarget, FiscalYear, SiteId from SiteTxTarget where (FiscalYear >= year(@start) and FiscalYear <= year(@end))) t on site.Id = t.SiteId
 group by site.StateId, t.TxCurrTarget, t.FiscalYear
END
GO
/****** Object:  StoredProcedure [dbo].[stGetStatesTxNewByPeriod]    Script Date: 06/03/2020 2:18:35 PM ******/
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
	@start as date,
	@end as date
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
select site.StateId as state, sum(total) as total, sum(txNew) as txNew, t.TxNewTarget, t.FiscalYear
from
    (select Id, StateId from Site) as site

 join 
 (

 select
        count(u.PatientId) as total, count(nc.PatientId) as txNew, u.SiteId as site

		from

	(select * from (select PatientId, SiteId,
             row_number() over (partition by PatientId order by AppointmentDate desc) as seqnum
      from ArtVisit) o where seqnum = 1) as u

    left join 
	
	(select distinct PatientId from ArtBaseline where ArtDate >= @start and ArtDate <= @end) nc on u.PatientId = nc.PatientId
	group by u.SiteId

) c on site.Id = c.site
left join (select TxNewTarget, FiscalYear, SiteId from SiteTxTarget where (FiscalYear >= year(@start) and FiscalYear <= year(@end))) t on site.Id = t.SiteId
 group by site.StateId, t.TxNewTarget, t.FiscalYear
END
GO
/****** Object:  StoredProcedure [dbo].[stGetStatesVLByPeriod]    Script Date: 06/03/2020 2:18:35 PM ******/
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
	@start as date,
	@end as date
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
select site.StateId as state, count(c.PatientId) as active,sum(tested) as tested, sum(suppressed) as suppressed,sum(unsuppressed) as unsuppressed
from
    (select Id, StateId from Site) as site

 join 
 (
 select 
  sum(case when TestDate is not null and TestDate != '' then 1 else 0 end) as tested,
  sum(case when cast(dbo.RemoveNonNumericChars(TestResult) as int) >= 1000 then 1 else 0 end) as unsuppressed, 
  sum(case when cast(dbo.RemoveNonNumericChars(TestResult) as int) > 0 and cast(dbo.RemoveNonNumericChars(TestResult) as int) < 1000 then 1 else 0 end) as suppressed, w.PatientId, w.SiteId
 
 from

(select * from (select PatientId, SiteId, row_number() over (partition by PatientId order by AppointmentDate desc) as seqnum
      from ArtVisit  where @start <= cast(dateadd(day, 28, AppointmentDate) as date) and @end <= cast(dateadd(day, 28, AppointmentDate) as date)) o where seqnum = 1) w

left join

(select * from (select PatientId, TestDate, DateReported, TestResult, row_number() over (partition by PatientId order by TestDate desc) as seqnum
      from LabResult o where Description like '%viral%' and TestResult is not null and TestResult != '' and (TestDate >= @start and TestDate <= @end)) o where seqnum = 1) n on w.PatientId = n.PatientId group by w.SiteId, w.PatientId

) c on site.Id = c.SiteId group by site.StateId
END
GO
/****** Object:  StoredProcedure [dbo].[stGetStateTxCurrByPeriod]    Script Date: 06/03/2020 2:18:35 PM ******/
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
	@start as date,
	@end as date,
	@stateId as int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
select site.StateId as state, sum(total) as total, t.TxCurrTarget, t.FiscalYear, sum(active) as active
from
	(select Id, StateId, Name, StateCode from Site where StateId = @stateId) as site

 join 
 (

 select count(u.PatientId) as total, count(w.PatientId) as active, u.SiteId as site from

(select * from (select PatientId, SiteId,
             row_number() over (partition by PatientId order by AppointmentDate desc) as seqnum
      from ArtVisit) o where seqnum = 1)u

   left outer join

(select * from (select PatientId, row_number() over (partition by PatientId order by AppointmentDate desc) as seqnum
      from ArtVisit where (@start <= cast(dateadd(day, 28, AppointmentDate) as date) and @end <= cast(dateadd(day, 28, AppointmentDate) as date))) o where seqnum = 1) w on u.PatientId = w.PatientId group by u.SiteId

) c on site.Id = c.site

left join 

(select TxCurrTarget, FiscalYear, SiteId from SiteTxTarget where (FiscalYear >= year(@start) and FiscalYear <= year(@end))) t on site.Id = t.SiteId
 group by site.StateId, t.TxCurrTarget, t.FiscalYear
END
GO
/****** Object:  StoredProcedure [dbo].[stGetStateTxNewByPeriod]    Script Date: 06/03/2020 2:18:35 PM ******/
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
	@start as date,
	@end as date,
	@stateId as int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
select site.StateId as state, sum(total) as total, sum(txNew) as txNew, t.TxNewTarget, t.FiscalYear
from
    (select Id, StateId from Site where StateId = @stateId) as site

 join 
 (

 select
        count(u.PatientId) as total, count(nc.PatientId) as txNew, u.SiteId as site

		from

	(select * from (select PatientId, SiteId,
             row_number() over (partition by PatientId order by AppointmentDate desc) as seqnum
      from ArtVisit) o where seqnum = 1) as u

    left join 
	
	(select distinct PatientId from ArtBaseline where ArtDate >= @start and ArtDate <= @end) nc on u.PatientId = nc.PatientId
	group by u.SiteId

) c on site.Id = c.site
left join (select TxNewTarget, FiscalYear, SiteId from SiteTxTarget where (FiscalYear >= year(@start) and FiscalYear <= year(@end))) t on site.Id = t.SiteId
 group by site.StateId, t.TxNewTarget, t.FiscalYear
END
GO
/****** Object:  StoredProcedure [dbo].[stGetStateVLByPeriod]    Script Date: 06/03/2020 2:18:35 PM ******/
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
	@start date,
	@end date,
	@stateId as int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
select site.StateId as state, sum(active) as active,sum(tested) as tested, sum(suppressed) as suppressed,sum(unsuppressed) as unsuppressed
from
    (select Id, Name, StateCode, StateId from Site where StateId = @stateId) as site

 join 
 (
 select 
  sum(case when w.PatientId > 0 then 1 else 0 end) as active,
  sum(case when TestDate is not null and TestDate != '' then 1 else 0 end) as tested,
  sum(case when cast(dbo.RemoveNonNumericChars(TestResult) as int) >= 1000 then 1 else 0 end) as unsuppressed, 
  sum(case when cast(dbo.RemoveNonNumericChars(TestResult) as int) > 0 and cast(dbo.RemoveNonNumericChars(TestResult) as int) < 1000 then 1 else 0 end) as suppressed, w.PatientId, w.SiteId
 
 from

(select * from (select PatientId, SiteId, row_number() over (partition by PatientId order by AppointmentDate desc) as seqnum
      from ArtVisit  where @start <= cast(dateadd(day, 28, AppointmentDate) as date) and @end <= cast(dateadd(day, 28, AppointmentDate) as date)) o where seqnum = 1) w

left join

(select * from (select PatientId, TestDate, DateReported, TestResult, row_number() over (partition by PatientId order by TestDate desc) as seqnum
      from LabResult o where Description like '%viral%' and TestResult is not null and TestResult != '' and (TestDate >= @start and TestDate <= @end)) o where seqnum = 1) n on w.PatientId = n.PatientId group by w.SiteId, w.PatientId

) c on site.Id = c.SiteId group by site.StateId
END
GO
/****** Object:  StoredProcedure [dbo].[stGetTxCurrByPeriod]    Script Date: 06/03/2020 2:18:35 PM ******/
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
	@start date,
	@end date,
	@pageNumber as int,
	@itemsPerPage as int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
;WITH txCurr AS (select site.Id as sId, site.Name as site, site.StateCode as code, count(u.PatientId) as total, t.TxCurrTarget, t.FiscalYear, count(w.PatientId) as active
from
    
	(select Id, Name, StateCode from Site) as site

 join 
 
 (select * from (select PatientId, SiteId,
             row_number() over (partition by PatientId order by AppointmentDate desc) as seqnum
      from ArtVisit) o where seqnum = 1)u on site.Id = u.SiteId
  
   left join 

   (select * from (select PatientId,
             row_number() over (partition by PatientId order by AppointmentDate desc) as seqnum
      from ArtVisit where (@start <= cast(dateadd(day, 28, AppointmentDate) as date) and @end <= cast(dateadd(day, 28, AppointmentDate) as date))
     ) o where seqnum = 1) w on u.PatientId = w.PatientId
  
left outer join 

(select TxCurrTarget, FiscalYear, SiteId from SiteTxTarget where (FiscalYear >= year(@start) and FiscalYear <= year(@end))) t on site.Id = t.SiteId

 group by site.Id, site.Name, site.StateCode, t.TxCurrTarget, t.FiscalYear)

SELECT * FROM txCurr
 cross join (select count(sId) as totalSites from txCurr) countAll
order by sId offset ((@pageNumber-1 )*@itemsPerPage)  rows fetch next @itemsPerPage rows only;
END
GO
/****** Object:  StoredProcedure [dbo].[stGetTxNewByPeriod]    Script Date: 06/03/2020 2:18:35 PM ******/
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
	@start date,
	@end date,
	@pageNumber as int,
	@itemsPerPage as int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

;WITH txNew AS (select site.Id as sId, site.Name as site, site.StateCode as code, sum(total) as total, t.TxNewTarget, t.FiscalYear, sum(txNew) as txNew
from
   
(select Id, Name, StateCode from Site) as site

 join 
 
 ( select count(u.PatientId) as total, count(nc.PatientId) as txNew, u.SiteId as site from

(select * from (select PatientId, SiteId, row_number() over (partition by PatientId order by AppointmentDate desc) as seqnum from ArtVisit) o where seqnum = 1)u

   left join

(select * from (select PatientId, row_number() over (partition by PatientId order by ArtDate desc) as seqnum from ArtBaseline where ArtDate >= @start and ArtDate <= @end) o where seqnum = 1) nc on u.PatientId = nc.PatientId group by u.SiteId) c on site.Id = c.site
  
left join 

(select TxNewTarget, FiscalYear, SiteId from SiteTxTarget where (FiscalYear >= year(@start) and FiscalYear <= year(@end))) t on site.Id = t.SiteId

 group by site.Id, site.Name, site.StateCode, t.TxNewTarget, t.FiscalYear)

SELECT * FROM txNew
 cross join (select count(sId) as totalSites from txNew) countAll
order by sId offset ((@pageNumber-1 )*@itemsPerPage)  rows fetch next @itemsPerPage rows only;
END
GO
/****** Object:  StoredProcedure [dbo].[stGetUser]    Script Date: 06/03/2020 2:18:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stGetUser] 
	-- Add the parameters for the stored procedure here
	@email as nvarchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select Id, FirstName, LastName, UserName, Email, PasswordHash, UserId, RoleId from
(select * from AspNetUsers where Email = @email)u
inner join 
(select * from AspNetUserRoles) r on u.Id = r.UserId
END
GO
/****** Object:  StoredProcedure [dbo].[stGetUsers]    Script Date: 06/03/2020 2:18:35 PM ******/
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
select Id, FirstName, LastName, UserName, Email, UserId, RoleId from
(select * from AspNetUsers)u
inner join 
(select * from AspNetUserRoles) r on u.Id = r.UserId
 order by FirstName desc  offset  ((@pageNumber-1 )*@itemsPerPage)  rows fetch next @itemsPerPage rows only
END
GO
/****** Object:  StoredProcedure [dbo].[stGetViralSuppressionByPeriod]    Script Date: 06/03/2020 2:18:35 PM ******/
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
	@start date,
	@end date,
	@pageNumber as int,
	@itemsPerPage as int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
;WITH vlSuppressed AS (select  site.Id as sId, site.Name as site, site.StateCode as code, sum(active) as active,sum(tested) as tested, sum(suppressed) as suppressed,sum(unsuppressed) as unsuppressed
from
    (select Id, Name, StateCode, StateId from Site) as site

 join 
 (
 select 
  sum(case when w.PatientId > 0 then 1 else 0 end) as active,
  sum(case when TestDate is not null and TestDate != '' then 1 else 0 end) as tested,
  sum(case when cast(dbo.RemoveNonNumericChars(TestResult) as int) >= 1000 then 1 else 0 end) as unsuppressed, 
  sum(case when cast(dbo.RemoveNonNumericChars(TestResult) as int) > 0 and cast(dbo.RemoveNonNumericChars(TestResult) as int) < 1000 then 1 else 0 end) as suppressed, w.PatientId, w.SiteId
 
 from

(select * from (select PatientId, SiteId, row_number() over (partition by PatientId order by AppointmentDate desc) as seqnum
      from ArtVisit  where @start <= cast(dateadd(day, 28, AppointmentDate) as date) and @end <= cast(dateadd(day, 28, AppointmentDate) as date)) o where seqnum = 1) w

left join

(select * from (select PatientId, TestDate, DateReported, TestResult, row_number() over (partition by PatientId order by TestDate desc) as seqnum
      from LabResult o where Description like '%viral%' and TestResult is not null and TestResult != '' and (TestDate >= @start and TestDate <= @end)) o where seqnum = 1) n on w.PatientId = n.PatientId group by w.SiteId, w.PatientId

) c on site.Id = c.SiteId group by site.Id, site.Name, site.StateCode)

SELECT * FROM vlSuppressed
 cross join (select count(sId) as totalSites from vlSuppressed) countAll
order by sId offset ((@pageNumber-1 )*@itemsPerPage)  rows fetch next @itemsPerPage rows only;
END
GO
/****** Object:  StoredProcedure [dbo].[stInsertArtVisit]    Script Date: 06/03/2020 2:18:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[stInsertArtVisit]
	-- Add the parameters for the stored procedure here
	@dtArtVisit ArtVisitInfo readonly,
    @outputMessage NVARCHAR(MAX) OUT,
	@processed int OUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	BEGIN TRY
        set transaction isolation level serializable
        BEGIN TRANSACTION		 
		
    -- Insert statements for procedure here
	insert into ArtVisit(IdNo,VisitDate,Weight,Height,Temperature,WhoStage,IsPregnant,TbScreen,TbDiagnosedTreatment,TbTreatmentStarted,CotrimeProphylaxis,ArtStarted,ArvAdherenceCode,ArvNonAdherenceCode,DrugReactionCode,ArvStopCode,ArvStopDate,Cd4Count,BloodPressure,FamilyPlanningCode,AppointmentDate,StatusCode,SiteId, DateAdded,PatientId) 
	
	select IdNo,VisitDate,Weight,Height,Temperature,WhoStage,IsPregnant,TbScreen,TbDiagnosedTreatment,TbTreatmentStarted,CotrimeProphylaxis,ArtStarted,ArvAdherenceCode,ArvNonAdherenceCode,DrugReactionCode,ArvStopCode,ArvStopDate,Cd4Count,BloodPressure,FamilyPlanningCode,AppointmentDate,StatusCode,SiteId, cast(getdate() as date),(select e 
		from  (SELECT Id e, SiteId s, EnrolmentId r, row_number() over (Partition by EnrolmentId order by Id desc) as rx
			  from Patient where EnrolmentId = a.EnrolmentId and SiteId = a.SiteId) as y
		where y.rx = 1) from @dtArtVisit a;

	SELECT @processed = @@ROWCOUNT;
	SET @outputMessage = 'success'; 

	
	COMMIT Transaction
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;  

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
/****** Object:  StoredProcedure [dbo].[stInsertBaseline]    Script Date: 06/03/2020 2:18:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[stInsertBaseline] 
	-- Add the parameters for the stored procedure here
	@dtArtBaseline ArtBaselineInfo readonly,
    @outputMessage NVARCHAR(MAX) OUT,
	@processed int out
	
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
		USING (select * from 		
		(select * 
		from  (SELECT *, row_number() over (Partition by EnrolmentId order by IdNo desc) as rn
			  from @dtArtBaseline) as R
		where R.rn = 1) f
		
		join
		
		--(select Id e, SiteId s, EnrolmentId r from Patient)
		(select * 
		from  (SELECT Id e, SiteId s, EnrolmentId r, row_number() over (Partition by EnrolmentId order by Id desc) as rx
			  from Patient) as y
		where y.rx = 1) g on f.EnrolmentId = g.r and f.SiteId = g.s) AS b	
		
		ON a.EnrolmentId = b.EnrolmentId AND a.SiteId = b.SiteId
		and a.IdNo = b.IdNo

		WHEN MATCHED THEN 
		
		UPDATE SET 		
		a.HivConfirmationDate = b.HivConfirmationDate, 
		a.EnrolmentDate = b.EnrolmentDate, 
		a.ArtDate = b.ArtDate, 
		a.DispositionDate = b.DispositionDate, 
		a.DispositionCode = b.DispositionCode
		
		WHEN NOT MATCHED by target THEN
		
		INSERT(EnrolmentId, IdNo,HivConfirmationDate,EnrolmentDate,ArtDate,DispositionDate,DispositionCode,SiteId, DateAdded, PatientId)
		VALUES(b.EnrolmentId, b.IdNo,b.HivConfirmationDate, b.EnrolmentDate,b.ArtDate,b.DispositionDate,b.DispositionCode,b.SiteId, cast(getdate() as date), b.e);
		
		SELECT @processed = @@ROWCOUNT;
          SET @outputMessage = 'success';   
		 COMMIT Transaction
    END TRY
    BEGIN CATCH
	ROLLBACK TRANSACTION;
		SET @outputMessage = 'error - ' + ERROR_MESSAGE();
		DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
		RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[stInsertLabResult]    Script Date: 06/03/2020 2:18:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stInsertLabResult]
	-- Add the parameters for the stored procedure here
	@dtLabResult LabResultInfo readonly,
    @outputMessage NVARCHAR(MAX) OUT,
	@processed int OUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from	
	SET NOCOUNT ON;
	BEGIN TRY
	-- interfering with SELECT statements.
	set transaction isolation level serializable
         BEGIN TRANSACTION

	MERGE LabResult WITH (HOLDLOCK) AS a
		USING (select * from 

		(select *  from  (SELECT *, row_number() over (Partition by IdNo order by idNo desc) as rn
			  from @dtLabResult) as R
		where R.rn = 1) AS t 
		
		join (select Id e, SiteId s, EnrolmentId r from Patient)g 
		on t.EnrolmentId = g.r and t.SiteId = g.s) as l		
		ON a.IdNo = l.IdNo AND a.SiteId = l.SiteId
		WHEN MATCHED THEN 
		
		UPDATE SET 		
		a.TestResult = l.TestResult, 
		a.DateReported = l.DateReported, 
		a.Description = l.Description, 
		a.TestDate = l.TestDate

		WHEN NOT MATCHED by target THEN
		INSERT(IdNo,LabNumber,Description,TestGroup,TestResult,TestDate,DateReported,SiteId, DateAdded, PatientId)
		VALUES(l.IdNo,l.LabNumber,l.Description,l.TestGroup,l.TestResult,l.TestDate,l.DateReported,l.SiteId, cast(getdate() as date), (select top 1 Id from Patient where EnrolmentId = l.EnrolmentId and SiteId = l.SiteId));
	
	SELECT @processed = @@ROWCOUNT;
	SET @outputMessage = 'success'; 	
	COMMIT Transaction
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;  

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
/****** Object:  StoredProcedure [dbo].[stInsertPaedVisits]    Script Date: 06/03/2020 2:18:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stInsertPaedVisits] 
	-- Add the parameters for the stored procedure here

	@dtArtVisit ArtPaedVisit readonly,
    @outputMessage NVARCHAR(MAX) OUT,
	@processed int OUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	BEGIN TRY
         BEGIN TRANSACTION [stInsertPaedVisits]

    -- Insert statements for procedure here
	insert into ArtVisit(IdNo,VisitDate,Weight,WhoStage,TbScreen,TbDiagnosed,TbSuspected,TbTreatmentReceived,ReceivingContrime,ArtStarted,ArvRegimenCode,ArvAdherenceCode,ArvNonAdherenceCode,ArvRegimen1,ArvRegimen2,ArvRegimen3,ArvStopCode,ArvStopDate,AppointmentDate,AdvDrugCode,SiteId, DateAdded, PatientId) select q.IdNo,q.VisitDate,q.Weight,q.WhoStage,q.TbScreen,q.TbDiagnosed,q.TbSuspected,q.TbTreatmentReceived,q.ReceivingContrime,q.ArtStarted,q.ArvRegimenCode,q.ArvAdherenceCode,q.ArvNonAdherenceCode,q.ArvRegimen1,q.ArvRegimen2,q.ArvRegimen3,q.ArvStopCode,q.ArvStopDate,q.AppointmentDate,q.AdvDrugCode,q.SiteId, cast(getdate() as date), (select e 
		from  (SELECT Id e, SiteId s, EnrolmentId r, row_number() over (Partition by EnrolmentId order by Id desc) as rx
			  from Patient where EnrolmentId = q.EnrolmentId and SiteId = q.SiteId) as y
		where y.rx = 1) from @dtArtVisit q;
	
	SELECT @processed = @@ROWCOUNT;
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
/****** Object:  StoredProcedure [dbo].[stInsertPatients]    Script Date: 06/03/2020 2:18:35 PM ******/
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
    @outputMessage NVARCHAR(MAX) OUT,
	@processed int out
	
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
	set transaction isolation level serializable
         BEGIN TRANSACTION		 
		 
		MERGE Patient WITH (HOLDLOCK) AS a
		USING		
		(select * 
		from  (SELECT *, row_number() over (Partition by IdNo order by idNo desc) as rn
			  from @dtPatients) as R
		where R.rn = 1) AS p	
		
		ON a.EnrolmentId = p.EnrolmentId AND a.SiteId = p.SiteId
		and a.IdNo = p.IdNo

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
		INSERT(FirstName, LastName, EnrolmentId, IdNo, VisitDate, StateId, SiteId, DateOfBirth, Age, Sex, Village, Town, PhoneNumber, AddressLine1, State, Lga, MaritalStatus, PreferredLanguage, DateAdded)
		VALUES(p.FirstName, p.LastName, p.EnrolmentId, p.IdNo, p.VisitDate, p.StateId, p.SiteId, p.DateOfBirth, p.Age, p.Sex, p.Village, p.Town, p.PhoneNumber, p.AddressLine1, p.State, p.Lga, p.MaritalStatus, p.PreferredLanguage, cast(getdate() as date));

		  SELECT @processed = @@ROWCOUNT;
          SET @outputMessage = 'success';   
		 COMMIT Transaction
    END TRY
    BEGIN CATCH
	ROLLBACK TRANSACTION;
		SET @outputMessage = 'error - ' + ERROR_MESSAGE();
		DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
		RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[stSearchUsers]    Script Date: 06/03/2020 2:18:35 PM ******/
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
select Id, FirstName, LastName, UserName, Email, UserId, RoleId from
(select * from AspNetUsers where (FirstName like '%' + @searchTerm + '%') or (LastName like '%' + @searchTerm + '%'))u
inner join 
(select * from AspNetUserRoles) r on u.Id = r.UserId
order by FirstName desc  offset  ((@pageNumber-1 )*@itemsPerPage)  rows fetch next @itemsPerPage rows only
END
GO
/****** Object:  StoredProcedure [dbo].[stSiteTestDetailsByPeriod]    Script Date: 06/03/2020 2:18:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Henry Otuadinma
-- Create date: 02/22/2019
-- Description:	Retrieves all Lab results by Site and period
-- =============================================
CREATE PROCEDURE [dbo].[stSiteTestDetailsByPeriod]
	-- Add the parameters for the stored procedure here
	@start as date,
    @end as date,
    @siteId as int,
	@pageNumber as int,
	@itemsPerPage as int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
;WITH labtests AS (	select m.Id as PatientId, a.Id, m.SiteId, EnrolmentId, site.Name as site, IsPregnant, TestDate, DateReported, Description, TestResult
	from
   (select Id, Name from Site where Id = @siteId) as site

 join 
	(select Id, SiteId, EnrolmentId from Patient) m on site.Id = m.SiteId
	 join
	 (select * from (select Id, PatientId, IsPregnant, row_number() over (partition by PatientId order by AppointmentDate desc) as seqnum
		  from ArtVisit) o where seqnum = 1)a on m.Id = a.PatientId
	 join

	(select PatientId, TestDate, DateReported, Description, dbo.RemoveNonNumericChars(TestResult) TestResult from LabResult 
	where TestDate >= @start and TestDate <= @end) b on a.PatientId= b.PatientId)

SELECT * FROM labtests
 cross join (select count(PatientId) as totalSites from labtests) countAll
order by PatientId offset  ((@pageNumber-1 )*@itemsPerPage)  rows fetch next @itemsPerPage rows only;
END
GO
/****** Object:  StoredProcedure [dbo].[stSiteTxCurrAgeSexAggByPeriod]    Script Date: 06/03/2020 2:18:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stSiteTxCurrAgeSexAggByPeriod]
	-- Add the parameters for the stored procedure here	
	@start as date,
	@end as date,
	@siteId as int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	declare @today as date = cast(getdate() as date);

		select sum(m0_4)m0_4,sum(f0_4)f0_4, sum(m5_9)m5_9, sum(f5_9)f5_9, sum(m10_14)m10_14, sum(f10_14)f10_14, sum(m15_19)m15_19, sum(f15_19)f15_19, sum(m20_24)m20_24, sum(f20_24)f20_24, sum(m25_29)m25_29, sum(f25_29)f25_29, sum(m30_34)m30_34,sum(f30_34)f30_34,sum(m35_39)m35_39,sum(f35_39)f35_39,sum(m40_44)m40_44,sum(f40_44)f40_44,sum(m45_49)m45_49,sum(f45_49)f45_49,sum(m50)m50,sum(f50)f50

from
(	select sum(case when datediff(year, cast(DateOfBirth as date), @today) > 0 and datediff(year, cast(DateOfBirth as date), @today) < 5 and Sex = 'Male' then 1 else 0 end) as m0_4, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) > 0 and datediff(year, cast(DateOfBirth as date), @today) < 5 and Sex = 'Female' then 1 else 0 end) as f0_4,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 5  and datediff(year, cast(DateOfBirth as date), @today) <= 9 and Sex = 'Male' then 1 else 0 end) as m5_9, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 5  and datediff(year, cast(DateOfBirth as date), @today) <= 9 and Sex = 'Female' then 1 else 0 end) as f5_9,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 10  and datediff(year, cast(DateOfBirth as date), @today) <= 14 and Sex = 'Male' then 1 else 0 end) as m10_14, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 10  and datediff(year, cast(DateOfBirth as date), @today) <= 14 and Sex = 'Female' then 1 else 0 end) as f10_14,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 15  and datediff(year, cast(DateOfBirth as date), @today) <= 19 and Sex = 'Male' then 1 else 0 end) as m15_19, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 15  and datediff(year, cast(DateOfBirth as date), @today) <= 19 and Sex = 'Female' then 1 else 0 end) as f15_19,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 20  and datediff(year, cast(DateOfBirth as date), @today) <= 24 and Sex = 'Male' then 1 else 0 end) as m20_24, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 20  and datediff(year, cast(DateOfBirth as date), @today) <= 24 and Sex = 'Female' then 1 else 0 end) as f20_24,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 25  and datediff(year, cast(DateOfBirth as date), @today) <= 29 and Sex = 'Male' then 1 else 0 end) as m25_29, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 25  and datediff(year, cast(DateOfBirth as date), @today) <= 29 and Sex = 'Female' then 1 else 0 end) as f25_29,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 30  and datediff(year, cast(DateOfBirth as date), @today) <= 34 and Sex = 'Male' then 1 else 0 end) as m30_34, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 30  and datediff(year, cast(DateOfBirth as date), @today) <= 34 and Sex = 'Female' then 1 else 0 end) as f30_34,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 35  and datediff(year, cast(DateOfBirth as date), @today) <= 39 and Sex = 'Male' then 1 else 0 end) as m35_39, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 35  and datediff(year, cast(DateOfBirth as date), @today) <= 39 and Sex = 'Female' then 1 else 0 end) as f35_39,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 40  and datediff(year, cast(DateOfBirth as date), @today) <= 44 and Sex = 'Male' then 1 else 0 end) as m40_44, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 40  and datediff(year, cast(DateOfBirth as date), @today) <= 44 and Sex = 'Female' then 1 else 0 end) as f40_44,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 45  and datediff(year, cast(DateOfBirth as date), @today) <= 49 and Sex = 'Male' then 1 else 0 end) as m45_49, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 45  and datediff(year, cast(DateOfBirth as date), @today) <= 49 and Sex = 'Female' then 1 else 0 end) as f45_49,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 50 and Sex = 'Male' then 1 else 0 end) as m50, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 50 and Sex = 'Female' then 1 else 0 end) as f50, Id
from (select distinct Id, Sex, DateOfBirth from Patient where SiteId = @siteId group by Id, DateOfBirth, Sex) as w

inner join

(select * from (select PatientId,
             row_number() over (partition by PatientId order by AppointmentDate desc) as seqnum
      from ArtVisit o where @today <= cast(dateadd(day, 28, AppointmentDate) as date)
     ) o where seqnum = 1) n on w.Id = n.PatientId group by w.Id)p
END
GO
/****** Object:  StoredProcedure [dbo].[stSiteTxCurrAgeSexByPeriod]    Script Date: 06/03/2020 2:18:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stSiteTxCurrAgeSexByPeriod] 
	-- Add the parameters for the stored procedure here
	@start date,
	@end date,
	@pageNumber as int,
	@itemsPerPage as int,
	@siteId as int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	declare @today as date = cast(getdate() as date);
	
;WITH txCrrLinelist AS (
    select j.Id, StateCode, EnrolmentId, HivConfirmationDate, EnrolmentDate, ArtDate, VisitDate, IsPregnant, AppointmentDate, ArvRegimen1, ArvRegimen2, ArvRegimen3, ArvRegimenCode, AdvDrugCode, 	
	r1, r2, r3, r, TestDate, DateReported, Description, TestResult, SiteId as site, datediff(year, cast(DateOfBirth as date), @today) as age, Sex as gender from

(select Id, StateId, Name, StateCode from Site where Id = @siteId) as site

	inner join
	
(select distinct Id, EnrolmentId, SiteId, DateOfBirth, Sex  from Patient)j on site.Id = j.SiteId
	
	inner join

(select * from (select PatientId, ArtDate, EnrolmentDate, HivConfirmationDate,
             row_number() over (partition by PatientId order by ArtDate desc) as seqnum
      from ArtBaseline o  where  ArtDate is not null and year(ArtDate) > 2000 
     ) o where seqnum = 1) b on j.Id = b.PatientId

inner join

(select * from (select PatientId, IsPregnant,ArvRegimen1, ArvRegimen2, ArvRegimen3, ArvRegimenCode, AdvDrugCode, VisitDate, AppointmentDate,
             row_number() over (partition by PatientId order by AppointmentDate desc) as seqnum
      from ArtVisit o where @start <= cast(dateadd(day, 28, AppointmentDate) as date) and @end <= cast(dateadd(day, 28, AppointmentDate) as date)
     ) o where seqnum = 1)h on b.PatientId = h.PatientId

	 left outer join

(select * from (select PatientId, ArvRegimen1 r1, ArvRegimen2 r2, ArvRegimen3 r3, ArvRegimenCode r,
             row_number() over (partition by PatientId order by AppointmentDate asc) as seqnum
      from ArtVisit
     ) o where seqnum = 1)k on b.PatientId = k.PatientId

	 left outer join

	 (select *
		from (select o.PatientId, TestDate, DateReported, Description, TestResult,
					 row_number() over (partition by PatientId order by TestDate desc) as seqnum
			  from LabResult o where Description like '%Viral%'
			 ) o

		where seqnum = 1)l on j.Id = l.PatientId
)

SELECT *, total FROM txCrrLinelist s
 cross join (select count(EnrolmentId) as total from txCrrLinelist) countAll
order by s.Id offset  ((@pageNumber-1 )*@itemsPerPage)  rows fetch next @itemsPerPage rows only;
END
GO
/****** Object:  StoredProcedure [dbo].[stSiteTxNewAgeSexByPeriod]    Script Date: 06/03/2020 2:18:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stSiteTxNewAgeSexByPeriod]
	-- Add the parameters for the stored procedure here
	@start date,
	@end date,
	@pageNumber as int,
	@itemsPerPage as int,
	@siteId as int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	declare @today as date = cast(getdate() as date);

;WITH txNewLinelist AS (	select j.Id, StateCode, EnrolmentId, IsPregnant, HivConfirmationDate, EnrolmentDate, ArtDate, VisitDate, AppointmentDate, ArvRegimen1, ArvRegimen2, ArvRegimen3, ArvRegimenCode, AdvDrugCode, TestDate, DateReported, Description, TestResult, SiteId as site, datediff(year, cast(DateOfBirth as date), @today) as age, Sex as gender from

((select Id, StateId, Name, StateCode from Site where Id = @siteId) as site

	inner join
	
(select distinct Id, EnrolmentId, SiteId, DateOfBirth, Sex  from Patient)j on site.Id = j.SiteId
	
	inner join

(select * from (select PatientId, ArtDate, EnrolmentDate, HivConfirmationDate,
             row_number() over (partition by PatientId order by ArtDate desc) as seqnum
      from ArtBaseline o  where  ArtDate >= @start and ArtDate <= @end and ArtDate is not null and year(ArtDate) > 2000
     ) o where seqnum = 1) b on j.Id = b.PatientId

inner join

(select * from (select PatientId, IsPregnant, ArvRegimen1, ArvRegimen2, ArvRegimen3, ArvRegimenCode, AdvDrugCode, VisitDate, AppointmentDate,
             row_number() over (partition by PatientId order by AppointmentDate desc) as seqnum
      from ArtVisit o
     ) o where seqnum = 1)h on b.PatientId = h.PatientId

	 left join

	 (select *
		from (select o.PatientId, TestDate, DateReported, Description, TestResult,
					 row_number() over (partition by PatientId order by TestDate desc) as seqnum
			  from LabResult o where Description like '%Viral%'
			 ) o

		where seqnum = 1)l on j.Id = l.PatientId) order by j.Id offset  ((@pageNumber-1 )*@itemsPerPage)  rows fetch next @itemsPerPage rows only)

		SELECT *, countAll.total FROM txNewLinelist s
 cross join (select count(EnrolmentId) as total from txNewLinelist) countAll
order by s.Id offset  ((@pageNumber-1 )*@itemsPerPage)  rows fetch next @itemsPerPage rows only;

END
GO
/****** Object:  StoredProcedure [dbo].[stSiteVLoadAgeSexByPeriod]    Script Date: 06/03/2020 2:18:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Henry Otuadinma
-- Create date: 2019-08-06
-- Description:	Retrieves Viral suppression for a site by age band and gender
-- =============================================
CREATE PROCEDURE [dbo].[stSiteVLoadAgeSexByPeriod]
	-- Add the parameters for the stored procedure here
	@start as date,
	@end as date,
	@siteId as int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	declare @today as date = cast(getdate() as date);

	select site.Id as id, site.Name as site, site.StateCode as stateCode, u.Id as patient, datediff(year, cast(DateOfBirth as date), @today) as age, Sex as gender

from

	(select Id, Name, StateCode from Site where Id = @siteId) site

	join
		(select distinct Id, SiteId, DateOfBirth, Sex  from Patient o join (select PatientId from ArtBaseline) d on o.Id = d.PatientId) u on u.SiteId = site.Id
		
		join		

	(select o.PatientId
		from (select o.PatientId,
					 row_number() over (partition by PatientId order by TestDate desc) as seqnum
			  from LabResult o where o.TestDate >= @start and o.TestDate <= @end
			 ) o

		where seqnum = 1)h on u.Id = h.PatientId
END
GO
/****** Object:  StoredProcedure [dbo].[stStateTestDetailsByPeriod]    Script Date: 06/03/2020 2:18:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Henry Otuadinma
-- Create date: 02/22/2019
-- Description:	Retrieves all Lab results by State period
-- =============================================
CREATE PROCEDURE [dbo].[stStateTestDetailsByPeriod] 
	-- Add the parameters for the stored procedure here
	@start as date,
	@end as date,
	@stateId as int,
	@pageNumber as int,
    @itemsPerPage as int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

;WITH labtests AS (select m.Id as PatientId, a.Id, m.SiteId, site.Name as site, EnrolmentId, IsPregnant, TestDate, DateReported, Description, TestResult
from
   
(select Id, StateId, Name from Site where StateId = @stateId) as site

 join 
 
(select Id, SiteId, EnrolmentId from Patient) m on site.Id = m.SiteId
 join
 (select * from (select Id, PatientId, IsPregnant, row_number() over (partition by PatientId order by AppointmentDate desc) as seqnum
      from ArtVisit) o where seqnum = 1)a on m.Id = a.PatientId
 join

(select PatientId, TestDate, DateReported, Description, dbo.RemoveNonNumericChars(TestResult) TestResult from LabResult 
where  TestDate >= @start and TestDate <= @end) b on a.PatientId= b.PatientId)

SELECT * FROM labtests
 cross join (select count(PatientId) as totalSites from labtests) countAll
order by PatientId offset  ((@pageNumber-1 )*@itemsPerPage)  rows fetch next @itemsPerPage rows only;

END

GO
/****** Object:  StoredProcedure [dbo].[stStateTxCurrAgeSexAggByPeriod]    Script Date: 06/03/2020 2:18:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stStateTxCurrAgeSexAggByPeriod] 
	-- Add the parameters for the stored procedure here
	@start as date,
	@end as date,
	@stateId as int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
declare @today as date = cast(getdate() as date);

select sum(m0_4)m0_4,sum(f0_4)f0_4, sum(m5_9)m5_9, sum(f5_9)f5_9, sum(m10_14)m10_14, sum(f10_14)f10_14, sum(m15_19)m15_19, sum(f15_19)f15_19, sum(m20_24)m20_24, sum(f20_24)f20_24, sum(m25_29)m25_29, sum(f25_29)f25_29, sum(m30_34)m30_34,sum(f30_34)f30_34,sum(m35_39)m35_39,sum(f35_39)f35_39,sum(m40_44)m40_44,sum(f40_44)f40_44,sum(m45_49)m45_49,sum(f45_49)f45_49,sum(m50)m50,sum(f50)f50

from
    (select Id, StateId from Site where StateId = @stateId) as site

 right join 
 (
	select sum(case when datediff(year, cast(DateOfBirth as date), @today) > 0 and datediff(year, cast(DateOfBirth as date), @today) < 5 and Sex = 'Male' then 1 else 0 end) as m0_4, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) > 0 and datediff(year, cast(DateOfBirth as date), @today) < 5 and Sex = 'Female' then 1 else 0 end) as f0_4,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 5  and datediff(year, cast(DateOfBirth as date), @today) <= 9 and Sex = 'Male' then 1 else 0 end) as m5_9, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 5  and datediff(year, cast(DateOfBirth as date), @today) <= 9 and Sex = 'Female' then 1 else 0 end) as f5_9,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 10  and datediff(year, cast(DateOfBirth as date), @today) <= 14 and Sex = 'Male' then 1 else 0 end) as m10_14, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 10  and datediff(year, cast(DateOfBirth as date), @today) <= 14 and Sex = 'Female' then 1 else 0 end) as f10_14,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 15  and datediff(year, cast(DateOfBirth as date), @today) <= 19 and Sex = 'Male' then 1 else 0 end) as m15_19, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 15  and datediff(year, cast(DateOfBirth as date), @today) <= 19 and Sex = 'Female' then 1 else 0 end) as f15_19,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 20  and datediff(year, cast(DateOfBirth as date), @today) <= 24 and Sex = 'Male' then 1 else 0 end) as m20_24, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 20  and datediff(year, cast(DateOfBirth as date), @today) <= 24 and Sex = 'Female' then 1 else 0 end) as f20_24,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 25  and datediff(year, cast(DateOfBirth as date), @today) <= 29 and Sex = 'Male' then 1 else 0 end) as m25_29, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 25  and datediff(year, cast(DateOfBirth as date), @today) <= 29 and Sex = 'Female' then 1 else 0 end) as f25_29,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 30  and datediff(year, cast(DateOfBirth as date), @today) <= 34 and Sex = 'Male' then 1 else 0 end) as m30_34, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 30  and datediff(year, cast(DateOfBirth as date), @today) <= 34 and Sex = 'Female' then 1 else 0 end) as f30_34,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 35  and datediff(year, cast(DateOfBirth as date), @today) <= 39 and Sex = 'Male' then 1 else 0 end) as m35_39, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 35  and datediff(year, cast(DateOfBirth as date), @today) <= 39 and Sex = 'Female' then 1 else 0 end) as f35_39,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 40  and datediff(year, cast(DateOfBirth as date), @today) <= 44 and Sex = 'Male' then 1 else 0 end) as m40_44, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 40  and datediff(year, cast(DateOfBirth as date), @today) <= 44 and Sex = 'Female' then 1 else 0 end) as f40_44,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 45  and datediff(year, cast(DateOfBirth as date), @today) <= 49 and Sex = 'Male' then 1 else 0 end) as m45_49, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 45  and datediff(year, cast(DateOfBirth as date), @today) <= 49 and Sex = 'Female' then 1 else 0 end) as f45_49,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 50 and Sex = 'Male' then 1 else 0 end) as m50, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 50 and Sex = 'Female' then 1 else 0 end) as f50, Id, SiteId
from (select distinct Id, Sex, SiteId, DateOfBirth from Patient group by Id, SiteId, DateOfBirth, Sex) as w

inner join

(select * from (select PatientId, ArvRegimen1, ArvRegimen2, ArvRegimen3, ArvRegimenCode, AdvDrugCode, VisitDate, AppointmentDate,
             row_number() over (partition by PatientId order by AppointmentDate desc) as seqnum
      from ArtVisit o where @start <= cast(dateadd(day, 28, AppointmentDate) as date) and @end <= cast(dateadd(day, 28, AppointmentDate) as date)
     ) o where seqnum = 1) n on w.Id = n.PatientId group by w.SiteId, w.Id

) c on site.Id = c.SiteId
END
GO
/****** Object:  StoredProcedure [dbo].[stTestDetailsByPeriod]    Script Date: 06/03/2020 2:18:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Henry Otuadinma
-- Create date: 02/22/2019
-- Description:	Retrieves all Lab results by period
-- =============================================
CREATE PROCEDURE [dbo].[stTestDetailsByPeriod]
	-- Add the parameters for the stored procedure here
	@start as date,
	@end as date,
	@pageNumber as int,
    @itemsPerPage as int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

;WITH labtests AS (select m.Id as PatientId, a.Id, m.SiteId, site.Name as site, EnrolmentId, IsPregnant, TestDate, DateReported, Description, TestResult
	from
   
(select Id, StateId, Name from Site) as site

 join 
 
 (select Id, SiteId, EnrolmentId from Patient)m on site.Id = m.SiteId
 join
 (select * from (select Id, PatientId, IsPregnant, row_number() over (partition by PatientId order by AppointmentDate desc) as seqnum
      from ArtVisit) o where seqnum = 1)a on m.Id = a.PatientId
	  join
(select PatientId, TestDate, DateReported, Description, dbo.RemoveNonNumericChars(TestResult) TestResult from LabResult 
where  TestDate >= @start and TestDate <= @end) b on a.PatientId= b.PatientId)

SELECT * FROM labtests
 cross join (select count(PatientId) as totalSites from labtests) countAll
order by PatientId offset  ((@pageNumber-1 )*@itemsPerPage)  rows fetch next @itemsPerPage rows only;
END
GO
/****** Object:  StoredProcedure [dbo].[stTxCurrAgeSexByPeriod]    Script Date: 06/03/2020 2:18:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Henry Otuadinma
-- Create date: 08/08/2019 2:44:35 PM
-- Description:	Gets TXCURR By Age band and Gender
-- =============================================
CREATE PROCEDURE [dbo].[stTxCurrAgeSexByPeriod] 
	-- Add the parameters for the stored procedure here
	@start as date,
	@end as date,
	@pageNumber as int,
	@itemsPerPage as int,
	@stateId as int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	declare @today as date = cast(getdate() as date);
	
select StateCode, EnrolmentId, HivConfirmationDate, EnrolmentDate, ArtDate, VisitDate, AppointmentDate, ArvRegimen1, ArvRegimen2, ArvRegimen3, ArvRegimenCode, AdvDrugCode, TestDate, DateReported, Description, TestResult, SiteId as site, datediff(year, cast(DateOfBirth as date), @today) as age, Sex as gender from

(select Id, StateId, Name, StateCode from Site s join (select SiteId from Patient group by SiteId having count(distinct SiteId) > 0 ) d on s.Id = d.SiteId where StateId = @stateId order by Id offset ((@pageNumber-1 )*@itemsPerPage)  rows fetch next @itemsPerPage rows only) as site

	inner join
	
(select distinct Id, EnrolmentId, SiteId, DateOfBirth, Sex  from Patient)j on site.Id = j.SiteId
	
	inner join

(select * from (select PatientId, ArtDate, EnrolmentDate, HivConfirmationDate,
             row_number() over (partition by PatientId order by ArtDate desc) as seqnum
      from ArtBaseline o  where  ArtDate is not null and year(ArtDate) > 2000
     ) o where seqnum = 1) b on j.Id = b.PatientId

inner join

(select * from (select PatientId, ArvRegimen1, ArvRegimen2, ArvRegimen3, ArvRegimenCode, AdvDrugCode, VisitDate, AppointmentDate,
             row_number() over (partition by PatientId order by AppointmentDate desc) as seqnum
      from ArtVisit o where @start <= cast(dateadd(day, 28, AppointmentDate) as date) and @end <= cast(dateadd(day, 28, AppointmentDate) as date)
     ) o where seqnum = 1)h on b.PatientId = h.PatientId

	 left join

	 (select *
		from (select o.PatientId, TestDate, DateReported, Description, TestResult,
					 row_number() over (partition by PatientId order by TestDate desc) as seqnum
			  from LabResult o
			 ) o

		where seqnum = 1)l on j.Id = l.PatientId
END
GO
/****** Object:  StoredProcedure [dbo].[stTxCurrAggByAgeSex]    Script Date: 06/03/2020 2:18:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stTxCurrAggByAgeSex] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
declare @today as date = cast(getdate() as date);

select StateId, sum(m0_4)m0_4,sum(f0_4)f0_4, sum(m5_9)m5_9, sum(f5_9)f5_9, sum(m10_14)m10_14, sum(f10_14)f10_14, sum(m15_19)m15_19, sum(f15_19)f15_19, sum(m20_24)m20_24, sum(f20_24)f20_24, sum(m25_29)m25_29, sum(f25_29)f25_29, sum(m30_34)m30_34,sum(f30_34)f30_34,sum(m35_39)m35_39,sum(f35_39)f35_39,sum(m40_44)m40_44,sum(f40_44)f40_44,sum(m45_49)m45_49,sum(f45_49)f45_49,sum(m50)m50,sum(f50)f50

from
    (select Id, StateId from Site s join (select SiteId from Patient group by SiteId having count(distinct SiteId) > 0 ) d on s.Id = d.SiteId) as site

 right join 
 (
	select sum(case when datediff(year, cast(DateOfBirth as date), @today) > 0 and datediff(year, cast(DateOfBirth as date), @today) < 5 and Sex = 'Male' then 1 else 0 end) as m0_4, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) > 0 and datediff(year, cast(DateOfBirth as date), @today) < 5 and Sex = 'Female' then 1 else 0 end) as f0_4,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 5  and datediff(year, cast(DateOfBirth as date), @today) <= 9 and Sex = 'Male' then 1 else 0 end) as m5_9, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 5  and datediff(year, cast(DateOfBirth as date), @today) <= 9 and Sex = 'Female' then 1 else 0 end) as f5_9,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 10  and datediff(year, cast(DateOfBirth as date), @today) <= 14 and Sex = 'Male' then 1 else 0 end) as m10_14, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 10  and datediff(year, cast(DateOfBirth as date), @today) <= 14 and Sex = 'Female' then 1 else 0 end) as f10_14,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 15  and datediff(year, cast(DateOfBirth as date), @today) <= 19 and Sex = 'Male' then 1 else 0 end) as m15_19, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 15  and datediff(year, cast(DateOfBirth as date), @today) <= 19 and Sex = 'Female' then 1 else 0 end) as f15_19,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 20  and datediff(year, cast(DateOfBirth as date), @today) <= 24 and Sex = 'Male' then 1 else 0 end) as m20_24, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 20  and datediff(year, cast(DateOfBirth as date), @today) <= 24 and Sex = 'Female' then 1 else 0 end) as f20_24,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 25  and datediff(year, cast(DateOfBirth as date), @today) <= 29 and Sex = 'Male' then 1 else 0 end) as m25_29, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 25  and datediff(year, cast(DateOfBirth as date), @today) <= 29 and Sex = 'Female' then 1 else 0 end) as f25_29,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 30  and datediff(year, cast(DateOfBirth as date), @today) <= 34 and Sex = 'Male' then 1 else 0 end) as m30_34, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 30  and datediff(year, cast(DateOfBirth as date), @today) <= 34 and Sex = 'Female' then 1 else 0 end) as f30_34,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 35  and datediff(year, cast(DateOfBirth as date), @today) <= 39 and Sex = 'Male' then 1 else 0 end) as m35_39, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 35  and datediff(year, cast(DateOfBirth as date), @today) <= 39 and Sex = 'Female' then 1 else 0 end) as f35_39,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 40  and datediff(year, cast(DateOfBirth as date), @today) <= 44 and Sex = 'Male' then 1 else 0 end) as m40_44, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 40  and datediff(year, cast(DateOfBirth as date), @today) <= 44 and Sex = 'Female' then 1 else 0 end) as f40_44,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 45  and datediff(year, cast(DateOfBirth as date), @today) <= 49 and Sex = 'Male' then 1 else 0 end) as m45_49, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 45  and datediff(year, cast(DateOfBirth as date), @today) <= 49 and Sex = 'Female' then 1 else 0 end) as f45_49,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 50 and Sex = 'Male' then 1 else 0 end) as m50, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 50 and Sex = 'Female' then 1 else 0 end) as f50, Id, SiteId
from (select distinct Id, Sex, SiteId, DateOfBirth from Patient group by Id, SiteId, DateOfBirth, Sex) as w

inner join

(select * from (select PatientId,
             row_number() over (partition by PatientId order by AppointmentDate desc) as seqnum
      from ArtVisit o where @today <= cast(dateadd(day, 28, AppointmentDate) as date)
     ) o where seqnum = 1) n on w.Id = n.PatientId group by w.SiteId, w.Id

) c on site.Id = c.SiteId group by site.StateId
END
GO
/****** Object:  StoredProcedure [dbo].[stTxNewAgeSexAggByPeriod]    Script Date: 06/03/2020 2:18:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stTxNewAgeSexAggByPeriod]
	-- Add the parameters for the stored procedure here
	@start date,
	@end date
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	declare @today as date = cast(getdate() as date);

	select StateId, sum(m0_4)m0_4,sum(f0_4)f0_4, sum(m5_9)m5_9, sum(f5_9)f5_9, sum(m10_14)m10_14, sum(f10_14)f10_14, sum(m15_19)m15_19, sum(f15_19)f15_19, sum(m20_24)m20_24, sum(f20_24)f20_24, sum(m25_29)m25_29, sum(f25_29)f25_29, sum(m30_34)m30_34,sum(f30_34)f30_34,sum(m35_39)m35_39,sum(f35_39)f35_39,sum(m40_44)m40_44,sum(f40_44)f40_44,sum(m45_49)m45_49,sum(f45_49)f45_49,sum(m50)m50,sum(f50)f50

from
    (select Id, StateId from Site s join (select SiteId from Patient group by SiteId having count(distinct SiteId) > 0 ) d on s.Id = d.SiteId) as site

 right join 
 (
	select sum(case when datediff(year, cast(DateOfBirth as date), @today) > 0 and datediff(year, cast(DateOfBirth as date), @today) < 5 and Sex = 'Male' then 1 else 0 end) as m0_4, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) > 0 and datediff(year, cast(DateOfBirth as date), @today) < 5 and Sex = 'Female' then 1 else 0 end) as f0_4,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 5  and datediff(year, cast(DateOfBirth as date), @today) <= 9 and Sex = 'Male' then 1 else 0 end) as m5_9, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 5  and datediff(year, cast(DateOfBirth as date), @today) <= 9 and Sex = 'Female' then 1 else 0 end) as f5_9,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 10  and datediff(year, cast(DateOfBirth as date), @today) <= 14 and Sex = 'Male' then 1 else 0 end) as m10_14, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 10  and datediff(year, cast(DateOfBirth as date), @today) <= 14 and Sex = 'Female' then 1 else 0 end) as f10_14,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 15  and datediff(year, cast(DateOfBirth as date), @today) <= 19 and Sex = 'Male' then 1 else 0 end) as m15_19, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 15  and datediff(year, cast(DateOfBirth as date), @today) <= 19 and Sex = 'Female' then 1 else 0 end) as f15_19,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 20  and datediff(year, cast(DateOfBirth as date), @today) <= 24 and Sex = 'Male' then 1 else 0 end) as m20_24, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 20  and datediff(year, cast(DateOfBirth as date), @today) <= 24 and Sex = 'Female' then 1 else 0 end) as f20_24,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 25  and datediff(year, cast(DateOfBirth as date), @today) <= 29 and Sex = 'Male' then 1 else 0 end) as m25_29, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 25  and datediff(year, cast(DateOfBirth as date), @today) <= 29 and Sex = 'Female' then 1 else 0 end) as f25_29,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 30  and datediff(year, cast(DateOfBirth as date), @today) <= 34 and Sex = 'Male' then 1 else 0 end) as m30_34, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 30  and datediff(year, cast(DateOfBirth as date), @today) <= 34 and Sex = 'Female' then 1 else 0 end) as f30_34,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 35  and datediff(year, cast(DateOfBirth as date), @today) <= 39 and Sex = 'Male' then 1 else 0 end) as m35_39, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 35  and datediff(year, cast(DateOfBirth as date), @today) <= 39 and Sex = 'Female' then 1 else 0 end) as f35_39,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 40  and datediff(year, cast(DateOfBirth as date), @today) <= 44 and Sex = 'Male' then 1 else 0 end) as m40_44, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 40  and datediff(year, cast(DateOfBirth as date), @today) <= 44 and Sex = 'Female' then 1 else 0 end) as f40_44,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 45  and datediff(year, cast(DateOfBirth as date), @today) <= 49 and Sex = 'Male' then 1 else 0 end) as m45_49, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 45  and datediff(year, cast(DateOfBirth as date), @today) <= 49 and Sex = 'Female' then 1 else 0 end) as f45_49,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 50 and Sex = 'Male' then 1 else 0 end) as m50, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 50 and Sex = 'Female' then 1 else 0 end) as f50, Id, SiteId
from (select distinct Id, Sex, SiteId, DateOfBirth from Patient group by Id, SiteId, DateOfBirth, Sex) as w

inner join

(select * from (select PatientId, ArtDate, EnrolmentDate, HivConfirmationDate,
             row_number() over (partition by PatientId order by ArtDate desc) as seqnum
      from ArtBaseline o  where  ArtDate >= @start and ArtDate <= @end
     ) o where seqnum = 1) b on w.Id = b.PatientId
	 	 
	 group by w.SiteId, w.Id

) c on site.Id = c.SiteId group by site.StateId
END
GO
/****** Object:  StoredProcedure [dbo].[stTxNewAgeSexByPeriod]    Script Date: 06/03/2020 2:18:35 PM ******/
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
	@start as date,
	@end as date,
	@pageNumber as int,
	@itemsPerPage as int,
	@stateId as int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	declare @today as date = cast(getdate() as date);
	
select StateCode, EnrolmentId, HivConfirmationDate, EnrolmentDate, ArtDate, VisitDate, AppointmentDate, ArvRegimen1, ArvRegimen2, ArvRegimen3, ArvRegimenCode, AdvDrugCode, TestDate, DateReported, Description, TestResult, SiteId as site, datediff(year, cast(DateOfBirth as date), @today) as age, Sex as gender from

(select Id, StateId, Name, StateCode from Site s join (select SiteId from Patient group by SiteId having count(distinct SiteId) > 0 ) d on s.Id = d.SiteId where StateId = @stateId order by Id offset ((@pageNumber-1 )*@itemsPerPage)  rows fetch next @itemsPerPage rows only) as site

	join
	
(select distinct Id, EnrolmentId, SiteId, DateOfBirth, Sex  from Patient)j on site.Id = j.SiteId
	
	join

(select * from (select PatientId, ArtDate, EnrolmentDate, HivConfirmationDate,
             row_number() over (partition by PatientId order by ArtDate desc) as seqnum
      from ArtBaseline o  where  ArtDate >= @start and ArtDate <= @end and ArtDate is not null and year(ArtDate) > 2000
     ) o where seqnum = 1) b on j.Id = b.PatientId

join

(select * from (select PatientId, ArvRegimen1, ArvRegimen2, ArvRegimen3, ArvRegimenCode, AdvDrugCode, VisitDate, AppointmentDate,
             row_number() over (partition by PatientId order by AppointmentDate desc) as seqnum
      from ArtVisit o
     ) o where seqnum = 1)h on b.PatientId = h.PatientId

	 left join

	 (select *
		from (select o.PatientId, TestDate, DateReported, Description, TestResult,
					 row_number() over (partition by PatientId order by TestDate desc) as seqnum
			  from LabResult o
			 ) o

		where seqnum = 1)l on j.Id = l.PatientId
END
GO
/****** Object:  StoredProcedure [dbo].[stTxNewAggByAgeSex]    Script Date: 06/03/2020 2:18:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stTxNewAggByAgeSex]
	-- Add the parameters for the stored procedure here	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	declare @today as date = cast(getdate() as date);

	select StateId, sum(m0_4)m0_4,sum(f0_4)f0_4, sum(m5_9)m5_9, sum(f5_9)f5_9, sum(m10_14)m10_14, sum(f10_14)f10_14, sum(m15_19)m15_19, sum(f15_19)f15_19, sum(m20_24)m20_24, sum(f20_24)f20_24, sum(m25_29)m25_29, sum(f25_29)f25_29, sum(m30_34)m30_34,sum(f30_34)f30_34,sum(m35_39)m35_39,sum(f35_39)f35_39,sum(m40_44)m40_44,sum(f40_44)f40_44,sum(m45_49)m45_49,sum(f45_49)f45_49,sum(m50)m50,sum(f50)f50

from
    (select Id, StateId from Site s join (select SiteId from Patient group by SiteId having count(distinct SiteId) > 0 ) d on s.Id = d.SiteId) as site

 right join 
 (
	select sum(case when datediff(year, cast(DateOfBirth as date), @today) > 0 and datediff(year, cast(DateOfBirth as date), @today) < 5 and Sex like '%male%' then 1 else 0 end) as m0_4, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) > 0 and datediff(year, cast(DateOfBirth as date), @today) < 5 and Sex like '%female%' then 1 else 0 end) as f0_4,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 5  and datediff(year, cast(DateOfBirth as date), @today) <= 9 and Sex like '%male%' then 1 else 0 end) as m5_9, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 5  and datediff(year, cast(DateOfBirth as date), @today) <= 9 and Sex like '%female%' then 1 else 0 end) as f5_9,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 10  and datediff(year, cast(DateOfBirth as date), @today) <= 14 and Sex like '%male%' then 1 else 0 end) as m10_14, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 10  and datediff(year, cast(DateOfBirth as date), @today) <= 14 and Sex like '%female%' then 1 else 0 end) as f10_14,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 15  and datediff(year, cast(DateOfBirth as date), @today) <= 19 and Sex like '%male%' then 1 else 0 end) as m15_19, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 15  and datediff(year, cast(DateOfBirth as date), @today) <= 19 and Sex like '%female%' then 1 else 0 end) as f15_19,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 20  and datediff(year, cast(DateOfBirth as date), @today) <= 24 and Sex like '%male%' then 1 else 0 end) as m20_24, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 20  and datediff(year, cast(DateOfBirth as date), @today) <= 24 and Sex like '%female%' then 1 else 0 end) as f20_24,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 25  and datediff(year, cast(DateOfBirth as date), @today) <= 29 and Sex like '%male%' then 1 else 0 end) as m25_29, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 25  and datediff(year, cast(DateOfBirth as date), @today) <= 29 and Sex like '%female%' then 1 else 0 end) as f25_29,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 30  and datediff(year, cast(DateOfBirth as date), @today) <= 34 and Sex like '%male%' then 1 else 0 end) as m30_34, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 30  and datediff(year, cast(DateOfBirth as date), @today) <= 34 and Sex like '%female%' then 1 else 0 end) as f30_34,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 35  and datediff(year, cast(DateOfBirth as date), @today) <= 39 and Sex like '%male%' then 1 else 0 end) as m35_39, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 35  and datediff(year, cast(DateOfBirth as date), @today) <= 39 and Sex like '%female%' then 1 else 0 end) as f35_39,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 40  and datediff(year, cast(DateOfBirth as date), @today) <= 44 and Sex like '%male%' then 1 else 0 end) as m40_44, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 40  and datediff(year, cast(DateOfBirth as date), @today) <= 44 and Sex like '%female%' then 1 else 0 end) as f40_44,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 45  and datediff(year, cast(DateOfBirth as date), @today) <= 49 and Sex like '%male%' then 1 else 0 end) as m45_49, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 45  and datediff(year, cast(DateOfBirth as date), @today) <= 49 and Sex like '%female%' then 1 else 0 end) as f45_49,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 50 and Sex like '%male%' then 1 else 0 end) as m50, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 50 and Sex like '%female%' then 1 else 0 end) as f50, Id, SiteId
from (select distinct Id, Sex, SiteId, DateOfBirth from Patient group by Id, SiteId, DateOfBirth, Sex) as w

inner join

(select * from (select PatientId, ArtDate, EnrolmentDate, HivConfirmationDate,
             row_number() over (partition by PatientId order by ArtDate desc) as seqnum
      from ArtBaseline o  where year(ArtDate) = year(@today) and ((((month(dateadd(month, -9, ArtDate))) + 2)/3) = (((month(dateadd(month, -9, @today))) + 2)/3))
     ) o where seqnum = 1) b on w.Id = b.PatientId
	 	 
	 group by w.SiteId, w.Id

) c on site.Id = c.SiteId group by site.StateId
END
GO
/****** Object:  StoredProcedure [dbo].[stVLAggByAgeBand]    Script Date: 06/03/2020 2:18:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Henry Otuadinma
-- Create date: 01/11/2019
-- Description: Retrieves Viral Suppression disagggreagation by Age band
-- =============================================
CREATE PROCEDURE [dbo].[stVLAggByAgeBand]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	declare @today as date = cast(getdate() as date);

select StateId, sum(u0_4)u0_4,
sum(s0_4)s0_4, sum(u5_9)u5_9, sum(s5_9)s5_9, sum(u10_14)u10_14, sum(s10_14)s10_14, 
sum(u15_19)u15_19, sum(s15_19)s15_19, sum(u20_24)u20_24, sum(s20_24)s20_24, sum(u25_29)u25_29, sum(s25_29)s25_29, 
sum(u30_34)u30_34, sum(s30_34)s30_34, sum(u35_39)u35_39, sum(s35_39)s35_39, sum(u40_44)u40_44, sum(s40_44)s40_44, sum(u45_49)u45_49, sum(s45_49)s45_49, sum(u50)u50, sum(s50)s50

from
    (select Id, StateId from Site s) as site

 join 
 (
	select sum(case when datediff(year, cast(DateOfBirth as date), @today) > 0 and datediff(year, cast(DateOfBirth as date), @today) < 5 and TestResult >= 1000 then 1 else 0 end) as u0_4, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) > 0 and datediff(year, cast(DateOfBirth as date), @today) < 5 and TestResult > 0 and TestResult < 1000 then 1 else 0 end) as s0_4,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 5  and datediff(year, cast(DateOfBirth as date), @today) <= 9 and TestResult >= 1000 then 1 else 0 end) as u5_9, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 5  and datediff(year, cast(DateOfBirth as date), @today) <= 9 and TestResult > 0 and TestResult < 1000 then 1 else 0 end) as s5_9,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 10  and datediff(year, cast(DateOfBirth as date), @today) <= 14 and TestResult >= 1000 then 1 else 0 end) as u10_14, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 10  and datediff(year, cast(DateOfBirth as date), @today) <= 14 and TestResult > 0 and TestResult < 1000 then 1 else 0 end) as s10_14,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 15  and datediff(year, cast(DateOfBirth as date), @today) <= 19 and TestResult >= 1000 then 1 else 0 end) as u15_19, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 15  and datediff(year, cast(DateOfBirth as date), @today) <= 19 and TestResult > 0 and TestResult < 1000 then 1 else 0 end) as s15_19,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 20  and datediff(year, cast(DateOfBirth as date), @today) <= 24 and TestResult >= 1000 then 1 else 0 end) as u20_24, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 20  and datediff(year, cast(DateOfBirth as date), @today) <= 24 and TestResult > 0 and TestResult < 1000 then 1 else 0 end) as s20_24,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 25  and datediff(year, cast(DateOfBirth as date), @today) <= 29 and TestResult >= 1000 then 1 else 0 end) as u25_29, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 25  and datediff(year, cast(DateOfBirth as date), @today) <= 29 and TestResult > 0 and TestResult < 1000 then 1 else 0 end) as s25_29,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 30  and datediff(year, cast(DateOfBirth as date), @today) <= 34 and TestResult >= 1000 then 1 else 0 end) as u30_34, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 30  and datediff(year, cast(DateOfBirth as date), @today) <= 34 and TestResult > 0 and TestResult < 1000 then 1 else 0 end) as s30_34,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 35  and datediff(year, cast(DateOfBirth as date), @today) <= 39 and TestResult >= 1000 then 1 else 0 end) as u35_39, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 35  and datediff(year, cast(DateOfBirth as date), @today) <= 39 and TestResult > 0 and TestResult < 1000 then 1 else 0 end) as s35_39,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 40  and datediff(year, cast(DateOfBirth as date), @today) <= 44 and TestResult >= 1000 then 1 else 0 end) as u40_44, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 40  and datediff(year, cast(DateOfBirth as date), @today) <= 44 and TestResult > 0 and TestResult < 1000 then 1 else 0 end) as s40_44,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 45  and datediff(year, cast(DateOfBirth as date), @today) <= 49 and TestResult >= 1000 then 1 else 0 end) as u45_49, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 45  and datediff(year, cast(DateOfBirth as date), @today) <= 49 and TestResult > 0 and TestResult < 1000 then 1 else 0 end) as s45_49,

sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 50 and TestResult >= 1000 then 1 else 0 end) as u50, 
sum(case when datediff(year, cast(DateOfBirth as date), @today) >= 50 and TestResult > 0 and TestResult < 1000 then 1 else 0 end) as s50, Id, SiteId
from (select distinct Id, SiteId, DateOfBirth from Patient group by Id, SiteId, DateOfBirth) as w

inner join

(select * from (select PatientId, row_number() over (partition by PatientId order by AppointmentDate desc) as seqnum
      from ArtVisit where (@today <= cast(dateadd(day, 28, AppointmentDate) as date))) o where seqnum = 1) s on w.Id = s.PatientId

left join

(select * from (select PatientId, DateReported, cast(dbo.RemoveNonNumericChars(TestResult) as int) as TestResult, row_number() over (partition by PatientId order by DateReported desc) as seqnum
      from LabResult o where Description like '%viral%' and TestResult is not null and TestResult != '') o where seqnum = 1) n on s.PatientId = n.PatientId group by w.SiteId, w.Id

) c on site.Id = c.SiteId group by site.StateId

END
GO
/****** Object:  StoredProcedure [dbo].[stVLoadAgeSexByPeriod]    Script Date: 06/03/2020 2:18:35 PM ******/
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
	@itemsPerPage as int,
	@stateId as int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	declare @start date = cast(@startDate as date);
	declare @end date = cast(@endDate as date);
	declare @today as date = cast(getdate() as date);
	
select StateCode, EnrolmentId, HivConfirmationDate, EnrolmentDate, ArtDate, ArvRegimen1, ArvRegimen2, ArvRegimen3, ArvRegimenCode, AdvDrugCode, SiteId as site, datediff(year, cast(DateOfBirth as date), @today) as age, Sex as gender from

(select Id, StateId, Name, StateCode from Site where StateId = @stateId order by Id offset ((@pageNumber-1 )*@itemsPerPage)  rows fetch next @itemsPerPage rows only) as site

	inner join
	
(select distinct Id, EnrolmentId, SiteId, DateOfBirth, Sex  from Patient)j on site.Id = j.SiteId
	
	inner join

(select * from (select PatientId, ArtDate, EnrolmentDate, HivConfirmationDate,
             row_number() over (partition by PatientId order by ArtDate desc) as seqnum
      from ArtBaseline o  where  ArtDate >= @start and ArtDate <= @end and ArtDate is not null and year(ArtDate) > 2000
     ) o where seqnum = 1) b on j.Id = b.PatientId

inner join

(select * from (select PatientId, ArvRegimen1, ArvRegimen2, ArvRegimen3, ArvRegimenCode, AdvDrugCode, AppointmentDate,
             row_number() over (partition by PatientId order by AppointmentDate desc) as seqnum
      from ArtVisit o
     ) o where seqnum = 1)h on b.PatientId = h.PatientId
END
GO
USE [master]
GO
ALTER DATABASE [CDR] SET  READ_WRITE 
GO
