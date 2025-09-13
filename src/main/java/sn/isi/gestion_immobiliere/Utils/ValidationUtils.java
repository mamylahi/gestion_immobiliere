package sn.isi.gestion_immobiliere.Utils;

import java.util.regex.Pattern;

public class ValidationUtils {

    // Patterns de validation
    private static final Pattern PHONE_PATTERN = Pattern.compile("^\\+?[0-9]{8,15}$");
    private static final Pattern NAME_PATTERN = Pattern.compile("^[a-zA-ZÀ-ÿ\\s'-]{2,50}$");
    private static final Pattern ADDRESS_PATTERN = Pattern.compile("^[a-zA-Z0-9À-ÿ\\s,.-]{5,200}$");

    /**
     * Valider un numéro de téléphone
     */
    public static boolean isValidPhone(String phone) {
        return phone != null && PHONE_PATTERN.matcher(phone.trim()).matches();
    }

    /**
     * Valider un nom/prénom
     */
    public static boolean isValidName(String name) {
        return name != null && NAME_PATTERN.matcher(name.trim()).matches();
    }

    /**
     * Valider une adresse
     */
    public static boolean isValidAddress(String address) {
        return address != null && ADDRESS_PATTERN.matcher(address.trim()).matches();
    }

    /**
     * Nettoyer une chaîne des caractères dangereux
     */
    public static String sanitizeInput(String input) {
        if (input == null) {
            return null;
        }

        return input.trim()
                .replaceAll("<script", "&lt;script")
                .replaceAll("</script>", "&lt;/script&gt;")
                .replaceAll("javascript:", "")
                .replaceAll("vbscript:", "")
                .replaceAll("onload=", "")
                .replaceAll("onerror=", "");
    }

    /**
     * Vérifier si une chaîne contient du contenu suspect
     */
    public static boolean containsSuspiciousContent(String input) {
        if (input == null) {
            return false;
        }

        String lower = input.toLowerCase();
        return lower.contains("<script") ||
                lower.contains("javascript:") ||
                lower.contains("vbscript:") ||
                lower.contains("onload=") ||
                lower.contains("onerror=") ||
                lower.contains("eval(") ||
                lower.contains("expression(");
    }
}