using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BD1_TP
{
    public partial class Index : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                SqlDataSource1.DataBind();
            }
        }

        protected void btnLimparPesquisa_Click(object sender, EventArgs e)
        {
            txtPesquisa.Text = "";
            SqlDataSource1.DataBind();
        }

        protected void btnAdicionarEspaco_Click(object sender, EventArgs e)
        {
            BD_Class bd = new BD_Class();
            bd.AdicionarEspaco(txtNovoEspaco.Text);
            txtNovoEspaco.Text = "";
            Page.Response.Redirect(Page.Request.Url.ToString(), true);
        }

        protected void btnRemover_Click(object sender, EventArgs e)
        {
            int placeID;
            GridViewRow grdrow = (GridViewRow)((LinkButton)sender).NamingContainer;
            int.TryParse(grdrow.Cells[0].Text, out placeID);

            BD_Class bd = new BD_Class();
            bd.RemoverEspaco(placeID);
            Page.Response.Redirect(Page.Request.Url.ToString(), true);
        }

        protected void btnConsultas_Click(object sender, EventArgs e)
        {
            Page.Response.Redirect("~/Consultas.aspx", true);
        }
    }
}