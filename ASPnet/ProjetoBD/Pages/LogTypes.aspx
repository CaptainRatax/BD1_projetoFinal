<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LogTypes.aspx.cs" Inherits="ProjetoBD.Pages.LogTypes" %>

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
                    <td>Name:<asp:TextBox ID="textBox_name" runat="server" style="margin-left: 20px; margin-right: 20px">
                        </asp:TextBox>
                        <asp:Button ID="button_filterName" runat="server" Text="Filter by Name" OnClick="button_filterName_Click" />
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
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataSourceID="SqlData_LogTypes" DataKeyNames="ID" OnRowDeleting="GridView1_RowDeleting" OnRowEditing="GridView1_RowEditing">
            <Columns>
                <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" ReadOnly="true"/>
                <asp:ButtonField CommandName="Edit" HeaderText="Edit" ShowHeader="True" Text="Edit" />
                <asp:ButtonField CommandName="Delete" HeaderText="Delete" ShowHeader="True" Text="Delete" />
            </Columns>
        </asp:GridView>
        <asp:SqlDataSource ID="SqlData_LogTypes" runat="server" ConnectionString="<%$ ConnectionStrings:BDbEdi2021ConnectionString %>" SelectCommand="SELECT [ID], [Name] FROM [LogTypes]"></asp:SqlDataSource>
        <table style="width:100%;">
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
                    Name<asp:TextBox ID="textBox_editName" runat="server" style="margin-left: 20px" Width="161px"></asp:TextBox>
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
