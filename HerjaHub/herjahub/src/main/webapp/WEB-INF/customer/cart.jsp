<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cart</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/cart_style.css">
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

<h1>Cart</h1>

<c:choose>
    <c:when test="${empty cartItems}">
        <p class="muted">Your cart is empty.</p>
    </c:when>
    <c:otherwise>
        <c:forEach var="item" items="${cartItems}">
            <div class="cart-line">
                <c:choose>
                    <c:when test="${empty item.product.image}">
                        <div class="image-placeholder">img</div>
                    </c:when>
                    <c:otherwise>
                        <img src="${item.product.image}" alt="${item.product.productName}" width="60" />
                    </c:otherwise>
                </c:choose>

                <span class="cart-name"><c:out value="${item.product.productName}" /></span>
                <span class="cart-qty">Qty: <c:out value="${item.quantity}" /></span>
                <span class="cart-subtotal">$<c:out value="${item.subtotal}" /></span>
            </div>
        </c:forEach>

        <form action="${pageContext.request.contextPath}/customer/cart/checkout" method="post">
            <input type="submit" value="Go to Orders" />
        </form>
    </c:otherwise>
</c:choose>

</body>
</html>
