package sn.isi.gestion_immobiliere.Dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import sn.isi.gestion_immobiliere.Entities.User;
import sn.isi.gestion_immobiliere.Utils.JPAUtil;
import sn.isi.gestion_immobiliere.Entities.Locataire;

import java.util.ArrayList;
import java.util.List;

public class LocataireRepository implements IRepository<Locataire> {
    EntityManager entityManager;

    public LocataireRepository() {
        this.entityManager = JPAUtil.getEntityManagerFactory().createEntityManager();
    }

    @Override
    public int add(Locataire locataire) {
        entityManager.getTransaction().begin();
        entityManager.persist(locataire);
        entityManager.getTransaction().commit();
        return 1;
    }

    @Override
    public int update(Locataire locataire) {
        entityManager.getTransaction().begin();
        Locataire db = entityManager.find(Locataire.class, locataire.getId());
        if (db != null) {

            db.setAdresse(locataire.getAdresse());
            db.setProfession(locataire.getProfession());
        }
        entityManager.getTransaction().commit();
        return 1;
    }

    @Override
    public int delete(int id) {
        entityManager.getTransaction().begin();
        Locataire locataire = entityManager.find(Locataire.class, id);
        if (locataire != null) {
            entityManager.remove(locataire);
        }
        entityManager.getTransaction().commit();
        return 1;
    }

    @Override
    public List<Locataire> getAll() {
        try {
            return entityManager.createQuery("FROM Locataire ", Locataire.class).getResultList();
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }

    @Override
    public Locataire get(int id) {
        return entityManager.createQuery("SELECT l FROM Locataire l WHERE l.id = :id", Locataire.class)
                .setParameter("id", id)
                .getSingleResult();
    }
    public void register(Locataire locataire) {
        try {
            entityManager.getTransaction().begin();
            entityManager.persist(locataire);
            entityManager.getTransaction().commit();
        } catch (Exception e) {
            if (entityManager.getTransaction().isActive()) entityManager.getTransaction().rollback();
            throw new RuntimeException("Erreur inscription locataire", e);
        }
    }



}
