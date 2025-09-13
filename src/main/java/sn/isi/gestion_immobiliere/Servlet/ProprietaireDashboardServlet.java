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

@WebServlet(name = "ProprietaireDashboardServlet", value = "/proprietaire")
public class ProprietaireDashboardServlet extends BaseServlet {
    // DTO class for contracts with Date objects (proprietaire view)
    public static class ContratProprietaireDTO {
        private int id;
        private Date dateDebut;
        private Date dateFin;
        private Double caution;
        private String statut;
        private String locataireNom;
        private String locatairePrenom;
        private String locataireEmail;
        private String locataireTelephone;
        private String uniteNumero;
        private String immeubleNom;
        private Double loyerMensuel;

        public ContratProprietaireDTO(ContratLocation contrat) {
            this.id = contrat.getId();
            this.caution = contrat.getCaution();
            this.statut = contrat.getStatut();

            // Convert LocalDate to Date
            if (contrat.getDateDebut() != null) {
                this.dateDebut = Date.from(contrat.getDateDebut().atStartOfDay(ZoneId.systemDefault()).toInstant());
            }
            if (contrat.getDateFin() != null) {
                this.dateFin = Date.from(contrat.getDateFin().atStartOfDay(ZoneId.systemDefault()).toInstant());
            }

            // Safe access to locataire information
            if (contrat.getLocataire() != null && contrat.getLocataire().getUser() != null) {
                this.locataireNom = contrat.getLocataire().getUser().getNom();
                this.locatairePrenom = contrat.getLocataire().getUser().getPrenom();
                this.locataireEmail = contrat.getLocataire().getUser().getEmail();
                this.locataireTelephone = contrat.getLocataire().getUser().getTelephone();
            }

            // Safe access to unite and immeuble information
            if (contrat.getUnite() != null) {
                this.uniteNumero = String.valueOf(contrat.getUnite().getNumeroUnite());
                this.loyerMensuel = contrat.getUnite().getLoyerMensuel();
                if (contrat.getUnite().getImmeuble() != null) {
                    this.immeubleNom = contrat.getUnite().getImmeuble().getNom();
                }
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
        public String getLocataireEmail() { return locataireEmail; }
        public String getLocataireTelephone() { return locataireTelephone; }
        public String getUniteNumero() { return uniteNumero; }
        public String getImmeubleNom() { return immeubleNom; }
        public Double getLoyerMensuel() { return loyerMensuel; }

        public String getLocataireNomComplet() {
            if (locatairePrenom != null && locataireNom != null) {
                return locatairePrenom + " " + locataireNom;
            }
            return locataireNom != null ? locataireNom : "N/A";
        }
    }

    // DTO class for demandes (proprietaire view)
    public static class DemandeProprietaireDTO {
        private int id;
        private String locataireNom;
        private String locatairePrenom;
        private String locataireEmail;
        private String locataireTelephone;
        private String locataireProfession;
        private String locataireAdresse;
        private String uniteNumero;
        private String immeubleNom;
        private String status;
        private String motif;
        private Double loyerMensuel;
        private int nombrePieces;

        public DemandeProprietaireDTO(DemandeLocation demande) {
            this.id = demande.getId();
            this.status = demande.getStatus();
            this.motif = demande.getMotif();

            if (demande.getLocataire() != null) {
                this.locataireProfession = demande.getLocataire().getProfession();
                this.locataireAdresse = demande.getLocataire().getAdresse();

                if (demande.getLocataire().getUser() != null) {
                    this.locataireNom = demande.getLocataire().getUser().getNom();
                    this.locatairePrenom = demande.getLocataire().getUser().getPrenom();
                    this.locataireEmail = demande.getLocataire().getUser().getEmail();
                    this.locataireTelephone = demande.getLocataire().getUser().getTelephone();
                }
            }

            if (demande.getUniteLocation() != null) {
                this.uniteNumero = String.valueOf(demande.getUniteLocation().getNumeroUnite());
                this.loyerMensuel = demande.getUniteLocation().getLoyerMensuel();
                this.nombrePieces = demande.getUniteLocation().getNombrePiece();

                if (demande.getUniteLocation().getImmeuble() != null) {
                    this.immeubleNom = demande.getUniteLocation().getImmeuble().getNom();
                }
            }
        }

        // Getters
        public int getId() { return id; }
        public String getLocataireNom() { return locataireNom; }
        public String getLocatairePrenom() { return locatairePrenom; }
        public String getLocataireEmail() { return locataireEmail; }
        public String getLocataireTelephone() { return locataireTelephone; }
        public String getLocataireProfession() { return locataireProfession; }
        public String getLocataireAdresse() { return locataireAdresse; }
        public String getUniteNumero() { return uniteNumero; }
        public String getImmeubleNom() { return immeubleNom; }
        public String getStatus() { return status; }
        public String getMotif() { return motif; }
        public Double getLoyerMensuel() { return loyerMensuel; }
        public int getNombrePieces() { return nombrePieces; }

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

        // Vérification de l'authentification et du rôle proprietaire
        if (currentUser == null || !"PROPRIETAIRE".equals(currentUser.getRole())) {
            response.sendRedirect("login");
            return;
        }

        try {
            // Calculer toutes les statistiques pour ce proprietaire
            Map<String, Object> stats = calculateProprietaireStats(currentUser.getId());

            // Transmettre les données à la vue
            for (Map.Entry<String, Object> entry : stats.entrySet()) {
                request.setAttribute(entry.getKey(), entry.getValue());
            }

            // Rediriger vers la vue
            request.getRequestDispatcher("/dashboard/proprietaireIndex.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Erreur dans ProprietaireDashboardServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Erreur lors du chargement du tableau de bord: " + e.getMessage());
            request.getRequestDispatcher("/dashboard/proprietaireIndex.jsp").forward(request, response);
        }
    }

    /**
     * Calcule toutes les statistiques nécessaires pour le tableau de bord propriétaire
     */
    private Map<String, Object> calculateProprietaireStats(int proprietaireId) {
        Map<String, Object> stats = new HashMap<>();

        try {
            // === RÉCUPÉRATION DES DONNÉES ===
            List<Immeuble> mesImmeubles = immeubleRepository.getByProprietaire(proprietaireId);
            List<UniteLocation> mesUnites = uniteLocationRepository.getByProprietaire(proprietaireId);
            List<ContratLocation> mesContrats = contratLocationRepository.getByProprietaire(proprietaireId);
            List<DemandeLocation> mesDemandes = demandeLocationRepository.getByProprietaire(proprietaireId);

            // Récupérer tous les paiements liés aux contrats du propriétaire
            List<Paiement> mesPaiements = new ArrayList<>();
            for (ContratLocation contrat : mesContrats) {
                mesPaiements.addAll(paiementRepository.getByContrat(contrat.getId()));
            }

            // === STATISTIQUES GÉNÉRALES ===
            stats.put("totalImmeubles", mesImmeubles.size());
            stats.put("totalUnites", mesUnites.size());
            stats.put("totalContrats", mesContrats.size());
            stats.put("totalDemandes", mesDemandes.size());

            // === STATISTIQUES DES CONTRATS ===
            Map<String, Long> contratsByStatut = mesContrats.stream()
                    .collect(Collectors.groupingBy(ContratLocation::getStatut, Collectors.counting()));

            stats.put("contratsActifs", contratsByStatut.getOrDefault("ACTIF", 0L));
            stats.put("contratsTermines", contratsByStatut.getOrDefault("TERMINE", 0L));
            stats.put("contratsResilies", contratsByStatut.getOrDefault("RESILIE", 0L));

            // === STATISTIQUES DES DEMANDES ===
            Map<String, Long> demandesByStatut = mesDemandes.stream()
                    .collect(Collectors.groupingBy(DemandeLocation::getStatus, Collectors.counting()));

            stats.put("demandesEnAttente", demandesByStatut.getOrDefault("EN_ATTENTE", 0L));
            stats.put("demandesAcceptees", demandesByStatut.getOrDefault("ACCEPTEE", 0L));
            stats.put("demandesRejetees", demandesByStatut.getOrDefault("REJETE", 0L));

            // === STATISTIQUES FINANCIÈRES ===
            double revenusTheorique = mesUnites.stream()
                    .filter(u -> u.getLoyerMensuel() != null)
                    .mapToDouble(UniteLocation::getLoyerMensuel)
                    .sum();

            double revenusReel = mesPaiements.stream()
                    .filter(p -> "PAYE".equals(p.getStatut()))
                    .mapToDouble(Paiement::getMontant)
                    .sum();

            double revenusEnAttente = mesPaiements.stream()
                    .filter(p -> "EN_ATTENTE".equals(p.getStatut()))
                    .mapToDouble(Paiement::getMontant)
                    .sum();

            double loyerMoyen = mesUnites.stream()
                    .filter(u -> u.getLoyerMensuel() != null)
                    .mapToDouble(UniteLocation::getLoyerMensuel)
                    .average()
                    .orElse(0.0);

            stats.put("revenusTheorique", revenusTheorique);
            stats.put("revenusReel", revenusReel);
            stats.put("revenusEnAttente", revenusEnAttente);
            stats.put("loyerMoyen", loyerMoyen);

            // === TAUX D'OCCUPATION ===
            long unitesOccupees = mesContrats.stream()
                    .filter(c -> "ACTIF".equals(c.getStatut()))
                    .count();

            double tauxOccupation = mesUnites.size() > 0 ?
                    (double) unitesOccupees / mesUnites.size() * 100 : 0.0;

            stats.put("unitesOccupees", unitesOccupees);
            stats.put("unitesLibres", mesUnites.size() - unitesOccupees);
            stats.put("tauxOccupation", tauxOccupation);

            // === DONNÉES POUR GRAPHIQUES ===

            // Évolution des contrats sur les 6 derniers mois
            Map<String, Long> contratsParMois = getContratsParMois(mesContrats);
            stats.put("contratsParMois", contratsParMois);

            // Répartition des revenus par immeuble
            Map<String, Double> revenusParImmeuble = new HashMap<>();
            for (Immeuble immeuble : mesImmeubles) {
                double revenus = mesContrats.stream()
                        .filter(c -> c.getUnite() != null &&
                                c.getUnite().getImmeuble() != null &&
                                c.getUnite().getImmeuble().getId() == immeuble.getId())
                        .filter(c -> "ACTIF".equals(c.getStatut()))
                        .mapToDouble(c -> c.getUnite().getLoyerMensuel() != null ? c.getUnite().getLoyerMensuel() : 0.0)
                        .sum();
                revenusParImmeuble.put(immeuble.getNom(), revenus);
            }
            stats.put("revenusParImmeuble", revenusParImmeuble);

            // Performance des immeubles (taux d'occupation par immeuble)
            Map<String, Double> occupationParImmeuble = new HashMap<>();
            for (Immeuble immeuble : mesImmeubles) {
                List<UniteLocation> unitesImmeuble = mesUnites.stream()
                        .filter(u -> u.getImmeuble() != null && u.getImmeuble().getId() == immeuble.getId())
                        .collect(Collectors.toList());

                long unitesOccupeesImmeuble = mesContrats.stream()
                        .filter(c -> "ACTIF".equals(c.getStatut()))
                        .filter(c -> c.getUnite() != null &&
                                c.getUnite().getImmeuble() != null &&
                                c.getUnite().getImmeuble().getId() == immeuble.getId())
                        .count();

                double tauxImmeuble = unitesImmeuble.size() > 0 ?
                        (double) unitesOccupeesImmeuble / unitesImmeuble.size() * 100 : 0.0;

                occupationParImmeuble.put(immeuble.getNom(), tauxImmeuble);
            }
            stats.put("occupationParImmeuble", occupationParImmeuble);

            // === ACTIVITÉS RÉCENTES ===

            // Derniers contrats signés - Convert to DTOs
            List<ContratProprietaireDTO> derniersContrats = mesContrats.stream()
                    .filter(c -> c.getDateDebut() != null)
                    .sorted((c1, c2) -> c2.getDateDebut().compareTo(c1.getDateDebut()))
                    .limit(5)
                    .map(ContratProprietaireDTO::new)
                    .collect(Collectors.toList());
            stats.put("derniersContrats", derniersContrats);

            // Dernières demandes reçues - Convert to DTOs
            List<DemandeProprietaireDTO> dernieresDemandes = mesDemandes.stream()
                    .sorted((d1, d2) -> Integer.compare(d2.getId(), d1.getId()))
                    .limit(5)
                    .map(DemandeProprietaireDTO::new)
                    .collect(Collectors.toList());
            stats.put("dernieresDemandes", dernieresDemandes);

            // Derniers paiements reçus
            List<Paiement> derniersPaiements = mesPaiements.stream()
                    .filter(p -> p.getDatePaiement() != null)
                    .sorted((p1, p2) -> p2.getDatePaiement().compareTo(p1.getDatePaiement()))
                    .limit(5)
                    .collect(Collectors.toList());
            stats.put("derniersPaiements", derniersPaiements);

            // === ALERTES ET NOTIFICATIONS ===

            // Paiements en retard
            long paiementsEnRetard = mesPaiements.stream()
                    .filter(p -> "EN_RETARD".equals(p.getStatut()))
                    .count();
            stats.put("paiementsEnRetard", paiementsEnRetard);

            // Contrats expirant bientôt (dans les 30 jours)
            LocalDate dateLimit = LocalDate.now().plusDays(30);
            long contratsExpirants = mesContrats.stream()
                    .filter(c -> "ACTIF".equals(c.getStatut()))
                    .filter(c -> c.getDateFin() != null && c.getDateFin().isBefore(dateLimit))
                    .count();
            stats.put("contratsExpirants", contratsExpirants);

            // Unités vacantes depuis longtemps (plus de 60 jours)
            LocalDate dateLimitVacance = LocalDate.now().minusDays(60);
            long unitesVacantesLongtemps = mesUnites.stream()
                    .filter(u -> mesContrats.stream()
                            .noneMatch(c -> "ACTIF".equals(c.getStatut()) &&
                                    c.getUnite() != null &&
                                    c.getUnite().getId() == u.getId()))
                    .count();
            stats.put("unitesVacantesLongtemps", unitesVacantesLongtemps);

            System.out.println("=== STATISTIQUES PROPRIÉTAIRE CALCULÉES ===");
            System.out.println("Propriétaire ID: " + proprietaireId);
            stats.forEach((key, value) ->
                    System.out.println(key + ": " + value)
            );

        } catch (Exception e) {
            System.err.println("Erreur lors du calcul des statistiques propriétaire: " + e.getMessage());
            e.printStackTrace();
            // Valeurs par défaut en cas d'erreur
            stats.put("totalImmeubles", 0);
            stats.put("totalUnites", 0);
            stats.put("totalContrats", 0);
            stats.put("totalDemandes", 0);
            stats.put("derniersContrats", new ArrayList<ContratProprietaireDTO>());
            stats.put("dernieresDemandes", new ArrayList<DemandeProprietaireDTO>());
            stats.put("derniersPaiements", new ArrayList<Paiement>());
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