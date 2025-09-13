package sn.isi.gestion_immobiliere.Listener;

import sn.isi.gestion_immobiliere.Utils.DatabaseManager;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

/**
 * Context Listener pour initialiser l'application au démarrage
 */
@WebListener
public class ApplicationContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("=== DÉMARRAGE DE L'APPLICATION GESTION IMMOBILIÈRE ===");
        long appStartTime = System.currentTimeMillis();

        try {
            // Initialiser le gestionnaire de base de données
            DatabaseManager.getInstance();

            // Stocker l'instance dans le contexte de l'application pour un accès global
            sce.getServletContext().setAttribute("databaseManager", DatabaseManager.getInstance());

            long appDuration = System.currentTimeMillis() - appStartTime;
            System.out.println("=== APPLICATION DÉMARRÉE EN " + appDuration + "ms ===");

        } catch (Exception e) {
            System.err.println("ERREUR CRITIQUE lors du démarrage de l'application: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Impossible de démarrer l'application", e);
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("=== ARRÊT DE L'APPLICATION GESTION IMMOBILIÈRE ===");

        try {
            // Nettoyer les ressources
            DatabaseManager dbManager = (DatabaseManager) sce.getServletContext().getAttribute("databaseManager");
            if (dbManager != null) {
                dbManager.cleanup();
            }

            System.out.println("=== APPLICATION ARRÊTÉE PROPREMENT ===");

        } catch (Exception e) {
            System.err.println("Erreur lors de l'arrêt de l'application: " + e.getMessage());
            e.printStackTrace();
        }
    }
}