<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Demandes</title>
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
                        <div class="inline-flex items-center justify-center w-24 h-24 bg-white/20 bg-opacity-20 backdrop-blur-sm rounded-full mb-6">
                            <i class="fas fa-file-alt text-4xl"></i>
                        </div>

                        <h1 class="text-5xl font-bold mb-4 tracking-tight">
                            <c:choose>
                                <c:when test="${sessionScope.user.role == 'ADMIN'}">
                                    Toutes les Demandes
                                </c:when>
                                <c:when test="${sessionScope.user.role == 'PROPRIETAIRE'}">
                                    Demandes pour Mes Propriétés
                                </c:when>
                                <c:when test="${sessionScope.user.role == 'LOCATAIRE'}">
                                    Mes Demandes
                                </c:when>
                                <c:otherwise>
                                    Gestion des Demandes
                                </c:otherwise>
                            </c:choose>
                        </h1>

                        <p class="text-xl text-white text-opacity-90 max-w-2xl mx-auto leading-relaxed">
                            <c:choose>
                                <c:when test="${sessionScope.user.role == 'ADMIN'}">
                                    Gérez et suivez toutes les demandes de location dans le système
                                </c:when>
                                <c:when test="${sessionScope.user.role == 'PROPRIETAIRE'}">
                                    Consultez et gérez les demandes de location pour vos propriétés
                                </c:when>
                                <c:when test="${sessionScope.user.role == 'LOCATAIRE'}">
                                    Suivez l'état de vos demandes de location et leurs réponses
                                </c:when>
                                <c:otherwise>
                                    Gérez efficacement toutes les demandes de location
                                </c:otherwise>
                            </c:choose>
                        </p>

                        <div class="flex justify-center mt-8 space-x-4">
                            <div class="flex items-center bg-white text-black bg-opacity-20 backdrop-blur-sm rounded-full px-4 py-2">
                                <i class="fas fa-clock text-blue-300 mr-2"></i>
                                <span class="text-sm">Suivi en temps réel</span>
                            </div>
                            <div class="flex items-center bg-white text-black bg-opacity-20 backdrop-blur-sm rounded-full px-4 py-2">
                                <i class="fas fa-shield-alt text-green-300 mr-2"></i>
                                <span class="text-sm">Sécurisé</span>
                            </div>
                            <c:if test="${sessionScope.user.role == 'LOCATAIRE'}">
                                <div class="flex items-center bg-white text-black bg-opacity-20 backdrop-blur-sm rounded-full px-4 py-2">
                                    <i class="fas fa-bell text-yellow-300 mr-2"></i>
                                    <span class="text-sm">Notifications</span>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Statistiques rapides -->
            <div class="mb-8 grid grid-cols-1 md:grid-cols-3 gap-6">
                <div class="bg-white rounded-2xl p-6 shadow-lg border border-gray-100">
                    <div class="flex items-center">
                        <div class="w-12 h-12 bg-blue-100 rounded-xl flex items-center justify-center">
                            <i class="fas fa-file-alt text-blue-600"></i>
                        </div>
                        <div class="ml-4">
                            <p class="text-2xl font-bold text-gray-900">${demandeLocations.size()}</p>
                            <p class="text-gray-600">Total demandes</p>
                        </div>
                    </div>
                </div>

                <div class="bg-white rounded-2xl p-6 shadow-lg border border-gray-100">
                    <div class="flex items-center">
                        <div class="w-12 h-12 bg-yellow-100 rounded-xl flex items-center justify-center">
                            <i class="fas fa-clock text-yellow-600"></i>
                        </div>
                        <div class="ml-4">
                            <p class="text-2xl font-bold text-gray-900">
                                <c:set var="enAttente" value="0" />
                                <c:forEach var="d" items="${demandeLocations}">
                                    <c:if test="${d.status == 'EN_ATTENTE'}">
                                        <c:set var="enAttente" value="${enAttente + 1}" />
                                    </c:if>
                                </c:forEach>
                                ${enAttente}
                            </p>
                            <p class="text-gray-600">En attente</p>
                        </div>
                    </div>
                </div>

                <div class="bg-white rounded-2xl p-6 shadow-lg border border-gray-100">
                    <div class="flex items-center">
                        <div class="w-12 h-12 bg-green-100 rounded-xl flex items-center justify-center">
                            <i class="fas fa-check text-green-600"></i>
                        </div>
                        <div class="ml-4">
                            <p class="text-2xl font-bold text-gray-900">
                                <c:set var="acceptees" value="0" />
                                <c:forEach var="d" items="${demandeLocations}">
                                    <c:if test="${d.status == 'ACCEPTEE'}">
                                        <c:set var="acceptees" value="${acceptees + 1}" />
                                    </c:if>
                                </c:forEach>
                                ${acceptees}
                            </p>
                            <p class="text-gray-600">Acceptées</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Action rapide pour locataire -->
            <c:if test="${sessionScope.user.role == 'LOCATAIRE' && empty demandeLocations}">
                <div class="mb-8">
                    <div class="bg-gradient-to-r from-blue-50 to-indigo-50 rounded-2xl p-8 border border-blue-200">
                        <div class="text-center">
                            <div class="w-16 h-16 bg-blue-100 rounded-full flex items-center justify-center mx-auto mb-4">
                                <i class="fas fa-search text-blue-600 text-2xl"></i>
                            </div>
                            <h3 class="text-xl font-semibold text-gray-900 mb-2">Prêt à trouver votre logement ?</h3>
                            <p class="text-gray-600 mb-6">Explorez notre catalogue de logements disponibles et faites votre première demande</p>
                            <a href="unite" class="inline-flex items-center px-6 py-3 bg-gradient-to-r from-blue-600 to-blue-700 hover:from-blue-700 hover:to-blue-800 text-white font-medium rounded-xl transition-all duration-200 transform hover:scale-105 shadow-lg hover:shadow-xl">
                                <i class="fas fa-search mr-2"></i>Rechercher un logement
                            </a>
                        </div>
                    </div>
                </div>
            </c:if>

            <!-- Messages -->
            <c:if test="${not empty sessionScope.successMessage}">
                <div class="mb-6 animate-slide-up">
                    <div class="bg-green-50 border border-green-200 rounded-xl p-4 flex items-center">
                        <div class="w-10 h-10 bg-green-100 rounded-full flex items-center justify-center mr-4">
                            <i class="fas fa-check-circle text-green-600"></i>
                        </div>
                        <div class="flex-1">
                            <p class="text-green-800 font-medium">${sessionScope.successMessage}</p>
                        </div>
                        <button onclick="this.parentElement.parentElement.remove()" class="text-green-400 hover:text-green-600 transition-colors duration-200">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                </div>
                <c:remove var="successMessage" scope="session" />
            </c:if>

            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="mb-6 animate-slide-up">
                    <div class="bg-red-50 border border-red-200 rounded-xl p-4 flex items-center">
                        <div class="w-10 h-10 bg-red-100 rounded-full flex items-center justify-center mr-4">
                            <i class="fas fa-exclamation-triangle text-red-600"></i>
                        </div>
                        <div class="flex-1">
                            <p class="text-red-800 font-medium">${sessionScope.errorMessage}</p>
                        </div>
                        <button onclick="this.parentElement.parentElement.remove()" class="text-red-400 hover:text-red-600 transition-colors duration-200">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                </div>
                <c:remove var="errorMessage" scope="session" />
            </c:if>

            <!-- Tableau des demandes -->
            <div class="bg-white rounded-2xl shadow-lg border border-gray-100 overflow-hidden">
                <c:choose>
                    <c:when test="${not empty demandeLocations}">
                        <div class="overflow-x-auto">
                            <table class="w-full">
                                <thead class="bg-gradient-to-r from-gray-800 to-gray-900 text-white">
                                <tr>
                                    <th class="px-6 py-4 text-left text-sm font-semibold">
                                        <i class="fas fa-hashtag mr-2"></i>ID
                                    </th>
                                    <c:if test="${sessionScope.user.role != 'LOCATAIRE'}">
                                        <th class="px-6 py-4 text-left text-sm font-semibold">
                                            <i class="fas fa-user mr-2"></i>Demandeur
                                        </th>
                                    </c:if>
                                    <th class="px-6 py-4 text-left text-sm font-semibold">
                                        <i class="fas fa-door-open mr-2"></i>Unité
                                    </th>
                                    <th class="px-6 py-4 text-left text-sm font-semibold">
                                        <i class="fas fa-building mr-2"></i>Immeuble
                                    </th>
                                    <c:if test="${sessionScope.user.role == 'LOCATAIRE'}">
                                        <th class="px-6 py-4 text-left text-sm font-semibold">
                                            <i class="fas fa-user-tie mr-2"></i>Propriétaire
                                        </th>
                                    </c:if>
                                    <th class="px-6 py-4 text-left text-sm font-semibold">
                                        <i class="fas fa-info-circle mr-2"></i>Statut
                                    </th>
                                    <th class="px-6 py-4 text-left text-sm font-semibold">
                                        <i class="fas fa-comment mr-2"></i>Motif
                                    </th>
                                    <th class="px-6 py-4 text-left text-sm font-semibold">
                                        <i class="fas fa-cog mr-2"></i>Actions
                                    </th>
                                </tr>
                                </thead>
                                <tbody class="divide-y divide-gray-200">
                                <c:forEach var="demande" items="${demandeLocations}" varStatus="status">
                                    <tr class="hover:bg-gray-50 transition-colors duration-200">
                                        <td class="px-6 py-4">
                                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800">
                                                    ${demande.id}
                                            </span>
                                        </td>

                                        <!-- Demandeur (pas pour les locataires) -->
                                        <c:if test="${sessionScope.user.role != 'LOCATAIRE'}">
                                            <td class="px-6 py-4">
                                                <c:choose>
                                                    <c:when test="${not empty demande.locataire && not empty demande.locataire.user}">
                                                        <div>
                                                            <div class="font-semibold text-gray-900">
                                                                    ${demande.locataire.user.prenom} ${demande.locataire.user.nom}
                                                            </div>
                                                            <div class="text-sm text-gray-500">
                                                                    ${demande.locataire.user.email}
                                                            </div>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-gray-400 italic">Utilisateur supprimé</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </c:if>

                                        <!-- Unité -->
                                        <td class="px-6 py-4">
                                            <c:choose>
                                                <c:when test="${not empty demande.uniteLocation}">
                                                    <div>
                                                        <div class="font-semibold text-gray-900">
                                                            Unité N° ${demande.uniteLocation.numeroUnite}
                                                        </div>
                                                        <div class="text-sm text-gray-500">
                                                                ${demande.uniteLocation.nombrePiece} pièces - ${demande.uniteLocation.superficie} m²
                                                        </div>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-gray-400 italic">Unité supprimée</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <!-- Immeuble -->
                                        <td class="px-6 py-4">
                                            <c:choose>
                                                <c:when test="${not empty demande.uniteLocation && not empty demande.uniteLocation.immeuble}">
                                                    <div>
                                                        <div class="font-semibold text-gray-900">
                                                                ${demande.uniteLocation.immeuble.nom}
                                                        </div>
                                                        <div class="text-sm text-gray-500">
                                                                ${demande.uniteLocation.immeuble.adresse}
                                                        </div>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-gray-400 italic">Immeuble non disponible</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <!-- Propriétaire (pour les locataires seulement) -->
                                        <c:if test="${sessionScope.user.role == 'LOCATAIRE'}">
                                            <td class="px-6 py-4">
                                                <c:choose>
                                                    <c:when test="${not empty demande.uniteLocation && not empty demande.uniteLocation.immeuble && not empty demande.uniteLocation.immeuble.proprietaire}">
                                                        <div>
                                                            <div class="font-semibold text-gray-900">
                                                                    ${demande.uniteLocation.immeuble.proprietaire.prenom} ${demande.uniteLocation.immeuble.proprietaire.nom}
                                                            </div>
                                                            <div class="text-sm text-gray-500">
                                                                    ${demande.uniteLocation.immeuble.proprietaire.email}
                                                            </div>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-gray-400 italic">Non renseigné</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </c:if>

                                        <!-- Statut -->
                                        <td class="px-6 py-4">
                                            <c:choose>
                                                <c:when test="${demande.status == 'EN_ATTENTE'}">
                                                    <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800">
                                                        <i class="fas fa-clock mr-1"></i>En attente
                                                    </span>
                                                </c:when>
                                                <c:when test="${demande.status == 'ACCEPTEE'}">
                                                    <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                                        <i class="fas fa-check mr-1"></i>Acceptée
                                                    </span>
                                                </c:when>
                                                <c:when test="${demande.status == 'REJETE'}">
                                                    <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-red-100 text-red-800">
                                                        <i class="fas fa-times mr-1"></i>Rejetée
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-gray-100 text-gray-800">
                                                            ${demande.status}
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <!-- Motif -->
                                        <td class="px-6 py-4">
                                            <c:choose>
                                                <c:when test="${not empty demande.motif && demande.motif.trim() != ''}">
                                                    <div class="max-w-xs truncate" title="${demande.motif}">
                                                            ${demande.motif}
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-gray-400">-</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <!-- Actions -->
                                        <td class="px-6 py-4">
                                            <div class="flex items-center space-x-2">
                                                <!-- Actions pour Admin et Propriétaire -->
                                                <c:if test="${sessionScope.user.role == 'ADMIN' ||
                                                             (sessionScope.user.role == 'PROPRIETAIRE' &&
                                                              not empty demande.uniteLocation &&
                                                              not empty demande.uniteLocation.immeuble &&
                                                              not empty demande.uniteLocation.immeuble.proprietaire &&
                                                              demande.uniteLocation.immeuble.proprietaire.id == sessionScope.user.id)}">

                                                    <c:if test="${demande.status == 'EN_ATTENTE'}">
                                                        <!-- Accepter -->
                                                        <form method="POST" action="demandeLocation" class="inline-block">
                                                            <input type="hidden" name="action" value="update">
                                                            <input type="hidden" name="demandeId" value="${demande.id}">
                                                            <input type="hidden" name="status" value="ACCEPTEE">
                                                            <button type="submit"
                                                                    class="inline-flex items-center justify-center w-8 h-8 bg-green-100 hover:bg-green-200 text-green-600 rounded-lg transition-colors duration-200"
                                                                    onclick="return confirm('Accepter cette demande ?')"
                                                                    title="Accepter">
                                                                <i class="fas fa-check text-sm"></i>
                                                            </button>
                                                        </form>

                                                        <!-- Rejeter -->
                                                        <button type="button"
                                                                class="inline-flex items-center justify-center w-8 h-8 bg-red-100 hover:bg-red-200 text-red-600 rounded-lg transition-colors duration-200"
                                                                onclick="openRejectModal(${demande.id})"
                                                                title="Rejeter">
                                                            <i class="fas fa-times text-sm"></i>
                                                        </button>
                                                    </c:if>
                                                </c:if>

                                                <!-- Voir détails (pour tous) -->
                                                <button type="button"
                                                        class="inline-flex items-center justify-center w-8 h-8 bg-blue-100 hover:bg-blue-200 text-blue-600 rounded-lg transition-colors duration-200"
                                                        onclick="openDetailModal(
                                                                '${demande.id}',
                                                                '${demande.status}',
                                                                '${demande.motif}',
                                                                '${demande.locataire.user.prenom} ${demande.locataire.user.nom}',
                                                                '${demande.locataire.user.email}',
                                                                '${demande.uniteLocation.numeroUnite}',
                                                                '${demande.uniteLocation.nombrePiece}',
                                                                '${demande.uniteLocation.superficie}',
                                                                '${demande.uniteLocation.loyerMensuel}',
                                                                '${demande.uniteLocation.immeuble.nom}',
                                                                '${demande.uniteLocation.immeuble.adresse}'
                                                                )"
                                                        title="Voir détails">
                                                    <i class="fas fa-eye text-sm"></i>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination -->
                        <div class="bg-gray-50 px-6 py-4 border-t border-gray-200">
                            <div class="flex justify-between items-center">
                                <div class="text-sm text-gray-600">
                                        ${demandeLocations.size()} demande(s) affichée(s)
                                </div>
                            </div>
                        </div>

                    </c:when>
                    <c:otherwise>
                        <!-- Message si aucune demande -->
                        <div class="text-center py-16">
                            <div class="w-24 h-24 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-6">
                                <i class="fas fa-inbox text-4xl text-gray-400"></i>
                            </div>
                            <h3 class="text-2xl font-semibold text-gray-900 mb-4">Aucune demande trouvée</h3>
                            <p class="text-gray-600 mb-6 max-w-md mx-auto">
                                <c:choose>
                                    <c:when test="${sessionScope.user.role == 'LOCATAIRE'}">
                                        Vous n'avez pas encore fait de demande de location.
                                    </c:when>
                                    <c:when test="${sessionScope.user.role == 'PROPRIETAIRE'}">
                                        Aucune demande n'a été faite pour vos propriétés.
                                    </c:when>
                                    <c:otherwise>
                                        Aucune demande de location dans le système.
                                    </c:otherwise>
                                </c:choose>
                            </p>

                            <c:if test="${sessionScope.user.role == 'LOCATAIRE'}">
                                <a href="unite" class="inline-flex items-center px-6 py-3 bg-blue-600 hover:bg-blue-700 text-white font-medium rounded-xl transition-colors duration-200">
                                    <i class="fas fa-search mr-2"></i>Rechercher un logement
                                </a>
                            </c:if>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<!-- Modal de rejet -->
