package sn.isi.gestion_immobiliere.Utils;

import javax.mail.*;
import javax.mail.internet.*;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.util.Properties;
import java.util.Date;

import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Table;
import com.itextpdf.layout.element.Cell;
import com.itextpdf.layout.properties.TextAlignment;
import com.itextpdf.kernel.colors.ColorConstants;
import com.itextpdf.kernel.font.PdfFont;
import com.itextpdf.kernel.font.PdfFontFactory;
import com.itextpdf.io.font.constants.StandardFonts;

import sn.isi.gestion_immobiliere.Entities.ContratLocation;
import sn.isi.gestion_immobiliere.Utils.EmailConfig;

public class EmailService {

    /**
     * Envoie le contrat PDF par email au locataire
     */
    public boolean envoyerContratPDF(ContratLocation contrat) {
        try {
            System.out.println("=== DEBUT ENVOI EMAIL CONTRAT ===");
            System.out.println("Contrat ID: " + contrat.getId());

            // Vérifier la configuration email
            if (!EmailConfig.isConfigurationValid()) {
                System.err.println("Configuration email invalide");
                EmailConfig.printConfiguration();
                return false;
            }

            if (contrat.getLocataire() == null || contrat.getLocataire().getUser() == null) {
                System.err.println("Locataire ou utilisateur manquant");
                return false;
            }

            String emailDestinataire = contrat.getLocataire().getUser().getEmail();
            String nomLocataire = contrat.getLocataire().getUser().getPrenom() + " " + contrat.getLocataire().getUser().getNom();

            System.out.println("Email destinataire: " + emailDestinataire);
            System.out.println("Nom locataire: " + nomLocataire);

            // Générer le PDF du contrat
            byte[] pdfBytes = genererContratPDF(contrat);

            if (pdfBytes == null) {
                System.err.println("Erreur lors de la génération du PDF");
                return false;
            }

            // Utiliser la configuration centralisée
            Properties props = EmailConfig.getSmtpProperties();

            // Créer la session avec authentification
            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(EmailConfig.getEmailUsername(), EmailConfig.getEmailPassword());
                }
            });

            // Créer le message
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EmailConfig.getEmailUsername(), EmailConfig.getFromName()));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(emailDestinataire));
            message.setSubject("Votre Contrat de Location - Ref: " + contrat.getId());
            message.setSentDate(new Date());

            // Créer le contenu multipart
            Multipart multipart = new MimeMultipart();

            // Partie texte de l'email
            BodyPart messageBodyPart = new MimeBodyPart();
            String contenuEmail = creerContenuEmail(contrat, nomLocataire);
            messageBodyPart.setContent(contenuEmail, "text/html; charset=utf-8");
            multipart.addBodyPart(messageBodyPart);

            // Partie pièce jointe PDF
            messageBodyPart = new MimeBodyPart();
            messageBodyPart.setDataHandler(new javax.activation.DataHandler(
                    new javax.mail.util.ByteArrayDataSource(pdfBytes, "application/pdf")));
            messageBodyPart.setFileName("Contrat_Location_" + contrat.getId() + ".pdf");
            multipart.addBodyPart(messageBodyPart);

            // Attacher le contenu au message
            message.setContent(multipart);

            // Envoyer l'email
            Transport.send(message);

            System.out.println("Email envoyé avec succès à: " + emailDestinataire);
            return true;

        } catch (Exception e) {
            System.err.println("Erreur lors de l'envoi de l'email: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Génère le PDF du contrat de location
     */
    private byte[] genererContratPDF(ContratLocation contrat) {
        try {
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            PdfWriter writer = new PdfWriter(baos);
            PdfDocument pdf = new PdfDocument(writer);
            Document document = new Document(pdf);

            // Police
            PdfFont font = PdfFontFactory.createFont(StandardFonts.HELVETICA);
            PdfFont boldFont = PdfFontFactory.createFont(StandardFonts.HELVETICA_BOLD);

            // En-tête du document
            Paragraph titre = new Paragraph("CONTRAT DE LOCATION")
                    .setFont(boldFont)
                    .setFontSize(20)
                    .setTextAlignment(TextAlignment.CENTER)
                    .setMarginBottom(20);
            document.add(titre);

            Paragraph refContrat = new Paragraph("Référence: CONTRAT-" + contrat.getId())
                    .setFont(boldFont)
                    .setFontSize(12)
                    .setTextAlignment(TextAlignment.CENTER)
                    .setMarginBottom(30);
            document.add(refContrat);

            // Informations des parties
            document.add(new Paragraph("ENTRE LES SOUSSIGNÉS :").setFont(boldFont).setFontSize(14));

            // Propriétaire
            if (contrat.getUnite() != null && contrat.getUnite().getImmeuble() != null &&
                    contrat.getUnite().getImmeuble().getProprietaire() != null) {

                var proprietaire = contrat.getUnite().getImmeuble().getProprietaire();
                document.add(new Paragraph("\nLE BAILLEUR :").setFont(boldFont));
                document.add(new Paragraph("Nom: " + proprietaire.getPrenom() + " " + proprietaire.getNom()).setFont(font));
                document.add(new Paragraph("Email: " + proprietaire.getEmail()).setFont(font));
                document.add(new Paragraph("Téléphone: " + proprietaire.getTelephone()).setFont(font));
            }

            // Locataire
            if (contrat.getLocataire() != null && contrat.getLocataire().getUser() != null) {
                var locataire = contrat.getLocataire().getUser();
                document.add(new Paragraph("\nLE LOCATAIRE :").setFont(boldFont));
                document.add(new Paragraph("Nom: " + locataire.getPrenom() + " " + locataire.getNom()).setFont(font));
                document.add(new Paragraph("Email: " + locataire.getEmail()).setFont(font));
                document.add(new Paragraph("Téléphone: " + locataire.getTelephone()).setFont(font));
                document.add(new Paragraph("Profession: " + (contrat.getLocataire().getProfession() != null ?
                        contrat.getLocataire().getProfession() : "Non renseignée")).setFont(font));
            }

            // Objet du contrat
            document.add(new Paragraph("\nOBJET DU CONTRAT").setFont(boldFont).setFontSize(14).setMarginTop(20));

            if (contrat.getUnite() != null) {
                var unite = contrat.getUnite();
                document.add(new Paragraph("Le présent contrat a pour objet la location de l'unité suivante :").setFont(font));
                document.add(new Paragraph("Numéro d'unité: " + unite.getNumeroUnite()).setFont(font));
                document.add(new Paragraph("Nombre de pièces: " + unite.getNombrePiece()).setFont(font));
                document.add(new Paragraph("Superficie: " + unite.getSuperficie() + " m²").setFont(font));

                if (unite.getImmeuble() != null) {
                    document.add(new Paragraph("Immeuble: " + unite.getImmeuble().getNom()).setFont(font));
                    document.add(new Paragraph("Adresse: " + unite.getImmeuble().getAdresse()).setFont(font));
                }
            }

            // Conditions financières et durée
            document.add(new Paragraph("\nCONDITIONS FINANCIÈRES ET DURÉE").setFont(boldFont).setFontSize(14).setMarginTop(20));

            // Créer un tableau pour les conditions
            Table table = new Table(2);
            table.setWidth(100);

            // En-têtes
            table.addCell(new Cell().add(new Paragraph("Élément").setFont(boldFont)).setBackgroundColor(ColorConstants.LIGHT_GRAY));
            table.addCell(new Cell().add(new Paragraph("Valeur").setFont(boldFont)).setBackgroundColor(ColorConstants.LIGHT_GRAY));

            // Données
            table.addCell(new Cell().add(new Paragraph("Date de début").setFont(font)));
            table.addCell(new Cell().add(new Paragraph(contrat.getDateDebut().toString()).setFont(font)));

            table.addCell(new Cell().add(new Paragraph("Date de fin").setFont(font)));
            table.addCell(new Cell().add(new Paragraph(contrat.getDateFin().toString()).setFont(font)));

            if (contrat.getUnite() != null && contrat.getUnite().getLoyerMensuel() != null) {
                table.addCell(new Cell().add(new Paragraph("Loyer mensuel").setFont(font)));
                table.addCell(new Cell().add(new Paragraph(String.format("%,.0f FCFA", contrat.getUnite().getLoyerMensuel())).setFont(font)));
            }

            table.addCell(new Cell().add(new Paragraph("Caution").setFont(font)));
            table.addCell(new Cell().add(new Paragraph(String.format("%,.0f FCFA", contrat.getCaution())).setFont(font)));

            table.addCell(new Cell().add(new Paragraph("Statut").setFont(font)));
            table.addCell(new Cell().add(new Paragraph(contrat.getStatut()).setFont(font)));

            document.add(table);

            // Clauses générales
            document.add(new Paragraph("\nCLAUSES GÉNÉRALES").setFont(boldFont).setFontSize(14).setMarginTop(20));
            document.add(new Paragraph("1. Le loyer est payable mensuellement à terme échu.").setFont(font));
            document.add(new Paragraph("2. Le locataire s'engage à occuper paisiblement les lieux loués.").setFont(font));
            document.add(new Paragraph("3. Toute transformation des lieux loués est interdite sans accord écrit du bailleur.").setFont(font));
            document.add(new Paragraph("4. En cas de retard de paiement, des pénalités pourront être appliquées.").setFont(font));

            // Signatures
            document.add(new Paragraph("\nSIGNATURES").setFont(boldFont).setFontSize(14).setMarginTop(30));

            Table signaturesTable = new Table(2);
            signaturesTable.setWidth(100);

            signaturesTable.addCell(new Cell().add(new Paragraph("Le Bailleur").setFont(boldFont)).setBorder(null));
            signaturesTable.addCell(new Cell().add(new Paragraph("Le Locataire").setFont(boldFont)).setBorder(null));

            signaturesTable.addCell(new Cell().add(new Paragraph("\n\n\n_________________").setFont(font)).setBorder(null));
            signaturesTable.addCell(new Cell().add(new Paragraph("\n\n\n_________________").setFont(font)).setBorder(null));

            document.add(signaturesTable);

            // Date de génération
            document.add(new Paragraph("\nDocument généré le: " + new Date().toString())
                    .setFont(font)
                    .setFontSize(10)
                    .setTextAlignment(TextAlignment.RIGHT)
                    .setMarginTop(20));

            document.close();

            return baos.toByteArray();

        } catch (Exception e) {
            System.err.println("Erreur lors de la génération du PDF: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Crée le contenu HTML de l'email
     */
    private String creerContenuEmail(ContratLocation contrat, String nomLocataire) {
        StringBuilder html = new StringBuilder();

        html.append("<!DOCTYPE html>");
        html.append("<html><head><meta charset='UTF-8'></head><body>");
        html.append("<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;'>");

        // En-tête
        html.append("<div style='background-color: #007bff; color: white; padding: 20px; text-align: center;'>");
        html.append("<h1>Gestion Immobilière</h1>");
        html.append("<h2>Votre Contrat de Location</h2>");
        html.append("</div>");

        // Contenu principal
        html.append("<div style='padding: 20px; background-color: #f8f9fa;'>");
        html.append("<p>Bonjour <strong>").append(nomLocataire).append("</strong>,</p>");

        html.append("<p>Nous avons le plaisir de vous adresser votre contrat de location pour l'unité suivante :</p>");

        if (contrat.getUnite() != null) {
            html.append("<div style='background-color: white; padding: 15px; border-radius: 5px; margin: 15px 0;'>");
            html.append("<h3 style='color: #007bff; margin-top: 0;'>Détails de l'unité</h3>");
            html.append("<p><strong>Numéro d'unité :</strong> ").append(contrat.getUnite().getNumeroUnite()).append("</p>");
            html.append("<p><strong>Superficie :</strong> ").append(contrat.getUnite().getSuperficie()).append(" m²</p>");
            html.append("<p><strong>Nombre de pièces :</strong> ").append(contrat.getUnite().getNombrePiece()).append("</p>");

            if (contrat.getUnite().getImmeuble() != null) {
                html.append("<p><strong>Immeuble :</strong> ").append(contrat.getUnite().getImmeuble().getNom()).append("</p>");
                html.append("<p><strong>Adresse :</strong> ").append(contrat.getUnite().getImmeuble().getAdresse()).append("</p>");
            }
        }

        html.append("</div>");

        // Informations contractuelles
        html.append("<div style='background-color: white; padding: 15px; border-radius: 5px; margin: 15px 0;'>");
        html.append("<h3 style='color: #007bff; margin-top: 0;'>Informations contractuelles</h3>");
        html.append("<p><strong>Référence contrat :</strong> CONTRAT-").append(contrat.getId()).append("</p>");
        html.append("<p><strong>Période :</strong> Du ").append(contrat.getDateDebut()).append(" au ").append(contrat.getDateFin()).append("</p>");

        if (contrat.getUnite() != null && contrat.getUnite().getLoyerMensuel() != null) {
            html.append("<p><strong>Loyer mensuel :</strong> ").append(String.format("%,.0f FCFA", contrat.getUnite().getLoyerMensuel())).append("</p>");
        }

        html.append("<p><strong>Caution :</strong> ").append(String.format("%,.0f FCFA", contrat.getCaution())).append("</p>");
        html.append("</div>");

        html.append("<p>Veuillez trouver en pièce jointe votre contrat de location au format PDF.</p>");
        html.append("<p>Pour toute question, n'hésitez pas à nous contacter.</p>");

        html.append("<div style='margin-top: 30px; padding-top: 20px; border-top: 1px solid #ddd;'>");
        html.append("<p style='color: #666; font-size: 12px;'>Cordialement,<br>L'équipe Gestion Immobilière</p>");
        html.append("</div>");

        html.append("</div>");
        html.append("</div>");
        html.append("</body></html>");

        return html.toString();
    }
}