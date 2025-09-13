<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Utilisateurs</title>
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
                            <i class="fas fa-users text-4xl"></i>
                        </div>

                        <h1 class="text-5xl font-bold mb-4 tracking-tight">
                            <c:choose>
                                <c:when test="${sessionScope.user.role == 'ADMIN'}">
                                    Gestion des Utilisateurs
                                </c:when>
                                <c:otherwise>
                                    Équipe et Collaborateurs
                                </c:otherwise>
                            </c:choose>
                        </h1>

                        <p class="text-xl text-white text-opacity-90 max-w-2xl mx-auto leading-relaxed">
                            <c:choose>
                                <c:when test="${sessionScope.user.role == 'ADMIN'}">
                                    Gérez les comptes utilisateurs, les rôles et les permissions de votre système
                                </c:when>
                                <c:otherwise>
                                    Consultez les informations de l'équipe et des collaborateurs
                                </c:otherwise>
                            </c:choose>
                        </p>

                        <div class="flex justify-center mt-8 space-x-4">
                            <div class="flex items-center bg-white text-black bg-opacity-20 backdrop-blur-sm rounded-full px-4 py-2">
                                <i class="fas fa-shield-alt text-blue-300 mr-2"></i>
                                <span class="text-sm">Sécurisé</span>
                            </div>
                            <div class="flex items-center bg-white text-black bg-opacity-20 backdrop-blur-sm rounded-full px-4 py-2">
                                <i class="fas fa-user-check text-green-300 mr-2"></i>
                                <span class="text-sm">Gestion des rôles</span>
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
                            <i class="fas fa-users text-blue-600"></i>
                        </div>
                        <div class="ml-4">
                            <p class="text-2xl font-bold text-gray-900">${users.size()}</p>
                            <p class="text-gray-600">Total utilisateurs</p>
                        </div>
                    </div>
                </div>

                <div class="bg-white rounded-2xl p-6 shadow-lg border border-gray-100">
                    <div class="flex items-center">
                        <div class="w-12 h-12 bg-green-100 rounded-xl flex items-center justify-center">
                            <i class="fas fa-user-shield text-green-600"></i>
                        </div>
                        <div class="ml-4">
                            <p class="text-2xl font-bold text-gray-900">
                                <c:set var="admins" value="0" />
                                <c:forEach var="u" items="${users}">
                                    <c:if test="${u.role == 'ADMIN'}">
                                        <c:set var="admins" value="${admins + 1}" />
                                    </c:if>
                                </c:forEach>
                                ${admins}
                            </p>
                            <p class="text-gray-600">Administrateurs</p>
                        </div>
                    </div>
                </div>

                <div class="bg-white rounded-2xl p-6 shadow-lg border border-gray-100">
                    <div class="flex items-center">
                        <div class="w-12 h-12 bg-yellow-100 rounded-xl flex items-center justify-center">
                            <i class="fas fa-home text-yellow-600"></i>
                        </div>
                        <div class="ml-4">
                            <p class="text-2xl font-bold text-gray-900">
                                <c:set var="proprietaires" value="0" />
                                <c:forEach var="u" items="${users}">
                                    <c:if test="${u.role == 'PROPRIETAIRE'}">
                                        <c:set var="proprietaires" value="${proprietaires + 1}" />
                                    </c:if>
                                </c:forEach>
                                ${proprietaires}
                            </p>
                            <p class="text-gray-600">Propriétaires</p>
                        </div>
                    </div>
                </div>

                <div class="bg-white rounded-2xl p-6 shadow-lg border border-gray-100">
                    <div class="flex items-center">
                        <div class="w-12 h-12 bg-purple-100 rounded-xl flex items-center justify-center">
                            <i class="fas fa-user text-purple-600"></i>
                        </div>
                        <div class="ml-4">
                            <p class="text-2xl font-bold text-gray-900">
                                <c:set var="locataires" value="0" />
                                <c:forEach var="u" items="${users}">
                                    <c:if test="${u.role == 'LOCATAIRE'}">
                                        <c:set var="locataires" value="${locataires + 1}" />
                                    </c:if>
                                </c:forEach>
                                ${locataires}
                            </p>
                            <p class="text-gray-600">Locataires</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Actions rapides -->
            <div class="mb-8 bg-white rounded-2xl shadow-lg border border-gray-100 p-6">
                <div class="flex flex-col md:flex-row md:items-center md:justify-between space-y-4 md:space-y-0">
                    <div class="flex items-center space-x-4">
                        <form method="get" action="user" class="flex items-center space-x-4">
                            <div class="relative">
                                <input type="text" id="searchInput" name="searchNom"
                                       placeholder="Rechercher un utilisateur..."
                                       value="${param.searchNom}"
                                       class="w-64 pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <i class="fas fa-search text-gray-400"></i>
                                </div>
                            </div>
                            <button type="submit" class="inline-flex items-center px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white font-medium rounded-lg transition-colors duration-200">
                                <i class="fas fa-search mr-2"></i>Rechercher
                            </button>
                        </form>

                        <select id="filterSelect" class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                            <option value="">Tous les rôles</option>
                            <option value="ADMIN">Administrateurs</option>
                            <option value="PROPRIETAIRE">Propriétaires</option>
                            <option value="LOCATAIRE">Locataires</option>
                        </select>
                    </div>

                    <div class="flex items-center space-x-2">
                        <c:if test="${sessionScope.user.role == 'ADMIN'}">
                            <a href="user?action=add" class="inline-flex items-center px-6 py-2 bg-gradient-to-r from-blue-600 to-blue-700 hover:from-blue-700 hover:to-blue-800 text-white font-medium rounded-lg transition-all duration-200 transform hover:scale-105 shadow-lg hover:shadow-xl">
                                <i class="fas fa-plus mr-2"></i>Nouvel utilisateur
                            </a>
                        </c:if>

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
                    <c:when test="${not empty users}">
                        <c:forEach var="u" items="${users}">
                            <div class="bg-white rounded-2xl shadow-lg border border-gray-100 overflow-hidden hover:shadow-xl transition-shadow duration-300 user-card"
                                 data-search="${u.nom} ${u.prenom} ${u.email}"
                                 data-role="${u.role}">

                                <!-- Header avec avatar -->
                                <div class="relative bg-gradient-to-br from-blue-500 to-purple-600 p-6 text-white">
                                    <!-- Badge de rôle -->
                                    <div class="absolute top-4 right-4">
                                        <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-white/20 bg-opacity-20 backdrop-blur-sm">
                                            <c:choose>
                                                <c:when test="${u.role == 'ADMIN'}">
                                                    <i class="fas fa-crown mr-1"></i>Admin
                                                </c:when>
                                                <c:when test="${u.role == 'PROPRIETAIRE'}">
                                                    <i class="fas fa-home mr-1"></i>Propriétaire
                                                </c:when>
                                                <c:when test="${u.role == 'LOCATAIRE'}">
                                                    <i class="fas fa-user mr-1"></i>Locataire
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="fas fa-user mr-1"></i>${u.role}
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>

                                    <!-- Avatar -->
                                    <div class="text-center">
                                        <div class="w-20 h-20 bg-white/20 bg-opacity-20 backdrop-blur-sm rounded-full flex items-center justify-center mx-auto mb-4 text-2xl font-bold">
                                                ${u.prenom.charAt(0)}${u.nom.charAt(0)}
                                        </div>
                                        <h3 class="text-xl font-bold">${u.prenom} ${u.nom}</h3>
                                        <p class="text-white text-opacity-80 text-sm">#${u.id}</p>
                                    </div>
                                </div>

                                <!-- Contenu -->
                                <div class="p-6">
                                    <!-- Informations de contact -->
                                    <div class="space-y-3 mb-6">
                                        <div class="flex items-center text-gray-600">
                                            <i class="fas fa-envelope w-5 mr-3 text-blue-500"></i>
                                            <span class="text-sm truncate">${u.email}</span>
                                        </div>
                                        <c:if test="${not empty u.telephone}">
                                            <div class="flex items-center text-gray-600">
                                                <i class="fas fa-phone w-5 mr-3 text-green-500"></i>
                                                <span class="text-sm">${u.telephone}</span>
                                            </div>
                                        </c:if>
                                    </div>

                                    <!-- Statut et informations -->
                                    <div class="grid grid-cols-2 gap-4 mb-6">
                                        <div class="bg-green-50 rounded-lg p-3 text-center">
                                            <div class="text-xl font-bold text-green-600">
                                                <i class="fas fa-check-circle"></i>
                                            </div>
                                            <div class="text-xs text-green-600">Actif</div>
                                        </div>
                                        <div class="bg-blue-50 rounded-lg p-3 text-center">
                                            <div class="text-xl font-bold text-blue-600">
                                                <i class="fas fa-calendar"></i>
                                            </div>
                                            <div class="text-xs text-blue-600">Inscrit</div>
                                        </div>
                                    </div>

                                    <!-- Actions -->
                                    <div class="flex items-center justify-between pt-4 border-t border-gray-100">
                                        <button onclick="viewDetails(${u.id})" class="inline-flex items-center px-3 py-2 bg-blue-100 hover:bg-blue-200 text-blue-600 text-sm font-medium rounded-lg transition-colors duration-200">
                                            <i class="fas fa-eye mr-1"></i>Voir
                                        </button>

                                        <div class="flex items-center space-x-2">
                                            <c:if test="${sessionScope.user.role == 'ADMIN' or sessionScope.user.id == u.id}">
                                                <a href="user?action=edit&id=${u.id}" class="inline-flex items-center justify-center w-8 h-8 bg-yellow-100 hover:bg-yellow-200 text-yellow-600 rounded-lg transition-colors duration-200" title="Modifier">
                                                    <i class="fas fa-edit text-sm"></i>
                                                </a>
                                            </c:if>

                                            <c:if test="${sessionScope.user.role == 'ADMIN' and sessionScope.user.id != u.id}">
                                                <button onclick="confirmDelete(${u.id}, '${u.prenom} ${u.nom}')" class="inline-flex items-center justify-center w-8 h-8 bg-red-100 hover:bg-red-200 text-red-600 rounded-lg transition-colors duration-200" title="Supprimer">
                                                    <i class="fas fa-trash text-sm"></i>
                                                </button>
                                            </c:if>
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
                                    <i class="fas fa-users text-4xl text-gray-400"></i>
                                </div>
                                <h3 class="text-2xl font-semibold text-gray-900 mb-4">Aucun utilisateur trouvé</h3>
                                <p class="text-gray-600 mb-6">Commencez par ajouter votre premier utilisateur.</p>
                                <c:if test="${sessionScope.user.role == 'ADMIN'}">
                                    <a href="user?action=add" class="inline-flex items-center px-6 py-3 bg-blue-600 hover:bg-blue-700 text-white font-medium rounded-xl transition-colors duration-200">
                                        <i class="fas fa-plus mr-2"></i>Ajouter un utilisateur
                                    </a>
                                </c:if>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Vue liste (masquée par défaut) -->
            <div id="listViewContainer" class="hidden bg-white rounded-2xl shadow-lg border border-gray-100 overflow-hidden">
                <c:if test="${not empty users}">
                    <div class="overflow-x-auto">
                        <table class="w-full">
                            <thead class="bg-gradient-to-r from-gray-800 to-gray-900 text-white">
                            <tr>
                                <th class="px-6 py-4 text-left text-sm font-semibold">Utilisateur</th>
                                <th class="px-6 py-4 text-left text-sm font-semibold">Email</th>
                                <th class="px-6 py-4 text-left text-sm font-semibold">Téléphone</th>
                                <th class="px-6 py-4 text-left text-sm font-semibold">Rôle</th>
                                <th class="px-6 py-4 text-left text-sm font-semibold">Statut</th>
                                <th class="px-6 py-4 text-left text-sm font-semibold">Actions</th>
                            </tr>
                            </thead>
                            <tbody class="divide-y divide-gray-200" id="userTableBody">
                            <c:forEach var="u" items="${users}">
                                <tr class="hover:bg-gray-50 transition-colors duration-200 user-row"
                                    data-search="${u.nom} ${u.prenom} ${u.email}"
                                    data-role="${u.role}">
                                    <td class="px-6 py-4">
                                        <div class="flex items-center">
                                            <div class="w-10 h-10 bg-gradient-to-br from-blue-500 to-purple-600 rounded-full flex items-center justify-center text-white font-bold text-sm mr-3">
                                                    ${u.prenom.charAt(0)}${u.nom.charAt(0)}
                                            </div>
                                            <div>
                                                <div class="font-semibold text-gray-900">${u.prenom} ${u.nom}</div>
                                                <div class="text-sm text-gray-500">#${u.id}</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="px-6 py-4">
                                        <div class="text-gray-900">${u.email}</div>
                                    </td>
                                    <td class="px-6 py-4">
                                        <div class="text-gray-900">
                                            <c:choose>
                                                <c:when test="${not empty u.telephone}">
                                                    ${u.telephone}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-gray-400">Non renseigné</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                    <td class="px-6 py-4">
                                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium
                                            <c:choose>
                                                <c:when test="${u.role == 'ADMIN'}">bg-red-100 text-red-800</c:when>
                                                <c:when test="${u.role == 'PROPRIETAIRE'}">bg-blue-100 text-blue-800</c:when>
                                                <c:when test="${u.role == 'LOCATAIRE'}">bg-green-100 text-green-800</c:when>
                                                <c:otherwise>bg-gray-100 text-gray-800</c:otherwise>
                                            </c:choose>">
                                            <c:choose>
                                                <c:when test="${u.role == 'ADMIN'}">
                                                    <i class="fas fa-crown mr-1"></i>Administrateur
                                                </c:when>
                                                <c:when test="${u.role == 'PROPRIETAIRE'}">
                                                    <i class="fas fa-home mr-1"></i>Propriétaire
                                                </c:when>
                                                <c:when test="${u.role == 'LOCATAIRE'}">
                                                    <i class="fas fa-user mr-1"></i>Locataire
                                                </c:when>
                                                <c:otherwise>
                                                    ${u.role}
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </td>
                                    <td class="px-6 py-4">
                                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                            <i class="fas fa-check-circle mr-1"></i>Actif
                                        </span>
                                    </td>
                                    <td class="px-6 py-4">
                                        <div class="flex items-center space-x-2">
                                            <button onclick="viewDetails(${u.id})" class="inline-flex items-center justify-center w-8 h-8 bg-blue-100 hover:bg-blue-200 text-blue-600 rounded-lg transition-colors duration-200" title="Voir détails">
                                                <i class="fas fa-eye text-sm"></i>
                                            </button>

                                            <c:if test="${sessionScope.user.role == 'ADMIN' or sessionScope.user.id == u.id}">
                                                <a href="user?action=edit&id=${u.id}" class="inline-flex items-center justify-center w-8 h-8 bg-yellow-100 hover:bg-yellow-200 text-yellow-600 rounded-lg transition-colors duration-200" title="Modifier">
                                                    <i class="fas fa-edit text-sm"></i>
                                                </a>
                                            </c:if>

                                            <c:if test="${sessionScope.user.role == 'ADMIN' and sessionScope.user.id != u.id}">
                                                <button onclick="confirmDelete(${u.id}, '${u.prenom} ${u.nom}')" class="inline-flex items-center justify-center w-8 h-8 bg-red-100 hover:bg-red-200 text-red-600 rounded-lg transition-colors duration-200" title="Supprimer">
                                                    <i class="fas fa-trash text-sm"></i>
                                                </button>
                                            </c:if>
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
                    <i class="fas fa-user-times text-2xl text-red-600"></i>
                </div>
                <p class="text-gray-700">
                    Êtes-vous sûr de vouloir supprimer l'utilisateur <strong id="deleteUserNom"></strong> ?
                </p>
                <p class="text-sm text-gray-500 mt-2">
                    Cette action est irréversible et supprimera définitivement le compte utilisateur.
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
    <div class="bg-white bg-opacity-95 backdrop-blur-sm rounded-3xl max-w-4xl w-full max-h-[90vh] shadow-2xl border border-gray-100 transform scale-95 opacity-0 transition-all duration-300 flex flex-col">
        <div class="bg-gradient-to-r from-blue-600 to-blue-700 text-white p-6 rounded-t-3xl flex-shrink-0">
            <div class="flex items-center justify-between">
                <h3 class="text-2xl font-bold flex items-center">
                    <i class="fas fa-user-circle mr-3"></i>
                    Détails de l'utilisateur
                </h3>
                <button onclick="closeDetailModal()" class="w-8 h-8 flex items-center justify-center text-white hover:bg-white hover:bg-opacity-20 rounded-lg transition-colors duration-200">
                    <i class="fas fa-times"></i>
                </button>
            </div>
        </div>

        <div class="p-8 overflow-y-auto flex-1" id="detailContent">
            <!-- Le contenu sera injecté dynamiquement -->
        </div>
    </div>
