package sn.isi.gestion_immobiliere.Servlet;

import sn.isi.gestion_immobiliere.Dao.UserRepository;
import sn.isi.gestion_immobiliere.Dao.LocataireRepository;
import sn.isi.gestion_immobiliere.Entities.User;
import sn.isi.gestion_immobiliere.Entities.Locataire;
import sn.isi.gestion_immobiliere.Utils.DatabaseManager;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.regex.Pattern;

@WebServlet("/auth")
public class AuthServlet extends BaseServlet {


    // Patterns de validation
    private static final Pattern EMAIL_PATTERN = Pattern.compile(
            "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
    );

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        System.out.println("GET /auth - action: " + action);

        if ("logout".equals(action)) {
            handleLogout(request, response);
        } else if ("register".equals(action)) {
            request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
        } else {
            // Page de connexion par défaut
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        System.out.println("POST /auth - action: " + action);

        long startTime = System.currentTimeMillis();

        try {
            if ("login".equals(action)) {
                handleLogin(request, response);
            } else if ("register".equals(action)) {
                handleRegister(request, response);
            } else {
                response.sendRedirect("login.jsp");
            }
        } finally {
            long duration = System.currentTimeMillis() - startTime;
            System.out.println("Temps de traitement AUTH: " + duration + "ms");
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== DÉBUT LOGIN ===");
        long loginStart = System.currentTimeMillis();

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Validation rapide des entrées
        if (email == null || email.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
            System.out.println("Validation échouée - champs vides");
            request.setAttribute("error", "Email et mot de passe requis");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        email = email.trim().toLowerCase();

        // Validation du format email
        if (!EMAIL_PATTERN.matcher(email).matches()) {
            System.out.println("Validation échouée - format email");
            request.setAttribute("error", "Format d'email invalide");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        try {
            // Protection brute force simplifiée
            if (hasTooManyFailedAttempts(request, email)) {
                System.out.println("Trop de tentatives pour: " + email);
                request.setAttribute("error", "Trop de tentatives échouées. Veuillez patienter.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }

            // MESURE DU TEMPS DE REQUÊTE DB
            long dbStart = System.currentTimeMillis();
            System.out.println("Tentative de connexion pour: " + email);

            User user = userRepository.login(email, password);

            long dbDuration = System.currentTimeMillis() - dbStart;
            System.out.println("Temps de requête DB: " + dbDuration + "ms");

            if (user != null) {
                // Connexion réussie
                System.out.println("LOGIN RÉUSSI pour: " + email + " (" + user.getRole() + ")");

                // Session rapide
                createSimpleSession(request, user);
                clearFailedAttempts(request, email);

                // Redirection immédiate
                String redirectUrl = getRedirectUrlByRole(user.getRole());
                System.out.println("Redirection vers: " + redirectUrl);

                long loginDuration = System.currentTimeMillis() - loginStart;
                System.out.println("Durée totale login: " + loginDuration + "ms");

                response.sendRedirect(redirectUrl);

            } else {
                // Connexion échouée
                System.out.println("LOGIN ÉCHOUÉ pour: " + email);
                recordFailedAttempt(request, email);

                request.setAttribute("error", "Email ou mot de passe incorrect");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            System.err.println("ERREUR CRITIQUE lors du login: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Erreur technique. Veuillez réessayer.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }

        System.out.println("=== FIN LOGIN ===");
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== DÉBUT REGISTRATION ===");

        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String email = request.getParameter("email");
        String telephone = request.getParameter("telephone");
        String motDePasse = request.getParameter("motDePasse");
        String role = request.getParameter("role");
        String adresse = request.getParameter("adresse");
        String profession = request.getParameter("profession");

        // Validation rapide
        StringBuilder errors = new StringBuilder();

        if (nom == null || nom.trim().isEmpty()) {
            errors.append("Le nom est requis. ");
        }
        if (prenom == null || prenom.trim().isEmpty()) {
            errors.append("Le prénom est requis. ");
        }
        if (email == null || email.trim().isEmpty()) {
            errors.append("L'email est requis. ");
        } else if (!EMAIL_PATTERN.matcher(email.trim()).matches()) {
            errors.append("Format d'email invalide. ");
        }
        if (motDePasse == null || motDePasse.length() < 6) {
            errors.append("Le mot de passe doit contenir au moins 6 caractères. ");
        }
        if (role == null || (!role.equals("LOCATAIRE") && !role.equals("PROPRIETAIRE"))) {
            errors.append("Rôle invalide. ");
        }

        if (errors.length() > 0) {
            request.setAttribute("error", errors.toString());
            request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
            return;
        }

        try {
            email = email.trim().toLowerCase();

            // Vérification email existant
            System.out.println("Vérification email existant: " + email);
            User existingUser = userRepository.getByEmail(email);
            if (existingUser != null) {
                request.setAttribute("error", "Un compte existe déjà avec cet email");
                request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
                return;
            }

            // Création utilisateur
            User newUser = new User(
                    nom.trim(),
                    prenom.trim(),
                    email,
                    motDePasse,
                    role,
                    telephone != null ? telephone.trim() : null
            );

            System.out.println("Création utilisateur: " + email);
            int userResult = userRepository.add(newUser);

            if (userResult > 0) {
                // Création locataire si nécessaire
                if ("LOCATAIRE".equals(role)) {
                    User savedUser = userRepository.getByEmail(email);
                    if (savedUser != null) {
                        Locataire locataire = new Locataire(
                                profession != null ? profession.trim() : "",
                                adresse != null ? adresse.trim() : "",
                                savedUser.getId(),
                                savedUser
                        );
                        locataireRepository.add(locataire);
                    }
                }

                System.out.println("INSCRIPTION RÉUSSIE: " + email + " (" + role + ")");
                request.setAttribute("success", "Compte créé avec succès. Vous pouvez maintenant vous connecter.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);

            } else {
                request.setAttribute("error", "Erreur lors de la création du compte");
                request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
            }

        } catch (Exception e) {
            System.err.println("ERREUR lors de l'inscription: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Erreur technique. Veuillez réessayer.");
            request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
        }

        System.out.println("=== FIN REGISTRATION ===");
    }

    private void handleLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        System.out.println("=== LOGOUT ===");
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }

    /**
     * Session optimisée
     */
    private void createSimpleSession(HttpServletRequest request, User user) {
        HttpSession session = request.getSession(true);
        session.setAttribute("user", user);
        session.setMaxInactiveInterval(30 * 60); // 30 minutes
        System.out.println("Session créée pour: " + user.getEmail());
    }

    private String getRedirectUrlByRole(String role) {
        return switch (role) {
            case "ADMIN" -> "admin";
            case "PROPRIETAIRE" -> "proprietaire";
            case "LOCATAIRE" -> "locataireIndex";
            default -> "dashboard/index.jsp";
        };
    }

    /**
     * Protection anti-brute force simplifiée
     */
    private boolean hasTooManyFailedAttempts(HttpServletRequest request, String email) {
        HttpSession session = request.getSession();
        Integer attempts = (Integer) session.getAttribute("failedAttempts_" + email);
        return attempts != null && attempts >= 3; // Réduit à 3 tentatives
    }

    private void recordFailedAttempt(HttpServletRequest request, String email) {
        HttpSession session = request.getSession();
        Integer attempts = (Integer) session.getAttribute("failedAttempts_" + email);
        attempts = (attempts == null) ? 1 : attempts + 1;
        session.setAttribute("failedAttempts_" + email, attempts);
    }

    private void clearFailedAttempts(HttpServletRequest request, String email) {
        HttpSession session = request.getSession();
        session.removeAttribute("failedAttempts_" + email);
    }
}