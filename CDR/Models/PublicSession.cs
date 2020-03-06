using Services.Utils;

namespace CDR.Models
{
    /// <summary>
    /// Represents public session of the web application
    /// that can be shared in browser's window object.
    /// </summary>
    public class PublicSession
    {
        public UserModel User { get; set; }
    }
}
