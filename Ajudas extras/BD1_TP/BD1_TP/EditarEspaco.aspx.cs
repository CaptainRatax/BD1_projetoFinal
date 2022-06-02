using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BD1_TP
{
    public partial class EditarEspaco : System.Web.UI.Page
    {
        int placeID;

        protected void Page_Load(object sender, EventArgs e)
        {
            int.TryParse(Request.Params["ID"], out placeID);

            if (!Page.IsPostBack)
            {
                BD_Class bd = new BD_Class();
                txtNome.Text = bd.BuscarNomeEspaco(placeID);
            }
        }

        protected void btnConfirmar_Click(object sender, EventArgs e)
        {
            string novoNome = txtNome.Text;
            BD_Class bd = new BD_Class();
            bd.EditarEspaco(placeID, novoNome);
            Page.Response.Redirect("~/Index.aspx", true);
        }

        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            Page.Response.Redirect("~/Index.aspx", true);
        }
    }
}