using System.Collections.Generic;
using System.Threading.Tasks;
using Services.DataModels;

namespace Services.Interfaces
{
    public interface IPatientDemographyService
    {
        long AddPatient(PatientDemographyModel patient);
        int AddPatients(List<PatientDemographyModel> patients, int currentPage);
        int AddPatients(List<PatientDemographyModel> patients, int lastPage, int siteId);
        long UpdatePatient(PatientDemographyModel patient);
        PatientDemographyModel GetPatientById(long patientId);
        List<PatientDemographyModel> GetPatientsBySite(int itemsPerPage, int pageNumber, int siteId, out int dataCount);
        PatientDemographyModel GetPatientByEnrolmentId(string enrolmentId);
        List<PatientDemographyModel> GetAllPatients();
        List<PatientDemographyModel> GetPatients(int itemsPerPage, int pageNumber, out int dataCount);
        List<PatientDemographyModel> Search(out int dataCount, string term = null);
    }
}