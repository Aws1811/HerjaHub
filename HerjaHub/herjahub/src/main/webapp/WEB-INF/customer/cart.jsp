<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cart</title>
</head>
<body>

<%-- ===== Testing nav: quick links to every customer page ===== --%>
<div>
    <a href="${pageContext.request.contextPath}/customer/dashboard">Dashboard</a> |
    <a href="${pageContext.request.contextPath}/customer/products">Products</a> |
    <a href="${pageContext.request.contextPath}/customer/products/1">Product Details</a> |
    <a href="${pageContext.request.contextPath}/customer/cart">Cart</a> |
    <a href="${pageContext.request.contextPath}/customer/orders">My Orders</a> |
    <a href="${pageContext.request.contextPath}/customer/orders/1/confirmation">Order Confirmation</a> |
    <a href="${pageContext.request.contextPath}/customer/profile/edit">Edit Profile</a>
</div>
<hr>


<h1>Cart</h1>

<c:choose>
    <c:when test="${empty cartItems}">
        <p>Your cart is empty.</p>
    </c:when>
    <c:otherwise>
        <c:forEach var="item" items="${cartItems}">
            <div>
                <c:choose>
                    <c:when test="${empty item.product.image}">
                        <p>(img)</p>
                    </c:when>
                    <c:otherwise>
                        <img src="${item.product.image}" alt="${item.product.productName}" width="60" />
                    </c:otherwise>
                </c:choose>

                <c:out value="${item.product.productName}" />
                &nbsp;-&nbsp; Qty: <c:out value="${item.quantity}" />
                &nbsp;-&nbsp; $<c:out value="${item.subtotal}" />
            </div>
        </c:forEach>

        <form action="/customer/cart/checkout" method="post">
            <input type="submit" value="Go to Orders" />
        </form>
    </c:otherwise>
</c:choose>

</body>
</html>
