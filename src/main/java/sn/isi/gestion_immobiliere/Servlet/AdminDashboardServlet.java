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
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet(name = "AdminDashboardServlet", value = "/admin")
public class AdminDashboardServlet extends BaseServlet {
    // DTO class for contracts with Date objects
    public static class ContratDisplayDTO {
        private int id;
        private Date dateDebut;
        private Date dateFin;
        private Double caution;
        private String statut;
        private String locataireNom;
        private String locatairePrenom;
        private String uniteNumero;

        public ContratDisplayDTO(ContratLocation contrat) {
            this.id = contrat.getId();
            this.caution = contrat.getCaution();
            this.statut = contrat.getStatut();

            // Convert LocalDate to Date for JSP compatibility
            if (contrat.getDateDebut() != null) {
                this.dateDebut = Date.from(contrat.getDateDebut().atStartOfDay(ZoneId.systemDefault()).toInstant());
            }
            if (contrat.getDateFin() != null) {
                this.dateFin = Date.from(contrat.getDateFin().atStartOfDay(ZoneId.systemDefault()).toInstant());
            }

            // Safely access locataire information
            if (contrat.getLocataire() != null && contrat.getLocataire().getUser() != null) {
                this.locataireNom = contrat.getLocataire().getUser().getNom();
                this.locatairePrenom = contrat.getLocataire().getUser().getPrenom();
            }

            // Safely access unite information
            if (contrat.getUnite() != null) {
                this.uniteNumero = String.valueOf(contrat.getUnite().getNumeroUnite());
            }
        }

        // Getters
        public int getId() { return id; }
        public Date getDateDebut() { return dateDebut; }
        public Date getDateFin() { return dateFin; }
        public Double getCaution() { return caution; }
        public String getStatut() { return statut; }
        public String getLocataireNom() { return locataireNom; }
        public String getLocatairePrenom() { return locatairePrenom; }
        public String getUniteNumero() { return uniteNumero; }

        // Utility methods for JSP
        public String getLocataireNomComplet() {
            if (locatairePrenom != null && locataireNom != null) {
                return locatairePrenom + " " + locataireNom;
            }
            return locataireNom != null ? locataireNom : "N/A";
        }
    }

    // DTO class for demandes
    public static class DemandeDisplayDTO {
        private int id;
        private String locataireNom;
        private String locatairePrenom;
        private String uniteNumero;
        private String status;
        private String motif;

        public DemandeDisplayDTO(DemandeLocation demande) {
            this.id = demande.getId();
            this.status = demande.getStatus();
            this.motif = demande.getMotif();

            if (demande.getLocataire() != null && demande.getLocataire().getUser() != null) {
                this.locataireNom = demande.getLocataire().getUser().getNom();
                this.locatairePrenom = demande.getLocataire().getUser().getPrenom();
            }

            if (demande.getUniteLocation() != null) {
                this.uniteNumero = String.valueOf(demande.getUniteLocation().getNumeroUnite());
            }
        }

        // Getters
        public int getId() { return id; }
        public String getLocataireNom() { return locataireNom; }
        public String getLocatairePrenom() { return locatairePrenom; }
        public String getUniteNumero() { return uniteNumero; }
        public String getStatus() { return status; }
        public String getMotif() { return motif; }

        public String getLocataireNomComplet() {
            if (locatairePrenom != null && locataireNom != null) {
                return locatairePrenom + " " + locataireNom;
            }
            return locataireNom != null ? locataireNom : "N/A";
        }
    }

    @Override
    public void init() throws ServletException {
        super.init();
        this.userRepository = new UserRepository();
        this.immeubleRepository = new ImmeubleRepository();
        this.uniteLocationRepository = new UniteLocationRepository();
        this.contratLocationRepository = new ContratLocationRepository();
        this.demandeLocationRepository = new DemandeLocationRepository();
        this.paiementRepository = new PaiementRepository();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        // Vérification de l'authentification et du rôle admin
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            response.sendRedirect("login");
            return;
        }

