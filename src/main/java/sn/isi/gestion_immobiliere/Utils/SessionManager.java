package sn.isi.gestion_immobiliere.Utils;

import sn.isi.gestion_immobiliere.Entities.User;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.time.LocalDateTime;
import java.util.concurrent.ConcurrentHashMap;

public class SessionManager {

    // Stockage des sessions actives
    private static final ConcurrentHashMap<String, SessionInfo> activeSessions = new ConcurrentHashMap<>();

    // Durée de vie de la session (30 minutes)
    private static final int SESSION_TIMEOUT = 30 * 60; // en secondes

    public static class SessionInfo {
        private String userId;
        private String userEmail;
        private String userRole;
        private LocalDateTime lastActivity;
        private String ipAddress;
        private String userAgent;

        // Constructeurs et getters/setters
        public SessionInfo(String userId, String userEmail, String userRole, String ipAddress, String userAgent) {
            this.userId = userId;
            this.userEmail = userEmail;
            this.userRole = userRole;
            this.lastActivity = LocalDateTime.now();
            this.ipAddress = ipAddress;
            this.userAgent = userAgent;
        }

        // Getters et setters...
        public String getUserId() { return userId; }
        public String getUserEmail() { return userEmail; }
        public String getUserRole() { return userRole; }
        public LocalDateTime getLastActivity() { return lastActivity; }
        public String getIpAddress() { return ipAddress; }
        public String getUserAgent() { return userAgent; }

        public void updateLastActivity() {
            this.lastActivity = LocalDateTime.now();
        }

        public boolean isExpired() {
            return lastActivity.isBefore(LocalDateTime.now().minusSeconds(SESSION_TIMEOUT));
        }
    }

    /**
     * Créer une nouvelle session utilisateur
     */
    public static void createSession(HttpServletRequest request, User user) {
        HttpSession session = request.getSession(true);
        session.setAttribute("user", user);
        session.setMaxInactiveInterval(SESSION_TIMEOUT);

        String sessionId = session.getId();
        String ipAddress = getClientIpAddress(request);
        String userAgent = request.getHeader("User-Agent");

        SessionInfo sessionInfo = new SessionInfo(
                String.valueOf(user.getId()),
                user.getEmail(),
                user.getRole(),
                ipAddress,
                userAgent
        );

        activeSessions.put(sessionId, sessionInfo);

        System.out.println("Session créée pour " + user.getEmail() + " (IP: " + ipAddress + ")");
    }

    /**
     * Mettre à jour l'activité de la session
     */
    public static void updateSessionActivity(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            SessionInfo sessionInfo = activeSessions.get(session.getId());
            if (sessionInfo != null) {
                sessionInfo.updateLastActivity();
            }
        }
    }

    /**
     * Détruire une session
     */
    public static void destroySession(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            String sessionId = session.getId();
            SessionInfo sessionInfo = activeSessions.get(sessionId);

            if (sessionInfo != null) {
                System.out.println("Session détruite pour " + sessionInfo.getUserEmail());
                activeSessions.remove(sessionId);
            }

            session.invalidate();
        }
    }

    /**
     * Nettoyer les sessions expirées
     */
    public static void cleanupExpiredSessions() {
        activeSessions.entrySet().removeIf(entry -> {
            if (entry.getValue().isExpired()) {
                System.out.println("Session expirée supprimée: " + entry.getValue().getUserEmail());
                return true;
            }
            return false;
        });
    }

    /**
     * Obtenir toutes les sessions actives (pour admin)
     */
    public static ConcurrentHashMap<String, SessionInfo> getActiveSessions() {
        cleanupExpiredSessions();
        return new ConcurrentHashMap<>(activeSessions);
    }

    /**
     * Forcer la déconnexion d'un utilisateur (pour admin)
     */
    public static boolean forceLogout(String userId) {
        return activeSessions.entrySet().removeIf(entry ->
                entry.getValue().getUserId().equals(userId));
    }

    /**
     * Obtenir l'adresse IP réelle du client
     */
    private static String getClientIpAddress(HttpServletRequest request) {
        String xForwardedFor = request.getHeader("X-Forwarded-For");
        if (xForwardedFor != null && !xForwardedFor.isEmpty()) {
            return xForwardedFor.split(",")[0].trim();
        }

        String xRealIp = request.getHeader("X-Real-IP");
        if (xRealIp != null && !xRealIp.isEmpty()) {
            return xRealIp;
        }

        return request.getRemoteAddr();
    }
}