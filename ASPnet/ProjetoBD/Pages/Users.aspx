﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Users.aspx.cs" Inherits="ProjetoBD.Pages.Users" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <table style="width:100%;">
                <tr>
                    <td>
                        <asp:LinkButton ID="link_geoCenters" runat="server" PostBackUrl="~/Pages/GeoCenters.aspx">Geo Centers</asp:LinkButton>
                        <asp:LinkButton ID="link_logs" runat="server" style="margin-left: 20px;" PostBackUrl="~/Pages/Logs.aspx">Logs</asp:LinkButton>
                        <asp:LinkButton ID="link_logTypes" runat="server" style="margin-left: 20px;" PostBackUrl="~/Pages/LogTypes.aspx">Log Types</asp:LinkButton>
                        <asp:LinkButton ID="link_reservations" runat="server" style="margin-left: 20px;" PostBackUrl="~/Pages/Reservations.aspx">Reservations</asp:LinkButton>
                        <asp:LinkButton ID="link_roles" runat="server" style="margin-left: 20px;" PostBackUrl="~/Pages/Roles.aspx">Roles</asp:LinkButton>
                        <asp:LinkButton ID="link_rooms" runat="server" style="margin-left: 20px;" PostBackUrl="~/Pages/Rooms.aspx">Rooms</asp:LinkButton>
                        <asp:LinkButton ID="link_users" runat="server" style="margin-left: 20px;" PostBackUrl="~/Pages/Users.aspx">Users</asp:LinkButton>
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                </tr>
            </table>
            <table style="width:100%;">
                <tr>
                    <td>Name:<asp:TextBox ID="textBox_name" runat="server" style="margin-left: 20px">
                        </asp:TextBox>
                        <asp:Button ID="button_filterName" runat="server" Text="Filter by Name" OnClick="button_filterName_Click" style="margin-left: 20px" />
                    </td>
                </tr>
                <tr>
                    <td>Role:<asp:DropDownList ID="listBox_role" runat="server" DataSourceID="SqlData_Roles" DataTextField="Name" DataValueField="ID" style="margin-left: 20px">
                        </asp:DropDownList>
                        <asp:Button ID="button_filterRole" runat="server" Text="Filter by Role" OnClick="button_filterRole_Click" style="margin-left: 20px" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Button ID="button_clearFilters" runat="server" Text="Clear Filters" OnClick="button_clearFilters_Click" />
                    </td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
            </table>
        </div>
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataSourceID="SqlData_Users" DataKeyNames="ID" OnRowDeleting="GridView1_RowDeleting" OnRowEditing="GridView1_RowEditing">
            <Columns>
                <asp:BoundField DataField="NIF" HeaderText="NIF" SortExpression="NIF" ReadOnly="true" />
                <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" ReadOnly="true"/>
                <asp:BoundField DataField="Email" HeaderText="Email" SortExpression="Email" ReadOnly="true"/>
                <asp:BoundField DataField="PhoneN" HeaderText="PhoneN" SortExpression="PhoneN" ReadOnly="true"/>
                <asp:BoundField DataField="Role" HeaderText="Role" SortExpression="Role" ReadOnly="true"/>
                <asp:CheckBoxField DataField="IsActive" HeaderText="IsActive" SortExpression="IsActive" ReadOnly="true"/>
                <asp:ButtonField CommandName="Edit" HeaderText="Edit" ShowHeader="True" Text="Edit" />
                <asp:ButtonField CommandName="Delete" HeaderText="Delete" ShowHeader="True" Text="Delete" />
            </Columns>
        </asp:GridView>
        <asp:SqlDataSource ID="SqlData_Users" runat="server" ConnectionString="<%$ ConnectionStrings:BDbEdi2021ConnectionString %>" SelectCommand="SELECT Users.ID, [NIF], Users.Name, [Email], [PhoneN], Roles.Name as 'Role', Users.IsActive
FROM [Users]
INNER JOIN Roles ON Roles.ID = Users.RoleID"></asp:SqlDataSource>
        <asp:SqlDataSource ID="SqlData_Roles" runat="server" ConnectionString="<%$ ConnectionStrings:BDbEdi2021ConnectionString %>" SelectCommand="SELECT [ID], [Name] FROM [Roles]
WHERE IsActive = 1"></asp:SqlDataSource>
        Rols<table style="width:100%;">
            <tr>
                <td>&nbsp;</td>
            </tr>
        <tr>
            <td>
                Edit Id<asp:TextBox ID="textBox_editId" runat="server" style="margin-left: 20px; margin-right: 20px" ReadOnly="True" Width="53px"></asp:TextBox>
                <asp:Button ID="button_clearEdit" runat="server" Text="Clear Id" OnClick="button_clearEdit_Click" style="margin-right: 20px" />
                <asp:Button ID="button_clearAll" runat="server" Text="Clear All" OnClick="button_clearAll_Click" />
            </td>
        </tr>
            <tr>
                <td>
                    NIF<asp:TextBox ID="textBox_nif" runat="server" style="margin-left: 20px" Width="162px" TextMode="Number"></asp:TextBox>
                    </td>
            </tr>
            <tr>
                <td>
                    Name<asp:TextBox ID="textBox_editName" runat="server" style="margin-left: 20px" Width="161px"></asp:TextBox>
                    </td>
            </tr>
            <tr>
                <td>
                    Email<asp:TextBox ID="textBox_email" runat="server" style="margin-left: 20px" Width="161px" TextMode="Email"></asp:TextBox>
                    </td>
            </tr>
            <tr>
                <td>
                    Phone Number<asp:TextBox ID="textBox_phoneNumber" runat="server" style="margin-left: 20px" Width="161px" TextMode="Phone"></asp:TextBox>
                    </td>
            </tr>
            <tr>
                <td>
                    Password<asp:TextBox ID="textBox_password" runat="server" style="margin-left: 20px" Width="161px" TextMode="Password"></asp:TextBox>
                    </td>
            </tr>
            <tr>
                <td>Is First Login:<asp:CheckBox ID="checkBox_isFirstLogin" runat="server" style="margin-left: 20px" />
                    </td>
            </tr>
            <tr>
                <td>Role:<asp:DropDownList ID="listBox_editRole" runat="server" DataSourceID="SqlData_Roles" DataTextField="Name" DataValueField="ID" style="margin-left: 20px">
                        </asp:DropDownList>
                    </td>
            </tr>
            <tr>
                <td>Is Active:<asp:CheckBox ID="checkBox_isActive" runat="server" style="margin-left: 20px" />
                    </td>
            </tr>
        </table>
        <table style="width:100%;">
            <tr>
                <td>
                    <asp:Button ID="button_save" runat="server" OnClick="button_save_Click" Text="Save" />
                    <asp:SqlDataSource ID="SqlData_Editor" runat="server" ConnectionString="<%$ ConnectionStrings:BDbEdi2021ConnectionString %>"></asp:SqlDataSource>
                </td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
        </table>
    </form>
</body>
</html>
