package sn.isi.gestion_immobiliere.Utils;

import sn.isi.gestion_immobiliere.Entities.User;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

public class SecurityUtils {

    /**
     * Vérifier si l'utilisateur actuel a le rôle requis
     */
    public static boolean hasRole(HttpServletRequest request, String requiredRole) {
        User currentUser = getCurrentUser(request);
        return currentUser != null && requiredRole.equals(currentUser.getRole());
    }

    /**
     * Vérifier si l'utilisateur actuel est admin
     */
    public static boolean isAdmin(HttpServletRequest request) {
        return hasRole(request, "ADMIN");
    }

    /**
     * Vérifier si l'utilisateur actuel est propriétaire
     */
    public static boolean isProprietaire(HttpServletRequest request) {
        return hasRole(request, "PROPRIETAIRE");
    }

    /**
     * Vérifier si l'utilisateur actuel est locataire
     */
    public static boolean isLocataire(HttpServletRequest request) {
        return hasRole(request, "LOCATAIRE");
    }

    /**
     * Obtenir l'utilisateur actuel depuis la session
     */
    public static User getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            return (User) session.getAttribute("user");
        }
        return null;
    }

    /**
     * Vérifier si l'utilisateur peut accéder à une ressource d'un autre utilisateur
     */
    public static boolean canAccessUserResource(HttpServletRequest request, int resourceUserId) {
        User currentUser = getCurrentUser(request);
        if (currentUser == null) {
            return false;
        }

        // Admin peut tout voir
        if ("ADMIN".equals(currentUser.getRole())) {
            return true;
        }

        // Un utilisateur peut voir ses propres ressources
        return currentUser.getId() == resourceUserId;
    }

    /**
     * Vérifier si l'utilisateur peut modifier une ressource
     */
    public static boolean canModifyResource(HttpServletRequest request, int resourceOwnerId) {
        User currentUser = getCurrentUser(request);
        if (currentUser == null) {
            return false;
        }

        // Admin peut tout modifier
        if ("ADMIN".equals(currentUser.getRole())) {
            return true;
        }

        // Un utilisateur peut modifier ses propres ressources
        return currentUser.getId() == resourceOwnerId;
    }

    /**
     * Générer un token CSRF simple
     */
    public static String generateCSRFToken(HttpServletRequest request) {
        HttpSession session = request.getSession();
        String token = java.util.UUID.randomUUID().toString();
        session.setAttribute("csrfToken", token);
        return token;
    }

    /**
     * Vérifier un token CSRF
     */
    public static boolean validateCSRFToken(HttpServletRequest request, String submittedToken) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }

        String sessionToken = (String) session.getAttribute("csrfToken");
        return sessionToken != null && sessionToken.equals(submittedToken);
    }

    /**
     * Nettoyer les données utilisateur sensibles pour l'affichage
     */
    public static String sanitizeForDisplay(String input) {
        if (input == null) {
            return "";
        }

        return input.replaceAll("<", "&lt;")
                .replaceAll(">", "&gt;")
                .replaceAll("\"", "&quot;")
                .replaceAll("'", "&#x27;")
                .replaceAll("/", "&#x2F;");
    }
}