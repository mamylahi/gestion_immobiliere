<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Connexion - Gestion Immobilière</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
</head>
<body class="min-h-screen bg-gradient-to-br from-blue-50 via-white to-purple-50">

<!-- Container principal -->
<div class="min-h-screen flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
  <div class="max-w-md w-full space-y-8">

    <!-- En-tête avec logo et titre -->
    <div class="text-center">
      <div class="mx-auto h-16 w-16 bg-gradient-to-br from-blue-600 to-purple-600 rounded-2xl flex items-center justify-center mb-4 shadow-lg">
        <i class="fas fa-building text-white text-2xl"></i>
      </div>
      <h2 class="text-3xl font-bold text-gray-900 mb-2">Connexion</h2>
      <p class="text-gray-600">Accédez à votre espace de gestion immobilière</p>
    </div>

    <!-- Message d'erreur -->
    <c:if test="${not empty error}">
      <div class="bg-red-50 border border-red-200 rounded-xl p-4 flex items-center animate-fade-in">
        <div class="w-8 h-8 bg-red-100 rounded-full flex items-center justify-center mr-3">
          <i class="fas fa-exclamation-triangle text-red-600 text-sm"></i>
        </div>
        <div class="flex-1">
          <p class="text-red-800 font-medium text-sm">${error}</p>
        </div>
      </div>
    </c:if>

    <!-- Formulaire de connexion -->
    <div class="bg-white rounded-2xl shadow-xl border border-gray-100 p-8">
      <form action="auth" method="post" class="space-y-6">
        <input type="hidden" name="action" value="login">

        <!-- Champ Email -->
        <div>
          <label for="email" class="block text-sm font-medium text-gray-700 mb-2">
            <i class="fas fa-envelope text-gray-400 mr-2"></i>
            Adresse email
          </label>
          <div class="relative">
            <input
                    type="email"
                    id="email"
                    name="email"
                    required
                    class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200 pl-12"
                    placeholder="votre@email.com"
            >
            <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
              <i class="fas fa-envelope text-gray-400"></i>
            </div>
          </div>
        </div>

        <!-- Champ Mot de passe -->
        <div>
          <label for="password" class="block text-sm font-medium text-gray-700 mb-2">
            <i class="fas fa-lock text-gray-400 mr-2"></i>
            Mot de passe
          </label>
          <div class="relative">
            <input
                    type="password"
                    id="password"
                    name="password"
                    required
                    class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200 pl-12 pr-12"
                    placeholder="••••••••"
            >
            <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
              <i class="fas fa-lock text-gray-400"></i>
            </div>
            <button
                    type="button"
                    class="absolute inset-y-0 right-0 pr-4 flex items-center"
                    onclick="togglePassword()"
            >
              <i id="passwordToggle" class="fas fa-eye text-gray-400 hover:text-gray-600 transition-colors duration-200"></i>
            </button>
          </div>
        </div>

        <!-- Option "Se souvenir de moi" -->
        <div class="flex items-center justify-between">
          <div class="flex items-center">
            <input
                    id="remember-me"
                    name="remember-me"
                    type="checkbox"
                    class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
            >
            <label for="remember-me" class="ml-2 block text-sm text-gray-700">
              Se souvenir de moi
            </label>
          </div>
          <div class="text-sm">
            <a href="#" class="font-medium text-blue-600 hover:text-blue-500 transition-colors duration-200">
              Mot de passe oublié ?
            </a>
          </div>
        </div>

        <!-- Bouton de connexion -->
        <div>
          <button
                  type="submit"
                  class="group relative w-full flex justify-center py-3 px-4 border border-transparent text-sm font-medium rounded-xl text-white bg-gradient-to-r from-blue-600 to-purple-600 hover:from-blue-700 hover:to-purple-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 transition-all duration-200 transform hover:scale-105 shadow-lg hover:shadow-xl"
          >
                            <span class="absolute left-0 inset-y-0 flex items-center pl-3">
                                <i class="fas fa-sign-in-alt text-white text-sm group-hover:animate-pulse"></i>
                            </span>
            Se connecter
          </button>
        </div>
      </form>
    </div>

    <!-- Lien vers l'inscription -->
    <div class="text-center">
      <p class="text-sm text-gray-600">
        Vous n'avez pas encore de compte ?
      </p>
      <a
              href="auth?action=register"
              class="inline-flex items-center mt-2 font-medium text-blue-600 hover:text-blue-500 transition-colors duration-200 group"
      >
        <i class="fas fa-user-plus mr-2 group-hover:animate-bounce"></i>
        Créer un compte
      </a>
    </div>

    <!-- Footer -->
    <div class="text-center text-xs text-gray-500 mt-8">
      <p>© 2025 Gestion Immobilière. Tous droits réservés.</p>
      <div class="flex justify-center space-x-4 mt-2">
        <a href="#" class="hover:text-gray-700 transition-colors duration-200">Conditions d'utilisation</a>
        <span>•</span>
        <a href="#" class="hover:text-gray-700 transition-colors duration-200">Politique de confidentialité</a>
      </div>
    </div>
  </div>
