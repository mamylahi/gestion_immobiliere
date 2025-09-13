package sn.isi.gestion_immobiliere.Servlet;

import sn.isi.gestion_immobiliere.Utils.SessionManager;
import sn.isi.gestion_immobiliere.Utils.SecurityUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.concurrent.ConcurrentHashMap;

@WebServlet("/admin/sessions")
public class SessionManagementServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Vérifier que l'utilisateur est admin
        if (!SecurityUtils.isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/unauthorized.jsp");
            return;
        }

        // Obtenir toutes les sessions actives
        ConcurrentHashMap<String, SessionManager.SessionInfo> activeSessions =
                SessionManager.getActiveSessions();

        request.setAttribute("activeSessions", activeSessions);
        request.getRequestDispatcher("/admin/sessions.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Vérifier que l'utilisateur est admin
        if (!SecurityUtils.isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/unauthorized.jsp");
            return;
        }

        String action = request.getParameter("action");
        String userId = request.getParameter("userId");

        if ("forceLogout".equals(action) && userId != null) {
            boolean success = SessionManager.forceLogout(userId);
            if (success) {
                request.setAttribute("success", "Utilisateur déconnecté avec succès");
            } else {
                request.setAttribute("error", "Impossible de déconnecter l'utilisateur");
            }
        }

        // Rediriger vers la page de gestion
        response.sendRedirect(request.getContextPath() + "/admin/sessions");
    }
}