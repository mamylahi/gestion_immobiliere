package sn.isi.gestion_immobiliere.Dao;

import jakarta.persistence.EntityManager;
import sn.isi.gestion_immobiliere.Entities.ContratLocation;
import sn.isi.gestion_immobiliere.Entities.DemandeLocation;
import sn.isi.gestion_immobiliere.Entities.Locataire;
import sn.isi.gestion_immobiliere.Utils.JPAUtil;

import java.util.ArrayList;
import java.util.List;

public class ContratLocationRepository implements IRepository<ContratLocation> {
    EntityManager entityManager;

    public ContratLocationRepository() {
        this.entityManager = JPAUtil.getEntityManagerFactory().createEntityManager();
    }

    @Override
    public int add(ContratLocation contratLocation) {
        EntityManager em = JPAUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(contratLocation);
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
    public int update(ContratLocation contratLocation) {
        EntityManager em = JPAUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();
            ContratLocation contratLocationdb = em.find(ContratLocation.class, contratLocation.getId());
            if (contratLocationdb != null) {
                contratLocationdb.setDateDebut(contratLocation.getDateDebut());
                contratLocationdb.setDateFin(contratLocation.getDateFin());
                contratLocationdb.setCaution(contratLocation.getCaution());
                contratLocationdb.setStatut(contratLocation.getStatut());
                contratLocationdb.setUnite(contratLocation.getUnite());
                contratLocationdb.setLocataire(contratLocation.getLocataire());
                contratLocationdb.setPaiements(contratLocation.getPaiements());
                em.merge(contratLocationdb);
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
    public int delete(int id) {
        EntityManager em = JPAUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();
            ContratLocation contratLocation = em.find(ContratLocation.class, id);
            if (contratLocation != null) {
                em.remove(contratLocation);
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
    public List<ContratLocation> getAll() {
        EntityManager em = JPAUtil.getEntityManagerFactory().createEntityManager();
        try {
            // CORRECTION: Query simplifiée pour éviter les problèmes de lazy loading
            String jpql = """
                SELECT c FROM ContratLocation c 
                LEFT JOIN FETCH c.unite u
                LEFT JOIN FETCH u.immeuble i
                LEFT JOIN FETCH i.proprietaire p
                LEFT JOIN FETCH c.locataire l
                LEFT JOIN FETCH l.user lu
                ORDER BY c.id DESC
                """;

            return em.createQuery(jpql, ContratLocation.class).getResultList();
        } catch (Exception e) {
            System.err.println("Erreur dans getAll(): " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    @Override
    public ContratLocation get(int id) {
        EntityManager em = JPAUtil.getEntityManagerFactory().createEntityManager();
        try {
            String jpql = """
                SELECT c FROM ContratLocation c 
                LEFT JOIN FETCH c.unite u
                LEFT JOIN FETCH u.immeuble i
                LEFT JOIN FETCH i.proprietaire p
                LEFT JOIN FETCH c.locataire l
                LEFT JOIN FETCH l.user lu
                WHERE c.id = :id
                """;

            return em.createQuery(jpql, ContratLocation.class)
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

    /**
     * Récupère tous les contrats d'un locataire connecté (par son ID User)
     * CORRECTION: Chercher d'abord le Locataire correspondant à cet User
     */
    /**
     * Récupère tous les contrats d'un locataire connecté (par son ID User)
     * CORRECTION: Utiliser la même logique que dans DemandeLocationRepository
     */
    public List<ContratLocation> getByLocataireUserId(int currentUserId) {
        EntityManager em = JPAUtil.getEntityManagerFactory().createEntityManager();
        try {
            System.out.println("=== RECHERCHE CONTRATS POUR USER ID: " + currentUserId + " ===");

            // Étape 1: Récupérer tous les locataires (même logique que les demandes)
            LocataireRepository  locataireRepository = new LocataireRepository();
            List<Locataire> locataireList = locataireRepository.getAll();

            System.out.println("Nombre total de locataires trouvés: " + locataireList.size());

            // Étape 2: Trouver le locataire qui correspond au currentUserId
            Locataire locataireCorrespondant = null;
            for (Locataire locataire : locataireList) {
                System.out.println("  - Locataire ID: " + locataire.getId() +
                        ", User ID associé: " + (locataire.getUser() != null ? locataire.getUser().getId() : "null") +
                        ", Nom: " + (locataire.getUser() != null ? locataire.getUser().getNom() : "null"));

                if (locataire.getUser() != null && locataire.getUser().getId() == currentUserId) {
                    locataireCorrespondant = locataire;
                    System.out.println("  -> LOCATAIRE TROUVÉ: " + locataire.getId());
                    break;
                }
            }

            if (locataireCorrespondant == null) {
                System.out.println("AUCUN LOCATAIRE TROUVÉ pour le User ID: " + currentUserId);
                return new ArrayList<>();
            }

            // Étape 3: Récupérer tous les contrats pour ce locataire
            String jpql = """
            SELECT DISTINCT c FROM ContratLocation c
            LEFT JOIN FETCH c.unite u
            LEFT JOIN FETCH u.immeuble i
            LEFT JOIN FETCH i.proprietaire p
            LEFT JOIN FETCH c.locataire l
            LEFT JOIN FETCH l.user lu
            WHERE c.locataire.id = :locataireId
            ORDER BY c.id DESC
            """;

            List<ContratLocation> result = em.createQuery(jpql, ContratLocation.class)
                    .setParameter("locataireId", locataireCorrespondant.getId())
                    .getResultList();

            System.out.println("Nombre de contrats trouvés: " + result.size());

            // Debug: Afficher les détails
            for (ContratLocation c : result) {
                System.out.println("  - Contrat ID: " + c.getId() +
                        ", Statut: " + c.getStatut() +
                        ", Locataire: " + (c.getLocataire() != null && c.getLocataire().getUser() != null ?
                        c.getLocataire().getUser().getNom() : "null") +
                        ", User ID: " + (c.getLocataire() != null && c.getLocataire().getUser() != null ?
                        c.getLocataire().getUser().getId() : "null") +
                        ", Unité: " + (c.getUnite() != null ? c.getUnite().getNumeroUnite() : "null"));
            }

            return result;

        } catch (Exception e) {
            System.err.println("Erreur dans getByLocataireUserId(): " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    /**
     * Récupère tous les contrats d'un locataire (par son ID Locataire direct)
     */
    // Dans DemandeLocationRepository.java
// CORRIGER cette méthode :

    public List<DemandeLocation> getByLocataire(int userId) {
        EntityManager em = JPAUtil.getEntityManagerFactory().createEntityManager();
        try {
            System.out.println("=== RECHERCHE DEMANDES POUR USER ID: " + userId + " ===");

            // Étape 1: Récupérer tous les locataires (même logique que les contrats)
            LocataireRepository locataireRepository = new LocataireRepository();
            List<Locataire> locataireList = locataireRepository.getAll();

            System.out.println("Nombre total de locataires trouvés: " + locataireList.size());

            // Étape 2: Trouver le locataire qui correspond au userId
            Locataire locataireCorrespondant = null;
            for (Locataire locataire : locataireList) {
                System.out.println("  - Locataire ID: " + locataire.getId() +
                        ", User ID associé: " + (locataire.getUser() != null ? locataire.getUser().getId() : "null") +
                        ", Nom: " + (locataire.getUser() != null ? locataire.getUser().getNom() : "null"));

                if (locataire.getUser() != null && locataire.getUser().getId() == userId) {
                    locataireCorrespondant = locataire;
                    System.out.println("  -> LOCATAIRE TROUVÉ: " + locataire.getId());
                    break;
                }
            }

            if (locataireCorrespondant == null) {
                System.out.println("AUCUN LOCATAIRE TROUVÉ pour le User ID: " + userId);
                return new ArrayList<>();
            }

            // Étape 3: Récupérer toutes les demandes pour ce locataire
            String jpql = """
        SELECT DISTINCT d FROM DemandeLocation d
        LEFT JOIN FETCH d.locataire l
        LEFT JOIN FETCH l.user u
        LEFT JOIN FETCH d.uniteLocation ul
        LEFT JOIN FETCH ul.immeuble i
        LEFT JOIN FETCH i.proprietaire p
        WHERE d.locataire.id = :locataireId
        ORDER BY d.id DESC
        """;

            List<DemandeLocation> result = em.createQuery(jpql, DemandeLocation.class)
                    .setParameter("locataireId", locataireCorrespondant.getId())
                    .getResultList();

            System.out.println("Nombre de demandes trouvées: " + result.size());

            // Debug: Afficher les détails
            for (DemandeLocation d : result) {
                System.out.println("  - Demande ID: " + d.getId() +
                        ", Statut: " + d.getStatus() +
                        ", Locataire: " + (d.getLocataire() != null && d.getLocataire().getUser() != null ?
                        d.getLocataire().getUser().getNom() : "null") +
                        ", User ID: " + (d.getLocataire() != null && d.getLocataire().getUser() != null ?
                        d.getLocataire().getUser().getId() : "null") +
                        ", Unité: " + (d.getUniteLocation() != null ? d.getUniteLocation().getNumeroUnite() : "null"));
            }

            return result;

        } catch (Exception e) {
            System.err.println("Erreur dans getByLocataire(): " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }
    /**
     * Récupère tous les contrats des propriétés d'un propriétaire connecté
     */
    public List<ContratLocation> getByProprietaire(int proprietaireId) {
        EntityManager em = JPAUtil.getEntityManagerFactory().createEntityManager();
        try {
            String jpql = """
                SELECT c FROM ContratLocation c 
                LEFT JOIN FETCH c.unite u
                LEFT JOIN FETCH u.immeuble i
                LEFT JOIN FETCH i.proprietaire p
                LEFT JOIN FETCH c.locataire l
                LEFT JOIN FETCH l.user lu
                WHERE i.proprietaire.id = :proprietaireId 
                ORDER BY c.id DESC
                """;

            List<ContratLocation> result = em.createQuery(jpql, ContratLocation.class)
                    .setParameter("proprietaireId", proprietaireId)
                    .getResultList();

            System.out.println("getByProprietaire(" + proprietaireId + ") - Nombre de contrats: " + result.size());
            return result;

        } catch (Exception e) {
            System.err.println("Erreur dans getByProprietaire(): " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    /**
     * Récupère les contrats actifs d'un locataire
     */
    public List<ContratLocation> getContratsActifsByLocataire(int userId) {
        EntityManager em = JPAUtil.getEntityManagerFactory().createEntityManager();
        try {
            String jpql = """
                SELECT c FROM ContratLocation c 
                LEFT JOIN FETCH c.unite u
                LEFT JOIN FETCH u.immeuble i
                LEFT JOIN FETCH i.proprietaire p
                LEFT JOIN FETCH c.locataire l
                LEFT JOIN FETCH l.user lu
                WHERE l.user.id = :userId AND c.statut = 'ACTIF'
                ORDER BY c.dateDebut DESC
                """;

            return em.createQuery(jpql, ContratLocation.class)
                    .setParameter("userId", userId)
                    .getResultList();

        } catch (Exception e) {
            System.err.println("Erreur dans getContratsActifsByLocataire(): " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    /**
     * Récupère les contrats actifs des propriétés d'un propriétaire
     */
    public List<ContratLocation> getContratsActifsByProprietaire(int proprietaireId) {
        EntityManager em = JPAUtil.getEntityManagerFactory().createEntityManager();
        try {
            String jpql = """
                SELECT c FROM ContratLocation c 
                LEFT JOIN FETCH c.unite u
                LEFT JOIN FETCH u.immeuble i
                LEFT JOIN FETCH i.proprietaire p
                LEFT JOIN FETCH c.locataire l
                LEFT JOIN FETCH l.user lu
                WHERE i.proprietaire.id = :proprietaireId AND c.statut = 'ACTIF'
                ORDER BY c.dateDebut DESC
                """;

            return em.createQuery(jpql, ContratLocation.class)
                    .setParameter("proprietaireId", proprietaireId)
                    .getResultList();

        } catch (Exception e) {
            System.err.println("Erreur dans getContratsActifsByProprietaire(): " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    /**
     * Compte le nombre de contrats actifs d'un propriétaire
     */
    public long countContratsActifsByProprietaire(int proprietaireId) {
        EntityManager em = JPAUtil.getEntityManagerFactory().createEntityManager();
        try {
            return em.createQuery(
                            "SELECT COUNT(c) FROM ContratLocation c WHERE c.unite.immeuble.proprietaire.id = :proprietaireId AND c.statut = 'ACTIF'",
                            Long.class)
                    .setParameter("proprietaireId", proprietaireId)
                    .getSingleResult();
        } catch (Exception e) {
            System.err.println("Erreur dans countContratsActifsByProprietaire(): " + e.getMessage());
            return 0L;
        } finally {
            em.close();
        }
    }

    /**
     * Vérifie si un locataire a déjà un contrat actif
     */
    public boolean hasContratActif(int userId) {
        EntityManager em = JPAUtil.getEntityManagerFactory().createEntityManager();
        try {
            Long count = em.createQuery(
                            "SELECT COUNT(c) FROM ContratLocation c WHERE c.locataire.user.id = :userId AND c.statut = 'ACTIF'",
                            Long.class)
                    .setParameter("userId", userId)
                    .getSingleResult();

            return count > 0;
        } catch (Exception e) {
            System.err.println("Erreur dans hasContratActif(): " + e.getMessage());
            return false;
        } finally {
            em.close();
        }
    }

    public List<ContratLocation> search(String dateDebut) {
        EntityManager em = JPAUtil.getEntityManagerFactory().createEntityManager();
        try {
            List<ContratLocation> result = em.createQuery(
                            "SELECT c FROM ContratLocation c WHERE LOWER(c.dateDebut) LIKE CONCAT('%', LOWER(:dateDebut), '%')", ContratLocation.class)
                    .setParameter("dateDebut", dateDebut)
                    .getResultList();
            return result != null ? result : new ArrayList<>();
        } catch (Exception e) {
            System.err.println("Erreur lors de la recherche de contrat: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    /**
     * Ferme l'EntityManager principal (optionnel)
     */
    public void close() {
        if (entityManager != null && entityManager.isOpen()) {
            entityManager.close();
        }
    }
}