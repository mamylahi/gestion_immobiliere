<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8" />
    <title>Gestion Immobilière</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Heroicons pour les icônes -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-50">
<!-- Sidebar fixe -->
<div class="fixed inset-y-0 left-0 w-64 bg-white shadow-lg border-r border-gray-200 z-50">
    <div class="flex flex-col h-full">
        <!-- Header avec logo et déconnexion -->
        <div class="flex items-center justify-between p-4 border-b border-gray-200">
            <!-- Logo -->
            <div class="flex items-center">
                <a href="${pageContext.request.contextPath}/" class="text-lg font-bold text-blue-600">
                    <i class="fas fa-building mr-2"></i>
                    Gestion Immobilière
                </a>
            </div>
        </div>

        <!-- Navigation principale -->
        <nav class="flex-1 px-4 py-6 space-y-2 overflow-y-auto">
            <!-- Links pour ADMIN uniquement -->
            <c:if test="${sessionScope.user.role == 'ADMIN'}">
                <a href="${pageContext.request.contextPath}/dashboard/admin"
                   class="flex items-center px-4 py-3 text-gray-700 hover:text-blue-600 hover:bg-blue-50 rounded-lg transition-colors duration-200 group">
                    <i class="fas fa-home w-5 h-5 mr-3 text-gray-400 group-hover:text-blue-600"></i>
                    <span class="font-medium">Accueil</span>
                </a>
                <a href="${pageContext.request.contextPath}/user"
                   class="flex items-center px-4 py-3 text-gray-700 hover:text-blue-600 hover:bg-blue-50 rounded-lg transition-colors duration-200 group">
                    <i class="fas fa-users w-5 h-5 mr-3 text-gray-400 group-hover:text-blue-600"></i>
                    <span class="font-medium">Utilisateurs</span>
                </a>
                <a href="${pageContext.request.contextPath}/immeuble"
                   class="flex items-center px-4 py-3 text-gray-700 hover:text-blue-600 hover:bg-blue-50 rounded-lg transition-colors duration-200 group">
                    <i class="fas fa-building w-5 h-5 mr-3 text-gray-400 group-hover:text-blue-600"></i>
                    <span class="font-medium">Immeubles</span>
                </a>
                <a href="${pageContext.request.contextPath}/unite"
                   class="flex items-center px-4 py-3 text-gray-700 hover:text-blue-600 hover:bg-blue-50 rounded-lg transition-colors duration-200 group">
                    <i class="fas fa-door-open w-5 h-5 mr-3 text-gray-400 group-hover:text-blue-600"></i>
                    <span class="font-medium">Unités de Location</span>
                </a>
            </c:if>

            <!-- Links pour PROPRIETAIRE uniquement -->
            <c:if test="${sessionScope.user.role == 'PROPRIETAIRE'}">
                <a href="${pageContext.request.contextPath}/dashboard/proprietaireIndex"
                   class="flex items-center px-4 py-3 text-gray-700 hover:text-blue-600 hover:bg-blue-50 rounded-lg transition-colors duration-200 group">
                    <i class="fas fa-home w-5 h-5 mr-3 text-gray-400 group-hover:text-blue-600"></i>
                    <span class="font-medium">Accueil</span>
                </a>
                <a href="${pageContext.request.contextPath}/immeuble"
                   class="flex items-center px-4 py-3 text-gray-700 hover:text-blue-600 hover:bg-blue-50 rounded-lg transition-colors duration-200 group">
                    <i class="fas fa-building w-5 h-5 mr-3 text-gray-400 group-hover:text-blue-600"></i>
                    <span class="font-medium">Mes Immeubles</span>
                </a>
                <a href="${pageContext.request.contextPath}/unite"
                   class="flex items-center px-4 py-3 text-gray-700 hover:text-blue-600 hover:bg-blue-50 rounded-lg transition-colors duration-200 group">
                    <i class="fas fa-door-open w-5 h-5 mr-3 text-gray-400 group-hover:text-blue-600"></i>
                    <span class="font-medium">Mes Unités</span>
                </a>
                <a href="${pageContext.request.contextPath}/contrats"
                   class="flex items-center px-4 py-3 text-gray-700 hover:text-blue-600 hover:bg-blue-50 rounded-lg transition-colors duration-200 group">
                    <i class="fas fa-file-contract w-5 h-5 mr-3 text-gray-400 group-hover:text-blue-600"></i>
                    <span class="font-medium">Mes Locations</span>
                </a>
                <a href="${pageContext.request.contextPath}/demandeLocation"
                   class="flex items-center px-4 py-3 text-gray-700 hover:text-blue-600 hover:bg-blue-50 rounded-lg transition-colors duration-200 group">
                    <i class="fas fa-inbox w-5 h-5 mr-3 text-gray-400 group-hover:text-blue-600"></i>
                    <span class="font-medium">Demandes</span>
                    <c:if test="${not empty demandesEnAttente && demandesEnAttente > 0}">
                        <span class="bg-red-500 text-white text-xs font-bold px-2 py-1 rounded-full ml-auto">${demandesEnAttente}</span>
                    </c:if>
                </a>
            </c:if>

            <!-- Links pour LOCATAIRE uniquement -->
            <c:if test="${sessionScope.user.role == 'LOCATAIRE'}">
                <a href="${pageContext.request.contextPath}/locataireIndex"
                   class="flex items-center px-4 py-3 text-gray-700 hover:text-blue-600 hover:bg-blue-50 rounded-lg transition-colors duration-200 group">
                    <i class="fas fa-home w-5 h-5 mr-3 text-gray-400 group-hover:text-blue-600"></i>
                    <span class="font-medium">Accueil</span>
                </a>
                <a href="${pageContext.request.contextPath}/demandeLocation"
                   class="flex items-center px-4 py-3 text-gray-700 hover:text-blue-600 hover:bg-blue-50 rounded-lg transition-colors duration-200 group">
                    <i class="fas fa-paper-plane w-5 h-5 mr-3 text-gray-400 group-hover:text-blue-600"></i>
                    <span class="font-medium">Mes Demandes</span>
                </a>
                <a href="${pageContext.request.contextPath}/contrats"
                   class="flex items-center px-4 py-3 text-gray-700 hover:text-blue-600 hover:bg-blue-50 rounded-lg transition-colors duration-200 group">
                    <i class="fas fa-file-contract w-5 h-5 mr-3 text-gray-400 group-hover:text-blue-600"></i>
                    <span class="font-medium">Mes Contrats</span>
                </a>
                <a href="${pageContext.request.contextPath}/paiements"
                   class="flex items-center px-4 py-3 text-gray-700 hover:text-blue-600 hover:bg-blue-50 rounded-lg transition-colors duration-200 group">
                    <i class="fas fa-credit-card w-5 h-5 mr-3 text-gray-400 group-hover:text-blue-600"></i>
                    <span class="font-medium">Paiements</span>
                </a>
            </c:if>

        </nav>

        <!-- Section utilisateur en bas -->
        <c:if test="${not empty sessionScope.user}">
            <div class="border-t border-gray-200 p-4">
                <div class="flex items-center space-x-3">
                    <!-- Avatar utilisateur -->
                    <div class="w-12 h-12 bg-gradient-to-br from-blue-500 to-blue-600 rounded-full flex items-center justify-center text-white font-bold text-lg shadow-md">
                            ${sessionScope.user.prenom.charAt(0)}${sessionScope.user.nom.charAt(0)}
                    </div>

                    <!-- Informations utilisateur -->
                    <div class="flex-1 min-w-0">
                        <p class="text-sm font-semibold text-gray-800 truncate">
                                ${sessionScope.user.prenom} ${sessionScope.user.nom}
                        </p>
                        <p class="text-xs text-gray-500 truncate">
                                ${sessionScope.user.email}
                        </p>
                        <span class="inline-block px-2 py-1 mt-1 text-xs font-medium rounded-full
                                ${sessionScope.user.role == 'ADMIN' ? 'bg-red-100 text-red-800' :
                                  sessionScope.user.role == 'PROPRIETAIRE' ? 'bg-green-100 text-green-800' :
                                  'bg-blue-100 text-blue-800'}">
                                ${sessionScope.user.role}
                        </span>
                    </div>

                    <!-- Menu utilisateur -->
                    <div class="relative">
                        <button id="user-menu-button"
                                class="p-2 text-gray-400 hover:text-gray-600 rounded-lg hover:bg-gray-100 transition-colors duration-200">
                            <i class="fas fa-ellipsis-v"></i>
                        </button>

                        <!-- Dropdown menu -->
                        <div id="user-dropdown" class="hidden absolute bottom-full right-0 mb-2 w-48 bg-white rounded-lg shadow-lg border border-gray-200 py-1 z-50">
                            <a href="${pageContext.request.contextPath}/profil"
                               class="flex items-center px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 transition-colors duration-200">
                                <i class="fas fa-user w-4 h-4 mr-3 text-gray-400"></i>
                                Mon Profil
                            </a>
                            <c:if test="${sessionScope.user.role == 'ADMIN'}">
                                <a href="${pageContext.request.contextPath}/configuration"
                                   class="flex items-center px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 transition-colors duration-200">
                                    <i class="fas fa-cog w-4 h-4 mr-3 text-gray-400"></i>
                                    Configuration
                                </a>
                            </c:if>
                            <hr class="my-1 border-gray-200">
                            <a href="${pageContext.request.contextPath}/auth"
                               class="flex items-center px-4 py-2 text-sm text-red-600 hover:bg-red-50 transition-colors duration-200">
                                <i class="fas fa-sign-out-alt w-4 h-4 mr-3"></i>
                                Déconnexion
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- Si pas d'utilisateur connecté -->
        <c:if test="${empty sessionScope.user}">
            <div class="border-t border-gray-200 p-4">
                <div class="space-y-2">
                    <a href="${pageContext.request.contextPath}/login"
                       class="flex items-center justify-center w-full px-4 py-2 text-gray-700 border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors duration-200">
                        <i class="fas fa-sign-in-alt w-4 h-4 mr-2"></i>
                        Connexion
                    </a>
                    <a href="${pageContext.request.contextPath}/register"
                       class="flex items-center justify-center w-full px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors duration-200">
                        <i class="fas fa-user-plus w-4 h-4 mr-2"></i>
                        S'inscrire
                    </a>
                </div>
            </div>
        </c:if>
    </div>
