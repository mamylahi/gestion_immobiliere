<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Gestion des Locataires</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
</head>
<body class="container mt-4">
<%@ include file="../../navbar/navbar.jsp" %>


<h2 class="mb-4">Liste des Locataires</h2>

<!-- Bouton Ajouter -->
<a href="locataires?action=add" class="btn btn-primary mb-3">Ajouter un Locataire</a>

<!-- Tableau -->
<table class="table table-bordered table-striped">
    <thead class="table-dark">
    <tr>
        <th>ID</th>
        <th>Nom</th>
        <th>Email</th>
        <th>Téléphone</th>
        <th>Adresse</th>
        <th>Actions</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="locataire" items="${locataires}">
        <tr>
            <td>${locataire.id}</td>
            <td>${locataire.user.nom}</td>
            <td>${locataire.user.prenom}</td>
            <td>${locataire.user.telephone}</td>
            <td>${locataire.adresse}</td>
            <td>
                <a href="locataires?action=edit&id=${locataire.id}" class="btn btn-warning btn-sm">Modifier</a>
                <a href="locataires?action=delete&id=${locataire.id}"
                   class="btn btn-danger btn-sm"
                   onclick="return confirm('Voulez-vous vraiment supprimer ce locataire ?');">
                    Supprimer
                </a>
                <a href="locataires?action=details&id=${locataire.id}" class="btn btn-info btn-sm">Détails</a>
            </td>
        </tr>
    </c:forEach>
    </tbody>
</table>

</body>
</html>
