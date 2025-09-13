<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tableau de Bord Administrateur</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body class="bg-gray-50">

<%@ include file="../navbar/navbar.jsp" %>

<!-- Contenu principal avec marge pour le sidebar -->
<div class="ml-64 min-h-screen">
    <div class="p-8">
        <div class="max-w-7xl mx-auto">

            <!-- En-tête du tableau de bord -->
            <div class="mb-8 animate-fade-in">
                <div class="bg-gradient-to-br from-blue-600 via-purple-600 to-blue-800 rounded-3xl text-white p-8 shadow-xl relative overflow-hidden">
                    <!-- Éléments décoratifs -->
                    <div class="absolute top-4 right-4 w-16 h-16 border-2 border-white border-opacity-30 rounded-full animate-pulse"></div>
                    <div class="absolute bottom-4 left-4 w-12 h-12 border-2 border-white border-opacity-20 rounded-full animate-bounce"></div>

                    <div class="relative z-10">
                        <div class="flex items-center justify-between">
                            <div>
                                <h1 class="text-4xl font-bold mb-2">Tableau de Bord Administrateur</h1>
                                <p class="text-white text-opacity-90 text-lg">Vue d'ensemble de la plateforme de gestion immobilière</p>
                                <div class="mt-4 flex items-center">
                                    <i class="fas fa-calendar-alt mr-2"></i>
                                    <span class="text-white text-opacity-80" id="currentDate"></span>
                                </div>
                            </div>
                            <div class="text-right">
                                <div class="w-16 h-16 bg-white/20 backdrop-blur-sm rounded-2xl flex items-center justify-center">
                                    <i class="fas fa-chart-line text-3xl"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Messages d'erreur -->
            <c:if test="${not empty errorMessage}">
                <div class="mb-6 bg-red-50 border border-red-200 rounded-xl p-4 flex items-center">
                    <div class="w-10 h-10 bg-red-100 rounded-full flex items-center justify-center mr-4">
                        <i class="fas fa-exclamation-triangle text-red-600"></i>
                    </div>
                    <div class="flex-1">
                        <p class="text-red-800 font-medium">${errorMessage}</p>
                    </div>
                </div>
            </c:if>

            <!-- Statistiques principales -->
            <div class="mb-8 grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                <!-- Total Utilisateurs -->
                <div class="bg-white rounded-2xl p-6 shadow-lg border border-gray-100 hover:shadow-xl transition-shadow duration-300">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-gray-600 text-sm font-medium">Total Utilisateurs</p>
                            <p class="text-3xl font-bold text-gray-900">${totalUsers}</p>
                            <div class="flex items-center mt-2 text-sm">
                                <span class="text-green-600 font-medium">+${adminsCount + proprietairesCount + locatairesCount}</span>
                                <span class="text-gray-500 ml-1">inscrits</span>
                            </div>
                        </div>
                        <div class="w-16 h-16 bg-blue-100 rounded-xl flex items-center justify-center">
                            <i class="fas fa-users text-blue-600 text-xl"></i>
                        </div>
                    </div>
                </div>

                <!-- Total Immeubles -->
                <div class="bg-white rounded-2xl p-6 shadow-lg border border-gray-100 hover:shadow-xl transition-shadow duration-300">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-gray-600 text-sm font-medium">Total Immeubles</p>
                            <p class="text-3xl font-bold text-gray-900">${totalImmeubles}</p>
                            <div class="flex items-center mt-2 text-sm">
                                <span class="text-blue-600 font-medium">${totalUnites}</span>
                                <span class="text-gray-500 ml-1">unités</span>
                            </div>
                        </div>
                        <div class="w-16 h-16 bg-green-100 rounded-xl flex items-center justify-center">
                            <i class="fas fa-building text-green-600 text-xl"></i>
                        </div>
                    </div>
                </div>

                <!-- Taux d'Occupation -->
                <div class="bg-white rounded-2xl p-6 shadow-lg border border-gray-100 hover:shadow-xl transition-shadow duration-300">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-gray-600 text-sm font-medium">Taux d'Occupation</p>
                            <p class="text-3xl font-bold text-gray-900">
                                <fmt:formatNumber value="${tauxOccupation}" pattern="#0.0" />%
                            </p>
                            <div class="flex items-center mt-2 text-sm">
                                <span class="text-purple-600 font-medium">${unitesOccupees}</span>
                                <span class="text-gray-500 ml-1">sur ${totalUnites}</span>
                            </div>
                        </div>
                        <div class="w-16 h-16 bg-purple-100 rounded-xl flex items-center justify-center">
                            <i class="fas fa-home text-purple-600 text-xl"></i>
                        </div>
                    </div>
                </div>

                <!-- Revenus Totaux -->
                <div class="bg-white rounded-2xl p-6 shadow-lg border border-gray-100 hover:shadow-xl transition-shadow duration-300">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-gray-600 text-sm font-medium">Revenus Réels</p>
                            <p class="text-3xl font-bold text-gray-900">
                                <fmt:formatNumber value="${totalRevenusReel}" pattern="#,##0" />
                            </p>
                            <div class="flex items-center mt-2 text-sm">
                                <span class="text-orange-600 font-medium">FCFA</span>
                                <span class="text-gray-500 ml-1">collectés</span>
                            </div>
                        </div>
                        <div class="w-16 h-16 bg-orange-100 rounded-xl flex items-center justify-center">
                            <i class="fas fa-coins text-orange-600 text-xl"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Répartition des utilisateurs et alertes -->
            <div class="mb-8 grid grid-cols-1 lg:grid-cols-3 gap-6">
                <!-- Répartition des Utilisateurs -->
                <div class="bg-white rounded-2xl p-6 shadow-lg border border-gray-100">
                    <h3 class="text-lg font-semibold text-gray-900 mb-4 flex items-center">
                        <i class="fas fa-user-friends text-blue-600 mr-2"></i>
                        Répartition des Utilisateurs
                    </h3>
                    <div class="space-y-3">
                        <div class="flex items-center justify-between">
                            <div class="flex items-center">
                                <div class="w-3 h-3 bg-red-500 rounded-full mr-3"></div>
                                <span class="text-gray-700">Administrateurs</span>
                            </div>
                            <span class="font-semibold text-gray-900">${adminsCount}</span>
                        </div>
                        <div class="flex items-center justify-between">
                            <div class="flex items-center">
                                <div class="w-3 h-3 bg-blue-500 rounded-full mr-3"></div>
                                <span class="text-gray-700">Propriétaires</span>
                            </div>
                            <span class="font-semibold text-gray-900">${proprietairesCount}</span>
                        </div>
                        <div class="flex items-center justify-between">
                            <div class="flex items-center">
                                <div class="w-3 h-3 bg-green-500 rounded-full mr-3"></div>
                                <span class="text-gray-700">Locataires</span>
                            </div>
                            <span class="font-semibold text-gray-900">${locatairesCount}</span>
                        </div>
                    </div>
                    <div class="mt-4">
                        <canvas id="usersChart" width="300" height="200"></canvas>
                    </div>
                </div>

                <!-- Statut des Contrats -->
                <div class="bg-white rounded-2xl p-6 shadow-lg border border-gray-100">
                    <h3 class="text-lg font-semibold text-gray-900 mb-4 flex items-center">
                        <i class="fas fa-file-contract text-green-600 mr-2"></i>
                        Statut des Contrats
                    </h3>
                    <div class="space-y-3">
                        <div class="flex items-center justify-between">
                            <div class="flex items-center">
                                <div class="w-3 h-3 bg-green-500 rounded-full mr-3"></div>
                                <span class="text-gray-700">Actifs</span>
                            </div>
                            <span class="font-semibold text-gray-900">${contratsActifs}</span>
                        </div>
                        <div class="flex items-center justify-between">
                            <div class="flex items-center">
                                <div class="w-3 h-3 bg-yellow-500 rounded-full mr-3"></div>
                                <span class="text-gray-700">Terminés</span>
                            </div>
                            <span class="font-semibold text-gray-900">${contratsTermines}</span>
                        </div>
                        <div class="flex items-center justify-between">
                            <div class="flex items-center">
                                <div class="w-3 h-3 bg-red-500 rounded-full mr-3"></div>
                                <span class="text-gray-700">Résiliés</span>
                            </div>
                            <span class="font-semibold text-gray-900">${contratsResilies}</span>
                        </div>
                    </div>
                    <div class="mt-4">
                        <canvas id="contratsChart" width="300" height="200"></canvas>
                    </div>
                </div>

                <!-- Alertes et Notifications -->
                <div class="bg-white rounded-2xl p-6 shadow-lg border border-gray-100">
                    <h3 class="text-lg font-semibold text-gray-900 mb-4 flex items-center">
                        <i class="fas fa-bell text-yellow-600 mr-2"></i>
                        Alertes
                    </h3>
                    <div class="space-y-3">
                        <c:if test="${paiementsEnRetard > 0}">
                            <div class="flex items-center p-3 bg-red-50 rounded-lg border border-red-200">
                                <i class="fas fa-exclamation-triangle text-red-600 mr-3"></i>
                                <div>
                                    <p class="text-sm font-medium text-red-800">Paiements en retard</p>
                                    <p class="text-xs text-red-600">${paiementsEnRetard} paiement(s) en retard</p>
                                </div>
                            </div>
                        </c:if>

                        <c:if test="${contratsExpirants > 0}">
                            <div class="flex items-center p-3 bg-orange-50 rounded-lg border border-orange-200">
                                <i class="fas fa-calendar-times text-orange-600 mr-3"></i>
                                <div>
                                    <p class="text-sm font-medium text-orange-800">Contrats expirants</p>
                                    <p class="text-xs text-orange-600">${contratsExpirants} contrat(s) expirent bientôt</p>
                                </div>
                            </div>
                        </c:if>

                        <c:if test="${demandesEnAttente > 0}">
                            <div class="flex items-center p-3 bg-blue-50 rounded-lg border border-blue-200">
                                <i class="fas fa-clock text-blue-600 mr-3"></i>
                                <div>
                                    <p class="text-sm font-medium text-blue-800">Demandes en attente</p>
                                    <p class="text-xs text-blue-600">${demandesEnAttente} demande(s) à traiter</p>
                                </div>
                            </div>
                        </c:if>

                        <c:if test="${paiementsEnRetard == 0 && contratsExpirants == 0 && demandesEnAttente == 0}">
                            <div class="flex items-center p-3 bg-green-50 rounded-lg border border-green-200">
                                <i class="fas fa-check-circle text-green-600 mr-3"></i>
                                <div>
                                    <p class="text-sm font-medium text-green-800">Tout va bien</p>
                                    <p class="text-xs text-green-600">Aucune alerte à signaler</p>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>

            <!-- Graphiques et activités récentes -->
            <div class="mb-8 grid grid-cols-1 lg:grid-cols-2 gap-6">
                <!-- Évolution des contrats -->
                <div class="bg-white rounded-2xl p-6 shadow-lg border border-gray-100">
                    <h3 class="text-lg font-semibold text-gray-900 mb-4 flex items-center">
                        <i class="fas fa-chart-line text-purple-600 mr-2"></i>
                        Évolution des Contrats (6 mois)
                    </h3>
                    <div class="h-64">
                        <canvas id="contratsEvolutionChart"></canvas>
                    </div>
                </div>

                <!-- Activités récentes -->
                <!-- Replace the "Activités Récentes" section in your JSP with this: -->

                <!-- Activités Récentes -->
                <div class="bg-white rounded-2xl p-6 shadow-lg border border-gray-100">
                    <h3 class="text-lg font-semibold text-gray-900 mb-4 flex items-center">
                        <i class="fas fa-activity text-indigo-600 mr-2"></i>
                        Activités Récentes
                    </h3>
                    <div class="space-y-3 max-h-64 overflow-y-auto">
                        <!-- Derniers contrats -->
                        <c:forEach var="contrat" items="${derniersContrats}" begin="0" end="2">
                            <div class="flex items-center p-3 bg-green-50 rounded-lg border border-green-100">
                                <i class="fas fa-file-contract text-green-600 mr-3"></i>
                                <div class="flex-1">
                                    <p class="text-sm font-medium text-gray-900">
                                        Nouveau contrat - Unité ${contrat.uniteNumero}
                                    </p>
                                    <p class="text-xs text-gray-600">
                                            ${contrat.locataireNomComplet} -
                                        <fmt:formatDate value="${contrat.dateDebut}" pattern="dd/MM/yyyy" />
                                    </p>
                                </div>
                            </div>
                        </c:forEach>

                        <!-- Dernières demandes -->
                        <c:forEach var="demande" items="${dernieresDemandes}" begin="0" end="2">
                            <div class="flex items-center p-3 bg-blue-50 rounded-lg border border-blue-100">
                                <i class="fas fa-clipboard-list text-blue-600 mr-3"></i>
                                <div class="flex-1">
                                    <p class="text-sm font-medium text-gray-900">
                                        Demande ${demande.status} - Unité ${demande.uniteNumero}
                                    </p>
                                    <p class="text-xs text-gray-600">
                                            ${demande.locataireNomComplet}
                                    </p>
                                </div>
                            </div>
                        </c:forEach>

                        <!-- Si aucune activité -->
                        <c:if test="${empty derniersContrats && empty dernieresDemandes}">
                            <div class="text-center py-4 text-gray-500">
                                <i class="fas fa-inbox text-gray-300 text-2xl mb-2"></i>
                                <p class="text-sm">Aucune activité récente</p>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>

            <!-- Statistiques détaillées et top propriétaires -->
            <div class="mb-8 grid grid-cols-1 lg:grid-cols-2 gap-6">
                <!-- Top Propriétaires -->
                <div class="bg-white rounded-2xl p-6 shadow-lg border border-gray-100">
                    <h3 class="text-lg font-semibold text-gray-900 mb-4 flex items-center">
                        <i class="fas fa-trophy text-yellow-600 mr-2"></i>
                        Top Propriétaires
                    </h3>
                    <div class="space-y-3">
                        <c:forEach var="entry" items="${topProprietaires}" varStatus="status">
                            <div class="flex items-center justify-between p-3 rounded-lg ${status.index == 0 ? 'bg-yellow-50 border border-yellow-200' : 'bg-gray-50'}">
                                <div class="flex items-center">
                                    <div class="w-8 h-8 rounded-full flex items-center justify-center mr-3 ${status.index == 0 ? 'bg-yellow-500 text-white' : 'bg-gray-400 text-white'} text-sm font-bold">
                                            ${status.index + 1}
                                    </div>
                                    <span class="text-gray-900 font-medium">${entry.key}</span>
                                </div>
                                <span class="text-gray-600 font-semibold">${entry.value} immeuble(s)</span>
                            </div>
                        </c:forEach>

                        <c:if test="${empty topProprietaires}">
                            <div class="text-center py-4 text-gray-500">
                                <i class="fas fa-users text-gray-300 text-2xl mb-2"></i>
                                <p class="text-sm">Aucun propriétaire enregistré</p>
                            </div>
                        </c:if>
                    </div>
                </div>

                <!-- Statistiques des demandes -->
                <div class="bg-white rounded-2xl p-6 shadow-lg border border-gray-100">
                    <h3 class="text-lg font-semibold text-gray-900 mb-4 flex items-center">
                        <i class="fas fa-clipboard-check text-teal-600 mr-2"></i>
                        Statut des Demandes
                    </h3>
                    <div class="space-y-4">
                        <div class="relative">
                            <div class="flex items-center justify-between mb-2">
                                <span class="text-sm font-medium text-gray-700">En attente</span>
                                <span class="text-sm text-gray-600">${demandesEnAttente}</span>
                            </div>
                            <div class="w-full bg-gray-200 rounded-full h-2">
                                <div class="bg-orange-500 h-2 rounded-full" style="width: ${totalDemandes > 0 ? (demandesEnAttente * 100 / totalDemandes) : 0}%"></div>
                            </div>
                        </div>

                        <div class="relative">
                            <div class="flex items-center justify-between mb-2">
                                <span class="text-sm font-medium text-gray-700">Acceptées</span>
                                <span class="text-sm text-gray-600">${demandesAcceptees}</span>
                            </div>
                            <div class="w-full bg-gray-200 rounded-full h-2">
                                <div class="bg-green-500 h-2 rounded-full" style="width: ${totalDemandes > 0 ? (demandesAcceptees * 100 / totalDemandes) : 0}%"></div>
                            </div>
                        </div>

                        <div class="relative">
                            <div class="flex items-center justify-between mb-2">
                                <span class="text-sm font-medium text-gray-700">Rejetées</span>
                                <span class="text-sm text-gray-600">${demandesRejetees}</span>
                            </div>
                            <div class="w-full bg-gray-200 rounded-full h-2">
                                <div class="bg-red-500 h-2 rounded-full" style="width: ${totalDemandes > 0 ? (demandesRejetees * 100 / totalDemandes) : 0}%"></div>
                            </div>
                        </div>
                    </div>

                    <div class="mt-4 pt-4 border-t border-gray-200">
                        <div class="flex items-center justify-between">
                            <span class="text-sm font-medium text-gray-700">Total demandes</span>
                            <span class="text-lg font-bold text-gray-900">${totalDemandes}</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Actions rapides -->
            <div class="bg-white rounded-2xl p-6 shadow-lg border border-gray-100">
                <h3 class="text-lg font-semibold text-gray-900 mb-4 flex items-center">
                    <i class="fas fa-bolt text-yellow-500 mr-2"></i>
                    Actions Rapides
                </h3>
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                    <a href="user" class="flex flex-col items-center p-6 bg-gradient-to-br from-blue-50 to-blue-100 rounded-xl border border-blue-200 hover:shadow-md transition-all duration-200 group">
                        <div class="w-12 h-12 bg-blue-600 rounded-xl flex items-center justify-center text-white mb-3 group-hover:scale-110 transition-transform duration-200">
                            <i class="fas fa-user-plus text-xl"></i>
                        </div>
                        <span class="text-sm font-medium text-blue-800">Gérer Utilisateurs</span>
                        <span class="text-xs text-blue-600 mt-1">${totalUsers} utilisateurs</span>
                    </a>

                    <a href="immeuble" class="flex flex-col items-center p-6 bg-gradient-to-br from-green-50 to-green-100 rounded-xl border border-green-200 hover:shadow-md transition-all duration-200 group">
                        <div class="w-12 h-12 bg-green-600 rounded-xl flex items-center justify-center text-white mb-3 group-hover:scale-110 transition-transform duration-200">
                            <i class="fas fa-building text-xl"></i>
                        </div>
                        <span class="text-sm font-medium text-green-800">Voir Immeubles</span>
                        <span class="text-xs text-green-600 mt-1">${totalImmeubles} immeubles</span>
                    </a>

                    <a href="contrat" class="flex flex-col items-center p-6 bg-gradient-to-br from-purple-50 to-purple-100 rounded-xl border border-purple-200 hover:shadow-md transition-all duration-200 group">
                        <div class="w-12 h-12 bg-purple-600 rounded-xl flex items-center justify-center text-white mb-3 group-hover:scale-110 transition-transform duration-200">
                            <i class="fas fa-file-contract text-xl"></i>
                        </div>
                        <span class="text-sm font-medium text-purple-800">Gérer Contrats</span>
                        <span class="text-xs text-purple-600 mt-1">${totalContrats} contrats</span>
                    </a>

                    <a href="demande" class="flex flex-col items-center p-6 bg-gradient-to-br from-orange-50 to-orange-100 rounded-xl border border-orange-200 hover:shadow-md transition-all duration-200 group">
                        <div class="w-12 h-12 bg-orange-600 rounded-xl flex items-center justify-center text-white mb-3 group-hover:scale-110 transition-transform duration-200">
                            <i class="fas fa-clipboard-list text-xl"></i>
                        </div>
                        <span class="text-sm font-medium text-orange-800">Traiter Demandes</span>
                        <span class="text-xs text-orange-600 mt-1">${demandesEnAttente} en attente</span>
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // Initialisation de la date actuelle
    document.addEventListener('DOMContentLoaded', function() {
        const now = new Date();
        const options = {
            weekday: 'long',
            year: 'numeric',
            month: 'long',
            day: 'numeric'
        };
        document.getElementById('currentDate').textContent =
            now.toLocaleDateString('fr-FR', options);

        // Initialiser les graphiques
        initializeCharts();

        // Animation d'apparition
        animateOnLoad();
    });

    function initializeCharts() {
        // Graphique des utilisateurs (Doughnut)
        const usersCtx = document.getElementById('usersChart').getContext('2d');
        new Chart(usersCtx, {
            type: 'doughnut',
            data: {
                labels: ['Administrateurs', 'Propriétaires', 'Locataires'],
                datasets: [{
                    data: [${adminsCount}, ${proprietairesCount}, ${locatairesCount}],
                    backgroundColor: ['#EF4444', '#3B82F6', '#10B981'],
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    }
                }
            }
        });

        // Graphique des contrats (Doughnut)
        const contratsCtx = document.getElementById('contratsChart').getContext('2d');
        new Chart(contratsCtx, {
            type: 'doughnut',
            data: {
                labels: ['Actifs', 'Terminés', 'Résiliés'],
                datasets: [{
                    data: [${contratsActifs}, ${contratsTermines}, ${contratsResilies}],
                    backgroundColor: ['#10B981', '#F59E0B', '#EF4444'],
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    }
                }
            }
        });

        // Graphique d'évolution des contrats (Line)
        const evolutionCtx = document.getElementById('contratsEvolutionChart').getContext('2d');

        // Préparer les données pour le graphique d'évolution
        const months = [];
        const contractCounts = [];

        <c:forEach var="entry" items="${contratsParMois}">
        months.push('${entry.key}');
        contractCounts.push(${entry.value});
        </c:forEach>

        new Chart(evolutionCtx, {
            type: 'line',
            data: {
                labels: months,
                datasets: [{
                    label: 'Nouveaux contrats',
                    data: contractCounts,
                    borderColor: '#8B5CF6',
                    backgroundColor: 'rgba(139, 92, 246, 0.1)',
                    borderWidth: 3,
                    fill: true,
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            stepSize: 1
                        }
                    }
                }
            }
        });
    }

    // Animation d'apparition
    function animateOnLoad() {
        const animatedElements = document.querySelectorAll('.animate-fade-in');
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

    // Actualisation automatique toutes les 5 minutes
    setInterval(function() {
        window.location.reload();
    }, 300000);
</script>

</body>
</html>