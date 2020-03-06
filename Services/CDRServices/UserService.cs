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

namespace Services.CDRServices
{
    public class UserService : Profile, IUserService
    {
        private readonly CDRContext _context;
        private string cnn = "";
        private readonly IMapper mapper;
        public UserService(CDRContext ctx, IMapper mapper)
        {
            _context = ctx;
            this.mapper = mapper;
            cnn = _context.Database.GetDbConnection().ConnectionString;
        }

        public string AddUser(UserModel user)
        {
            try
            {
                var userEntities = _context.AspNetUsers.Where(m => m.Email == user.Email).ToList();
                if (userEntities.Any())
                {
                    return "-3";
                }
                var userEntity = mapper.Map<UserModel, AspNetUsers>(user);
                userEntity.Id = Guid.NewGuid().ToString();
                userEntity.SecurityStamp = Guid.NewGuid().ToString("D");
                userEntity.EmailConfirmed = true;
                userEntity.PasswordHash = PasswordManager.HashPassword(user.Password);                
                _context.AspNetUsers.Add(userEntity);
                _context.SaveChanges();

                if (!string.IsNullOrEmpty(user.Role))
                {
                    var role = new AspNetUserRoles
                    {                        
                        UserId = userEntity.Id,
                        RoleId = user.Role
                    };
                    _context.AspNetUserRoles.Add(role);
                    _context.SaveChanges();
                }
                
                return userEntity.Id;

            }
            catch (Exception e)
            {
                return null;
            }
        }
        
        public long UpdateUser(UserModel user)
        {
            try
            {
                if (string.IsNullOrEmpty(user.Id))
                {
                    return -2;
                }
                var userEntities = _context.AspNetUsers.Where(m => m.Id == user.Id).ToList();
                if (!userEntities.Any())
                {
                    return -2;
                }
                var userEntity = userEntities[0];
                userEntity.FirstName = user.FirstName;
                userEntity.LastName = user.LastName;
                userEntity.UserName = user.UserName;
                userEntity.Email = user.Email;
                if(!string.IsNullOrEmpty(user.Password))
                {
                    userEntity.PasswordHash = PasswordManager.HashPassword(user.Password);
                }                
                _context.Entry(userEntity).State = EntityState.Modified;

                if (!string.IsNullOrEmpty(user.Role))
                {
                    var rr = _context.AspNetUserRoles.Where(r => r.UserId == user.Id).ToList();
                    if(!rr.Any())
                    {
                        var role = new AspNetUserRoles
                        {
                            UserId = userEntity.Id,
                            RoleId = user.Role
                        };
                        _context.AspNetUserRoles.Add(role);
                    }
                    else
                    {
                        var role = rr[0];
                        if(role.RoleId != user.Role)
                        {
                            role.RoleId = user.Role;
                            _context.Entry(role).State = EntityState.Modified;
                        }
                    }
                }

                _context.SaveChanges();
                return 5;

            }
            catch (Exception e)
            {
                return 0;
            }
        }       

        public UserModel GetUserById(string userId)
        {
            try
            {
                var userList = _context.AspNetUsers.Where(c => c.Id == userId).ToList();   
                if (!userList.Any())
                {
                    return new UserModel();
                }
                var user = userList[0];
                var userModel = new UserModel
                {
                    Id = user.Id,
                    FirstName = user.FirstName,
                    UserName = user.UserName,
                    Email = user.Email
                };
               
                return userModel;
            }
            catch (Exception ex)
            {
                return new UserModel();
            }
        }

        public UserModel GetUserByEmail(string email)
        {
            try
            {
                var userList = _context.AspNetUsers.Where(c => c.Email == email).ToList();

                if (!userList.Any())
                {
                    return new UserModel();
                }

                var user = userList[0];
                var userModel = new UserModel
                {
                    Id = user.Id,
                    FirstName = user.FirstName,
                    UserName = user.UserName,
                    Email = user.Email
                };

                return userModel;

            }
            catch (Exception ex)
            {
                return new UserModel();
            }
        }       

