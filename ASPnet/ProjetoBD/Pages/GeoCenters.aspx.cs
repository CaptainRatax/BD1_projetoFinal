﻿using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ProjetoBD.Pages
{
	public partial class GeoCenters : Page
	{
		protected void Page_Load(object sender, EventArgs e)
		{

		}

		protected void button_filter_Click(object sender, EventArgs e)
		{
			SqlData_GeoCenters.SelectCommand =
				"SELECT [ID], [Name], [Location]" +
				" FROM GeoCenters" +
				" WHERE Location = '" + listBox_locations.SelectedValue + "'";
			SqlData_GeoCenters.Select(DataSourceSelectArguments.Empty);
			SqlData_GeoCenters.DataBind();
		}

		protected void button_clearFilters_Click(object sender, EventArgs e)
		{
			SqlData_GeoCenters.SelectCommand = "SELECT [ID], [Name], [Location] FROM GeoCenters";
			SqlData_GeoCenters.Select(DataSourceSelectArguments.Empty);
			SqlData_GeoCenters.DataBind();
		}

		protected void button_save_Click(object sender, EventArgs e)
		{
			if (string.IsNullOrEmpty(textBox_editId.Text))
			{
				SqlData_GeoCenters.InsertCommand =
					"INSERT INTO [GeoCenters] (Name, Location)" +
					$" VALUES ('{textBox_name.Text}', '{textBox_location.Text}')";
				SqlData_GeoCenters.Insert();
			}
			else
			{
				int editId = Convert.ToInt32(textBox_editId.Text);

				SqlData_GeoCenters.UpdateCommand =
					"UPDATE [GeoCenters]" +
					$" SET Name = '{textBox_name.Text}', Location = '{textBox_location.Text}'" +
					$" WHERE ID = " + editId;
				SqlData_GeoCenters.Update();
			}

			SqlData_GeoCenters.DataBind();
			this.RefreshLocations();
		}

		protected void GridView1_RowDeleting(object sender, GridViewDeleteEventArgs e)
		{
			int id = Convert.ToInt32(GridView1.DataKeys[e.RowIndex].Value.ToString());

			SqlData_GeoCenters.DeleteCommand = $"DELETE FROM [GeoCenters] WHERE ID = {id}";
			SqlData_GeoCenters.Delete();
			SqlData_GeoCenters.DataBind();
			this.RefreshLocations();
		}

		protected void GridView1_RowEditing(object sender, GridViewEditEventArgs e)
		{
			GridView1.EditIndex = e.NewEditIndex;
			SqlData_GeoCenters.DataBind();

			int id = Convert.ToInt32(GridView1.DataKeys[e.NewEditIndex].Value.ToString());
			SqlData_Editor.SelectCommand =
				"SELECT Name, Location" +
				" FROM GeoCenters" +
				" WHERE ID = " + id;
			DataView dv = (DataView)SqlData_Editor.Select(DataSourceSelectArguments.Empty);
			SqlData_Editor.DataBind();

			DataTable dt = dv.ToTable();

			textBox_editId.Text = id.ToString();

			textBox_name.Text = dt.Rows[0]["Name"].ToString();
			textBox_location.Text = dt.Rows[0]["Location"].ToString();
		}

		protected void button_clearEdit_Click(object sender, EventArgs e)
		{
			textBox_editId.Text = string.Empty;
		}

		protected void button_clearAll_Click(object sender, EventArgs e)
		{
			textBox_editId.Text = string.Empty;

			textBox_name.Text = string.Empty;
			textBox_location.Text = string.Empty;
		}

		private void RefreshLocations()
		{
			SqlData_Locations.SelectCommand = "SELECT DISTINCT [Location] FROM [GeoCenters]";
			SqlData_Locations.Select(DataSourceSelectArguments.Empty);
			SqlData_Locations.DataBind();
		}
	}
}