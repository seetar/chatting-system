<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="ChitChat.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    
    <script type="text/javascript">
        document.title = "ChitChat";
    </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <asp:LoginView runat="server" ViewStateMode="Disabled">
        <AnonymousTemplate>
            <div class="row">
                <div class="col-md-3 text-center box middle">
                    <h1>Please Log In To Get Started☺</h1>
                </div>
            </div>
        </AnonymousTemplate>
        <LoggedInTemplate>
            <div class="row">
                <div class="col-md-3 text-center box middle">
                    <h1>To Open Your Emoji Keyboard In Chat, Press <kbd><kbd>windows</kbd> + <kbd>.</kbd></kbd></h1>
                </div>
            </div>
        </LoggedInTemplate>
    </asp:LoginView>

</asp:Content>
