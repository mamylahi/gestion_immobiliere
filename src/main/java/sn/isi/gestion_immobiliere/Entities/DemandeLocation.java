package sn.isi.gestion_immobiliere.Entities;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.awt.*;

@Entity
@Table(name = "demande_location")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class DemandeLocation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private Locataire locataire;

    @ManyToOne
    @JoinColumn(name = "unite_location_id")
    @ToString.Exclude
    private UniteLocation uniteLocation;

    @Column(nullable = false, length = 20)
    private String status; // "EN_ATTENTE", "ACCEPTE", "REJETE"

    @Column(nullable = true, length = 500)
    private String motif;

    public DemandeLocation(Locataire locataire, UniteLocation uniteLocation, String status, String motif) {
        this.locataire = locataire;
        this.uniteLocation = uniteLocation;
        this.status = status;
        this.motif = motif;
    }
}
