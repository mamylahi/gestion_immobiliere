<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Ajouter une Unité de Location</title>
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
            <div class="flex items-center mb-4">
              <div class="w-16 h-16 bg-white/20 backdrop-blur-sm rounded-full flex items-center justify-center mr-4">
                <i class="fas fa-plus text-2xl"></i>
              </div>
              <div>
                <h1 class="text-3xl font-bold">Ajouter une Unité de Location</h1>
                <p class="text-white text-opacity-90">Ajoutez une nouvelle unité à votre immeuble</p>
              </div>
            </div>

            <!-- Breadcrumb -->
            <nav class="flex items-center space-x-2 text-sm">
              <a href="unite" class="text-white text-opacity-75 hover:text-white transition-colors duration-200">
                <i class="fas fa-building mr-1"></i>Unités
              </a>
              <i class="fas fa-chevron-right text-white text-opacity-50"></i>
              <span class="text-white">Nouvelle</span>
            </nav>
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

      <!-- Formulaire principal -->
      <div class="bg-white rounded-2xl shadow-lg border border-gray-100 overflow-hidden">
        <div class="bg-gradient-to-r from-gray-50 to-blue-50 px-8 py-6 border-b border-gray-200">
          <h2 class="text-xl font-semibold text-gray-900 flex items-center">
            <i class="fas fa-edit text-blue-600 mr-3"></i>
            Informations de l'unité
          </h2>
          <p class="text-gray-600 text-sm mt-1">Remplissez tous les champs pour créer votre unité</p>
        </div>

        <form action="unite" method="post" enctype="multipart/form-data" id="uniteForm" class="p-8">
          <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
            <!-- Colonne gauche - Informations de base -->
            <div class="space-y-6">
              <div class="bg-gradient-to-br from-blue-50 to-indigo-50 rounded-2xl p-6 border border-blue-200">
                <h3 class="text-lg font-semibold text-gray-900 mb-4 flex items-center">
                  <i class="fas fa-info-circle text-blue-600 mr-2"></i>
                  Informations générales
                </h3>

                <!-- Numéro d'unité -->
                <div class="mb-4">
                  <label for="numeroUnite" class="block text-sm font-semibold text-gray-700 mb-2">
                    Numéro d'unité <span class="text-red-500">*</span>
                  </label>
                  <input type="number" id="numeroUnite" name="numeroUnite" required min="1"
                         class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200"
                         placeholder="Ex: 101, 205..." value="${param.numeroUnite}">
                  <p class="text-xs text-gray-500 mt-1">Numéro unique pour identifier l'unité</p>
                </div>

                <!-- Nombre de pièces -->
                <div class="mb-4">
                  <label for="nombrePiece" class="block text-sm font-semibold text-gray-700 mb-2">
                    Nombre de pièces <span class="text-red-500">*</span>
                  </label>
                  <select id="nombrePiece" name="nombrePiece" required
                          class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200">
                    <option value="">Sélectionnez...</option>
                    <option value="1" ${param.nombrePiece == '1' ? 'selected' : ''}>1 pièce (Studio)</option>
                    <option value="2" ${param.nombrePiece == '2' ? 'selected' : ''}>2 pièces</option>
                    <option value="3" ${param.nombrePiece == '3' ? 'selected' : ''}>3 pièces</option>
                    <option value="4" ${param.nombrePiece == '4' ? 'selected' : ''}>4 pièces</option>
                    <option value="5" ${param.nombrePiece == '5' ? 'selected' : ''}>5 pièces</option>
                    <option value="6" ${param.nombrePiece == '6' ? 'selected' : ''}>6+ pièces</option>
                  </select>
                </div>

                <!-- Immeuble -->
                <div>
                  <label for="immeubleId" class="block text-sm font-semibold text-gray-700 mb-2">
                    Immeuble <span class="text-red-500">*</span>
                  </label>
                  <select id="immeubleId" name="immeubleId" required
                          class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200">
                    <option value="">Sélectionnez un immeuble...</option>
                    <c:forEach var="i" items="${immeubles}">
                      <option value="${i.id}" ${param.immeubleId == i.id ? 'selected' : ''}>
                          ${i.nom} - ${i.adresse}
                      </option>
                    </c:forEach>
                  </select>
                  <c:if test="${empty immeubles}">
                    <div class="mt-2 p-3 bg-yellow-50 border border-yellow-200 rounded-lg">
                      <div class="flex items-center text-yellow-800">
                        <i class="fas fa-exclamation-triangle mr-2"></i>
                        <span class="text-sm">Aucun immeuble disponible.
                                                    <a href="immeuble?action=add" class="font-medium underline hover:no-underline">Créer un immeuble</a> d'abord.
                                                </span>
                      </div>
                    </div>
                  </c:if>
                </div>
              </div>

              <!-- Caractéristiques techniques -->
              <div class="bg-gradient-to-br from-green-50 to-emerald-50 rounded-2xl p-6 border border-green-200">
                <h3 class="text-lg font-semibold text-gray-900 mb-4 flex items-center">
                  <i class="fas fa-ruler-combined text-green-600 mr-2"></i>
                  Caractéristiques
                </h3>

                <!-- Superficie -->
                <div class="mb-4">
                  <label for="superficie" class="block text-sm font-semibold text-gray-700 mb-2">
                    Superficie <span class="text-red-500">*</span>
                  </label>
                  <div class="relative">
                    <input type="number" step="0.01" id="superficie" name="superficie" required min="1"
                           class="w-full pl-4 pr-12 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-green-500 focus:border-transparent transition-all duration-200"
                           placeholder="Ex: 45.50" value="${param.superficie}">
                    <div class="absolute inset-y-0 right-0 flex items-center pr-4">
                      <span class="text-gray-500 font-medium">m²</span>
                    </div>
                  </div>
                </div>

                <!-- Loyer mensuel -->
                <div>
                  <label for="loyerMensuel" class="block text-sm font-semibold text-gray-700 mb-2">
                    Loyer mensuel <span class="text-red-500">*</span>
                  </label>
                  <div class="relative">
                    <input type="number" step="0.01" id="loyerMensuel" name="loyerMensuel" required min="1"
                           class="w-full pl-4 pr-16 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-green-500 focus:border-transparent transition-all duration-200"
                           placeholder="Ex: 125000" value="${param.loyerMensuel}">
                    <div class="absolute inset-y-0 right-0 flex items-center pr-4">
                      <span class="text-gray-500 font-medium">FCFA</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Colonne droite - Upload d'image -->
            <div class="space-y-6">
              <!-- Upload d'image -->
              <div class="bg-gradient-to-br from-orange-50 to-yellow-50 rounded-2xl p-6 border border-orange-200">
                <h3 class="text-lg font-semibold text-gray-900 mb-4 flex items-center">
                  <i class="fas fa-camera text-orange-600 mr-2"></i>
                  Image de l'unité
                </h3>

                <!-- Zone de drop -->
                <div class="border-2 border-dashed border-gray-300 rounded-xl p-6 text-center hover:border-orange-400 transition-colors duration-200"
                     id="uploadArea" onclick="document.getElementById('imageInput').click()">
                  <div id="uploadContent" class="space-y-4">
                    <div class="w-16 h-16 bg-orange-100 rounded-full flex items-center justify-center mx-auto">
                      <i class="fas fa-cloud-upload-alt text-2xl text-orange-600"></i>
                    </div>
                    <div>
                      <p class="text-gray-700 font-medium">Glissez votre image ici ou</p>
                      <p class="text-blue-600 font-medium cursor-pointer hover:underline">cliquez pour sélectionner un fichier</p>
                    </div>
                    <p class="text-sm text-gray-500">JPG, PNG, GIF jusqu'à 10MB</p>
                  </div>
                </div>

                <input type="file" id="imageInput" name="image" accept="image/*" class="hidden">

                <!-- Aperçu de l'image -->
                <div id="imagePreview" class="hidden mt-4">
                  <div class="relative">
                    <img id="previewImg" src="" alt="Aperçu" class="w-full h-48 object-cover rounded-xl border border-gray-200">
                    <button type="button" onclick="removeImage()" class="absolute top-2 right-2 w-8 h-8 bg-red-500 hover:bg-red-600 text-white rounded-full flex items-center justify-center transition-colors duration-200">
                      <i class="fas fa-times text-sm"></i>
                    </button>
                  </div>
                  <p class="text-sm text-gray-600 mt-2 flex items-center">
                    <i class="fas fa-check-circle text-green-500 mr-2"></i>
                    Image sélectionnée
                  </p>
                </div>
              </div>

              <!-- Informations d'aide -->
              <div class="bg-gradient-to-br from-purple-50 to-pink-50 rounded-2xl p-6 border border-purple-200">
                <h3 class="text-lg font-semibold text-gray-900 mb-4 flex items-center">
                  <i class="fas fa-lightbulb text-purple-600 mr-2"></i>
                  Conseils
                </h3>
                <div class="space-y-3 text-sm text-gray-700">
                  <div class="flex items-start">
                    <i class="fas fa-check text-green-500 mr-2 mt-0.5"></i>
                    <span>Utilisez un numéro d'unité unique et logique</span>
                  </div>
                  <div class="flex items-start">
                    <i class="fas fa-check text-green-500 mr-2 mt-0.5"></i>
                    <span>Vérifiez la superficie et le nombre de pièces</span>
                  </div>
                  <div class="flex items-start">
                    <i class="fas fa-check text-green-500 mr-2 mt-0.5"></i>
                    <span>Ajoutez une photo de qualité pour attirer les locataires</span>
                  </div>
                  <div class="flex items-start">
                    <i class="fas fa-check text-green-500 mr-2 mt-0.5"></i>
                    <span>Définissez un loyer cohérent avec le marché</span>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Actions -->
          <div class="flex items-center justify-between pt-8 border-t border-gray-200 mt-8">
            <div class="flex items-center text-sm text-gray-500">
              <i class="fas fa-info-circle mr-2"></i>
              Les champs marqués d'un <span class="text-red-500">*</span> sont obligatoires
            </div>

            <div class="flex items-center space-x-4">
              <a href="unite" class="inline-flex items-center px-6 py-3 bg-gray-100 hover:bg-gray-200 text-gray-700 font-medium rounded-xl transition-colors duration-200">
                <i class="fas fa-arrow-left mr-2"></i>Retour à la liste
              </a>
              <button type="reset" class="inline-flex items-center px-6 py-3 bg-yellow-100 hover:bg-yellow-200 text-yellow-700 font-medium rounded-xl transition-colors duration-200" onclick="resetForm()">
                <i class="fas fa-undo mr-2"></i>Réinitialiser
              </button>
              <button type="submit" class="inline-flex items-center px-8 py-3 bg-gradient-to-r from-blue-600 to-blue-700 hover:from-blue-700 hover:to-blue-800 text-white font-bold rounded-xl transition-all duration-200 transform hover:scale-105 shadow-lg hover:shadow-xl">
                <i class="fas fa-save mr-2"></i>Ajouter l'unité
              </button>
            </div>
          </div>
        </form>
      </div>
    </div>
  </div>
