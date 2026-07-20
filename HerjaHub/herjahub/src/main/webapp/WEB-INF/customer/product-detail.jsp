<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Product Details</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/productsdetails_style.css">
</head>
<body>

<%-- ===== Testing nav: quick links to every customer page ===== --%>
<div class="test-nav">
    <a href="${pageContext.request.contextPath}/customer/dashboard">Dashboard</a> |
    <a href="${pageContext.request.contextPath}/customer/products">Products</a> |
    <a href="${pageContext.request.contextPath}/customer/products/1">Product Details</a> |
    <a href="${pageContext.request.contextPath}/customer/cart">Cart</a> |
    <a href="${pageContext.request.contextPath}/customer/orders">My Orders</a> |
    <a href="${pageContext.request.contextPath}/customer/orders/1/confirmation">Order Confirmation</a> |
    <a href="${pageContext.request.contextPath}/customer/profile/edit">Edit Profile</a>
</div>
<hr>


<h1>Product Details</h1>

<%-- product image --%>
<c:choose>
    <c:when test="${empty product.image}">
        <p class="image-placeholder">(product image placeholder)</p>
    </c:when>
    <c:otherwise>
        <img class="product-image" src="${product.image}" alt="${product.productName}" width="250" />
    </c:otherwise>
</c:choose>

<h2 class="product-title"><c:out value="${product.productName}" /></h2>
<p class="description"><c:out value="${product.description}" /></p>
<p class="price">$ <c:out value="${product.price}" /></p>

<%-- Add to Cart form --%>
<form class="add-to-cart-form" action="${pageContext.request.contextPath}/customer/cart/add/${product.id}" method="post">
    <label>Quantity</label>
    <input type="number" name="quantity" value="1" min="1" />
    <input type="submit" value="Add to Cart" />
</form>

<hr>

<%-- ===== Reviews. CustomerProductController passes:
     - comments: List<CommentDTO> (already sorted newest first)
     - avgRating / reviewCount: shown at the top of this section
     - reviewForm: bound to the form below (rating + comment text) ===== --%>
<h3>Reviews</h3>

<c:if test="${reviewCount > 0}">
    <p class="rating-summary">
        Average rating:
        <fmt:formatNumber value="${avgRating}" maxFractionDigits="1" />
        (<c:out value="${reviewCount}" /> reviews)
    </p>
</c:if>

<c:choose>
    <c:when test="${empty comments}">
        <p class="muted">No reviews yet.</p>
    </c:when>
    <c:otherwise>
        <c:forEach var="existingComment" items="${comments}">
            <p class="comment-line">
                <strong><c:out value="${existingComment.customerName}" /></strong>
                <c:if test="${not empty existingComment.rating}">
                    - <c:out value="${existingComment.rating}" />/5
                </c:if>
                - <c:out value="${existingComment.comment}" />
            </p>
        </c:forEach>
    </c:otherwise>
</c:choose>

<h3>Leave a Review</h3>

<c:if test="${not empty errorMessage}">
    <p class="error-text"><c:out value="${errorMessage}" /></p>
</c:if>

<form:form action="${pageContext.request.contextPath}/customer/products/${product.id}/reviews" method="post" modelAttribute="reviewForm">

    <form:label path="rating">Rating (1-5)</form:label>
    <form:input path="rating" type="number" min="1" max="5" />
    <form:errors path="rating" cssClass="error-text" />

    <form:label path="comment">Review</form:label>
    <form:textarea path="comment" />
    <form:errors path="comment" cssClass="error-text" />

    <input type="submit" value="Post Review" />
</form:form>

</body>
</html>
