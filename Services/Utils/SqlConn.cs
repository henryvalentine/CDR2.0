using MySql.Data.MySqlClient;
using System;
using System.Data.SqlClient;

namespace Services.Utils
{
    public class SqlConn
    {
        public  SqlConnection GetSqlConn()
        {            
            return new SqlConnection("Server=jackv;Database=CDR;Trusted_Connection=False;User ID=sa;Password=z3r0ufx1;MultipleActiveResultSets=true; Connection Timeout=120;");
        }
        public  SqlConnection GetSqlConn(string server, string user, string password)
        {            
            return new SqlConnection("Server=" + server + ";Database=patientdb;Trusted_Connection=False;User ID=" + user + ";Password=" + password + ";MultipleActiveResultSets=true; Connection Timeout=120;");
        }

        public MySqlConnection GetMySqlConn(string server, string user, string password)
        {
            return new MySqlConnection("Server=" + server + ";Database=openmrs;Uid=" + user + ";Pwd=" + password + ";");
        }
    }
}