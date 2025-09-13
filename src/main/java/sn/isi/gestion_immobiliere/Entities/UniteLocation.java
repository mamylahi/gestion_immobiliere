package sn.isi.gestion_immobiliere.Entities;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Entity
@Table(name = "unite_location")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class UniteLocation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "numero_unite", nullable = false)
    private int numeroUnite;

    @Column(name = "nombre_piece", nullable = false)
    private int nombrePiece;

    @Column(name = "superficie", nullable = false)
    private Double superficie;

    @Column(name = "loyer_mensuel", nullable = false)
    private Double loyerMensuel;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "immeuble_id", nullable = false)
    @ToString.Exclude
    private Immeuble immeuble;

    @Column(name = "image")
    private String image;

    public UniteLocation(int numeroUnite, int nombrePiece, Double superficie, Double loyerMensuel, Immeuble immeuble) {
        this.numeroUnite = numeroUnite;
        this.nombrePiece = nombrePiece;
        this.superficie = superficie;
        this.loyerMensuel = loyerMensuel;
        this.immeuble = immeuble;
    }
}
