using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ChitChat.Account
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (User.Identity.IsAuthenticated)
            {
                Response.Redirect("~/");
            }
        }

        protected void SignUp_Click(object sender, EventArgs e)
        {
            Page.Validate();
            if (Page.IsValid)
            {

                switch (IsEmailExists(Server.HtmlEncode(Email.Text)))
                {
                    case 0:
                        AddUser();
                        break;
                    case 1:
                        Email.Text = Name.Text = Pwd.Text = "";
                        Error.Text = "Email exists..";
                        Error.Visible = true;
                        break;
                    default:       
                        Error.Text = "Something went wrong!! Please Try again later..";
                        Error.Visible = true;
                        break;
                }

            }
        }

        protected void AddUser()
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["Connect"].ToString());
            string query = "Insert into [Users](Email, Name, Password) values(@email, @name, @pass)";
            SqlCommand cmd = new SqlCommand(query, con);

            cmd.Parameters.AddWithValue("@email", Server.HtmlEncode(Email.Text));
            cmd.Parameters.AddWithValue("@name", Server.HtmlEncode(Name.Text));
            cmd.Parameters.AddWithValue("@pass", Server.HtmlEncode(Pwd.Text));

            con.Open();
            int status = cmd.ExecuteNonQuery();
            con.Close();

            if (status == 1)
            {
                Response.Redirect("~/Account/Login");
            }
            else
            {
                Error.Text = "Registration Failed!!";
                Error.Visible = true;              
            }
        }

        protected int IsEmailExists(string email)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["Connect"].ToString());
            string command_string = "select count(*) from [Users] where Email= @email";
            SqlCommand cmd = new SqlCommand(command_string, con);

            cmd.Parameters.AddWithValue("@email", email);

            con.Open();
            int n = Convert.ToInt32(cmd.ExecuteScalar());
            con.Close();

            return n;
        }
    }
}