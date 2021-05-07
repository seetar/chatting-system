using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using ChitChat.Models;
using Microsoft.AspNet.SignalR;

namespace ChitChat.Hubs
{
    public class ChatHub : Hub
    {
        public static IHubContext context = GlobalHost.ConnectionManager.GetHubContext<ChatHub>();

        public SqlCommand cmd = new SqlCommand();
        public SqlDataAdapter sda;
        public SqlDataReader sdr;        
        public DataSet ds = new DataSet();
        public SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["connect"].ToString());
               
        public override Task OnConnected()
        {
            int userId = int.Parse(HttpContext.Current.User.Identity.Name);

            string query = "Insert into [Connections](UserId,ConnectionId) values(@id,@conId)";
            cmd = new SqlCommand(query, con);

            cmd.Parameters.AddWithValue("@id", userId);
            cmd.Parameters.AddWithValue("@conId", Context.ConnectionId);

            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();

            Clients.All.BroadcastOnlineUser(userId);
            return base.OnConnected();
        }

        public override Task OnDisconnected(bool stopCalled)
        {
            int userId = 0;

            string query1 = "select * from [Connections] where ConnectionId = @id";

            cmd = new SqlCommand(query1, con);

            cmd.Parameters.AddWithValue("@id", Context.ConnectionId);

            con.Open();
            sdr = cmd.ExecuteReader();
            if (sdr.HasRows)
            {
                while (sdr.Read())
                {
                    userId = int.Parse(sdr["UserId"].ToString());
                    break;
                }
            }
            con.Close();

            string query2 = "Delete from [Connections] where ConnectionId = @id";

            cmd = new SqlCommand(query2, con);

            cmd.Parameters.AddWithValue("@id", Context.ConnectionId);

            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();

            Clients.All.BroadcastOfflineUser(userId);
            return base.OnDisconnected(stopCalled);
        }

        public void GetUsersToChat()
        {
            List<User> users = new List<User>();

            int UserId = int.Parse(HttpContext.Current.User.Identity.Name);

            string query1 = "select * from [Users] where UserId in ( select UserId from [Connections] ) and UserId != @id";

            cmd = new SqlCommand(query1, con);

            cmd.Parameters.AddWithValue("@id", UserId);

            con.Open();
            sdr = cmd.ExecuteReader();

            if (sdr.HasRows)
            {
                while (sdr.Read())
                {
                    users.Add(new User
                    {
                        UserId = int.Parse(sdr["UserId"].ToString()),
                        Name = sdr["Name"].ToString(),
                        IsOnline = true
                    });
                }
            }         

            con.Close();

            string query2 = "select * from [Users] where UserId not in ( select UserId from [Connections] )";

            cmd = new SqlCommand(query2, con);

            con.Open();
            sdr = cmd.ExecuteReader();

            if (sdr.HasRows)
            {
                while (sdr.Read())
                {
                    users.Add(new User
                    {
                        UserId = int.Parse(sdr["UserId"].ToString()),
                        Name = sdr["Name"].ToString(),
                        IsOnline = false
                    });
                }
            }

            con.Close();

            Clients.Caller.BroadcastUsersToChat(users);
        }
        
        public static void OfflineUser(int UserId)
        {
            context.Clients.All.BroadcastOfflineUser(UserId);
        }

        public void LoadMessage(int User)
        {
            List<Message> messages = new List<Message>();

            int UserId = int.Parse(HttpContext.Current.User.Identity.Name);

            string StrCmd = "select * from [Messages] where (Sender = @sender and Receiver = @receiver) or (Sender = @ViseSender and Receiver = @ViseReceiver) order by Id";
            cmd = new SqlCommand(StrCmd, con);

            cmd.Parameters.AddWithValue("@sender", UserId);
            cmd.Parameters.AddWithValue("@receiver", User);
            cmd.Parameters.AddWithValue("@ViseSender", User);
            cmd.Parameters.AddWithValue("@ViseReceiver", UserId);

            con.Open();
            sdr = cmd.ExecuteReader();

            if (sdr.HasRows)
            {
                while (sdr.Read())
                {
                    messages.Add(new Message
                    {
                        Sender = sdr["Sender"].ToString(),
                        Msg = sdr["Message"].ToString(),
                        Date = DateTime.Parse(sdr["Date"].ToString())
                    });
                }
            }

            con.Close();

            Clients.Caller.LoadMessage(messages);
        }

        public void SendMessage(int receiver, string message)
        {
            int UserId = int.Parse(HttpContext.Current.User.Identity.Name);
            DateTime date = DateTime.Now;

            string StrCmd = "Insert into [Messages](Sender, Receiver, Message, Date) values(@sender, @receiver, @msg, @date)";
            cmd = new SqlCommand(StrCmd, con);

            cmd.Parameters.AddWithValue("@sender", UserId);
            cmd.Parameters.AddWithValue("@receiver", receiver);
            cmd.Parameters.AddWithValue("@msg", message);
            cmd.Parameters.AddWithValue("@date", date);

            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();

            string query = "select * from [Connections] where UserId = @id";

            cmd = new SqlCommand(query, con);

            cmd.Parameters.AddWithValue("@id", receiver);

            con.Open();
            sdr = cmd.ExecuteReader();
            if (sdr.HasRows)
            {
                while (sdr.Read())
                {
                    Clients.Client(sdr["ConnectionId"].ToString()).MessageReceived(UserId, message, date);
                    break;
                }
            }
            con.Close();

            Clients.Caller.MessageReceived(UserId, message, date);
        }
    }
}