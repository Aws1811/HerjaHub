<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Orders</title>
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


<h1>My Orders</h1>

<c:choose>
    <c:when test="${empty orders}">
        <p>You haven't placed any orders yet.</p>
    </c:when>
    <c:otherwise>
        <c:forEach var="order" items="${orders}">
            <%-- add up this order's total from its order items --%>
            <c:set var="orderTotal" value="0" />
            <c:forEach var="item" items="${order.orderItems}">
                <c:set var="orderTotal" value="${orderTotal + (item.price * item.quantity)}" />
            </c:forEach>

            <div>
                <strong>Order #<c:out value="${order.id}" /></strong>
                <br>
                Placed on <c:out value="${order.createdAt}" />

                <%-- Note: there is no status field on Order yet - placeholder for now --%>
                &nbsp;-&nbsp; Status: (pending / in progress / completed - coming soon)

                &nbsp;-&nbsp; Total: $<c:out value="${orderTotal}" />

                <a href="/customer/orders/${order.id}/confirmation">View</a>
            </div>
        </c:forEach>
    </c:otherwise>
</c:choose>

</body>
</html>
