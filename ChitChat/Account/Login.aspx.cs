using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ChitChat
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (User.Identity.IsAuthenticated)
            {
                Response.Redirect("~/");
            }
        }

        protected void SignIn_Click(object sender, EventArgs e)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["Connect"].ToString());
            string query = "select * from [Users] where Email = @uname and Password = @pass";
            SqlCommand cmd = new SqlCommand(query, con);

            cmd.Parameters.AddWithValue("@uname", Server.HtmlEncode(Email.Text));
            cmd.Parameters.AddWithValue("@pass", Server.HtmlEncode(Pwd.Text));

            con.Open();
            SqlDataReader sdr = cmd.ExecuteReader();
            if (sdr.HasRows)
            {
                while (sdr.Read())
                {
                    FormsAuthentication.RedirectFromLoginPage(Server.HtmlEncode(sdr["UserId"].ToString()), false);
                    Session["name"] = Server.HtmlEncode(sdr["Name"].ToString());
                    break;
                }
            }
            else
            {
                Email.Text = "";
                Error.Text = "Invalid Email or Password!!";
                Error.Visible = true;
            }
            con.Close();
        }
    }
}