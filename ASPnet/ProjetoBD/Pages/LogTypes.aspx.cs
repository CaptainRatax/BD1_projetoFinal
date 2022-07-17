using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ProjetoBD.Pages
{
	public partial class LogTypes : Page
	{
		protected void Page_Load(object sender, EventArgs e)
		{

		}

		protected void button_filterName_Click(object sender, EventArgs e)
		{
			SqlData_LogTypes.SelectCommand =
				"SELECT [ID], [Name] FROM [LogTypes]"
				+ $" WHERE Name LIKE '%{textBox_name.Text}%'";
			SqlData_LogTypes.Select(DataSourceSelectArguments.Empty);
			SqlData_LogTypes.DataBind();
		}

		protected void button_clearFilters_Click(object sender, EventArgs e)
		{
			textBox_name.Text = string.Empty;
			SqlData_LogTypes.SelectCommand =
				"SELECT [ID], [Name] FROM [LogTypes] WHERE 1 = 1";
			SqlData_LogTypes.Select(DataSourceSelectArguments.Empty);
			SqlData_LogTypes.DataBind();
		}

		protected void button_save_Click(object sender, EventArgs e)
		{
			if (string.IsNullOrEmpty(textBox_editId.Text))
			{
				SqlData_LogTypes.InsertCommand =
					"INSERT INTO [LogTypes] (Name)" +
					$" VALUES ('{textBox_editName.Text}')";
				SqlData_LogTypes.Insert();
			}
			else
			{
				int editId = Convert.ToInt32(textBox_editId.Text);

				SqlData_LogTypes.UpdateCommand =
					"UPDATE [LogTypes]" +
					$" SET Name = '{textBox_editName.Text}'" +
					$" WHERE ID = " + editId;
				SqlData_LogTypes.Update();
			}

			SqlData_LogTypes.DataBind();
		}

		protected void GridView1_RowDeleting(object sender, GridViewDeleteEventArgs e)
		{
			int id = Convert.ToInt32(GridView1.DataKeys[e.RowIndex].Value.ToString());

			SqlData_LogTypes.DeleteCommand = "DELETE FROM [LogTypes] WHERE ID = " + id;
			SqlData_LogTypes.Delete();
			SqlData_LogTypes.DataBind();
		}

		protected void GridView1_RowEditing(object sender, GridViewEditEventArgs e)
		{
			GridView1.EditIndex = e.NewEditIndex;
			SqlData_LogTypes.DataBind();

			int id = Convert.ToInt32(GridView1.DataKeys[e.NewEditIndex].Value.ToString());
			SqlData_LogTypes.SelectCommand =
				"SELECT [ID], [Name] FROM [LogTypes]" +
				$" WHERE ID = " + id;
			
			DataView dv = (DataView)SqlData_Editor.Select(DataSourceSelectArguments.Empty);
			SqlData_Editor.DataBind();

			DataTable dt = dv.ToTable();

			textBox_editId.Text = id.ToString();

			textBox_editName.Text = dt.Rows[0]["Name"].ToString();
		}

		protected void button_clearEdit_Click(object sender, EventArgs e)
		{
			textBox_editId.Text = string.Empty;
		}

		protected void button_clearAll_Click(object sender, EventArgs e)
		{
			textBox_editId.Text = string.Empty;

			textBox_editName.Text = string.Empty;
		}
	}
}