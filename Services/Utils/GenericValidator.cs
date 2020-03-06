using Services.DataModels;
using System.Collections.Generic;

namespace Services.Utils
{
    public class GenericValidator
    {
        public long Code {get; set;}
        public string Message {get; set;}
        public string Asset {get; set;}
        public string FileName { get; set; }
        public List<FileTask> FileTasks { get; set; }
    }

    public class FileTask
    {
        public int Code { get; set; }
        public string Message { get; set; }
        public string PatientId { get; set; }
        public string FacilityName { get; set; }
    }

    public class PushDataResult
    {
        public int Code { get; set; }
        public string Message { get; set; }
        public long LastPage {get; set;}
        public int TotalItems {get; set;}
        public int TotalProcessed {get; set;}     
        public int Patients {get; set;}   
        public int AdultBaseline {get; set;}    
        public int PaediatricBaseline {get; set;} 
        public int AdultVisists {get; set;}      
        public int PaediatricVisists {get; set;}   
        public int LabResults {get; set;}   
    }
}