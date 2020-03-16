using System.Collections.Generic;
using System.Threading.Tasks;
using Services.DataModels;

namespace Services.Interfaces
{
    public interface IPatientService
    {
        long AddPatient(PatientDemographyModel patient);
        int AddPatientList(List<PatientDemographyModel> patients);
        int AddPatients(List<PatientDemographyModel> patients);
        int TrackPatientData(List<PatientDemographyModel> patients);
        long UpdatePatient(PatientDemographyModel patient);
        PatientDemographyModel GetPatientById(long patientId);
        PatientDemographyModel GetPatientByEnrolmentId(string enrolmentId);
        List<PatientDemographyModel> GetAllPatients();
        List<PatientDemographyModel> GetPatients(int itemsPerPage, int pageNumber, out int dataCount);
        List<PatientDemographyModel> GetPatientsBySite(int itemsPerPage, int pageNumber, int siteId, out int dataCount);
        List<PatientDemographyModel> Search(out int dataCount, string facilityId, string term = null);
    }
}