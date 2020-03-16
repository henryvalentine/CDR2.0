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
    public class PatientDemographyService : Profile, IPatientService
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

        public int AddPatientList(List<PatientDemographyModel> patients)
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
        public int AddPatients(List<PatientDemographyModel> patients)
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
                    _context.BulkInsertOrUpdate(entities, bulkConfig);
                    entities.ForEach(entity =>
                    {
                        entity.HivEncounter.ToList().ForEach(e =>
                        {
                            e.PatientId = entity.Id;
                        });
                        _context.BulkInsertOrUpdate(entity.HivEncounter.ToList());

                        entity.PatientRegimen.ToList().ForEach(r =>
                        {
                            r.PatientId = entity.Id;
                        });
                        _context.BulkInsertOrUpdate(entity.PatientRegimen.ToList());

                        entity.LaboratoryReport.ToList().ForEach(l =>
                        {
                            l.PatientId = entity.Id;
                        });
                        _context.BulkInsertOrUpdate(entity.LaboratoryReport.ToList());

                        entity.FingerPrint.ToList().ForEach(fi =>
                        {
                            fi.PatientId = entity.Id;
                        });
                        _context.BulkInsertOrUpdate(entity.FingerPrint.ToList());

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

                patients.ForEach(p =>
                {
                    long patientId = 0;
                    var duplicates = _context.PatientDemography.Where(m => m.PatientIdentifier.Trim().ToLower() == p.PatientIdentifier.Trim().ToLower() && m.SiteId == p.SiteId).ToList();
                    if (!duplicates.Any())
                    {
                        var sites = _context.Site.Where(m => m.SiteId.Trim().ToLower() == p.FacilityId.Trim().ToLower()).ToList();
                        if (sites.Any())
                        {
                            var patientEntity = mapper.Map<PatientDemographyModel, PatientDemography>(p);
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
                        using (var transaction = _context.Database.BeginTransaction())
                        {
                            var bulkConfig = new BulkConfig { PreserveInsertOrder = true, SetOutputIdentity = true };

                            if (p.HivEncounters.Any())
                            {
                                var encounterEntities = new List<HivEncounter>();
                                p.HivEncounters.ToList().ForEach(he =>
                                {
                                    var hEntity = mapper.Map<HivEncounterModel, HivEncounter>(he);
                                    hEntity.PatientId = patientId;
                                    encounterEntities.Add(hEntity);
                                });

                                _context.BulkInsertOrUpdate(encounterEntities);
                            }

                            if (p.PatientRegimens.Any())
                            {
                                var regimenEntities = new List<PatientRegimen>();
                                p.PatientRegimens.ToList().ForEach(re =>
                                {
                                    var rEntity = mapper.Map<PatientRegimenModel, PatientRegimen>(re);
                                    rEntity.PatientId = patientId;
                                    regimenEntities.Add(rEntity);
                                });

                                _context.BulkInsertOrUpdate(regimenEntities);
                            }

                            if (p.LaboratoryReports.Any())
                            {
                                var labEntities = new List<LaboratoryReport>();
                                p.LaboratoryReports.ToList().ForEach(re =>
                                {
                                    var lEntity = mapper.Map<LaboratoryReportModel, LaboratoryReport>(re);
                                    lEntity.PatientId = patientId;
                                    labEntities.Add(lEntity);
                                });
                                _context.BulkInsertOrUpdate(labEntities);
                            }

                            if (p.FingerPrints.Any())
                            {
                                var fingerEntities = new List<FingerPrint>();
                                p.FingerPrints.ToList().ForEach(re =>
                                {
                                    var fEntity = mapper.Map<FingerPrintModel, FingerPrint>(re);
                                    fEntity.PatientId = patientId;
                                    fingerEntities.Add(fEntity);
                                });

                                _context.BulkInsertOrUpdate(fingerEntities);
                            }

                            transaction.Commit();
                            processed++;
                        }                        
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
                patientEntity.SiteId = patient.SiteId;
                patientEntity.EnrolleeCode = patient.EnrolleeCode;
                patientEntity.PatientDateOfBirth = patient.PatientDateOfBirth;
                patientEntity.PatientIdentifier = patient.PatientIdentifier;
                patientEntity.PatientSexCode = patient.PatientSexCode;
                patientEntity.FacilityId = patient.FacilityId;
                patientEntity.FacilityName = patient.FacilityName;
                patientEntity.FacilityTypeCode = patient.FacilityTypeCode;
                patientEntity.OtherIdnumber = patient.OtherIdnumber;
                patientEntity.OtherIdtypeCode = patient.OtherIdtypeCode;
                patientEntity.ConditionCode = patient.ConditionCode;
                patientEntity.AddressTypeCode = patient.AddressTypeCode;
                patientEntity.StateCode = patient.StateCode;
                patientEntity.CountryCode = patient.CountryCode;
                patientEntity.ProgramAreaCode = patient.ProgramAreaCode;
                patientEntity.FirstConfirmedHivtestDate = patient.FirstConfirmedHivtestDate;
                patientEntity.ArtstartDate = patient.ArtstartDate;
                patientEntity.TransferredOutStatus = patient.TransferredOutStatus;
                patientEntity.EnrolledInHivcareDate = patient.EnrolledInHivcareDate;
                patientEntity.HospitalNumber = patient.HospitalNumber;
                patientEntity.DateOfFirstReport = patient.DateOfFirstReport;
                patientEntity.DateOfLastReport = patient.DateOfLastReport;
                patientEntity.DiagnosisDate = patient.DiagnosisDate;
                patientEntity.PatientDieFromThisIllness = patient.PatientDieFromThisIllness;
                patientEntity.PatientAge = patient.PatientAge;
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
                .Include("HivEncounter")
                .Include("LaboratoryReport")
                .Include("PatientRegimen")
                .Where(c => c.Id == patientId 
                && (c.PatientRegimen.Any() || c.HivEncounter.Any())).ToList();
                  
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
                
                var artVisit = new List<HivEncounterModel>();
                var drugPickups = new List<PatientRegimenModel>();
                var labResult = new List<LaboratoryReportModel>();

                patientModel.FacilityName = patientEntity.Site.Name;
                patientModel.StateCode = patientEntity.Site.StateCode;
                patientModel.Status = "Unknown Status";
                
                patientModel.DateOfBirthStr = patientModel.PatientDateOfBirth.Value.ToShortDateString();
                if(patientEntity.PatientRegimen.Any())
                {
                    var maxVisitDate = patientEntity.PatientRegimen.Max(s => s.VisitDate);
                    var maxDuration = patientEntity.PatientRegimen.Max(s => s.PrescribedRegimenDuration);
                    patientModel.Status = StatusMapper.GetClientStatus2(maxVisitDate, maxDuration);

                    patientEntity.PatientRegimen.ToList().ForEach(v => 
                    {
                        var regimen = mapper.Map<PatientRegimen, PatientRegimenModel>(v);
                        regimen.VisitDateStr = v.VisitDate != null ? v.VisitDate.Value.ToShortDateString() : "NA";
                        regimen.AppointmentDateStr = v.VisitDate != null && v.PrescribedRegimenDuration > 0 ? v.VisitDate.Value.AddDays(v.PrescribedRegimenDuration).ToShortDateString() : "NA";
                        drugPickups.Add(regimen);                        
                    });
                   
                    drugPickups = drugPickups.OrderByDescending(g => g.VisitDate).ToList();
                }

                if (patientEntity.LaboratoryReport.Any())
                {
                    patientEntity.LaboratoryReport.ToList().ForEach(v =>
                    {
                        var lab = mapper.Map<LaboratoryReport, LaboratoryReportModel>(v);
                        lab.VisitDateStr = v.VisitDate.Value.ToShortDateString();
                        lab.CollectionDateStr = v.VisitDate.Value.ToShortDateString();
                        lab.OrderedTestDateStr = v.VisitDate.Value.ToShortDateString();
                        lab.ResultedTestDateStr = v.VisitDate.Value.ToShortDateString();
                        labResult.Add(lab);
                    });
                    labResult = labResult.OrderByDescending(g => g.OrderedTestDate).ToList();
                }

                if (patientEntity.HivEncounter.Any())
                {
                    patientEntity.HivEncounter.ToList().ForEach(v =>
                    {
                        var encounter = mapper.Map<HivEncounter, HivEncounterModel>(v);
                        encounter.VisitDateStr = v.VisitDate.ToShortDateString();
                        encounter.NextAppointmentDateStr = v.NextAppointmentDate.Value.ToShortDateString();
                        artVisit.Add(encounter);
                    });
                    artVisit = artVisit.OrderByDescending(g => g.VisitDate).ToList();
                }
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
                var patientList = _context.PatientDemography.Where(c => c.PatientIdentifier == enrolmentId).ToList();

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

                return PatientModels.OrderBy(m => m.PatientIdentifier).ToList();
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
                .Include("PatientRegimen")
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
                    patientModel.DateOfBirthStr = patientModel.PatientDateOfBirth?.ToShortDateString()?? "NA";
                    patientModel.Status = "Unknown";

                    if(m.PatientRegimen.Any())
                    {
                        var maxVisitDate = m.PatientRegimen.Max(s => s.VisitDate);
                        var maxDuration = m.PatientRegimen.Max(s => s.PrescribedRegimenDuration);
                        patientModel.VisitDateStr = maxVisitDate?.ToShortDateString() ?? "NA";
                        patientModel.AppointmentDateStr = (maxVisitDate.Value.AddDays(maxDuration)).ToShortDateString() ?? "NA";                        
                        patientModel.Status = StatusMapper.GetClientStatus2(maxVisitDate, maxDuration);
                    }

                    patientModel.ArtstartDateStr = m.ArtstartDate.Value.ToShortDateString() ?? "NA";
                    patientModel.FacilityName = m.FacilityName;
                    PatientModels.Add(patientModel);

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
                .Include("PatientRegimen")
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
                    patientModel.DateOfBirthStr = patientModel.PatientDateOfBirth?.ToShortDateString() ?? "NA";
                    patientModel.Status = "Unknown";

                    if (m.PatientRegimen.Any())
                    {
                        var maxVisitDate = m.PatientRegimen.Max(s => s.VisitDate);
                        var maxDuration = m.PatientRegimen.Max(s => s.PrescribedRegimenDuration);
                        patientModel.VisitDateStr = maxVisitDate?.ToShortDateString() ?? "NA";
                        patientModel.AppointmentDateStr = (maxVisitDate.Value.AddDays(maxDuration)).ToShortDateString() ?? "NA";
                        patientModel.Status = StatusMapper.GetClientStatus2(maxVisitDate, maxDuration);
                    }

                    patientModel.ArtstartDateStr = m.ArtstartDate.Value.ToShortDateString() ?? "NA";
                    patientModel.FacilityName = m.FacilityName;
                    PatientModels.Add(patientModel);
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
        public List<PatientDemographyModel> Search(out int dataCount, string facilityId, string term = null)
        {
            try
            {
                var patientEntites = new List<PatientDemography>();

                if (!string.IsNullOrEmpty(term))
                {
                    patientEntites = _context.PatientDemography.Include("PatientRegimen").Where(m => m.FacilityId == facilityId && m.PatientIdentifier.ToLower().Contains(term.ToLower().Trim())).ToList();
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
                    var patientModel = mapper.Map<PatientDemography, PatientDemographyModel>(m);
                    patientModel.DateOfBirthStr = patientModel.PatientDateOfBirth?.ToShortDateString() ?? "NA";
                    patientModel.Status = "Unknown";

                    if (m.PatientRegimen.Any())
                    {
                        var maxVisitDate = m.PatientRegimen.Max(s => s.VisitDate);
                        var maxDuration = m.PatientRegimen.Max(s => s.PrescribedRegimenDuration);
                        patientModel.VisitDateStr = maxVisitDate?.ToShortDateString() ?? "NA";
                        patientModel.AppointmentDateStr = (maxVisitDate.Value.AddDays(maxDuration)).ToShortDateString() ?? "NA";
                        patientModel.Status = StatusMapper.GetClientStatus2(maxVisitDate, maxDuration);
                    }

                    patientModel.ArtstartDateStr = m.ArtstartDate.Value.ToShortDateString() ?? "NA";
                    patientModel.FacilityName = m.FacilityName;
                    PatientModels.Add(patientModel);
                });

                dataCount = _context.PatientDemography.Count(m => m.FacilityId == facilityId && m.PatientIdentifier.ToLower().Contains(term.ToLower().Trim()));

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