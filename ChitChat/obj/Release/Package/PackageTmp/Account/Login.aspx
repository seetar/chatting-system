<%@ Page Title="Log In" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="ChitChat.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container">
        <div class="row">
            <div class="col-md-4 col-md-offset-4">
                <div class="box">
                    <div class="text-center">
                        <h1>Sign In</h1>
                        <div>
                            <span>New to ChitChat?</span>
                            <a href="/Account/Register">Sign Up</a>
                            <hr />
                        </div>
                    </div>
                    <div class="form-group">
                        <asp:TextBox ID="Email" runat="server" TextMode="Email" CssClass="form-control" Required="True" placeholder="Email"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <asp:TextBox ID="Pwd" runat="server" TextMode="Password" CssClass="form-control" Required="True" placeholder="Password"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <asp:Button ID="SignIn" runat="server" Text="Log In" CssClass="btn btn-block bg-primary" OnClick="SignIn_Click" />
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
