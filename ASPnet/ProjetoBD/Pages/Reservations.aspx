<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Reservations.aspx.cs" Inherits="ProjetoBD.Pages.Reservations" %>

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
                    <td>User:<asp:DropDownList ID="listBox_users" runat="server" DataSourceID="SqlData_Users" DataTextField="Name" DataValueField="ID" style="margin-left: 20px">
                        </asp:DropDownList>
                    </td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td>Room:<asp:DropDownList ID="listBox_rooms" runat="server" DataSourceID="SqlData_Rooms" DataTextField="Name" DataValueField="ID" style="margin-left: 20px">
                        </asp:DropDownList>
                    </td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td>
                        <asp:Button ID="button_filter" runat="server" Text="Filter" OnClick="button_filter_Click" />
                        <asp:Button ID="button_clearFilters" runat="server" Text="Clear Filters" style="margin-left: 20px" OnClick="button_clearFilters_Click" />
                    </td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
            </table>
        </div>
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataSourceID="SqlData_Reservations" DataKeyNames="ID" OnRowDeleting="GridView1_RowDeleting" OnRowEditing="GridView1_RowEditing">
            <Columns>
                <asp:BoundField DataField="Beginning" HeaderText="Beginning" SortExpression="Beginning" />
                <asp:BoundField DataField="End" HeaderText="End" SortExpression="End" />
                <asp:BoundField DataField="Responsible" HeaderText="Responsible" SortExpression="Responsible" />
                <asp:BoundField DataField="Room" HeaderText="Room" SortExpression="Room" />
                <asp:ButtonField CommandName="Edit" HeaderText="Edit" ShowHeader="True" Text="Edit" />
                <asp:ButtonField CommandName="Delete" HeaderText="Delete" ShowHeader="True" Text="Delete" />
            </Columns>
        </asp:GridView>
        <asp:SqlDataSource ID="SqlData_Reservations" runat="server" ConnectionString="<%$ ConnectionStrings:BDbEdi2021ConnectionString %>" SelectCommand="SELECT Reservations.ID, StartDateTime AS 'Beginning', EndDateTime AS 'End', Users.Name AS 'Responsible', Rooms.Name AS 'Room'
FROM Reservations
INNER JOIN Rooms ON Rooms.ID = Room
INNER JOIN Users ON Users.ID = Responsible"></asp:SqlDataSource>
        <asp:SqlDataSource ID="SqlData_Rooms" runat="server" ConnectionString="<%$ ConnectionStrings:BDbEdi2021ConnectionString %>" SelectCommand="SELECT [ID], [Name] FROM [Rooms]"></asp:SqlDataSource>
        <asp:SqlDataSource ID="SqlData_Users" runat="server" ConnectionString="<%$ ConnectionStrings:BDbEdi2021ConnectionString %>" SelectCommand="SELECT [ID], [Name] FROM [Users]"></asp:SqlDataSource>
        <table style="width:100%;">
            <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
        <tr>
            <td>
                Edit Id<asp:TextBox ID="textBox_editId" runat="server" style="margin-left: 20px; margin-right: 20px" ReadOnly="True" Width="53px"></asp:TextBox>
                <asp:Button ID="button_clearEdit" runat="server" Text="Clear Id" OnClick="button_clearEdit_Click" style="margin-right: 20px" />
                <asp:Button ID="button_clearAll" runat="server" Text="Clear All" OnClick="button_clearAll_Click" />
            </td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
            <tr>
                <td>
                    Start Time<asp:TextBox ID="textBox_start" runat="server" style="margin-left: 20px; margin-right: 20px" Width="172px"></asp:TextBox>
                    YYYY-MM-DD hh:mm:ss</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td>
                    End Time<asp:TextBox ID="textBox_end" runat="server" style="margin-left: 20px; margin-right: 20px" Width="161px"></asp:TextBox>
                    YYYY-MM-DD hh:mm:ss</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
        </table>
        <table style="width:100%;">
            <tr>
                <td>User:<asp:DropDownList ID="listBox_usersInsert" runat="server" DataSourceID="SqlData_Users" DataTextField="Name" DataValueField="ID" style="margin-left: 20px">
                        </asp:DropDownList>
                    </td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td>Room:<asp:DropDownList ID="listBox_roomsInsert" runat="server" DataSourceID="SqlData_Rooms" DataTextField="Name" DataValueField="ID" style="margin-left: 20px">
                        </asp:DropDownList>
                    </td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
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
