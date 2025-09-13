package sn.isi.gestion_immobiliere.Servlet;

import sn.isi.gestion_immobiliere.Dao.*;
import sn.isi.gestion_immobiliere.Entities.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/demandeLocation")
public class DemandeLocationServlet extends BaseServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";

        System.out.println("=== DEBUG DEMANDE SERVLET ===");
        System.out.println("Action demandée: " + action);

        HttpSession session = req.getSession(false);
        if (session == null) {
            System.out.println("Aucune session trouvée, redirection vers login");
            resp.sendRedirect("login");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            System.out.println("Aucun utilisateur en session, redirection vers login");
            resp.sendRedirect("login");
            return;
        }

        System.out.println("Utilisateur connecté: " + currentUser.getNom() + " (Role: " + currentUser.getRole() + ", ID: " + currentUser.getId() + ")");

        List<DemandeLocation> demandeLocations = new ArrayList<>();

        try {
            if ("list".equals(action)) {
                if ("PROPRIETAIRE".equals(currentUser.getRole())) {
                    System.out.println("Recherche des demandes pour le propriétaire ID: " + currentUser.getId());
                    demandeLocations = demandeLocationRepository.getByProprietaire(currentUser.getId());
                } else if ("LOCATAIRE".equals(currentUser.getRole())) {
                    System.out.println("Recherche des demandes pour le locataire User ID: " + currentUser.getId());

                    // Trouver le locataire correspondant à l'utilisateur connecté
                    List<Locataire> locataireList = locataireRepository.getAll();
                    Locataire locataireCorrespondant = null;
                    for (Locataire locataire : locataireList) {
                        if (locataire.getUser() != null && locataire.getIdUser() == currentUser.getId()) {
                            locataireCorrespondant = locataire;
                            break;
                        }
                    }

                    if (locataireCorrespondant != null) {
                        demandeLocations = demandeLocationRepository.getByLocataire(locataireCorrespondant.getId());
                    }

                    System.out.println("Demandes trouvées pour le locataire: " + demandeLocations.size());
                } else {
                    System.out.println("Recherche de toutes les demandes (Admin)");
                    demandeLocations = demandeLocationRepository.getAll();
                }

                System.out.println("Nombre de demandes trouvées: " + demandeLocations.size());

                // Debug détaillé des demandes
                for (int i = 0; i < demandeLocations.size(); i++) {
                    DemandeLocation d = demandeLocations.get(i);
                    System.out.println("Demande " + (i+1) + ":");
                    System.out.println("  - ID: " + d.getId());
                    System.out.println("  - Status: " + d.getStatus());
                    System.out.println("  - Locataire: " + (d.getLocataire() != null ?
                            d.getLocataire().getUser().getNom() : "NULL"));
                    System.out.println("  - Unité: " + (d.getUniteLocation() != null ?
                            d.getUniteLocation().getNumeroUnite() : "NULL"));
                    if (d.getUniteLocation() != null && d.getUniteLocation().getImmeuble() != null) {
                        System.out.println("  - Immeuble: " + d.getUniteLocation().getImmeuble().getNom());
                        if (d.getUniteLocation().getImmeuble().getProprietaire() != null) {
                            System.out.println("  - Propriétaire: " +
                                    d.getUniteLocation().getImmeuble().getProprietaire().getNom());
                        }
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("ERREUR dans doGet(): " + e.getMessage());
            e.printStackTrace();
            demandeLocations = new ArrayList<>();
            req.setAttribute("errorMessage", "Erreur lors de la récupération des demandes: " + e.getMessage());
        }

        req.setAttribute("demandeLocations", demandeLocations);
        System.out.println("Transfert vers JSP avec " + demandeLocations.size() + " demandes");
        System.out.println("==============================");

        req.getRequestDispatcher("/views/demande/demande_jstl.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);

        if (session == null) {
            resp.sendRedirect("auth?action=login");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            resp.sendRedirect("auth?action=login");
            return;
        }

        try {
            String action = req.getParameter("action");
            System.out.println("=== POST ACTION: " + action + " ===");

            if ("update".equals(action)) {
                handleUpdateDemande(req, currentUser);
            } else if ("add".equals(action)) {
                handleAddDemande(req, currentUser);
            }

        } catch (Exception e) {
            System.err.println("Erreur dans doPost(): " + e.getMessage());
            e.printStackTrace();
            req.getSession().setAttribute("errorMessage", "Une erreur s'est produite : " + e.getMessage());
        }

        resp.sendRedirect("demandeLocation");
    }

    private void handleUpdateDemande(HttpServletRequest req, User currentUser) {
        String demandeIdStr = req.getParameter("demandeId");
        String newStatus = req.getParameter("status");

        System.out.println("=== DEBUT HANDLE UPDATE DEMANDE ===");
        System.out.println("Demande ID: " + demandeIdStr);
        System.out.println("Nouveau statut reçu: " + newStatus);

        if (demandeIdStr != null && newStatus != null) {
            try {
                int demandeId = Integer.parseInt(demandeIdStr);
                DemandeLocation demande = demandeLocationRepository.get(demandeId);

                if (demande != null) {
                    boolean canUpdate = false;

                    if ("ADMIN".equals(currentUser.getRole())) {
                        canUpdate = true;
                    } else if ("PROPRIETAIRE".equals(currentUser.getRole())) {
                        if (demande.getUniteLocation() != null &&
                                demande.getUniteLocation().getImmeuble() != null &&
                                demande.getUniteLocation().getImmeuble().getProprietaire() != null &&
                                demande.getUniteLocation().getImmeuble().getProprietaire().getId() == currentUser.getId()) {
                            canUpdate = true;
                        }
                    }

                    if (canUpdate) {
                        String ancienStatus = demande.getStatus();
                        System.out.println("Ancien statut (avant update): " + ancienStatus);
                        System.out.println("Nouveau statut: " + newStatus);

                        demande.setStatus(newStatus);
                        String motif = req.getParameter("motif");
                        if (motif != null && !motif.trim().isEmpty()) {
                            demande.setMotif(motif);
                        }

                        // La logique de création de contrat est maintenant UNIQUEMENT dans le repository
                        int result = demandeLocationRepository.update(demande);

                        if (result > 0) {
                            // CORRECTION: Vérifier avec "ACCEPTE" (pas "ACCEPTEE")
                            if ("EN_ATTENTE".equals(ancienStatus) && "ACCEPTE".equals(newStatus)) {
                                req.getSession().setAttribute("successMessage",
                                        "Demande acceptée avec succès ! Le contrat a été créé automatiquement et envoyé par email au locataire.");
                            } else {
                                req.getSession().setAttribute("successMessage", "Statut mis à jour avec succès");
                            }
                        } else {
                            req.getSession().setAttribute("errorMessage", "Erreur lors de la mise à jour");
                        }
                    } else {
                        req.getSession().setAttribute("errorMessage", "Vous n'avez pas l'autorisation de modifier cette demande");
                    }
                } else {
                    req.getSession().setAttribute("errorMessage", "Demande introuvable");
                }
            } catch (NumberFormatException e) {
                req.getSession().setAttribute("errorMessage", "ID de demande invalide");
            }
        } else {
            req.getSession().setAttribute("errorMessage", "Paramètres manquants");
        }
    }

    private void handleAddDemande(HttpServletRequest req, User currentUser) {
        if (!"LOCATAIRE".equals(currentUser.getRole())) {
            req.getSession().setAttribute("errorMessage", "Seuls les locataires peuvent faire des demandes");
            return;
        }

        String uniteIdStr = req.getParameter("uniteId");
        String motif = req.getParameter("motif");

        if (uniteIdStr != null) {
            try {
                int uniteId = Integer.parseInt(uniteIdStr);

                // Trouver le locataire correspondant à l'utilisateur connecté
                List<Locataire> locataireList = locataireRepository.getAll();
                Locataire locataireCorrespondant = null;
                for (Locataire locataire : locataireList) {
                    if (locataire.getUser() != null && locataire.getIdUser() == currentUser.getId()) {
                        locataireCorrespondant = locataire;
                        break;
                    }
                }

                if (locataireCorrespondant == null) {
                    req.getSession().setAttribute("errorMessage", "Profil locataire non trouvé");
                    return;
                }

                // Vérifier s'il y a déjà une demande en attente
                if (demandeLocationRepository.existsDemandeForUnite(locataireCorrespondant.getId(), uniteId)) {
                    req.getSession().setAttribute("errorMessage", "Vous avez déjà une demande en attente pour cette unité");
                    return;
                }

                UniteLocation uniteLocation = uniteLocationRepository.get(uniteId);
                Locataire locataire = locataireRepository.get(locataireCorrespondant.getId());

                if (uniteLocation != null && locataire != null) {
                    DemandeLocation demandeLocation = new DemandeLocation();
                    demandeLocation.setLocataire(locataire);
                    demandeLocation.setUniteLocation(uniteLocation);
                    demandeLocation.setStatus("EN_ATTENTE");
                    demandeLocation.setMotif(motif != null ? motif : "");

                    int result = demandeLocationRepository.add(demandeLocation);
                    if (result > 0) {
                        req.getSession().setAttribute("successMessage", "Demande envoyée avec succès");
                    } else {
                        req.getSession().setAttribute("errorMessage", "Erreur lors de l'envoi de la demande");
                    }
                } else {
                    req.getSession().setAttribute("errorMessage", "Unité ou utilisateur introuvable");
                }

            } catch (NumberFormatException e) {
                req.getSession().setAttribute("errorMessage", "ID d'unité invalide");
            }
        }
    }
}