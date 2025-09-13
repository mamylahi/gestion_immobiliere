<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tableau de Bord Propriétaire</title>
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
                                <h1 class="text-4xl font-bold mb-2">Tableau de Bord Propriétaire</h1>
                                <p class="text-white text-opacity-90 text-lg">Gestion de votre patrimoine immobilier</p>
                                <div class="mt-4 flex items-center">
                                    <i class="fas fa-calendar-alt mr-2"></i>
                                    <span class="text-white text-opacity-80" id="currentDate"></span>
                                </div>
                            </div>
                            <div class="text-right">
                                <div class="w-16 h-16 bg-white/20 backdrop-blur-sm rounded-2xl flex items-center justify-center">
                                    <i class="fas fa-building text-3xl"></i>
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
                <!-- Total Immeubles -->
                <div class="bg-white rounded-2xl p-6 shadow-lg border border-gray-100 hover:shadow-xl transition-shadow duration-300">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-gray-600 text-sm font-medium">Mes Immeubles</p>
                            <p class="text-3xl font-bold text-gray-900">${totalImmeubles}</p>
                            <div class="flex items-center mt-2 text-sm">
                                <span class="text-green-600 font-medium">${totalUnites}</span>
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
                                <span class="text-blue-600 font-medium">${unitesOccupees}</span>
                                <span class="text-gray-500 ml-1">sur ${totalUnites}</span>
                            </div>
                        </div>
                        <div class="w-16 h-16 bg-blue-100 rounded-xl flex items-center justify-center">
                            <i class="fas fa-home text-blue-600 text-xl"></i>
                        </div>
                    </div>
                </div>

                <!-- Revenus Réels -->
                <div class="bg-white rounded-2xl p-6 shadow-lg border border-gray-100 hover:shadow-xl transition-shadow duration-300">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-gray-600 text-sm font-medium">Revenus Réels</p>
                            <p class="text-3xl font-bold text-gray-900">
                                <fmt:formatNumber value="${revenusReel}" pattern="#,##0" />
                            </p>
                            <div class="flex items-center mt-2 text-sm">
                                <span class="text-purple-600 font-medium">FCFA</span>
                                <span class="text-gray-500 ml-1">collectés</span>
                            </div>
                        </div>
                        <div class="w-16 h-16 bg-purple-100 rounded-xl flex items-center justify-center">
                            <i class="fas fa-coins text-purple-600 text-xl"></i>
                        </div>
                    </div>
                </div>

                <!-- Demandes en Attente -->
                <div class="bg-white rounded-2xl p-6 shadow-lg border border-gray-100 hover:shadow-xl transition-shadow duration-300">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-gray-600 text-sm font-medium">Demandes en Attente</p>
                            <p class="text-3xl font-bold text-gray-900">${demandesEnAttente}</p>
                            <div class="flex items-center mt-2 text-sm">
                                <span class="text-orange-600 font-medium">À traiter</span>
                                <span class="text-gray-500 ml-1">demande(s)</span>
                            </div>
                        </div>
                        <div class="w-16 h-16 bg-orange-100 rounded-xl flex items-center justify-center">
                            <i class="fas fa-clock text-orange-600 text-xl"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Graphiques et analyses -->
            <div class="mb-8 grid grid-cols-1 lg:grid-cols-2 gap-6">
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

                        <c:if test="${unitesVacantesLongtemps > 0}">
                            <div class="flex items-center p-3 bg-yellow-50 rounded-lg border border-yellow-200">
                                <i class="fas fa-home text-yellow-600 mr-3"></i>
                                <div>
                                    <p class="text-sm font-medium text-yellow-800">Unités vacantes</p>
                                    <p class="text-xs text-yellow-600">${unitesVacantesLongtemps} unité(s) vacante(s) depuis longtemps</p>
                                </div>
                            </div>
                        </c:if>

                        <c:if test="${demandesEnAttente > 0}">
                            <div class="flex items-center p-3 bg-blue-50 rounded-lg border border-blue-200">
                                <i class="fas fa-clipboard-list text-blue-600 mr-3"></i>
                                <div>
                                    <p class="text-sm font-medium text-blue-800">Demandes à traiter</p>
                                    <p class="text-xs text-blue-600">${demandesEnAttente} demande(s) en attente</p>
                                </div>
                            </div>
                        </c:if>

                        <c:if test="${paiementsEnRetard == 0 && contratsExpirants == 0 && unitesVacantesLongtemps == 0 && demandesEnAttente == 0}">
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

            <!-- Évolution et Performance -->
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

                <!-- Performance des Immeubles -->
                <div class="bg-white rounded-2xl p-6 shadow-lg border border-gray-100">
                    <h3 class="text-lg font-semibold text-gray-900 mb-4 flex items-center">
                        <i class="fas fa-chart-bar text-indigo-600 mr-2"></i>
                        Taux d'Occupation par Immeuble
                    </h3>
                    <div class="space-y-3 max-h-64 overflow-y-auto">
                        <c:forEach var="entry" items="${occupationParImmeuble}">
                            <div class="relative">
                                <div class="flex items-center justify-between mb-2">
                                    <span class="text-sm font-medium text-gray-700">${entry.key}</span>
                                    <span class="text-sm text-gray-600">
                                        <fmt:formatNumber value="${entry.value}" pattern="#0.0" />%
                                    </span>
                                </div>
                                <div class="w-full bg-gray-200 rounded-full h-2">
                                    <div class="bg-indigo-500 h-2 rounded-full"
                                         style="width: ${entry.value}%"></div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <!-- Activités récentes -->
            <div class="mb-8 grid grid-cols-1 lg:grid-cols-2 gap-6">
                <!-- Derniers Contrats -->
                <div class="bg-white rounded-2xl p-6 shadow-lg border border-gray-100">
                    <h3 class="text-lg font-semibold text-gray-900 mb-4 flex items-center">
                        <i class="fas fa-file-signature text-green-600 mr-2"></i>
                        Derniers Contrats Signés
                    </h3>
                    <div class="space-y-3 max-h-64 overflow-y-auto">
                        <c:forEach var="contrat" items="${derniersContrats}" begin="0" end="4">
                            <div class="flex items-center p-3 bg-green-50 rounded-lg border border-green-100">
                                <i class="fas fa-file-contract text-green-600 mr-3"></i>
                                <div class="flex-1">
                                    <p class="text-sm font-medium text-gray-900">
                                            ${contrat.immeubleNom} - Unité ${contrat.uniteNumero}
                                    </p>
                                    <p class="text-xs text-gray-600">
                                            ${contrat.locataireNomComplet} -
                                        <fmt:formatDate value="${contrat.dateDebut}" pattern="dd/MM/yyyy" />
                                    </p>
                                    <p class="text-xs text-green-600 font-medium">
                                        <fmt:formatNumber value="${contrat.loyerMensuel}" pattern="#,##0" /> FCFA/mois
                                    </p>
                                </div>
                            </div>
                        </c:forEach>

                        <c:if test="${empty derniersContrats}">
                            <div class="text-center py-4 text-gray-500">
                                <i class="fas fa-inbox text-gray-300 text-2xl mb-2"></i>
                                <p class="text-sm">Aucun contrat récent</p>
                            </div>
                        </c:if>
                    </div>
                </div>

                <!-- Dernières Demandes -->
                <div class="bg-white rounded-2xl p-6 shadow-lg border border-gray-100">
                    <h3 class="text-lg font-semibold text-gray-900 mb-4 flex items-center">
                        <i class="fas fa-inbox text-blue-600 mr-2"></i>
                        Dernières Demandes Reçues
                    </h3>
                    <div class="space-y-3 max-h-64 overflow-y-auto">
                        <c:forEach var="demande" items="${dernieresDemandes}" begin="0" end="4">
                            <div class="flex items-center p-3
                                ${demande.status == 'EN_ATTENTE' ? 'bg-yellow-50 border-yellow-200' :
                                  demande.status == 'ACCEPTEE' ? 'bg-green-50 border-green-200' :
                                  'bg-red-50 border-red-200'}
                                rounded-lg border">
                                <i class="fas fa-user
                                   ${demande.status == 'EN_ATTENTE' ? 'text-yellow-600' :
                                     demande.status == 'ACCEPTEE' ? 'text-green-600' :
                                     'text-red-600'} mr-3"></i>
                                <div class="flex-1">
                                    <p class="text-sm font-medium text-gray-900">
                                            ${demande.immeubleNom} - Unité ${demande.uniteNumero}
                                    </p>
                                    <p class="text-xs text-gray-600">
                                            ${demande.locataireNomComplet}
                                    </p>
                                    <p class="text-xs font-medium
                                       ${demande.status == 'EN_ATTENTE' ? 'text-yellow-600' :
                                         demande.status == 'ACCEPTEE' ? 'text-green-600' :
                                         'text-red-600'}">
                                            ${demande.status}
                                    </p>
                                </div>
                            </div>
                        </c:forEach>

                        <c:if test="${empty dernieresDemandes}">
                            <div class="text-center py-4 text-gray-500">
                                <i class="fas fa-inbox text-gray-300 text-2xl mb-2"></i>
                                <p class="text-sm">Aucune demande récente</p>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>

            <!-- Résumé financier -->
            <div class="mb-8 bg-white rounded-2xl p-6 shadow-lg border border-gray-100">
                <h3 class="text-lg font-semibold text-gray-900 mb-4 flex items-center">
                    <i class="fas fa-chart-pie text-emerald-600 mr-2"></i>
                    Résumé Financier
                </h3>
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                    <div class="text-center">
                        <p class="text-2xl font-bold text-emerald-600">
                            <fmt:formatNumber value="${revenusTheorique}" pattern="#,##0" />
                        </p>
                        <p class="text-sm text-gray-600">Revenus Théoriques (FCFA)</p>
                    </div>
                    <div class="text-center">
                        <p class="text-2xl font-bold text-blue-600">
                            <fmt:formatNumber value="${revenusReel}" pattern="#,##0" />
                        </p>
                        <p class="text-sm text-gray-600">Revenus Réels (FCFA)</p>
                    </div>
                    <div class="text-center">
                        <p class="text-2xl font-bold text-orange-600">
                            <fmt:formatNumber value="${revenusEnAttente}" pattern="#,##0" />
                        </p>
                        <p class="text-sm text-gray-600">En Attente (FCFA)</p>
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
                    <a href="immeuble" class="flex flex-col items-center p-6 bg-gradient-to-br from-green-50 to-green-100 rounded-xl border border-green-200 hover:shadow-md transition-all duration-200 group">
                        <div class="w-12 h-12 bg-green-600 rounded-xl flex items-center justify-center text-white mb-3 group-hover:scale-110 transition-transform duration-200">
                            <i class="fas fa-building text-xl"></i>
                        </div>
                        <span class="text-sm font-medium text-green-800">Gérer Immeubles</span>
                        <span class="text-xs text-green-600 mt-1">${totalImmeubles} immeuble(s)</span>
                    </a>

                    <a href="unite" class="flex flex-col items-center p-6 bg-gradient-to-br from-blue-50 to-blue-100 rounded-xl border border-blue-200 hover:shadow-md transition-all duration-200 group">
                        <div class="w-12 h-12 bg-blue-600 rounded-xl flex items-center justify-center text-white mb-3 group-hover:scale-110 transition-transform duration-200">
                            <i class="fas fa-home text-xl"></i>
                        </div>
                        <span class="text-sm font-medium text-blue-800">Gérer Unités</span>
                        <span class="text-xs text-blue-600 mt-1">${totalUnites} unité(s)</span>
                    </a>

                    <a href="contrat" class="flex flex-col items-center p-6 bg-gradient-to-br from-purple-50 to-purple-100 rounded-xl border border-purple-200 hover:shadow-md transition-all duration-200 group">
                        <div class="w-12 h-12 bg-purple-600 rounded-xl flex items-center justify-center text-white mb-3 group-hover:scale-110 transition-transform duration-200">
                            <i class="fas fa-file-contract text-xl"></i>
                        </div>
                        <span class="text-sm font-medium text-purple-800">Voir Contrats</span>
                        <span class="text-xs text-purple-600 mt-1">${totalContrats} contrat(s)</span>
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

    // Actualisation automatique toutes les 10 minutes
    setInterval(function() {
        window.location.reload();
    }, 600000);
</script>

</body>
</html>