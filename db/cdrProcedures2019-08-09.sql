USE [CDR]
GO
/****** Object:  StoredProcedure [dbo].[sp_CallProcedureLog]    Script Date: 09/08/2019 1:56:10 AM ******/
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
/****** Object:  StoredProcedure [dbo].[stActives28ByPartition]    Script Date: 09/08/2019 1:56:10 AM ******/
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
/****** Object:  StoredProcedure [dbo].[stCountClientsOnArt]    Script Date: 09/08/2019 1:56:10 AM ******/
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
/****** Object:  StoredProcedure [dbo].[stCountSearch]    Script Date: 09/08/2019 1:56:10 AM ******/
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
/****** Object:  StoredProcedure [dbo].[stCountSites]    Script Date: 09/08/2019 1:56:10 AM ******/
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
/****** Object:  StoredProcedure [dbo].[stCountTxCurrByPeriod]    Script Date: 09/08/2019 1:56:10 AM ******/
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
/****** Object:  StoredProcedure [dbo].[stCountTxNewByPeriod]    Script Date: 09/08/2019 1:56:10 AM ******/
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
/****** Object:  StoredProcedure [dbo].[stCountUsers]    Script Date: 09/08/2019 1:56:10 AM ******/
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
/****** Object:  StoredProcedure [dbo].[stCountViralSuppressionByPeriod]    Script Date: 09/08/2019 1:56:10 AM ******/
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
/****** Object:  StoredProcedure [dbo].[stDashboard]    Script Date: 09/08/2019 1:56:10 AM ******/
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
	
	select count(p.PatientId) as clients from
	(select Id from Patient) u 
	inner join
	(select distinct PatientId from ArtBaseline) p on p.PatientId = u.Id
	
	--------------------- Sites with Clients Ever enrolled on ART

	select count(distinct Id) as sites from Site s where exists (select SiteId = s.Id from Patient)

	------------------- Tx_Curr based on 28 days

	select count(n.PatientId) as patients28 from
	((select distinct Id from Patient)j 
	join
	(select distinct PatientId, max(AppointmentDate) as dt1 from ArtVisit where @today <= cast(dateadd(day, 28, AppointmentDate) as date) group by PatientId) n on j.Id = n.PatientId)

	------------------- Tx_Curr based on 90 days
	
	select count(n.PatientId) as patient90 from
	((select distinct Id from Patient)j 
	inner join
	(select distinct PatientId, max(AppointmentDate) as dt1 from ArtVisit where @today <= cast(dateadd(day, 90, AppointmentDate) as date) group by PatientId) n on j.Id = n.PatientId)
	
	------------------- Clients newly Enrolled on ART

select count(r.PatientId) as newC from
	 (select Id from Patient)as u

    inner join 
	
	(select distinct PatientId from ArtBaseline where year(ArtDate) = year(@today) and ((((month(dateadd(month, -9, ArtDate))) + 2)/3) = (((month(dateadd(month, -9, @today))) + 2)/3)) group by PatientId)r on u.Id = r.PatientId

