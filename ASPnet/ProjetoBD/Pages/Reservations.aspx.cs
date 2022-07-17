using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ProjetoBD.Pages
{
	public partial class Reservations : Page
	{
		protected void Page_Load(object sender, EventArgs e)
		{

		}

		protected void button_filter_Click(object sender, EventArgs e)
		{
			SqlData_Reservations.SelectCommand =
				"SELECT Reservations.ID, StartDateTime AS 'Beginning', EndDateTime AS 'End', Users.Name AS 'Responsible', Rooms.Name AS 'Room'" +
				" FROM Reservations" +
				" INNER JOIN Rooms ON Rooms.ID = Reservations.Room" +
				" INNER JOIN Users ON Users.ID = Reservations.Responsible" +
				" WHERE Room = " + listBox_rooms.SelectedValue +
				" AND Responsible = " + listBox_users.SelectedValue;
			SqlData_Reservations.Select(DataSourceSelectArguments.Empty);
			SqlData_Reservations.DataBind();
		}

		protected void button_clearFilters_Click(object sender, EventArgs e)
		{
			SqlData_Reservations.SelectCommand =
				"SELECT Reservations.ID, StartDateTime AS 'Beginning', EndDateTime AS 'End', Users.Name AS 'Responsible', Rooms.Name AS 'Room'" +
				" FROM Reservations" +
				" INNER JOIN Rooms ON Rooms.ID = Room" +
				" INNER JOIN Users ON Users.ID = Responsible";
			SqlData_Reservations.Select(DataSourceSelectArguments.Empty);
			SqlData_Reservations.DataBind();
		}

		protected void button_save_Click(object sender, EventArgs e)
		{
			if (string.IsNullOrEmpty(textBox_editId.Text))
			{
				SqlData_Reservations.InsertCommand =
					"INSERT INTO [Reservations] (StartDateTime, EndDateTime, Responsible, Room)" +
					$" VALUES ('{textBox_start.Text}', '{textBox_end.Text}', {listBox_usersInsert.SelectedValue}, {listBox_roomsInsert.SelectedValue})";
				SqlData_Reservations.Insert();
			}
			else
			{
				int editId = Convert.ToInt32(textBox_editId.Text);

				SqlData_Reservations.UpdateCommand =
					"UPDATE [Reservations]" +
					$" SET StartDateTime = '{textBox_start.Text}', EndDateTime = '{textBox_end.Text}', Responsible = '{listBox_usersInsert.SelectedValue}', Room = '{listBox_roomsInsert.SelectedValue}'" +
					$" WHERE ID = " + editId;
				SqlData_Reservations.Update();
			}

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
			GridView1.EditIndex = e.NewEditIndex;
			SqlData_Reservations.DataBind();

			int id = Convert.ToInt32(GridView1.DataKeys[e.NewEditIndex].Value.ToString());
			SqlData_Editor.SelectCommand =
				"SELECT StartDateTime, EndDateTime, Responsible, Room" +
				" FROM Reservations" +
				" WHERE ID = " + id;
			DataView dv = (DataView)SqlData_Editor.Select(DataSourceSelectArguments.Empty);
			SqlData_Editor.DataBind();

			DataTable dt = dv.ToTable();

			textBox_editId.Text = id.ToString();

			textBox_start.Text = this.GetSqlData(dt.Rows[0]["StartDateTime"].ToString());
			textBox_end.Text = this.GetSqlData(dt.Rows[0]["EndDateTime"].ToString());
			listBox_usersInsert.SelectedValue = dt.Rows[0]["Responsible"].ToString();
			listBox_roomsInsert.SelectedValue = dt.Rows[0]["Room"].ToString();
		}

		protected void button_clearEdit_Click(object sender, EventArgs e)
		{
			textBox_editId.Text = string.Empty;
		}

		protected void button_clearAll_Click(object sender, EventArgs e)
		{
			textBox_editId.Text = string.Empty;

			textBox_start.Text = string.Empty;
			textBox_end.Text = string.Empty;
			listBox_usersInsert.SelectedIndex = 0;
			listBox_roomsInsert.SelectedIndex = 0;
		}

		private string GetSqlData(string data)
		{
			string[] split = data.Split('/');
			return $"{split[2].Split(' ')[0]}/{split[1]}/{split[0]} {split[2].Split(' ')[1]}";
		}
	}
}