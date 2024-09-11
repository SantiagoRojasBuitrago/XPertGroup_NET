using System;
using System.Data.SqlClient;
using System.IO;
using System.Xml;

class Program
{
    static void Main(string[] args)
    {
        XmlDocument doc = new XmlDocument();
        doc.Load("config.xml");

        XmlNode connectionStringNode = doc.SelectSingleNode("//connectionStrings/add");
        XmlNode logFilePathNode = doc.SelectSingleNode("//logFilePath");

        if (connectionStringNode == null || logFilePathNode == null)
        {
            Console.WriteLine("Error: La configuración está incompleta.");
            return;
        }

        string? connectionString = connectionStringNode.Attributes["connectionString"]?.Value;
        string? logFilePath = logFilePathNode.InnerText;

        if (string.IsNullOrEmpty(connectionString) || string.IsNullOrEmpty(logFilePath))
        {
            Console.WriteLine("Error: La cadena de conexión o la ruta del archivo de log están vacías.");
            return;
        }

        try
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                using (SqlCommand cmd = new SqlCommand("ObtenerUsuariosRecientes", conn))
                {
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        using (StreamWriter writer = new StreamWriter(logFilePath, true))
                        {
                            while (reader.Read())
                            {
                                writer.WriteLine($"ID: {reader["Id"]}, Nombre: {reader["Nombre"]}, Apellido: {reader["Apellido"]}, Edad: {reader["Edad"]}, Correo: {reader["Correo"]}, Hobbies: {reader["Hobbies"]}, Activo: {reader["Activo"]}, FechaCreacion: {reader["FechaCreacion"]}");
                            }
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error al ejecutar el procedimiento almacenado: {ex.Message}");
        }
    }
}
