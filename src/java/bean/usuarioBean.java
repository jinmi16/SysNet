/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package bean;

import dao.usuarioDao;
import entity.Usuario;
import java.io.IOException;
import javax.faces.application.FacesMessage;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.ViewScoped;
import javax.faces.context.FacesContext;
import javax.swing.JOptionPane;

@ManagedBean
@ViewScoped
public class usuarioBean {

    Usuario usuario = new Usuario();
    usuarioDao usuarioDao = new usuarioDao();

    public usuarioBean() {
    }

    public Usuario getUsuario() {
        return usuario;
    }

    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }

    public void loginUsuario() throws IOException {
        usuario = usuarioDao.validar(usuario.getUsuario(), usuario.getContrasena());

        if (usuario.getIdUsuario() != 0) {

            //personal = personalDao.buscarEntidad(usuario.getID_PERSONAL_BIBLIOTECA());
            FacesContext.getCurrentInstance().getExternalContext().getSessionMap().put("UsuarioIdUsuario", usuario.getIdPersonal());
            FacesContext.getCurrentInstance().getExternalContext().getSessionMap().put("UsuarioIdPersonal", usuario.getIdPersonal());
            FacesContext.getCurrentInstance().getExternalContext().getSessionMap().put("UsuarioIdPerfil", usuario.getIdPerfil());
            FacesContext.getCurrentInstance().getExternalContext().getSessionMap().put("personalNombre", usuario.getNombre());
            FacesContext.getCurrentInstance().addMessage("gMensaje", new FacesMessage(FacesMessage.SEVERITY_INFO, "Bienvenido", usuario.getNombre()));
            FacesContext.getCurrentInstance().getExternalContext().getFlash().setKeepMessages(true);
            FacesContext.getCurrentInstance().getExternalContext().redirect("inicio.xhtml");
        } else {
            FacesContext.getCurrentInstance().addMessage("gMensaje", new FacesMessage(FacesMessage.SEVERITY_ERROR, "Error", "Usuario y/o Contraseña incorrecta."));
            FacesContext.getCurrentInstance().getExternalContext().getFlash().setKeepMessages(true);
            FacesContext.getCurrentInstance().getExternalContext().redirect("accesoDenegado.xhtml");

        }

    }

}
