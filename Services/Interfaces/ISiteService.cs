using System.Collections.Generic;
using System.Threading.Tasks;
using Services.DataModels;

namespace Services.Interfaces
{
    public interface ISiteService
    {
        long AddSite(SiteModel site);
        int AddSites(List<SiteModel> sites);
        long UpdateSite(SiteModel site);
        int AddTXCurrs(List<TXCurrImport> tXCurrs);
        List<StateModel> GetAllStates();
        SiteModel GetSiteById(long siteId);
        List<SiteModel> GetSitesByStateCode(string stateCode);
        List<SiteModel> GetSitesByStateId(int stateId);
        SiteModel GetSiteBySiteId(string siteId);
        List<SiteModel> GetAllSites();
        List<SiteModel> GetSites(int itemsPerPage, int pageNumber);
        List<SiteModel> GetSites(int itemsPerPage, int pageNumber, out int dataCount);
        List<SiteModel> Search(int itemsPerPage, int pageNumber, out int dataCount, string term = null);
    }
}