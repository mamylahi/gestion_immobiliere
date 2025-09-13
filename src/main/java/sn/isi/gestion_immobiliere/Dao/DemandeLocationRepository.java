package sn.isi.gestion_immobiliere.Dao;

import jakarta.persistence.EntityManager;
import sn.isi.gestion_immobiliere.Entities.DemandeLocation;
import sn.isi.gestion_immobiliere.Entities.ContratLocation;
import sn.isi.gestion_immobiliere.Entities.Locataire;
import sn.isi.gestion_immobiliere.Utils.JPAUtil;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class DemandeLocationRepository implements IRepository<DemandeLocation> {

    EntityManager entityManager;

    public DemandeLocationRepository() {
        this.entityManager = JPAUtil.getEntityManagerFactory().createEntityManager();
    }

    @Override
    public int add(DemandeLocation demandeLocation) {
        EntityManager em = JPAUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(demandeLocation);
            em.getTransaction().commit();
            return 1;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
            return 0;
        } finally {
            em.close();
        }
    }

    @Override
    public int update(DemandeLocation demandeLocation) {
        EntityManager em = JPAUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();

            System.out.println("=== DEBUT UPDATE DEMANDE ===");
            System.out.println("ID Demande: " + demandeLocation.getId());
            System.out.println("Nouveau statut reçu: " + demandeLocation.getStatus());

            // Récupérer la demande existante avec ses relations
            DemandeLocation db = em.createQuery(
                            "SELECT d FROM DemandeLocation d " +
                                    "LEFT JOIN FETCH d.locataire l " +
                                    "LEFT JOIN FETCH l.user u " +
                                    "LEFT JOIN FETCH d.uniteLocation ul " +
                                    "LEFT JOIN FETCH ul.immeuble i " +
                                    "WHERE d.id = :id", DemandeLocation.class)
                    .setParameter("id", demandeLocation.getId())
                    .getSingleResult();

            if (db != null) {
                String ancienStatus = db.getStatus();
                String nouveauStatus = demandeLocation.getStatus();

                System.out.println("Ancien statut: " + ancienStatus);
                System.out.println("Nouveau statut: " + nouveauStatus);

                // Mettre à jour les champs
                db.setStatus(nouveauStatus);
                if (demandeLocation.getMotif() != null) {
                    db.setMotif(demandeLocation.getMotif());
                }

                // CORRECTION: Vérifier avec ACCEPTE (pas ACCEPTEE)
                if ("EN_ATTENTE".equals(ancienStatus) && "ACCEPTEE".equals(nouveauStatus)) {
                    System.out.println("CONDITIONS REMPLIES - Création du contrat...");
                    createContratFromDemande(em, db);
                } else {
                    System.out.println("Conditions non remplies pour créer contrat");
                    System.out.println("  - Ancien: " + ancienStatus + " (doit être EN_ATTENTE)");
                    System.out.println("  - Nouveau: " + nouveauStatus + " (doit être ACCEPTE)");
                }

                em.merge(db);
            }

            em.getTransaction().commit();
            System.out.println("=== TRANSACTION COMMITTED ===");
            return 1;

        } catch (Exception e) {
            System.err.println("ERREUR dans update(): " + e.getMessage());
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
                System.out.println("Transaction rollback effectué");
            }
            e.printStackTrace();
            return 0;
        } finally {
            em.close();
        }
    }

    /**
     * Crée automatiquement un contrat de location lors de l'acceptation d'une demande
     */
    private void createContratFromDemande(EntityManager em, DemandeLocation demande) {
        try {
            System.out.println("=== DEBUT CREATION CONTRAT ===");
            System.out.println("Demande ID: " + demande.getId());

            // Vérifications des données nécessaires
            if (demande.getLocataire() == null) {
                throw new IllegalStateException("Locataire manquant dans la demande");
            }
            if (demande.getUniteLocation() == null) {
                throw new IllegalStateException("Unité de location manquante dans la demande");
            }

            System.out.println("Locataire ID (depuis demande): " + demande.getLocataire().getId());
            System.out.println("Unite ID: " + demande.getUniteLocation().getId());

            // CORRECTION: Le locataire est déjà chargé avec ses relations dans la demande
            Locataire locataire = demande.getLocataire();

            if (locataire == null || locataire.getUser() == null) {
                throw new IllegalStateException("Locataire ou utilisateur introuvable");
            }

            System.out.println("Locataire trouvé: " + locataire.getUser().getNom() + " " + locataire.getUser().getPrenom());
            System.out.println("Email locataire: " + locataire.getUser().getEmail());

            // Vérifier que l'unité a un loyer défini
            Double loyerMensuel = demande.getUniteLocation().getLoyerMensuel();
            if (loyerMensuel == null || loyerMensuel <= 0) {
                throw new IllegalStateException("L'unité doit avoir un loyer mensuel défini. Loyer actuel: " + loyerMensuel);
            }

            System.out.println("Loyer mensuel: " + loyerMensuel);

            // Créer le nouveau contrat
            ContratLocation contrat = new ContratLocation();
            contrat.setDateDebut(LocalDate.now());
            contrat.setDateFin(LocalDate.now().plusYears(1)); // Contrat d'1 an par défaut
            contrat.setCaution(loyerMensuel * 2); // 2 mois de caution
            contrat.setStatut("ACTIF");
            contrat.setUnite(demande.getUniteLocation());
            contrat.setLocataire(locataire);
            contrat.setPaiements(null); // Pas de paiements initiaux

            System.out.println("Contrat créé - persistance...");

            // Sauvegarder le contrat
            em.persist(contrat);
            em.flush(); // Forcer la sauvegarde immédiate

            System.out.println("Contrat persisté avec flush - ID: " + contrat.getId());

            // Rejeter automatiquement toutes les autres demandes en attente pour cette unité
            int demandesRefusees = em.createQuery(
                            "UPDATE DemandeLocation d SET d.status = 'REJETE', d.motif = 'Unité déjà attribuée à un autre locataire' " +
                                    "WHERE d.uniteLocation.id = :uniteId AND d.status = 'EN_ATTENTE' AND d.id != :demandeId")
                    .setParameter("uniteId", demande.getUniteLocation().getId())
                    .setParameter("demandeId", demande.getId())
                    .executeUpdate();

            System.out.println("Autres demandes refusées: " + demandesRefusees);

            // NOUVEAU: Envoyer le contrat PDF par email
            try {
                System.out.println("=== ENVOI EMAIL CONTRAT ===");
                sn.isi.gestion_immobiliere.Utils.EmailService emailService = new sn.isi.gestion_immobiliere.Utils.EmailService();
                boolean emailEnvoye = emailService.envoyerContratPDF(contrat);

                if (emailEnvoye) {
                    System.out.println("✅ Email avec contrat PDF envoyé avec succès à : " +
                            locataire.getUser().getEmail());
                } else {
                    System.err.println("❌ Échec de l'envoi de l'email");
                    // Ne pas faire échouer la transaction pour autant
                    System.out.println("Le contrat a été créé mais l'email n'a pas pu être envoyé");
                }
            } catch (Exception emailError) {
                System.err.println("Erreur lors de l'envoi de l'email: " + emailError.getMessage());
                emailError.printStackTrace();
                // L'erreur d'email ne doit pas faire échouer la création du contrat
                System.out.println("Le contrat a été créé malgré l'erreur d'email");
            }

            System.out.println("=== CONTRAT CREE AVEC SUCCES ===");
            System.out.println("   - ID Contrat: " + contrat.getId());
            System.out.println("   - ID Demande: " + demande.getId());
            System.out.println("   - Locataire: " + locataire.getUser().getNom() + " " + locataire.getUser().getPrenom());
            System.out.println("   - Email: " + locataire.getUser().getEmail());
            System.out.println("   - Unité: Numéro " + demande.getUniteLocation().getNumeroUnite() +
                    " (" + demande.getUniteLocation().getNombrePiece() + " pièces)");
            System.out.println("   - Loyer: " + loyerMensuel + " FCFA");
            System.out.println("   - Caution: " + contrat.getCaution() + " FCFA");
            System.out.println("   - Durée: Du " + contrat.getDateDebut() + " au " + contrat.getDateFin());

        } catch (Exception e) {
            System.err.println("ERREUR lors de la création du contrat: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Impossible de créer le contrat automatiquement: " + e.getMessage(), e);
        }
    }
    @Override
    public int delete(int id) {
        EntityManager em = JPAUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();
            DemandeLocation demandeLocation = em.find(DemandeLocation.class, id);
            if (demandeLocation != null) {
                em.remove(demandeLocation);
            }
            em.getTransaction().commit();
            return 1;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
            return 0;
        } finally {
            em.close();
        }
    }

    @Override
    public List<DemandeLocation> getAll() {
        EntityManager em = JPAUtil.getEntityManagerFactory().createEntityManager();
        try {
            String jpql = """
                SELECT DISTINCT d FROM DemandeLocation d
                LEFT JOIN FETCH d.locataire l
                LEFT JOIN FETCH l.user u
                LEFT JOIN FETCH d.uniteLocation ul
                LEFT JOIN FETCH ul.immeuble i
                LEFT JOIN FETCH i.proprietaire p
                ORDER BY d.id DESC
                """;

            List<DemandeLocation> result = em.createQuery(jpql, DemandeLocation.class)
                    .getResultList();

            System.out.println("getAll() - Nombre de demandes trouvées: " + result.size());
            return result;

        } catch (Exception e) {
            System.err.println("Erreur dans getAll(): " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    @Override
    public DemandeLocation get(int id) {
        EntityManager em = JPAUtil.getEntityManagerFactory().createEntityManager();
        try {
            String jpql = """
                SELECT d FROM DemandeLocation d 
                LEFT JOIN FETCH d.locataire l
                LEFT JOIN FETCH l.user u
                LEFT JOIN FETCH d.uniteLocation ul
                LEFT JOIN FETCH ul.immeuble i
                LEFT JOIN FETCH i.proprietaire p
                WHERE d.id = :id
                """;

            return em.createQuery(jpql, DemandeLocation.class)
                    .setParameter("id", id)
                    .getSingleResult();

        } catch (Exception e) {
            System.err.println("Erreur dans get(): " + e.getMessage());
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    public List<DemandeLocation> getByLocataire(int userId) {
        EntityManager em = JPAUtil.getEntityManagerFactory().createEntityManager();
        try {
            String jpql = """
            SELECT DISTINCT d FROM DemandeLocation d
            LEFT JOIN FETCH d.locataire l
            LEFT JOIN FETCH l.user u
            LEFT JOIN FETCH d.uniteLocation ul
            LEFT JOIN FETCH ul.immeuble i
            LEFT JOIN FETCH i.proprietaire p
            WHERE l.id = :userId
            ORDER BY d.id DESC
            """;

            List<DemandeLocation> result = em.createQuery(jpql, DemandeLocation.class)
                    .setParameter("userId", userId)
                    .getResultList();

            System.out.println("getByLocataire(userId=" + userId + ") - Nombre de demandes: " + result.size());
            return result;

        } catch (Exception e) {
            System.err.println("Erreur dans getByLocataire(): " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }
    
    public List<DemandeLocation> getByProprietaire(int proprietaireId) {
        EntityManager em = JPAUtil.getEntityManagerFactory().createEntityManager();
        try {
            if (proprietaireId <= 0) {
                throw new IllegalArgumentException("L'ID du propriétaire doit être positif");
            }

            String jpql = """
            SELECT DISTINCT d FROM DemandeLocation d
            LEFT JOIN FETCH d.locataire l
            LEFT JOIN FETCH l.user u
            LEFT JOIN FETCH d.uniteLocation ul
            LEFT JOIN FETCH ul.immeuble i
            LEFT JOIN FETCH i.proprietaire p
            WHERE i.proprietaire.id = :proprietaireId
            ORDER BY d.id DESC
            """;

            List<DemandeLocation> result = em.createQuery(jpql, DemandeLocation.class)
                    .setParameter("proprietaireId", proprietaireId)
                    .getResultList();

            System.out.println("getByProprietaire(" + proprietaireId + ") - Nombre de demandes: " + result.size());
            return result;

        } catch (IllegalArgumentException e) {
            System.err.println("Paramètre invalide: " + e.getMessage());
            throw e;
        } catch (Exception e) {
            System.err.println("Erreur dans getByProprietaire(): " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public boolean existsDemandeForUnite(int locataireId, int uniteId) {
        EntityManager em = JPAUtil.getEntityManagerFactory().createEntityManager();
        try {
            Long count = em.createQuery(
                            "SELECT COUNT(d) FROM DemandeLocation d WHERE d.locataire.id = :locataireId AND d.uniteLocation.id = :uniteId AND d.status = 'EN_ATTENTE'",
                            Long.class)
                    .setParameter("locataireId", locataireId)
                    .setParameter("uniteId", uniteId)
                    .getSingleResult();

            return count > 0;
        } catch (Exception e) {
            System.err.println("Erreur dans existsDemandeForUnite(): " + e.getMessage());
            return false;
        } finally {
            em.close();
        }
    }
}