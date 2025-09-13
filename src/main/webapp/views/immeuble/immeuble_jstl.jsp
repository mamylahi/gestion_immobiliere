<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Immeubles</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-gray-50">

<%@ include file="../../navbar/navbar.jsp" %>

<!-- Contenu principal avec marge pour le sidebar -->
<div class="ml-64 min-h-screen">
    <div class="p-8">
        <div class="max-w-7xl mx-auto">

            <!-- En-tête avec titre moderne et icône circulaire -->
            <div class="mb-12 animate-fade-in">
                <div class="bg-gradient-to-br from-blue-600 via-purple-600 to-blue-800 rounded-3xl text-white p-12 shadow-xl relative overflow-hidden">
                    <!-- Éléments décoratifs -->
                    <div class="absolute top-8 right-8 w-20 h-20 border-2 border-white border-opacity-30 rounded-full animate-pulse"></div>
                    <div class="absolute bottom-8 left-8 w-16 h-16 border-2 border-white border-opacity-20 rounded-full animate-bounce"></div>
                    <div class="absolute top-1/2 left-1/4 w-2 h-2 bg-white bg-opacity-40 rounded-full animate-ping"></div>

                    <div class="relative z-10 text-center">
                        <!-- Icône circulaire principale -->
                        <div class="inline-flex items-center justify-center w-24 h-24 bg-white/20 backdrop-blur-sm rounded-full mb-6">
                            <i class="fas fa-building text-4xl"></i>
                        </div>

                        <h1 class="text-5xl font-bold mb-4 tracking-tight">
                            <c:choose>
                                <c:when test="${sessionScope.user.role == 'ADMIN'}">
                                    Tous les Immeubles
                                </c:when>
                                <c:when test="${sessionScope.user.role == 'PROPRIETAIRE'}">
                                    Mes Immeubles
                                </c:when>
                                <c:otherwise>
                                    Gestion des Immeubles
                                </c:otherwise>
                            </c:choose>
                        </h1>

                        <p class="text-xl text-white text-opacity-90 max-w-2xl mx-auto leading-relaxed">
                            <c:choose>
                                <c:when test="${sessionScope.user.role == 'ADMIN'}">
                                    Gérez et supervisez tous les immeubles du système
                                </c:when>
                                <c:when test="${sessionScope.user.role == 'PROPRIETAIRE'}">
                                    Gérez vos propriétés immobilières et leurs caractéristiques
                                </c:when>
                                <c:otherwise>
                                    Gérez efficacement votre portefeuille immobilier
                                </c:otherwise>
                            </c:choose>
                        </p>

                        <div class="flex justify-center mt-8 space-x-4">
                            <div class="flex items-center bg-white text-black bg-opacity-20 backdrop-blur-sm rounded-full px-4 py-2">
                                <i class="fas fa-home text-blue-300 mr-2"></i>
                                <span class="text-sm">Gestion complète</span>
                            </div>
                            <div class="flex items-center bg-white text-black bg-opacity-20 backdrop-blur-sm rounded-full px-4 py-2">
                                <i class="fas fa-shield-alt text-green-300 mr-2"></i>
                                <span class="text-sm">Sécurisé</span>
                            </div>
                            <div class="flex items-center bg-white text-black bg-opacity-20 backdrop-blur-sm rounded-full px-4 py-2">
                                <i class="fas fa-chart-line text-yellow-300 mr-2"></i>
                                <span class="text-sm">Analytics</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Statistiques rapides -->
            <div class="mb-8 grid grid-cols-1 md:grid-cols-4 gap-6">
                <div class="bg-white rounded-2xl p-6 shadow-lg border border-gray-100">
                    <div class="flex items-center">
                        <div class="w-12 h-12 bg-blue-100 rounded-xl flex items-center justify-center">
                            <i class="fas fa-building text-blue-600"></i>
                        </div>
                        <div class="ml-4">
                            <p class="text-2xl font-bold text-gray-900">${immeubles.size()}</p>
                            <p class="text-gray-600">Total immeubles</p>
                        </div>
                    </div>
                </div>

                <div class="bg-white rounded-2xl p-6 shadow-lg border border-gray-100">
                    <div class="flex items-center">
                        <div class="w-12 h-12 bg-green-100 rounded-xl flex items-center justify-center">
                            <i class="fas fa-door-open text-green-600"></i>
                        </div>
                        <div class="ml-4">
                            <p class="text-2xl font-bold text-gray-900">
                                <c:set var="totalUnites" value="0" />
                                <c:forEach var="immeuble" items="${immeubles}">
                                    <c:set var="totalUnites" value="${totalUnites + immeuble.nombreUnite}" />
                                </c:forEach>
                                ${totalUnites}
                            </p>
                            <p class="text-gray-600">Total unités</p>
                        </div>
                    </div>
                </div>

                <div class="bg-white rounded-2xl p-6 shadow-lg border border-gray-100">
                    <div class="flex items-center">
                        <div class="w-12 h-12 bg-yellow-100 rounded-xl flex items-center justify-center">
                            <i class="fas fa-tools text-yellow-600"></i>
                        </div>
                        <div class="ml-4">
                            <p class="text-2xl font-bold text-gray-900">
                                <c:set var="avecEquipements" value="0" />
                                <c:forEach var="immeuble" items="${immeubles}">
                                    <c:if test="${not empty immeuble.equipements}">
                                        <c:set var="avecEquipements" value="${avecEquipements + 1}" />
                                    </c:if>
                                </c:forEach>
                                ${avecEquipements}
                            </p>
                            <p class="text-gray-600">Avec équipements</p>
                        </div>
                    </div>
                </div>

                <div class="bg-white rounded-2xl p-6 shadow-lg border border-gray-100">
                    <div class="flex items-center">
                        <div class="w-12 h-12 bg-purple-100 rounded-xl flex items-center justify-center">
                            <i class="fas fa-image text-purple-600"></i>
                        </div>
                        <div class="ml-4">
                            <p class="text-2xl font-bold text-gray-900">
                                <c:set var="avecImages" value="0" />
                                <c:forEach var="immeuble" items="${immeubles}">
                                    <c:if test="${not empty immeuble.image}">
                                        <c:set var="avecImages" value="${avecImages + 1}" />
                                    </c:if>
                                </c:forEach>
                                ${avecImages}
                            </p>
                            <p class="text-gray-600">Avec photos</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Actions rapides -->
            <div class="mb-8 bg-white rounded-2xl shadow-lg border border-gray-100 p-6">
                <div class="flex flex-col md:flex-row md:items-center md:justify-between space-y-4 md:space-y-0">
                    <div class="flex items-center space-x-4">
                        <div class="relative">
                            <input type="text" id="searchInput" placeholder="Rechercher un immeuble..."
                                   class="w-64 pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                   value="${param.searchNom}">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <i class="fas fa-search text-gray-400"></i>
                            </div>
                        </div>

                        <select id="filterSelect" class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                            <option value="">Tous les immeubles</option>
                            <option value="avec-equipements">Avec équipements</option>
                            <option value="sans-equipements">Sans équipements</option>
                            <option value="avec-images">Avec photos</option>
                            <option value="sans-images">Sans photos</option>
                        </select>
                    </div>

                    <div class="flex items-center space-x-2">
                        <a href="immeuble?action=add" class="inline-flex items-center px-6 py-2 bg-gradient-to-r from-blue-600 to-blue-700 hover:from-blue-700 hover:to-blue-800 text-white font-medium rounded-lg transition-all duration-200 transform hover:scale-105 shadow-lg hover:shadow-xl">
                            <i class="fas fa-plus mr-2"></i>Nouvel immeuble
                        </a>

                        <button onclick="exportData()" class="inline-flex items-center px-4 py-2 bg-gray-600 hover:bg-gray-700 text-white font-medium rounded-lg transition-colors duration-200">
                            <i class="fas fa-download mr-2"></i>Exporter
                        </button>

                        <div class="flex items-center bg-gray-100 rounded-lg p-1">
                            <button id="gridView" class="p-2 text-blue-600 bg-white rounded-md shadow-sm transition-colors duration-200">
                                <i class="fas fa-th-large"></i>
                            </button>
                            <button id="listView" class="p-2 text-gray-400 hover:text-blue-600 transition-colors duration-200">
                                <i class="fas fa-list"></i>
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Messages -->
            <c:if test="${not empty successMessage}">
                <div class="mb-6 animate-slide-up">
                    <div class="bg-green-50 border border-green-200 rounded-xl p-4 flex items-center">
                        <div class="w-10 h-10 bg-green-100 rounded-full flex items-center justify-center mr-4">
                            <i class="fas fa-check-circle text-green-600"></i>
                        </div>
                        <div class="flex-1">
                            <p class="text-green-800 font-medium">${successMessage}</p>
                        </div>
                        <button onclick="this.parentElement.parentElement.remove()" class="text-green-400 hover:text-green-600 transition-colors duration-200">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                </div>
            </c:if>

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

            <!-- Vue grille (par défaut) -->
            <div id="gridViewContainer" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                <c:choose>
                    <c:when test="${not empty immeubles}">
                        <c:forEach var="immeuble" items="${immeubles}">
                            <div class="bg-white rounded-2xl shadow-lg border border-gray-100 overflow-hidden hover:shadow-xl transition-shadow duration-300 immeuble-card"
                                 data-search="${immeuble.nom} ${immeuble.adresse} ${immeuble.proprietaire.nom} ${immeuble.proprietaire.prenom}"
                                 data-equipements="${not empty immeuble.equipements ? 'avec' : 'sans'}"
                                 data-images="${not empty immeuble.image ? 'avec' : 'sans'}">

                                <!-- Image de l'immeuble -->
                                <div class="relative h-48 bg-gray-200">
                                    <c:choose>
                                        <c:when test="${not empty immeuble.image}">
                                            <img src="${pageContext.request.contextPath}/${immeuble.image}"
                                                 alt="Image de ${immeuble.nom}"
                                                 class="w-full h-full object-cover cursor-pointer hover:scale-105 transition-transform duration-300"
                                                 onclick="showImageModal('${pageContext.request.contextPath}/${immeuble.image}', '${immeuble.nom}')">
                                            <div class="absolute top-3 right-3">
                                                <span class="bg-blue-600 text-white px-2 py-1 rounded-full text-xs font-medium">
                                                    <i class="fas fa-image mr-1"></i>Photo
                                                </span>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="w-full h-full flex items-center justify-center bg-gradient-to-br from-gray-100 to-gray-200">
                                                <div class="text-center text-gray-400">
                                                    <i class="fas fa-building text-4xl mb-2"></i>
                                                    <p class="text-sm">Aucune image</p>
                                                </div>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <!-- Contenu de la carte -->
                                <div class="p-6">
                                    <!-- En-tête -->
                                    <div class="flex items-start justify-between mb-4">
                                        <div>
                                            <h3 class="text-xl font-bold text-gray-900 mb-1">${immeuble.nom}</h3>
                                            <p class="text-gray-600 text-sm">
                                                <i class="fas fa-map-marker-alt mr-1"></i>${immeuble.adresse}
                                            </p>
                                        </div>
                                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800">
                                            #${immeuble.id}
                                        </span>
                                    </div>

                                    <!-- Description -->
                                    <c:if test="${not empty immeuble.description}">
                                        <p class="text-gray-600 text-sm mb-4 line-clamp-2">
                                            <c:choose>
                                                <c:when test="${immeuble.description.length() > 80}">
                                                    ${immeuble.description.substring(0, 80)}...
                                                </c:when>
                                                <c:otherwise>
                                                    ${immeuble.description}
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                    </c:if>

                                    <!-- Informations clés -->
                                    <div class="grid grid-cols-2 gap-4 mb-4">
                                        <div class="bg-blue-50 rounded-lg p-3 text-center">
                                            <div class="text-2xl font-bold text-blue-600">${immeuble.nombreUnite}</div>
                                            <div class="text-xs text-blue-600">Unités</div>
                                        </div>
                                        <div class="bg-green-50 rounded-lg p-3 text-center">
                                            <div class="text-2xl font-bold text-green-600">
                                                <c:choose>
                                                    <c:when test="${not empty immeuble.equipements}">
                                                        <i class="fas fa-check"></i>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="fas fa-times"></i>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="text-xs text-green-600">Équipements</div>
                                        </div>
                                    </div>

                                    <!-- Propriétaire -->
                                    <div class="flex items-center mb-4 p-3 bg-gray-50 rounded-lg">
                                        <div class="w-10 h-10 bg-gradient-to-br from-purple-500 to-purple-600 rounded-full flex items-center justify-center text-white font-bold text-sm mr-3">
                                                ${immeuble.proprietaire.prenom.charAt(0)}${immeuble.proprietaire.nom.charAt(0)}
                                        </div>
                                        <div>
                                            <div class="font-semibold text-gray-900 text-sm">
                                                    ${immeuble.proprietaire.prenom} ${immeuble.proprietaire.nom}
                                            </div>
                                            <div class="text-gray-500 text-xs">Propriétaire</div>
                                        </div>
                                    </div>

                                    <!-- Équipements (si présents) -->
                                    <c:if test="${not empty immeuble.equipements}">
                                        <div class="mb-4">
                                            <div class="text-xs font-medium text-gray-700 mb-2">Équipements:</div>
                                            <div class="text-xs text-gray-600 bg-gray-50 rounded-lg p-2">
                                                <c:choose>
                                                    <c:when test="${immeuble.equipements.length() > 60}">
                                                        ${immeuble.equipements.substring(0, 60)}...
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${immeuble.equipements}
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </c:if>

                                    <!-- Actions -->
                                    <div class="flex items-center justify-between pt-4 border-t border-gray-100">
                                        <button onclick="viewDetails(${immeuble.id})" class="inline-flex items-center px-3 py-2 bg-blue-100 hover:bg-blue-200 text-blue-600 text-sm font-medium rounded-lg transition-colors duration-200">
                                            <i class="fas fa-eye mr-1"></i>Voir
                                        </button>

                                        <div class="flex items-center space-x-2">
                                            <a href="?action=edit&id=${immeuble.id}" class="inline-flex items-center justify-center w-8 h-8 bg-yellow-100 hover:bg-yellow-200 text-yellow-600 rounded-lg transition-colors duration-200" title="Modifier">
                                                <i class="fas fa-edit text-sm"></i>
                                            </a>

                                            <button onclick="confirmDelete(${immeuble.id}, '${immeuble.nom}')" class="inline-flex items-center justify-center w-8 h-8 bg-red-100 hover:bg-red-200 text-red-600 rounded-lg transition-colors duration-200" title="Supprimer">
                                                <i class="fas fa-trash text-sm"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="col-span-full">
                            <div class="text-center py-16">
                                <div class="w-24 h-24 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-6">
                                    <i class="fas fa-building text-4xl text-gray-400"></i>
                                </div>
                                <h3 class="text-2xl font-semibold text-gray-900 mb-4">Aucun immeuble trouvé</h3>
                                <p class="text-gray-600 mb-6">Commencez par ajouter votre premier immeuble.</p>
                                <a href="immeuble?action=add" class="inline-flex items-center px-6 py-3 bg-blue-600 hover:bg-blue-700 text-white font-medium rounded-xl transition-colors duration-200">
                                    <i class="fas fa-plus mr-2"></i>Ajouter un immeuble
                                </a>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Vue liste (masquée par défaut) -->
            <div id="listViewContainer" class="hidden bg-white rounded-2xl shadow-lg border border-gray-100 overflow-hidden">
                <c:if test="${not empty immeubles}">
                    <div class="overflow-x-auto">
                        <table class="w-full">
                            <thead class="bg-gradient-to-r from-gray-800 to-gray-900 text-white">
                            <tr>
                                <th class="px-6 py-4 text-left text-sm font-semibold">Image</th>
                                <th class="px-6 py-4 text-left text-sm font-semibold">Nom</th>
                                <th class="px-6 py-4 text-left text-sm font-semibold">Adresse</th>
                                <th class="px-6 py-4 text-left text-sm font-semibold">Unités</th>
                                <th class="px-6 py-4 text-left text-sm font-semibold">Propriétaire</th>
                                <th class="px-6 py-4 text-left text-sm font-semibold">Actions</th>
                            </tr>
                            </thead>
                            <tbody class="divide-y divide-gray-200" id="immeubleTableBody">
                            <c:forEach var="immeuble" items="${immeubles}">
                                <tr class="hover:bg-gray-50 transition-colors duration-200 immeuble-row"
                                    data-search="${immeuble.nom} ${immeuble.adresse} ${immeuble.proprietaire.nom} ${immeuble.proprietaire.prenom}"
                                    data-equipements="${not empty immeuble.equipements ? 'avec' : 'sans'}"
                                    data-images="${not empty immeuble.image ? 'avec' : 'sans'}">
                                    <td class="px-6 py-4">
                                        <c:choose>
                                            <c:when test="${not empty immeuble.image}">
                                                <img src="${pageContext.request.contextPath}/${immeuble.image}"
                                                     alt="Image de ${immeuble.nom}"
                                                     class="w-16 h-16 object-cover rounded-lg border border-gray-200 cursor-pointer hover:scale-110 transition-transform duration-200"
                                                     onclick="showImageModal('${pageContext.request.contextPath}/${immeuble.image}', '${immeuble.nom}')">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="w-16 h-16 bg-gray-100 rounded-lg border border-gray-200 flex items-center justify-center">
                                                    <i class="fas fa-building text-gray-400"></i>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="px-6 py-4">
                                        <div class="font-semibold text-gray-900">${immeuble.nom}</div>
                                        <div class="text-sm text-gray-500">#${immeuble.id}</div>
                                    </td>
                                    <td class="px-6 py-4">
                                        <div class="text-gray-900">${immeuble.adresse}</div>
                                        <c:if test="${not empty immeuble.description}">
                                            <div class="text-sm text-gray-500 truncate max-w-xs">
                                                    ${immeuble.description.length() > 50 ? immeuble.description.substring(0, 50).concat('...') : immeuble.description}
                                            </div>
                                        </c:if>
                                    </td>
                                    <td class="px-6 py-4">
                                        <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-blue-100 text-blue-800">
                                            ${immeuble.nombreUnite} unité(s)
                                        </span>
                                    </td>
                                    <td class="px-6 py-4">
                                        <div class="flex items-center">
                                            <div class="w-10 h-10 bg-gradient-to-br from-purple-500 to-purple-600 rounded-full flex items-center justify-center text-white font-bold text-sm mr-3">
                                                    ${immeuble.proprietaire.prenom.charAt(0)}${immeuble.proprietaire.nom.charAt(0)}
                                            </div>
                                            <div>
                                                <div class="font-semibold text-gray-900">
                                                        ${immeuble.proprietaire.prenom} ${immeuble.proprietaire.nom}
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="px-6 py-4">
                                        <div class="flex items-center space-x-2">
                                            <button onclick="viewDetails(${immeuble.id})" class="inline-flex items-center justify-center w-8 h-8 bg-blue-100 hover:bg-blue-200 text-blue-600 rounded-lg transition-colors duration-200" title="Voir détails">
                                                <i class="fas fa-eye text-sm"></i>
                                            </button>

                                            <a href="?action=edit&id=${immeuble.id}" class="inline-flex items-center justify-center w-8 h-8 bg-yellow-100 hover:bg-yellow-200 text-yellow-600 rounded-lg transition-colors duration-200" title="Modifier">
                                                <i class="fas fa-edit text-sm"></i>
                                            </a>

                                            <button onclick="confirmDelete(${immeuble.id}, '${immeuble.nom}')" class="inline-flex items-center justify-center w-8 h-8 bg-red-100 hover:bg-red-200 text-red-600 rounded-lg transition-colors duration-200" title="Supprimer">
                                                <i class="fas fa-trash text-sm"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</div>

