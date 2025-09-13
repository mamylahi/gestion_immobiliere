<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Paiements</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-gray-50">

<%@ include file="../../navbar/navbar.jsp" %>

<!-- Contenu principal avec marge pour le sidebar -->
<div class="ml-64 min-h-screen">
    <div class="p-8">
        <div class="max-w-7xl mx-auto">

            <!-- En-tête avec design moderne identique à demande -->
            <div class="mb-12 animate-fade-in">
                <div class="bg-gradient-to-br from-blue-600 via-purple-600 to-blue-800 rounded-3xl text-white p-12 shadow-xl relative overflow-hidden">
                    <!-- Éléments décoratifs -->
                    <div class="absolute top-8 right-8 w-20 h-20 border-2 border-white border-opacity-30 rounded-full animate-pulse"></div>
                    <div class="absolute bottom-8 left-8 w-16 h-16 border-2 border-white border-opacity-20 rounded-full animate-bounce"></div>
                    <div class="absolute top-1/2 left-1/4 w-2 h-2 bg-white bg-opacity-40 rounded-full animate-ping"></div>

                    <div class="relative z-10 text-center">
                        <!-- Icône circulaire principale -->
                        <div class="inline-flex items-center justify-center w-24 h-24 bg-white/20 backdrop-blur-sm rounded-full mb-6">
                            <i class="fas fa-credit-card text-4xl"></i>
                        </div>

                        <h1 class="text-5xl font-bold mb-4 tracking-tight">
                            Gestion des Paiements
                        </h1>

                        <p class="text-xl text-white text-opacity-90 max-w-2xl mx-auto leading-relaxed">
                            Effectuez vos paiements de loyer en toute sécurité et suivez l'historique de vos transactions
                        </p>

                        <div class="flex justify-center mt-8 space-x-4">
                            <div class="flex items-center bg-white text-black bg-opacity-20 backdrop-blur-sm rounded-full px-4 py-2">
                                <i class="fas fa-shield-alt text-green-300 mr-2"></i>
                                <span class="text-sm">Paiement sécurisé</span>
                            </div>
                            <div class="flex items-center bg-white text-black bg-opacity-20 backdrop-blur-sm rounded-full px-4 py-2">
                                <i class="fas fa-clock text-blue-300 mr-2"></i>
                                <span class="text-sm">Instantané</span>
                            </div>
                            <div class="flex items-center bg-white text-black bg-opacity-20 backdrop-blur-sm rounded-full px-4 py-2">
                                <i class="fas fa-mobile-alt text-yellow-300 mr-2"></i>
                                <span class="text-sm">Mobile Money</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Statistiques rapides -->
            <div class="mb-8 grid grid-cols-1 md:grid-cols-3 gap-6">
                <div class="bg-white rounded-2xl p-6 shadow-lg border border-gray-100">
                    <div class="flex items-center">
                        <div class="w-12 h-12 bg-blue-100 rounded-xl flex items-center justify-center">
                            <i class="fas fa-file-contract text-blue-600"></i>
                        </div>
                        <div class="ml-4">
                            <p class="text-2xl font-bold text-gray-900">${not empty contrats ? contrats.size() : 0}</p>
                            <p class="text-gray-600">Contrats actifs</p>
                        </div>
                    </div>
                </div>

                <div class="bg-white rounded-2xl p-6 shadow-lg border border-gray-100">
                    <div class="flex items-center">
                        <div class="w-12 h-12 bg-green-100 rounded-xl flex items-center justify-center">
                            <i class="fas fa-check-circle text-green-600"></i>
                        </div>
                        <div class="ml-4">
                            <p class="text-2xl font-bold text-gray-900">
                                <c:set var="paiementsCount" value="${not empty historiquesPaiements ? historiquesPaiements.size() : 0}" />
                                ${paiementsCount}
                            </p>
                            <p class="text-gray-600">Paiements effectués</p>
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
                                <c:set var="contratsActifs" value="0" />
                                <c:forEach var="contrat" items="${contrats}">
                                    <c:if test="${contrat.statut == 'ACTIF'}">
                                        <c:set var="contratsActifs" value="${contratsActifs + 1}" />
                                    </c:if>
                                </c:forEach>
                                ${contratsActifs}
                            </p>
                            <p class="text-gray-600">A PAYER</p>
                        </div>
                    </div>
                </div>
            </div>

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

            <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
                <!-- Liste des contrats -->
                <div class="lg:col-span-2">
                    <div class="bg-white rounded-2xl shadow-lg border border-gray-100 overflow-hidden">
                        <div class="bg-gradient-to-r from-gray-800 to-gray-900 text-white p-6">
                            <h2 class="text-xl font-bold flex items-center">
                                <i class="fas fa-file-contract mr-3"></i>
                                Mes Contrats à payer
                            </h2>
                        </div>

                        <div class="p-6">
                            <c:choose>
                                <c:when test="${not empty contrats}">
                                    <div class="space-y-4">
                                        <c:forEach var="contrat" items="${contrats}">
                                            <div class="contract-card border border-gray-200 rounded-xl p-6 hover:border-blue-300 hover:shadow-md transition-all duration-200 cursor-pointer"
                                                 data-contrat-id="${contrat.id}">
                                                <div class="flex items-center justify-between">
                                                    <div class="flex-1">
                                                        <div class="flex items-center mb-3">
                                                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800 mr-3">
                                                                #${contrat.id}
                                                            </span>
                                                            <c:choose>
                                                                <c:when test="${contrat.statut == 'ACTIF'}">
                                                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                                                        <i class="fas fa-circle text-xs mr-1"></i>Actif
                                                                    </span>
                                                                </c:when>
                                                                <c:when test="${contrat.statut == 'EXPIRE'}">
                                                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800">
                                                                        <i class="fas fa-circle text-xs mr-1"></i>Expiré
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800">
                                                                        <i class="fas fa-circle text-xs mr-1"></i>${contrat.statut}
                                                                    </span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>

                                                        <h3 class="font-semibold text-gray-900 text-lg mb-2">
                                                            <c:choose>
                                                                <c:when test="${not empty contrat.unite && not empty contrat.unite.immeuble}">
                                                                    ${contrat.unite.immeuble.nom}
                                                                </c:when>
                                                                <c:otherwise>Immeuble non défini</c:otherwise>
                                                            </c:choose>
                                                        </h3>

                                                        <p class="text-gray-600 mb-3">
                                                            <c:choose>
                                                                <c:when test="${not empty contrat.unite}">
                                                                    Unité N° ${contrat.unite.numeroUnite} - ${contrat.unite.nombrePiece} pièces
                                                                </c:when>
                                                                <c:otherwise>Unité non définie</c:otherwise>
                                                            </c:choose>
                                                        </p>

                                                        <div class="flex items-center justify-between">
                                                            <div class="text-2xl font-bold text-blue-600">
                                                                <c:choose>
                                                                    <c:when test="${not empty contrat.unite && not empty contrat.unite.loyerMensuel}">
                                                                        <fmt:formatNumber value="${contrat.unite.loyerMensuel}" type="number" groupingUsed="true" /> FCFA
                                                                    </c:when>
                                                                    <c:otherwise>Montant non défini</c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                            <button class="select-contract inline-flex items-center px-4 py-2 bg-gradient-to-r from-blue-600 to-blue-700 hover:from-blue-700 hover:to-blue-800 text-white font-medium rounded-xl transition-all duration-200 transform hover:scale-105"
                                                                    data-contrat-id="${contrat.id}"
                                                                    data-montant="${not empty contrat.unite && not empty contrat.unite.loyerMensuel ? contrat.unite.loyerMensuel : 0}"
                                                                    data-immeuble="${not empty contrat.unite && not empty contrat.unite.immeuble ? contrat.unite.immeuble.nom : 'Non défini'}"
                                                                    data-unite="${not empty contrat.unite ? contrat.unite.numeroUnite : 'N/A'}">
                                                                <i class="fas fa-hand-pointer mr-2"></i>Sélectionner
                                                            </button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-16">
                                        <div class="w-24 h-24 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-6">
                                            <i class="fas fa-file-contract text-4xl text-gray-400"></i>
                                        </div>
                                        <h3 class="text-2xl font-semibold text-gray-900 mb-4">Aucun contrat actif</h3>
                                        <p class="text-gray-600">Vous n'avez pas de contrat de location actif.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <!-- Formulaire de paiement -->
                <div class="lg:col-span-1">
                    <div class="bg-white rounded-2xl shadow-lg border border-gray-100 overflow-hidden">
                        <div class="bg-gradient-to-r from-purple-600 to-blue-600 text-white p-6">
                            <h2 class="text-xl font-bold flex items-center">
                                <i class="fas fa-payment mr-3"></i>
                                Effectuer un Paiement
                            </h2>
                        </div>

                        <div class="p-6">
                            <form id="paymentForm" action="paiements" method="post" class="space-y-6">
                                <input type="hidden" id="selectedContratId" name="contratId" value="">

                                <!-- Montant -->
                                <div>
                                    <label class="block text-sm font-semibold text-gray-700 mb-2">Montant à payer</label>
                                    <div class="relative">
                                        <input type="text" class="w-full px-4 py-3 border border-gray-200 rounded-xl text-xl font-bold text-gray-900 bg-gray-50 focus:bg-white focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200"
                                               id="montant" placeholder="Sélectionnez un contrat" readonly>
                                        <div class="absolute inset-y-0 right-0 flex items-center pr-4">
                                            <span class="text-gray-500 font-medium">FCFA</span>
                                        </div>
                                    </div>
                                    <input type="hidden" id="montantRaw" name="montant" value="">
                                </div>

                                <!-- Méthodes de paiement -->
                                <div>
                                    <label class="block text-sm font-semibold text-gray-700 mb-4">Choisir une méthode de paiement</label>
                                    <div class="grid grid-cols-2 gap-3">
                                        <!-- Orange Money -->
                                        <div class="payment-method-card border border-gray-200 rounded-xl p-4 text-center hover:border-orange-500 hover:bg-orange-50 transition-all duration-200 cursor-pointer"
                                             data-method="orange_money">
                                            <div class="text-orange-500 mb-2">
                                                <i class="fas fa-mobile-alt text-2xl"></i>
                                            </div>
                                            <h6 class="font-medium text-gray-900">Orange Money</h6>
                                        </div>

                                        <!-- Wave -->
                                        <div class="payment-method-card border border-gray-200 rounded-xl p-4 text-center hover:border-blue-500 hover:bg-blue-50 transition-all duration-200 cursor-pointer"
                                             data-method="wave">
                                            <div class="text-blue-500 mb-2">
                                                <i class="fas fa-water text-2xl"></i>
                                            </div>
                                            <h6 class="font-medium text-gray-900">Wave</h6>
                                        </div>

                                        <!-- Free Money -->
                                        <div class="payment-method-card border border-gray-200 rounded-xl p-4 text-center hover:border-cyan-500 hover:bg-cyan-50 transition-all duration-200 cursor-pointer"
                                             data-method="free_money">
                                            <div class="text-cyan-500 mb-2">
                                                <i class="fas fa-mobile text-2xl"></i>
                                            </div>
                                            <h6 class="font-medium text-gray-900">Free Money</h6>
                                        </div>

                                        <!-- Carte Bancaire -->
                                        <div class="payment-method-card border border-gray-200 rounded-xl p-4 text-center hover:border-green-500 hover:bg-green-50 transition-all duration-200 cursor-pointer"
                                             data-method="carte_bancaire">
                                            <div class="text-green-500 mb-2">
                                                <i class="fas fa-credit-card text-2xl"></i>
                                            </div>
                                            <h6 class="font-medium text-gray-900">Carte Bancaire</h6>
                                        </div>
                                    </div>
                                </div>

                                <input type="hidden" id="paymentMethod" name="paymentMethod" value="">

                                <!-- Champs Mobile Money -->
                                <div id="mobileMoneyFields" class="hidden">
                                    <label class="block text-sm font-semibold text-gray-700 mb-2">Numéro de téléphone</label>
                                    <input type="tel" class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200"
                                           id="telephone" name="telephone" placeholder="77 123 45 67">
                                </div>

                                <!-- Champs Carte Bancaire -->
                                <div id="cardFields" class="hidden space-y-4">
                                    <div>
                                        <label class="block text-sm font-semibold text-gray-700 mb-2">Numéro de carte</label>
                                        <input type="text" class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200"
                                               id="cardNumber" name="cardNumber" placeholder="1234 5678 9012 3456" maxlength="19">
                                    </div>
                                    <div class="grid grid-cols-2 gap-4">
                                        <div>
                                            <label class="block text-sm font-semibold text-gray-700 mb-2">Expiration</label>
                                            <input type="text" class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200"
                                                   id="expiryDate" name="expiryDate" placeholder="MM/AA" maxlength="5">
                                        </div>
                                        <div>
                                            <label class="block text-sm font-semibold text-gray-700 mb-2">CVV</label>
                                            <input type="text" class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200"
                                                   id="cvv" name="cvv" placeholder="123" maxlength="3">
                                        </div>
                                    </div>
                                </div>

                                <!-- Bouton de paiement -->
                                <div class="pt-4">
                                    <button type="submit"
                                            class="w-full px-6 py-4 bg-gradient-to-r from-green-600 to-green-700 hover:from-green-700 hover:to-green-800 disabled:from-gray-300 disabled:to-gray-400 text-white font-bold rounded-xl transition-all duration-200 transform hover:scale-105 disabled:transform-none disabled:cursor-not-allowed shadow-lg hover:shadow-xl"
                                            id="payButton" disabled>
                                        <i class="fas fa-lock mr-2"></i>
                                        Payer Maintenant
                                    </button>
                                </div>

                                <!-- Information sécurité -->
                                <div class="text-center pt-2">
                                    <div class="flex items-center justify-center text-sm text-gray-500">
                                        <i class="fas fa-shield-alt mr-2"></i>
                                        Paiement sécurisé SSL 256-bit
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Historique récent -->
                    <div class="mt-8 bg-white rounded-2xl shadow-lg border border-gray-100 overflow-hidden">
                        <div class="bg-gradient-to-r from-gray-800 to-gray-900 text-white p-6">
                            <h3 class="text-lg font-bold flex items-center">
                                <i class="fas fa-history mr-3"></i>
                                Derniers Paiements
                            </h3>
                        </div>
                        <div class="p-6">
                            <c:choose>
                                <c:when test="${not empty historiquesPaiements}">
                                    <div class="space-y-4">
                                        <c:forEach var="paiement" items="${historiquesPaiements}" varStatus="status">
                                            <div class="flex items-center justify-between p-4 bg-gray-50 rounded-xl">
                                                <div>
                                                    <div class="font-semibold text-gray-900">Contrat #${paiement.contrat.id}</div>
                                                    <div class="text-sm text-gray-500">${paiement.datePaiement}</div>
                                                    <div class="text-xs text-gray-400">${paiement.methodePaiement}</div>
                                                </div>
                                                <div class="text-right">
                                                    <div class="text-lg font-bold text-green-600">
                                                        <fmt:formatNumber value="${paiement.montant}" type="number" groupingUsed="true" /> FCFA
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-8">
                                        <div class="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4">
                                            <i class="fas fa-receipt text-2xl text-gray-400"></i>
                                        </div>
                                        <p class="text-gray-500">Aucun paiement effectué</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal de confirmation -->
