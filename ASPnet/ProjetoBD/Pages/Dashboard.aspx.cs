using System;
using System.Web.UI;

namespace ProjetoBD.Pages
{
	public partial class Dashboard : Page
	{
		private string sql1;

		protected void Page_Load(object sender, EventArgs e)
		{
			sql1 = SqlData_1.SelectCommand;
			SqlData_1.SelectCommand = string.Format(SqlData_1.SelectCommand, "2022-04-29", 3);
		}

		protected void button_search_Click(object sender, EventArgs e)
		{
			SqlData_1.SelectCommand = "SELECT" +
				" Reservations.ID," +
				" CAST(StartDateTime AS DATE) AS[Date]," +
				" CAST(StartDateTime AS TIME(0)) AS[Start Time]," +
				" CAST(EndDateTime AS TIME(0)) AS[End Time]," +
				" Room," +
				" CAST(EndDateTime - StartDateTime AS TIME(0)) AS[Reservation Time]," +
				" CAST(dateadd(MINUTE, CleaningTime, '00:00:00') AS TIME(0)) AS[Cleaning Time]," +
				" dateadd(MINUTE, CleaningTime, CAST(EndDateTime - StartDateTime AS TIME(0))) AS[Total Time]," +
				" dateadd(MINUTE, CleaningTime, CAST(EndDateTime AS TIME(0))) AS[Available After]" +
				" FROM" +
				" Reservations" +
				" INNER JOIN Rooms ON Rooms.ID = Reservations.Room" +
				" WHERE" +
				$" CAST(StartDateTime AS DATE) = '{textBox_date.Text}' AND" +
				$" Room = {listBox_room.SelectedValue}";
			SqlData_1.Select(DataSourceSelectArguments.Empty);
			SqlData_1.DataBind();
		}
	}
}