<div id="rejectModal" class="fixed inset-0 backdrop-blur-md z-50 hidden flex items-center justify-center p-4">
    <div class="bg-white bg-opacity-95 backdrop-blur-sm rounded-3xl max-w-md w-full shadow-2xl border border-gray-100 transform scale-95 opacity-0 transition-all duration-300">
        <div class="bg-gradient-to-r from-red-600 to-red-700 text-white p-6 rounded-t-3xl">
            <div class="flex items-center justify-between">
                <h3 class="text-xl font-bold flex items-center">
                    <i class="fas fa-times-circle mr-3"></i>
                    Rejeter la demande
                </h3>
                <button onclick="closeRejectModal()" class="w-8 h-8 flex items-center justify-center text-white hover:bg-white hover:bg-opacity-20 rounded-lg transition-colors duration-200">
                    <i class="fas fa-times"></i>
                </button>
            </div>
        </div>

        <form method="POST" action="demandeLocation" class="p-6">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="status" value="REJETE">
            <input type="hidden" name="demandeId" id="rejectDemandeId">

            <div class="mb-6">
                <label class="block text-sm font-semibold text-gray-700 mb-2">
                    Motif du rejet <span class="text-red-500">*</span>
                </label>
                <textarea name="motif"
                          class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-red-500 focus:border-transparent transition-all duration-200"
                          rows="4"
                          required
                          placeholder="Veuillez expliquer pourquoi vous rejetez cette demande..."></textarea>
            </div>

            <div class="flex space-x-4">
                <button type="button"
                        onclick="closeRejectModal()"
                        class="flex-1 px-6 py-3 bg-gray-100 hover:bg-gray-200 text-gray-700 font-semibold rounded-xl transition-colors duration-200">
                    <i class="fas fa-arrow-left mr-2"></i>Annuler
                </button>
                <button type="submit"
                        class="flex-1 px-6 py-3 bg-gradient-to-r from-red-600 to-red-700 hover:from-red-700 hover:to-red-800 text-white font-bold rounded-xl transition-all duration-200">
                    <i class="fas fa-times mr-2"></i>Rejeter
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Modal de détails -->
<div id="detailModal" class="fixed inset-0 backdrop-blur-md z-50 hidden flex items-center justify-center p-4">
    <div class="bg-white bg-opacity-95 backdrop-blur-sm rounded-3xl max-w-4xl w-full max-h-[90vh] overflow-hidden shadow-2xl border border-gray-100 transform scale-95 opacity-0 transition-all duration-300">
        <div class="bg-gradient-to-r from-blue-600 to-blue-700 text-white p-6">
            <div class="flex items-center justify-between">
                <h3 class="text-2xl font-bold flex items-center">
                    <i class="fas fa-info-circle mr-3"></i>
                    Détails de la demande
                </h3>
                <button onclick="closeDetailModal()" class="w-8 h-8 flex items-center justify-center text-white hover:bg-white hover:bg-opacity-20 rounded-lg transition-colors duration-200">
                    <i class="fas fa-times"></i>
                </button>
            </div>
        </div>

        <div class="p-8 overflow-y-auto">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                <div class="space-y-6">
                    <div class="bg-gradient-to-r from-purple-50 to-blue-50 rounded-2xl p-6 border border-purple-200">
                        <h4 class="font-bold text-lg text-gray-900 mb-4 flex items-center">
                            <i class="fas fa-user text-purple-600 mr-3"></i>
                            Informations du demandeur
                        </h4>
                        <div class="space-y-2">
                            <p><span class="font-medium text-gray-700">Nom :</span> <span id="modalUserName" class="text-gray-900"></span></p>
                            <p><span class="font-medium text-gray-700">Email :</span> <span id="modalUserEmail" class="text-gray-900"></span></p>
                        </div>
                    </div>

                    <div class="bg-gradient-to-r from-green-50 to-emerald-50 rounded-2xl p-6 border border-green-200">
                        <h4 class="font-bold text-lg text-gray-900 mb-4 flex items-center">
                            <i class="fas fa-door-open text-green-600 mr-3"></i>
                            Informations de l'unité
                        </h4>
                        <div class="space-y-2">
                            <p><span class="font-medium text-gray-700">Unité N° :</span> <span id="modalUniteNumero" class="text-gray-900"></span></p>
                            <p><span class="font-medium text-gray-700">Pièces :</span> <span id="modalUnitePieces" class="text-gray-900"></span></p>
                            <p><span class="font-medium text-gray-700">Superficie :</span> <span id="modalUniteSuperficie" class="text-gray-900"></span> m²</p>
                            <p><span class="font-medium text-gray-700">Loyer :</span> <span id="modalUniteLoyer" class="text-gray-900"></span> FCFA</p>
                        </div>
                    </div>
                </div>

                <div class="space-y-6">
                    <div class="bg-gradient-to-r from-orange-50 to-yellow-50 rounded-2xl p-6 border border-orange-200">
                        <h4 class="font-bold text-lg text-gray-900 mb-4 flex items-center">
                            <i class="fas fa-building text-orange-600 mr-3"></i>
                            Immeuble
                        </h4>
                        <div class="space-y-2">
                            <p><span class="font-medium text-gray-700">Nom :</span> <span id="modalImmeubleNom" class="text-gray-900"></span></p>
                            <p><span class="font-medium text-gray-700">Adresse :</span> <span id="modalImmeubleAdresse" class="text-gray-900"></span></p>
                        </div>
                    </div>

                    <div class="bg-gradient-to-r from-gray-50 to-slate-50 rounded-2xl p-6 border border-gray-200">
                        <h4 class="font-bold text-lg text-gray-900 mb-4 flex items-center">
                            <i class="fas fa-comment text-gray-600 mr-3"></i>
                            Statut et motif
                        </h4>
                        <div class="space-y-3">
                            <p><span class="font-medium text-gray-700">Statut :</span> <span id="modalStatus" class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium"></span></p>
                            <p><span class="font-medium text-gray-700">Motif :</span> <span id="modalMotif" class="text-gray-900"></span></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="bg-gray-50 px-8 py-6 border-t border-gray-200">
            <div class="flex justify-end">
                <button onclick="closeDetailModal()"
                        class="px-6 py-3 bg-gray-200 hover:bg-gray-300 text-gray-800 font-semibold rounded-xl transition-colors duration-200">
                    <i class="fas fa-times mr-2"></i>Fermer
                </button>
            </div>
        </div>
    </div>
