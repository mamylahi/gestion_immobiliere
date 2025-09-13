package sn.isi.gestion_immobiliere.Entities;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.util.List;

@Entity
@Table(name = "immeubles")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Immeuble {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(nullable = false, length = 100)
    private String nom;

    @Column(nullable = false, length = 200)
    private String adresse;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(name = "equipements", length = 255)
    private String equipements;

    @Column(name = "nombre_unite")
    private int nombreUnite;

    @OneToMany(mappedBy = "immeuble", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @ToString.Exclude  // Exclude from toString to prevent circular reference
    private List<UniteLocation> unites;

    @ManyToOne
    @JoinColumn(name = "proprietaire_id")
    private User proprietaire;

    @Column(name = "image")
    private String image;

    public Immeuble(String nom, String adresse, String description, String equipements, int nombreUnite, User proprietaire, String image) {
        this.nom = nom;
        this.adresse = adresse;
        this.description = description;
        this.equipements = equipements;
        this.nombreUnite = nombreUnite;
        this.proprietaire = proprietaire;
        this.image = image;
    }

    public Immeuble(String nom, String adresse, String description, String equipements, int nombreUnite, User proprietaire) {
        this.nom = nom;
        this.adresse = adresse;
        this.description = description;
        this.equipements = equipements;
        this.nombreUnite = nombreUnite;
        this.proprietaire = proprietaire;
        this.image = null;
    }
}