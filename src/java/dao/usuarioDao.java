/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao;

import entity.Usuario;
import java.util.ArrayList;
import utilitario.sql;

/**
 *
 * @author JINMI
 */
public class usuarioDao {

    sql conector = new sql();

    public Usuario validar(String user, String contrasena) {
        Usuario usuario = null;
        String[] array = new String[2];
        array[0] = user;
        array[1] = contrasena;
        ArrayList<Object[]> data = conector.execProcedure("SNET.SP_USUARIO_LOGIN", array);
        
        
            for (Object[] d : data) {
                if(!d[0].toString().equals("0")){
                usuario = new Usuario();
                usuario.setIdUsuario(Integer.parseInt(d[0].toString()));
                usuario.setIdPersonal(Integer.parseInt(d[1].toString()));
                usuario.setNombre(d[2].toString());
                usuario.setIdPerfil(d[3].toString());
                }else{
                 usuario = new Usuario();
                 usuario.setIdUsuario(Integer.parseInt(d[0].toString()));
                }
                

            }

       

       
        return usuario;
    }
}