END
GO
/****** Object:  StoredProcedure [dbo].[stErrorHandler]    Script Date: 09/08/2019 1:56:10 AM ******/
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
/****** Object:  StoredProcedure [dbo].[stGet28DayActivesBand]    Script Date: 09/08/2019 1:56:10 AM ******/
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
/****** Object:  StoredProcedure [dbo].[stGet90DayActives]    Script Date: 09/08/2019 1:56:10 AM ******/
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
/****** Object:  StoredProcedure [dbo].[stGetAllByPeriod]    Script Date: 09/08/2019 1:56:10 AM ******/
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
/****** Object:  StoredProcedure [dbo].[stGetClientBands]    Script Date: 09/08/2019 1:56:10 AM ******/
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
/****** Object:  StoredProcedure [dbo].[stGetDashboardStats]    Script Date: 09/08/2019 1:56:10 AM ******/
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
/****** Object:  StoredProcedure [dbo].[stGetSitesByPage]    Script Date: 09/08/2019 1:56:10 AM ******/
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
/****** Object:  StoredProcedure [dbo].[stGetSiteTxCurrByPeriod]    Script Date: 09/08/2019 1:56:10 AM ******/
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
/****** Object:  StoredProcedure [dbo].[stGetSiteTxNewByPeriod]    Script Date: 09/08/2019 1:56:10 AM ******/
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
/****** Object:  StoredProcedure [dbo].[stGetSiteVLByPeriod]    Script Date: 09/08/2019 1:56:10 AM ******/
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
/****** Object:  StoredProcedure [dbo].[stGetStatesTxCurrByPeriod]    Script Date: 09/08/2019 1:56:10 AM ******/
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
/****** Object:  StoredProcedure [dbo].[stGetStatesTxNewByPeriod]    Script Date: 09/08/2019 1:56:10 AM ******/
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
/****** Object:  StoredProcedure [dbo].[stGetStatesVLByPeriod]    Script Date: 09/08/2019 1:56:10 AM ******/
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
/****** Object:  StoredProcedure [dbo].[stGetStateTxCurrByPeriod]    Script Date: 09/08/2019 1:56:10 AM ******/
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
/****** Object:  StoredProcedure [dbo].[stGetStateTxNewByPeriod]    Script Date: 09/08/2019 1:56:10 AM ******/
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
/****** Object:  StoredProcedure [dbo].[stGetStateVLByPeriod]    Script Date: 09/08/2019 1:56:10 AM ******/
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
/****** Object:  StoredProcedure [dbo].[stGetTxCurrByPeriod]    Script Date: 09/08/2019 1:56:10 AM ******/
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
/****** Object:  StoredProcedure [dbo].[stGetTxNewByPeriod]    Script Date: 09/08/2019 1:56:10 AM ******/
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
/****** Object:  StoredProcedure [dbo].[stGetUsers]    Script Date: 09/08/2019 1:56:10 AM ******/
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
/****** Object:  StoredProcedure [dbo].[stGetViralSuppressionByPeriod]    Script Date: 09/08/2019 1:56:10 AM ******/
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
/****** Object:  StoredProcedure [dbo].[stInsertArtVisit]    Script Date: 09/08/2019 1:56:10 AM ******/
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
/****** Object:  StoredProcedure [dbo].[stInsertBaseline]    Script Date: 09/08/2019 1:56:10 AM ******/
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
/****** Object:  StoredProcedure [dbo].[stInsertLabResult]    Script Date: 09/08/2019 1:56:10 AM ******/
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
/****** Object:  StoredProcedure [dbo].[stInsertPaedVisits]    Script Date: 09/08/2019 1:56:10 AM ******/
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
/****** Object:  StoredProcedure [dbo].[stInsertPatients]    Script Date: 09/08/2019 1:56:10 AM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetClientStatsByStates]    Script Date: 09/08/2019 1:56:10 AM ******/
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
/****** Object:  StoredProcedure [dbo].[stSearchUsers]    Script Date: 09/08/2019 1:56:10 AM ******/
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
/****** Object:  StoredProcedure [dbo].[stSiteTxCurrAgeSexByPeriod]    Script Date: 09/08/2019 1:56:10 AM ******/
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
	@siteId as int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	declare @today as date = cast(getdate() as date);
	
select StateCode, EnrolmentId, HivConfirmationDate, EnrolmentDate, ArtDate, VisitDate, AppointmentDate, ArvRegimen1, ArvRegimen2, ArvRegimen3, ArvRegimenCode, AdvDrugCode, TestDate, DateReported, Description, TestResult, SiteId as site, datediff(year, cast(DateOfBirth as date), @today) as age, Sex as gender from

(select Id, StateId, Name, StateCode from Site where Id = @siteId) as site

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
/****** Object:  StoredProcedure [dbo].[stSiteTxNewAgeSexByPeriod]    Script Date: 09/08/2019 1:56:10 AM ******/
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
	declare @today as date = cast(getdate() as date);

	select StateCode, EnrolmentId, HivConfirmationDate, EnrolmentDate, ArtDate, VisitDate, AppointmentDate, ArvRegimen1, ArvRegimen2, ArvRegimen3, ArvRegimenCode, AdvDrugCode, TestDate, DateReported, Description, TestResult, SiteId as site, datediff(year, cast(DateOfBirth as date), @today) as age, Sex as gender from

(select Id, StateId, Name, StateCode from Site where Id = @siteId) as site

	inner join
	
(select distinct Id, EnrolmentId, SiteId, DateOfBirth, Sex  from Patient)j on site.Id = j.SiteId
	
	inner join

