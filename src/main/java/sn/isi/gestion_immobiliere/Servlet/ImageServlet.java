package sn.isi.gestion_immobiliere.Servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

// CORRECTION: URL pattern plus simple et accessible
@WebServlet("/images/*")
public class ImageServlet extends HttpServlet {

    private String uploadPath;

    @Override
    public void init() {
        // CORRECTION: Chemin vers le dossier des images plus robuste
        String contextPath = getServletContext().getRealPath("");
        if (contextPath == null) {
            // Fallback pour certains serveurs
            contextPath = System.getProperty("user.dir") + "/src/main/webapp";
        }

        uploadPath = contextPath + File.separator + "images";

        // Créer le dossier s'il n'existe pas
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
            System.out.println("Dossier d'images créé: " + uploadPath);
        }

        System.out.println("ImageServlet initialized with path: " + uploadPath);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();
        System.out.println("=== IMAGE REQUEST DEBUG ===");
        System.out.println("PathInfo: " + pathInfo);
        System.out.println("RequestURI: " + request.getRequestURI());
        System.out.println("Upload path: " + uploadPath);

        if (pathInfo == null || pathInfo.equals("/")) {
            System.out.println("PathInfo null ou vide");
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Nom de fichier manquant");
            return;
        }

        // Extraire le chemin de fichier (enlever le premier "/")
        String filePath = pathInfo.substring(1);
        System.out.println("Fichier demandé: " + filePath);

        // Gérer les sous-dossiers (ex: unites/image.jpg)
        File imageFile = new File(uploadPath, filePath);
        System.out.println("Chemin complet du fichier: " + imageFile.getAbsolutePath());
        System.out.println("Fichier existe: " + imageFile.exists());
        System.out.println("Est un fichier: " + imageFile.isFile());
        System.out.println("Peut lire: " + imageFile.canRead());

        if (!imageFile.exists() || !imageFile.isFile()) {
            System.out.println("Fichier non trouvé: " + imageFile.getAbsolutePath());
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Image non trouvée");
            return;
        }

        // Vérifications de sécurité
        String canonicalPath = imageFile.getCanonicalPath();
        String basePath = new File(uploadPath).getCanonicalPath();
        if (!canonicalPath.startsWith(basePath)) {
            System.out.println("Tentative d'accès non autorisé détectée");
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Accès refusé");
            return;
        }

        // Déterminer le type MIME
        String mimeType = getServletContext().getMimeType(imageFile.getName());
        if (mimeType == null) {
            // Types MIME par défaut pour les images courantes
            String extension = getFileExtension(imageFile.getName()).toLowerCase();
            switch (extension) {
                case "jpg":
                case "jpeg":
                    mimeType = "image/jpeg";
                    break;
                case "png":
                    mimeType = "image/png";
                    break;
                case "gif":
                    mimeType = "image/gif";
                    break;
                case "webp":
                    mimeType = "image/webp";
                    break;
                default:
                    mimeType = "application/octet-stream";
            }
        }

        System.out.println("Type MIME détecté: " + mimeType);

        // Configurer les en-têtes de réponse
        response.setContentType(mimeType);
        response.setContentLengthLong(imageFile.length());
        response.setHeader("Content-Disposition", "inline; filename=\"" + imageFile.getName() + "\"");

        // Ajouter des en-têtes de cache
        response.setHeader("Cache-Control", "public, max-age=3600"); // Cache 1 heure
        response.setDateHeader("Expires", System.currentTimeMillis() + 3600000L); // 1 heure

        // Copier le fichier vers la réponse
        try (FileInputStream in = new FileInputStream(imageFile);
             BufferedOutputStream out = new BufferedOutputStream(response.getOutputStream())) {

            byte[] buffer = new byte[8192]; // Buffer plus grand pour de meilleures performances
            int length;
            while ((length = in.read(buffer)) > 0) {
                out.write(buffer, 0, length);
            }
            out.flush();

            System.out.println("Image servie avec succès: " + imageFile.getName());
        } catch (Exception e) {
            System.err.println("Erreur lors de la lecture du fichier: " + e.getMessage());
            e.printStackTrace();
            if (!response.isCommitted()) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erreur lors de la lecture de l'image");
            }
        }
    }

    private String getFileExtension(String fileName) {
        if (fileName == null || fileName.isEmpty()) {
            return "";
        }
        int lastDotIndex = fileName.lastIndexOf('.');
        return lastDotIndex > 0 && lastDotIndex < fileName.length() - 1
                ? fileName.substring(lastDotIndex + 1)
                : "";
    }

    /**
     * Méthode de debug pour lister les images dans un dossier
     */
    private void listImagesInDirectory(HttpServletRequest request, HttpServletResponse response, String pathInfo)
            throws ServletException, IOException {

        String subdirectory = pathInfo.substring(1); // Enlever le premier /
        if (subdirectory.endsWith("/")) {
            subdirectory = subdirectory.substring(0, subdirectory.length() - 1);
        }

        File dir = new File(uploadPath, subdirectory);
        System.out.println("Listage du dossier: " + dir.getAbsolutePath());

        response.setContentType("text/html; charset=UTF-8");
        response.getWriter().println("<html><head><title>Debug Images</title></head><body>");
        response.getWriter().println("<h1>Debug - Contenu du dossier</h1>");
        response.getWriter().println("<p><strong>Chemin:</strong> " + dir.getAbsolutePath() + "</p>");
        response.getWriter().println("<p><strong>Existe:</strong> " + dir.exists() + "</p>");
        response.getWriter().println("<p><strong>Est un dossier:</strong> " + dir.isDirectory() + "</p>");

        if (dir.exists() && dir.isDirectory()) {
            File[] files = dir.listFiles();
            if (files != null && files.length > 0) {
                response.getWriter().println("<h2>Fichiers trouvés (" + files.length + "):</h2>");
                response.getWriter().println("<ul>");
                for (File file : files) {
                    if (file.isFile()) {
                        String fileName = file.getName();
                        String fileUrl = request.getContextPath() + "/images/" + subdirectory + "/" + fileName;
                        response.getWriter().println("<li>");
                        response.getWriter().println("<strong>" + fileName + "</strong> (" + file.length() + " bytes)");
                        response.getWriter().println(" - <a href='" + fileUrl + "' target='_blank'>Voir</a>");
                        response.getWriter().println("</li>");
                    }
                }
                response.getWriter().println("</ul>");
            } else {
                response.getWriter().println("<p style='color:orange;'>Dossier vide</p>");
            }
        } else {
            response.getWriter().println("<p style='color:red;'>Dossier non accessible</p>");
        }

        response.getWriter().println("</body></html>");
    }
}