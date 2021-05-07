<%@ Page Title="Chat" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="ChitChat.Home" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div id="notebar" hidden></div>
    <div class="row">
        <div class="col-md-10">
            <div class="chat-container box" style="height: 450px;">
                <div class="text-center receiver" hidden></div>
                <div class="chat">
                    <div class="row">
                        <div class="col-md-3 text-center box middle">
                            <h1>Select a User To Get Started☺</h1>
                        </div>
                    </div>
                    <!-- chat box goes here -->
                </div>
            </div>
            <div id="msg" class="form-group box" hidden>
                <textarea id="txtMessage" class="form-control" placeholder="Enter Message" rows="1" style="resize: none;"></textarea>
            </div>
        </div>
        <div class="col-md-2">
            <div class="users-list box" title="Users" style="max-height: 529px;">
                <!-- users list goes here -->
            </div>
        </div>
    </div>

    <script type="text/javascript">
        $(function () {
            var chat = $.connection.chatHub;

            registerClientMethods(chat);

            chat.connection.start()
                .done(function () {
                    chat.server.getUsersToChat();

                    $('#txtMessage').keyup(function (e) {
                        var msg = $('#txtMessage').val().trim();
                        var user = $('#Receiver').val();
                        if (msg.length <= 0) {
                            $('#txtMessage').val('');
                        }
                        else if (e.which == 13) {                        
                            chat.server.sendMessage(user, msg);
                        }
                    });
                });

            function registerClientMethods(chat) {

                chat.client.broadcastUsersToChat = function (listUsers) {
                    $('.users-list').html('');
                    for (var i = 0; i < listUsers.length; i++) {
                        let online = listUsers[i].IsOnline ? '🟢' : "";
                        $('.users-list').append('<div id="' + listUsers[i].UserId + '" class="user-box">\
                        <h5><b>'+ listUsers[i].Name + '</b>\
                        <span class="online">'+ online + '</span></h5>\
                        </div>');

                        $('#' + listUsers[i].UserId + '').click(function () {
                            var user = this.id;
                            chat.server.loadMessage(user);
                            $('.receiver').html('<input type="hidden" id="Receiver" value="' + user + '" />' + $('.users-list').find('#' + this.id).find('b').html()).show().delay(300).fadeOut(500);
                            $('#msg').show();
                            $("#txtMessage").focus();
                        });
                    }
                };

                chat.client.broadcastOnlineUser = function (userId) {
                    $('.users-list').find('#' + userId + '').find('span[class="online"]').html('🟢');
                }

                chat.client.broadcastOfflineUser = function (userId) {
                    $('.users-list').find('#' + userId + '').find('span[class="online"]').html('');
                }

                chat.client.loadMessage = function (msgs) {
                    $('.chat').text('');
                    for (var i = 0; i < msgs.length; i++) {
                        AddMessage(msgs[i].Sender, msgs[i].Msg, msgs[i].Date);
                    }
                }

                chat.client.messageReceived = function (userName, message, date) {
                    if (($("#Receiver").val() == userName) || userName == <%= int.Parse(User.Identity.Name) %>) {
                        AddMessage(userName, message, date);
                    }
                    else {
                        $('#notebar').html("New message from " + userName).show().delay(500).fadeOut(500);
                    }
                }

            }

        });

        function AddMessage(Name, Msg, Date) {
            var Side = 'from';

            if (Name == <%= int.Parse(User.Identity.Name) %>) {
                Side = 'to';
                Name = 'You';
            }
            else {
                Name = $('.receiver').text();
            }

            $('.chat').append('<div class="' + Side + '">\
                        <div><span class="text-muted">' + Name + '</span></div>\
                        <div class="img-rounded msg-' + Side + '">' + Msg + '</div>\
                        <div><span class="text-muted small">' + Date + '</span></div>\
                        </div>');

            var height = $('.chat-container')[0].scrollHeight;
            $('.chat-container').scrollTop(height);

            $("#txtMessage").val('').focus();
        }

    </script>

</asp:Content>
