package sn.isi.gestion_immobiliere.Entities;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.time.LocalDate;
import java.util.List;

@Entity
@Table(name = "contrats_location")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ContratLocation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(nullable = false)
    private LocalDate dateDebut;

    @Column(nullable = false)
    private LocalDate dateFin;

    @Column(nullable = false)
    private Double caution;

    @Column(nullable = false, length = 20)
    private String statut; // "ACTIF", "RESILIE", "TERMINE"


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "unite_id", nullable = false)
    private UniteLocation unite;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "locataire_id", nullable = false)
    private Locataire locataire;

    @OneToMany(mappedBy = "contrat", cascade = CascadeType.ALL, orphanRemoval = true)
    @ToString.Exclude
    private List<Paiement> paiements;

    public ContratLocation( LocalDate dateDebut, LocalDate dateFin, Double caution, String statut, UniteLocation unite, Locataire locataire, List<Paiement> paiements) {
        this.dateDebut = dateDebut;
        this.dateFin = dateFin;
        this.caution = caution;
        this.statut = statut;
        this.unite = unite;
        this.locataire = locataire;
        this.paiements = paiements;
    }
}
