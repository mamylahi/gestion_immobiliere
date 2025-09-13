package sn.isi.gestion_immobiliere.Servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import sn.isi.gestion_immobiliere.Dao.LocataireRepository;
import sn.isi.gestion_immobiliere.Dao.UserRepository;
import sn.isi.gestion_immobiliere.Entities.Locataire;
import sn.isi.gestion_immobiliere.Entities.User;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "locataireServlet", value = "/locataires")
public class LocataireServlet extends BaseServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String action = (request.getParameter("action") == null) ? "list" : request.getParameter("action");
        String idStr = request.getParameter("id");

        try {
            switch (action) {
                case "add":
                    List<User> listUser = userRepository.getAllLocataire();
                    request.setAttribute("users", listUser);
                    request.getRequestDispatcher("views/locataire/addLocataire_jstl.jsp").forward(request, response);
                    break;

                case "delete":
                    if (idStr != null) {
                        int id = Integer.parseInt(idStr);
                        locataireRepository.delete(id);
                    }
                    response.sendRedirect("locataires");
                    break;

                case "edit":
                    if (idStr != null) {
                        int id = Integer.parseInt(idStr);
                        Locataire locataire = locataireRepository.get(id);
                        request.setAttribute("locataire", locataire);
                        request.getRequestDispatcher("views/locataire/editLocataire_jstl.jsp").forward(request, response);
                    }
                    break;

                case "list":
                    List<Locataire> locataires = locataireRepository.getAll();
                    request.setAttribute("locataires", locataires);
                    request.getRequestDispatcher("views/locataire/locataires_jstl.jsp").forward(request, response);
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
        try {
            String action = request.getParameter("action");

            int idUser = Integer.parseInt(request.getParameter("user"));
            String adresse = request.getParameter("adresse");
            String profession = request.getParameter("profession");


            if ("update".equals(action)) {
                // Modification
                String idStr = request.getParameter("id");
                if (idStr != null) {
                    int id = Integer.parseInt(idStr);
                    Locataire locataire = locataireRepository.get(id);
                    if (locataire != null) {
                        locataire.setIdUser(idUser);
                        locataire.setAdresse(adresse);
                        locataire.setProfession(profession);
                        locataireRepository.update(locataire);
                    }
                }
            } else {
                // Ajout
                User user = userRepository.get(idUser);
                Locataire locataire = new Locataire(adresse, profession, idUser, user);
                locataireRepository.add(locataire);
            }

            response.sendRedirect("locataires");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Une erreur s'est produite lors de l'ajout : " + e.getMessage());
            request.getRequestDispatcher("views/locataire/addLocataire_jstl.jsp").forward(request, response);
        }
    }
}