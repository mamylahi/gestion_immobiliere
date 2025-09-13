package sn.isi.gestion_immobiliere.Servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import sn.isi.gestion_immobiliere.Entities.UniteLocation;
import sn.isi.gestion_immobiliere.Entities.Immeuble;
import sn.isi.gestion_immobiliere.Entities.User;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;

@WebServlet(name = "uniteLocationServlet", value = "/unite")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class UniteLocationServlet extends BaseServlet {

    // Chemin pour stocker les images
    private static final String UPLOAD_DIRECTORY = "images/unites";
    private String uploadPath;

    @Override
    public void init() throws ServletException {
        // IMPORTANT: Appeler d'abord super.init() pour initialiser les repositories
        super.init();

        // Ensuite initialiser les éléments spécifiques à ce servlet
        uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;

        // Créer le dossier s'il n'existe pas
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        System.out.println("UniteLocationServlet: Upload path configuré - " + uploadPath);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        System.out.println("=== UNITE SERVLET GET ===");

        String action = (request.getParameter("action") == null) ? "list" : request.getParameter("action");
        String searchNumero = request.getParameter("searchNumero");
        String idStr = request.getParameter("id");

        System.out.println("Action: " + action);
        System.out.println("Repositories initialized: " + (uniteLocationRepository != null));

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("login");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }

        List<UniteLocation> unites;

        try {
            switch (action) {
                case "add":
                    System.out.println("Récupération des immeubles pour le propriétaire: " + currentUser.getId());
                    List<Immeuble> immeubles = immeubleRepository.getByProprietaire(currentUser.getId());
                    request.setAttribute("immeubles", immeubles);
                    request.getRequestDispatcher("/views/unite/addUnite_jstl.jsp").forward(request, response);
                    break;

                case "delete":
                    if (idStr != null) {
                        int id = Integer.parseInt(idStr);
                        // Récupérer l'unité pour supprimer l'image associée
                        UniteLocation unite = uniteLocationRepository.get(id);
                        if (unite != null && unite.getImage() != null) {
                            deleteImageFile(unite.getImage());
                        }
                        uniteLocationRepository.delete(id);
                    }
                    response.sendRedirect("unite");
                    break;

                case "edit":
                    if (idStr != null) {
                        int id = Integer.parseInt(idStr);
                        UniteLocation unite = uniteLocationRepository.get(id);
                        List<Immeuble> immeublesList = immeubleRepository.getAll();
                        request.setAttribute("unite", unite);
                        request.setAttribute("immeubles", immeublesList);
                        request.getRequestDispatcher("views/unite/editUnite_jstl.jsp").forward(request, response);
                    }
                    break;

                case "list":
                    System.out.println("Chargement de la liste des unités pour: " + currentUser.getRole());

                    if ("PROPRIETAIRE".equals(currentUser.getRole())) {
                        System.out.println("Recherche par propriétaire ID: " + currentUser.getId());
                        unites = (searchNumero != null && !searchNumero.isBlank())
                                ? uniteLocationRepository.search(searchNumero)
                                : uniteLocationRepository.getByProprietaire(currentUser.getId());
                    } else {
                        System.out.println("Recherche toutes les unités (Admin/Autre)");
                        unites = (searchNumero != null && !searchNumero.isBlank())
                                ? uniteLocationRepository.search(searchNumero)
                                : uniteLocationRepository.getAll();
                    }

                    System.out.println("Unités trouvées: " + unites.size());
                    request.setAttribute("unite", unites);
                    request.getRequestDispatcher("views/unite/unite_jstl.jsp").forward(request, response);
                    break;

                default:
                    System.out.println("Action inconnue: " + action);
                    response.sendRedirect("unite");
                    break;
            }

        } catch (Exception e) {
            System.err.println("ERREUR dans UniteLocationServlet.doGet(): " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Une erreur s'est produite : " + e.getMessage());
            request.getRequestDispatcher("views/error.jsp").forward(request, response);
        }

        System.out.println("=== FIN UNITE SERVLET GET ===");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("=== UNITE SERVLET POST ===");

        try {
            String action = request.getParameter("action");
            System.out.println("POST Action: " + action);

            // Récupérer les données du formulaire
            String numeroUniteStr = request.getParameter("numeroUnite");
            String nombrePieceStr = request.getParameter("nombrePiece");
            String superficieStr = request.getParameter("superficie");
            String loyerMensuelStr = request.getParameter("loyerMensuel");
            String immeubleIdStr = request.getParameter("immeubleId");

            // Validation des paramètres
            if (numeroUniteStr == null || numeroUniteStr.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Le numéro d'unité est obligatoire");
                List<Immeuble> immeubles = immeubleRepository.getAll();
                request.setAttribute("immeubles", immeubles);
                request.getRequestDispatcher("views/unite/addUnite_jstl.jsp").forward(request, response);
                return;
            }

            if (immeubleIdStr == null || immeubleIdStr.trim().isEmpty()) {
                request.setAttribute("errorMessage", "L'immeuble est obligatoire");
                List<Immeuble> immeubles = immeubleRepository.getAll();
                request.setAttribute("immeubles", immeubles);
                request.getRequestDispatcher("views/unite/addUnite_jstl.jsp").forward(request, response);
                return;
            }

            int numeroUnite = Integer.parseInt(numeroUniteStr);
            int nombrePiece = Integer.parseInt(nombrePieceStr);
            Double superficie = Double.parseDouble(superficieStr);
            Double loyerMensuel = Double.parseDouble(loyerMensuelStr);
            int immeubleId = Integer.parseInt(immeubleIdStr);

            Immeuble immeuble = immeubleRepository.get(immeubleId);

            // Gestion de l'upload d'image
            String imageName = null;
            Part imagePart = request.getPart("image");

            if (imagePart != null && imagePart.getSize() > 0) {
                // Vérifier le type de fichier
                String contentType = imagePart.getContentType();
                System.out.println("Type de fichier uploadé: " + contentType);

                // CORRECTION: Vérification du type MIME correcte
                if (contentType != null && contentType.startsWith("image/")) {
                    imageName = uploadImage(imagePart);
                    System.out.println("Image uploadée: " + imageName);
                } else {
                    request.setAttribute("errorMessage", "Seuls les fichiers image sont autorisés (JPG, PNG, GIF, etc.)");
                    List<Immeuble> immeubles = immeubleRepository.getAll();
                    request.setAttribute("immeubles", immeubles);
                    request.getRequestDispatcher("views/unite/addUnite_jstl.jsp").forward(request, response);
                    return;
                }
            }

            if ("update".equals(action)) {
                // Logique de modification
                String idStr = request.getParameter("id");
                if (idStr != null) {
                    int id = Integer.parseInt(idStr);
                    UniteLocation unite = uniteLocationRepository.get(id);
                    if (unite != null) {
                        // Si une nouvelle image est uploadée, supprimer l'ancienne
                        if (imageName != null && unite.getImage() != null) {
                            deleteImageFile(unite.getImage());
                        }

                        unite.setNumeroUnite(numeroUnite);
                        unite.setNombrePiece(nombrePiece);
                        unite.setSuperficie(superficie);
                        unite.setLoyerMensuel(loyerMensuel);
                        unite.setImmeuble(immeuble);

                        // Mettre à jour l'image seulement si une nouvelle a été uploadée
                        if (imageName != null) {
                            unite.setImage(imageName);
                        }

                        uniteLocationRepository.update(unite);
                        System.out.println("Unité mise à jour: " + id);
                    }
                }
            } else {
                // Logique d'ajout
                UniteLocation unite = new UniteLocation(numeroUnite, nombrePiece, superficie, loyerMensuel, immeuble);
                if (imageName != null) {
                    unite.setImage(imageName);
                }
                uniteLocationRepository.add(unite);
                System.out.println("Nouvelle unité ajoutée");
            }

            response.sendRedirect("unite");

        } catch (NumberFormatException e) {
            System.err.println("Erreur de format numérique: " + e.getMessage());
            request.setAttribute("errorMessage", "Les valeurs numériques doivent être valides");
            List<Immeuble> immeubles = immeubleRepository.getAll();
            request.setAttribute("immeubles", immeubles);
            request.getRequestDispatcher("views/unite/addUnite_jstl.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("ERREUR dans UniteLocationServlet.doPost(): " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Une erreur s'est produite lors de l'opération : " + e.getMessage());
            List<Immeuble> immeubles = immeubleRepository.getAll();
            request.setAttribute("immeubles", immeubles);
            request.getRequestDispatcher("views/unite/addUnite_jstl.jsp").forward(request, response);
        }

        System.out.println("=== FIN UNITE SERVLET POST ===");
    }

    /**
     * Upload une image et retourne le nom du fichier généré
     */
    private String uploadImage(Part imagePart) throws IOException {
        // Générer un nom unique pour l'image
        String originalFileName = imagePart.getSubmittedFileName();
        String fileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
        String uniqueFileName = UUID.randomUUID().toString() + fileExtension;

        // Chemin complet du fichier
        String filePath = uploadPath + File.separator + uniqueFileName;

        // Sauvegarder le fichier
        imagePart.write(filePath);

        return uniqueFileName;
    }

    /**
     * Supprimer un fichier image
     */
    private void deleteImageFile(String imageName) {
        if (imageName != null && !imageName.isEmpty()) {
            try {
                Path imagePath = Paths.get(uploadPath + File.separator + imageName);
                Files.deleteIfExists(imagePath);
                System.out.println("Image supprimée: " + imageName);
            } catch (IOException e) {
                System.err.println("Erreur lors de la suppression de l'image : " + e.getMessage());
            }
        }
    }
}