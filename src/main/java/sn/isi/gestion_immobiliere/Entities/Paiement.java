package sn.isi.gestion_immobiliere.Entities;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.time.LocalDate;

@Entity
@Table(name = "paiements")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Paiement {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(nullable = false)
    private LocalDate datePaiement;

    @Column(nullable = false)
    private Double montant;

    @Column(nullable = false, length = 20)
    private String statut; // "PAYE", "EN_RETARD", "EN_ATTENTE"

    @Column(length = 100)
    private String methodePaiement; // "Orange Money", "Wave", "Carte Bancaire", etc.

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "contrat_id", nullable = false)
    @ToString.Exclude
    private ContratLocation contrat;

    public Paiement(LocalDate datePaiement, Double montant, String statut, ContratLocation contrat) {
        this.datePaiement = datePaiement;
        this.montant = montant;
        this.statut = statut;
        this.contrat = contrat;
    }

    public Paiement(LocalDate datePaiement, Double montant, String statut, String methodePaiement, ContratLocation contrat) {
        this.datePaiement = datePaiement;
        this.montant = montant;
        this.statut = statut;
        this.methodePaiement = methodePaiement;
        this.contrat = contrat;
    }
}