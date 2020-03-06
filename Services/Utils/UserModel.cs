using System.Collections.Generic;

namespace Services.Utils
{
    public class UserPayload
    {
        public List<UserModel> Users{get; set;}
        public int TotalItems {get; set;} 
    }
    
    public class UserModel
    {
        public string Id { get; set; }
        public string Email { get; set; }
        public int Code {get; set;}
        public bool IsAuthenticated {get; set;}
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Message { get; set; }
        public string UserName { get; set; }
        public string Role { get; set; }
        public string Password { get; set; }
        public string ConfirmPassword { get; set; }
        public string PasswordHash {get; set;}
        public string SecurityStamp {get; set;}
    }
}