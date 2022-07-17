using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ProjetoBD.Pages
{
	public partial class Roles : Page
	{
		protected void Page_Load(object sender, EventArgs e)
		{

		}

		protected void button_filterCode_Click(object sender, EventArgs e)
		{
			SqlData_Roles.SelectCommand =
				"SELECT [ID], [Code], [Name], [ReserveRooms], [CreateRooms], [EditRooms], [CreateGeoCenters], [EditGeoCenters], [CreateUsers], [EditUsers], [IsActive] FROM [Roles]"
				+ $" WHERE Code LIKE '%{textBox_code.Text}%'";
			SqlData_Roles.Select(DataSourceSelectArguments.Empty);
			SqlData_Roles.DataBind();
		}

		protected void button_filterName_Click(object sender, EventArgs e)
		{
			SqlData_Roles.SelectCommand =
				"SELECT [ID], [Code], [Name], [ReserveRooms], [CreateRooms], [EditRooms], [CreateGeoCenters], [EditGeoCenters], [CreateUsers], [EditUsers], [IsActive] FROM [Roles]"
				+ $" WHERE Name LIKE '%{textBox_name.Text}%'";
			SqlData_Roles.Select(DataSourceSelectArguments.Empty);
			SqlData_Roles.DataBind();
		}

		protected void button_clearFilters_Click(object sender, EventArgs e)
		{
			textBox_code.Text = string.Empty;
			textBox_name.Text = string.Empty;
			SqlData_Roles.SelectCommand =
				"SELECT [ID], [Code], [Name], [ReserveRooms], [CreateRooms], [EditRooms], [CreateGeoCenters], [EditGeoCenters], [CreateUsers], [EditUsers], [IsActive] FROM [Roles] WHERE 1 = 1";
			SqlData_Roles.Select(DataSourceSelectArguments.Empty);
			SqlData_Roles.DataBind();
		}

		protected void button_save_Click(object sender, EventArgs e)
		{
			if (string.IsNullOrEmpty(textBox_editId.Text))
			{
				SqlData_Roles.InsertCommand =
					"INSERT INTO [Roles] (Code, Name, ReserveRooms, CreateRooms, EditRooms, CreateGeoCenters, EditGeoCenters, CreateUsers, EditUsers, IsActive)" +
					$" VALUES ('{textBox_editCode.Text}', '{textBox_editName.Text}', '{Convert.ToInt32(checkBox_reserveRooms.Checked)}', '{Convert.ToInt32(checkBox_createRooms.Checked)}', '{Convert.ToInt32(checkBox_editRooms.Checked)}', '{Convert.ToInt32(checkBox_createGeoCenters.Checked)}','{checkBox_editGeoCenters.Checked}','{Convert.ToInt32(checkBox_createUsers.Checked)}', '{Convert.ToInt32(checkBox_editUsers.Checked)}', '{Convert.ToInt32(checkBox_isActive.Checked)}')";
				SqlData_Roles.Insert();
			}
			else
			{
				int editId = Convert.ToInt32(textBox_editId.Text);

				SqlData_Roles.UpdateCommand =
					"UPDATE [Roles]" +
					$" SET Code = '{textBox_editCode.Text}', Name = '{textBox_editName.Text}', ReserveRooms = '{Convert.ToInt32(checkBox_reserveRooms.Checked)}', CreateRooms = '{Convert.ToInt32(checkBox_createRooms.Checked)}', EditRooms = '{Convert.ToInt32(checkBox_editRooms.Checked)}', CreateGeoCenters = '{Convert.ToInt32(checkBox_createGeoCenters.Checked)}', EditGeoCenters = '{Convert.ToInt32(checkBox_editGeoCenters.Checked)}', IsActive = '{Convert.ToInt32(checkBox_isActive.Checked)}'" +
					$" WHERE ID = " + editId;
				SqlData_Roles.Update();
			}

			SqlData_Roles.DataBind();
		}

		protected void GridView1_RowDeleting(object sender, GridViewDeleteEventArgs e)
		{
			int id = Convert.ToInt32(GridView1.DataKeys[e.RowIndex].Value.ToString());

			SqlData_Roles.DeleteCommand = $"UPDATE [Roles] SET IsActive = 0 WHERE ID = {id}";
			SqlData_Roles.Delete();
			SqlData_Roles.DataBind();
		}

		protected void GridView1_RowEditing(object sender, GridViewEditEventArgs e)
		{
			GridView1.EditIndex = e.NewEditIndex;
			SqlData_Roles.DataBind();

			int id = Convert.ToInt32(GridView1.DataKeys[e.NewEditIndex].Value.ToString());
			SqlData_Editor.SelectCommand =
				"SELECT Code, Name, ReserveRooms, CreateRooms, EditRooms, CreateGeoCenters, EditGeoCenters, CreateUsers, EditUsers, IsActive" +
				" FROM Roles" +
				" WHERE ID = " + id;
			DataView dv = (DataView)SqlData_Editor.Select(DataSourceSelectArguments.Empty);
			SqlData_Editor.DataBind();

			DataTable dt = dv.ToTable();

			textBox_editId.Text = id.ToString();

			textBox_editCode.Text = dt.Rows[0]["Code"].ToString();
			textBox_editName.Text = dt.Rows[0]["Name"].ToString();
			checkBox_reserveRooms.Checked = Convert.ToBoolean(dt.Rows[0]["ReserveRooms"]);
			checkBox_createRooms.Checked = Convert.ToBoolean(dt.Rows[0]["CreateRooms"]);
			checkBox_editRooms.Checked = Convert.ToBoolean(dt.Rows[0]["EditRooms"]);
			checkBox_createGeoCenters.Checked = Convert.ToBoolean(dt.Rows[0]["CreateGeoCenters"]);
			checkBox_editGeoCenters.Checked = Convert.ToBoolean(dt.Rows[0]["EditGeoCenters"]);
			checkBox_createUsers.Checked = Convert.ToBoolean(dt.Rows[0]["CreateUsers"]);
			checkBox_editUsers.Checked = Convert.ToBoolean(dt.Rows[0]["EditUsers"]);
			checkBox_isActive.Checked = Convert.ToBoolean(dt.Rows[0]["IsActive"]);
		}

		protected void button_clearEdit_Click(object sender, EventArgs e)
		{
			textBox_editId.Text = string.Empty;
		}

		protected void button_clearAll_Click(object sender, EventArgs e)
		{
			textBox_editId.Text = string.Empty;

			textBox_editCode.Text = string.Empty;
			textBox_editName.Text = string.Empty;
			checkBox_reserveRooms.Checked = false;
			checkBox_createRooms.Checked = false;
			checkBox_editRooms.Checked = false;
			checkBox_createGeoCenters.Checked = false;
			checkBox_editGeoCenters.Checked = false;
			checkBox_createUsers.Checked = false;
			checkBox_editUsers.Checked = false;
			checkBox_isActive.Checked = false;
		}
	}
}