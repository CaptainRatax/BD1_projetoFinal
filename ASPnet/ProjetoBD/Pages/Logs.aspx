<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Logs.aspx.cs" Inherits="ProjetoBD.Pages.Logs" %>

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
                    <td>Log Type:
                        <asp:DropDownList ID="listBox_logTypes" runat="server" DataSourceID="SqlData_LogTypes" DataTextField="Name" DataValueField="ID" Height="37px" Width="256px" style="margin-left: 20px">
                        </asp:DropDownList>
                        <asp:Button ID="button_filter" runat="server" OnClick="button_filter_Click" Text="Filter" style="margin-left: 20px" />
                        <asp:Button ID="button_clearFilter" runat="server" Text="Clear filter" style="margin-left: 20px" OnClick="button_clearFilter_Click" />
                    </td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
            </table>
        </div>
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataSourceID="SqlData_Logs">
            <Columns>
                <asp:BoundField DataField="LogDescription" HeaderText="LogDescription" SortExpression="LogDescription" />
                <asp:BoundField DataField="LogDate" HeaderText="LogDate" SortExpression="LogDate" />
                <asp:BoundField DataField="Action" HeaderText="Action" SortExpression="Action" />
            </Columns>
        </asp:GridView>
        <asp:SqlDataSource ID="SqlData_Logs" runat="server" ConnectionString="<%$ ConnectionStrings:BDbEdi2021ConnectionString %>" DeleteCommand="DELETE FROM [Logs] WHERE [ID] = @ID" InsertCommand="INSERT INTO [Logs] ([LogDescription], [LogDate], [LogType]) VALUES (@LogDescription, @LogDate, @LogType)" SelectCommand="SELECT Logs.LogDescription, Logs.LogDate, LogTypes.Name AS 'Action' FROM Logs INNER JOIN LogTypes ON Logs.LogType = LogTypes.ID" UpdateCommand="UPDATE [Logs] SET [LogDescription] = @LogDescription, [LogDate] = @LogDate, [LogType] = @LogType WHERE [ID] = @ID">
            <DeleteParameters>
                <asp:Parameter Name="ID" Type="Int32" />
            </DeleteParameters>
            <InsertParameters>
                <asp:Parameter Name="LogDescription" Type="String" />
                <asp:Parameter Name="LogDate" Type="DateTime" />
                <asp:Parameter Name="LogType" Type="Int32" />
            </InsertParameters>
            <UpdateParameters>
                <asp:Parameter Name="LogDescription" Type="String" />
                <asp:Parameter Name="LogDate" Type="DateTime" />
                <asp:Parameter Name="LogType" Type="Int32" />
                <asp:Parameter Name="ID" Type="Int32" />
            </UpdateParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="SqlData_LogTypes" runat="server" ConnectionString="<%$ ConnectionStrings:BDbEdi2021ConnectionString %>" SelectCommand="SELECT * FROM [LogTypes]"></asp:SqlDataSource>
    </form>
</body>
</html>
