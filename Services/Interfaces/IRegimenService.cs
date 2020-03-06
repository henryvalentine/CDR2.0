using System.Collections.Generic;
using System.Threading.Tasks;
using Services.DataModels;

namespace Services.Interfaces
{
    public interface IRegimenService
    {
        long AddRegimen(RegimenModel regimen);
        long UpdateRegimen(RegimenModel regimen);     
        List<RegimenModel> GetAllRegimens();
        RegimenModel GetRegimen(int regimenId);
        List<RegimenModel> GetRegimens(int itemsPerPage, int pageNumber, out int dataCount);
        List<RegimenModel> Search(int itemsPerPage, int pageNumber, out int dataCount, string term = null);
    }
}