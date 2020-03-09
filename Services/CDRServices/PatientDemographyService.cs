using System;
using System.Collections.Generic;
using System.Linq;
using Services.DataModels;
using Microsoft.EntityFrameworkCore;
using Entities.Models;
using Services.Interfaces;
using Services.Utils;
using AutoMapper;
using System.Data.SqlClient;
using System.Data;
using EFCore.BulkExtensions;

namespace Services.CDRServices
{
    public class PatientDemographyService : Profile, IPatientDemographyService
    {
        private readonly CDRContext _context;
        private readonly IMapper mapper;
        public PatientDemographyService(CDRContext ctx, IMapper mapper)
        {
            _context = ctx;
            this.mapper = mapper;
        }
        public long AddPatient(PatientDemographyModel patient)
        {
            try
            {
                if (patient == null)
                {
                    return -2;
                }

                var duplicates = _context.PatientDemography.Count(m => m.PatientIdentifier.Trim().ToLower() == patient.PatientIdentifier.Trim().ToLower());
                if (duplicates > 0)
                {
                    return -3;
                }

                var sites = _context.Site.Where(m => m.SiteId.Trim().ToLower() == patient.FacilityId.Trim().ToLower()).ToList();
                if (!sites.Any())
                {
                    return -3;
                }                               

                var patientEntity = mapper.Map<PatientDemographyModel, PatientDemography>(patient);
                _context.PatientDemography.Add(patientEntity);
                _context.SaveChanges();
                return patientEntity.Id;

            }
            catch (Exception e)
            {
                return 0;
            }
        }

