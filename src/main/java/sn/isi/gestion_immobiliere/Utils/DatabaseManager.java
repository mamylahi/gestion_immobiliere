package sn.isi.gestion_immobiliere.Utils;

import sn.isi.gestion_immobiliere.Dao.*;

/**
 * Gestionnaire centralisé pour tous les repositories
 * Pattern Singleton pour éviter les multiples initialisations
 */
public class DatabaseManager {

    private static DatabaseManager instance;

    // Repositories centralisés
    private UserRepository userRepository;
    private ImmeubleRepository immeubleRepository;
    private UniteLocationRepository uniteLocationRepository;
    private ContratLocationRepository contratLocationRepository;
    private DemandeLocationRepository demandeLocationRepository;
    private PaiementRepository paiementRepository;
    private LocataireRepository locataireRepository;

    // Constructeur privé pour Singleton
    private DatabaseManager() {
        initializeRepositories();
    }

    /**
     * Méthode pour obtenir l'instance unique
     */
    public static synchronized DatabaseManager getInstance() {
        if (instance == null) {
            instance = new DatabaseManager();
        }
        return instance;
    }

    /**
     * Initialise tous les repositories une seule fois
     */
    private void initializeRepositories() {
        System.out.println("=== INITIALISATION DES REPOSITORIES ===");
        long startTime = System.currentTimeMillis();

        try {
            userRepository = new UserRepository();
            System.out.println("✓ UserRepository initialisé");

            immeubleRepository = new ImmeubleRepository();
            System.out.println("✓ ImmeubleRepository initialisé");

            uniteLocationRepository = new UniteLocationRepository();
            System.out.println("✓ UniteLocationRepository initialisé");

            contratLocationRepository = new ContratLocationRepository();
            System.out.println("✓ ContratLocationRepository initialisé");

            demandeLocationRepository = new DemandeLocationRepository();
            System.out.println("✓ DemandeLocationRepository initialisé");

            paiementRepository = new PaiementRepository();
            System.out.println("✓ PaiementRepository initialisé");

            locataireRepository = new LocataireRepository();
            System.out.println("✓ LocataireRepository initialisé");

            long duration = System.currentTimeMillis() - startTime;
            System.out.println("=== REPOSITORIES INITIALISÉS EN " + duration + "ms ===");

        } catch (Exception e) {
            System.err.println("ERREUR lors de l'initialisation des repositories: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Impossible d'initialiser la base de données", e);
        }
    }

    // Getters pour tous les repositories
    public UserRepository getUserRepository() {
        return userRepository;
    }

    public ImmeubleRepository getImmeubleRepository() {
        return immeubleRepository;
    }

    public UniteLocationRepository getUniteLocationRepository() {
        return uniteLocationRepository;
    }

    public ContratLocationRepository getContratLocationRepository() {
        return contratLocationRepository;
    }

    public DemandeLocationRepository getDemandeLocationRepository() {
        return demandeLocationRepository;
    }

    public PaiementRepository getPaiementRepository() {
        return paiementRepository;
    }

    public LocataireRepository getLocataireRepository() {
        return locataireRepository;
    }

    /**
     * Méthode pour nettoyer les ressources si nécessaire
     */
    public void cleanup() {
        System.out.println("=== NETTOYAGE DES RESSOURCES DATABASE ===");
        // Ajouter ici le nettoyage des connexions si nécessaire
        instance = null;
    }
}