<div id="confirmationModal" class="fixed inset-0 backdrop-blur-md z-50 hidden flex items-center justify-center p-4">
    <div class="bg-white bg-opacity-95 backdrop-blur-sm rounded-3xl max-w-md w-full shadow-2xl border border-gray-100 transform scale-95 opacity-0 transition-all duration-300">
        <div class="bg-gradient-to-r from-green-600 to-green-700 text-white p-6 rounded-t-3xl">
            <div class="flex items-center justify-center">
                <h3 class="text-xl font-bold flex items-center">
                    <i class="fas fa-check-circle mr-3"></i>
                    Paiement en cours...
                </h3>
            </div>
        </div>

        <div class="p-8 text-center">
            <div class="w-16 h-16 border-4 border-green-200 border-t-green-600 rounded-full animate-spin mx-auto mb-6"></div>
            <h5 class="text-xl font-semibold text-gray-900 mb-4">Traitement de votre paiement</h5>
            <p class="text-gray-600 mb-6">Veuillez patienter pendant que nous traitons votre transaction.</p>
            <div id="paymentSummary" class="bg-gray-50 rounded-xl p-4"></div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const contractCards = document.querySelectorAll('.select-contract');
        const paymentMethods = document.querySelectorAll('.payment-method-card');
        const paymentForm = document.getElementById('paymentForm');
        const payButton = document.getElementById('payButton');

        // Sélection du contrat
        contractCards.forEach(card => {
            card.addEventListener('click', function() {
                const contratId = this.getAttribute('data-contrat-id');
                const montant = parseFloat(this.getAttribute('data-montant'));

                document.getElementById('selectedContratId').value = contratId;

                if (montant && montant > 0) {
                    const montantFormate = new Intl.NumberFormat('fr-FR').format(montant);
                    document.getElementById('montant').value = montantFormate;
                    document.getElementById('montantRaw').value = montant;
                } else {
                    document.getElementById('montant').value = '0';
                    document.getElementById('montantRaw').value = '0';
                }

                // Marquer visuellement
                document.querySelectorAll('.contract-card').forEach(c => {
                    c.classList.remove('border-blue-500', 'bg-blue-50');
                });
                this.closest('.contract-card').classList.add('border-blue-500', 'bg-blue-50');

                checkFormValidity();
            });
        });

        // Sélection de la méthode de paiement
        paymentMethods.forEach(method => {
            method.addEventListener('click', function() {
                paymentMethods.forEach(m => m.classList.remove('border-blue-500', 'bg-blue-50'));
                this.classList.add('border-blue-500', 'bg-blue-50');

                const methodType = this.getAttribute('data-method');
                document.getElementById('paymentMethod').value = methodType;

                const mobileFields = document.getElementById('mobileMoneyFields');
                const cardFields = document.getElementById('cardFields');

                if (methodType === 'carte_bancaire') {
                    mobileFields.classList.add('hidden');
                    cardFields.classList.remove('hidden');
                    document.getElementById('cardNumber').required = true;
                    document.getElementById('expiryDate').required = true;
                    document.getElementById('cvv').required = true;
                    document.getElementById('telephone').required = false;
                } else {
                    mobileFields.classList.remove('hidden');
                    cardFields.classList.add('hidden');
                    document.getElementById('telephone').required = true;
                    document.getElementById('cardNumber').required = false;
                    document.getElementById('expiryDate').required = false;
                    document.getElementById('cvv').required = false;
                }

                checkFormValidity();
            });
        });

        // Formatage des champs
        document.getElementById('cardNumber').addEventListener('input', function(e) {
            let x = e.target.value.replace(/\s+/g, '').replace(/[^0-9]/gi, '');
            let formattedInputValue = x.match(/.{1,4}/g)?.join(' ') || x;
            e.target.value = formattedInputValue;
        });

        document.getElementById('expiryDate').addEventListener('input', function(e) {
            let x = e.target.value.replace(/\D/g, '');
            if (x.length >= 2) {
                x = x.substring(0, 2) + '/' + x.substring(2, 4);
            }
            e.target.value = x;
        });

        document.getElementById('cvv').addEventListener('input', function(e) {
            e.target.value = e.target.value.replace(/\D/g, '');
        });

        // Formatage du téléphone
        document.getElementById('telephone').addEventListener('input', function(e) {
            let x = e.target.value.replace(/\D/g, '');
            if (x.length >= 2) {
                x = x.substring(0, 2) + ' ' + x.substring(2, 5) + ' ' + x.substring(5, 7) + ' ' + x.substring(7, 9);
            }
            e.target.value = x.trim();
        });

        // Vérifier la validité du formulaire
        function checkFormValidity() {
            const contratSelected = document.getElementById('selectedContratId').value !== '';
            const methodSelected = document.getElementById('paymentMethod').value !== '';

            let fieldsValid = false;
            const method = document.getElementById('paymentMethod').value;

            if (method === 'carte_bancaire') {
                const cardNumber = document.getElementById('cardNumber').value.replace(/\s/g, '');
                const expiryDate = document.getElementById('expiryDate').value;
                const cvv = document.getElementById('cvv').value;
                fieldsValid = cardNumber.length >= 16 && expiryDate.length === 5 && cvv.length >= 3;
            } else if (method && method !== '') {
                const telephone = document.getElementById('telephone').value.replace(/\s/g, '');
                fieldsValid = telephone.length >= 9;
            }

            payButton.disabled = !(contratSelected && methodSelected && fieldsValid);
        }

        // Écouter les changements dans les champs
        document.querySelectorAll('input').forEach(input => {
            input.addEventListener('input', checkFormValidity);
        });

        // Soumission du formulaire
        paymentForm.addEventListener('submit', function(e) {
            e.preventDefault();

            // Afficher le modal de confirmation
            const modal = document.getElementById('confirmationModal');
            const modalContent = modal.querySelector('.bg-white');

            // Préparer le résumé
            const contratId = document.getElementById('selectedContratId').value;
            const montantDisplay = document.getElementById('montant').value;
            const montantRaw = document.getElementById('montantRaw').value;
            const method = document.getElementById('paymentMethod').value;

            document.getElementById('montantRaw').value = montantRaw;

            document.getElementById('paymentSummary').innerHTML = `
                <div class="text-left space-y-2">
                    <div class="flex justify-between">
                        <span class="font-medium text-gray-700">Contrat:</span>
                        <span class="text-gray-900">#${contratId}</span>
                    </div>
                    <div class="flex justify-between">
                        <span class="font-medium text-gray-700">Montant:</span>
                        <span class="text-gray-900 font-bold">${montantDisplay} FCFA</span>
                    </div>
                    <div class="flex justify-between">
                        <span class="font-medium text-gray-700">Méthode:</span>
                        <span class="text-gray-900">${method.replace('_', ' ').toUpperCase()}</span>
                    </div>
                </div>
            `;

            // Afficher le modal
            modal.classList.remove('hidden');
            document.body.style.overflow = 'hidden';

            requestAnimationFrame(() => {
                requestAnimationFrame(() => {
                    modalContent.classList.remove('scale-95', 'opacity-0');
                    modalContent.classList.add('scale-100', 'opacity-100');
                });
            });

            // Simuler le traitement
            setTimeout(() => {
                // Cacher le modal
                modalContent.classList.remove('scale-100', 'opacity-100');
                modalContent.classList.add('scale-95', 'opacity-0');

                setTimeout(() => {
                    modal.classList.add('hidden');
                    document.body.style.overflow = 'auto';
                    this.submit(); // Soumettre le formulaire
                }, 300);
            }, 3000);
        });

        // Auto-masquage des alertes
        setTimeout(() => {
            const alerts = document.querySelectorAll('.animate-slide-up');
            alerts.forEach(alert => {
                if (alert.parentNode) {
                    alert.style.opacity = '0';
                    alert.style.transform = 'translateY(-20px)';
                    setTimeout(() => {
                        if (alert.parentNode) {
                            alert.remove();
                        }
                    }, 300);
                }
            });
        }, 5000);

        // Animation d'apparition au chargement
        const animatedElements = document.querySelectorAll('.animate-fade-in, .animate-slide-up');
        animatedElements.forEach((element, index) => {
            element.style.opacity = '0';
            element.style.transform = 'translateY(20px)';

            setTimeout(() => {
                element.style.transition = 'all 0.6s ease-out';
                element.style.opacity = '1';
                element.style.transform = 'translateY(0)';
            }, index * 100);
        });
    });

    // Fermer le modal en cliquant à l'extérieur
    document.addEventListener('click', function(e) {
        const modal = document.getElementById('confirmationModal');
        if (e.target === modal) {
            const modalContent = modal.querySelector('.bg-white');
            modalContent.classList.remove('scale-100', 'opacity-100');
            modalContent.classList.add('scale-95', 'opacity-0');

            setTimeout(() => {
                modal.classList.add('hidden');
                document.body.style.overflow = 'auto';
            }, 300);
        }
    });

    // Fermer avec la touche Escape
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            const modal = document.getElementById('confirmationModal');
            if (!modal.classList.contains('hidden')) {
                const modalContent = modal.querySelector('.bg-white');
                modalContent.classList.remove('scale-100', 'opacity-100');
                modalContent.classList.add('scale-95', 'opacity-0');

                setTimeout(() => {
                    modal.classList.add('hidden');
                    document.body.style.overflow = 'auto';
                }, 300);
            }
        }
    });
</script>

</body>
</html>