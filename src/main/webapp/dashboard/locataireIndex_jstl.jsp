<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rechercher un Logement</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-gray-50">

<%@ include file="/navbar/navbar.jsp" %>

<!-- Contenu principal avec marge pour le sidebar -->
<div class="ml-64 min-h-screen">
    <div class="p-8">
        <div class="max-w-7xl mx-auto">

            <!-- En-tête de bienvenue -->
            <div class="mb-8 animate-fade-in">
                <div class="bg-gradient-to-br from-blue-600 via-purple-600 to-blue-800 rounded-2xl text-white p-8 shadow-xl">
                    <div class="text-center">
                        <div class="inline-flex items-center justify-center w-16 h-16 bg-white/20 rounded-full mb-4">
                            <i class="fas fa-home text-2xl"></i>
                        </div>
                        <h1 class="text-3xl font-bold mb-2">Bienvenue, ${sessionScope.user.prenom} ${sessionScope.user.nom}</h1>
                        <p class="text-blue-100 text-lg">Découvrez les logements disponibles et trouvez votre futur chez-vous</p>
                    </div>
                </div>
            </div>

            <!-- Filtres de recherche -->
            <div class="mb-8 transform translate-y-4 opacity-0">
                <div class="bg-white rounded-2xl shadow-lg border border-gray-100 p-6">
                    <div class="flex items-center mb-6">
                        <div class="w-10 h-10 bg-blue-100 rounded-xl flex items-center justify-center mr-3">
                            <i class="fas fa-filter text-blue-600"></i>
                        </div>
                        <h2 class="text-xl font-semibold text-gray-800">Filtres de recherche</h2>
                    </div>

                    <form method="GET" action="unite" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-4">
                        <div class="space-y-2">
                            <label class="flex items-center text-sm font-medium text-gray-700">
                                <i class="fas fa-search w-4 h-4 mr-2 text-gray-400"></i>
                                Rechercher
                            </label>
                            <input type="text" name="searchNumero"
                                   class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200"
                                   placeholder="Numéro d'unité..." value="${param.searchNumero}">
                        </div>

                        <div class="space-y-2">
                            <label class="flex items-center text-sm font-medium text-gray-700">
                                <i class="fas fa-door-open w-4 h-4 mr-2 text-gray-400"></i>
                                Pièces min
                            </label>
                            <select name="piecesMin" class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200">
                                <option value="">Toutes</option>
                                <option value="1" ${param.piecesMin == '1' ? 'selected' : ''}>1+</option>
                                <option value="2" ${param.piecesMin == '2' ? 'selected' : ''}>2+</option>
                                <option value="3" ${param.piecesMin == '3' ? 'selected' : ''}>3+</option>
                                <option value="4" ${param.piecesMin == '4' ? 'selected' : ''}>4+</option>
                            </select>
                        </div>

                        <div class="space-y-2">
                            <label class="flex items-center text-sm font-medium text-gray-700">
                                <i class="fas fa-money-bill w-4 h-4 mr-2 text-gray-400"></i>
                                Loyer max
                            </label>
                            <select name="loyerMax" class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200">
                                <option value="">Tous</option>
                                <option value="100000" ${param.loyerMax == '100000' ? 'selected' : ''}>100,000 FCFA</option>
                                <option value="200000" ${param.loyerMax == '200000' ? 'selected' : ''}>200,000 FCFA</option>
                                <option value="300000" ${param.loyerMax == '300000' ? 'selected' : ''}>300,000 FCFA</option>
                                <option value="500000" ${param.loyerMax == '500000' ? 'selected' : ''}>500,000 FCFA</option>
                            </select>
                        </div>

                        <div class="space-y-2">
                            <label class="flex items-center text-sm font-medium text-gray-700">
                                <i class="fas fa-map-marker-alt w-4 h-4 mr-2 text-gray-400"></i>
                                Quartier
                            </label>
                            <input type="text" name="quartier"
                                   class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200"
                                   placeholder="Nom du quartier..." value="${param.quartier}">
                        </div>

                        <div class="flex items-end">
                            <button type="submit" class="w-full bg-gradient-to-r from-blue-600 to-blue-700 hover:from-blue-700 hover:to-blue-800 text-white font-medium py-3 px-6 rounded-xl transition-all duration-200 transform hover:scale-105 shadow-lg hover:shadow-xl">
                                <i class="fas fa-search mr-2"></i>Rechercher
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Nombre de résultats et actions -->
            <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center mb-6 space-y-4 sm:space-y-0">
                <div class="flex items-center">
                    <div class="w-8 h-8 bg-green-100 rounded-lg flex items-center justify-center mr-3">
                        <i class="fas fa-building text-green-600"></i>
                    </div>
                    <h3 class="text-xl font-semibold text-gray-800">
                        ${not empty unite ? unite.size() : 0} logement(s) disponible(s)
                        <c:if test="${not empty param.searchNumero}">
                            <span class="text-gray-500">pour "${param.searchNumero}"</span>
                        </c:if>
                    </h3>
                </div>
                <c:if test="${not empty param.searchNumero}">
                    <a href="unite" class="inline-flex items-center px-4 py-2 bg-gray-100 hover:bg-gray-200 text-gray-700 rounded-lg transition-colors duration-200">
                        <i class="fas fa-times mr-2"></i>Effacer les filtres
                    </a>
                </c:if>
            </div>

            <!-- Messages d'alerte -->
            <c:if test="${not empty successMessage}">
                <div class="mb-6 transform translate-y-4 opacity-0">
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
                <div class="mb-6 transform translate-y-4 opacity-0">
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

            <!-- Grille des logements -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                <c:choose>
                    <c:when test="${not empty unite}">
                        <c:forEach var="u" items="${unite}" varStatus="status">
                            <div class="group transform translate-y-4 opacity-0" style="animation-delay: ${status.index * 100}ms;">
                                <div class="bg-white rounded-2xl shadow-lg hover:shadow-2xl transition-all duration-300 transform hover:-translate-y-2 overflow-hidden border border-gray-100">
                                    <!-- Image avec badge -->
                                    <div class="relative overflow-hidden">
                                        <span class="absolute top-4 right-4 z-10 bg-green-500 text-white text-xs font-bold px-3 py-1 rounded-full shadow-lg animate-pulse">
                                            <i class="fas fa-check mr-1"></i>Disponible
                                        </span>

                                        <c:choose>
                                            <c:when test="${not empty u.image}">
                                                <img src="images/unites/${u.image}"
                                                     class="w-full h-48 object-cover group-hover:scale-110 transition-transform duration-300"
                                                     alt="Unité ${u.numeroUnite}"
                                                     loading="lazy">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="w-full h-48 bg-gradient-to-br from-blue-500 to-purple-600 flex items-center justify-center text-white">
                                                    <div class="text-center">
                                                        <i class="fas fa-home text-4xl opacity-70 mb-2 animate-bounce"></i>
                                                        <p class="font-medium">Unité N° ${u.numeroUnite}</p>
                                                    </div>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <!-- Contenu de la carte -->
                                    <div class="p-6">
                                        <!-- En-tête -->
                                        <div class="mb-4">
                                            <h3 class="text-xl font-bold text-gray-900 mb-2 flex items-center">
                                                <i class="fas fa-door-open text-blue-600 mr-2"></i>
                                                Unité N° ${u.numeroUnite}
                                            </h3>
                                            <p class="text-gray-600 font-medium flex items-center">
                                                <i class="fas fa-building text-gray-400 mr-2"></i>
                                                    ${u.immeuble.nom}
                                            </p>
                                            <p class="text-gray-500 text-sm flex items-center mt-1">
                                                <i class="fas fa-map-marker-alt text-gray-400 mr-2"></i>
                                                    ${u.immeuble.adresse}
                                            </p>
                                        </div>

                                        <!-- Caractéristiques -->
                                        <div class="grid grid-cols-3 gap-3 mb-4">
                                            <div class="bg-blue-50 rounded-lg p-3 text-center border border-blue-100 hover:bg-blue-100 transition-colors duration-200">
                                                <i class="fas fa-door-open text-blue-600 mb-1"></i>
                                                <div class="font-bold text-gray-900">${u.nombrePiece}</div>
                                                <div class="text-xs text-gray-600">Pièces</div>
                                            </div>
                                            <div class="bg-green-50 rounded-lg p-3 text-center border border-green-100 hover:bg-green-100 transition-colors duration-200">
                                                <i class="fas fa-expand-arrows-alt text-green-600 mb-1"></i>
                                                <div class="font-bold text-gray-900">${u.superficie}</div>
                                                <div class="text-xs text-gray-600">m²</div>
                                            </div>
                                            <div class="bg-purple-50 rounded-lg p-3 text-center border border-purple-100 hover:bg-purple-100 transition-colors duration-200">
                                                <i class="fas fa-home text-purple-600 mb-1"></i>
                                                <div class="font-bold text-gray-900 text-xs">Louer</div>
                                                <div class="text-xs text-gray-600">Dispo</div>
                                            </div>
                                        </div>

                                        <!-- Description -->
                                        <div class="mb-4 space-y-2">
                                            <c:if test="${not empty u.immeuble.equipements}">
                                                <div class="flex items-start">
                                                    <i class="fas fa-tools text-gray-400 mt-1 mr-2 flex-shrink-0"></i>
                                                    <p class="text-sm text-gray-600 line-clamp-2">
                                                        <span class="font-medium">Équipements :</span>
                                                            ${u.immeuble.equipements.length() > 50 ?
                                                                    u.immeuble.equipements.substring(0, 50).concat('...') :
                                                                    u.immeuble.equipements}
                                                    </p>
                                                </div>
                                            </c:if>
                                            <c:if test="${not empty u.immeuble.description}">
                                                <div class="flex items-start">
                                                    <i class="fas fa-info-circle text-gray-400 mt-1 mr-2 flex-shrink-0"></i>
                                                    <p class="text-sm text-gray-600 line-clamp-2">
                                                            ${u.immeuble.description.length() > 80 ?
                                                                    u.immeuble.description.substring(0, 80).concat('...') :
                                                                    u.immeuble.description}
                                                    </p>
                                                </div>
                                            </c:if>
                                        </div>

                                        <!-- Prix -->
                                        <div class="text-center mb-4">
                                            <div class="text-3xl font-bold bg-gradient-to-r from-green-600 to-green-700 bg-clip-text text-transparent">
                                                <fmt:formatNumber value="${u.loyerMensuel}" pattern="#,##0" />
                                                <span class="text-lg text-gray-500 font-normal">FCFA/mois</span>
                                            </div>
                                        </div>

                                        <!-- Boutons d'action -->
                                        <div class="space-y-3">
                                            <form method="POST" action="demandeLocation" class="w-full">
                                                <input type="hidden" name="action" value="add">
                                                <input type="hidden" name="uniteId" value="${u.id}">
                                                <button type="submit" class="w-full bg-gradient-to-r from-blue-600 to-blue-700 hover:from-blue-700 hover:to-blue-800 text-white font-medium py-3 px-4 rounded-xl transition-all duration-200 transform hover:scale-105 shadow-lg hover:shadow-xl">
                                                    <i class="fas fa-bookmark mr-2"></i>Réserver maintenant
                                                </button>
                                            </form>

                                            <button type="button"
                                                    class="w-full bg-gray-100 hover:bg-gray-200 text-gray-700 font-medium py-2 px-4 rounded-xl transition-colors duration-200 border border-gray-200"
                                                    onclick="openModal('${u.id}', '${u.numeroUnite}', '${u.nombrePiece}', '${u.superficie}', '${u.loyerMensuel}', '${u.image}', '${u.immeuble.nom}', '${u.immeuble.adresse}', '${u.immeuble.equipements}', '${u.immeuble.description}')">
                                                <i class="fas fa-eye mr-2"></i>Voir détails
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <!-- Message si aucune unité -->
                        <div class="col-span-full">
                            <div class="text-center py-16">
                                <div class="w-24 h-24 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-6 animate-pulse">
                                    <i class="fas fa-search text-4xl text-gray-400"></i>
                                </div>
                                <h3 class="text-2xl font-semibold text-gray-900 mb-4">Aucun logement trouvé</h3>
                                <p class="text-gray-600 mb-6 max-w-md mx-auto">
                                    <c:choose>
                                        <c:when test="${not empty param.searchNumero}">
                                            Aucun résultat pour "${param.searchNumero}". Essayez avec d'autres critères.
                                        </c:when>
                                        <c:otherwise>
                                            Aucun logement n'est disponible pour le moment.
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                                <a href="unite" class="inline-flex items-center px-6 py-3 bg-blue-600 hover:bg-blue-700 text-white font-medium rounded-xl transition-colors duration-200">
                                    <i class="fas fa-refresh mr-2"></i>Voir tous les logements
                                </a>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<!-- Modal détails avec Tailwind pur -->
