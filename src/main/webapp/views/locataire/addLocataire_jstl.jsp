<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Ajouter un Locataire</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
</head>
<body class="container mt-4">
<%@ include file="../../navbar/navbar.jsp" %>


<h2 class="mb-4">Ajouter un Locataire</h2>

<form action="locataires" method="post" class="row g-3">
    <input type="hidden" name="action" value="add" />

    <div class="col-md-6">
        <label for="user" class="form-label">Choisir un utilisateur :</label>
        <select name="user" id="user" class="form-select" required>
            <option value="">-- Sélectionnez un utilisateur --</option>
            <c:forEach var="u" items="${users}">
                <option value="${u.id}">${u.prenom} ${u.nom}</option>
            </c:forEach>
        </select>
    </div>

    <div class="col-md-6">
        <label class="form-label">Adresse</label>
        <input type="text" name="adresse" class="form-control" required>
    </div>
    <div class="col-md-6">
        <label class="form-label">Profession</label>
        <input type="text" name="profession" class="form-control" required>
    </div>




    <div class="col-12">
        <button type="submit" class="btn btn-success">Enregistrer</button>
        <a href="locataires" class="btn btn-secondary">Annuler</a>
    </div>
</form>

</body>
</html>
