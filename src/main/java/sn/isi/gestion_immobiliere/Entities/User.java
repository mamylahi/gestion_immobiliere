package sn.isi.gestion_immobiliere.Entities;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "users")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Inheritance(strategy = InheritanceType.JOINED)
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(nullable = false, length = 100)
    private String nom;

    @Column(nullable = false, length = 100)
    private String prenom;

    @Column(nullable = false, unique = false, length = 150)
    private String email;

    @Column(nullable = false)
    private String motDePasse;

    @Column(nullable = false, length = 20)
    private String role; // "ADMIN", "PROPRIETAIRE", "LOCATAIRE"

    @Column(length = 20)
    private String telephone;

    public User(String nom, String prenom, String email, String motDePasse, String role, String telephone) {
        this.nom = nom;
        this.prenom = prenom;
        this.email = email;
        this.motDePasse = motDePasse;
        this.role = role;
        this.telephone = telephone;
    }
}
