package sn.isi.gestion_immobiliere.Dao;

import jakarta.persistence.EntityManager;
import sn.isi.gestion_immobiliere.Utils.JPAUtil;
import sn.isi.gestion_immobiliere.Entities.UniteLocation;

import java.util.ArrayList;
import java.util.List;

public class UniteLocationRepository implements IRepository<UniteLocation> {
    EntityManager entityManager;

    public UniteLocationRepository() {
        this.entityManager = JPAUtil.getEntityManagerFactory().createEntityManager();
    }

    @Override
    public int add(UniteLocation unite) {
        entityManager.getTransaction().begin();
        entityManager.persist(unite);
        entityManager.getTransaction().commit();
        return 1;
    }

    @Override
    public int update(UniteLocation unite) {
        entityManager.getTransaction().begin();
        UniteLocation db = entityManager.find(UniteLocation.class, unite.getId());
        if (db != null) {
            db.setNumeroUnite(unite.getNumeroUnite());
            db.setNombrePiece(unite.getNombrePiece());
            db.setSuperficie(unite.getSuperficie());
            db.setLoyerMensuel(unite.getLoyerMensuel());
            db.setImmeuble(unite.getImmeuble());
        }
        entityManager.getTransaction().commit();
        return 1;
    }

    @Override
    public int delete(int id) {
        entityManager.getTransaction().begin();
        UniteLocation unite = entityManager.find(UniteLocation.class, id);
        if (unite != null) {
            entityManager.remove(unite);
        }
        entityManager.getTransaction().commit();
        return 1;
    }

    @Override
    public List<UniteLocation> getAll() {
        List<UniteLocation> list = new ArrayList<>();
        entityManager.getTransaction().begin();
        List<UniteLocation> resultat = entityManager.createQuery("FROM UniteLocation", UniteLocation.class).getResultList();
        entityManager.getTransaction().commit();
        list.addAll(resultat);
        return list;
    }

    public List<UniteLocation> search(String numeroUnite) {
        try {
            List<UniteLocation> result = entityManager.createQuery(
                            "SELECT u FROM UniteLocation u WHERE CAST(u.numeroUnite AS string) LIKE CONCAT('%', :numeroUnite, '%')", UniteLocation.class)
                    .setParameter("numeroUnite", numeroUnite)
                    .getResultList();
            return result != null ? result : new ArrayList<>();
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors de la recherche d'unités", e);
        }
    }

    @Override
    public UniteLocation get(int id) {
        return entityManager.createQuery("SELECT u FROM UniteLocation u WHERE u.id = :id", UniteLocation.class)
                .setParameter("id", id)
                .getSingleResult();
    }

    public List<UniteLocation> getByProprietaire(int proprietaireId) {
        try {
            List<UniteLocation> resultat = entityManager.createQuery(
                            "FROM UniteLocation u WHERE u.immeuble.proprietaire.id = :proprietaireId",
                            UniteLocation.class)
                    .setParameter("proprietaireId", proprietaireId)
                    .getResultList();
            return resultat != null ? resultat : new ArrayList<>();
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors de la récupération des unités du propriétaire", e);
        }
    }
}
