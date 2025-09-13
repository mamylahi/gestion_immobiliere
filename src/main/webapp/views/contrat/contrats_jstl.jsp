<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Contrats</title>
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
                            <i class="fas fa-file-contract text-4xl"></i>
                        </div>

                        <h1 class="text-5xl font-bold mb-4 tracking-tight">
                            <c:choose>
                                <c:when test="${currentUser.role == 'ADMIN'}">
                                    Tous les Contrats de Location
                                </c:when>
                                <c:when test="${currentUser.role == 'PROPRIETAIRE'}">
                                    Contrats de Mes Propriétés
                                </c:when>
                                <c:when test="${currentUser.role == 'LOCATAIRE'}">
                                    Mes Contrats de Location
                                </c:when>
                                <c:otherwise>
                                    Gestion des Contrats
                                </c:otherwise>
                            </c:choose>
                        </h1>

                        <p class="text-xl text-white text-opacity-90 max-w-2xl mx-auto leading-relaxed">
                            <c:choose>
                                <c:when test="${currentUser.role == 'ADMIN'}">
                                    Gérez et supervisez tous les contrats de location du système
                                </c:when>
                                <c:when test="${currentUser.role == 'PROPRIETAIRE'}">
                                    Suivez et gérez les contrats de vos propriétés en toute simplicité
                                </c:when>
                                <c:when test="${currentUser.role == 'LOCATAIRE'}">
                                    Consultez vos contrats actifs et leur statut en temps réel
                                </c:when>
                                <c:otherwise>
                                    Gestion complète et sécurisée de tous vos contrats de location
                                </c:otherwise>
                            </c:choose>
                        </p>

                        <div class="flex justify-center mt-8 space-x-4">
                            <div class="flex items-center bg-white text-black bg-opacity-20 backdrop-blur-sm rounded-full px-4 py-2">
                                <i class="fas fa-shield-alt text-green-300 mr-2"></i>
                                <span class="text-sm">Sécurisé</span>
                            </div>
                            <div class="flex items-center bg-white text-black bg-opacity-20 backdrop-blur-sm rounded-full px-4 py-2">
                                <i class="fas fa-file-signature text-blue-300 mr-2"></i>
                                <span class="text-sm">Légal</span>
                            </div>
                            <div class="flex items-center bg-white text-black bg-opacity-20 backdrop-blur-sm rounded-full px-4 py-2">
                                <i class="fas fa-clock text-yellow-300 mr-2"></i>
                                <span class="text-sm">Suivi temps réel</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Statistiques rapides -->
            <div class="mb-8 grid grid-cols-1 md:grid-cols-4 gap-6">
                <div class="bg-white rounded-2xl p-6 shadow-lg border border-gray-100">
                    <div class="flex items-center">
                        <div class="w-12 h-12 bg-green-100 rounded-xl flex items-center justify-center">
                            <i class="fas fa-check text-green-600"></i>
                        </div>
                        <div class="ml-4">
                            <p class="text-2xl font-bold text-gray-900">
                                <c:set var="actifs" value="0" />
                                <c:forEach var="c" items="${contrats}">
                                    <c:if test="${c.statut == 'ACTIF'}">
                                        <c:set var="actifs" value="${actifs + 1}" />
                                    </c:if>
                                </c:forEach>
                                ${actifs}
                            </p>
                            <p class="text-gray-600">Contrats Actifs</p>
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
                                <c:set var="expires" value="0" />
                                <c:forEach var="c" items="${contrats}">
                                    <c:if test="${c.statut == 'EXPIRE'}">
                                        <c:set var="expires" value="${expires + 1}" />
                                    </c:if>
                                </c:forEach>
                                ${expires}
                            </p>
                            <p class="text-gray-600">Expirés</p>
                        </div>
                    </div>
                </div>

                <div class="bg-white rounded-2xl p-6 shadow-lg border border-gray-100">
                    <div class="flex items-center">
                        <div class="w-12 h-12 bg-red-100 rounded-xl flex items-center justify-center">
                            <i class="fas fa-times text-red-600"></i>
                        </div>
                        <div class="ml-4">
                            <p class="text-2xl font-bold text-gray-900">
                                <c:set var="resilies" value="0" />
                                <c:forEach var="c" items="${contrats}">
                                    <c:if test="${c.statut == 'RESILIE'}">
                                        <c:set var="resilies" value="${resilies + 1}" />
                                    </c:if>
                                </c:forEach>
                                ${resilies}
                            </p>
                            <p class="text-gray-600">Résiliés</p>
                        </div>
                    </div>
                </div>

                <div class="bg-white rounded-2xl p-6 shadow-lg border border-gray-100">
                    <div class="flex items-center">
                        <div class="w-12 h-12 bg-blue-100 rounded-xl flex items-center justify-center">
                            <i class="fas fa-file-contract text-blue-600"></i>
                        </div>
                        <div class="ml-4">
                            <p class="text-2xl font-bold text-gray-900">${not empty contrats ? contrats.size() : 0}</p>
                            <p class="text-gray-600">Total</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Action rapide pour propriétaires et admin -->
            <c:if test="${(currentUser.role == 'ADMIN' || currentUser.role == 'PROPRIETAIRE') && empty contrats}">
                <div class="mb-8">
                    <div class="bg-gradient-to-r from-green-50 to-emerald-50 rounded-2xl p-8 border border-green-200">
                        <div class="text-center">
                            <div class="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-4">
                                <i class="fas fa-plus text-green-600 text-2xl"></i>
                            </div>
                            <h3 class="text-xl font-semibold text-gray-900 mb-2">Prêt à créer votre premier contrat ?</h3>
                            <p class="text-gray-600 mb-6">Commencez par établir un contrat de location sécurisé et conforme</p>
                            <a href="contrats?action=add" class="inline-flex items-center px-6 py-3 bg-gradient-to-r from-green-600 to-green-700 hover:from-green-700 hover:to-green-800 text-white font-medium rounded-xl transition-all duration-200 transform hover:scale-105 shadow-lg hover:shadow-xl">
                                <i class="fas fa-plus mr-2"></i>Créer un contrat
                            </a>
                        </div>
                    </div>
                </div>
            </c:if>

            <!-- Bouton Nouveau Contrat -->
            <c:if test="${currentUser.role == 'ADMIN' || currentUser.role == 'PROPRIETAIRE'}">
                <div class="mb-8 flex justify-end">
                    <a href="contrats?action=add" class="inline-flex items-center px-6 py-3 bg-gradient-to-r from-green-600 to-green-700 hover:from-green-700 hover:to-green-800 text-white font-medium rounded-xl transition-all duration-200 transform hover:scale-105 shadow-lg hover:shadow-xl">
                        <i class="fas fa-plus mr-2"></i>Nouveau Contrat
                    </a>
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

            <!-- Tableau des contrats -->
            <div class="bg-white rounded-2xl shadow-lg border border-gray-100 overflow-hidden">
                <c:choose>
                    <c:when test="${not empty contrats}">
                        <div class="overflow-x-auto">
                            <table class="w-full">
                                <thead class="bg-gradient-to-r from-gray-800 to-gray-900 text-white">
                                <tr>
                                    <th class="px-6 py-4 text-left text-sm font-semibold">
                                        <i class="fas fa-hashtag mr-2"></i>ID
                                    </th>
                                    <c:if test="${currentUser.role != 'LOCATAIRE'}">
                                        <th class="px-6 py-4 text-left text-sm font-semibold">
                                            <i class="fas fa-user mr-2"></i>Locataire
                                        </th>
                                    </c:if>
                                    <th class="px-6 py-4 text-left text-sm font-semibold">
                                        <i class="fas fa-door-open mr-2"></i>Unité
                                    </th>
                                    <th class="px-6 py-4 text-left text-sm font-semibold">
                                        <i class="fas fa-building mr-2"></i>Immeuble
                                    </th>
                                    <c:if test="${currentUser.role == 'LOCATAIRE'}">
                                        <th class="px-6 py-4 text-left text-sm font-semibold">
                                            <i class="fas fa-user-tie mr-2"></i>Propriétaire
                                        </th>
                                    </c:if>
                                    <th class="px-6 py-4 text-left text-sm font-semibold">
                                        <i class="fas fa-calendar mr-2"></i>Période
                                    </th>
                                    <th class="px-6 py-4 text-left text-sm font-semibold">
                                        <i class="fas fa-money-bill mr-2"></i>Loyer
                                    </th>
                                    <th class="px-6 py-4 text-left text-sm font-semibold">
                                        <i class="fas fa-shield-alt mr-2"></i>Caution
                                    </th>
                                    <th class="px-6 py-4 text-left text-sm font-semibold">
                                        <i class="fas fa-info-circle mr-2"></i>Statut
                                    </th>
                                    <th class="px-6 py-4 text-left text-sm font-semibold">
                                        <i class="fas fa-cog mr-2"></i>Actions
                                    </th>
                                </tr>
                                </thead>
                                <tbody class="divide-y divide-gray-200">
                                <c:forEach var="contrat" items="${contrats}" varStatus="status">
                                    <tr class="hover:bg-gray-50 transition-colors duration-200">
                                        <td class="px-6 py-4">
                                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800">
                                                    ${contrat.id}
                                            </span>
                                        </td>

                                        <!-- Locataire (pas pour les locataires) -->
                                        <c:if test="${currentUser.role != 'LOCATAIRE'}">
                                            <td class="px-6 py-4">
                                                <c:choose>
                                                    <c:when test="${not empty contrat.locataire && not empty contrat.locataire.user}">
                                                        <div>
                                                            <div class="font-semibold text-gray-900">
                                                                    ${contrat.locataire.user.prenom} ${contrat.locataire.user.nom}
                                                            </div>
                                                            <div class="text-sm text-gray-500">
                                                                    ${contrat.locataire.user.email}
                                                            </div>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-gray-400 italic">Non assigné</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </c:if>

                                        <!-- Unité -->
                                        <td class="px-6 py-4">
                                            <c:choose>
                                                <c:when test="${not empty contrat.unite}">
                                                    <div>
                                                        <div class="font-semibold text-gray-900">
                                                            Unité N° ${contrat.unite.numeroUnite}
                                                        </div>
                                                        <div class="text-sm text-gray-500">
                                                                ${contrat.unite.nombrePiece} pièces - ${contrat.unite.superficie} m²
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
                                                <c:when test="${not empty contrat.unite && not empty contrat.unite.immeuble}">
                                                    <div>
                                                        <div class="font-semibold text-gray-900">
                                                                ${contrat.unite.immeuble.nom}
                                                        </div>
                                                        <div class="text-sm text-gray-500">
                                                                ${contrat.unite.immeuble.adresse}
                                                        </div>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-gray-400 italic">Non disponible</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <!-- Propriétaire (pour les locataires seulement) -->
                                        <c:if test="${currentUser.role == 'LOCATAIRE'}">
                                            <td class="px-6 py-4">
                                                <c:choose>
                                                    <c:when test="${not empty contrat.unite && not empty contrat.unite.immeuble && not empty contrat.unite.immeuble.proprietaire}">
                                                        <div>
                                                            <div class="font-semibold text-gray-900">
                                                                    ${contrat.unite.immeuble.proprietaire.prenom} ${contrat.unite.immeuble.proprietaire.nom}
                                                            </div>
                                                            <div class="text-sm text-gray-500">
                                                                    ${contrat.unite.immeuble.proprietaire.email}
                                                            </div>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-gray-400 italic">Non renseigné</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </c:if>

                                        <!-- Période -->
                                        <td class="px-6 py-4">
                                            <c:choose>
                                                <c:when test="${not empty contrat.dateDebut && not empty contrat.dateFin}">
                                                    <div>
                                                        <div class="text-sm">
                                                            <span class="font-medium text-gray-700">Du :</span> ${contrat.dateDebut}
                                                        </div>
                                                        <div class="text-sm">
                                                            <span class="font-medium text-gray-700">Au :</span> ${contrat.dateFin}
                                                        </div>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-gray-400 italic">Dates non définies</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <!-- Loyer -->
                                        <td class="px-6 py-4">
                                            <c:choose>
                                                <c:when test="${not empty contrat.unite && not empty contrat.unite.loyerMensuel}">
                                                    <div class="font-semibold text-gray-900">
                                                        <fmt:formatNumber value="${contrat.unite.loyerMensuel}" type="number" groupingUsed="true" /> FCFA
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-gray-400 italic">Non défini</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <!-- Caution -->
                                        <td class="px-6 py-4">
                                            <c:choose>
                                                <c:when test="${contrat.caution > 0}">
                                                    <div class="font-semibold text-gray-900">
                                                        <fmt:formatNumber value="${contrat.caution}" type="number" groupingUsed="true" /> FCFA
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-gray-400">-</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <!-- Statut -->
                                        <td class="px-6 py-4">
                                            <c:choose>
                                                <c:when test="${contrat.statut == 'ACTIF'}">
                                                    <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                                        <i class="fas fa-check mr-1"></i>Actif
                                                    </span>
                                                </c:when>
                                                <c:when test="${contrat.statut == 'EXPIRE'}">
                                                    <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800">
                                                        <i class="fas fa-clock mr-1"></i>Expiré
                                                    </span>
                                                </c:when>
                                                <c:when test="${contrat.statut == 'RESILIE'}">
                                                    <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-red-100 text-red-800">
                                                        <i class="fas fa-times mr-1"></i>Résilié
                                                    </span>
                                                </c:when>
                                                <c:when test="${contrat.statut == 'SUSPENDU'}">
                                                    <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-gray-100 text-gray-800">
                                                        <i class="fas fa-pause mr-1"></i>Suspendu
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-gray-100 text-gray-800">
                                                            ${contrat.statut}
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <!-- Actions -->
                                        <td class="px-6 py-4">
                                            <div class="flex items-center space-x-2">
                                                <!-- Voir détails (pour tous) -->
                                                <button type="button"
                                                        class="inline-flex items-center justify-center w-8 h-8 bg-blue-100 hover:bg-blue-200 text-blue-600 rounded-lg transition-colors duration-200"
                                                        onclick="openDetailModal(
                                                                '${contrat.id}',
                                                                '${contrat.statut}',
                                                                '${contrat.locataire.user.prenom} ${contrat.locataire.user.nom}',
                                                                '${contrat.locataire.user.email}',
                                                                '${contrat.unite.numeroUnite}',
                                                                '${contrat.unite.nombrePiece}',
                                                                '${contrat.unite.superficie}',
                                                                '${contrat.unite.loyerMensuel}',
                                                                '${contrat.unite.immeuble.nom}',
                                                                '${contrat.unite.immeuble.adresse}',
                                                                '${contrat.dateDebut}',
                                                                '${contrat.dateFin}',
                                                                '${contrat.caution}'
                                                                )"
                                                        title="Voir détails">
                                                    <i class="fas fa-eye text-sm"></i>
                                                </button>

                                                <!-- Actions admin/propriétaire -->
                                                <c:if test="${currentUser.role == 'ADMIN' ||
                                                             (currentUser.role == 'PROPRIETAIRE' &&
                                                              not empty contrat.unite &&
                                                              not empty contrat.unite.immeuble &&
                                                              not empty contrat.unite.immeuble.proprietaire &&
                                                              contrat.unite.immeuble.proprietaire.id == currentUser.id)}">

                                                    <a href="contrats?action=edit&id=${contrat.id}"
                                                       class="inline-flex items-center justify-center w-8 h-8 bg-yellow-100 hover:bg-yellow-200 text-yellow-600 rounded-lg transition-colors duration-200"
                                                       title="Modifier">
                                                        <i class="fas fa-edit text-sm"></i>
                                                    </a>

                                                    <!-- Supprimer (Admin uniquement) -->
                                                    <c:if test="${currentUser.role == 'ADMIN'}">
                                                        <a href="contrats?action=delete&id=${contrat.id}"
                                                           class="inline-flex items-center justify-center w-8 h-8 bg-red-100 hover:bg-red-200 text-red-600 rounded-lg transition-colors duration-200"
                                                           title="Supprimer"
                                                           onclick="return confirm('Supprimer ce contrat définitivement ?')">
                                                            <i class="fas fa-trash text-sm"></i>
                                                        </a>
                                                    </c:if>
                                                </c:if>
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
                                        ${not empty contrats ? contrats.size() : 0} contrat(s) affiché(s)
                                </div>
                            </div>
                        </div>

                    </c:when>
                    <c:otherwise>
                        <!-- Message si aucun contrat -->
                        <div class="text-center py-16">
                            <div class="w-24 h-24 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-6">
                                <i class="fas fa-file-contract text-4xl text-gray-400"></i>
                            </div>
                            <h3 class="text-2xl font-semibold text-gray-900 mb-4">Aucun contrat trouvé</h3>
                            <p class="text-gray-600 mb-6 max-w-md mx-auto">
                                <c:choose>
                                    <c:when test="${currentUser.role == 'LOCATAIRE'}">
                                        Vous n'avez pas encore de contrat de location.
                                    </c:when>
                                    <c:when test="${currentUser.role == 'PROPRIETAIRE'}">
                                        Aucun contrat pour vos propriétés.
                                    </c:when>
                                    <c:otherwise>
                                        Aucun contrat enregistré dans le système.
                                    </c:otherwise>
                                </c:choose>
                            </p>

                            <c:if test="${currentUser.role == 'ADMIN' || currentUser.role == 'PROPRIETAIRE'}">
                                <a href="contrats?action=add" class="inline-flex items-center px-6 py-3 bg-green-600 hover:bg-green-700 text-white font-medium rounded-xl transition-colors duration-200">
                                    <i class="fas fa-plus mr-2"></i>Créer le premier contrat
                                </a>
                            </c:if>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<!-- Modal de détails -->
