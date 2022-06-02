<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Consultas.aspx.cs" Inherits="BD1_TP.Consultas" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Button ID="btnVoltar" runat="server" Text="Voltar" OnClick="btnVoltar_Click" />
            <asp:Button ID="btnReportar" runat="server" Text="Inserir report de nível alto" OnClick="btnReportar_Click" AutoPostBack="True" />
        </div>
        <br />
        <div>
            <asp:DropDownList ID="ddlConsulta" runat="server" AutoPostBack="true">
                <asp:ListItem Value="1">Nº de reports de cada utilizador</asp:ListItem>
                <asp:ListItem Value="2">Utilizadores sem reports</asp:ListItem>
                <asp:ListItem Value="3">Alertas de concentração</asp:ListItem>
            </asp:DropDownList>
        </div>
        <br />
        <div>
            <asp:GridView ID="GridView1" runat="server" AllowPaging="True" AutoGenerateColumns="True" DataSourceID="SqlDataSource1">
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:BDbEdiConnectionString %>" SelectCommand="spConsultas" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:ControlParameter Name="paramIdConsulta" ControlID="ddlConsulta"  PropertyName="SelectedValue" DefaultValue="" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>
        </div>
    </form>
</body>
</html>