<!-- Modal pour afficher l'image en grand -->
<div id="imageModal" class="fixed inset-0 backdrop-blur-md z-50 hidden flex items-center justify-center p-4">
    <div class="bg-white bg-opacity-95 backdrop-blur-sm rounded-3xl max-w-4xl w-full max-h-[90vh] overflow-hidden shadow-2xl border border-gray-100 transform scale-95 opacity-0 transition-all duration-300">
        <div class="bg-gradient-to-r from-gray-800 to-gray-900 text-white p-6">
            <div class="flex items-center justify-between">
                <h3 class="text-xl font-bold flex items-center" id="imageModalLabel">
                    <i class="fas fa-image mr-3"></i>
                    Image de l'immeuble
                </h3>
                <button onclick="closeImageModal()" class="w-8 h-8 flex items-center justify-center text-white hover:bg-white hover:bg-opacity-20 rounded-lg transition-colors duration-200">
                    <i class="fas fa-times"></i>
                </button>
            </div>
        </div>

        <div class="p-8 text-center">
            <img id="modalImage" src="" alt="Image de l'immeuble" class="max-w-full max-h-[60vh] object-contain mx-auto rounded-lg shadow-lg">
        </div>
    </div>
</div>

<!-- Modal de confirmation de suppression -->
<div id="deleteModal" class="fixed inset-0 backdrop-blur-md z-50 hidden flex items-center justify-center p-4">
    <div class="bg-white bg-opacity-95 backdrop-blur-sm rounded-3xl max-w-md w-full shadow-2xl border border-gray-100 transform scale-95 opacity-0 transition-all duration-300">
        <div class="bg-gradient-to-r from-red-600 to-red-700 text-white p-6 rounded-t-3xl">
            <div class="flex items-center justify-between">
                <h3 class="text-xl font-bold flex items-center">
                    <i class="fas fa-exclamation-triangle mr-3"></i>
                    Confirmer la suppression
                </h3>
                <button onclick="closeDeleteModal()" class="w-8 h-8 flex items-center justify-center text-white hover:bg-white hover:bg-opacity-20 rounded-lg transition-colors duration-200">
                    <i class="fas fa-times"></i>
                </button>
            </div>
        </div>

        <div class="p-6">
            <div class="text-center mb-6">
                <div class="w-16 h-16 bg-red-100 rounded-full flex items-center justify-center mx-auto mb-4">
                    <i class="fas fa-building text-2xl text-red-600"></i>
                </div>
                <p class="text-gray-700">
                    Êtes-vous sûr de vouloir supprimer l'immeuble <strong id="deleteImmeubleNom"></strong> ?
                </p>
                <p class="text-sm text-gray-500 mt-2">
                    Cette action est irréversible et supprimera également toutes les unités associées.
                </p>
            </div>

            <div class="flex space-x-4">
                <button type="button" onclick="closeDeleteModal()" class="flex-1 px-6 py-3 bg-gray-100 hover:bg-gray-200 text-gray-700 font-semibold rounded-xl transition-colors duration-200">
                    <i class="fas fa-arrow-left mr-2"></i>Annuler
                </button>
                <button type="button" onclick="executeDelete()" class="flex-1 px-6 py-3 bg-gradient-to-r from-red-600 to-red-700 hover:from-red-700 hover:to-red-800 text-white font-bold rounded-xl transition-all duration-200">
                    <i class="fas fa-trash mr-2"></i>Supprimer
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Modal de détails -->
<div id="detailModal" class="fixed inset-0 backdrop-blur-md z-50 hidden flex items-center justify-center p-4">
    <div class="bg-white bg-opacity-95 backdrop-blur-sm rounded-3xl max-w-4xl w-full max-h-[90vh] overflow-hidden shadow-2xl border border-gray-100 transform scale-95 opacity-0 transition-all duration-300">
        <div class="bg-gradient-to-r from-blue-600 to-blue-700 text-white p-6">
            <div class="flex items-center justify-between">
                <h3 class="text-2xl font-bold flex items-center">
                    <i class="fas fa-info-circle mr-3"></i>
                    Détails de l'immeuble
                </h3>
                <button onclick="closeDetailModal()" class="w-8 h-8 flex items-center justify-center text-white hover:bg-white hover:bg-opacity-20 rounded-lg transition-colors duration-200">
                    <i class="fas fa-times"></i>
                </button>
            </div>
        </div>

        <div class="p-8 overflow-y-auto" id="detailContent">
            <!-- Le contenu sera injecté dynamiquement -->
        </div>
    </div>