        try {
            // Calculer toutes les statistiques
            Map<String, Object> stats = calculateDashboardStats();

            // Transmettre les données à la vue
            for (Map.Entry<String, Object> entry : stats.entrySet()) {
                request.setAttribute(entry.getKey(), entry.getValue());
            }

            // Rediriger vers la vue
            request.getRequestDispatcher("/dashboard/admin_jstl.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Erreur dans AdminDashboardServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Erreur lors du chargement du tableau de bord: " + e.getMessage());
            request.getRequestDispatcher("/dashboard/admin_jstl.jsp").forward(request, response);
        }
    }

    /**
     * Calcule toutes les statistiques nécessaires pour le tableau de bord
     */
    private Map<String, Object> calculateDashboardStats() {
        Map<String, Object> stats = new HashMap<>();

        try {
            // === STATISTIQUES GÉNÉRALES ===
            List<User> allUsers = userRepository.getAll();
            List<Immeuble> allImmeubles = immeubleRepository.getAll();
            List<UniteLocation> allUnites = uniteLocationRepository.getAll();
            List<ContratLocation> allContrats = contratLocationRepository.getAll();
            List<DemandeLocation> allDemandes = demandeLocationRepository.getAll();
            List<Paiement> allPaiements = paiementRepository.getAll();

            // Totaux généraux
            stats.put("totalUsers", allUsers.size());
            stats.put("totalImmeubles", allImmeubles.size());
            stats.put("totalUnites", allUnites.size());
            stats.put("totalContrats", allContrats.size());
            stats.put("totalDemandes", allDemandes.size());
            stats.put("totalPaiements", allPaiements.size());

            // === RÉPARTITION DES UTILISATEURS PAR RÔLE ===
            Map<String, Long> usersByRole = allUsers.stream()
                    .collect(Collectors.groupingBy(User::getRole, Collectors.counting()));

            stats.put("adminsCount", usersByRole.getOrDefault("ADMIN", 0L));
            stats.put("proprietairesCount", usersByRole.getOrDefault("PROPRIETAIRE", 0L));
            stats.put("locatairesCount", usersByRole.getOrDefault("LOCATAIRE", 0L));

            // === STATISTIQUES DES CONTRATS ===
            Map<String, Long> contratsByStatut = allContrats.stream()
                    .collect(Collectors.groupingBy(ContratLocation::getStatut, Collectors.counting()));

            stats.put("contratsActifs", contratsByStatut.getOrDefault("ACTIF", 0L));
            stats.put("contratsTermines", contratsByStatut.getOrDefault("TERMINE", 0L));
            stats.put("contratsResilies", contratsByStatut.getOrDefault("RESILIE", 0L));

            // === STATISTIQUES DES DEMANDES ===
            Map<String, Long> demandesByStatut = allDemandes.stream()
                    .collect(Collectors.groupingBy(DemandeLocation::getStatus, Collectors.counting()));

            stats.put("demandesEnAttente", demandesByStatut.getOrDefault("EN_ATTENTE", 0L));
            stats.put("demandesAcceptees", demandesByStatut.getOrDefault("ACCEPTEE", 0L));
            stats.put("demandesRejetees", demandesByStatut.getOrDefault("REJETE", 0L));

            // === STATISTIQUES FINANCIÈRES ===
            double totalRevenusTheorique = allUnites.stream()
                    .filter(u -> u.getLoyerMensuel() != null)
                    .mapToDouble(UniteLocation::getLoyerMensuel)
                    .sum();

            double totalRevenusReel = allPaiements.stream()
                    .filter(p -> "PAYE".equals(p.getStatut()))
                    .mapToDouble(Paiement::getMontant)
                    .sum();

            double loyerMoyen = allUnites.stream()
                    .filter(u -> u.getLoyerMensuel() != null)
                    .mapToDouble(UniteLocation::getLoyerMensuel)
                    .average()
                    .orElse(0.0);

            stats.put("totalRevenusTheorique", totalRevenusTheorique);
            stats.put("totalRevenusReel", totalRevenusReel);
            stats.put("loyerMoyen", loyerMoyen);

            // === TAUX D'OCCUPATION ===
            long unitesOccupees = allContrats.stream()
                    .filter(c -> "ACTIF".equals(c.getStatut()))
                    .count();

            double tauxOccupation = allUnites.size() > 0 ?
                    (double) unitesOccupees / allUnites.size() * 100 : 0.0;

            stats.put("unitesOccupees", unitesOccupees);
            stats.put("unitesLibres", allUnites.size() - unitesOccupees);
            stats.put("tauxOccupation", tauxOccupation);

            // === DONNÉES POUR GRAPHIQUES ===

            // Évolution des contrats sur les 6 derniers mois
            Map<String, Long> contratsParMois = getContratsParMois(allContrats);
            stats.put("contratsParMois", contratsParMois);

            // Répartition des paiements par méthode
            Map<String, Long> paiementsParMethode = allPaiements.stream()
                    .filter(p -> p.getMethodePaiement() != null && !p.getMethodePaiement().isEmpty())
                    .collect(Collectors.groupingBy(Paiement::getMethodePaiement, Collectors.counting()));
            stats.put("paiementsParMethode", paiementsParMethode);

            // Top 5 des propriétaires par nombre d'immeubles
            Map<String, Long> immeublesByProprietaire = allImmeubles.stream()
                    .filter(i -> i.getProprietaire() != null)
                    .collect(Collectors.groupingBy(
                            i -> i.getProprietaire().getPrenom() + " " + i.getProprietaire().getNom(),
                            Collectors.counting()
                    ));

            List<Map.Entry<String, Long>> topProprietaires = immeublesByProprietaire.entrySet()
                    .stream()
                    .sorted(Map.Entry.<String, Long>comparingByValue().reversed())
                    .limit(5)
                    .collect(Collectors.toList());
            stats.put("topProprietaires", topProprietaires);

            // === ACTIVITÉS RÉCENTES ===

            // IMPORTANT: Convert to DTOs with proper Date objects
            List<ContratDisplayDTO> derniersContrats = allContrats.stream()
                    .filter(c -> c.getDateDebut() != null) // Filter null dates
                    .sorted((c1, c2) -> c2.getDateDebut().compareTo(c1.getDateDebut()))
                    .limit(5)
                    .map(ContratDisplayDTO::new) // Convert to DTO
                    .collect(Collectors.toList());
            stats.put("derniersContrats", derniersContrats);

            // Convert demandes to DTOs as well
            List<DemandeDisplayDTO> dernieresDemandes = allDemandes.stream()
                    .sorted((d1, d2) -> Integer.compare(d2.getId(), d1.getId()))
                    .limit(5)
                    .map(DemandeDisplayDTO::new) // Convert to DTO
                    .collect(Collectors.toList());
            stats.put("dernieresDemandes", dernieresDemandes);

            // Keep payments as is since they don't have the LocalDate issue
            List<Paiement> derniersPaiements = allPaiements.stream()
                    .filter(p -> p.getDatePaiement() != null)
                    .sorted((p1, p2) -> p2.getDatePaiement().compareTo(p1.getDatePaiement()))
                    .limit(5)
                    .collect(Collectors.toList());
            stats.put("derniersPaiements", derniersPaiements);

            // === ALERTES ET NOTIFICATIONS ===

            // Paiements en retard
            long paiementsEnRetard = allPaiements.stream()
                    .filter(p -> "EN_RETARD".equals(p.getStatut()))
                    .count();
            stats.put("paiementsEnRetard", paiementsEnRetard);

            // Contrats expirant bientôt (dans les 30 jours)
            LocalDate dateLimit = LocalDate.now().plusDays(30);
            long contratsExpirants = allContrats.stream()
                    .filter(c -> "ACTIF".equals(c.getStatut()))
                    .filter(c -> c.getDateFin() != null && c.getDateFin().isBefore(dateLimit))
                    .count();
            stats.put("contratsExpirants", contratsExpirants);

            // Demandes en attente depuis plus de 7 jours
            long demandesAnciennesEnAttente = demandesByStatut.getOrDefault("EN_ATTENTE", 0L);
            stats.put("demandesAnciennesEnAttente", demandesAnciennesEnAttente);

            System.out.println("=== STATISTIQUES CALCULÉES ===");
            stats.forEach((key, value) ->
                    System.out.println(key + ": " + value)
            );

        } catch (Exception e) {
            System.err.println("Erreur lors du calcul des statistiques: " + e.getMessage());
            e.printStackTrace();
            // Valeurs par défaut en cas d'erreur
            stats.put("totalUsers", 0);
            stats.put("totalImmeubles", 0);
            stats.put("totalUnites", 0);
            stats.put("totalContrats", 0);
            stats.put("derniersContrats", new ArrayList<ContratDisplayDTO>());
            stats.put("dernieresDemandes", new ArrayList<DemandeDisplayDTO>());
        }

        return stats;
    }

    /**
     * Calcule le nombre de contrats créés par mois sur les 6 derniers mois
     */
    private Map<String, Long> getContratsParMois(List<ContratLocation> contrats) {
        Map<String, Long> result = new LinkedHashMap<>();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM yyyy", Locale.FRENCH);

        for (int i = 5; i >= 0; i--) {
            LocalDate mois = LocalDate.now().minusMonths(i);
            String moisLabel = mois.format(formatter);

            long count = contrats.stream()
                    .filter(c -> c.getDateDebut() != null)
                    .filter(c -> c.getDateDebut().getYear() == mois.getYear() &&
                            c.getDateDebut().getMonth() == mois.getMonth())
                    .count();

            result.put(moisLabel, count);
        }

        return result;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}