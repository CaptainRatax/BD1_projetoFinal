using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ProjetoBD.Pages
{
	public partial class Rooms : Page
	{
		protected void Page_Load(object sender, EventArgs e)
		{

		}

		protected void button_filter_Click(object sender, EventArgs e)
		{
			SqlData_Rooms.SelectCommand =
			"SELECT Rooms.ID, Rooms.Name, [MaximumCapacity], [Restrictions], GeoCenters.Name AS 'GeoCenter', [IsCleaned], Rooms.IsActive, [CleaningTime] FROM [Rooms]"
			+ " INNER JOIN GeoCenters ON Rooms.GeoCenter = GeoCenters.ID"
			+ " WHERE Rooms.ID = " + listBox_rooms.SelectedValue;
			SqlData_Rooms.Select(DataSourceSelectArguments.Empty);
			SqlData_Rooms.DataBind();
		}

		protected void button_clearFilters_Click(object sender, EventArgs e)
		{
			SqlData_Rooms.SelectCommand =
				"SELECT Rooms.ID, Rooms.Name, [MaximumCapacity], [Restrictions], GeoCenters.Name AS 'GeoCenter', [IsCleaned], Rooms.IsActive, [CleaningTime] FROM [Rooms]"
				+ " INNER JOIN GeoCenters ON Rooms.GeoCenter = GeoCenters.ID"
				+ " WHERE 1 = 1";
			SqlData_Rooms.Select(DataSourceSelectArguments.Empty);
			SqlData_Rooms.DataBind();
		}

		protected void button_save_Click(object sender, EventArgs e)
		{
			if (string.IsNullOrEmpty(textBox_name.Text) || string.IsNullOrEmpty(textBox_maximumCapacity.Text) || string.IsNullOrEmpty(textBox_restrictions.Text) || string.IsNullOrEmpty(textBox_cleaningTime.Text))
			{
				return;
			}

			if (string.IsNullOrEmpty(textBox_editId.Text))
			{
				SqlData_Rooms.InsertCommand =
					"INSERT INTO [Rooms] (Name, MaximumCapacity, Restrictions, GeoCenter, IsCleaned, CleaningTime, IsActive)" +
					$" VALUES ('{textBox_name.Text}', '{textBox_maximumCapacity.Text}', '{textBox_restrictions.Text}', '{listBox_geoCenter.SelectedValue}','{Convert.ToInt32(checkBox_isCleaned.Checked)}','{textBox_cleaningTime.Text}','{Convert.ToInt32(checkBox_isActive.Checked)}')";
				SqlData_Rooms.Insert();
			}
			else
			{
				int editId = Convert.ToInt32(textBox_editId.Text);

				SqlData_Rooms.UpdateCommand =
					"UPDATE [Rooms]" +
					$" SET Name = '{textBox_name.Text}', MaximumCapacity = '{textBox_maximumCapacity.Text}', Restrictions = '{textBox_restrictions.Text}', GeoCenter = '{listBox_geoCenter.SelectedValue}', IsCleaned = '{Convert.ToInt32(checkBox_isCleaned.Checked)}', CleaningTime = '{textBox_cleaningTime.Text}', IsActive = '{Convert.ToInt32(checkBox_isActive.Checked)}'" +
					$" WHERE ID = " + editId;
				SqlData_Rooms.Update();
			}

			SqlData_Rooms.DataBind();
		}

		protected void GridView1_RowDeleting(object sender, GridViewDeleteEventArgs e)
		{
			int id = Convert.ToInt32(GridView1.DataKeys[e.RowIndex].Value.ToString());

			SqlData_Rooms.DeleteCommand = $"UPDATE [Rooms] SET IsActive = 0 WHERE ID = {id}";
			SqlData_Rooms.Delete();
			SqlData_Rooms.DataBind();
		}

		protected void GridView1_RowEditing(object sender, GridViewEditEventArgs e)
		{
			GridView1.EditIndex = e.NewEditIndex;
			SqlData_Rooms.DataBind();

			int id = Convert.ToInt32(GridView1.DataKeys[e.NewEditIndex].Value.ToString());
			SqlData_Editor.SelectCommand =
				"SELECT Name, MaximumCapacity, Restrictions, GeoCenter, IsCleaned, CleaningTime, IsActive" +
				" FROM Rooms" +
				" WHERE ID = " + id;
			DataView dv = (DataView)SqlData_Editor.Select(DataSourceSelectArguments.Empty);
			SqlData_Editor.DataBind();

			DataTable dt = dv.ToTable();

			textBox_editId.Text = id.ToString();

			textBox_name.Text = dt.Rows[0]["Name"].ToString();
			textBox_maximumCapacity.Text = dt.Rows[0]["MaximumCapacity"].ToString();
			textBox_restrictions.Text = dt.Rows[0]["Restrictions"].ToString();
			listBox_geoCenter.SelectedValue = dt.Rows[0]["GeoCenter"].ToString();
			checkBox_isCleaned.Checked = Convert.ToBoolean(dt.Rows[0]["IsCleaned"]);
			textBox_cleaningTime.Text = dt.Rows[0]["CleaningTime"].ToString();
			checkBox_isActive.Checked = Convert.ToBoolean(dt.Rows[0]["IsActive"]);
		}

		protected void button_clearEdit_Click(object sender, EventArgs e)
		{
			textBox_editId.Text = string.Empty;
		}

		protected void button_clearAll_Click(object sender, EventArgs e)
		{
			textBox_editId.Text = string.Empty;

			textBox_name.Text = string.Empty;
			textBox_maximumCapacity.Text = string.Empty;
			textBox_restrictions.Text = string.Empty;
			listBox_geoCenter.SelectedIndex = 0;
			checkBox_isCleaned.Checked = false;
			textBox_cleaningTime.Text = string.Empty;
			checkBox_isActive.Checked = false;
		}
	}
}