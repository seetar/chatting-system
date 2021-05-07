using ChitChat.Hubs;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ChitChat
{
    public partial class Site : MasterPage
    {
        public SqlCommand cmd = new SqlCommand();
        public SqlDataAdapter sda;
        public SqlDataReader sdr;
        public DataSet ds = new DataSet();
        public SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["connect"].ToString());

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void LoggingOut(object sender, EventArgs e)
        {
            int userId = int.Parse(HttpContext.Current.User.Identity.Name);

            string query = "Delete from [Connections] where UserId = @id";

            cmd = new SqlCommand(query, con);

            cmd.Parameters.AddWithValue("@id", userId);

            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();

            ChatHub.OfflineUser(userId);

            Session.Clear();
            Session.Abandon();
            FormsAuthentication.SignOut();
        }
    }
}