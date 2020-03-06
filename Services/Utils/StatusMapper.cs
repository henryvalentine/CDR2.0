using System;

namespace Services.Utils
{
    public static class StatusMapper
    {
        public static string GetClientStatus(DateTime? lastAppointmentDate)
        {
            try
            {
                // var today = DateTime.Today;
                // return ((today <= lastAppointmentDate.Value) ||  (today <= lastAppointmentDate.Value.AddDays(28)))? "Active" :
                // (today > lastAppointmentDate.Value.AddDays(28)) && (today <= lastAppointmentDate.Value.AddDays(90))? "Inactive" : 
                // (today >  lastAppointmentDate.Value.AddDays(90))? "Loss-to-follow up" : "Unknown Status";

                var today = DateTime.Today;
                return ((today <= lastAppointmentDate.Value) ||  (today <= lastAppointmentDate.Value.AddDays(28)))? "Active" :
                (((today > lastAppointmentDate.Value.AddDays(28)) 
                && (today <= lastAppointmentDate.Value.AddDays(90))) || (today >  lastAppointmentDate.Value.AddDays(90)))? "Inactive" : "Unknown";
            }
            catch(Exception ex)
            {
                return "NA";
            }
        }
    }
}