package sn.isi.gestion_immobiliere.Servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import sn.isi.gestion_immobiliere.Dao.UniteLocationRepository;
import sn.isi.gestion_immobiliere.Dao.ContratLocationRepository;
import sn.isi.gestion_immobiliere.Dao.DemandeLocationRepository;
import sn.isi.gestion_immobiliere.Entities.UniteLocation;
import sn.isi.gestion_immobiliere.Entities.ContratLocation;
import sn.isi.gestion_immobiliere.Entities.DemandeLocation;
import sn.isi.gestion_immobiliere.Entities.User;

import java.io.IOException;
import java.util.List;

@WebServlet("/locataireIndex")
public class DashboardLocataireServlet extends BaseServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("auth?action=login");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect("auth?action=login");
            return;
        }

        // Vérifier que c'est bien un locataire
        if (!"LOCATAIRE".equals(currentUser.getRole())) {
            response.sendRedirect("auth?action=login");
            return;
        }

        try {
            System.out.println("=== CHARGEMENT DASHBOARD LOCATAIRE ===");
            System.out.println("User: " + currentUser.getNom() + " " + currentUser.getPrenom());

            // 1. Charger TOUTES les unités disponibles (pour la recherche de logement)
            List<UniteLocation> unites = uniteLocationRepository.getAll();
            System.out.println("Unités chargées: " + unites.size());

            // 2. Charger les contrats du locataire
            List<ContratLocation> mesContrats = contratLocationRepository.getByLocataireUserId(currentUser.getId());
            System.out.println("Contrats du locataire: " + mesContrats.size());

            // 3. Charger les demandes du locataire (utiliser l'ID User directement)
            List<DemandeLocation> mesDemandes = demandeLocationRepository.getByLocataire(currentUser.getId());
            System.out.println("Demandes du locataire: " + mesDemandes.size());

            // Debug des demandes
            for (DemandeLocation demande : mesDemandes) {
                System.out.println("  - Demande ID: " + demande.getId() +
                        ", Statut: " + demande.getStatus() +
                        ", Unité: " + (demande.getUniteLocation() != null ? demande.getUniteLocation().getNumeroUnite() : "null"));
            }

            // 4. Calculer quelques statistiques
            long demandesEnAttente = mesDemandes.stream()
                    .filter(d -> "EN_ATTENTE".equals(d.getStatus()))
                    .count();

            long contratsActifs = mesContrats.stream()
                    .filter(c -> "ACTIF".equals(c.getStatut()))
                    .count();

            // 5. Passer les données à la JSP
            request.setAttribute("unite", unites); // Pour la recherche de logement
            request.setAttribute("mesContrats", mesContrats);
            request.setAttribute("mesDemandes", mesDemandes);
            request.setAttribute("demandesEnAttente", demandesEnAttente);
            request.setAttribute("contratsActifs", contratsActifs);
            request.setAttribute("nombreUnites", unites.size());

            System.out.println("=== DONNÉES ENVOYÉES À LA JSP ===");
            System.out.println("- Unités: " + unites.size());
            System.out.println("- Contrats: " + mesContrats.size());
            System.out.println("- Demandes: " + mesDemandes.size());
            System.out.println("- Demandes en attente: " + demandesEnAttente);
            System.out.println("- Contrats actifs: " + contratsActifs);

            // Rediriger vers la page dashboard locataire
            request.getRequestDispatcher("dashboard/locataireIndex_jstl.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Erreur dans DashboardLocataireServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Une erreur s'est produite lors du chargement du dashboard : " + e.getMessage());
            request.getRequestDispatcher("views/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Rediriger vers GET pour éviter les resoumissions
        doGet(request, response);
    }
}