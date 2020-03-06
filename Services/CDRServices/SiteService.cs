using System;
using System.Collections.Generic;
using System.Linq;
using Services.DataModels;
using Microsoft.EntityFrameworkCore;
using Entities.Models;
using Services.Interfaces;
using AutoMapper;
using System.Data.SqlClient;
using System.Data;
using System.Data.Common;
using Services.Utils;

namespace Services.CDRServices
{
    public class SiteService : Profile, ISiteService
    {
        private readonly CDRContext _context;
        private readonly IMapper mapper;
        private string cnn = "";
        public SiteService(CDRContext ctx, IMapper mapper)
        {
            _context = ctx;
             this.mapper = mapper;
            cnn = _context.Database.GetDbConnection().ConnectionString;
        }
        public long AddSite(SiteModel site)
        {
            try
            {
                if (site == null)
                {
                    return -2;
                }

                var duplicates = _context.Site.Count(m => m.SiteId.Trim().ToLower() == site.SiteId.Trim().ToLower());
                if (duplicates > 0)
                {
                    return -3;
                }

                var siteEntity = mapper.Map<SiteModel, Site>(site);

                if (string.IsNullOrEmpty(siteEntity.SiteId))
                {
                    return -2;
                }
                _context.Site.Add(siteEntity);
                _context.SaveChanges();
                return siteEntity.Id;

            }
            catch (Exception e)
            {
                return 0;
            }
        }