<div id="detailsModal" class="fixed inset-0 backdrop-blur-md z-50 hidden flex items-center justify-center p-4">
    <div class="bg-white bg-opacity-95 backdrop-blur-sm rounded-3xl max-w-5xl w-full max-h-[90vh] overflow-hidden shadow-2xl border border-gray-100 transform scale-95 opacity-0 transition-all duration-300 flex flex-col">
        <!-- Header du modal -->
        <div class="bg-gradient-to-r from-blue-600 via-purple-600 to-indigo-700 text-white p-6 relative overflow-hidden flex-shrink-0">
            <!-- Éléments décoratifs avec Tailwind -->
            <div class="absolute top-0 right-0 w-32 h-32 bg-white bg-opacity-10 rounded-full transform -translate-y-16 translate-x-16"></div>
            <div class="absolute bottom-0 left-0 w-24 h-24 bg-white bg-opacity-10 rounded-full transform translate-y-12 -translate-x-12"></div>

            <div class="relative z-10 flex items-center justify-between">
                <div class="flex items-center">
                    <div class="w-14 h-14 bg-white bg-opacity-20 backdrop-blur-sm rounded-2xl flex items-center justify-center mr-4">
                        <i class="fas fa-info-circle text-2xl"></i>
                    </div>
                    <div>
                        <h2 class="text-2xl font-bold">Détails du logement</h2>
                        <p class="text-blue-100 text-sm">Informations complètes</p>
                    </div>
                </div>
                <button onclick="closeModal()" class="w-12 h-12 flex items-center justify-center text-white text-opacity-80 hover:text-white hover:bg-white hover:bg-opacity-20 rounded-xl transition-all duration-200 group">
                    <i class="fas fa-times text-xl group-hover:rotate-90 transition-transform duration-200"></i>
                </button>
            </div>
        </div>

        <!-- Contenu du modal -->
        <div class="p-8 overflow-y-auto flex-1">
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
                <!-- Section image -->
                <div class="space-y-6">
                    <div id="modalImageContainer" class="relative overflow-hidden rounded-2xl shadow-xl">
                        <!-- Image générée dynamiquement -->
                    </div>

                    <!-- Badges informatifs -->
                    <div class="flex flex-wrap gap-3">
                        <span class="inline-flex items-center px-3 py-1 bg-green-100 text-green-800 text-sm font-medium rounded-full">
                            <i class="fas fa-check-circle mr-2"></i>
                            Disponible immédiatement
                        </span>
                        <span class="inline-flex items-center px-3 py-1 bg-blue-100 text-blue-800 text-sm font-medium rounded-full">
                            <i class="fas fa-star mr-2"></i>
                            Logement premium
                        </span>
                        <span class="inline-flex items-center px-3 py-1 bg-purple-100 text-purple-800 text-sm font-medium rounded-full">
                            <i class="fas fa-shield-alt mr-2"></i>
                            Sécurisé 24/7
                        </span>
                    </div>
                </div>

                <!-- Section informations -->
                <div class="space-y-6">
                    <!-- En-tête -->
                    <div>
                        <h3 id="modalImmeuble" class="text-3xl font-bold text-gray-900 mb-3"></h3>
                        <p class="text-gray-600 text-lg flex items-center">
                            <i class="fas fa-map-marker-alt text-red-500 mr-3"></i>
                            <span id="modalAdresse"></span>
                        </p>
                    </div>

                    <!-- Caractéristiques principales -->
                    <div class="grid grid-cols-3 gap-4">
                        <div class="bg-gradient-to-br from-blue-50 to-blue-100 rounded-2xl p-4 text-center border border-blue-200 hover:shadow-lg transition-shadow duration-200">
                            <div class="w-12 h-12 bg-blue-500 rounded-xl flex items-center justify-center mx-auto mb-3 shadow-lg">
                                <i class="fas fa-door-open text-white text-lg"></i>
                            </div>
                            <div id="modalPieces" class="text-2xl font-bold text-blue-900 mb-1"></div>
                            <div class="text-sm text-blue-600 font-medium">Pièces</div>
                        </div>
                        <div class="bg-gradient-to-br from-green-50 to-green-100 rounded-2xl p-4 text-center border border-green-200 hover:shadow-lg transition-shadow duration-200">
                            <div class="w-12 h-12 bg-green-500 rounded-xl flex items-center justify-center mx-auto mb-3 shadow-lg">
                                <i class="fas fa-expand-arrows-alt text-white text-lg"></i>
                            </div>
                            <div id="modalSuperficie" class="text-2xl font-bold text-green-900 mb-1"></div>
                            <div class="text-sm text-green-600 font-medium">Mètres carrés</div>
                        </div>
                        <div class="bg-gradient-to-br from-purple-50 to-purple-100 rounded-2xl p-4 text-center border border-purple-200 hover:shadow-lg transition-shadow duration-200">
                            <div class="w-12 h-12 bg-purple-500 rounded-xl flex items-center justify-center mx-auto mb-3 shadow-lg">
                                <i class="fas fa-money-bill text-white text-lg"></i>
                            </div>
                            <div id="modalLoyer" class="text-lg font-bold text-purple-900 mb-1"></div>
                            <div class="text-sm text-purple-600 font-medium">FCFA/mois</div>
                        </div>
                    </div>

                    <!-- Informations détaillées sur une ligne -->
                    <div class="grid grid-cols-1 lg:grid-cols-2 gap-4">
                        <div class="bg-gradient-to-r from-orange-50 to-yellow-50 rounded-2xl p-5 border border-orange-200">
                            <h4 class="font-bold text-lg text-gray-900 mb-3 flex items-center">
                                <div class="w-8 h-8 bg-orange-500 rounded-lg flex items-center justify-center mr-3">
                                    <i class="fas fa-tools text-white text-sm"></i>
                                </div>
                                Équipements inclus
                            </h4>
                            <p id="modalEquipements" class="text-gray-700 leading-relaxed"></p>
                        </div>

                        <div class="bg-gradient-to-r from-blue-50 to-indigo-50 rounded-2xl p-5 border border-blue-200">
                            <h4 class="font-bold text-lg text-gray-900 mb-3 flex items-center">
                                <div class="w-8 h-8 bg-blue-500 rounded-lg flex items-center justify-center mr-3">
                                    <i class="fas fa-info-circle text-white text-sm"></i>
                                </div>
                                Description complète
                            </h4>
                            <p id="modalDescription" class="text-gray-700 leading-relaxed"></p>
                        </div>
                    </div>

                    <!-- Avantages supplémentaires -->
                    <div class="bg-gradient-to-r from-gray-50 to-gray-100 rounded-2xl p-5 border border-gray-200">
                        <h4 class="font-bold text-lg text-gray-900 mb-4">Avantages inclus</h4>
                        <div class="grid grid-cols-1 gap-3">
                            <div class="flex items-center justify-between">
                                <div class="flex items-center text-sm">
                                    <i class="fas fa-wifi text-blue-500 mr-3"></i>
                                    <span class="text-gray-700">WiFi haut débit</span>
                                </div>
                                <div class="flex items-center text-sm">
                                    <i class="fas fa-shield-alt text-green-500 mr-3"></i>
                                    <span class="text-gray-700">Sécurité 24/7</span>
                                </div>
                            </div>
                            <div class="flex items-center justify-between">
                                <div class="flex items-center text-sm">
                                    <i class="fas fa-car text-purple-500 mr-3"></i>
                                    <span class="text-gray-700">Parking inclus</span>
                                </div>
                                <div class="flex items-center text-sm">
                                    <i class="fas fa-leaf text-green-500 mr-3"></i>
                                    <span class="text-gray-700">Espace vert</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Footer du modal -->
        <div class="bg-gradient-to-r from-gray-50 to-gray-100 border-t border-gray-200 p-6 flex-shrink-0">
            <div class="flex flex-col sm:flex-row justify-between items-center space-y-4 sm:space-y-0 sm:space-x-6">
                <!-- Information -->
                <div class="text-center sm:text-left">
                    <p class="text-gray-800 font-medium text-lg">Intéressé par ce logement ?</p>
                    <p class="text-sm text-gray-600 mt-1">Réservez maintenant pour sécuriser votre choix</p>
                </div>

                <!-- Boutons d'action -->
                <div class="flex flex-col sm:flex-row space-y-3 sm:space-y-0 sm:space-x-4 w-full sm:w-auto">
                    <button onclick="closeModal()"
                            class="px-8 py-3 bg-white hover:bg-gray-50 text-gray-700 font-semibold rounded-xl border-2 border-gray-300 hover:border-gray-400 transition-all duration-200 flex items-center justify-center shadow-md hover:shadow-lg">
                        <i class="fas fa-times mr-2"></i>
                        Fermer
                    </button>

                    <form method="POST" action="demandeLocation" class="inline-block w-full sm:w-auto">
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" id="modalUniteId" name="uniteId" value="">
                        <button type="submit"
                                class="w-full sm:w-auto px-8 py-3 bg-gradient-to-r from-blue-600 via-purple-600 to-blue-700 hover:from-blue-700 hover:via-purple-700 hover:to-blue-800 text-white font-bold rounded-xl transition-all duration-300 transform hover:scale-105 shadow-lg hover:shadow-xl flex items-center justify-center">
                            <i class="fas fa-bookmark mr-2"></i>
                            Réserver ce logement
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // Animation d'apparition au chargement
    document.addEventListener('DOMContentLoaded', function() {
        // Animer l'en-tête
        setTimeout(() => {
            document.querySelector('.mb-8').classList.remove('opacity-0');
            document.querySelector('.mb-8').classList.add('opacity-100');
        }, 100);

        // Animer les filtres
        setTimeout(() => {
            const filters = document.querySelector('.mb-8.transform');
            filters.classList.remove('translate-y-4', 'opacity-0');
            filters.classList.add('translate-y-0', 'opacity-100');
        }, 300);

        // Animer les messages d'alerte
        const alerts = document.querySelectorAll('.mb-6.transform');
        alerts.forEach((alert, index) => {
            setTimeout(() => {
                alert.classList.remove('translate-y-4', 'opacity-0');
                alert.classList.add('translate-y-0', 'opacity-100');
            }, 500 + (index * 100));
        });

        // Animer les cartes de logements
        const cards = document.querySelectorAll('.group.transform');
        cards.forEach((card, index) => {
            setTimeout(() => {
                card.classList.remove('translate-y-4', 'opacity-0');
                card.classList.add('translate-y-0', 'opacity-100');
            }, 700 + (index * 100));
        });
    });

    // Fonctions pour le modal avec Tailwind pur
    function openModal(uniteId, numero, pieces, superficie, loyer, image, immeubleNom, immeubleAdresse, equipements, description) {
        console.log('Ouverture du modal pour unité:', numero); // Debug

        // Remplir les données
        document.getElementById('modalImmeuble').textContent = immeubleNom;
        document.getElementById('modalAdresse').textContent = immeubleAdresse;
        document.getElementById('modalPieces').textContent = pieces;
        document.getElementById('modalSuperficie').textContent = superficie;
        document.getElementById('modalLoyer').textContent = new Intl.NumberFormat('fr-FR').format(loyer);
        document.getElementById('modalEquipements').textContent = equipements || 'Équipements standards inclus dans le logement';
        document.getElementById('modalDescription').textContent = description || 'Description détaillée disponible lors de la visite. Ce logement offre un cadre de vie exceptionnel.';
        document.getElementById('modalUniteId').value = uniteId;

        // Gestion de l'image
        console.log(image);
        const imageContainer = document.getElementById('modalImageContainer');
        if (image && image.trim() !== '' && image !== 'null') {
            imageContainer.innerHTML = `
                <img src="images/unites/${image}"
                     class="w-full h-72 object-cover rounded-2xl shadow-2xl hover:scale-105 transition-transform duration-500"
                     alt="Unité ${numero}">
            `;
        } else {
            imageContainer.innerHTML = `
                <div class="w-full h-72 bg-gradient-to-br from-blue-500 via-purple-500 to-pink-500 rounded-2xl flex items-center justify-center text-white shadow-2xl relative overflow-hidden">
                    <div class="absolute inset-0 bg-gradient-to-br from-blue-600 from-opacity-30 to-purple-600 to-opacity-30"></div>
                    <div class="text-center relative z-10">
                        <i class="fas fa-home text-6xl opacity-80 mb-4 animate-bounce"></i>
                        <p class="text-2xl font-bold">Unité N° ${numero}</p>
                        <p class="text-blue-100 mt-2">Photos disponibles lors de la visite</p>
                    </div>
                </div>
            `;
        }

        // Afficher le modal avec animation Tailwind
        const modal = document.getElementById('detailsModal');
        const modalContent = modal.querySelector('.bg-white');

        // Forcer l'affichage du modal
        modal.style.display = 'flex';
        modal.classList.remove('hidden');
        document.body.style.overflow = 'hidden';

        console.log('Modal affiché'); // Debug

        // Animation d'ouverture avec un délai
        requestAnimationFrame(() => {
            requestAnimationFrame(() => {
                modalContent.classList.remove('scale-95', 'opacity-0');
                modalContent.classList.add('scale-100', 'opacity-100');
            });
        });
    }

    function closeModal() {
        console.log('Fermeture du modal'); // Debug

        const modal = document.getElementById('detailsModal');
        const modalContent = modal.querySelector('.bg-white');

        // Animation de fermeture
        modalContent.classList.remove('scale-100', 'opacity-100');
        modalContent.classList.add('scale-95', 'opacity-0');

        setTimeout(() => {
            modal.classList.add('hidden');
            modal.style.display = 'none';
            document.body.style.overflow = 'auto';
            console.log('Modal fermé'); // Debug
        }, 300);
    }

    // Fermer le modal en cliquant à l'extérieur
    document.getElementById('detailsModal')?.addEventListener('click', function(e) {
        if (e.target === this) {
            closeModal();
        }
    });

    // Fermer avec la touche Escape
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            closeModal();
        }
    });

    // Observer pour les animations au scroll (optionnel)
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.remove('opacity-0', 'translate-y-4');
                entry.target.classList.add('opacity-100', 'translate-y-0');
            }
        });
    }, observerOptions);

    // Observer les éléments qui entrent dans la vue
    document.addEventListener('DOMContentLoaded', function() {
        const animatedElements = document.querySelectorAll('.group, .mb-6, .mb-8');
        animatedElements.forEach(el => {
            if (!el.classList.contains('opacity-100')) {
                observer.observe(el);
            }
        });
    });
</script>

</body>
</html>