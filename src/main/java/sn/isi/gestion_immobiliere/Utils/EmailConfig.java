package sn.isi.gestion_immobiliere.Utils;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * Configuration centralisée pour l'envoi d'emails
 */
public class EmailConfig {

    private static final String CONFIG_FILE = "email.properties";
    private static Properties properties;

    static {
        loadProperties();
    }

    private static void loadProperties() {
        properties = new Properties();
        try (InputStream input = EmailConfig.class.getClassLoader().getResourceAsStream(CONFIG_FILE)) {
            if (input != null) {
                properties.load(input);
                System.out.println("Configuration email chargée depuis " + CONFIG_FILE);
            } else {
                // Configuration par défaut si le fichier n'existe pas
                setDefaultProperties();
                System.out.println("Fichier de configuration email non trouvé, utilisation des valeurs par défaut");
            }
        } catch (IOException e) {
            System.err.println("Erreur lors du chargement de la configuration email: " + e.getMessage());
            setDefaultProperties();
        }
    }

    private static void setDefaultProperties() {
        // Configuration par défaut (à modifier selon vos besoins)
        properties.setProperty("smtp.host", "smtp.gmail.com");
        properties.setProperty("smtp.port", "587");
        properties.setProperty("smtp.auth", "true");
        properties.setProperty("smtp.starttls.enable", "true");
        properties.setProperty("smtp.ssl.protocols", "TLSv1.2");

        // Paramètres à configurer
        properties.setProperty("email.username", "votre.email@gmail.com");
        properties.setProperty("email.password", "votre_mot_de_passe_app");
        properties.setProperty("email.from.name", "Gestion Immobilière");
    }

    public static String getSmtpHost() {
        return properties.getProperty("smtp.host");
    }

    public static String getSmtpPort() {
        return properties.getProperty("smtp.port");
    }

    public static String getEmailUsername() {
        return properties.getProperty("email.username");
    }

    public static String getEmailPassword() {
        return properties.getProperty("email.password");
    }

    public static String getFromName() {
        return properties.getProperty("email.from.name");
    }

    public static Properties getSmtpProperties() {
        Properties smtpProps = new Properties();
        smtpProps.put("mail.smtp.host", getSmtpHost());
        smtpProps.put("mail.smtp.port", getSmtpPort());
        smtpProps.put("mail.smtp.auth", properties.getProperty("smtp.auth", "true"));
        smtpProps.put("mail.smtp.starttls.enable", properties.getProperty("smtp.starttls.enable", "true"));
        smtpProps.put("mail.smtp.ssl.protocols", properties.getProperty("smtp.ssl.protocols", "TLSv1.2"));
        return smtpProps;
    }

    /**
     * Valide la configuration email
     */
    public static boolean isConfigurationValid() {
        String username = getEmailUsername();
        String password = getEmailPassword();

        if (username == null || username.equals("votre.email@gmail.com") || username.trim().isEmpty()) {
            System.err.println("Configuration email invalide: nom d'utilisateur non configuré");
            return false;
        }

        if (password == null || password.equals("votre_mot_de_passe_app") || password.trim().isEmpty()) {
            System.err.println("Configuration email invalide: mot de passe non configuré");
            return false;
        }

        return true;
    }

    /**
     * Affiche les informations de configuration (sans le mot de passe)
     */
    public static void printConfiguration() {
        System.out.println("=== CONFIGURATION EMAIL ===");
        System.out.println("SMTP Host: " + getSmtpHost());
        System.out.println("SMTP Port: " + getSmtpPort());
        System.out.println("Username: " + getEmailUsername());
        System.out.println("From Name: " + getFromName());
        System.out.println("Configuration valide: " + isConfigurationValid());
        System.out.println("==========================");
    }
}