// 1. Listener pour nettoyer les sessions automatiquement
package sn.isi.gestion_immobiliere.Listener;

import sn.isi.gestion_immobiliere.Utils.SessionManager;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

@WebListener
public class SessionCleanupListener implements ServletContextListener {

    private ScheduledExecutorService scheduler;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("=== INITIALISATION DU SYSTÈME DE SÉCURITÉ ===");

        // Créer un scheduler pour nettoyer les sessions expirées
        scheduler = Executors.newScheduledThreadPool(1);

        // Nettoyer les sessions expirées toutes les 10 minutes
        scheduler.scheduleAtFixedRate(() -> {
            try {
                System.out.println("Nettoyage automatique des sessions expirées...");
                SessionManager.cleanupExpiredSessions();
            } catch (Exception e) {
                System.err.println("Erreur lors du nettoyage des sessions: " + e.getMessage());
            }
        }, 10, 10, TimeUnit.MINUTES);

        System.out.println("Nettoyeur de sessions démarré (intervalle: 10 minutes)");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("=== ARRÊT DU SYSTÈME DE SÉCURITÉ ===");

        if (scheduler != null && !scheduler.isShutdown()) {
            scheduler.shutdown();
            try {
                if (!scheduler.awaitTermination(5, TimeUnit.SECONDS)) {
                    scheduler.shutdownNow();
                }
            } catch (InterruptedException e) {
                scheduler.shutdownNow();
            }
        }

        System.out.println("Nettoyeur de sessions arrêté");
    }
}