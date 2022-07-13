using System;
using System.Data.SqlClient;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections.Generic;

namespace ProjetoBD.Pages
{
	public partial class Reservations : Page
	{
		bool isEditing = false;

		protected void Page_Load(object sender, EventArgs e)
		{

		}

		protected void button_filter_Click(object sender, EventArgs e)
		{
			SqlData_Reservations.SelectCommand =
				"SELECT StartDateTime AS 'Beginning', EndDateTime AS 'End', Users.Name AS 'Responsible', Rooms.Name AS 'Room'" +
				" FROM Reservations" +
				" INNER JOIN Rooms ON Rooms.ID = Reservations.Room" +
				" INNER JOIN Users ON Users.ID = Reservations.Responsible" +
				" WHERE Room = " + listBox_rooms.SelectedValue +
				" AND Responsible = " + listBox_users.SelectedValue;
			SqlData_Reservations.DataBind();
		}

		protected void button_clearFilters_Click(object sender, EventArgs e)
		{
			SqlData_Reservations.SelectCommand =
				"SELECT StartDateTime AS 'Beginning', EndDateTime AS 'End', Users.Name AS 'Responsible', Rooms.Name AS 'Room'" +
				" FROM Reservations" +
				" INNER JOIN Rooms ON Rooms.ID = Room" +
				" INNER JOIN Users ON Users.ID = Responsible" +
				" WHERE Reservations.ID > -1";
			SqlData_Reservations.DataBind();
		}

		protected void button_insert_Click(object sender, EventArgs e)
		{
			SqlData_Reservations.InsertCommand =
				"INSERT INTO [Reservations] (StartDateTime, EndDateTime, Responsible, Room)" +
				$" VALUES ('{textBox_start.Text}', '{textBox_end.Text}', {listBox_usersInsert.SelectedValue}, {listBox_roomsInsert.SelectedValue})";
			SqlData_Reservations.Insert();
			SqlData_Reservations.DataBind();
		}

		protected void GridView1_RowDeleting(object sender, GridViewDeleteEventArgs e)
		{
			int id = Convert.ToInt32(GridView1.DataKeys[e.RowIndex].Value.ToString());
			
			SqlData_Reservations.DeleteCommand = $"DELETE FROM [Reservations] WHERE ID = {id}";
			SqlData_Reservations.Delete();
			SqlData_Reservations.DataBind();
		}

		protected void GridView1_RowEditing(object sender, GridViewEditEventArgs e)
		{
			isEditing = true;
			GridView1.EditIndex = e.NewEditIndex;
			SqlData_Reservations.DataBind();
		}

		protected void GridView1_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
		{
			isEditing = false;
			GridView1.EditIndex = -1;
			SqlData_Reservations.DataBind();
		}

		protected void GridView1_RowUpdating(object sender, GridViewUpdateEventArgs e)
		{
			int id = Convert.ToInt32(GridView1.DataKeys[e.RowIndex].Value.ToString());
			
		}
	}
}