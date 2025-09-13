package sn.isi.gestion_immobiliere.Servlet;

import sn.isi.gestion_immobiliere.Dao.UserRepository;
import sn.isi.gestion_immobiliere.Entities.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "userServlet", value = "/user")
public class UserServlet extends BaseServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = (request.getParameter("action") == null) ? "list" : request.getParameter("action");
        String searchNom = request.getParameter("searchNom");
        String idStr = request.getParameter("id");

        try {
            switch (action) {
                case "add":
                    request.getRequestDispatcher("/views/user/addUser_jstl.jsp").forward(request, response);
                    break;

                case "delete":
                    if (idStr != null) {
                        int id = Integer.parseInt(idStr);
                        userRepository.delete(id);
                    }
                    response.sendRedirect("user");
                    break;

                case "edit":
                    if (idStr != null) {
                        int id = Integer.parseInt(idStr);
                        User user = userRepository.get(id);
                        request.setAttribute("user", user);
                        request.getRequestDispatcher("/views/user/editUser_jstl.jsp").forward(request, response);
                    }
                    break;

                case "list":
                default:
                    List<User> users = (searchNom != null && !searchNom.isBlank())
                            ? userRepository.search(searchNom)
                            : userRepository.getAll();
                    request.setAttribute("users", users);
                    request.getRequestDispatcher("/views/user/user_jstl.jsp").forward(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Erreur : " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String action = request.getParameter("action");

            String nom = request.getParameter("nom");
            String prenom = request.getParameter("prenom");
            String email = request.getParameter("email");
            String motDePasse = request.getParameter("motDePasse");
            String role = request.getParameter("role");
            String telephone = request.getParameter("telephone");

            if ("update".equals(action)) {
                String idStr = request.getParameter("id");
                if (idStr != null) {
                    int id = Integer.parseInt(idStr);
                    User user = userRepository.get(id);
                    if (user != null) {
                        user.setNom(nom);
                        user.setPrenom(prenom);
                        user.setEmail(email);
                        user.setMotDePasse(motDePasse);
                        user.setRole(role);
                        user.setTelephone(telephone);
                        userRepository.update(user);
                    }
                }
            } else {
                User user = new User(nom, prenom, email, motDePasse, role, telephone);
                userRepository.add(user);
            }

            response.sendRedirect("user");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Erreur lors du traitement : " + e.getMessage());
            request.getRequestDispatcher("/views/user/addUser_jstl.jsp").forward(request, response);
        }
    }
}
