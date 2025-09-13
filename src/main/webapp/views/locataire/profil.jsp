<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html><head>
  <title>Mon Profil</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head><body class="container mt-5">
<h2>Mon Profil</h2>
<form action="locataires" method="post">
  <input type="hidden" name="action" value="updateProfile">
  <input type="hidden" name="id" value="${locataire.id}">
  <div class="mb-3"><label>Nom</label><input name="nom" value="${locataire.nom}" class="form-control" required></div>
  <div class="mb-3"><label>Prénom</label><input name="prenom" value="${locataire.prenom}" class="form-control" required></div>
  <div class="mb-3"><label>Email</label><input type="email" name="email" value="${locataire.email}" class="form-control" required></div>
  <div class="mb-3"><label>Téléphone</label><input name="telephone" value="${locataire.telephone}" class="form-control"></div>
  <div class="mb-3"><label>Adresse</label><input name="adresse" value="${locataire.adresse}" class="form-control"></div>
  <div class="mb-3"><label>Profession</label><input name="profession" value="${locataire.profession}" class="form-control"></div>
  <div class="mb-3"><label>Changer le mot de passe</label><input type="password" name="password" class="form-control" placeholder="Laisser vide pour ne pas changer"></div>
  <button class="btn btn-primary">Mettre à jour</button>
  <a class="btn btn-outline-secondary" href="locataires?action=offres">Voir les offres</a>
  <a class="btn btn-link" href="locataires?action=logout">Se déconnecter</a>
</form>
</body></html>