</div>

<!-- Scripts JavaScript -->
<script>
  // Animation d'apparition au chargement
  document.addEventListener('DOMContentLoaded', function() {
    const elements = document.querySelectorAll('.animate-fade-in, form > div');
    elements.forEach((element, index) => {
      element.style.opacity = '0';
      element.style.transform = 'translateY(20px)';
      setTimeout(() => {
        element.style.transition = 'all 0.6s ease-out';
        element.style.opacity = '1';
        element.style.transform = 'translateY(0)';
      }, index * 100);
    });
  });

  // Toggle du mot de passe
  function togglePassword() {
    const passwordInput = document.getElementById('password');
    const toggleIcon = document.getElementById('passwordToggle');

    if (passwordInput.type === 'password') {
      passwordInput.type = 'text';
      toggleIcon.classList.remove('fa-eye');
      toggleIcon.classList.add('fa-eye-slash');
    } else {
      passwordInput.type = 'password';
      toggleIcon.classList.remove('fa-eye-slash');
      toggleIcon.classList.add('fa-eye');
    }
  }

  // Animation des champs au focus
  document.querySelectorAll('input[type="email"], input[type="password"]').forEach(input => {
    input.addEventListener('focus', function() {
      this.parentElement.classList.add('ring-2', 'ring-blue-500');
    });

    input.addEventListener('blur', function() {
      this.parentElement.classList.remove('ring-2', 'ring-blue-500');
    });
  });

  // Validation en temps réel
  document.getElementById('email').addEventListener('input', function() {
    const email = this.value;
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    if (email && !emailRegex.test(email)) {
      this.classList.add('border-red-300');
      this.classList.remove('border-gray-300');
    } else {
      this.classList.remove('border-red-300');
      this.classList.add('border-gray-300');
    }
  });

  // Effet de typing pour le placeholder
  let typingTimer;
  document.querySelectorAll('input').forEach(input => {
    input.addEventListener('keyup', function() {
      clearTimeout(typingTimer);
      typingTimer = setTimeout(() => {
        // Animation subtile après l'arrêt de la saisie
        this.style.transform = 'scale(1.02)';
        setTimeout(() => {
          this.style.transform = 'scale(1)';
        }, 150);
      }, 500);
    });
  });

  // Animation du bouton de soumission
  document.querySelector('form').addEventListener('submit', function(e) {
    const button = this.querySelector('button[type="submit"]');
    button.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i>Connexion en cours...';
    button.disabled = true;
  });
</script>

<style>
  /* Animations personnalisées */
  @keyframes fade-in {
    from {
      opacity: 0;
      transform: translateY(20px);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }

  .animate-fade-in {
    animation: fade-in 0.6s ease-out;
  }

  /* Smooth transitions */
  * {
    transition: all 0.2s ease-in-out;
  }

  /* Custom focus styles */
  input:focus {
    box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
  }

  /* Gradient animation for the button */
  button[type="submit"]:hover {
    background-size: 120% 120%;
  }

  /* Custom scrollbar pour une meilleure apparence */
  ::-webkit-scrollbar {
    width: 8px;
  }

  ::-webkit-scrollbar-track {
    background: #f1f5f9;
  }

  ::-webkit-scrollbar-thumb {
    background: #cbd5e1;
    border-radius: 4px;
  }

  ::-webkit-scrollbar-thumb:hover {
    background: #94a3b8;
  }
</style>
</body>
</html>