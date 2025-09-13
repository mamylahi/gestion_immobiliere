<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modifier l'Unité de Location</title>
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
                                <i class="fas fa-edit text-2xl"></i>
                            </div>
                            <div>
                                <h1 class="text-3xl font-bold">Modifier l'Unité de Location</h1>
                                <p class="text-white text-opacity-90">Mettez à jour les informations de votre unité</p>
                            </div>
                        </div>

                        <!-- Breadcrumb -->
                        <nav class="flex items-center space-x-2 text-sm">
                            <a href="unite" class="text-white text-opacity-75 hover:text-white transition-colors duration-200">
                                <i class="fas fa-building mr-1"></i>Unités
                            </a>
                            <i class="fas fa-chevron-right text-white text-opacity-50"></i>
                            <span class="text-white">Unité N° ${unite.numeroUnite}</span>
                            <i class="fas fa-chevron-right text-white text-opacity-50"></i>
                            <span class="text-white">Modifier</span>
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
                        Modification de l'Unité N° ${unite.numeroUnite}
                    </h2>
                    <p class="text-gray-600 text-sm mt-1">ID: #${unite.id}</p>
                </div>

                <form action="unite?action=update&id=${unite.id}" method="post" enctype="multipart/form-data" class="p-8">
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
                                    <input type="number" id="numeroUnite" name="numeroUnite" value="${unite.numeroUnite}" required
                                           class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200">
                                </div>

                                <!-- Nombre de pièces -->
                                <div class="mb-4">
                                    <label for="nombrePiece" class="block text-sm font-semibold text-gray-700 mb-2">
                                        Nombre de pièces <span class="text-red-500">*</span>
                                    </label>
                                    <select id="nombrePiece" name="nombrePiece" required
                                            class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200">
                                        <option value="1" ${unite.nombrePiece == 1 ? 'selected' : ''}>1 pièce (Studio)</option>
                                        <option value="2" ${unite.nombrePiece == 2 ? 'selected' : ''}>2 pièces</option>
                                        <option value="3" ${unite.nombrePiece == 3 ? 'selected' : ''}>3 pièces</option>
                                        <option value="4" ${unite.nombrePiece == 4 ? 'selected' : ''}>4 pièces</option>
                                        <option value="5" ${unite.nombrePiece == 5 ? 'selected' : ''}>5 pièces</option>
                                        <option value="6" ${unite.nombrePiece >= 6 ? 'selected' : ''}>6+ pièces</option>
                                    </select>
                                </div>

                                <!-- Immeuble -->
                                <div>
                                    <label for="immeubleId" class="block text-sm font-semibold text-gray-700 mb-2">
                                        Immeuble <span class="text-red-500">*</span>
                                    </label>
                                    <select id="immeubleId" name="immeubleId" required
                                            class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200">
                                        <c:forEach var="i" items="${immeubles}">
                                            <option value="${i.id}" ${i.id == unite.immeuble.id ? 'selected' : ''}>
                                                    ${i.nom} - ${i.adresse}
                                            </option>
                                        </c:forEach>
                                    </select>
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
                                        <input type="number" step="0.01" id="superficie" name="superficie" value="${unite.superficie}" required
                                               class="w-full pl-4 pr-12 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-green-500 focus:border-transparent transition-all duration-200">
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
                                        <input type="number" step="0.01" id="loyerMensuel" name="loyerMensuel" value="${unite.loyerMensuel}" required
                                               class="w-full pl-4 pr-16 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-green-500 focus:border-transparent transition-all duration-200">
                                        <div class="absolute inset-y-0 right-0 flex items-center pr-4">
                                            <span class="text-gray-500 font-medium">FCFA</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Colonne droite - Gestion d'image -->
                        <div class="space-y-6">
                            <!-- Gestion d'image -->
                            <div class="bg-gradient-to-br from-orange-50 to-yellow-50 rounded-2xl p-6 border border-orange-200">
                                <h3 class="text-lg font-semibold text-gray-900 mb-4 flex items-center">
                                    <i class="fas fa-camera text-orange-600 mr-2"></i>
                                    Image de l'unité
                                </h3>

                                <!-- Image actuelle -->
                                <c:if test="${not empty unite.image}">
                                    <div class="mb-4" id="currentImageContainer">
                                        <p class="text-sm font-medium text-gray-700 mb-2">Image actuelle:</p>
                                        <div class="relative group">
                                            <img src="images/unites/${unite.image}"
                                                 alt="Image actuelle"
                                                 class="w-full h-48 object-cover rounded-xl border border-gray-200">
                                            <div class="absolute inset-0 bg-black bg-opacity-0 group-hover:bg-opacity-30 transition-all duration-200 rounded-xl flex items-center justify-center">
                                                <button type="button" onclick="toggleImageChange()" class="opacity-0 group-hover:opacity-100 transition-opacity duration-200 bg-white text-gray-900 px-4 py-2 rounded-lg font-medium">
                                                    <i class="fas fa-edit mr-2"></i>Changer
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>

                                <!-- Zone de drop pour nouvelle image -->
                                <div class="border-2 border-dashed border-gray-300 rounded-xl p-6 text-center hover:border-orange-400 transition-colors duration-200 ${not empty unite.image ? 'hidden' : ''}"
                                     id="dropZone" onclick="document.getElementById('imageInput').click()">
                                    <div class="space-y-4">
                                        <div class="w-16 h-16 bg-orange-100 rounded-full flex items-center justify-center mx-auto">
                                            <i class="fas fa-cloud-upload-alt text-2xl text-orange-600"></i>
                                        </div>
                                        <div>
                                            <p class="text-gray-700 font-medium">
                                                <c:choose>
                                                    <c:when test="${not empty unite.image}">Changer l'image</c:when>
                                                    <c:otherwise>Ajouter une image</c:otherwise>
                                                </c:choose>
                                            </p>
                                            <p class="text-blue-600 font-medium cursor-pointer hover:underline">cliquez pour sélectionner un fichier</p>
                                        </div>
                                        <p class="text-sm text-gray-500">
                                            JPG, PNG, GIF jusqu'à 10MB
                                            <c:if test="${not empty unite.image}">
                                                <br><em>Laisser vide pour conserver l'image actuelle</em>
                                            </c:if>
                                        </p>
                                    </div>
                                </div>

                                <input type="file" id="imageInput" name="image" accept="image/*" class="hidden">

                                <!-- Aperçu de la nouvelle image -->
                                <div id="imagePreview" class="hidden">
                                    <p class="text-sm font-medium text-gray-700 mb-2">Nouvelle image:</p>
                                    <div class="relative">
                                        <img id="previewImg" src="" alt="Aperçu" class="w-full h-48 object-cover rounded-xl border border-gray-200">
                                        <button type="button" onclick="removeImage()" class="absolute top-2 right-2 w-8 h-8 bg-red-500 hover:bg-red-600 text-white rounded-full flex items-center justify-center transition-colors duration-200">
                                            <i class="fas fa-times text-sm"></i>
                                        </button>
                                    </div>
                                    <p class="text-sm text-gray-600 mt-2 flex items-center">
                                        <i class="fas fa-check-circle text-green-500 mr-2"></i>
                                        Nouvelle image sélectionnée
                                    </p>
                                </div>
                            </div>

                            <!-- Informations d'aide -->
                            <div class="bg-gradient-to-br from-purple-50 to-pink-50 rounded-2xl p-6 border border-purple-200">
                                <h3 class="text-lg font-semibold text-gray-900 mb-4 flex items-center">
                                    <i class="fas fa-lightbulb text-purple-600 mr-2"></i>
                                    Informations
                                </h3>
                                <div class="space-y-3 text-sm text-gray-700">
                                    <div class="flex items-start">
                                        <i class="fas fa-info-circle text-blue-500 mr-2 mt-0.5"></i>
                                        <span>Unité créée dans l'immeuble: <strong>${unite.immeuble.nom}</strong></span>
                                    </div>
                                    <div class="flex items-start">
                                        <i class="fas fa-calendar text-purple-500 mr-2 mt-0.5"></i>
                                        <span>Modifiez les caractéristiques selon vos besoins</span>
                                    </div>
                                    <div class="flex items-start">
                                        <i class="fas fa-image text-orange-500 mr-2 mt-0.5"></i>
                                        <span>L'image aide à attirer les locataires potentiels</span>
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
                                <i class="fas fa-arrow-left mr-2"></i>Annuler
                            </a>
                            <button type="submit" class="inline-flex items-center px-8 py-3 bg-gradient-to-r from-green-600 to-green-700 hover:from-green-700 hover:to-green-800 text-white font-bold rounded-xl transition-all duration-200 transform hover:scale-105 shadow-lg hover:shadow-xl">
                                <i class="fas fa-save mr-2"></i>Enregistrer les modifications
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
    let imageInput, imagePreview, previewImg, dropZone, currentImageContainer;

    document.addEventListener('DOMContentLoaded', function() {
        // Initialiser les éléments
        imageInput = document.getElementById('imageInput');
        imagePreview = document.getElementById('imagePreview');
        previewImg = document.getElementById('previewImg');
        dropZone = document.getElementById('dropZone');
        currentImageContainer = document.getElementById('currentImageContainer');

        initializeDragAndDrop();
        initializeFileInput();
        animateOnLoad();
    });

    // Initialiser le drag and drop
    function initializeDragAndDrop() {
        if (!dropZone) return;

        dropZone.addEventListener('dragover', function(e) {
            e.preventDefault();
            dropZone.classList.add('border-orange-400', 'bg-orange-50');
        });

        dropZone.addEventListener('dragleave', function(e) {
            e.preventDefault();
            dropZone.classList.remove('border-orange-400', 'bg-orange-50');
        });

        dropZone.addEventListener('drop', function(e) {
            e.preventDefault();
            dropZone.classList.remove('border-orange-400', 'bg-orange-50');

            const files = e.dataTransfer.files;
            if (files.length > 0) {
                handleFileSelect(files[0]);
            }
        });
    }

    // Initialiser l'input file
    function initializeFileInput() {
        if (!imageInput) return;

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
            imagePreview.classList.remove('hidden');
            dropZone.classList.add('hidden');
            if (currentImageContainer) {
                currentImageContainer.classList.add('hidden');
            }
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
        imagePreview.classList.add('hidden');
        dropZone.classList.remove('hidden');
        if (currentImageContainer) {
            currentImageContainer.classList.remove('hidden');
        }
    }

    // Basculer vers le mode changement d'image
    function toggleImageChange() {
        if (currentImageContainer) {
            currentImageContainer.classList.add('hidden');
        }
        dropZone.classList.remove('hidden');
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