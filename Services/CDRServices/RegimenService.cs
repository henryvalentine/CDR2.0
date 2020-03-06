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
    public class RegimenService : Profile, IRegimenService
    {
        private readonly CDRContext _context;
        private readonly IMapper mapper;
        public RegimenService(CDRContext ctx, IMapper mapper)
        {
            _context = ctx;
             this.mapper = mapper;
        }
        public long AddRegimen(RegimenModel regimen)
        {
            try
            {
                if (regimen == null)
                {
                    return -2;
                }

                var duplicates = _context.Regimen.Count(m => m.Combination.Trim().ToLower() == regimen.Combination.Trim().ToLower() && m.Code == regimen.Code);
                if (duplicates > 0)
                {
                    return -3;
                }

                var regimenEntity = mapper.Map<RegimenModel, Regimen>(regimen);
                _context.Regimen.Add(regimenEntity);
                _context.SaveChanges();
                return regimenEntity.Id;

            }
            catch (Exception e)
            {
                return 0;
            }
        }
        public long UpdateRegimen(RegimenModel regimen)
        {
            try
            {
                if (regimen == null || regimen.Id < 1)
                {
                    return -2;
                }
                var regimenEntities = _context.Regimen.Where(m => m.Id == regimen.Id).ToList();
                if (!regimenEntities.Any())
                {
                    return -2;
                }
                var regimenEntity = regimenEntities[0];
                regimenEntity.Combination = regimen.Combination;
                regimenEntity.Line = regimen.Line;
                regimenEntity.Code = regimen.Code;
                _context.Entry(regimenEntity).State = EntityState.Modified;
                _context.SaveChanges();
                return regimenEntity.Id;

            }
            catch (Exception ex)
            {
                // Log Error
                return 0;
            }
        }       
        public RegimenModel GetRegimen(int regimenId)
        {
            try
            {
                var regimenList = _context.Regimen.Where(c => c.Id == regimenId).ToList();

                if (!regimenList.Any())
                {
                    return new RegimenModel();
                }

                var regimenEntity = regimenList[0];
                var RegimenModel = mapper.Map<Regimen, RegimenModel> (regimenEntity);

                if (RegimenModel.Id < 1)
                {
                    return new RegimenModel();
                }
                return RegimenModel;
            }
            catch (Exception ex)
            {
                return new RegimenModel();
            }
        }
        public List<RegimenModel> GetAllRegimens()
        {
            try
            {
                var regimenEntites = _context.Regimen.ToList();

                if (!regimenEntites.Any())
                {
                    return new List<RegimenModel>();
                }

                var RegimenModels = new List<RegimenModel>();

                regimenEntites.ForEach(m =>
                {
                    var regimenModel = mapper.Map<Regimen, RegimenModel>(m);
                    RegimenModels.Add(regimenModel);
                });

                return RegimenModels.OrderBy(m => m.Combination).ToList();
            }
            catch (Exception ex)
            {
                return new List<RegimenModel>();
            }
        }
        public List<RegimenModel> GetRegimens(int itemsPerPage, int pageNumber, out int dataCount)
        {
            var regimens = new List<RegimenModel>();
            try
            {
                var regimenEntites = _context.Regimen.OrderBy(m => m.Combination).Skip((pageNumber - 1) * itemsPerPage).Take(itemsPerPage).ToList();

                if (!regimenEntites.Any())
                {
                    dataCount = 0;
                    return new List<RegimenModel>();
                }

                var RegimenModels = new List<RegimenModel>();

                regimenEntites.ForEach(m =>
                {
                    var RegimenModel = mapper.Map<Regimen, RegimenModel>(m);
                    if (RegimenModel.Id > 0)
                    {
                        RegimenModels.Add(RegimenModel);
                    }
                });

                dataCount = _context.Regimen.Count();

                return RegimenModels;
            }
            catch (Exception ex)
            {
                dataCount = 0;
                return regimens;
            }
        }
        public List<RegimenModel> Search(int itemsPerPage, int pageNumber, out int dataCount, string term = null)
        {
            try
            {
                var regimenEntites = new List<Regimen>();

                if (!string.IsNullOrEmpty(term))
                {
                    regimenEntites = _context.Regimen.Where(m => m.Combination.ToLower() == term.ToLower().Trim()).OrderBy(m => m.Id).Skip((pageNumber - 1) * itemsPerPage).Take(itemsPerPage).ToList();
                }
                else
                {
                    regimenEntites = _context.Regimen.ToList();
                }

                if (!regimenEntites.Any())
                {
                    dataCount = 0;
                    return new List<RegimenModel>();
                }

                var RegimenModels = new List<RegimenModel>();

                regimenEntites.ForEach(m =>
                {
                    var RegimenModel = mapper.Map<Regimen, RegimenModel>(m);
                    if (RegimenModel.Id > 0)
                    {
                        RegimenModels.Add(RegimenModel);
                    }
                });

                dataCount = _context.Regimen.Count(m => m.Combination.ToLower() == term.ToLower().Trim());

                return RegimenModels;

            }

            catch (Exception ex)
            {
                dataCount = 0;
                return new List<RegimenModel>();
            }
        }
    }
}