<%@ Page Title="Sign Up" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="ChitChat.Account.Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container">
        <div class="row">
            <div class="col-md-4 col-md-offset-4">
                <div class="box">
                    <div class="text-center">
                        <h1>Sign Up</h1>
                        <div>
                            <span>Have an Account?</span>
                            <a href="/Account/Login">Log In</a>
                            <hr />
                        </div>
                    </div>
                    <div class="form-group">
                        <asp:TextBox ID="Email" runat="server" TextMode="Email" CssClass="form-control" Required="True" placeholder="Email"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <asp:TextBox ID="Name" runat="server" CssClass="form-control" Required="True" placeholder="Your Name"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <asp:TextBox ID="Pwd" runat="server" TextMode="Password" CssClass="form-control" Required="True" pattern="(?=.*\d).{6,}" ToolTip="Must contain a digit and must be 6 character long" placeholder="Password"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <asp:Button ID="SignUp" runat="server" Text="Sign Up" CssClass="btn btn-block bg-primary" OnClick="SignUp_Click" />
                    </div> 
                    <div class="text-center">
                        <asp:Label ID="Error" runat="server" CssClass="text-center text-danger" Visible="False"></asp:Label>
                    </div>                   
                </div>
            </div>
        </div>
    </div>

</asp:Content>