<div id="detailModal" class="fixed inset-0 backdrop-blur-md z-50 hidden flex items-center justify-center p-4">
    <div class="bg-white bg-opacity-95 backdrop-blur-sm rounded-3xl max-w-5xl w-full max-h-[90vh] shadow-2xl border border-gray-100 transform scale-95 opacity-0 transition-all duration-300 flex flex-col">
        <div class="bg-gradient-to-r from-blue-600 to-blue-700 text-white p-6 flex-shrink-0">
            <div class="flex items-center justify-between">
                <h3 class="text-2xl font-bold flex items-center">
                    <i class="fas fa-file-contract mr-3"></i>
                    Détails du contrat
                </h3>
                <button onclick="closeDetailModal()" class="w-8 h-8 flex items-center justify-center text-white hover:bg-white hover:bg-opacity-20 rounded-lg transition-colors duration-200">
                    <i class="fas fa-times"></i>
                </button>
            </div>
        </div>

        <div class="p-8 overflow-y-auto flex-1">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                <div class="space-y-6">
                    <div class="bg-gradient-to-r from-purple-50 to-blue-50 rounded-2xl p-6 border border-purple-200">
                        <h4 class="font-bold text-lg text-gray-900 mb-4 flex items-center">
                            <i class="fas fa-user text-purple-600 mr-3"></i>
                            Informations du locataire
                        </h4>
                        <div class="space-y-2">
                            <p><span class="font-medium text-gray-700">Nom :</span> <span id="modalLocataireName" class="text-gray-900"></span></p>
                            <p><span class="font-medium text-gray-700">Email :</span> <span id="modalLocataireEmail" class="text-gray-900"></span></p>
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
                            <p><span class="font-medium text-gray-700">Loyer mensuel :</span> <span id="modalUniteLoyer" class="text-gray-900"></span> FCFA</p>
                        </div>
                    </div>

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
                </div>

                <div class="space-y-6">
                    <div class="bg-gradient-to-r from-indigo-50 to-purple-50 rounded-2xl p-6 border border-indigo-200">
                        <h4 class="font-bold text-lg text-gray-900 mb-4 flex items-center">
                            <i class="fas fa-calendar text-indigo-600 mr-3"></i>
                            Période du contrat
                        </h4>
                        <div class="space-y-2">
                            <p><span class="font-medium text-gray-700">Date de début :</span> <span id="modalDateDebut" class="text-gray-900"></span></p>
                            <p><span class="font-medium text-gray-700">Date de fin :</span> <span id="modalDateFin" class="text-gray-900"></span></p>
                        </div>
                    </div>

                    <div class="bg-gradient-to-r from-emerald-50 to-teal-50 rounded-2xl p-6 border border-emerald-200">
                        <h4 class="font-bold text-lg text-gray-900 mb-4 flex items-center">
                            <i class="fas fa-money-bill text-emerald-600 mr-3"></i>
                            Informations financières
                        </h4>
                        <div class="space-y-2">
                            <p><span class="font-medium text-gray-700">Loyer mensuel :</span> <span id="modalLoyerMensuel" class="text-gray-900"></span> FCFA</p>
                            <p><span class="font-medium text-gray-700">Caution :</span> <span id="modalCaution" class="text-gray-900"></span> FCFA</p>
                        </div>
                    </div>

                    <div class="bg-gradient-to-r from-gray-50 to-slate-50 rounded-2xl p-6 border border-gray-200">
                        <h4 class="font-bold text-lg text-gray-900 mb-4 flex items-center">
                            <i class="fas fa-info-circle text-gray-600 mr-3"></i>
                            Statut du contrat
                        </h4>
                        <div class="space-y-3">
                            <p><span class="font-medium text-gray-700">Identifiant :</span> <span id="modalContratId" class="text-gray-900"></span></p>
                            <p><span class="font-medium text-gray-700">Statut :</span> <span id="modalStatus" class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium"></span></p>
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
    let detailModal;

    // Initialisation au chargement de la page
    document.addEventListener('DOMContentLoaded', function() {
        detailModal = document.getElementById('detailModal');

        // Auto-masquage des alertes après 5 secondes
        const alerts = document.querySelectorAll('.bg-green-50, .bg-red-50');
        alerts.forEach(function(alert) {
            setTimeout(function() {
                if (alert.parentNode) {
                    alert.style.opacity = '0';
                    alert.style.transform = 'translateY(-10px)';
                    setTimeout(() => {
                        if (alert.parentNode) {
                            alert.remove();
                        }
                    }, 300);
                }
            }, 5000);
        });

        // Animer les éléments avec un délai
        const animatedElements = document.querySelectorAll('.animate-fade-in, .animate-slide-up');
        animatedElements.forEach((element, index) => {
            setTimeout(() => {
                element.style.opacity = '1';
                element.style.transform = 'translateY(0)';
            }, index * 100);
        });
    });

    // Fonctions pour le modal de détails
    function openDetailModal(contratId, statut, locataireName, locataireEmail, uniteNumero, unitePieces, uniteSuperficie, uniteLoyer, immeubleNom, immeubleAdresse, dateDebut, dateFin, caution) {
        // Remplir les données
        document.getElementById('modalContratId').textContent = contratId || 'Non disponible';
        document.getElementById('modalLocataireName').textContent = locataireName || 'Non disponible';
        document.getElementById('modalLocataireEmail').textContent = locataireEmail || 'Non disponible';
        document.getElementById('modalUniteNumero').textContent = uniteNumero || 'Non disponible';
        document.getElementById('modalUnitePieces').textContent = unitePieces || 'Non disponible';
        document.getElementById('modalUniteSuperficie').textContent = uniteSuperficie || 'Non disponible';
        document.getElementById('modalUniteLoyer').textContent = uniteLoyer ? new Intl.NumberFormat('fr-FR').format(uniteLoyer) : 'Non disponible';
        document.getElementById('modalImmeubleNom').textContent = immeubleNom || 'Non disponible';
        document.getElementById('modalImmeubleAdresse').textContent = immeubleAdresse || 'Non disponible';
        document.getElementById('modalDateDebut').textContent = dateDebut || 'Non disponible';
        document.getElementById('modalDateFin').textContent = dateFin || 'Non disponible';
        document.getElementById('modalLoyerMensuel').textContent = uniteLoyer ? new Intl.NumberFormat('fr-FR').format(uniteLoyer) : 'Non disponible';
        document.getElementById('modalCaution').textContent = caution && caution > 0 ? new Intl.NumberFormat('fr-FR').format(caution) : 'Aucune';

        // Statut avec couleur
        const statusElement = document.getElementById('modalStatus');
        statusElement.textContent = getStatusText(statut);
        statusElement.className = 'inline-flex items-center px-3 py-1 rounded-full text-xs font-medium ' + getStatusClass(statut);

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
    function getStatusText(statut) {
        switch(statut) {
            case 'ACTIF': return 'Actif';
            case 'EXPIRE': return 'Expiré';
            case 'RESILIE': return 'Résilié';
            case 'SUSPENDU': return 'Suspendu';
            default: return statut;
        }
    }

    function getStatusClass(statut) {
        switch(statut) {
            case 'ACTIF': return 'bg-green-100 text-green-800';
            case 'EXPIRE': return 'bg-yellow-100 text-yellow-800';
            case 'RESILIE': return 'bg-red-100 text-red-800';
            case 'SUSPENDU': return 'bg-gray-100 text-gray-800';
            default: return 'bg-gray-100 text-gray-800';
        }
    }

    // Fermer les modals en cliquant à l'extérieur
    document.addEventListener('click', function(e) {
        if (e.target === detailModal) {
            closeDetailModal();
        }
    });

    // Fermer avec la touche Escape
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            if (!detailModal.classList.contains('hidden')) {
                closeDetailModal();
            }
        }
    });
</script>

</body>
</html>