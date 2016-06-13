package utilitario;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class sql {

    private ConectaDb db = null;

    public sql() {
        db = new ConectaDb();
    }

    //retorna lo que se haga en los SELECTS
    public List<Object[]> consulta(String sql) {
        List<Object[]> lista = null;
        Connection cn = db.getConnection();
        if (cn != null) {
            try {
                Statement st = cn.createStatement();
                ResultSet rs = st.executeQuery(sql);
                ResultSetMetaData rm = rs.getMetaData();
                int numcol = rm.getColumnCount();

                lista = new ArrayList<Object[]>();
                //Obtiene cabeceras de las tablas
                String[] cabecera = new String[numcol];
                for (int i = 0; i < numcol; i++) {
                    cabecera[i] = rm.getColumnLabel(1 + i);
                }
                //lista.add(cabecera);
                //obtiene los datos de la tabla
                while (rs.next()) {
                    Object[] fila = new Object[numcol];
                    for (int i = 0; i < numcol; i++) {
                        fila[i] = rs.getObject(1 + i);
                    }
                    lista.add(fila);
                }
                cn.close();

            } catch (SQLException e) {
            }
        }
        return lista;
    }

    //ejecuta un STORE_PROCEDURE
    public ArrayList<Object[]> execProcedure(String sp, String[] parametros) {
        ArrayList<Object[]> array = new ArrayList<Object[]>();
        Connection cn = db.getConnection();
        if (cn != null) {
            try {
                Statement st = cn.createStatement();
                String sql = "EXEC " + sp + " ";
                for (int i = 0; i < parametros.length; i++) {
                    sql = sql + "'" + parametros[i].replace("'","''") + "',";
                }
                sql = sql.substring(0, sql.length() - 1);
                ResultSet rs = st.executeQuery(sql);
                ResultSetMetaData rm = rs.getMetaData();
                int numcol = rm.getColumnCount();
                while (rs.next()) {
                    Object[] fila = new Object[numcol];
                    for (int i = 0; i < numcol; i++) {
                        fila[i] = rs.getObject(1 + i);
                    }
                    array.add(fila);
                }
                cn.close();

            } catch (SQLException e) {

            }
        }
        return array;
    }

    //ejecuta las sentencias INSERT, UPDATE y DELETE
    public String ejecuta(String sql) {
        String msg = null;
        Connection cn = db.getConnection();

        if (cn != null) {
            try {
                Statement st = cn.createStatement();
                int ct = st.executeUpdate(sql);

                if (ct == 0) {
                    msg = "o filas afectadas";
                }
                cn.close();

            } catch (SQLException e) {
                msg = e.getMessage();
            }
        } else {
            msg = "No hay conexion";
        }
        return msg;
    }

    //Accesorios para obtener filas y columnas de las consultas realizadas
    public Object[] getFila(String sql) {
        Object[] fila = null;
        List<Object[]> lista = consulta(sql);

        if ((lista != null) && (lista.size() > 1)) {
            fila = (Object[]) lista.get(1);
        }
        return fila;
    }

    public Object[] getColumna(String sql) {
        Object[] columna = null;
        List<Object[]> lista = consulta(sql);

        if ((lista != null) && (lista.size() > 1)) {
            int ctos = lista.size();
            columna = new Object[ctos - 1];

            for (int i = 1; i < ctos; i++) {
                columna[i - 1] = ((Object[]) lista.get(i))[0];
            }
        }
        return columna;
    }

    //obtener dato de la fila
    public Object getCampo(String sql) {
        Object campo = null;
        Object[] fila = getFila(sql);

        if (fila != null) {
            campo = fila[0];
        }

        return campo;
    }

    //Consulta con limite de filas  por pagina    
    public List<Object[]> consulta(String sql, long numpag, long ctasfils) {

        sql += " LIMIT " + (numpag * ctasfils) + "," + ctasfils;

        List<Object[]> list = consulta(sql);
        return list;
    }

    public long ctasFilas(String sql) {
        long ctasfils = 0L;

        sql = sql.toUpperCase();
        int idx = sql.indexOf(" FROM ");
        String aux = sql.substring(idx);
        String sql2 = "SELECT COUNT(*)" + aux;

        Object campo = getCampo(sql2);
        if (campo != null) {
            ctasfils = Long.valueOf(campo.toString()).longValue();
        }
        return ctasfils;
    }

    public ArrayList<Object[]> execTransProcedure(String sp, String[] parametros, Connection cn){
        ArrayList<Object[]> array = new ArrayList<Object[]>();        
        if (cn != null) {
            try {
                Statement st = cn.createStatement();
                String sql = "EXEC " + sp + " ";
                for (int i = 0; i < parametros.length; i++) {
                    sql = sql + "'" + parametros[i] + "',";
                }
                sql = sql.substring(0, sql.length() - 1);
                System.out.println(sql);
                ResultSet rs = st.executeQuery(sql);
                ResultSetMetaData rm = rs.getMetaData();
                int numcol = rm.getColumnCount();
                while (rs.next()) {
                    Object[] fila = new Object[numcol];
                    for (int i = 0; i < numcol; i++) {
                        fila[i] = rs.getObject(1 + i);
                    }
                    array.add(fila);
                }
                //cn.close();

            } catch (SQLException e) {
                System.out.println("ERROR EN EXECTRANSPROCEDURE" + e);
            }
        }
        return array;
    }

}
