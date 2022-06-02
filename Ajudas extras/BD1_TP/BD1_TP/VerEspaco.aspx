<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="VerEspaco.aspx.cs" Inherits="BD1_TP.VerEspaco" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css" />
    <script src="//code.jquery.com/jquery-1.10.2.js"></script>
    <script src="//code.jquery.com/ui/1.11.4/jquery-ui.js"></script>

    <script>
        $(function () {
            $("#txtDataInicio").datepicker({
                defaultDate: "+1w",
                changeMonth: true,
                changeYear: true,
                onClose: function (selectedDate) {
                    $("#txtDataInicio").datepicker("option", "minDate", selectedDate);
                }
            });

            $("#txtDataFim").datepicker({
                defaultDate: "+1w",
                changeMonth: true,
                changeYear: true,
                onClose: function (selectedDate) {
                    $("#txtDataFim").datepicker("option", "maxDate", selectedDate);
                }
            });
        })
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Button ID="btnVoltar" runat="server" Text="Voltar" OnClick="btnVoltar_Click" />
            <asp:TextBox ID="txtIdEspaco" runat="server" Visible="false"></asp:TextBox>
        </div>
        <br />
        <table style="width: 100%;">
            <tr>
                <td>
                    <div>
                        Últimos 10 reports:
                    </div>
                </td>
                <td>
                    <div>
                        Data Início:
                        <asp:TextBox ID="txtDataInicio" runat="server"></asp:TextBox>
                        Data Fim:
                        <asp:TextBox ID="txtDataFim" runat="server"></asp:TextBox>
                        <asp:Button ID="btnListar" runat="server" Text="Listar reports entre estas datas" OnClick="btnListar_Click" />
                        <asp:Button ID="btnLimparDatas" runat="server" Text="Limpar Datas" OnClick="btnLimparDatas_Click" />
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <div>
                        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="ID" DataSourceID="SqlDataSource1">
                            <Columns>
                                <asp:BoundField DataField="ID" HeaderText="ID" InsertVisible="False" ReadOnly="True" SortExpression="ID" />
                                <asp:BoundField DataField="Nível" HeaderText="Nível" ReadOnly="True" SortExpression="Nível" />
                                <asp:BoundField DataField="Criado por" HeaderText="Criado por" SortExpression="Criado por" />
                                <asp:BoundField DataField="Data&amp;Hora" HeaderText="Data&amp;Hora" SortExpression="Data&amp;Hora" />
                            </Columns>
                        </asp:GridView>
                        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:BDbEdiConnectionString %>"
                            SelectCommand="spListarDezUltReports" SelectCommandType="StoredProcedure">
                            <SelectParameters>
                                <asp:ControlParameter Name="paramIdEspaco" ControlID="txtIdEspaco" PropertyName="Text" DefaultValue="" ConvertEmptyStringToNull="false" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </div>
                </td>
                <td>
                    <div>
                        <asp:GridView ID="GridView2" runat="server" AllowPaging="True" AutoGenerateColumns="False" DataKeyNames="ID" DataSourceID="SqlDataSource2">
                            <Columns>
                                <asp:BoundField DataField="ID" HeaderText="ID" InsertVisible="False" ReadOnly="True" SortExpression="ID" />
                                <asp:BoundField DataField="Nível" HeaderText="Nível" SortExpression="Nível" />
                                <asp:BoundField DataField="Criado por" HeaderText="Criado por" SortExpression="Criado por" />
                                <asp:BoundField DataField="Data&amp;Hora" HeaderText="Data&amp;Hora" SortExpression="Data&amp;Hora" />
                            </Columns>
                        </asp:GridView>
                        <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:BDbEdiConnectionString %>" SelectCommand="spListarReportsEntreDatas" SelectCommandType="StoredProcedure">
                            <SelectParameters>
                                <asp:ControlParameter Name="paramIdEspaco" ControlID="txtIdEspaco" PropertyName="Text" DefaultValue="" ConvertEmptyStringToNull="false" />
                                <asp:ControlParameter Name="paramDataInicio" ControlID="txtDataInicio" PropertyName="Text" DefaultValue="" ConvertEmptyStringToNull="false" />
                                <asp:ControlParameter Name="paramDataFim" ControlID="txtDataFim" PropertyName="Text" DefaultValue="" ConvertEmptyStringToNull="false" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </div>
                </td>
            </tr>
        </table>

    </form>
</body>
</html>