        public int AddPatients(List<PatientDemographyModel> patients, int currentPage, string siteId)
        {
            try
            {
                var processed = 0;
                if (!patients.Any())
                {
                    return -1;
                }

                patients.ForEach(patient =>
                {
                    var duplicates = _context.PatientDemography.Where(m => m.PatientIdentifier.Trim().ToLower() == patient.PatientIdentifier.Trim().ToLower());
                    if (!duplicates.Any())
                    {
                        var patientEntity = mapper.Map<PatientDemographyModel, PatientDemography>(patient);
                        patientEntity.FacilityId = siteId;                            
                        _context.PatientDemography.Add(patientEntity); 
                        processed++;                                              
                    } 
                    else
                    {
                        var entity = duplicates.ToList()[0];
                        entity.PatientDieFromThisIllness = patient.PatientDieFromThisIllness;
                        entity.OtherIdtypeCode = patient.OtherIdtypeCode;
                        entity.OtherIdnumber = patient.OtherIdnumber;
                        entity.ConditionCode = patient.ConditionCode;
                        entity.PatientAge = patient.PatientAge;
                        entity.DiagnosisDate = patient.DiagnosisDate;
                        entity.DateOfLastReport = patient.DateOfLastReport;
                        entity.DateOfFirstReport = patient.DateOfFirstReport;
                        entity.HospitalNumber = patient.HospitalNumber;
                        entity.EnrolledInHivcareDate = patient.EnrolledInHivcareDate;
                        entity.TransferredOutStatus = patient.TransferredOutStatus;
                        entity.ArtstartDate = patient.ArtstartDate;
                        entity.FirstConfirmedHivtestDate = patient.FirstConfirmedHivtestDate;
                        entity.ProgramAreaCode = patient.ProgramAreaCode;
                        _context.Entry(entity).State = EntityState.Modified;
                        processed++;
                    }                    
                });               
                
                return processed;
            }
            catch (Exception ex)
            {
                return -1;
            }
        }
        public int AddPatients(List<PatientDemographyModel> patients, int currentPage)
        {
            var dtCount = 0;
            var entities = new List<PatientDemography>();
            try
            {
                patients.ForEach(p => 
                {
                    var pEntity = mapper.Map<PatientDemographyModel, PatientDemography>(p);
                    if (p.HivEncounters.Any())
                    {
                        var encounterEntities = new List<HivEncounter>();
                        p.HivEncounters.ToList().ForEach(he => 
                        {
                            var hEntity = mapper.Map<HivEncounterModel, HivEncounter>(he);
                            encounterEntities.Add(hEntity);
                        });

                        pEntity.HivEncounter = encounterEntities;
                    }

                    if (p.PatientRegimens.Any())
                    {
                        var regimenEntities = new List<PatientRegimen>();
                        p.PatientRegimens.ToList().ForEach(re =>
                        {
                            var rEntity = mapper.Map<PatientRegimenModel, PatientRegimen>(re);
                            regimenEntities.Add(rEntity);
                        });

                        pEntity.PatientRegimen = regimenEntities;
                    }

                    if (p.LaboratoryReports.Any())
                    {
                        var labEntities = new List<LaboratoryReport>();
                        p.LaboratoryReports.ToList().ForEach(re =>
                        {
                            var rEntity = mapper.Map<LaboratoryReportModel, LaboratoryReport>(re);
                            labEntities.Add(rEntity);
                        });

                        pEntity.LaboratoryReport = labEntities;
                    }

                    if (p.FingerPrints.Any())
                    {
                        var fingerEntities = new List<FingerPrint>();
                        p.FingerPrints.ToList().ForEach(re =>
                        {
                            var fEntity = mapper.Map<FingerPrintModel, FingerPrint>(re);
                            fingerEntities.Add(fEntity);
                        });

                        pEntity.FingerPrint = fingerEntities;
                    }
                    entities.Add(pEntity);
                });

                using (var transaction = _context.Database.BeginTransaction())
                {
                    var bulkConfig = new BulkConfig { PreserveInsertOrder = true, SetOutputIdentity = true };
                    _context.BulkInsert(entities, bulkConfig);
                    entities.ForEach(entity =>
                    {
                        entity.HivEncounter.ToList().ForEach(e =>
                        {
                            e.PatientId = entity.Id;
                        });
                        _context.BulkInsert(entity.HivEncounter.ToList());

                        entity.PatientRegimen.ToList().ForEach(r =>
                        {
                            r.PatientId = entity.Id;
                        });
                        _context.BulkInsert(entity.PatientRegimen.ToList());

                        entity.LaboratoryReport.ToList().ForEach(l =>
                        {
                            l.PatientId = entity.Id;
                        });
                        _context.BulkInsert(entity.LaboratoryReport.ToList());

                        entity.FingerPrint.ToList().ForEach(fi =>
                        {
                            fi.PatientId = entity.Id;
                        });
                        _context.BulkInsert(entity.FingerPrint.ToList());

                        transaction.Commit();
                    });

                }
                return dtCount;
            }
            catch (Exception ex)
            {
                return 0;
            }
        }
        public int TrackPatientData(List<PatientDemographyModel> patients)
        {
            try
            {
                var processed = 0;
                if (!patients.Any())
                {
                    return 0;
                }

                patients.ForEach(patient =>
                {
                    long patientId = 0;
                    var duplicates = _context.PatientDemography.Where(m => m.PatientIdentifier.Trim().ToLower() == patient.PatientIdentifier.Trim().ToLower() && m.SiteId == patient.SiteId).ToList();
                    if (!duplicates.Any())
                    {
                        var sites = _context.Site.Where(m => m.SiteId.Trim().ToLower() == patient.FacilityId.Trim().ToLower()).ToList();
                        if (sites.Any())
                        {
                            var patientEntity = mapper.Map<PatientDemographyModel, PatientDemography>(patient);
                            patientEntity.SiteId = sites[0].Id;
                            _context.PatientDemography.Add(patientEntity);
                            _context.SaveChanges();   
                            patientId = patientEntity.Id;               
                        }
                    }
                    else
                    {
                        patientId = duplicates[0].Id;
                    }
                    if(patientId > 0)
                    {
                        if(patient.ArtVisit.Any())
                        {
                            patient.ArtVisit.ForEach(artVisit =>
                            {
                                var artVisitEntity = mapper.Map<ArtVisitModel, ArtVisit>(artVisit);                         
                                artVisitEntity.PatientId = patientId;
                                _context.ArtVisit.Add(artVisitEntity);
                            });
                        }
                      
                        if(patient.ArtBaseline.Any())
                        {
                            patient.ArtBaseline.ForEach(artBaseline =>
                            {
                                var artBaselineEntity = mapper.Map<ArtBaselineModel, ArtBaseline>(artBaseline);                         
                                artBaselineEntity.PatientId = patientId;
                                _context.ArtBaseline.Add(artBaselineEntity);
                            });
                        }
                         if(patient.LabResult.Any())
                        {
                            patient.LabResult.ForEach(labResult =>
                            {
                                var labResultEntity = mapper.Map<LabResultModel, LabResult>(labResult);                         
                                labResultEntity.PatientId = patientId;
                                _context.LabResult.Add(labResultEntity);
                            });
                        }

                        _context.SaveChanges(); 
                        processed++;
                    }                    
                });

                _context.SaveChanges();

                return processed;
            }
            catch (Exception ex)
            {
                return 0;
            }
        }
        public long UpdatePatient(PatientDemographyModel patient)
        {
            try
            {
                if (patient == null || patient.Id < 1)
                {
                    return -2;
                }
                var patientEntities = _context.PatientDemography.Where(m => m.Id == patient.Id).ToList();
                if (!patientEntities.Any())
                {
                    return -2;
                }
                var patientEntity = patientEntities[0];
                patientEntity.FirstName = patient.FirstName;
                patientEntity.LastName = patient.LastName;
                patientEntity.PatientIdentifier = patient.PatientIdentifier;
                patientEntity.VisitDate = patient.VisitDate;
                patientEntity.StateId = patient.StateId;
                patientEntity.Sex = patient.Sex;
                patientEntity.DateOfBirth = patient.DateOfBirth;
                patientEntity.Age = patient.Age;
                patientEntity.Village = patient.Village;
                patientEntity.Town = patient.Town;
                patientEntity.Lga = patient.Lga;
                patientEntity.State = patient.State;
                patientEntity.AddressLine1 = patient.AddressLine1;
                patientEntity.PhoneNumber = patient.PhoneNumber;
                patientEntity.MaritalStatus = patient.MaritalStatus;
                patientEntity.PreferredLanguage = patient.PreferredLanguage;
                _context.Entry(patientEntity).State = EntityState.Modified;
                _context.SaveChanges();
                return patientEntity.Id;

            }
            catch (Exception e)
            {
                return 0;
            }
        }       
        public PatientDemographyModel GetPatientById(long patientId)
        {
            try
            {
                var patientList = _context.PatientDemography
                .Include("Site")
                .Include("ArtBaseline")
                .Include("ArtVisit")
                .Include("LabResult")
                .Where(c => c.Id == patientId 
                && (c.ArtVisit.Any() || c.ArtBaseline.Any())).ToList();
   
                if (!patientList.Any())
                {
                    return new PatientDemographyModel();
                }

                var patientEntity = patientList[0];
                var patientModel = mapper.Map<PatientDemography, PatientDemographyModel> (patientEntity);

                if (patientModel.Id < 1)
                {
                    return new PatientDemographyModel();
                }
                
                var baselines = new ArtBaselineModel();
                var artVisit = new List<ArtVisitModel>();
                var labResult = new List<LabResultModel>();
                patientModel.SiteName = patientEntity.Site.Name;
                patientModel.StateCode = patientEntity.Site.StateCode;
                patientModel.Status = "Unknown Status";

                patientModel.DateOfBirthStr = patientModel.DateOfBirth.Value.ToShortDateString();
                if(patientEntity.ArtVisit.Any())
                {
                    var maxDate = patientEntity.ArtVisit.Max(s => s.AppointmentDate);                    
                    patientModel.Status = StatusMapper.GetClientStatus(maxDate);
                    patientEntity.ArtVisit.ToList().ForEach(v => 
                    {
                        artVisit.Add(new ArtVisitModel
                        {
                            Id = v.Id,
                            VisitDate = v.VisitDate,
                            AppointmentDate = v.AppointmentDate,
                            VisitDateStr = v.VisitDate != null? v.VisitDate.Value.ToShortDateString() : "NA",
                            AppointmentDateStr = v.VisitDate != null? v.AppointmentDate.Value.ToShortDateString() : "NA"
                        });
                    });  
                    artVisit = artVisit.OrderByDescending(g => g.AppointmentDate).ToList();
                }

                if (patientEntity.LabResult.Any())
                {
                    patientEntity.LabResult.ToList().ForEach(v =>
                    {
                        labResult.Add(new LabResultModel
                        {
                            Id = v.Id,
                            DateReported = v.DateReported,
                            TestDateStr = v.TestDate != null ? v.TestDate.ToShortDateString() : "NA",
                            DateReportedStr = v.DateReported != null ? v.DateReported.ToShortDateString() : "NA",
                            LabNumber = v.LabNumber,
                            TestGroup = v.TestGroup,
                            Description = v.Description,
                            TestResult = v.TestResult
                        });
                    });

                    labResult = labResult.OrderByDescending(g => g.DateReported).ToList();
                }

                if (patientEntity.ArtBaseline.Any())
                {
                    var baseL = patientEntity.ArtBaseline.ToList()[0];

                    patientModel.Baseline = new ArtBaselineModel
                    {
                        HivConfirmationDateStr = baseL.HivConfirmationDate != null ? baseL.HivConfirmationDate.Value.ToShortDateString() : "NA",
                        EnrolmentDateStr = baseL.EnrolmentDate != null ? baseL.EnrolmentDate.Value.ToShortDateString() : "NA",
                        ArtDateStr = baseL.ArtDate != null ? baseL.ArtDate.Value.ToShortDateString() : "NA"
                    };
                }

                patientModel.Site = new SiteModel();
                patientModel.ArtBaseline = new List<ArtBaselineModel>();
                patientModel.ArtVisit = new List<ArtVisitModel>();
                patientModel.LabResult = new List<LabResultModel>();

                patientModel.ArtVisit = artVisit;
                patientModel.LabResult = labResult;
                return patientModel;
            }
            catch (Exception ex)
            {
                return new PatientDemographyModel();
            }
        }
        public PatientDemographyModel GetPatientByEnrolmentId(string enrolmentId)
        {
            try
            {
                var patientList = _context.PatientDemography.Include("Site").Where(c => c.PatientIdentifier == enrolmentId).ToList();

                if (!patientList.Any())
                {
                    return new PatientDemographyModel();
                }

                var patientEntity = patientList[0];
                var PatientDemographyModel = mapper.Map<PatientDemography, PatientDemographyModel>(patientEntity);

                if (PatientDemographyModel.Id < 1)
                {
                    return new PatientDemographyModel();
                }

                return PatientDemographyModel;

            }
            catch (Exception ex)
            {
                return new PatientDemographyModel();
            }
        }
        public List<PatientDemographyModel> GetAllPatients()
        {
            try
            {
                var patientEntites = _context.PatientDemography.ToList();

                if (!patientEntites.Any())
                {
                    return new List<PatientDemographyModel>();
                }

                var PatientModels = new List<PatientDemographyModel>();

                patientEntites.ForEach(m =>
                {
                    var PatientDemographyModel = mapper.Map<PatientDemography, PatientDemographyModel>(m);

                    if (PatientDemographyModel.Id > 0)
                    {
                        PatientModels.Add(PatientDemographyModel);
                    }
                });

                return PatientModels.OrderBy(m => m.FirstName).ToList();
            }
            catch (Exception ex)
            {
                return new List<PatientDemographyModel>();
            }
        }
        public List<PatientDemographyModel> GetPatients(int itemsPerPage, int pageNumber, out int dataCount)
        {
            try
            {
                var patientEntites = _context.PatientDemography
                .Include("Site")
                .Include("ArtBaseline")
                .Include("ArtVisit")
                .OrderByDescending(m => m.Id).Skip((pageNumber - 1) * itemsPerPage).Take(itemsPerPage).ToList();

                if (!patientEntites.Any())
                {
                    dataCount = 0;
                    return new List<PatientDemographyModel>();
                }

                var PatientModels = new List<PatientDemographyModel>();

                patientEntites.ForEach(m =>
                {
                    var patientModel = mapper.Map<PatientDemography, PatientDemographyModel>(m);
                    patientModel.DateOfBirthStr = patientModel.DateOfBirth?.ToShortDateString()?? "NA";
                    patientModel.Name = patientModel.FirstName + " " + patientModel.LastName;
                    patientModel.Status = "Unknown";
                    DateTime? maxDate = DateTime.Today;
                    if(m.ArtVisit.Any())
                    {
                        maxDate = m.ArtVisit.Max(s => s.AppointmentDate); 
                        patientModel.VisitDateStr  = m.ArtVisit.Max(s => s.VisitDate)?.ToShortDateString()?? "NA";                 
                        patientModel.Status = StatusMapper.GetClientStatus(maxDate);
                        patientModel.AppointmentDate = maxDate;
                        patientModel.AppointmentDateStr = maxDate?.ToShortDateString()?? "NA";
                    } 
                    if(m.ArtBaseline.Any())
                    {
                        var baseline = m.ArtBaseline.ToList()[0];
                        patientModel.ArtDateStr = baseline.ArtDate?.ToShortDateString()?? "NA";
                    }

                    if (patientModel.Id > 0)
                    {
                        patientModel.SiteName = m.Site.Name;
                        patientModel.Site = new SiteModel();
                        patientModel.ArtBaseline = new List<ArtBaselineModel>();
                        patientModel.ArtVisit = new List<ArtVisitModel>();
                        PatientModels.Add(patientModel);
                    }
                });

                dataCount = _context.PatientDemography.Count();
                return PatientModels; //.OrderByDescending(m => m.AppointmentDate).ToList()
            }
            catch (Exception ex)
            {
                dataCount = 0;
                return new List<PatientDemographyModel>();
            }
        }
        public List<PatientDemographyModel> GetPatientsBySite(int itemsPerPage, int pageNumber, int siteId, out int dataCount)
        {
            try
            {
                var patientEntites = _context.PatientDemography.Where(p => p.SiteId == siteId)
                .Include("Site")
                .Include("ArtBaseline")
                .Include("ArtVisit")
                .OrderByDescending(m => m.Id).Skip((pageNumber - 1) * itemsPerPage).Take(itemsPerPage).ToList();

                if (!patientEntites.Any())
                {
                    dataCount = 0;
                    return new List<PatientDemographyModel>();
                }

                var PatientModels = new List<PatientDemographyModel>();

                patientEntites.ForEach(m =>
                {
                    var patientModel = mapper.Map<PatientDemography, PatientDemographyModel>(m);
                    patientModel.DateOfBirthStr = patientModel.DateOfBirth?.ToShortDateString()?? "NA";
                    patientModel.Name = patientModel.FirstName + " " + patientModel.LastName;
                    patientModel.Status = "Unknown";
                    if(m.ArtVisit.Any())
                    {
                        var maxDate = m.ArtVisit.Max(s => s.AppointmentDate); 
                        patientModel.VisitDateStr  = m.ArtVisit.Max(s => s.VisitDate)?.ToShortDateString()?? "NA";                 
                        patientModel.Status = StatusMapper.GetClientStatus(maxDate);
                        patientModel.AppointmentDateStr = maxDate?.ToShortDateString()?? "NA";
                    }
                    if(m.ArtBaseline.Any())
                    {
                        var baseline = m.ArtBaseline.ToList()[0];
                        patientModel.ArtDateStr = baseline.ArtDate?.ToShortDateString()?? "NA";
                    }

                    if (patientModel.Id > 0)
                    {
                        patientModel.SiteName = m.Site.Name;
                        patientModel.Site = new SiteModel();
                        patientModel.ArtBaseline = new List<ArtBaselineModel>();
                        patientModel.ArtVisit = new List<ArtVisitModel>();
                        PatientModels.Add(patientModel);
                    }
                });

                dataCount = _context.PatientDemography.Count(p => p.SiteId == siteId);
                return PatientModels;

            }
            catch (Exception ex)
            {
                dataCount = 0;
                return new List<PatientDemographyModel>();
            }
        }
        public List<PatientDemographyModel> Search(out int dataCount, string term = null)
        {
            try
            {
                var patientEntites = new List<PatientDemography>();

                if (!string.IsNullOrEmpty(term))
                {
                    patientEntites = _context.PatientDemography.Include("Site").Where(m => m.PatientIdentifier.ToLower() == term.ToLower().Trim()
                    || m.LastName.ToLower().Trim().Contains(term.ToLower().Trim())
                    || m.FirstName.ToLower().Trim().Contains(term.ToLower().Trim())
                    ).ToList();
                }
                else
                {
                    patientEntites = _context.PatientDemography.ToList();
                }

                if (!patientEntites.Any())
                {
                    dataCount = 0;
                    return new List<PatientDemographyModel>();
                }

                var PatientModels = new List<PatientDemographyModel>();

                patientEntites.ForEach(m =>
                {
                    var PatientDemographyModel = mapper.Map<PatientDemography, PatientDemographyModel>(m);
                    if (PatientDemographyModel.Id > 0)
                    {
                        PatientDemographyModel.SiteName = m.Site.Name;
                        PatientModels.Add(PatientDemographyModel);
                    }
                });

                dataCount = _context.PatientDemography.Count(m => m.PatientIdentifier.ToLower() == term.ToLower().Trim()
                    || m.LastName.ToLower().Trim().Contains(term.ToLower().Trim())
                    || m.FirstName.ToLower().Trim().Contains(term.ToLower().Trim()));

                return PatientModels;

            }

            catch (Exception ex)
            {
                dataCount = 0;
                return new List<PatientDemographyModel>();
            }
        }
    }
}