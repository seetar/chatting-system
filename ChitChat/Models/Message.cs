using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ChitChat.Models
{
    public class Message
    {
        public string Sender { get; set; }
        public string Msg { get; set; }
        public DateTime Date { get; set; }
    }
}