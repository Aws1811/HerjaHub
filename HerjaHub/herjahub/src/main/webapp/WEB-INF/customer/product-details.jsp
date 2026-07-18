<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
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
<form class="add-to-cart-form" action="/customer/cart/add/${product.id}" method="post">
    <label>Quantity</label>
    <input type="number" name="quantity" value="1" min="1" />
    <input type="submit" value="Add to Cart" />
</form>

<hr>

<h3>Comments</h3>

<c:choose>
    <c:when test="${empty product.comments}">
        <p class="muted">No comments yet.</p>
    </c:when>
    <c:otherwise>
        <c:forEach var="comment" items="${product.comments}">
            <p class="comment-line">
                <strong><c:out value="${comment.customer.firstName}" /></strong> -
                <c:out value="${comment.comment}" />
            </p>
        </c:forEach>
    </c:otherwise>
</c:choose>

<%-- Note: writing a new comment isn't wired up yet - the Comment model still
     requires a rating, and the rating feature is planned for later. --%>
<p class="muted">(write a comment - coming soon)</p>

</body>
</html>
