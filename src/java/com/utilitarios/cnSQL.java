package com.utilitarios;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class cnSQL {

    private static Connection cn;
    private static String driver = null;
    private static String url = null;
    private static String usuario = null;
    private static String contrasena = null;

    public cnSQL() {
       

    }
public static void inicializarParametrosConeccion(){
 try {
            
            //E:\properties
            
            InputStream in = new FileInputStream("E:/properties/sql.properties");
            Properties props = new Properties();
            props.load(in);
            in.close();
            driver = props.getProperty("DRIVER");
            url = props.getProperty("URL");
            usuario = props.getProperty("USUARIO");
            contrasena = props.getProperty("CONTRASENA");
        } catch (FileNotFoundException ex) {
            System.out.println("Error: 1" + ex.getMessage());
        } catch (IOException ex) {
            System.out.println("Error: 2" + ex.getMessage());
        }

}
    public static Connection createConnection() {
        try {
            inicializarParametrosConeccion();
            Class.forName(driver);
            cn = DriverManager.getConnection(url, usuario, contrasena);
            System.out.println("EXITO__  SE CONECTO CON PATRIMONIO");
        } catch (ClassNotFoundException | SQLException objException) {
            System.out.println("ERROR DE CONEXION  : " + objException.getMessage());
        }
        return cn;
    }

    public static Connection getConnection() {
        try {
            if (cn == null || cn.isClosed()) {
                createConnection();
            }
        } catch (SQLException ex) {
            System.out.println("Error: " + ex.getMessage());
        }
        return cn;
    }
}
