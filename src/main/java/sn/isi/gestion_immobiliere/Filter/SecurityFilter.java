package sn.isi.gestion_immobiliere.Filter;

import sn.isi.gestion_immobiliere.Entities.User;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

@WebFilter("/*")
public class SecurityFilter implements Filter {

    // Pages publiques (accessibles sans connexion)
    private static final List<String> PUBLIC_URLS = Arrays.asList(
            "/login", "/register", "/auth", "/", "/index.jsp", "/login.jsp", "/register.jsp",
            "/css/", "/js/", "/images/", "/favicon.ico", "/static/"
    );

    // URLs d'administration (ADMIN uniquement)
    private static final List<String> ADMIN_URLS = Arrays.asList(
            "/admin", "/user", "/dashboard/admin"
    );

    // URLs de propriétaire (PROPRIETAIRE uniquement)
    private static final List<String> PROPRIETAIRE_URLS = Arrays.asList(
            "/proprietaire", "/dashboard/proprietaire", "/demandeLocation"
    );

    // URLs de locataire (LOCATAIRE uniquement)
    private static final List<String> LOCATAIRE_URLS = Arrays.asList(
            "/locataire", "/locataireIndex", "/unite"
    );

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("=== INITIALISATION DU FILTRE DE SÉCURITÉ ===");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = requestURI.substring(contextPath.length());

        System.out.println("=== SECURITY FILTER ===");
        System.out.println("Path demandé: " + path);
        System.out.println("Session: " + (session != null ? "Existe" : "Null"));

        // Vérifier si c'est une page publique
        if (isPublicResource(path)) {
            System.out.println("Ressource publique - accès autorisé");
            chain.doFilter(request, response);
            return;
        }

        // Vérifier si l'utilisateur est connecté
        User currentUser = null;
        if (session != null) {
            currentUser = (User) session.getAttribute("user");
        }

        if (currentUser == null) {
            System.out.println("Utilisateur non connecté - redirection vers login");
            httpResponse.sendRedirect(contextPath + "/login.jsp");
            return;
        }

        System.out.println("Utilisateur connecté: " + currentUser.getEmail() + " (" + currentUser.getRole() + ")");

        // Vérifier les autorisations par rôle
        if (!hasPermission(path, currentUser.getRole())) {
            System.out.println("Accès refusé pour le rôle " + currentUser.getRole() + " sur " + path);
            httpResponse.sendRedirect(contextPath + "/unauthorized.jsp");
            return;
        }

        System.out.println("Accès autorisé - continuation");
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        System.out.println("=== DESTRUCTION DU FILTRE DE SÉCURITÉ ===");
    }

    private boolean isPublicResource(String path) {
        // Pages complètement publiques
        for (String publicUrl : PUBLIC_URLS) {
            if (path.equals(publicUrl) || path.startsWith(publicUrl)) {
                return true;
            }
        }

        // Ressources statiques
        if (path.matches(".*\\.(css|js|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf)$")) {
            return true;
        }

        return false;
    }

    private boolean hasPermission(String path, String userRole) {
        // Admin a accès à tout
        if ("ADMIN".equals(userRole)) {
            return true;
        }

        // Vérifier les restrictions spécifiques
        if (isRestrictedToAdmin(path) && !"ADMIN".equals(userRole)) {
            return false;
        }

        if (isRestrictedToProprietaire(path) && !"PROPRIETAIRE".equals(userRole)) {
            return false;
        }

        if (isRestrictedToLocataire(path) && !"LOCATAIRE".equals(userRole)) {
            return false;
        }

        return true;
    }

    private boolean isRestrictedToAdmin(String path) {
        return ADMIN_URLS.stream().anyMatch(path::startsWith);
    }

    private boolean isRestrictedToProprietaire(String path) {
        return PROPRIETAIRE_URLS.stream().anyMatch(path::startsWith);
    }

    private boolean isRestrictedToLocataire(String path) {
        return LOCATAIRE_URLS.stream().anyMatch(path::startsWith);
    }
}