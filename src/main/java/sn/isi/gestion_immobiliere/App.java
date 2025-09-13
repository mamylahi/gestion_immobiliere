package sn.isi.gestion_immobiliere;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import sn.isi.gestion_immobiliere.Utils.JPAUtil;


public class App {
    public static void main(String[] args) {
        EntityManagerFactory entityManagerFactory = JPAUtil.getEntityManagerFactory();
        EntityManager entityManager = entityManagerFactory.createEntityManager();

    }
}
