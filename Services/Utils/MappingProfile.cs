using AutoMapper;
using Entities.Models;
using Services.DataModels;

namespace Services.Utils
{
    public class MappingProfile : Profile
    {
        public MappingProfile() 
        {
            //Patient Mapping
            CreateMap<PatientDemography, PatientDemographyModel>();
            CreateMap<PatientDemographyModel, PatientDemography>();

            //Site Mapping
            CreateMap<Site, SiteModel>();
            CreateMap<SiteModel, Site>();

            //SiteDataTracking Mapping
            CreateMap<UserModel, AspNetUsers>();
            CreateMap<AspNetUsers, UserModel>();

            //State Mapping
            CreateMap<State, StateModel>();
            CreateMap<StateModel, State>();

            //SiteTxTarget Mapping
            CreateMap<SiteTxTarget, SiteTxTargetModel>();
            CreateMap<SiteTxTargetModel, SiteTxTarget>();

            //Regimen Mapping
            CreateMap<Regimen, RegimenModel>();
            CreateMap<RegimenModel, Regimen>();
        }

        // public class Source<T>
        //  {
        //     public T Value { get; set; }
        // }

        // public class Destination<T> {
        //     public T Value { get; set; }
        // }
    }
    
}
