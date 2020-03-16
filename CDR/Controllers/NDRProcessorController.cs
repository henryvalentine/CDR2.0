using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.Serialization;
using CDR.Models;
using ICSharpCode.SharpZipLib.Zip;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.FileProviders;
using Newtonsoft.Json;
using Services.Interfaces;
using Services.Utils;
using static CDR.Models.NDRExtract;

namespace CDR.Controllers
{
    [Route("api/[controller]")]
    public class NDRProcessorController : Controller
    {
        private readonly IPatientService _patientService;
        private readonly ISiteService _siteService;
        private readonly IHostingEnvironment _hostingEnvironment;
        public NDRProcessorController(IPatientService patientService, ISiteService siteService, IHostingEnvironment hostingEnvironment = null)
        {
            _patientService = patientService;
            _siteService = siteService;
            _hostingEnvironment = hostingEnvironment;
        }
        // GET: NDR/Create
        public ActionResult Create()
        {
            string xmlString = "<Products><Product><Id>1</Id><Name>My XML product</Name></Product><Product><Id>2</Id><Name>My second product</Name></Product></Products>";
            var serializer = new XmlSerializer(typeof(List<NDRExtract>), new XmlRootAttribute("NDRExtract"));
            var stringReader = new StringReader(xmlString);
            var ndrExtract = (NDRExtract)serializer.Deserialize(stringReader);

            return View();
        }

        [HttpPost("processData")]
        public ActionResult<GenericValidator> ProcessData()
        {
            var gVal = new GenericValidator
            { 
                FileTasks = new List<FileTask>()
            };

            try 
            {
                var path = Path.Combine(_hostingEnvironment.WebRootPath, @"NDR");
                var dir = new DirectoryInfo(path);
                if (!dir.Exists)
                {
                    Directory.CreateDirectory(path);
                }
                var files = dir.GetFiles();
                if (files.Any())
                {
                    files.ToList().ForEach(f =>
                    {
                        var facilityFiles = new List<Container>();
                        using (var zipStream = new ZipInputStream(f.OpenRead()))
                        {
                            ZipEntry theEntry;
                            while ((theEntry = zipStream.GetNextEntry()) != null)
                            {
                                
                                var fileName = theEntry.Name.ToLower();
                                try
                                {
                                    if (fileName.EndsWith(".xml") && !fileName.StartsWith("__macosx"))
                                    {
                                        var doc = new XmlDocument();
                                        doc.Load(zipStream);                                
                                        XmlDocument d = new XmlDocument();
                                        d.LoadXml(doc.LastChild.OuterXml);
                                        var dSerialised = JsonConvert.SerializeXmlNode(d);
                                        var ndrExtract = JsonConvert.DeserializeObject<Extract>(dSerialised);
                                        facilityFiles.Add(ndrExtract.Container);


                                        string xmlString = System.IO.File.ReadAllText(fileName);
                                        var serializer = new XmlSerializer(typeof(List<Extract>), new XmlRootAttribute("Container"));
                                        var stringReader = new StringReader(xmlString);
                                        var ndrExtract1 = (Extract)serializer.Deserialize(stringReader);


                                    }

                                }
                                catch (Exception e)
                                {
                                    gVal.Code = -1;
                                    gVal.Message = e.Message;
                                    var ef = new FileTask 
                                    {
                                        FacilityName = fileName,
                                        Message = e.InnerException != null? e.InnerException.Message : e.Message,
                                        Code = -1
                                    };
                                    gVal.FileTasks.Add(ef);
                                }

                            }
                        }

                    });
                }

                return gVal;
            }
            catch(Exception e)
            {
                gVal.Code = -1;
                gVal.Message = e.InnerException != null ? e.InnerException.Message : e.Message;
                return gVal;
            }           
        }

        [HttpPost("uploadNmrs")]
        public async Task<ActionResult<GenericValidator>> UploadNmrs()
        {
            var gVal = new GenericValidator();
            var form = Request.Form;
            try
            {
                var formFiles = form.Files;
                if (!formFiles.Any())
                {
                    gVal.Code = -1;
                    gVal.Message = "The requested file is empty";
                    return gVal;
                }

                var formFile = formFiles[0];
                if (formFile == null || formFile.Length <= 0)
                {
                    gVal.Code = -1;
                    gVal.Message = "The selected file could not be processed";
                    return gVal;
                }

                if (!Path.GetExtension(formFile.FileName).Equals(".zip", StringComparison.OrdinalIgnoreCase))
                {
                    gVal.Code = -1;
                    gVal.Message = "Unknown file extension";
                    return gVal;
                }

                var provider = new PhysicalFileProvider(_hostingEnvironment.WebRootPath);

                var fileName = Path.GetFileName(formFile.FileName); //use a randomn string with date, time, facility datim code to form file's name
                var filePath = Path.Combine(_hostingEnvironment.WebRootPath, @"NDR", fileName);
                var path = Path.Combine(_hostingEnvironment.WebRootPath, @"NDR");
                var dir = new DirectoryInfo(path);
                if (!dir.Exists)
                {
                    Directory.CreateDirectory(path);
                }
                using (var fileStream = new FileStream(filePath, FileMode.Create))
                {
                    await formFile.CopyToAsync(fileStream);
                }

                gVal.Code = 5;
                gVal.Message = "File was successfully uploaded";
                return gVal;
            }
            catch (Exception e)
            {
                gVal.Code = -1;
                gVal.Message = "File could not be processed. Please try again later";
                return gVal;
            }
        }

    }
}