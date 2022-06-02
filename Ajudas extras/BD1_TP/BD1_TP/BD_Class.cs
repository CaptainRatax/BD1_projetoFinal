using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace BD1_TP
{
    public class BD_Class
    {
        public string strc = "Data Source=193.137.7.32;Initial Catalog=BDbEdi;Persist Security Info=True;User ID=diei94;Password=DI@2020";

        public BD_Class()
        {
        }

        public void AdicionarEspaco(string nomeEspaco)
        {
            SqlConnection con = new SqlConnection();
            SqlCommand cmd = new SqlCommand();
            SqlParameter paramNomeEspaco = new SqlParameter();

            con.ConnectionString = strc;
            con.Open();
            cmd.Connection = con;
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "spAdicionarEspaco";

            paramNomeEspaco.ParameterName = "paramNomeEspaco";
            paramNomeEspaco.Direction = ParameterDirection.Input;
            paramNomeEspaco.Value = nomeEspaco;
            cmd.Parameters.Add(paramNomeEspaco);

            cmd.ExecuteNonQuery();
            con.Close();
        }

        public void EditarEspaco(int idEspaco, string nomeEspaco)
        {
            SqlConnection con = new SqlConnection();
            SqlCommand cmd = new SqlCommand();
            SqlParameter paramIdEspaco = new SqlParameter();
            SqlParameter paramNomeEspaco = new SqlParameter();

            con.ConnectionString = strc;
            con.Open();
            cmd.Connection = con;
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "spEditarEspaco";

            paramIdEspaco.ParameterName = "paramIdEspaco";
            paramIdEspaco.Direction = ParameterDirection.Input;
            paramIdEspaco.Value = idEspaco;
            cmd.Parameters.Add(paramIdEspaco);

            paramNomeEspaco.ParameterName = "paramNomeEspaco";
            paramNomeEspaco.Direction = ParameterDirection.Input;
            paramNomeEspaco.Value = nomeEspaco;
            cmd.Parameters.Add(paramNomeEspaco);

            cmd.ExecuteNonQuery();
            con.Close();
        }

        public void RemoverEspaco(int idEspaco)
        {
            SqlConnection con = new SqlConnection();
            SqlCommand cmd = new SqlCommand();
            SqlParameter paramIdEspaco = new SqlParameter();

            con.ConnectionString = strc;
            con.Open();
            cmd.Connection = con;
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "spRemoverEspaco";
            paramIdEspaco.ParameterName = "paramIdEspaco";

            paramIdEspaco.Direction = ParameterDirection.Input;
            paramIdEspaco.Value = idEspaco;
            cmd.Parameters.Add(paramIdEspaco);

            cmd.ExecuteNonQuery();
            con.Close();
        }

        public string BuscarNomeEspaco(int idEspaco)
        {
            string result;
            string query = @"SELECT scdi94.fnBuscarNomeEspaco(@paramIdEspaco);";

            SqlConnection con = new SqlConnection();
            con.ConnectionString = strc;
            SqlCommand cmd = new SqlCommand(query, con);

            SqlParameter paramIdEspaco = new SqlParameter();
            paramIdEspaco.ParameterName = "@paramIdEspaco";
            paramIdEspaco.SqlDbType = SqlDbType.Int;
            paramIdEspaco.Value = idEspaco;
            cmd.Parameters.Add(paramIdEspaco);

            con.Open();

            result = cmd.ExecuteScalar().ToString();

            con.Close();

            return result.ToString();
        }

        public void ListarReportsEntreDatas(int idEspaco, DateTime dataInicio, DateTime dataFim)
        {
            SqlConnection con = new SqlConnection();
            SqlCommand cmd = new SqlCommand();
            SqlParameter paramIdEspaco = new SqlParameter();
            SqlParameter paramDataInicio = new SqlParameter();
            SqlParameter paramDataFim = new SqlParameter();

            con.ConnectionString = strc;
            con.Open();
            cmd.Connection = con;
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "spListarReportsEntreDatas";

            paramIdEspaco.ParameterName = "paramIdEspaco";
            paramIdEspaco.Direction = ParameterDirection.Input;
            paramIdEspaco.Value = idEspaco;
            cmd.Parameters.Add(paramIdEspaco);

            paramDataInicio.ParameterName = "paramDataInicio";
            paramDataInicio.Direction = ParameterDirection.Input;
            //Formato da data em SQL
            paramDataInicio.Value = dataInicio.ToString("yyy-MM-dd HH:mm:ss");
            cmd.Parameters.Add(paramDataInicio);

            paramDataFim.ParameterName = "paramDataFim";
            paramDataFim.Direction = ParameterDirection.Input;
            //Formato da data em SQL
            paramDataFim.Value = dataFim.ToString("yyy-MM-dd HH:mm:ss");
            cmd.Parameters.Add(paramDataFim);

            cmd.ExecuteNonQuery();
            con.Close();
        }

        public void InserirReportParaTeste()
        {
            SqlConnection con = new SqlConnection();
            SqlCommand cmd = new SqlCommand();

            con.ConnectionString = strc;
            con.Open();
            cmd.Connection = con;
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "spInserirReportParaTeste";

            cmd.ExecuteNonQuery();
            con.Close();
        }
    }
}