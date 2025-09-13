<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Accès Non Autorisé - Gestion Immobilière</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
</head>
<body class="min-h-screen bg-gradient-to-br from-red-50 via-white to-red-100">

<div class="min-h-screen flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
    <div class="max-w-md w-full text-center space-y-8">

        <!-- Icône d'erreur -->
        <div class="mx-auto h-32 w-32 bg-gradient-to-br from-red-500 to-red-600 rounded-full flex items-center justify-center shadow-xl">
            <i class="fas fa-shield-alt text-white text-5xl"></i>
        </div>

        <!-- Message d'erreur -->
        <div class="space-y-4">
            <h1 class="text-4xl font-bold text-gray-900">Accès Refusé</h1>
            <h2 class="text-xl text-gray-600">Error 403 - Non autorisé</h2>
            <p class="text-gray-500">
                Vous n'avez pas les permissions nécessaires pour accéder à cette page.
            </p>
        </div>

        <!-- Informations utilisateur -->
        <c:if test="${not empty sessionScope.user}">
            <div class="bg-white rounded-xl p-6 shadow-lg border border-gray-200">
                <div class="flex items-center justify-center space-x-3 mb-4">
                    <div class="w-12 h-12 bg-gradient-to-br from-blue-500 to-blue-600 rounded-full flex items-center justify-center text-white font-bold">
                            ${sessionScope.user.prenom.charAt(0)}${sessionScope.user.nom.charAt(0)}
                    </div>
                    <div>
                        <p class="text-sm font-medium text-gray-900">
                                ${sessionScope.user.prenom} ${sessionScope.user.nom}
                        </p>
                        <p class="text-xs text-gray-500">
                            Rôle: ${sessionScope.user.role}
                        </p>
                    </div>
                </div>
                <p class="text-sm text-gray-600">
                    Votre niveau d'accès actuel ne permet pas de consulter cette ressource.
                </p>
            </div>
        </c:if>

        <!-- Actions disponibles -->
        <div class="space-y-4">
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <!-- Utilisateur connecté -->
                    <c:choose>
                        <c:when test="${sessionScope.user.role == 'ADMIN'}">
                            <a href="${pageContext.request.contextPath}/admin"
                               class="inline-flex items-center px-6 py-3 bg-gradient-to-r from-blue-600 to-purple-600 text-white font-medium rounded-xl hover:from-blue-700 hover:to-purple-700 transition-all duration-200 transform hover:scale-105 shadow-lg">
                                <i class="fas fa-tachometer-alt mr-2"></i>
                                Retour au tableau de bord
                            </a>
                        </c:when>
                        <c:when test="${sessionScope.user.role == 'PROPRIETAIRE'}">
                            <a href="${pageContext.request.contextPath}/proprietaire"
                               class="inline-flex items-center px-6 py-3 bg-gradient-to-r from-green-600 to-emerald-600 text-white font-medium rounded-xl hover:from-green-700 hover:to-emerald-700 transition-all duration-200 transform hover:scale-105 shadow-lg">
                                <i class="fas fa-building mr-2"></i>
                                Retour à mes propriétés
                            </a>
                        </c:when>
                        <c:when test="${sessionScope.user.role == 'LOCATAIRE'}">
                            <a href="${pageContext.request.contextPath}/locataireIndex"
                               class="inline-flex items-center px-6 py-3 bg-gradient-to-r from-blue-600 to-indigo-600 text-white font-medium rounded-xl hover:from-blue-700 hover:to-indigo-700 transition-all duration-200 transform hover:scale-105 shadow-lg">
                                <i class="fas fa-home mr-2"></i>
                                Retour à mon espace
                            </a>
                        </c:when>
                    </c:choose>

                    <!-- Lien de déconnexion -->
                    <div class="pt-4">
                        <a href="${pageContext.request.contextPath}/auth?action=logout"
                           class="text-sm text-gray-500 hover:text-red-600 transition-colors duration-200">
                            <i class="fas fa-sign-out-alt mr-1"></i>
                            Se déconnecter et retourner à l'accueil
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- Utilisateur non connecté -->
                    <div class="space-y-3">
                        <a href="${pageContext.request.contextPath}/login.jsp"
                           class="inline-flex items-center px-6 py-3 bg-gradient-to-r from-blue-600 to-purple-600 text-white font-medium rounded-xl hover:from-blue-700 hover:to-purple-700 transition-all duration-200 transform hover:scale-105 shadow-lg">
                            <i class="fas fa-sign-in-alt mr-2"></i>
                            Se connecter
                        </a>
                        <p class="text-sm text-gray-500">
                            ou
                            <a href="${pageContext.request.contextPath}/register.jsp"
                               class="text-blue-600 hover:text-blue-700 font-medium">
                                créer un compte
                            </a>
                        </p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Informations d'aide -->
        <div class="bg-gray-50 rounded-xl p-6 text-left">
            <h3 class="text-sm font-semibold text-gray-900 mb-3">
                <i class="fas fa-info-circle text-blue-500 mr-2"></i>
                Que faire ?
            </h3>
            <div class="space-y-2 text-sm text-gray-600">
                <p>• Vérifiez que vous êtes connecté avec le bon compte</p>
                <p>• Contactez votre administrateur si vous pensez avoir les droits nécessaires</p>
                <p>• Retournez à votre espace personnel via les liens ci-dessus</p>
            </div>
        </div>

        <!-- Contact support -->
        <div class="text-center">
            <p class="text-xs text-gray-400">
                Besoin d'aide ?
                <a href="mailto:support@gestion-immobiliere.com"
                   class="text-blue-500 hover:text-blue-600">
                    Contactez le support
                </a>
            </p>
        </div>
    </div>
</div>

<script>
    // Redirection automatique après 30 secondes pour les utilisateurs connectés
    <c:if test="${not empty sessionScope.user}">
    setTimeout(function() {
        <c:choose>
        <c:when test="${sessionScope.user.role == 'ADMIN'}">
        window.location.href = '${pageContext.request.contextPath}/admin';
        </c:when>
        <c:when test="${sessionScope.user.role == 'PROPRIETAIRE'}">
        window.location.href = '${pageContext.request.contextPath}/proprietaire';
        </c:when>
        <c:when test="${sessionScope.user.role == 'LOCATAIRE'}">
        window.location.href = '${pageContext.request.contextPath}/locataireIndex';
        </c:when>
        </c:choose>
    }, 30000); // 30 secondes
    </c:if>
</script>
</body>
</html>