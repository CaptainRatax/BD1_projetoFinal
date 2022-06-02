using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BD1_TP
{
    public partial class Consultas : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            SqlDataSource1.DataBind();
        }

        protected void btnVoltar_Click(object sender, EventArgs e)
        {
            Page.Response.Redirect("~/Index.aspx", true);
        }

        protected void btnReportar_Click(object sender, EventArgs e)
        {
            BD_Class bd = new BD_Class();
            bd.InserirReportParaTeste();
            GridView1.DataBind();
        }
    }
}