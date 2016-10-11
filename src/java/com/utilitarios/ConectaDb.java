package com.utilitarios;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConectaDb {

    public ConectaDb() {
    }

    public static Connection getConnection() {
        Connection cn = null;
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

            cn = DriverManager.getConnection("jdbc:sqlserver://JLV-PC:1433;databaseName=EJERCITO_BD", "sa", "123456789");
            if (cn != null) {
                System.out.println("Conexion realizada satisfactoriamente.");
            }

        } catch (ClassNotFoundException | SQLException objException) {
            System.out.println("Error: " + objException.getMessage());
        }
        return cn;
    }

}
