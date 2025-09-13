package sn.isi.gestion_immobiliere.Servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import sn.isi.gestion_immobiliere.Entities.*;

import java.io.IOException;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/contrats")
public class ContratLocationServlet extends BaseServlet {
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = (req.getParameter("action") == null) ? "list" : req.getParameter("action");
        String idStr = req.getParameter("id");

        // Vérifier la session
        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect("login");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            resp.sendRedirect("login");
            return;
        }

        List<ContratLocation> contratLocations;

        try {
            if (action.equals("list")) {
                // CORRECTION: Simplifier la logique selon le rôle
                if ("PROPRIETAIRE".equals(currentUser.getRole())) {
                    System.out.println("=== PROPRIETAIRE ===");
                    System.out.println("Récupération contrats pour propriétaire ID: " + currentUser.getId());
                    contratLocations = contratLocationRepository.getByProprietaire(currentUser.getId());

                } else if ("LOCATAIRE".equals(currentUser.getRole())) {
                    System.out.println("=== LOCATAIRE ===");
                    System.out.println("User connecté ID: " + currentUser.getId());
                    System.out.println("User connecté nom: " + currentUser.getNom() + " " + currentUser.getPrenom());



                    contratLocations = contratLocationRepository.getByLocataireUserId(currentUser.getId());
                    //System.out.println("Contrats trouvés pour User ID " + locataireCorrespondant.getId() + ": " + contratLocations.size());

                } else {
                    // Admin ou autres rôles
                    System.out.println("=== ADMIN ===");
                    contratLocations = contratLocationRepository.getAll();
                }

                System.out.println("Nombre total de contrats trouvés: " + contratLocations.size());

                // Debug: Afficher les détails de chaque contrat
                for (ContratLocation contrat : contratLocations) {
                    System.out.println("Debug Contrat ID: " + contrat.getId());
                    System.out.println("  - Statut: " + contrat.getStatut());
                    System.out.println("  - Dates: " + contrat.getDateDebut() + " -> " + contrat.getDateFin());

                    if (contrat.getUnite() != null) {
                        System.out.println("  - Unité: " + contrat.getUnite().getNumeroUnite());
                        System.out.println("  - Loyer: " + contrat.getUnite().getLoyerMensuel());

                        if (contrat.getUnite().getImmeuble() != null) {
                            System.out.println("  - Immeuble: " + contrat.getUnite().getImmeuble().getNom());

                            if (contrat.getUnite().getImmeuble().getProprietaire() != null) {
                                System.out.println("  - Propriétaire: " +
                                        contrat.getUnite().getImmeuble().getProprietaire().getNom());
                            }
                        }
                    }

                    if (contrat.getLocataire() != null && contrat.getLocataire().getUser() != null) {
                        System.out.println("  - Locataire: " +
                                contrat.getLocataire().getUser().getNom());
                    }
                }

                // Calculer les statistiques
                Map<String, Integer> stats = calculateStats(contratLocations);
                req.setAttribute("stats", stats);

                // Message de bienvenue personnalisé
                String welcomeMessage = getWelcomeMessage(currentUser, contratLocations.size());
                req.setAttribute("welcomeMessage", welcomeMessage);

            } else if (action.equals("view") && idStr != null) {
                int contratId = Integer.parseInt(idStr);
                ContratLocation contrat = contratLocationRepository.get(contratId);

                // Vérifier les droits d'accès
                if (!canAccessContrat(currentUser, contrat)) {
                    req.setAttribute("errorMessage", "Vous n'avez pas accès à ce contrat.");
                    contratLocations = getContratsForUser(currentUser);
                } else {
                    req.setAttribute("contrat", contrat);
                    req.getRequestDispatcher("/views/contrat/contrat_detail.jsp").forward(req, resp);
                    return;
                }

            } else if (action.equals("edit") && idStr != null) {
                int contratId = Integer.parseInt(idStr);
                ContratLocation contrat = contratLocationRepository.get(contratId);

                if (!canModifyContrat(currentUser, contrat)) {
                    req.setAttribute("errorMessage", "Vous n'avez pas les droits pour modifier ce contrat.");
                    contratLocations = getContratsForUser(currentUser);
                } else {
                    req.setAttribute("contrat", contrat);
                    // Charger les listes pour le formulaire
                    req.setAttribute("unites", uniteLocationRepository.getAll());
                    req.setAttribute("locataires", locataireRepository.getAll());
                    req.getRequestDispatcher("/views/contrat/contrat_form.jsp").forward(req, resp);
                    return;
                }

            } else if (action.equals("delete") && idStr != null && "ADMIN".equals(currentUser.getRole())) {
                int contratId = Integer.parseInt(idStr);
                int result = contratLocationRepository.delete(contratId);

                if (result > 0) {
                    req.setAttribute("successMessage", "Contrat supprimé avec succès.");
                } else {
                    req.setAttribute("errorMessage", "Erreur lors de la suppression du contrat.");
                }
                contratLocations = contratLocationRepository.getAll();

            } else {
                // Action par défaut
                contratLocations = getContratsForUser(currentUser);
            }

        } catch (Exception e) {
            System.err.println("Erreur dans ContratLocationServlet: " + e.getMessage());
            e.printStackTrace();
            req.setAttribute("errorMessage", "Une erreur est survenue lors du chargement des contrats: " + e.getMessage());
            contratLocations = List.of(); // Liste vide en cas d'erreur
        }

        // Passer les contrats à la JSP
        req.setAttribute("currentUser", currentUser);
        req.setAttribute("contrats", contratLocations);

        // Debug: Vérifier ce qui est passé à la JSP
        System.out.println("=== DONNEES PASSEES A LA JSP ===");
        System.out.println("Nombre de contrats: " + contratLocations.size());
        System.out.println("Current User: " + currentUser.getNom() + " (" + currentUser.getRole() + ")");

        req.getRequestDispatcher("/views/contrat/contrats_jstl.jsp").forward(req, resp);
    }

    /**
     * Simplifie la récupération des contrats selon le rôle de l'utilisateur
     */
    private List<ContratLocation> getContratsForUser(User user) {
        try {
            if ("PROPRIETAIRE".equals(user.getRole())) {
                return contratLocationRepository.getByProprietaire(user.getId());
            } else if ("LOCATAIRE".equals(user.getRole())) {
                return contratLocationRepository.getByLocataireUserId(user.getId());
            } else {
                return contratLocationRepository.getAll();
            }
        } catch (Exception e) {
            System.err.println("Erreur dans getContratsForUser: " + e.getMessage());
            e.printStackTrace();
            return List.of();
        }
    }
    /**
     * Récupère les contrats selon le rôle de l'utilisateur
     */

    /**
     * Vérifie si l'utilisateur peut accéder à ce contrat
     */
    private boolean canAccessContrat(User user, ContratLocation contrat) {
        if (contrat == null) return false;

        if ("ADMIN".equals(user.getRole())) {
            return true;
        } else if ("PROPRIETAIRE".equals(user.getRole())) {
            return contrat.getUnite() != null &&
                    contrat.getUnite().getImmeuble() != null &&
                    contrat.getUnite().getImmeuble().getProprietaire() != null &&
                    contrat.getUnite().getImmeuble().getProprietaire().getId() == user.getId();
        } else if ("LOCATAIRE".equals(user.getRole())) {
            return contrat.getLocataire() != null &&
                    contrat.getLocataire().getUser() != null &&
                    contrat.getLocataire().getUser().getId() == user.getId();
        }
        return false;
    }

    /**
     * Vérifie si l'utilisateur peut modifier ce contrat
     */
    private boolean canModifyContrat(User user, ContratLocation contrat) {
        if ("ADMIN".equals(user.getRole())) {
            return true;
        } else if ("PROPRIETAIRE".equals(user.getRole())) {
            return canAccessContrat(user, contrat);
        }
        return false; // Les locataires ne peuvent pas modifier les contrats
    }

    /**
     * Calcule les statistiques des contrats
     */
    private Map<String, Integer> calculateStats(List<ContratLocation> contrats) {
        Map<String, Integer> stats = new HashMap<>();
        stats.put("ACTIF", 0);
        stats.put("EXPIRE", 0);
        stats.put("RESILIE", 0);
        stats.put("SUSPENDU", 0);

        LocalDate today = LocalDate.now();

        for (ContratLocation contrat : contrats) {
            String statut = contrat.getStatut();

            // Vérifier si le contrat est expiré
            if ("ACTIF".equals(statut) && contrat.getDateFin() != null && contrat.getDateFin().isBefore(today)) {
                statut = "EXPIRE";
            }

            stats.put(statut, stats.getOrDefault(statut, 0) + 1);
        }

        return stats;
    }

    /**
     * Génère un message de bienvenue personnalisé
     */
    private String getWelcomeMessage(User user, int nombreContrats) {
        if ("LOCATAIRE".equals(user.getRole())) {
            if (nombreContrats == 0) {
                return "Vous n'avez pas encore de contrat de location.";
            } else if (nombreContrats == 1) {
                return "Vous avez 1 contrat de location.";
            } else {
                return "Vous avez " + nombreContrats + " contrats de location.";
            }
        } else if ("PROPRIETAIRE".equals(user.getRole())) {
            if (nombreContrats == 0) {
                return "Aucun contrat actif pour vos propriétés.";
            } else {
                return nombreContrats + " contrat(s) pour vos propriétés.";
            }
        } else {
            return nombreContrats + " contrat(s) au total dans le système.";
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect("login");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            resp.sendRedirect("login");
            return;
        }

        try {
            LocalDate dateDebut = LocalDate.parse(req.getParameter("dateDebut"));
            LocalDate dateFin = LocalDate.parse(req.getParameter("dateFin"));
            Double caution = Double.parseDouble(req.getParameter("caution"));
            String statut = req.getParameter("statut");
            Long uniteId = Long.parseLong(req.getParameter("uniteId"));
            Long locataireId = Long.parseLong(req.getParameter("locataireId"));

            UniteLocation unite = uniteLocationRepository.get(uniteId.intValue());
            Locataire locataire = locataireRepository.get(locataireId.intValue());

            ContratLocation contrat = new ContratLocation();
            contrat.setDateDebut(dateDebut);
            contrat.setDateFin(dateFin);
            contrat.setCaution(caution);
            contrat.setStatut(statut);
            contrat.setUnite(unite);
            contrat.setLocataire(locataire);

            int result = contratLocationRepository.add(contrat);

            if (result > 0) {
                req.getSession().setAttribute("successMessage", "Contrat créé avec succès.");
            } else {
                req.getSession().setAttribute("errorMessage", "Erreur lors de la création du contrat.");
            }

        } catch (Exception e) {
            System.err.println("Erreur lors de la création du contrat: " + e.getMessage());
            e.printStackTrace();
            req.getSession().setAttribute("errorMessage", "Erreur lors de la création du contrat: " + e.getMessage());
        }

        resp.sendRedirect("contrats");
    }
}