</div>

<script>
    // Variables globales pour les modals
    let rejectModal, detailModal;

    // Initialisation au chargement de la page
    document.addEventListener('DOMContentLoaded', function() {
        rejectModal = document.getElementById('rejectModal');
        detailModal = document.getElementById('detailModal');
    });

    // Fonctions pour le modal de rejet
    function openRejectModal(demandeId) {
        document.getElementById('rejectDemandeId').value = demandeId;
        showModal(rejectModal);
    }

    function closeRejectModal() {
        hideModal(rejectModal);
        // Réinitialiser le formulaire
        rejectModal.querySelector('form').reset();
    }

    // Fonctions pour le modal de détails
    function openDetailModal(demandeId, status, motif, userName, userEmail, uniteNumero, unitePieces, uniteSuperficie, uniteLoyer, immeubleNom, immeubleAdresse) {
        // Remplir les données
        document.getElementById('modalUserName').textContent = userName || 'Non disponible';
        document.getElementById('modalUserEmail').textContent = userEmail || 'Non disponible';
        document.getElementById('modalUniteNumero').textContent = uniteNumero || 'Non disponible';
        document.getElementById('modalUnitePieces').textContent = unitePieces || 'Non disponible';
        document.getElementById('modalUniteSuperficie').textContent = uniteSuperficie || 'Non disponible';
        document.getElementById('modalUniteLoyer').textContent = uniteLoyer ? new Intl.NumberFormat('fr-FR').format(uniteLoyer) : 'Non disponible';
        document.getElementById('modalImmeubleNom').textContent = immeubleNom || 'Non disponible';
        document.getElementById('modalImmeubleAdresse').textContent = immeubleAdresse || 'Non disponible';
        document.getElementById('modalMotif').textContent = motif || 'Aucun motif renseigné';

        // Statut avec couleur
        const statusElement = document.getElementById('modalStatus');
        statusElement.textContent = getStatusText(status);
        statusElement.className = 'inline-flex items-center px-3 py-1 rounded-full text-xs font-medium ' + getStatusClass(status);

        showModal(detailModal);
    }

    function closeDetailModal() {
        hideModal(detailModal);
    }

    // Fonctions utilitaires pour les modals
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

    // Fonctions utilitaires pour le statut
    function getStatusText(status) {
        switch(status) {
            case 'EN_ATTENTE': return 'En attente';
            case 'ACCEPTEE': return 'Acceptée';
            case 'REJETE': return 'Rejetée';
            default: return status;
        }
    }

    function getStatusClass(status) {
        switch(status) {
            case 'EN_ATTENTE': return 'bg-yellow-100 text-yellow-800';
            case 'ACCEPTEE': return 'bg-green-100 text-green-800';
            case 'REJETE': return 'bg-red-100 text-red-800';
            default: return 'bg-gray-100 text-gray-800';
        }
    }

    // Fermer les modals en cliquant à l'extérieur
    document.addEventListener('click', function(e) {
        if (e.target === rejectModal) {
            closeRejectModal();
        }
        if (e.target === detailModal) {
            closeDetailModal();
        }
    });

    // Fermer avec la touche Escape
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            if (!rejectModal.classList.contains('hidden')) {
                closeRejectModal();
            }
            if (!detailModal.classList.contains('hidden')) {
                closeDetailModal();
            }
        }
    });

    // Animation d'apparition au chargement
    document.addEventListener('DOMContentLoaded', function() {
        // Animer les éléments avec un délai
        const animatedElements = document.querySelectorAll('.animate-fade-in, .animate-slide-up');
        animatedElements.forEach((element, index) => {
            setTimeout(() => {
                element.style.opacity = '1';
                element.style.transform = 'translateY(0)';
            }, index * 100);
        });
    });
</script>

</body>
</html>