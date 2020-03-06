using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Services.DataModels;
using Services.Interfaces;
using Services.Utils;

namespace CDR.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class ArtBaselineController : ControllerBase
    {       
        private readonly IArtBaselineService _adultArtBaselineService;
        public ArtBaselineController(IArtBaselineService adultArtBaselineService)
        {
            _adultArtBaselineService = adultArtBaselineService;
        }

        [HttpGet]
        [Route("getArtBaselines")]
        public ActionResult<GenericModel> GetArtBaselines(int itemsPerPage, int pageNumber)
        {
            int dataCount;
            var adultArtBaselines = _adultArtBaselineService.GetArtBaselines(itemsPerPage, pageNumber, out dataCount);
            return new GenericModel { ArtBaselines = adultArtBaselines, TotalItems = dataCount };
        }

        [HttpGet]
        [Route("searchArtBaselines")]
        public ActionResult<GenericModel> Search(string term = null)
        {
            int dataCount;
            var adultArtBaselines = _adultArtBaselineService.Search(out dataCount, term);
            return new GenericModel { ArtBaselines = adultArtBaselines, TotalItems = dataCount };
        }
        // GET api/values/5
        [HttpGet]
        [Route("getArtBaseline/{id}")]
        public ActionResult<ArtBaselineModel> GetArtBaseline(long id)
        {
            return _adultArtBaselineService.GetArtBaselineById(id);
        }

         // GET api/values/5
        [HttpGet]
        [Route("getArtBaselineByEnrolmentId/{lng}/{lat}")]
        public ActionResult<ArtBaselineModel> GetArtBaselineByEnrolmentId(string enrolmentId)
        {
            return _adultArtBaselineService.GetArtBaselineByEnrolmentId(enrolmentId);
        }
               

        // POST api/values
        [HttpPost]
        [Route("addArtBaseline")]
        public ActionResult<GenericValidator> AddArtBaseline([FromBody]ArtBaselineModel adultArtBaseline)
        {
             var gVal = new GenericValidator();
            try
            {
                if (adultArtBaseline.PatientId < 1)
                {
                    gVal.Code = -1;
                    gVal.Message = "Please provide select Patient.";
                    return gVal;
                }
                if (adultArtBaseline.EnrolmentDate == null)
                {
                    gVal.Code = -1;
                    gVal.Message = "Please provide Art Enrolment Date";
                    return gVal;
                }
                var status = _adultArtBaselineService.AddArtBaseline(adultArtBaseline);
                if (status < 1)
                {
                    gVal.Code = -1;
                    gVal.Message = "An unknown error was encountered. Please try again.";
                    return gVal;
                }

                gVal.Code = status;
                gVal.Message = "ArtBaseline information was successfully Added";
                return gVal;

            }
            catch (Exception ex)
            {
                gVal.Code = -1;
                gVal.Message = ex.Message != null? ex.Message : ex.InnerException != null? ex.InnerException.Message : "An unknown error was encountered. Please try again.";
                return gVal;
            }
           
        }

        [HttpPatch]
        [Route("updateArtBaseline")]
        public ActionResult<GenericValidator> EditArtBaseline([FromBody]ArtBaselineModel adultArtBaseline)
        {
            var gVal = new GenericValidator();
            try
            {
                if (string.IsNullOrEmpty(adultArtBaseline.EnrolmentId))
                {
                    gVal.Code = -1;
                    gVal.Message = "Please provide ArtBaseline's enrolmentId.";
                    return gVal;
                }
                if (adultArtBaseline.PatientId < 1)
                {
                    gVal.Code = -1;
                    gVal.Message = "Please Select a Patient";
                    return gVal;
                }
                if (adultArtBaseline.EnrolmentDate == null)
                {
                    gVal.Code = -1;
                    gVal.Message = "Please provide Art Enrolment Date";
                    return gVal;
                }
                if (adultArtBaseline.Id < 1)
                {
                    gVal.Code = -1;
                    gVal.Message = "Invalid ArtBaseline information selected. Please try again.";
                    return gVal;
                }

                var status = _adultArtBaselineService.UpdateArtBaseline(adultArtBaseline);
                if (status < 1)
                {
                    gVal.Code = -1;
                    gVal.Message =  "An unknown error was encountered. Please try again.";
                    return gVal;
                }

                gVal.Code = 5;
                gVal.Message = "ArtBaseline information was successfully Updated";
                return gVal;

            }
            catch (Exception ex)
            {
                gVal.Code = -1;
                gVal.Message = ex.Message != null ? ex.Message : ex.InnerException != null ? ex.InnerException.Message : "An unknown error was encountered. Please try again.";
                return gVal;
            }
        }

    }
}
