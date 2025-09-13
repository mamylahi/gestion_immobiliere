package sn.isi.gestion_immobiliere.Dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import sn.isi.gestion_immobiliere.Entities.User;
import sn.isi.gestion_immobiliere.Utils.JPAUtil;
import sn.isi.gestion_immobiliere.Entities.Immeuble;

import java.util.ArrayList;
import java.util.List;

public class ImmeubleRepository implements IRepository<Immeuble> {
    private EntityManager entityManager;

    public ImmeubleRepository() {
        this.entityManager = JPAUtil.getEntityManagerFactory().createEntityManager();
    }

    @Override
    public int add(Immeuble immeuble) {
        try {
            entityManager.getTransaction().begin();
            entityManager.persist(immeuble);
            entityManager.getTransaction().commit();
            return 1;
        } catch (Exception e) {
            if (entityManager.getTransaction().isActive()) {
                entityManager.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de l'ajout de l'immeuble", e);
        }
    }

    @Override
    public int update(Immeuble immeuble) {
        try {
            entityManager.getTransaction().begin();
            Immeuble db = entityManager.find(Immeuble.class, immeuble.getId());
            if (db != null) {
                db.setNom(immeuble.getNom());
                db.setAdresse(immeuble.getAdresse());
                db.setDescription(immeuble.getDescription());
                db.setEquipements(immeuble.getEquipements());
                db.setNombreUnite(immeuble.getNombreUnite());
                // AJOUT: Mise à jour de l'image
                db.setImage(immeuble.getImage());
                if (immeuble.getUnites() != null) {
                    db.setUnites(immeuble.getUnites());
                }
                entityManager.merge(db);
            }
            entityManager.getTransaction().commit();
            return 1;
        } catch (Exception e) {
            if (entityManager.getTransaction().isActive()) {
                entityManager.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la mise à jour de l'immeuble", e);
        }
    }
    @Override
    public int delete(int id) {
        try {
            entityManager.getTransaction().begin();
            Immeuble immeuble = entityManager.find(Immeuble.class, id);
            if (immeuble != null) {
                entityManager.remove(immeuble);
            }
            entityManager.getTransaction().commit();
            return 1;
        } catch (Exception e) {
            if (entityManager.getTransaction().isActive()) {
                entityManager.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la suppression de l'immeuble", e);
        }
    }

    @Override
    public List<Immeuble> getAll() {
        try {
            // Correction: Pas besoin de transaction pour une lecture
            List<Immeuble> resultat = entityManager.createQuery("FROM Immeuble", Immeuble.class).getResultList();
            return resultat != null ? resultat : new ArrayList<>();
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors de la récupération de tous les immeubles", e);
        }
    }

    public List<Immeuble> getByProprietaire(int proprietaireId) {
        try {
            List<Immeuble> resultat = entityManager.createQuery(
                            "FROM Immeuble i WHERE i.proprietaire.id = :proprietaireId",
                            Immeuble.class)
                    .setParameter("proprietaireId", proprietaireId)
                    .getResultList();
            return resultat != null ? resultat : new ArrayList<>();
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors de la récupération des immeubles du propriétaire", e);
        }
    }

    @Override
    public Immeuble get(int id) {
        try {
            Immeuble immeuble = entityManager.createQuery("SELECT i FROM Immeuble i WHERE i.id = :id", Immeuble.class)
                    .setParameter("id", id)
                    .getSingleResult();
            return immeuble;
        } catch (NoResultException e) {
            return null; // Retourner null si aucun résultat trouvé
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors de la récupération de l'immeuble avec l'ID: " + id, e);
        }
    }

    public List<Immeuble> search(String nom) {
        try {
            List<Immeuble> result = entityManager.createQuery(
                            "SELECT i FROM Immeuble i WHERE LOWER(i.nom) LIKE CONCAT('%', LOWER(:nom), '%')", Immeuble.class)
                    .setParameter("nom", nom)
                    .getResultList();
            return result != null ? result : new ArrayList<>();
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors de la recherche d'immeubles", e);
        }
    }

    // Méthode pour fermer l'EntityManager
    public void close() {
        if (entityManager != null && entityManager.isOpen()) {
            entityManager.close();
        }
    }

    public User getProprietaireImmeuble(int id) {
         User user = entityManager.find(User.class, id);
         return user;
    }
}