</div>

<script>
  // Variables globales
  let uploadArea, imageInput, imagePreview, previewImg, uploadContent;

  document.addEventListener('DOMContentLoaded', function() {
    // Initialiser les éléments
    uploadArea = document.getElementById('uploadArea');
    imageInput = document.getElementById('imageInput');
    imagePreview = document.getElementById('imagePreview');
    previewImg = document.getElementById('previewImg');
    uploadContent = document.getElementById('uploadContent');

    initializeDragAndDrop();
    initializeFileInput();
    initializeFormValidation();
    animateOnLoad();
  });

  // Initialiser le drag and drop
  function initializeDragAndDrop() {
    uploadArea.addEventListener('dragover', function(e) {
      e.preventDefault();
      uploadArea.classList.add('border-orange-400', 'bg-orange-50');
    });

    uploadArea.addEventListener('dragleave', function(e) {
      e.preventDefault();
      uploadArea.classList.remove('border-orange-400', 'bg-orange-50');
    });

    uploadArea.addEventListener('drop', function(e) {
      e.preventDefault();
      uploadArea.classList.remove('border-orange-400', 'bg-orange-50');

      const files = e.dataTransfer.files;
      if (files.length > 0) {
        handleFileSelect(files[0]);
      }
    });
  }

  // Initialiser l'input file
  function initializeFileInput() {
    imageInput.addEventListener('change', function(e) {
      if (e.target.files.length > 0) {
        handleFileSelect(e.target.files[0]);
      }
    });
  }

  // Gérer la sélection de fichier
  function handleFileSelect(file) {
    // Vérifier le type de fichier
    if (!file.type.startsWith('image/')) {
      alert('Veuillez sélectionner un fichier image (JPG, PNG, GIF).');
      return;
    }

    // Vérifier la taille (10MB max)
    if (file.size > 10 * 1024 * 1024) {
      alert('Le fichier est trop volumineux. Taille maximum: 10MB.');
      return;
    }

    // Afficher la prévisualisation
    const reader = new FileReader();
    reader.onload = function(e) {
      previewImg.src = e.target.result;
      uploadContent.classList.add('hidden');
      imagePreview.classList.remove('hidden');
    };
    reader.readAsDataURL(file);

    // Assigner le fichier à l'input
    const dt = new DataTransfer();
    dt.items.add(file);
    imageInput.files = dt.files;
  }

  // Supprimer l'image
  function removeImage() {
    imageInput.value = '';
    uploadContent.classList.remove('hidden');
    imagePreview.classList.add('hidden');
    uploadArea.classList.remove('border-orange-400', 'bg-orange-50');
  }

  // Réinitialiser le formulaire
  function resetForm() {
    removeImage();
    document.getElementById('uniteForm').reset();
  }

  // Validation du formulaire
  function initializeFormValidation() {
    document.getElementById('uniteForm').addEventListener('submit', function(e) {
      const numeroUnite = document.querySelector('input[name="numeroUnite"]').value;
      const nombrePiece = document.querySelector('select[name="nombrePiece"]').value;
      const superficie = document.querySelector('input[name="superficie"]').value;
      const loyerMensuel = document.querySelector('input[name="loyerMensuel"]').value;
      const immeubleId = document.querySelector('select[name="immeubleId"]').value;

      if (!numeroUnite || !nombrePiece || !superficie || !loyerMensuel || !immeubleId) {
        e.preventDefault();
        alert('Veuillez remplir tous les champs obligatoires.');
        return false;
      }

      // Validation des valeurs numériques
      if (parseFloat(superficie) <= 0) {
        e.preventDefault();
        alert('La superficie doit être supérieure à 0.');
        return false;
      }

      if (parseFloat(loyerMensuel) <= 0) {
        e.preventDefault();
        alert('Le loyer mensuel doit être supérieur à 0.');
        return false;
      }
    });
  }

  // Animation d'apparition
  function animateOnLoad() {
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
  }
</script>

</body>
</html>