using System;
using System.Web.UI;

namespace ProjetoBD.Pages
{
	public partial class Logs : Page
	{
		protected void Page_Load(object sender, EventArgs e)
		{

		}

		protected void button_filter_Click(object sender, EventArgs e)
		{
			SqlData_Logs.SelectCommand = "SELECT Logs.LogDescription, Logs.LogDate, LogTypes.Name AS 'Action' FROM Logs INNER JOIN LogTypes ON Logs.LogType = LogTypes.ID WHERE [Logs].LogType = " + listBox_logTypes.SelectedValue;
			SqlData_Logs.DataBind();
		}

		protected void button_clearFilter_Click(object sender, EventArgs e)
		{
			SqlData_Logs.SelectCommand = "SELECT Logs.LogDescription, Logs.LogDate, LogTypes.Name AS 'Action' FROM Logs INNER JOIN LogTypes ON Logs.LogType = LogTypes.ID WHERE [Logs].ID > -1";
			SqlData_Logs.DataBind();
		}
	}
}