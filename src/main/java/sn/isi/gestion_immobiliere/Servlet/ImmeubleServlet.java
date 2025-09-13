package sn.isi.gestion_immobiliere.Servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import sn.isi.gestion_immobiliere.Dao.ImmeubleRepository;
import sn.isi.gestion_immobiliere.Dao.UserRepository;
import sn.isi.gestion_immobiliere.Entities.Immeuble;
import sn.isi.gestion_immobiliere.Entities.User;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;

@WebServlet(name = "immeubleServlet", value = "/immeuble")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,    // 1 MB
        maxFileSize = 1024 * 1024 * 10,     // 10 MB
        maxRequestSize = 1024 * 1024 * 15   // 15 MB
)
public class ImmeubleServlet extends BaseServlet {

    // Dossier pour stocker les images
    private static final String UPLOAD_DIRECTORY = "uploads/immeubles";
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String action = (request.getParameter("action") == null) ? "list" : request.getParameter("action");
        String searchNom = request.getParameter("searchNom");
        String idStr = request.getParameter("id");

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect("login");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        List<Immeuble> immeubles;

        try {
            switch (action) {
                case "add":
                    request.getRequestDispatcher("/views/immeuble/addImmeuble_jstl.jsp").forward(request, response);
                    break;

                case "delete":
                    if (idStr != null) {
                        int id = Integer.parseInt(idStr);
                        // Récupérer l'immeuble pour supprimer son image
                        Immeuble immeubleToDelete = immeubleRepository.get(id);
                        if (immeubleToDelete != null && immeubleToDelete.getImage() != null) {
                            deleteImageFile(immeubleToDelete.getImage());
                        }
                        immeubleRepository.delete(id);
                    }
                    response.sendRedirect("immeuble");
                    break;

                case "edit":
                    if (idStr != null) {
                        int id = Integer.parseInt(idStr);
                        Immeuble immeuble = immeubleRepository.get(id);
                        request.setAttribute("immeuble", immeuble);
                        request.getRequestDispatcher("views/immeuble/editImmeuble_jstl.jsp").forward(request, response);
                    }
                    break;

                case "list":
                    if(currentUser.getRole().equals("PROPRIETAIRE")){
                        immeubles = (searchNom != null && !searchNom.isBlank())
                                ? immeubleRepository.search(searchNom)
                                : immeubleRepository.getByProprietaire(currentUser.getId());
                    }else {
                        immeubles = (searchNom != null && !searchNom.isBlank())
                                ? immeubleRepository.search(searchNom)
                                : immeubleRepository.getAll();
                    }

                    request.setAttribute("immeubles", immeubles);
                    request.getRequestDispatcher("views/immeuble/immeuble_jstl.jsp").forward(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Une erreur s'est produite : " + e.getMessage());
            request.getRequestDispatcher("views/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect("login");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        try {
            String action = request.getParameter("action");

            // Récupérer les données du formulaire
            String nom = request.getParameter("nom");
            String adresse = request.getParameter("adresse");
            String description = request.getParameter("description");
            String equipements = request.getParameter("equipements");
            String nombreUniteStr = request.getParameter("nombreUnite");
            int idProprietaire = currentUser.getId();
            User proprietaire = userRepository.get(idProprietaire);

            // Validation des paramètres
            if (nom == null || nom.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Le nom est obligatoire");
                request.getRequestDispatcher("views/immeuble/addImmeuble_jstl.jsp").forward(request, response);
                return;
            }

            if (nombreUniteStr == null || nombreUniteStr.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Le nombre d'unités est obligatoire");
                request.getRequestDispatcher("views/immeuble/addImmeuble_jstl.jsp").forward(request, response);
                return;
            }

            int nombreUnite = Integer.parseInt(nombreUniteStr);

            // Gestion de l'upload d'image
            String imagePath = null;
            Part filePart = request.getPart("image");

            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

                // Vérifier l'extension du fichier
                if (isValidImageFile(fileName)) {
                    // Générer un nom unique pour éviter les conflits
                    String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;
                    String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;

                    // Sauvegarder le fichier
                    Path filePath = Paths.get(uploadPath, uniqueFileName);
                    try {
                        Files.copy(filePart.getInputStream(), filePath);
                        imagePath = UPLOAD_DIRECTORY + "/" + uniqueFileName;
                    } catch (IOException e) {
                        System.err.println("Erreur lors de la sauvegarde de l'image: " + e.getMessage());
                    }
                } else {
                    request.setAttribute("errorMessage", "Format d'image non supporté. Utilisez JPG, JPEG, PNG ou GIF.");
                    request.getRequestDispatcher("views/immeuble/addImmeuble_jstl.jsp").forward(request, response);
                    return;
                }
            }

            if ("update".equals(action)) {
                // Logique de modification
                String idStr = request.getParameter("id");
                if (idStr != null) {
                    int id = Integer.parseInt(idStr);
                    Immeuble immeuble = immeubleRepository.get(id);
                    if (immeuble != null) {
                        // Supprimer l'ancienne image si une nouvelle est uploadée
                        if (imagePath != null && immeuble.getImage() != null) {
                            deleteImageFile(immeuble.getImage());
                        }

                        immeuble.setNom(nom);
                        immeuble.setAdresse(adresse);
                        immeuble.setDescription(description);
                        immeuble.setEquipements(equipements);
                        immeuble.setNombreUnite(nombreUnite);

                        // Mettre à jour l'image seulement si une nouvelle a été uploadée
                        if (imagePath != null) {
                            immeuble.setImage(imagePath);
                        }

                        immeubleRepository.update(immeuble);
                    }
                }
            } else {
                // Logique d'ajout
                Immeuble immeuble = new Immeuble(nom, adresse, description, equipements, nombreUnite, proprietaire);
                if (imagePath != null) {
                    immeuble.setImage(imagePath);
                }
                immeubleRepository.add(immeuble);
            }

            // Rediriger vers la liste
            response.sendRedirect("immeuble");

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Le nombre d'unités doit être un nombre valide");
            request.getRequestDispatcher("views/immeuble/addImmeuble_jstl.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Une erreur s'est produite : " + e.getMessage());
            request.getRequestDispatcher("views/immeuble/addImmeuble_jstl.jsp").forward(request, response);
        }
    }

    /**
     * Vérifie si le fichier est une image valide
     */
    private boolean isValidImageFile(String fileName) {
        if (fileName == null) return false;
        String lowerCaseFileName = fileName.toLowerCase();
        return lowerCaseFileName.endsWith(".jpg") ||
                lowerCaseFileName.endsWith(".jpeg") ||
                lowerCaseFileName.endsWith(".png") ||
                lowerCaseFileName.endsWith(".gif");
    }

    /**
     * Supprime un fichier image du serveur
     */
    private void deleteImageFile(String imagePath) {
        try {
            String fullPath = getServletContext().getRealPath("") + File.separator + imagePath;
            File imageFile = new File(fullPath);
            if (imageFile.exists()) {
                imageFile.delete();
            }
        } catch (Exception e) {
            System.err.println("Erreur lors de la suppression de l'image: " + e.getMessage());
        }
    }
}