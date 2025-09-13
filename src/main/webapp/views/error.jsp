<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Erreur - Gestion Immobilière</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gradient-to-br from-red-50 to-white font-sans min-h-screen">

<div class="container mx-auto px-4 py-8">
    <div class="max-w-2xl mx-auto text-center">
        <div class="bg-white rounded-lg shadow-lg p-8 border-l-4 border-red-500">
            <div class="flex items-center justify-center w-16 h-16 mx-auto mb-4 bg-red-100 rounded-full">
                <svg class="w-8 h-8 text-red-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                </svg>
            </div>

            <h1 class="text-3xl font-bold text-gray-800 mb-4">Une erreur s'est produite</h1>

            <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="bg-red-50 border border-red-200 rounded-md p-4 mb-6">
                <p class="text-red-700 font-medium">
                    <%= request.getAttribute("errorMessage") %>
                </p>
            </div>
            <% } else { %>
            <p class="text-gray-600 mb-6">
                Désolé, une erreur inattendue s'est produite. Veuillez réessayer.
            </p>
            <% } %>

            <div class="flex flex-col sm:flex-row gap-4 justify-center">
                <a href="javascript:history.back()"
                   class="bg-gray-500 hover:bg-gray-600 text-white font-bold py-2 px-4 rounded transition-colors">
                    ← Retour
                </a>
                <a href="${pageContext.request.contextPath}/"
                   class="bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded transition-colors">
                    🏠 Accueil
                </a>
            </div>
        </div>
    </div>
</div>

</body>
</html>