</div>

<script>
    // Variables globales
    let currentView = 'grid';
    let deleteUserId = null;

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

        if (searchInput) {
            searchInput.addEventListener('input', filterUsers);
        }
        if (filterSelect) {
            filterSelect.addEventListener('change', filterUsers);
        }
    }

    // Initialisation des vues
    function initializeViews() {
        const gridViewBtn = document.getElementById('gridView');
        const listViewBtn = document.getElementById('listView');

        if (gridViewBtn) gridViewBtn.addEventListener('click', () => switchView('grid'));
        if (listViewBtn) listViewBtn.addEventListener('click', () => switchView('list'));
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

    // Filtrer les utilisateurs
    function filterUsers() {
        const searchTerm = document.getElementById('searchInput')?.value.toLowerCase() || '';
        const filterValue = document.getElementById('filterSelect')?.value || '';

        const cards = document.querySelectorAll('.user-card');
        const rows = document.querySelectorAll('.user-row');

        let visibleCount = 0;

        // Filtrer les cartes
        cards.forEach(card => {
            const searchData = card.getAttribute('data-search').toLowerCase();
            const role = card.getAttribute('data-role');

            const matchesSearch = searchData.includes(searchTerm);
            const matchesFilter = !filterValue || role === filterValue;

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
            const role = row.getAttribute('data-role');

            const matchesSearch = searchData.includes(searchTerm);
            const matchesFilter = !filterValue || role === filterValue;

            if (matchesSearch && matchesFilter) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }

    // Confirmer la suppression
    function confirmDelete(id, nom) {
        deleteUserId = id;
        document.getElementById('deleteUserNom').textContent = nom;
        showModal(document.getElementById('deleteModal'));
    }

    function closeDeleteModal() {
        hideModal(document.getElementById('deleteModal'));
        deleteUserId = null;
    }

    function executeDelete() {
        if (deleteUserId) {
            window.location.href = `user?action=delete&id=${deleteUserId}`;
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
                                <i class="fas fa-user-circle text-blue-600 mr-3"></i>
                                Informations personnelles
                            </h4>
                            <div class="space-y-2">
                                <p><span class="font-medium text-gray-700">ID :</span> <span class="text-gray-900">#${id}</span></p>
                                <p><span class="font-medium text-gray-700">Statut :</span> <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800">Actif</span></p>
                                <p><span class="font-medium text-gray-700">Date d'inscription :</span> <span class="text-gray-900">15 janvier 2024</span></p>
                                <p><span class="font-medium text-gray-700">Dernière connexion :</span> <span class="text-gray-900">Aujourd'hui à 14:32</span></p>
                            </div>
                        </div>

                        <div class="bg-gradient-to-r from-green-50 to-emerald-50 rounded-2xl p-6 border border-green-200">
                            <h4 class="font-bold text-lg text-gray-900 mb-4 flex items-center">
                                <i class="fas fa-shield-alt text-green-600 mr-3"></i>
                                Sécurité et permissions
                            </h4>
                            <div class="space-y-2">
                                <p><span class="font-medium text-gray-700">Authentification 2FA :</span> <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800">Activée</span></p>
                                <p><span class="font-medium text-gray-700">Dernière modification :</span> <span class="text-gray-900">20 novembre 2024</span></p>
                                <p><span class="font-medium text-gray-700">Sessions actives :</span> <span class="text-gray-900">2 appareils</span></p>
                                <p><span class="font-medium text-gray-700">Tentatives échouées :</span> <span class="text-gray-900">0</span></p>
                            </div>
                        </div>

                        <div class="bg-gradient-to-r from-yellow-50 to-orange-50 rounded-2xl p-6 border border-yellow-200">
                            <h4 class="font-bold text-lg text-gray-900 mb-4 flex items-center">
                                <i class="fas fa-building text-yellow-600 mr-3"></i>
                                Propriétés gérées
                            </h4>
                            <div class="space-y-2">
                                <p><span class="font-medium text-gray-700">Immeubles :</span> <span class="text-gray-900">3 propriétés</span></p>
                                <p><span class="font-medium text-gray-700">Unités totales :</span> <span class="text-gray-900">45 unités</span></p>
                                <p><span class="font-medium text-gray-700">Taux d'occupation :</span> <span class="text-gray-900">87%</span></p>
                                <p><span class="font-medium text-gray-700">Revenus mensuels :</span> <span class="text-gray-900">2,850,000 FCFA</span></p>
                            </div>
                        </div>
                    </div>

                    <div class="space-y-6">
                        <div class="bg-gradient-to-r from-purple-50 to-pink-50 rounded-2xl p-6 border border-purple-200">
                            <h4 class="font-bold text-lg text-gray-900 mb-4 flex items-center">
                                <i class="fas fa-chart-line text-purple-600 mr-3"></i>
                                Activité récente
                            </h4>
                            <div class="space-y-3">
                                <div class="bg-white rounded-lg p-3 border border-purple-100">
                                    <div class="flex items-center justify-between">
                                        <span class="text-sm font-medium text-gray-700">Connexions ce mois</span>
                                        <span class="text-purple-600 font-bold">28</span>
                                    </div>
                                    <div class="text-xs text-gray-500 mt-1">En hausse de 15%</div>
                                </div>
                                <div class="space-y-2 text-sm">
                                    <p><span class="font-medium text-gray-700">Actions réalisées :</span> <span class="text-gray-900">147 cette semaine</span></p>
                                    <p><span class="font-medium text-gray-700">Contrats créés :</span> <span class="text-gray-900">5 ce mois</span></p>
                                    <p><span class="font-medium text-gray-700">Paiements traités :</span> <span class="text-gray-900">23 ce mois</span></p>
                                </div>
                            </div>
                        </div>

                        <div class="bg-gradient-to-r from-indigo-50 to-blue-50 rounded-2xl p-6 border border-indigo-200">
                            <h4 class="font-bold text-lg text-gray-900 mb-4 flex items-center">
                                <i class="fas fa-cog text-indigo-600 mr-3"></i>
                                Préférences
                            </h4>
                            <div class="space-y-2">
                                <p><span class="font-medium text-gray-700">Langue :</span> <span class="text-gray-900">Français</span></p>
                                <p><span class="font-medium text-gray-700">Fuseau horaire :</span> <span class="text-gray-900">GMT+0 (Dakar)</span></p>
                                <p><span class="font-medium text-gray-700">Notifications email :</span> <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-blue-100 text-blue-800">Activées</span></p>
                                <p><span class="font-medium text-gray-700">Notifications push :</span> <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800">Activées</span></p>
                            </div>
                        </div>

                        <div class="bg-gradient-to-r from-gray-50 to-slate-50 rounded-2xl p-6 border border-gray-200">
                            <h4 class="font-bold text-lg text-gray-900 mb-4 flex items-center">
                                <i class="fas fa-history text-gray-600 mr-3"></i>
                                Historique des modifications
                            </h4>
                            <div class="space-y-2 text-sm">
                                <div class="bg-white rounded-lg p-3 border border-gray-100">
                                    <div class="flex justify-between items-center">
                                        <span class="font-medium text-gray-700">Profil mis à jour</span>
                                        <span class="text-gray-500">20/11/2024</span>
                                    </div>
                                    <div class="text-xs text-gray-500 mt-1">Numéro de téléphone modifié</div>
                                </div>
                                <div class="bg-white rounded-lg p-3 border border-gray-100">
                                    <div class="flex justify-between items-center">
                                        <span class="font-medium text-gray-700">Mot de passe changé</span>
                                        <span class="text-gray-500">15/11/2024</span>
                                    </div>
                                    <div class="text-xs text-gray-500 mt-1">Par l'utilisateur</div>
                                </div>
                                <div class="bg-white rounded-lg p-3 border border-gray-100">
                                    <div class="flex justify-between items-center">
                                        <span class="font-medium text-gray-700">Nouveau rôle attribué</span>
                                        <span class="text-gray-500">10/11/2024</span>
                                    </div>
                                    <div class="text-xs text-gray-500 mt-1">Par l'administrateur</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Actions rapides -->
                <div class="mt-8 bg-gradient-to-r from-gray-50 to-blue-50 rounded-2xl p-6 border border-gray-200">
                    <h4 class="font-bold text-lg text-gray-900 mb-4 flex items-center">
                        <i class="fas fa-bolt text-yellow-500 mr-3"></i>
                        Actions rapides
                    </h4>
                    <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                        <button class="flex flex-col items-center p-4 bg-white rounded-xl border border-gray-200 hover:border-blue-300 hover:shadow-md transition-all duration-200">
                            <i class="fas fa-edit text-blue-600 text-xl mb-2"></i>
                            <span class="text-sm font-medium text-gray-700">Modifier profil</span>
                        </button>
                        <button class="flex flex-col items-center p-4 bg-white rounded-xl border border-gray-200 hover:border-orange-300 hover:shadow-md transition-all duration-200">
                            <i class="fas fa-key text-orange-600 text-xl mb-2"></i>
                            <span class="text-sm font-medium text-gray-700">Réinitialiser MDP</span>
                        </button>
                        <button class="flex flex-col items-center p-4 bg-white rounded-xl border border-gray-200 hover:border-purple-300 hover:shadow-md transition-all duration-200">
                            <i class="fas fa-user-cog text-purple-600 text-xl mb-2"></i>
                            <span class="text-sm font-medium text-gray-700">Permissions</span>
                        </button>
                        <button class="flex flex-col items-center p-4 bg-white rounded-xl border border-gray-200 hover:border-red-300 hover:shadow-md transition-all duration-200">
                            <i class="fas fa-ban text-red-600 text-xl mb-2"></i>
                            <span class="text-sm font-medium text-gray-700">Suspendre</span>
                        </button>
                    </div>
                </div>
            `;
        }, 1000);
    }

    function closeDetailModal() {
        hideModal(document.getElementById('detailModal'));
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
        const deleteModal = document.getElementById('deleteModal');
        const detailModal = document.getElementById('detailModal');

        if (e.target === deleteModal) closeDeleteModal();
        if (e.target === detailModal) closeDetailModal();
    });

    // Fermer avec Escape
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            const deleteModal = document.getElementById('deleteModal');
            const detailModal = document.getElementById('detailModal');

            if (!deleteModal.classList.contains('hidden')) closeDeleteModal();
            if (!detailModal.classList.contains('hidden')) closeDetailModal();
        }
    });
</script>

</body>
</html>