</div>

<script>
    // Variables globales
    let currentView = 'grid';
    let deleteImmeubleId = null;

    // Initialisation au chargement de la page
    document.addEventListener('DOMContentLoaded', function() {
        initializeFilters();
        initializeViews();
        animateOnLoad();
    });

    // Initialisation des filtres
    function initializeFilters() {
        const searchInput = document.getElementById('searchInput');
        const filterSelect = document.getElementById('filterSelect');

        searchInput.addEventListener('input', filterImmeubles);
        filterSelect.addEventListener('change', filterImmeubles);
    }

    // Initialisation des vues
    function initializeViews() {
        const gridViewBtn = document.getElementById('gridView');
        const listViewBtn = document.getElementById('listView');

        gridViewBtn.addEventListener('click', () => switchView('grid'));
        listViewBtn.addEventListener('click', () => switchView('list'));
    }

    // Changer de vue
    function switchView(view) {
        const gridContainer = document.getElementById('gridViewContainer');
        const listContainer = document.getElementById('listViewContainer');
        const gridBtn = document.getElementById('gridView');
        const listBtn = document.getElementById('listView');

        if (view === 'grid') {
            gridContainer.classList.remove('hidden');
            listContainer.classList.add('hidden');
            gridBtn.classList.add('text-blue-600', 'bg-white', 'shadow-sm');
            gridBtn.classList.remove('text-gray-400');
            listBtn.classList.remove('text-blue-600', 'bg-white', 'shadow-sm');
            listBtn.classList.add('text-gray-400');
        } else {
            gridContainer.classList.add('hidden');
            listContainer.classList.remove('hidden');
            listBtn.classList.add('text-blue-600', 'bg-white', 'shadow-sm');
            listBtn.classList.remove('text-gray-400');
            gridBtn.classList.remove('text-blue-600', 'bg-white', 'shadow-sm');
            gridBtn.classList.add('text-gray-400');
        }
        currentView = view;
    }

    // Filtrer les immeubles
    function filterImmeubles() {
        const searchTerm = document.getElementById('searchInput').value.toLowerCase();
        const filterValue = document.getElementById('filterSelect').value;

        const cards = document.querySelectorAll('.immeuble-card');
        const rows = document.querySelectorAll('.immeuble-row');

        let visibleCount = 0;

        // Filtrer les cartes
        cards.forEach(card => {
            const searchData = card.getAttribute('data-search').toLowerCase();
            const equipements = card.getAttribute('data-equipements');
            const images = card.getAttribute('data-images');

            const matchesSearch = searchData.includes(searchTerm);
            let matchesFilter = true;

            switch(filterValue) {
                case 'avec-equipements':
                    matchesFilter = equipements === 'avec';
                    break;
                case 'sans-equipements':
                    matchesFilter = equipements === 'sans';
                    break;
                case 'avec-images':
                    matchesFilter = images === 'avec';
                    break;
                case 'sans-images':
                    matchesFilter = images === 'sans';
                    break;
            }

            if (matchesSearch && matchesFilter) {
                card.style.display = '';
                visibleCount++;
            } else {
                card.style.display = 'none';
            }
        });

        // Filtrer les lignes du tableau
        rows.forEach(row => {
            const searchData = row.getAttribute('data-search').toLowerCase();
            const equipements = row.getAttribute('data-equipements');
            const images = row.getAttribute('data-images');

            const matchesSearch = searchData.includes(searchTerm);
            let matchesFilter = true;

            switch(filterValue) {
                case 'avec-equipements':
                    matchesFilter = equipements === 'avec';
                    break;
                case 'sans-equipements':
                    matchesFilter = equipements === 'sans';
                    break;
                case 'avec-images':
                    matchesFilter = images === 'avec';
                    break;
                case 'sans-images':
                    matchesFilter = images === 'sans';
                    break;
            }

            if (matchesSearch && matchesFilter) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }

    // Afficher le modal d'image
    function showImageModal(imageSrc, immeubleNom) {
        document.getElementById('modalImage').src = imageSrc;
        document.getElementById('imageModalLabel').innerHTML = `<i class="fas fa-image mr-3"></i>Image de ${immeubleNom}`;
        showModal(document.getElementById('imageModal'));
    }

    function closeImageModal() {
        hideModal(document.getElementById('imageModal'));
    }

    // Confirmer la suppression
    function confirmDelete(id, nom) {
        deleteImmeubleId = id;
        document.getElementById('deleteImmeubleNom').textContent = nom;
        showModal(document.getElementById('deleteModal'));
    }

    function closeDeleteModal() {
        hideModal(document.getElementById('deleteModal'));
        deleteImmeubleId = null;
    }

    function executeDelete() {
        if (deleteImmeubleId) {
            window.location.href = `?action=delete&id=${deleteImmeubleId}`;
        }
    }

    // Voir les détails
    function viewDetails(id) {
        // Simuler le chargement des détails (à remplacer par un appel AJAX)
        const detailContent = document.getElementById('detailContent');
        detailContent.innerHTML = `
            <div class="text-center py-8">
                <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto mb-4"></div>
                <p class="text-gray-600">Chargement des détails...</p>
            </div>
        `;

        showModal(document.getElementById('detailModal'));

        // Simuler le chargement (remplacer par un vrai appel AJAX)
        setTimeout(() => {
            detailContent.innerHTML = `
                <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                    <div class="space-y-6">
                        <div class="bg-gradient-to-r from-blue-50 to-indigo-50 rounded-2xl p-6 border border-blue-200">
                            <h4 class="font-bold text-lg text-gray-900 mb-4 flex items-center">
                                <i class="fas fa-building text-blue-600 mr-3"></i>
                                Informations générales
                            </h4>
                            <div class="space-y-2">
                                <p><span class="font-medium text-gray-700">ID :</span> <span class="text-gray-900">#${id}</span></p>
                                <p><span class="font-medium text-gray-700">Statut :</span> <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800">Actif</span></p>
                            </div>
                        </div>

                        <div class="bg-gradient-to-r from-green-50 to-emerald-50 rounded-2xl p-6 border border-green-200">
                            <h4 class="font-bold text-lg text-gray-900 mb-4 flex items-center">
                                <i class="fas fa-chart-line text-green-600 mr-3"></i>
                                Statistiques
                            </h4>
                            <div class="space-y-2">
                                <p><span class="font-medium text-gray-700">Taux d'occupation :</span> <span class="text-gray-900">85%</span></p>
                                <p><span class="font-medium text-gray-700">Revenus mensuels :</span> <span class="text-gray-900">450,000 FCFA</span></p>
                            </div>
                        </div>
                    </div>

                    <div class="space-y-6">
                        <div class="bg-gradient-to-r from-purple-50 to-pink-50 rounded-2xl p-6 border border-purple-200">
                            <h4 class="font-bold text-lg text-gray-900 mb-4 flex items-center">
                                <i class="fas fa-door-open text-purple-600 mr-3"></i>
                                Unités disponibles
                            </h4>
                            <div class="space-y-2">
                                <p><span class="font-medium text-gray-700">Libres :</span> <span class="text-gray-900">2 unités</span></p>
                                <p><span class="font-medium text-gray-700">Occupées :</span> <span class="text-gray-900">8 unités</span></p>
                            </div>
                        </div>

                        <div class="bg-gradient-to-r from-orange-50 to-yellow-50 rounded-2xl p-6 border border-orange-200">
                            <h4 class="font-bold text-lg text-gray-900 mb-4 flex items-center">
                                <i class="fas fa-calendar text-orange-600 mr-3"></i>
                                Dernière activité
                            </h4>
                            <div class="space-y-2">
                                <p><span class="font-medium text-gray-700">Dernière location :</span> <span class="text-gray-900">15/11/2024</span></p>
                                <p><span class="font-medium text-gray-700">Dernière maintenance :</span> <span class="text-gray-900">10/11/2024</span></p>
                            </div>
                        </div>
                    </div>
                </div>
            `;
        }, 1000);
    }

    function closeDetailModal() {
        hideModal(document.getElementById('detailModal'));
    }

    // Export des données
    function exportData() {
        alert('Fonctionnalité d\'export en cours de développement');
    }

    // Utilitaires pour les modals
    function showModal(modal) {
        if (!modal) return;
        const modalContent = modal.querySelector('.bg-white');
        modal.classList.remove('hidden');
        document.body.style.overflow = 'hidden';
        requestAnimationFrame(() => {
            requestAnimationFrame(() => {
                modalContent.classList.remove('scale-95', 'opacity-0');
                modalContent.classList.add('scale-100', 'opacity-100');
            });
        });
    }

    function hideModal(modal) {
        if (!modal) return;
        const modalContent = modal.querySelector('.bg-white');
        modalContent.classList.remove('scale-100', 'opacity-100');
        modalContent.classList.add('scale-95', 'opacity-0');
        setTimeout(() => {
            modal.classList.add('hidden');
            document.body.style.overflow = 'auto';
        }, 300);
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

    // Fermer les modals en cliquant à l'extérieur
    document.addEventListener('click', function(e) {
        const imageModal = document.getElementById('imageModal');
        const deleteModal = document.getElementById('deleteModal');
        const detailModal = document.getElementById('detailModal');

        if (e.target === imageModal) closeImageModal();
        if (e.target === deleteModal) closeDeleteModal();
        if (e.target === detailModal) closeDetailModal();
    });

    // Fermer avec Escape
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            const imageModal = document.getElementById('imageModal');
            const deleteModal = document.getElementById('deleteModal');
            const detailModal = document.getElementById('detailModal');

            if (!imageModal.classList.contains('hidden')) closeImageModal();
            if (!deleteModal.classList.contains('hidden')) closeDeleteModal();
            if (!detailModal.classList.contains('hidden')) closeDetailModal();
        }
    });
</script>

</body>
</html>