<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="BD1_TP.Index" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>BD1-TP</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Label ID="Label1" runat="server" Text="Espaço:"></asp:Label>
            <asp:TextBox ID="txtPesquisa" runat="server"></asp:TextBox>
            <asp:Button runat="server" Text="Pesquisar Espaço" />
            <asp:Button ID="btnLimparPesquisa" runat="server" Text="Limpar Pesquisa" OnClick="btnLimparPesquisa_Click" />
        </div>
        <br />
        <div>
            <asp:Label ID="Label2" runat="server" Text="Nome do Espaço:"></asp:Label>
            <asp:TextBox ID="txtNovoEspaco" runat="server"></asp:TextBox>
            <asp:Button ID="btnAdicionarEspaco" runat="server" Text="Adicionar espaço" OnClick="btnAdicionarEspaco_Click" />
        </div>
        <br />
        <div>
            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="ID" DataSourceID="SqlDataSource1">
                <Columns>
                    <asp:BoundField DataField="ID" HeaderText="ID" InsertVisible="False" ReadOnly="True" SortExpression="ID" />
                    <asp:BoundField DataField="Grupo" HeaderText="Grupo" SortExpression="Grupo" />
                    <asp:BoundField DataField="Espaço" HeaderText="Espaço" SortExpression="Espaço" />
                    <asp:BoundField DataField="Criado por" HeaderText="Criado por" SortExpression="Criado por" />
                    <asp:BoundField DataField="Nível" HeaderText="Nível baseado nos reports dos últimos 10min." SortExpression="Nível" />
                    <asp:TemplateField HeaderText="Opções">
                        <ItemTemplate>
                            <asp:HyperLink ID="btnVer" runat="server" NavigateUrl='<%#Eval("ID", "VerEspaco.aspx?ID={0}") %>'>Ver</asp:HyperLink>
                            <asp:HyperLink ID="btnEditar" runat="server" NavigateUrl='<%#Eval("ID", "EditarEspaco.aspx?ID={0}") %>'>Editar</asp:HyperLink>
                            <asp:LinkButton ID="btnRemover" runat="server" OnClick="btnRemover_Click">Remover</asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:BDbEdiConnectionString %>"
                SelectCommand="spListarEspacos" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:ControlParameter Name="PlaceName" ControlID="txtPesquisa" PropertyName="Text" DefaultValue="" ConvertEmptyStringToNull="false" />
                </SelectParameters>
            </asp:SqlDataSource>
        </div>
        <br />
        <div>
            <asp:Button ID="btnConsultas" runat="server" Text="Consultas" OnClick="btnConsultas_Click" />
        </div>
    </form>
</body>
</html>
