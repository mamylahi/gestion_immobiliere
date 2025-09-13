package sn.isi.gestion_immobiliere.Entities;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "locataires")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Locataire{

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;


    private String profession;
    private String adresse;
    private int idUser;
    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    public Locataire(String profession, String adresse, int idUser, User user) {
        this.profession = profession;
        this.adresse = adresse;
        this.idUser = idUser;
        this.user = user;
    }
}
