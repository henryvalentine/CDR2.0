using System.Collections.Generic;
using System.Threading.Tasks;
using Services.DataModels;
using Services.Utils;

namespace Services.Interfaces
{
    public interface IUserService
    {
        string AddUser(UserModel user);
        List<RoleModel> GetRoles();
        UserModel CheckUserByEmail(string email);
        List<UserModel> GetUsers(int itemsPerPage, int pageNumber, out int dataCount);
        List<UserModel> Search(int itemsPerPage, int pageNumber, out int dataCount, string term = null);
        long UpdateUser(UserModel user);
        UserModel GetUserById(string userId);
        UserModel GetUserByEmail(string email);
    }
}