(select * from (select PatientId, ArtDate, EnrolmentDate, HivConfirmationDate,
             row_number() over (partition by PatientId order by ArtDate desc) as seqnum
      from ArtBaseline o  where  ArtDate >= @start and ArtDate <= @end and ArtDate is not null and year(ArtDate) > 2000
     ) o where seqnum = 1) b on j.Id = b.PatientId

inner join

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
/****** Object:  StoredProcedure [dbo].[stSiteVLoadAgeSexByPeriod]    Script Date: 09/08/2019 1:56:10 AM ******/
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
/****** Object:  StoredProcedure [dbo].[stTxCurrAgeSexAggByPeriod]    Script Date: 09/08/2019 1:56:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stTxCurrAgeSexAggByPeriod] 
	-- Add the parameters for the stored procedure here
	@start as date,
	@end as date
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

(select * from (select PatientId, ArvRegimen1, ArvRegimen2, ArvRegimen3, ArvRegimenCode, AdvDrugCode, VisitDate, AppointmentDate,
             row_number() over (partition by PatientId order by AppointmentDate desc) as seqnum
      from ArtVisit o where @start <= cast(dateadd(day, 28, AppointmentDate) as date) and @end <= cast(dateadd(day, 28, AppointmentDate) as date)
     ) o where seqnum = 1) n on w.Id = n.PatientId group by w.SiteId, w.Id

) c on site.Id = c.SiteId group by site.StateId
END
GO
/****** Object:  StoredProcedure [dbo].[stTxCurrAgeSexByPeriod]    Script Date: 09/08/2019 1:56:10 AM ******/
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
/****** Object:  StoredProcedure [dbo].[stTxCurrAggByAgeSex]    Script Date: 09/08/2019 1:56:10 AM ******/
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

(select * from (select PatientId,
             row_number() over (partition by PatientId order by AppointmentDate desc) as seqnum
      from ArtVisit o where @today <= cast(dateadd(day, 28, AppointmentDate) as date)
     ) o where seqnum = 1) n on w.Id = n.PatientId group by w.SiteId, w.Id

) c on site.Id = c.SiteId group by site.StateId
END
GO
/****** Object:  StoredProcedure [dbo].[stTxNewAgeSexAggByPeriod]    Script Date: 09/08/2019 1:56:10 AM ******/
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
      from ArtBaseline o  where  ArtDate >= @start and ArtDate <= @end
     ) o where seqnum = 1) b on w.Id = b.PatientId
	 	 
	 group by w.SiteId, w.Id

) c on site.Id = c.SiteId group by site.StateId
END
GO
/****** Object:  StoredProcedure [dbo].[stTxNewAgeSexByPeriod]    Script Date: 09/08/2019 1:56:10 AM ******/
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
	
select StateCode, EnrolmentId, HivConfirmationDate, EnrolmentDate, ArtDate, VisitDate, AppointmentDate, ArvRegimen1, ArvRegimen2, ArvRegimen3, ArvRegimenCode, AdvDrugCode, TestDate, DateReported, Description, TestResult, SiteId as site, datediff(year, cast(DateOfBirth as date), @today) as age, Sex as gender from

(select Id, StateId, Name, StateCode from Site s join (select SiteId from Patient group by SiteId having count(distinct SiteId) > 0 ) d on s.Id = d.SiteId where StateId = @stateId order by Id offset ((@pageNumber-1 )*@itemsPerPage)  rows fetch next @itemsPerPage rows only) as site

	inner join
	
(select distinct Id, EnrolmentId, SiteId, DateOfBirth, Sex  from Patient)j on site.Id = j.SiteId
	
	inner join

(select * from (select PatientId, ArtDate, EnrolmentDate, HivConfirmationDate,
             row_number() over (partition by PatientId order by ArtDate desc) as seqnum
      from ArtBaseline o  where  ArtDate >= @start and ArtDate <= @end and ArtDate is not null and year(ArtDate) > 2000
     ) o where seqnum = 1) b on j.Id = b.PatientId

inner join

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
/****** Object:  StoredProcedure [dbo].[stTxNewAggByAgeSex]    Script Date: 09/08/2019 1:56:10 AM ******/
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
/****** Object:  StoredProcedure [dbo].[stVLoadAgeSexByPeriod]    Script Date: 09/08/2019 1:56:10 AM ******/
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
