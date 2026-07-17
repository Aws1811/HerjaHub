<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order Confirmation</title>
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


<p>(checkmark placeholder)</p>
<h1>Order Placed Successfully!</h1>

<%-- add up the order's total from its order items --%>
<c:set var="orderTotal" value="0" />
<c:forEach var="item" items="${order.orderItems}">
    <c:set var="orderTotal" value="${orderTotal + (item.price * item.quantity)}" />
</c:forEach>

<table border="1">
    <tr>
        <td>Order #</td>
        <td><c:out value="${order.id}" /></td>
    </tr>
    <tr>
        <td>Date</td>
        <td><c:out value="${order.createdAt}" /></td>
    </tr>
    <tr>
        <td>Total</td>
        <td>$<c:out value="${orderTotal}" /></td>
    </tr>
</table>

<a href="/customer/orders">View My Orders</a>
<br>
<a href="/customer/products">Continue Shopping</a>

</body>
</html>
