package sn.isi.gestion_immobiliere.Dao;

import jakarta.persistence.EntityManager;
import sn.isi.gestion_immobiliere.Utils.JPAUtil;
import sn.isi.gestion_immobiliere.Entities.Paiement;

import java.util.ArrayList;
import java.util.List;

public class PaiementRepository implements IRepository<Paiement> {
    EntityManager entityManager;

    public PaiementRepository() {
        this.entityManager = JPAUtil.getEntityManagerFactory().createEntityManager();
    }

    @Override
    public int add(Paiement paiement) {
        try {
            entityManager.getTransaction().begin();
            entityManager.persist(paiement);
            entityManager.getTransaction().commit();
            return paiement.getId(); // Retourner l'ID généré
        } catch (Exception e) {
            if (entityManager.getTransaction().isActive()) {
                entityManager.getTransaction().rollback();
            }
            System.err.println("Erreur lors de l'ajout du paiement: " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public int update(Paiement paiement) {
        try {
            entityManager.getTransaction().begin();
            Paiement db = entityManager.find(Paiement.class, paiement.getId());
            if (db != null) {
                db.setDatePaiement(paiement.getDatePaiement());
                db.setMontant(paiement.getMontant());
                db.setStatut(paiement.getStatut());
                db.setMethodePaiement(paiement.getMethodePaiement());
                db.setContrat(paiement.getContrat());
                entityManager.getTransaction().commit();
                return 1;
            } else {
                entityManager.getTransaction().rollback();
                return 0;
            }
        } catch (Exception e) {
            if (entityManager.getTransaction().isActive()) {
                entityManager.getTransaction().rollback();
            }
            System.err.println("Erreur lors de la mise à jour du paiement: " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public int delete(int id) {
        try {
            entityManager.getTransaction().begin();
            Paiement paiement = entityManager.find(Paiement.class, id);
            if (paiement != null) {
                entityManager.remove(paiement);
                entityManager.getTransaction().commit();
                return 1;
            } else {
                entityManager.getTransaction().rollback();
                return 0;
            }
        } catch (Exception e) {
            if (entityManager.getTransaction().isActive()) {
                entityManager.getTransaction().rollback();
            }
            System.err.println("Erreur lors de la suppression du paiement: " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public List<Paiement> getAll() {
        try {
            entityManager.getTransaction().begin();
            List<Paiement> resultat = entityManager.createQuery(
                    "SELECT p FROM Paiement p LEFT JOIN FETCH p.contrat c LEFT JOIN FETCH c.unite u LEFT JOIN FETCH u.immeuble",
                    Paiement.class
            ).getResultList();
            entityManager.getTransaction().commit();
            return resultat;
        } catch (Exception e) {
            if (entityManager.getTransaction().isActive()) {
                entityManager.getTransaction().rollback();
            }
            System.err.println("Erreur lors de la récupération des paiements: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    @Override
    public Paiement get(int id) {
        try {
            return entityManager.createQuery(
                    "SELECT p FROM Paiement p LEFT JOIN FETCH p.contrat c LEFT JOIN FETCH c.unite u LEFT JOIN FETCH u.immeuble WHERE p.id = :id",
                    Paiement.class
            ).setParameter("id", id).getSingleResult();
        } catch (Exception e) {
            System.err.println("Erreur lors de la récupération du paiement " + id + ": " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Récupère les paiements pour un contrat spécifique
     */
    public List<Paiement> getByContrat(int contratId) {
        try {
            return entityManager.createQuery(
                    "SELECT p FROM Paiement p WHERE p.contrat.id = :contratId ORDER BY p.datePaiement DESC",
                    Paiement.class
            ).setParameter("contratId", contratId).getResultList();
        } catch (Exception e) {
            System.err.println("Erreur lors de la récupération des paiements pour le contrat " + contratId + ": " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    /**
     * Récupère les paiements récents (limité)
     */
    public List<Paiement> getRecent(int limit) {
        try {
            return entityManager.createQuery(
                    "SELECT p FROM Paiement p LEFT JOIN FETCH p.contrat c LEFT JOIN FETCH c.unite u LEFT JOIN FETCH u.immeuble ORDER BY p.datePaiement DESC",
                    Paiement.class
            ).setMaxResults(limit).getResultList();
        } catch (Exception e) {
            System.err.println("Erreur lors de la récupération des paiements récents: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
}