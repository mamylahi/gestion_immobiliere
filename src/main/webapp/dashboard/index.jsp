<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<body class="bg-gradient-to-br from-blue-50 to-white font-sans min-h-screen">

<%@ include file="../navbar/navbar.jsp" %>

<!-- Main Content -->
<div class="flex flex-col items-center justify-center h-[calc(100vh-4rem)] text-center px-4">
  <h1 class="text-5xl font-extrabold text-blue-600 mb-6 drop-shadow">
    🏢 Bienvenue dans <span class="text-gray-800">Gestion Immobilière</span>
  </h1>
  <p class="text-gray-600 text-lg mb-8 max-w-2xl">
    Gérez efficacement vos immeubles et unités de location avec notre système complet de gestion immobilière.
  </p>

  <!-- Quick Actions -->
  <div class="flex flex-col sm:flex-row gap-4 mt-8">
    <a href="${pageContext.request.contextPath}/immeuble"
       class="bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 px-6 rounded-lg shadow-lg transition-colors">
      Gérer les Immeubles
    </a>
    <a href="${pageContext.request.contextPath}/unite"
       class="bg-green-600 hover:bg-green-700 text-white font-bold py-3 px-6 rounded-lg shadow-lg transition-colors">
      Gérer les Unités
    </a>
  </div>
</div>

</body>
