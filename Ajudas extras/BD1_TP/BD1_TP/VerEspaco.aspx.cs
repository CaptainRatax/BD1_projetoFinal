using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BD1_TP
{
    public partial class VerEspaco : System.Web.UI.Page
    {
        int placeID;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                if (Request.Params["ID"] != null && int.TryParse(Request.Params["ID"], out placeID))
                {
                    txtIdEspaco.Text = placeID.ToString();
                }
            }

            SqlDataSource1.DataBind();
            SqlDataSource2.DataBind();
        }

        protected void btnVoltar_Click(object sender, EventArgs e)
        {
            Page.Response.Redirect("~/Index.aspx", true);
        }

        protected void btnListar_Click(object sender, EventArgs e)
        {
            string dataInicioDia = txtDataInicio.Text.Substring(3, 2);
            string dataFimDia = txtDataFim.Text.Substring(3, 2);

            string dataInicioMes = txtDataInicio.Text.Remove(2);
            string dataFimMes = txtDataFim.Text.Remove(2);

            string dataInicioAno = txtDataInicio.Text.Substring(6);
            string dataFimAno = txtDataFim.Text.Substring(6);

            DateTime dataInicio = Convert.ToDateTime(dataInicioAno + '-' + dataInicioMes + '-' + dataInicioDia);
            DateTime dataFim = Convert.ToDateTime(dataFimAno + '-' + dataFimMes + '-' + dataFimDia);

            BD_Class bd = new BD_Class();
            bd.ListarReportsEntreDatas(placeID, dataInicio, dataFim);
            SqlDataSource2.DataBind();
        }

        protected void btnLimparDatas_Click(object sender, EventArgs e)
        {
            txtDataInicio.Text = "";
            txtDataFim.Text = "";
            SqlDataSource2.DataBind();
        }
    }
}