</div>

<!-- Scripts JavaScript -->
<script>
    // Toggle du menu utilisateur
    document.getElementById('user-menu-button')?.addEventListener('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        const dropdown = document.getElementById('user-dropdown');
        dropdown.classList.toggle('hidden');
    });

    // Fermer le dropdown quand on clique ailleurs
    document.addEventListener('click', function(event) {
        const userButton = document.getElementById('user-menu-button');
        const dropdown = document.getElementById('user-dropdown');

        if (userButton && dropdown && !userButton.contains(event.target) && !dropdown.contains(event.target)) {
            dropdown.classList.add('hidden');
        }
    });

    // Gestion des notifications
    document.getElementById('notifications-button')?.addEventListener('click', function() {
        // Implémenter la logique des notifications
        alert('Fonctionnalité des notifications à implémenter');
    });

    // Ajouter la classe active au lien courant (optionnel)
    const currentPath = window.location.pathname;
    const sidebarLinks = document.querySelectorAll('nav a');

    sidebarLinks.forEach(link => {
        if (link.getAttribute('href') && currentPath.includes(link.getAttribute('href').split('/').pop())) {
            link.classList.add('bg-blue-50', 'text-blue-600');
            link.classList.remove('text-gray-700');
            const icon = link.querySelector('i');
            if (icon) {
                icon.classList.add('text-blue-600');
                icon.classList.remove('text-gray-400');
            }
        }
    });
</script>
</body>
</html>