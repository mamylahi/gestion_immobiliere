package sn.isi.gestion_immobiliere.Dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import sn.isi.gestion_immobiliere.Entities.Locataire;
import sn.isi.gestion_immobiliere.Entities.User;
import sn.isi.gestion_immobiliere.Utils.JPAUtil;

import java.util.ArrayList;
import java.util.List;

public class UserRepository implements IRepository<User> {
    private EntityManager entityManager;

    public UserRepository() {
        this.entityManager = JPAUtil.getEntityManagerFactory().createEntityManager();
    }

    @Override
    public int add(User user) {
        try {
            entityManager.getTransaction().begin();
            entityManager.persist(user);
            entityManager.getTransaction().commit();
            return 1;
        } catch (Exception e) {
            if (entityManager.getTransaction().isActive()) {
                entityManager.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de l'ajout de l'utilisateur", e);
        }
    }

    @Override
    public int update(User user) {
        try {
            entityManager.getTransaction().begin();
            User db = entityManager.find(User.class, user.getId());
            if (db != null) {
                db.setNom(user.getNom());
                db.setPrenom(user.getPrenom());
                db.setEmail(user.getEmail());
                db.setMotDePasse(user.getMotDePasse());
                db.setRole(user.getRole());
                db.setTelephone(user.getTelephone());
                entityManager.merge(db);
            }
            entityManager.getTransaction().commit();
            return 1;
        } catch (Exception e) {
            if (entityManager.getTransaction().isActive()) {
                entityManager.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la mise à jour de l'utilisateur", e);
        }
    }

    @Override
    public int delete(int id) {
        try {
            entityManager.getTransaction().begin();
            User user = entityManager.find(User.class, id);
            if (user != null) {
                entityManager.remove(user);
            }
            entityManager.getTransaction().commit();
            return 1;
        } catch (Exception e) {
            if (entityManager.getTransaction().isActive()) {
                entityManager.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la suppression de l'utilisateur", e);
        }
    }

    @Override
    public List<User> getAll() {
        try {
            return entityManager.createQuery("FROM User", User.class).getResultList();
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }

    public List<User> getAllLocataire() {
        try {
            return entityManager.createQuery(
                            "SELECT u FROM User u WHERE u.role = :role", User.class)
                    .setParameter("role", "LOCATAIRE")
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace(); // utile pour debug
            return new ArrayList<>();
        }
    }

    @Override
    public User get(int id) {
        try {
            return entityManager.createQuery("SELECT u FROM User u WHERE u.id = :id", User.class)
                    .setParameter("id", id)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors de la récupération de l'utilisateur", e);
        }
    }
    public User getByEmail(String email) {
            try {
                return entityManager.createQuery("SELECT u FROM User u WHERE u.email = :email", User.class)
                        .setParameter("email", email)
                        .getSingleResult();
            } catch (NoResultException e) {
                return null;
            } catch (Exception e) {
                throw new RuntimeException("Erreur lors de la récupération de l'utilisateur", e);
            }
    }

    public List<User> search(String nom) {
        try {
            return entityManager.createQuery(
                            "SELECT u FROM User u WHERE LOWER(u.nom) LIKE CONCAT('%', LOWER(:nom), '%')", User.class)
                    .setParameter("nom", nom)
                    .getResultList();
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }

    public User login(String email, String motDePasse) {
        try {
            return entityManager.createQuery("SELECT l FROM User l WHERE l.email = :email AND l.motDePasse = :mdp", User.class)
                    .setParameter("email", email)
                    .setParameter("mdp", motDePasse)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

}
