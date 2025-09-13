package sn.isi.gestion_immobiliere.Servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import sn.isi.gestion_immobiliere.Dao.PaiementRepository;
import sn.isi.gestion_immobiliere.Dao.ContratLocationRepository;
import sn.isi.gestion_immobiliere.Entities.Paiement;
import sn.isi.gestion_immobiliere.Entities.ContratLocation;
import sn.isi.gestion_immobiliere.Entities.User;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/paiements")
public class PaiementServlet extends BaseServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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

        String action = req.getParameter("action");

        try {
            if (action == null) {
                // Afficher la page de paiement avec les contrats
                List<ContratLocation> contrats = getContratsForUser(currentUser);

                // Filtrer les contrats qui nécessitent un paiement
                List<ContratLocation> contratsAPayer = getContratsNecessitantPaiement(contrats);

                // Récupérer l'historique des paiements pour cet utilisateur
                List<Paiement> historiquePaiements = getPaiementsForUser(currentUser);

                req.setAttribute("contrats", contratsAPayer);
                req.setAttribute("historiquesPaiements", historiquePaiements);
                req.setAttribute("currentUser", currentUser);

                System.out.println("=== DEBUG PAIEMENT ===");
                System.out.println("User: " + currentUser.getNom() + " (" + currentUser.getRole() + ")");
                System.out.println("Contrats totaux: " + contrats.size());
                System.out.println("Contrats nécessitant paiement: " + contratsAPayer.size());
                System.out.println("Historique paiements: " + historiquePaiements.size());

                req.getRequestDispatcher("/views/paiement/paiement_jstl.jsp").forward(req, resp);

            } else if (action.equals("delete") && "ADMIN".equals(currentUser.getRole())) {
                int id = Integer.parseInt(req.getParameter("id"));
                int result = paiementRepository.delete(id);

                if (result > 0) {
                    req.getSession().setAttribute("successMessage", "Paiement supprimé avec succès.");
                } else {
                    req.getSession().setAttribute("errorMessage", "Erreur lors de la suppression du paiement.");
                }
                resp.sendRedirect("paiements");

            } else {
                // Action non reconnue, rediriger vers la liste
                resp.sendRedirect("paiements");
            }

        } catch (Exception e) {
            System.err.println("Erreur dans PaiementServlet: " + e.getMessage());
            e.printStackTrace();
            req.getSession().setAttribute("errorMessage", "Une erreur est survenue: " + e.getMessage());
            resp.sendRedirect("paiements");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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

        try {
            // Récupérer les paramètres du formulaire
            Long contratId = Long.parseLong(req.getParameter("contratId"));
            Double montant = Double.parseDouble(req.getParameter("montant"));
            String paymentMethod = req.getParameter("paymentMethod");

            // Paramètres optionnels selon la méthode de paiement
            String telephone = req.getParameter("telephone");
            String cardNumber = req.getParameter("cardNumber");
            String expiryDate = req.getParameter("expiryDate");
            String cvv = req.getParameter("cvv");

            // Récupérer le contrat pour vérifier les droits d'accès
            ContratLocation contrat = contratLocationRepository.get(contratId.intValue());

            if (contrat == null) {
                req.getSession().setAttribute("errorMessage", "Contrat non trouvé.");
                resp.sendRedirect("paiements");
                return;
            }

            // Vérifier que l'utilisateur a le droit de payer pour ce contrat
            if (!canPayForContract(currentUser, contrat)) {
                req.getSession().setAttribute("errorMessage", "Vous n'êtes pas autorisé à payer pour ce contrat.");
                resp.sendRedirect("paiements");
                return;
            }

            // Créer le paiement
            Paiement paiement = new Paiement();
            paiement.setDatePaiement(LocalDate.now());
            paiement.setMontant(montant);
            paiement.setStatut("PAYE"); // ou "EN_ATTENTE" selon votre logique métier
            paiement.setContrat(contrat);

            // Ajouter des informations sur la méthode de paiement
            String methodeDescription = getMethodeDescription(paymentMethod, telephone, cardNumber);
            paiement.setMethodePaiement(methodeDescription);

            System.out.println("=== CREATION PAIEMENT ===");
            System.out.println("Contrat ID: " + contratId);
            System.out.println("Montant: " + montant);
            System.out.println("Méthode: " + paymentMethod);
            System.out.println("User: " + currentUser.getNom());

            int result = paiementRepository.add(paiement);

            if (result > 0) {
                req.getSession().setAttribute("successMessage",
                        "Paiement de " + String.format("%,.0f", montant) + " FCFA effectué avec succès pour le contrat #" + contratId + ".");

                // Log du succès
                System.out.println("Paiement créé avec succès - ID: " + result);
            } else {
                req.getSession().setAttribute("errorMessage", "Erreur lors du traitement du paiement.");
                System.err.println("Échec de la création du paiement");
            }

        } catch (NumberFormatException e) {
            req.getSession().setAttribute("errorMessage", "Données de paiement invalides.");
            System.err.println("Erreur de format dans les données: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("Erreur lors de la création du paiement: " + e.getMessage());
            e.printStackTrace();
            req.getSession().setAttribute("errorMessage", "Erreur lors du traitement du paiement: " + e.getMessage());
        }

        resp.sendRedirect("paiements");
    }

    /**
     * Récupère les contrats selon le rôle de l'utilisateur
     */
    private List<ContratLocation> getContratsForUser(User user) {
        try {
            if ("LOCATAIRE".equals(user.getRole())) {
                return contratLocationRepository.getByLocataireUserId(user.getId());
            } else if ("PROPRIETAIRE".equals(user.getRole())) {
                return contratLocationRepository.getByProprietaire(user.getId());
            } else {
                // Admin peut voir tous les contrats
                return contratLocationRepository.getAll();
            }
        } catch (Exception e) {
            System.err.println("Erreur dans getContratsForUser: " + e.getMessage());
            e.printStackTrace();
            return List.of();
        }
    }

    /**
     * Filtre les contrats qui nécessitent un paiement selon les critères :
     * - Contrats actifs sans aucun paiement
     * - Contrats actifs dont le dernier paiement date de plus de 30 jours
     */
    private List<ContratLocation> getContratsNecessitantPaiement(List<ContratLocation> contrats) {
        try {
            LocalDate dateActuelle = LocalDate.now();

            return contrats.stream()
                    .filter(contrat -> "ACTIF".equals(contrat.getStatut()))
                    .filter(contrat -> necessitePaiement(contrat, dateActuelle))
                    .collect(Collectors.toList());

        } catch (Exception e) {
            System.err.println("Erreur dans getContratsNecessitantPaiement: " + e.getMessage());
            e.printStackTrace();
            return List.of();
        }
    }

    /**
     * Vérifie si un contrat nécessite un paiement
     */
    private boolean necessitePaiement(ContratLocation contrat, LocalDate dateActuelle) {
        try {
            // Récupérer tous les paiements pour ce contrat
            List<Paiement> paiementsContrat = paiementRepository.getAll().stream()
                    .filter(p -> p.getContrat() != null && p.getContrat().getId() == contrat.getId())
                    .collect(Collectors.toList());

            System.out.println("Contrat #" + contrat.getId() + " - Paiements trouvés: " + paiementsContrat.size());

            // Si aucun paiement, le contrat nécessite un paiement
            if (paiementsContrat.isEmpty()) {
                System.out.println("Contrat #" + contrat.getId() + " - Aucun paiement, nécessite paiement");
                return true;
            }

            // Trouver le dernier paiement
            Paiement dernierPaiement = paiementsContrat.stream()
                    .filter(p -> p.getDatePaiement() != null)
                    .max((p1, p2) -> p1.getDatePaiement().compareTo(p2.getDatePaiement()))
                    .orElse(null);

            if (dernierPaiement == null) {
                System.out.println("Contrat #" + contrat.getId() + " - Pas de date de paiement valide, nécessite paiement");
                return true;
            }

            // Calculer si plus de 30 jours se sont écoulés depuis le dernier paiement
            LocalDate dateLimitePaiement = dernierPaiement.getDatePaiement().plusDays(30);
            boolean necessitePaiement = dateActuelle.isAfter(dateLimitePaiement);

            System.out.println("Contrat #" + contrat.getId() +
                    " - Dernier paiement: " + dernierPaiement.getDatePaiement() +
                    " - Date limite: " + dateLimitePaiement +
                    " - Date actuelle: " + dateActuelle +
                    " - Nécessite paiement: " + necessitePaiement);

            return necessitePaiement;

        } catch (Exception e) {
            System.err.println("Erreur lors de la vérification du paiement pour le contrat #" + contrat.getId() + ": " + e.getMessage());
            e.printStackTrace();
            // En cas d'erreur, considérer que le contrat nécessite un paiement par sécurité
            return true;
        }
    }

    /**
     * Récupère l'historique des paiements pour un utilisateur
     */
    private List<Paiement> getPaiementsForUser(User user) {
        try {
            if ("ADMIN".equals(user.getRole())) {
                // Admin voit tous les paiements (limité aux 10 derniers)
                List<Paiement> allPaiements = paiementRepository.getAll();
                return allPaiements.stream()
                        .sorted((p1, p2) -> p2.getDatePaiement().compareTo(p1.getDatePaiement()))
                        .limit(10)
                        .collect(Collectors.toList());
            } else {
                // Pour les locataires et propriétaires, filtrer selon leurs contrats
                List<ContratLocation> userContracts = getContratsForUser(user);
                List<Integer> contractIds = userContracts.stream()
                        .map(ContratLocation::getId)
                        .collect(Collectors.toList());

                return paiementRepository.getAll().stream()
                        .filter(p -> p.getContrat() != null && contractIds.contains(p.getContrat().getId()))
                        .sorted((p1, p2) -> p2.getDatePaiement().compareTo(p1.getDatePaiement()))
                        .limit(5)
                        .collect(Collectors.toList());
            }
        } catch (Exception e) {
            System.err.println("Erreur dans getPaiementsForUser: " + e.getMessage());
            e.printStackTrace();
            return List.of();
        }
    }

    /**
     * Vérifie si l'utilisateur peut payer pour ce contrat
     */
    private boolean canPayForContract(User user, ContratLocation contrat) {
        if ("ADMIN".equals(user.getRole())) {
            return true;
        } else if ("LOCATAIRE".equals(user.getRole())) {
            return contrat.getLocataire() != null &&
                    contrat.getLocataire().getUser() != null &&
                    contrat.getLocataire().getUser().getId() == user.getId();
        } else if ("PROPRIETAIRE".equals(user.getRole())) {
            return contrat.getUnite() != null &&
                    contrat.getUnite().getImmeuble() != null &&
                    contrat.getUnite().getImmeuble().getProprietaire() != null &&
                    contrat.getUnite().getImmeuble().getProprietaire().getId() == user.getId();
        }
        return false;
    }

    /**
     * Génère une description de la méthode de paiement
     */
    private String getMethodeDescription(String paymentMethod, String telephone, String cardNumber) {
        switch (paymentMethod) {
            case "orange_money":
                return "Orange Money" + (telephone != null ? " (" + maskPhone(telephone) + ")" : "");
            case "wave":
                return "Wave" + (telephone != null ? " (" + maskPhone(telephone) + ")" : "");
            case "free_money":
                return "Free Money" + (telephone != null ? " (" + maskPhone(telephone) + ")" : "");
            case "carte_bancaire":
                return "Carte Bancaire" + (cardNumber != null ? " (**** " + cardNumber.substring(Math.max(0, cardNumber.length() - 4)) + ")" : "");
            default:
                return paymentMethod;
        }
    }

    /**
     * Masque partiellement un numéro de téléphone
     */
    private String maskPhone(String phone) {
        if (phone == null || phone.length() < 4) {
            return phone;
        }
        String cleaned = phone.replaceAll("\\s+", "");
        if (cleaned.length() >= 8) {
            return cleaned.substring(0, 2) + " *** ** " + cleaned.substring(cleaned.length() - 2);
        }
        return phone;
    }
}