        public int AddSites(List<SiteModel> sites)
        {
            try
            {
                var processed = 0;
                if (!sites.Any())
                {
                    return 0;
                }               

                sites.ForEach(site =>
                {
                    var duplicates = _context.Site.Count(m => m.SiteId.Trim().ToLower() == site.SiteId.Trim().ToLower());
                    if (duplicates < 1)
                    {
                        var siteEntity = mapper.Map<SiteModel, Site>(site);
                        processed++;
                       _context.Site.Add(siteEntity);
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

        public int AddTXCurrs(List<TXCurrImport> tXCurrs)
        {
            try
            {
                var processed = 0;
                if (!tXCurrs.Any())
                {
                    return 0;
                }

                tXCurrs.ForEach(site =>
                {
                    var siteO = _context.Site.Include("SiteTxTarget").Where(s => s.SiteId.Trim().ToLower() == site.SiteId.Trim().ToLower()).ToList();

                    if (siteO.Any())
                    {                        
                        var tt = siteO.ToList()[0];
                        if (!tt.SiteTxTarget.Any(r => r.FiscalYear == site.FISCAL_YEAR))
                        {
                            var siteEntity = new SiteTxTarget
                            {
                                SiteId = tt.Id,
                                TxCurrTarget = site.TX_CURR_TARGET,
                                TxNewTarget = site.TX_NEW_TARGET,
                                FiscalYear = site.FISCAL_YEAR
                            };
                            _context.SiteTxTarget.Add(siteEntity);
                            processed++;
                        }
                        else
                        {
                            var t = tt.SiteTxTarget.ToList()[0];
                            t.TxCurrTarget = site.TX_CURR_TARGET;
                            t.TxNewTarget = site.TX_NEW_TARGET;
                            _context.Entry(t).State = EntityState.Modified;
                            processed++;
                        }
                    }
                    else
                    {

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

        public long UpdateSite(SiteModel site)
        {
            try
            {
                if (site == null || site.Id < 1)
                {
                    return -2;
                }
                var siteEntities = _context.Site.Where(m => m.Id == site.Id).ToList();
                if (!siteEntities.Any())
                {
                    return -2;
                }

                var siteEntity = siteEntities[0];
                siteEntity.Name = site.Name;
                siteEntity.Lga = site.Lga;
                siteEntity.SiteId = site.SiteId;
                siteEntity.StateCode = site.StateCode;
                siteEntity.StateId = site.StateId;
                _context.Entry(siteEntity).State = EntityState.Modified;
                _context.SaveChanges();
                return siteEntity.Id;

            }
            catch (Exception ex)
            {
                // Log Error
                return 0;
            }
        }       

        public SiteModel GetSiteById(long siteId)
        {
            try
            {
                var siteList = _context.Site.Include("State").Where(c => c.Id == siteId).ToList();

                if (!siteList.Any())
                {
                    return new SiteModel();
                }

                var siteEntity = siteList[0];
                var SiteModel = mapper.Map<Site, SiteModel> (siteEntity);

                if (SiteModel.Id < 1)
                {
                    return new SiteModel();
                }
                SiteModel.StateName = siteEntity.State.Name;
                SiteModel.State = new StateModel();
                return SiteModel;
            }
            catch (Exception ex)
            {
                return new SiteModel();
            }
        }

        public SiteModel GetSiteBySiteId(string siteCode)
        {
            try
            {
                var siteList = _context.Site.Where(c => c.SiteId == siteCode).ToList();

                if (!siteList.Any())
                {
                    return new SiteModel();
                }

                var siteEntity = siteList[0];
                var SiteModel = mapper.Map<Site, SiteModel>(siteEntity);

                if (SiteModel.Id < 1)
                {
                    return new SiteModel();
                }

                return SiteModel;

            }
            catch (Exception ex)
            {
                return new SiteModel();
            }
        }

        public List<SiteModel> GetAllSites()
        {
            try
            {
                var siteEntites = _context.Site.Include("State").ToList();

                if (!siteEntites.Any())
                {
                    return new List<SiteModel>();
                }

                var SiteModels = new List<SiteModel>();

                siteEntites.ForEach(m =>
                {
                    var siteModel = mapper.Map<Site, SiteModel>(m);

                    if (siteModel.Id > 0)
                    {
                        siteModel.State = new StateModel();
                        siteModel.SiteTxTarget = new List<SiteTxTargetModel>();
                        siteModel.StateName = m.State.Name;
                        siteModel.StateCode = m.State.Code;
                        siteModel.Name = siteModel.Name + "(" + siteModel.StateCode + ")";
                        SiteModels.Add(siteModel);
                    }
                });

                return SiteModels.OrderBy(m => m.Name).ToList();
            }
            catch (Exception ex)
            {
                return new List<SiteModel>();
            }
        }

        public List<StateModel> GetAllStates()
        {
            try
            {
                var siteEntites = _context.State.ToList();

                if (!siteEntites.Any())
                {
                    return new List<StateModel>();
                }

                var states = new List<StateModel>();

                siteEntites.ForEach(m =>
                {
                    var state = mapper.Map<State, StateModel>(m);
                    state.Site = new List<SiteModel>();
                    states.Add(state);                    
                });

                return states.OrderBy(m => m.Name).ToList();
            }
            catch (Exception ex)
            {
                return new List<StateModel>();
            }
        }

        public List<SiteModel> GetSitesByStateCode(string stateCode)
        {
            try
            {
                var siteEntites = _context.Site.Where(s => s.StateCode.ToLower() == stateCode.ToLower()).ToList();

                if (!siteEntites.Any())
                {
                    return new List<SiteModel>();
                }

                var SiteModels = new List<SiteModel>();

                siteEntites.ForEach(m =>
                {
                    var SiteModel = mapper.Map<Site, SiteModel>(m);

                    if (SiteModel.Id > 0)
                    {
                        SiteModels.Add(SiteModel);
                    }
                });

                return SiteModels.OrderBy(s => s.Name).ToList();
            }
            catch (Exception ex)
            {
                return new List<SiteModel>();
            }
        }

        public List<SiteModel> GetSitesByStateId(int stateId)
        {
            try
            {
                var siteEntites = _context.Site.Where(s => s.StateId == stateId).ToList();

                if (!siteEntites.Any())
                {
                    return new List<SiteModel>();
                }

                var SiteModels = new List<SiteModel>();

                siteEntites.ForEach(m =>
                {
                    var SiteModel = mapper.Map<Site, SiteModel>(m);

                    if (SiteModel.Id > 0)
                    {
                        SiteModels.Add(SiteModel);
                    }
                });

                return SiteModels.OrderBy(s => s.Name).ToList();
            }
            catch (Exception ex)
            {
                return new List<SiteModel>();
            }
        }

        public List<SiteModel> GetSites(int itemsPerPage, int pageNumber, out int dataCount)
        {
            var sites = new List<SiteModel>();
            try
            {
                var dtCount = 0;
                using (SqlConnection connection = new SqlConnection(cnn))
                {
                    connection.Open();
                    using (SqlCommand cmd = new SqlCommand("stGetSitesByPage", connection))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.Add("@pageNumber", SqlDbType.Int).Value = pageNumber;
                        cmd.Parameters.Add("@itemsPerPage", SqlDbType.Int).Value = itemsPerPage;

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.HasRows)
                            {                                
                                while (reader.Read())
                                {                        
                                    var total = Convert.ToInt64(reader["totalArt"]);
                                    dtCount = Convert.ToInt32(reader["totalSites"]);
                                    var active = Convert.ToInt64(reader["active"]);         
                                    sites.Add(new SiteModel
                                    {
                                        Id = Convert.ToInt32(reader["sId"]),
                                        Name = reader["site"].ToString(),
                                        StateCode = reader["code"].ToString(),
                                        Active = active,
                                        Inactive = Convert.ToInt64(reader["inactive"]),
                                        Difference = (total > 0 && active > 0)? ((active * 100)/total): 0,
                                        LossToFollowUp = Convert.ToInt64(reader["loss"]),
                                        TotalClients = total,
                                        NewClients = Convert.ToInt64(reader["tx_new"])   
                                    });                                                                
                                }                             
                            }
                        }
                    }                                      
                }       
                dataCount = dtCount;
                return sites;
            }
            catch (Exception ex)
            {
                dataCount = 0;
                return sites;
            }
        }
       
       public List<SiteModel> GetSites(int itemsPerPage, int pageNumber)
        {
            var sites = new List<SiteModel>();
            try
            {
                using (SqlConnection connection = new SqlConnection(cnn))
                {
                    connection.Open();
                    using (SqlCommand cmd = new SqlCommand("stGetSitesByPage", connection))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.Add("@pageNumber", SqlDbType.Int).Value = pageNumber;
                        cmd.Parameters.Add("@itemsPerPage", SqlDbType.Int).Value = itemsPerPage;

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.HasRows)
                            {                                
                                while (reader.Read())
                                {                        
                                    var total = Convert.ToInt32(reader["totalArt"]);   
                                    var active = Convert.ToInt32(reader["active"]);         
                                    sites.Add(new SiteModel
                                    {
                                        Id = Convert.ToInt32(reader["sId"]),
                                        Name = reader["site"].ToString(),
                                        StateCode = reader["code"].ToString(),
                                        Active = Convert.ToInt32(reader["active"]),
                                        Inactive = Convert.ToInt32(reader["inactive"]),
                                        Difference = (total > 0 && active > 0)? ((active * 100)/total): 0,
                                        LossToFollowUp = Convert.ToInt32(reader["loss"]),
                                        TotalClients = total,
                                        NewClients = Convert.ToInt32(reader["tx_new"])   
                                    });                                                                
                                }                             
                            }
                        }
                    }                                      
                }       
                return sites;
            }
            catch (Exception ex)
            {
                return sites;
            }
        }

        public static int GetFinancialQuarter(DateTime date)
        {
            return ((date.AddMonths(-9).Month + 2)/3);
        }

        public List<SiteModel> Search(int itemsPerPage, int pageNumber, out int dataCount, string term = null)
        {
            try
            {
                var siteEntites = new List<Site>();

                if (!string.IsNullOrEmpty(term))
                {
                    siteEntites = _context.Site.Where(m => m.SiteId.ToLower() == term.ToLower().Trim()
                    || m.Name.ToLower().Trim().Contains(term.ToLower().Trim())
                    || m.StateCode.ToLower().Trim().Contains(term.ToLower().Trim())
                    ).OrderBy(m => m.Id).Skip(pageNumber).Take(itemsPerPage).ToList();
                }
                else
                {
                    siteEntites = _context.Site.ToList();
                }

                if (!siteEntites.Any())
                {
                    dataCount = 0;
                    return new List<SiteModel>();
                }

                var SiteModels = new List<SiteModel>();

                siteEntites.ForEach(m =>
                {
                    var SiteModel = mapper.Map<Site, SiteModel>(m);
                    if (SiteModel.Id > 0)
                    {
                        SiteModels.Add(SiteModel);
                    }
                });

                dataCount = _context.Site.Count(m => m.SiteId.ToLower() == term.ToLower().Trim()
                    || m.Name.ToLower().Trim().Contains(term.ToLower().Trim())
                    || m.StateCode.ToLower().Trim().Contains(term.ToLower().Trim()));

                return SiteModels;

            }

            catch (Exception ex)
            {
                dataCount = 0;
                return new List<SiteModel>();
            }
        }

    }
}