        public UserModel CheckUserByEmail(string email)
        {
            var UserModel = new UserModel();
            try
            {
                using (SqlConnection connection = new SqlConnection(cnn))
                {
                    connection.Open();
                    using (SqlCommand cmd = new SqlCommand("stGetUser", connection))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.Add("@email", SqlDbType.NVarChar).Value = email;

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.HasRows)
                            {
                                while (reader.Read())
                                {
                                    UserModel.Id = reader["Id"].ToString();
                                    UserModel.FirstName = reader["FirstName"].ToString();
                                    UserModel.LastName = reader["LastName"].ToString();
                                    UserModel.UserName = reader["UserName"].ToString();
                                    UserModel.Email = reader["Email"].ToString();
                                    UserModel.Role = reader["RoleId"].ToString();
                                    UserModel.PasswordHash = reader["PasswordHash"].ToString();

                                }
                            }
                        }

                    }
                }

                return UserModel;

            }
            catch (Exception ex)
            {
                return UserModel;
            }
        }

        public List<UserModel> GetUsers(int itemsPerPage, int pageNumber, out int dataCount)
        {
            var userModels = new List<UserModel>();
            try
            {
                var dtCount = 0;
                using (SqlConnection connection = new SqlConnection(cnn))
                {
                    connection.Open();
                    using (SqlCommand cmd = new SqlCommand("stGetUsers", connection))
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
                                    userModels.Add(new UserModel
                                    {
                                        Id = reader["Id"].ToString(),
                                        FirstName = reader["FirstName"].ToString(),
                                        LastName = reader["LastName"].ToString(),
                                        UserName = reader["UserName"].ToString(),
                                        Email = reader["Email"].ToString(),
                                        Role = reader["RoleId"].ToString()
                                    });                                                                
                                }                             
                            }
                        }
                        
                        cmd.CommandText = "stCountUsers";
                        cmd.Parameters.Clear();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.HasRows)
                            {                                
                                while (reader.Read())
                                {                        
                                    dtCount = Convert.ToInt32(reader["users"]);                
                                }                             
                            }
                        } 
                    }                                      
                }    

                dataCount = dtCount;
                return userModels;
            }
            catch (Exception ex)
            {
                dataCount = 0;
                return new List<UserModel>();
            }
        }
        public List<UserModel> Search(int itemsPerPage, int pageNumber, out int dataCount, string term = null)
        {
            var userModels = new List<UserModel>();
            try
            {
                var dtCount = 0;
                using (SqlConnection connection = new SqlConnection(cnn))
                {
                    connection.Open();
                    using (SqlCommand cmd = new SqlCommand("stSearchUsers", connection))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.Add("@pageNumber", SqlDbType.Int).Value = pageNumber;
                        cmd.Parameters.Add("@pageNumber", SqlDbType.Int).Value = pageNumber;
                        cmd.Parameters.Add("@searchTerm", SqlDbType.Int).Value = term;

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.HasRows)
                            {                                
                                while (reader.Read())
                                {          
                                    userModels.Add(new UserModel
                                    {
                                        Id = reader["Id"].ToString(),
                                        FirstName = reader["FirstName"].ToString(),
                                        LastName = reader["LastName"].ToString(),
                                        UserName = reader["UserName"].ToString(),
                                        Email = reader["Email"].ToString(),
                                        Role = reader["RoleId"].ToString()
                                    });                                                                
                                }                             
                            }
                        }

                        cmd.CommandText = "stCountSearch";
                        cmd.Parameters.Clear();
                        cmd.Parameters.Add("@searchTerm", SqlDbType.Int).Value = term;
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.HasRows)
                            {                                
                                while (reader.Read())
                                {                        
                                    dtCount = Convert.ToInt32(reader["users"]);                
                                }                             
                            }
                        } 
                    }                                      
                }    

                dataCount = dtCount;
                return userModels;
            }
            catch (Exception ex)
            {
                dataCount = 0;
                return new List<UserModel>();
            }
        }
        public List<RoleModel> GetRoles()
        {
            var roleModels = new List<RoleModel>();
            try
            {
                var roles = _context.AspNetRoles.ToList();
                if(roles.Any())
                {
                    roles.ForEach(r =>
                    {
                        roleModels.Add(new RoleModel {Id = r.Id, Name = r.Name, ConcurrencyStamp = r.ConcurrencyStamp, NormalizedName = r.NormalizedName });
                    });
                }
                return roleModels;
            }
            catch (Exception ex)
            {
                return roleModels;
            }
        }
    }
}