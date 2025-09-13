package sn.isi.gestion_immobiliere.Servlet;

import sn.isi.gestion_immobiliere.Utils.DatabaseManager;
import sn.isi.gestion_immobiliere.Dao.*;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;

/**
 * Classe de base pour tous les servlets avec accès optimisé aux repositories
 */
public abstract class BaseServlet extends HttpServlet {

    protected DatabaseManager dbManager;

    // Repositories disponibles pour tous les servlets enfants
    protected UserRepository userRepository;
    protected ImmeubleRepository immeubleRepository;
    protected UniteLocationRepository uniteLocationRepository;
    protected ContratLocationRepository contratLocationRepository;
    protected DemandeLocationRepository demandeLocationRepository;
    protected PaiementRepository paiementRepository;
    protected LocataireRepository locataireRepository;

    @Override
    public void init() throws ServletException {
        super.init();

        // Récupérer le DatabaseManager depuis le contexte ou créer une instance
        this.dbManager = DatabaseManager.getInstance();

        // Initialiser tous les repositories
        this.userRepository = dbManager.getUserRepository();
        this.immeubleRepository = dbManager.getImmeubleRepository();
        this.uniteLocationRepository = dbManager.getUniteLocationRepository();
        this.contratLocationRepository = dbManager.getContratLocationRepository();
        this.demandeLocationRepository = dbManager.getDemandeLocationRepository();
        this.paiementRepository = dbManager.getPaiementRepository();
        this.locataireRepository = dbManager.getLocataireRepository();

        System.out.println("✓ " + this.getClass().getSimpleName() + " initialisé avec DatabaseManager");
    }
}
