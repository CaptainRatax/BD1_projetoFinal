using System;
using System.Data;
using System.Security.Cryptography;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ProjetoBD.Pages
{
	public partial class Users : Page
	{
		protected void Page_Load(object sender, EventArgs e)
		{

		}

		protected void button_filterName_Click(object sender, EventArgs e)
		{
			SqlData_Users.SelectCommand =
			"SELECT Users.ID, [NIF], Users.Name, [Email], [PhoneN], [Password], Roles.Name as 'Role', Users.IsActive"
			+ " FROM [Users]"
			+ " INNER JOIN Roles ON Roles.ID = Users.RoleID"
			+ $" WHERE Users.Name LIKE '%{textBox_name.Text}%'";
			SqlData_Users.Select(DataSourceSelectArguments.Empty);
			SqlData_Users.DataBind();
		}

		protected void button_filterRole_Click(object sender, EventArgs e)
		{
			SqlData_Users.SelectCommand =
			"SELECT Users.ID, [NIF], Users.Name, [Email], [PhoneN], [Password], Roles.Name as 'Role', Users.IsActive"
			+ " FROM [Users]"
			+ " INNER JOIN Roles ON Roles.ID = Users.RoleID"
			+ $" WHERE Users.RoleID = '{listBox_role.SelectedValue}'";
			SqlData_Users.Select(DataSourceSelectArguments.Empty);
			SqlData_Users.DataBind();
		}

		protected void button_clearFilters_Click(object sender, EventArgs e)
		{
			textBox_name.Text = string.Empty;
			listBox_role.SelectedIndex = 0;
			SqlData_Users.SelectCommand =
				"SELECT Users.ID, [NIF], Users.Name, [Email], [PhoneN], [Password], Roles.Name as 'Role', Users.IsActive"
				+ " FROM [Users]"
				+ " INNER JOIN Roles ON Roles.ID = Users.RoleID"
				+ " WHERE 1 = 1";
			SqlData_Users.Select(DataSourceSelectArguments.Empty);
			SqlData_Users.DataBind();
		}

		protected void button_save_Click(object sender, EventArgs e)
		{
			if (string.IsNullOrEmpty(textBox_nif.Text) || string.IsNullOrEmpty(textBox_editName.Text) || string.IsNullOrEmpty(textBox_email.Text) || string.IsNullOrEmpty(textBox_phoneNumber.Text) || string.IsNullOrEmpty(textBox_password.Text))
			{
				return;
			}

			if (string.IsNullOrEmpty(textBox_editId.Text))
			{
				SqlData_Users.InsertCommand =
					"INSERT INTO [Users] (NIF, Name, Email, PhoneN, Password, IsFirstLogin, RoleID, IsActive)" +
					$" VALUES ('{textBox_nif.Text}', '{textBox_editName.Text}', '{textBox_email.Text}', '{textBox_phoneNumber.Text}', '{textBox_password.Text}', '{Convert.ToInt32(checkBox_isFirstLogin.Checked)}','{listBox_editRole.SelectedValue}','{Convert.ToInt32(checkBox_isActive.Checked)}')";
				SqlData_Users.Insert();
			}
			else
			{
				int editId = Convert.ToInt32(textBox_editId.Text);

				string password = string.Empty;
				if (!string.IsNullOrEmpty(textBox_password.Text))
				{
					password = $" Password = '{EncryptPassword(textBox_password.Text)}',";
				}

				SqlData_Users.UpdateCommand =
					"UPDATE [Users]" +
					$" SET NIF = '{textBox_nif.Text}', Name = '{textBox_editName.Text}', Email = '{textBox_email.Text}', PhoneN = '{textBox_phoneNumber.Text}',{password} IsFirstLogin = '{Convert.ToInt32(checkBox_isFirstLogin.Checked)}', RoleID = '{listBox_editRole.SelectedValue}', IsActive = '{Convert.ToInt32(checkBox_isActive.Checked)}'" +
					$" WHERE ID = " + editId;
				SqlData_Users.Update();
			}

			SqlData_Users.DataBind();
		}

		protected void GridView1_RowDeleting(object sender, GridViewDeleteEventArgs e)
		{
			int id = Convert.ToInt32(GridView1.DataKeys[e.RowIndex].Value.ToString());

			SqlData_Users.DeleteCommand = $"UPDATE [Users] SET IsActive = 0 WHERE ID = {id}";
			SqlData_Users.Delete();
			SqlData_Users.DataBind();
		}

		protected void GridView1_RowEditing(object sender, GridViewEditEventArgs e)
		{
			GridView1.EditIndex = e.NewEditIndex;
			SqlData_Users.DataBind();

			int id = Convert.ToInt32(GridView1.DataKeys[e.NewEditIndex].Value.ToString());
			SqlData_Editor.SelectCommand =
				"SELECT NIF, Name, Email, PhoneN, IsFirstLogin, RoleID, IsActive" +
				" FROM Users" +
				" WHERE ID = " + id;
			DataView dv = (DataView)SqlData_Editor.Select(DataSourceSelectArguments.Empty);
			SqlData_Editor.DataBind();

			DataTable dt = dv.ToTable();

			textBox_editId.Text = id.ToString();

			textBox_nif.Text = dt.Rows[0]["NIF"].ToString();
			textBox_editName.Text = dt.Rows[0]["Name"].ToString();
			textBox_email.Text = dt.Rows[0]["Email"].ToString();
			textBox_phoneNumber.Text = dt.Rows[0]["PhoneN"].ToString();
			checkBox_isFirstLogin.Checked = Convert.ToBoolean(dt.Rows[0]["IsFirstLogin"]);
			try
			{
				listBox_editRole.SelectedValue = dt.Rows[0]["RoleID"].ToString();
			}
			catch
			{
				listBox_editRole.SelectedIndex = 0;
			}
			checkBox_isActive.Checked = Convert.ToBoolean(dt.Rows[0]["IsActive"]);
		}

		protected void button_clearEdit_Click(object sender, EventArgs e)
		{
			textBox_editId.Text = string.Empty;
		}

		protected void button_clearAll_Click(object sender, EventArgs e)
		{
			textBox_editId.Text = string.Empty;

			textBox_nif.Text = string.Empty;
			textBox_editName.Text = string.Empty;
			textBox_email.Text = string.Empty;
			textBox_phoneNumber.Text = string.Empty;
			checkBox_isFirstLogin.Checked = false;
			listBox_editRole.SelectedIndex = 0;
			checkBox_isActive.Checked = false;
		}

		private static string EncryptPassword(string input)
		{
			byte[] bytes = Encoding.UTF8.GetBytes(input);
			using (SHA512 hash = SHA512.Create())
			{
				byte[] hashedInputBytes = hash.ComputeHash(bytes);

				StringBuilder hashedInputStringBuilder = new StringBuilder(128);
				foreach (byte b in hashedInputBytes)
				{
					hashedInputStringBuilder.Append(b.ToString("X2"));
				}
				return hashedInputStringBuilder.ToString().ToLower();
			}
		}
	}
}