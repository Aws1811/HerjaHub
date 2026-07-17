<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Profile</title>
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


<h1>Edit Profile</h1>

<%-- Note: Customer has no "image" field yet, so this is just a placeholder for now --%>
<p>(profile photo placeholder)</p>

<form:form action="/customer/profile/edit" method="post" modelAttribute="editProfileForm">

    <form:label path="firstName">First Name</form:label>
    <form:input path="firstName" />
    <form:errors path="firstName" />

    <form:label path="lastName">Last Name</form:label>
    <form:input path="lastName" />
    <form:errors path="lastName" />

    <form:label path="email">Email</form:label>
    <form:input path="email" />
    <form:errors path="email" />

    <form:label path="newPassword">New Password</form:label>
    <form:password path="newPassword" />
    <form:errors path="newPassword" />

    <input type="submit" value="Save Changes" />
</form:form>

</body>
</html>
