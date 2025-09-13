<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Ajouter un Utilisateur</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-gray-50">

<%@ include file="../../navbar/navbar.jsp" %>

<!-- Contenu principal avec marge pour le sidebar -->
<div class="ml-64 min-h-screen">
  <div class="p-8">
    <div class="max-w-4xl mx-auto">

      <!-- En-tête avec titre moderne -->
      <div class="mb-8 animate-fade-in">
        <div class="bg-gradient-to-br from-blue-600 via-purple-600 to-blue-800 rounded-3xl text-white p-8 shadow-xl relative overflow-hidden">
          <!-- Éléments décoratifs -->
          <div class="absolute top-4 right-4 w-16 h-16 border-2 border-white border-opacity-30 rounded-full animate-pulse"></div>
          <div class="absolute bottom-4 left-4 w-12 h-12 border-2 border-white border-opacity-20 rounded-full animate-bounce"></div>

          <div class="relative z-10">
            <!-- Breadcrumb -->
            <nav class="mb-4">
              <div class="flex items-center space-x-2 text-white text-opacity-80 text-sm">
                <a href="user" class="hover:text-white transition-colors duration-200">
                  <i class="fas fa-users mr-1"></i>Utilisateurs
                </a>
                <i class="fas fa-chevron-right text-xs"></i>
                <span class="text-white">Nouvel utilisateur</span>
              </div>
            </nav>

            <!-- Titre et icône -->
            <div class="flex items-center">
              <div class="w-16 h-16 bg-white/20 backdrop-blur-sm rounded-2xl flex items-center justify-center mr-4">
                <i class="fas fa-user-plus text-2xl"></i>
              </div>
              <div>
                <h1 class="text-3xl font-bold mb-2">Ajouter un Utilisateur</h1>
                <p class="text-white text-opacity-90">Créez un nouveau compte utilisateur avec les informations requises</p>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Messages d'erreur -->
      <c:if test="${not empty errorMessage}">
        <div class="mb-6 animate-slide-up">
          <div class="bg-red-50 border border-red-200 rounded-xl p-4 flex items-center">
            <div class="w-10 h-10 bg-red-100 rounded-full flex items-center justify-center mr-4">
              <i class="fas fa-exclamation-triangle text-red-600"></i>
            </div>
            <div class="flex-1">
              <p class="text-red-800 font-medium">${errorMessage}</p>
            </div>
            <button onclick="this.parentElement.parentElement.remove()" class="text-red-400 hover:text-red-600 transition-colors duration-200">
              <i class="fas fa-times"></i>
            </button>
          </div>
        </div>
      </c:if>

      <!-- Formulaire -->
      <div class="bg-white rounded-2xl shadow-lg border border-gray-100 overflow-hidden">
        <!-- Header du formulaire -->
        <div class="bg-gradient-to-r from-gray-50 to-blue-50 px-8 py-6 border-b border-gray-200">
          <div class="flex items-center justify-between">
            <div>
              <h2 class="text-xl font-semibold text-gray-900 flex items-center">
                <i class="fas fa-edit text-blue-600 mr-3"></i>
                Informations utilisateur
              </h2>
              <p class="text-gray-600 mt-1">Remplissez tous les champs obligatoires marqués d'un astérisque (*)</p>
            </div>
            <div class="flex items-center space-x-2">
              <div class="w-3 h-3 bg-green-400 rounded-full"></div>
              <span class="text-sm text-gray-600">Formulaire actif</span>
            </div>
          </div>
        </div>

        <!-- Corps du formulaire -->
        <form method="post" action="user" class="p-8" id="userForm">
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <!-- Nom -->
            <div class="space-y-2">
              <label for="nom" class="block text-sm font-medium text-gray-700 flex items-center">
                <i class="fas fa-user text-gray-400 mr-2"></i>
                Nom <span class="text-red-500 ml-1">*</span>
              </label>
              <input type="text" id="nom" name="nom" required
                     class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200 bg-gray-50 focus:bg-white"
                     placeholder="Entrez le nom de famille">
              <div class="invalid-feedback text-red-500 text-sm hidden">
                <i class="fas fa-exclamation-circle mr-1"></i>
                Le nom est obligatoire
              </div>
            </div>

            <!-- Prénom -->
            <div class="space-y-2">
              <label for="prenom" class="block text-sm font-medium text-gray-700 flex items-center">
                <i class="fas fa-user text-gray-400 mr-2"></i>
                Prénom <span class="text-red-500 ml-1">*</span>
              </label>
              <input type="text" id="prenom" name="prenom" required
                     class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200 bg-gray-50 focus:bg-white"
                     placeholder="Entrez le prénom">
              <div class="invalid-feedback text-red-500 text-sm hidden">
                <i class="fas fa-exclamation-circle mr-1"></i>
                Le prénom est obligatoire
              </div>
            </div>

            <!-- Email -->
            <div class="space-y-2">
              <label for="email" class="block text-sm font-medium text-gray-700 flex items-center">
                <i class="fas fa-envelope text-gray-400 mr-2"></i>
                Adresse email <span class="text-red-500 ml-1">*</span>
              </label>
              <input type="email" id="email" name="email" required
                     class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200 bg-gray-50 focus:bg-white"
                     placeholder="exemple@email.com">
              <div class="invalid-feedback text-red-500 text-sm hidden">
                <i class="fas fa-exclamation-circle mr-1"></i>
                Une adresse email valide est requise
              </div>
            </div>

            <!-- Téléphone -->
            <div class="space-y-2">
              <label for="telephone" class="block text-sm font-medium text-gray-700 flex items-center">
                <i class="fas fa-phone text-gray-400 mr-2"></i>
                Téléphone
              </label>
              <input type="tel" id="telephone" name="telephone"
                     class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200 bg-gray-50 focus:bg-white"
                     placeholder="+221 XX XXX XX XX">
              <p class="text-xs text-gray-500">Format recommandé: +221 XX XXX XX XX</p>
            </div>

            <!-- Mot de passe -->
            <div class="space-y-2">
              <label for="motDePasse" class="block text-sm font-medium text-gray-700 flex items-center">
                <i class="fas fa-lock text-gray-400 mr-2"></i>
                Mot de passe <span class="text-red-500 ml-1">*</span>
              </label>
              <div class="relative">
                <input type="password" id="motDePasse" name="motDePasse" required
                       class="w-full px-4 py-3 pr-12 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200 bg-gray-50 focus:bg-white"
                       placeholder="Créez un mot de passe sécurisé"
                       minlength="8">
                <button type="button" onclick="togglePassword()" class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-gray-600">
                  <i class="fas fa-eye" id="passwordToggleIcon"></i>
                </button>
              </div>
              <div class="invalid-feedback text-red-500 text-sm hidden">
                <i class="fas fa-exclamation-circle mr-1"></i>
                Le mot de passe doit contenir au moins 8 caractères
              </div>
              <div class="text-xs text-gray-500">
                <div class="flex items-center space-x-4">
                  <span id="passwordStrength" class="font-medium">Force: Faible</span>
                  <div class="flex-1 bg-gray-200 rounded-full h-2">
                    <div id="passwordStrengthBar" class="bg-red-400 h-2 rounded-full transition-all duration-300" style="width: 20%"></div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Rôle -->
            <div class="space-y-2">
              <label for="role" class="block text-sm font-medium text-gray-700 flex items-center">
                <i class="fas fa-user-tag text-gray-400 mr-2"></i>
                Rôle utilisateur <span class="text-red-500 ml-1">*</span>
              </label>
              <select id="role" name="role" required
                      class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200 bg-gray-50 focus:bg-white">
                <option value="">Sélectionnez un rôle</option>
                <option value="ADMIN">
                  <i class="fas fa-crown"></i> Administrateur - Accès complet
                </option>
                <option value="PROPRIETAIRE">
                  <i class="fas fa-home"></i> Propriétaire - Gestion des biens
                </option>
                <option value="LOCATAIRE">
                  <i class="fas fa-user"></i> Locataire - Accès limité
                </option>
              </select>
              <div class="invalid-feedback text-red-500 text-sm hidden">
                <i class="fas fa-exclamation-circle mr-1"></i>
                Veuillez sélectionner un rôle
              </div>
            </div>
          </div>

          <!-- Informations sur les rôles -->
          <div class="mt-8 bg-gradient-to-r from-blue-50 to-indigo-50 rounded-xl p-6 border border-blue-200">
            <h3 class="font-semibold text-gray-900 mb-4 flex items-center">
              <i class="fas fa-info-circle text-blue-600 mr-2"></i>
              Descriptions des rôles
            </h3>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
              <div class="bg-white rounded-lg p-4 border border-blue-100">
                <div class="flex items-center mb-2">
                  <i class="fas fa-crown text-red-500 mr-2"></i>
                  <span class="font-medium text-gray-900">Administrateur</span>
                </div>
                <p class="text-sm text-gray-600">Accès complet au système, gestion des utilisateurs et configuration globale.</p>
              </div>
              <div class="bg-white rounded-lg p-4 border border-blue-100">
                <div class="flex items-center mb-2">
                  <i class="fas fa-home text-blue-500 mr-2"></i>
                  <span class="font-medium text-gray-900">Propriétaire</span>
                </div>
                <p class="text-sm text-gray-600">Gestion de ses biens immobiliers, unités de location et contrats.</p>
              </div>
              <div class="bg-white rounded-lg p-4 border border-blue-100">
                <div class="flex items-center mb-2">
                  <i class="fas fa-user text-green-500 mr-2"></i>
                  <span class="font-medium text-gray-900">Locataire</span>
                </div>
                <p class="text-sm text-gray-600">Consultation de ses contrats de location et paiements.</p>
              </div>
            </div>
          </div>

          <!-- Boutons d'action -->
          <div class="mt-8 flex items-center justify-between pt-6 border-t border-gray-200">
            <div class="flex items-center text-sm text-gray-500">
              <i class="fas fa-shield-alt mr-2"></i>
              Toutes les informations sont sécurisées et cryptées
            </div>
            <div class="flex items-center space-x-4">
              <a href="user" class="inline-flex items-center px-6 py-3 border border-gray-300 rounded-lg text-gray-700 bg-white hover:bg-gray-50 font-medium transition-all duration-200">
                <i class="fas fa-arrow-left mr-2"></i>
                Annuler
              </a>
              <button type="submit" class="inline-flex items-center px-8 py-3 bg-gradient-to-r from-blue-600 to-blue-700 hover:from-blue-700 hover:to-blue-800 text-white font-medium rounded-lg transition-all duration-200 transform hover:scale-105 shadow-lg hover:shadow-xl">
                <i class="fas fa-user-plus mr-2"></i>
                Créer l'utilisateur
              </button>
            </div>
          </div>
        </form>
      </div>

      <!-- Conseils de sécurité -->
      <div class="mt-8 bg-yellow-50 rounded-xl p-6 border border-yellow-200">
        <h3 class="font-semibold text-gray-900 mb-3 flex items-center">
          <i class="fas fa-lightbulb text-yellow-500 mr-2"></i>
          Conseils de sécurité
        </h3>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 text-sm text-gray-700">
          <div class="flex items-start">
            <i class="fas fa-check-circle text-green-500 mr-2 mt-0.5"></i>
            <span>Utilisez un mot de passe fort avec au moins 8 caractères</span>
          </div>
          <div class="flex items-start">
            <i class="fas fa-check-circle text-green-500 mr-2 mt-0.5"></i>
            <span>Vérifiez l'adresse email avant de créer le compte</span>
          </div>
          <div class="flex items-start">
            <i class="fas fa-check-circle text-green-500 mr-2 mt-0.5"></i>
            <span>Attribuez le rôle approprié selon les responsabilités</span>
          </div>
          <div class="flex items-start">
            <i class="fas fa-check-circle text-green-500 mr-2 mt-0.5"></i>
            <span>L'utilisateur recevra un email de confirmation</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
  // Validation en temps réel
  document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('userForm');
    const inputs = form.querySelectorAll('input[required], select[required]');

    // Validation pour chaque champ
    inputs.forEach(input => {
      input.addEventListener('blur', validateField);
      input.addEventListener('input', clearValidation);
    });

    // Validation du mot de passe en temps réel
    const passwordInput = document.getElementById('motDePasse');
    passwordInput.addEventListener('input', checkPasswordStrength);

    // Validation du formulaire
    form.addEventListener('submit', function(e) {
      if (!validateForm()) {
        e.preventDefault();
      }
    });
  });

  function validateField(e) {
    const field = e.target;
    const value = field.value.trim();

    // Supprimer les anciennes validations
    clearValidation(e);

    if (field.hasAttribute('required') && !value) {
      showFieldError(field, 'Ce champ est obligatoire');
      return false;
    }

    // Validation spécifique par type
    if (field.type === 'email' && value && !isValidEmail(value)) {
      showFieldError(field, 'Format d\'email invalide');
      return false;
    }

    if (field.type === 'password' && value && value.length < 8) {
      showFieldError(field, 'Le mot de passe doit contenir au moins 8 caractères');
      return false;
    }

    showFieldSuccess(field);
    return true;
  }

  function clearValidation(e) {
    const field = e.target;
    const container = field.closest('.space-y-2');

    // Supprimer les classes de validation
    field.classList.remove('border-red-500', 'border-green-500');

    // Masquer les messages d'erreur
    const errorMsg = container.querySelector('.invalid-feedback');
    if (errorMsg) {
      errorMsg.classList.add('hidden');
    }
  }

  function showFieldError(field, message) {
    field.classList.add('border-red-500');
    field.classList.remove('border-green-500');

    const container = field.closest('.space-y-2');
    const errorMsg = container.querySelector('.invalid-feedback');

    if (errorMsg) {
      errorMsg.textContent = message;
      errorMsg.classList.remove('hidden');
    }
  }

  function showFieldSuccess(field) {
    field.classList.add('border-green-500');
    field.classList.remove('border-red-500');
  }

  function validateForm() {
    const form = document.getElementById('userForm');
    const inputs = form.querySelectorAll('input[required], select[required]');
    let isValid = true;

    inputs.forEach(input => {
      const event = { target: input };
      if (!validateField(event)) {
        isValid = false;
      }
    });

    return isValid;
  }

  function isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
  }

  function togglePassword() {
    const passwordInput = document.getElementById('motDePasse');
    const toggleIcon = document.getElementById('passwordToggleIcon');

    if (passwordInput.type === 'password') {
      passwordInput.type = 'text';
      toggleIcon.classList.replace('fa-eye', 'fa-eye-slash');
    } else {
      passwordInput.type = 'password';
      toggleIcon.classList.replace('fa-eye-slash', 'fa-eye');
    }
  }

  function checkPasswordStrength() {
    const password = document.getElementById('motDePasse').value;
    const strengthText = document.getElementById('passwordStrength');
    const strengthBar = document.getElementById('passwordStrengthBar');

    let strength = 0;
    let strengthLabel = 'Très faible';
    let strengthColor = 'bg-red-400';

    // Critères de force
    if (password.length >= 8) strength += 20;
    if (password.match(/[a-z]/)) strength += 20;
    if (password.match(/[A-Z]/)) strength += 20;
    if (password.match(/[0-9]/)) strength += 20;
    if (password.match(/[^a-zA-Z0-9]/)) strength += 20;

    // Déterminer le label et la couleur
    if (strength >= 80) {
      strengthLabel = 'Très fort';
      strengthColor = 'bg-green-500';
    } else if (strength >= 60) {
      strengthLabel = 'Fort';
      strengthColor = 'bg-green-400';
    } else if (strength >= 40) {
      strengthLabel = 'Moyen';
      strengthColor = 'bg-yellow-400';
    } else if (strength >= 20) {
      strengthLabel = 'Faible';
      strengthColor = 'bg-orange-400';
    }

    // Mettre à jour l'affichage
    strengthText.textContent = `Force: ${strengthLabel}`;
    strengthBar.className = `h-2 rounded-full transition-all duration-300 ${strengthColor}`;
    strengthBar.style.width = `${Math.max(strength, 10)}%`;
  }

  // Animation d'apparition
  document.addEventListener('DOMContentLoaded', function() {
    const animatedElements = document.querySelectorAll('.animate-fade-in, .animate-slide-up');
    animatedElements.forEach((element, index) => {
      element.style.opacity = '0';
      element.style.transform = 'translateY(20px)';
      setTimeout(() => {
        element.style.transition = 'all 0.6s ease-out';
        element.style.opacity = '1';
        element.style.transform = 'translateY(0)';
      }, index * 100);
    });
  });
</script>

</body>
</html>